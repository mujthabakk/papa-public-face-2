/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/controller/languages_controller.dart';

class LanguagesBinding extends Bindings {
  @override
  void dependencies() async {
    if (!Get.isRegistered<LanguagesController>()) {
      Get.put(LanguagesController(parser: Get.find()), permanent: true);
    }
  }
}
