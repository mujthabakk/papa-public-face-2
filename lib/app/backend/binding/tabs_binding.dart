import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TabsController(parser: Get.find()));
    Get.lazyPut(() => HomeController(parser: Get.find()));
    Get.put(CategoriesController(parser: Get.find()), permanent: true);
    Get.lazyPut(() => NearController(parser: Get.find()));
    Get.lazyPut(() => BookingController(parser: Get.find()));
    Get.lazyPut(() => AccountController(parser: Get.find()));
  }
}
