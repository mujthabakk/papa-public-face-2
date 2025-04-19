import 'package:get/get.dart';
import 'package:salon_user/app/controller/category_search_controller.dart';
import 'package:salon_user/app/controller/new_category_search_controller.dart';

class NewCatSearchCBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CategorySearchController(parser: Get.find()),
    );
  }
}
