/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/intro_parse.dart';
import 'package:salon_user/app/helper/router.dart';

class IntroController extends GetxController implements GetxService {
  final IntroParser parser;
  IntroController({required this.parser});

  void onSkip() {
    parser.saveWelcome(true);
    Get.offNamed(AppRouter.getChooseLocationRoutes());
  }

  void onGetStarted() {
    parser.saveWelcome(true);
    Get.offNamed(AppRouter.getChooseLocationRoutes());
  }

  void saveLanguage(String code) {
    parser.saveLanguage(code);
    update();
  }
}
