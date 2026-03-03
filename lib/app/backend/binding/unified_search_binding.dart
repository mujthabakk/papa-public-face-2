import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';

class UnifiedSearchBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => UnifiedSearchController(parser: Get.find()),
    );
  }
}
