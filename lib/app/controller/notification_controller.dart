import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/notification_parser.dart';
import 'package:salon_user/app/helper/router.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationParser parser;
  NotificationController({required this.parser});

  void onSkip() {
    Get.toNamed(AppRouter.getNotificatinRoutes(), arguments: ['']);
  }

  void saveLanguage(String code) {
    parser.saveLanguage(code);
    update();
  }
}
