import 'package:get/get.dart';
import 'package:salon_user/app/controller/timed_offer_controller.dart';

class TimedOfferBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => TimedOfferController(parser: Get.find()),
    );
  }
}
