/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';

class RescheduleSlotBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => RescheduleSlotController(parser: Get.find()),
    );
  }
}
