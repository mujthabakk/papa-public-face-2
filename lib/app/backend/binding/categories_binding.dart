import 'package:get/get.dart';
import 'package:salon_user/app/controller/categories_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CategoriesController(parser: Get.find()),
    );
  }
}
