import 'package:get/get.dart';
import 'package:salon_user/app/controller/notification_controller.dart';

class NotificationtBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => NotificationController(parser: Get.find()),
    );
  }
}
