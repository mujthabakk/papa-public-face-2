/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

class WelcomeParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  WelcomeParser(
      {required this.apiService, required this.sharedPreferencesManager});
}
