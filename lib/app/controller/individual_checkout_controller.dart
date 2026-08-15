import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/service_cart_model.dart';
import 'package:salon_user/app/backend/parse/individual_checkout_parse.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/individual_payment_controller.dart';
import 'package:salon_user/app/controller/individual_slot_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/facebook_service.dart';
import 'package:salon_user/app/util/toast.dart';

class IndividualCheckoutController extends GetxController
    implements GetxService {
  final IndividualCheckoutParser parser;

  bool isChecked = false;

  ServiceCartModel _savedInCart = ServiceCartModel();
  ServiceCartModel get savedInCart => _savedInCart;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  IndividualCheckoutController({required this.parser});

  @override
  void onInit() {
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    FacebookService.logInitiatedCheckout(
      totalPrice: Get.find<ServiceCartController>().totalPrice,
      currency: AppConstants.defaultCurrencySymbol,
      numItems: Get.find<ServiceCartController>().totalItemsInCart,
    );
    super.onInit();
  }

  void onCoupon() {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes());
  }

  void onSlot() {
    if (parser.isLogin() != true) {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
      return;
    }

    String savedDate = '';
    String selectedSlot = '';
    DateTime selectedDay = DateTime.now();

    if (Get.isRegistered<SpecialistController>()) {
      final spec = Get.find<SpecialistController>();
      savedDate = spec.savedDate;
      selectedSlot = spec.selectedSlotIndex;
      selectedDay = spec.selectedDay;
    }

    if (selectedSlot.isEmpty) {
      showToast('Please select Slots'.tr);
      return;
    }

    Get.delete<IndividualSlotController>(force: true);
    final slotCtrl = Get.put(IndividualSlotController(parser: Get.find()));
    slotCtrl.savedDate = savedDate;
    slotCtrl.selectedSlotIndex = selectedSlot;
    slotCtrl.selectedValue = selectedDay;

    Get.delete<IndividualPaymentController>(force: true);
    Get.toNamed(AppRouter.getIndividualPayment());
  }

  void deleteServiceFromCart(int index) {
    Get.find<ServiceCartController>()
        .removeServiceFromCart(_savedInCart.services![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    update();
  }

  void deletePackageFromCart(int index) {
    Get.find<ServiceCartController>()
        .removePackageFromCart(_savedInCart.packages![index].id as int);
    _savedInCart = Get.find<ServiceCartController>().savedInCart;
    update();
  }
}
