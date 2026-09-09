import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/service_cart_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/parse/checkout_parse.dart';
import 'package:salon_user/app/backend/parse/coupon_parse.dart';
import 'package:salon_user/app/backend/parse/pricing_parse.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/slot_controller.dart';
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
  bool pricingLoading = false;

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
    super.onInit();
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
    ])?.then((_) => _syncCouponLabel());
  }

  Future<void> applyCouponByCode(String code) async {
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      showToast('Please enter a coupon code.');
      return;
    }
    if (!Get.isRegistered<CouponParser>()) {
      showToast('Coupons are unavailable right now.');
      return;
    }
    final couponParser = Get.find<CouponParser>();
    final response = await couponParser.getCouponCodes();
    if (response.statusCode != 200) {
      showToast('Unable to load coupons. Please try again.');
      return;
    }
    final cart = Get.find<ServiceCartController>();
    final list = ApiBody.asList(response.body);
    CouponsModel? matched;
    for (final item in list) {
      final coupon = CouponsModel.tryParse(item);
      if (coupon == null) continue;
      final couponCode = (coupon.code ?? '').trim().toLowerCase();
      if (couponCode == trimmed.toLowerCase()) {
        matched = coupon;
        break;
      }
    }
    if (matched == null) {
      showToast('Invalid coupon code.');
      return;
    }
    if (cart.totalPrice < (matched.minCartValue ?? 0)) {
      showToast(
          'Minimum cart value is ₹${matched.minCartValue!.toStringAsFixed(0)}.');
      return;
    }
    cart.onSaveCoupon(matched);
    _syncCouponLabel();
    refreshPricingFromApi();
    showToast('Coupon applied successfully.');
    update();
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
    refreshPricingFromApi();
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
    final discount = _couponDiscountAmount(cart);
    final servicesAmount = cart.totalPrice + cart.serviceChargeAmount;

    final result = await Get.find<PricingParser>().calculateAppointment(
      servicesAmount: servicesAmount,
      discount: discount,
    );

    pricingLoading = false;
    if (result.success && result.data != null) {
      final data = result.data!;
      taxAmount = data.serviceTax;
      taxableValue = data.taxableValue;
      grandTotal = data.grandTotal;
    } else {
      _applyLocalPricingFallback();
    }
    update();
  }

  double _couponDiscountAmount(ServiceCartController cart) {
    final coupon = cart.selectedCoupon;
    if ((coupon.discount ?? 0) <= 0) return 0;
    var amount = cart.totalPrice * (coupon.discount! / 100);
    if (coupon.upto != null && amount > coupon.upto!) {
      amount = coupon.upto!;
    }
    return amount;
  }

  void _applyLocalPricingFallback() {
    final cart = Get.find<ServiceCartController>();
    grandTotal = cart.grandTotal - _couponDiscountAmount(cart);
    taxAmount = 0;
    taxableValue = grandTotal;
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
