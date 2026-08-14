/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/sortby_controller.dart';

class SortByBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => SortByController(parser: Get.find()),
    );
  }
}
