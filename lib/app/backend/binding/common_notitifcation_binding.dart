import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/common_notification_controller.dart';

class CommonNotificationPageBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CommonNotificationController>()) {
      Get.put(
        CommonNotificationController(parser: Get.find()),
        permanent: true,
      );
      return;
    }
    // Never call update()/refresh during route binding (build phase).
    final ctrl = Get.find<CommonNotificationController>();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ctrl.isClosed) {
        ctrl.refreshNotifications();
      }
    });
  }
}
