/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => RegisterController(parser: Get.find()),
    );
  }
}
