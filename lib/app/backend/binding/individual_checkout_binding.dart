/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';

class IndividualCheckoutBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => IndividualCheckoutController(parser: Get.find()),
    );
  }
}
