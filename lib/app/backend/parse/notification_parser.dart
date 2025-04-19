import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

class NotificationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NotificationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  void saveLanguage(String code) {
    sharedPreferencesManager.putString('language', code);
  }
}
