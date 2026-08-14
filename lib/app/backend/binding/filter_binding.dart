/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/filter_controller.dart';

class FilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FilterController(parser: Get.find()),
      fenix: true,
    );
  }
}
