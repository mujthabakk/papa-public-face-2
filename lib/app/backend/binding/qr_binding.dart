import 'package:get/get.dart';
import 'package:salon_user/app/controller/intro_controller.dart';
import 'package:salon_user/app/controller/qr_controller.dart';

class QrBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => QRController(parser: Get.find()),
    );
  }
}
