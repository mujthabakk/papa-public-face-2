import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/common_notification_controller.dart';

class CommonNotificationPageBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => CommonNotificationController(parser: Get.find()),
    );
  }
}
