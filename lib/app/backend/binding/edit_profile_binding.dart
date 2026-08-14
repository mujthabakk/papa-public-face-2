/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/edit_profile_controller.dart';

class EditProfileBindings extends Bindings {
  @override
  void dependencies() async {
    Get.lazyPut(
      () => EditProfileController(parser: Get.find()),
    );
  }
}
