import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/service_cart_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/parse/checkout_parse.dart';
import 'package:salon_user/app/backend/parse/coupon_parse.dart';
import 'package:salon_user/app/backend/parse/pricing_parse.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/slot_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/facebook_service.dart';
import 'package:salon_user/app/util/toast.dart';

class CheckoutController extends GetxController implements GetxService {
  final CheckoutParser parser;

  bool isChecked = false;

  ServiceCartModel _savedInCart = ServiceCartModel();
  ServiceCartModel get savedInCart => _savedInCart;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  String appliedCouponLabel = '';
  double taxAmount = 0.0;
  double taxableValue = 0.0;
  double grandTotal = 0.0;
  double apiDiscount = 0.0;
  double apiServicesAmount = 0.0;
  bool pricingLoading = false;

  double get couponDiscount {
    if (apiDiscount > 0) return apiDiscount;
    if (!Get.isRegistered<ServiceCartController>()) return 0;
    return _couponDiscountAmount(Get.find<ServiceCartController>());
  }

  double get originalAmount {
    if (apiServicesAmount > 0) return apiServicesAmount;
    if (!Get.isRegistered<ServiceCartController>()) return 0;
    return Get.find<ServiceCartController>().totalPrice;
  }

  double get payAmount {
    if (grandTotal > 0) return grandTotal;
    if (!Get.isRegistered<ServiceCartController>()) return 0;
    final cart = Get.find<ServiceCartController>();
    return (cart.grandTotal - couponDiscount).clamp(0, double.infinity);
  }

  CheckoutController({required this.parser});

  @override
  void onInit() {
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    FacebookService.logInitiatedCheckout(
      totalPrice: Get.find<ServiceCartController>().totalPrice,
      currency: AppConstants.defaultCurrencySymbol,
      numItems: Get.find<ServiceCartController>().totalItemsInCart,
    );
    refreshPricingFromApi();
    _dropIneligibleFirstUserCoupon();
    super.onInit();
  }

  Future<void> _dropIneligibleFirstUserCoupon() async {
    if (!Get.isRegistered<ServiceCartController>() ||
        !Get.isRegistered<CouponParser>()) {
      return;
    }
    final cart = Get.find<ServiceCartController>();
    final coupon = cart.selectedCoupon;
    final code = (coupon.code ?? coupon.name ?? '').trim();
    if (code.isEmpty && (coupon.id ?? 0) <= 0) return;
    final couponParser = Get.find<CouponParser>();
    final eligible = await couponParser.loadEligibleOffers();
    final stillOk = eligible.any((item) =>
        ((coupon.id ?? 0) > 0 && item.id == coupon.id) ||
        (code.isNotEmpty && CouponsModel.matchesCode(item, code)));
    if (stillOk) return;
    if (!coupon.isFirstTimeUserOffer &&
        !(code.isNotEmpty &&
            await couponParser.isBlockedFirstUserOffer(code))) {
      return;
    }
    cart.onSaveCoupon(CouponsModel());
    _syncCouponLabel();
    showToast(CouponParser.firstUserOnlyMessage.tr);
    refreshPricingFromApi();
    update();
  }

  void onCoupon() {
    final cart = Get.find<ServiceCartController>();
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes(), arguments: [
      'service',
      '',
      '',
      cart.salonId.toString(),
      cart.totalPrice.toString(),
    ])?.then((_) {
      _syncCouponLabel();
      refreshPricingFromApi();
    });
  }

  Future<void> applyCouponByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      showToast('Please enter a coupon code.');
      return;
    }
    try {
      if (!Get.isRegistered<CouponParser>()) {
        showToast('Coupons are unavailable right now.');
        return;
      }
      final couponParser = Get.find<CouponParser>();
      final matched = await couponParser.findEligibleOffer(trimmed);
      if (matched == null) {
        if (await couponParser.isBlockedFirstUserOffer(trimmed)) {
          showToast(CouponParser.firstUserOnlyMessage.tr);
        } else {
          showToast('Invalid coupon code.');
        }
        return;
      }
      final cart = Get.find<ServiceCartController>();
      if (cart.totalPrice < (matched.minCartValue ?? 0)) {
        showToast(
            'Minimum cart value is ${AppCurrency.format(matched.minCartValue)}.');
        return;
      }
      cart.onSaveCoupon(matched);
      _syncCouponLabel();
      await refreshPricingFromApi();
      showToast('Coupon applied successfully.');
      update();
    } catch (e) {
      debugPrint('applyCouponByCode: $e');
      showToast('Unable to apply coupon. Please try again.');
    }
  }

  void removeCoupon() {
    Get.find<ServiceCartController>().onSaveCoupon(CouponsModel());
    appliedCouponLabel = '';
    refreshPricingFromApi();
    update();
  }

  void _syncCouponLabel() {
    final coupon = Get.find<ServiceCartController>().selectedCoupon;
    if ((coupon.code ?? '').isNotEmpty) {
      appliedCouponLabel = coupon.code!;
    } else if ((coupon.name ?? '').isNotEmpty) {
      appliedCouponLabel = coupon.name!;
    } else {
      appliedCouponLabel = '';
    }
    update();
  }

//Lat ----9.591566799999999
  void onSlot() {
    if (parser.isLogin() == true) {
      Get.delete<SlotController>(force: true);
      Get.toNamed(AppRouter.getSlotRoutes());
    } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
    }
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> refreshPricingFromApi() async {
    if (!Get.isRegistered<PricingParser>()) {
      _applyLocalPricingFallback();
      update();
      return;
    }

    pricingLoading = true;
    update();

    final cart = Get.find<ServiceCartController>();
    final discount = cart.couponDiscountAmount();
    final servicesAmount = cart.totalPrice + cart.serviceChargeAmount;

    final result = await Get.find<PricingParser>().calculateAppointment(
      servicesAmount: servicesAmount,
      discount: discount,
    );

    pricingLoading = false;
    if (result.success && result.data != null) {
      final data = result.data!;
      final couponOff = discount;
      taxAmount = data.serviceTax > 0 ? data.serviceTax : cart.taxAmount;
      taxableValue =
          data.taxableValue > 0 ? data.taxableValue : cart.taxableValue;
      apiServicesAmount = data.servicesAmount;
      if (couponOff <= 0 && data.discount > 0) {
        // Cart already uses offer price (off). Do not apply that discount again.
        apiDiscount = 0;
        grandTotal = data.grandTotal + data.discount;
      } else {
        apiDiscount = data.discount;
        grandTotal = data.grandTotal;
      }
      cart.applyApiPayAmount(grandTotal);
    } else {
      _applyLocalPricingFallback();
    }
    update();
  }

  double _couponDiscountAmount(ServiceCartController cart) {
    return cart.couponDiscountAmount();
  }

  void _applyLocalPricingFallback() {
    final cart = Get.find<ServiceCartController>();
    apiDiscount = _couponDiscountAmount(cart);
    apiServicesAmount = cart.totalPrice;
    grandTotal = cart.grandTotal - apiDiscount;
    cart.applyApiPayAmount(grandTotal);
    taxAmount = cart.taxAmount;
    taxableValue = cart.taxableValue > 0 ? cart.taxableValue : grandTotal;
  }

  void deleteServiceFromCart(int index) {
    debugPrint('deleteServiceFromCart');
    Get.find<ServiceCartController>()
        .removeServiceFromCart(_savedInCart.services![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    refreshPricingFromApi();
    update();
    checkCartItems();
  }

  void deletePackageFromCart(int index) {
    Get.find<ServiceCartController>()
        .removePackageFromCart(_savedInCart.packages![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    refreshPricingFromApi();
    update();
    if (_savedInCart.services!.isEmpty && _savedInCart.packages!.isEmpty) {
      Get.find<ServiceCartController>().clearCart();
      Get.find<ServiceCartController>().update();
    }
    checkCartItems();
  }

  void checkCartItems() {
    if (Get.find<ServiceCartController>().savedInCart.services!.isEmpty &&
        Get.find<ServiceCartController>().savedInCart.packages!.isEmpty) {
      var context = Get.context as BuildContext;
      Navigator.of(context).pop(true);
    }
  }
}
