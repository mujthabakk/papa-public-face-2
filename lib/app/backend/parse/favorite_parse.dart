/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

class FavoritesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FavoritesParser(
      {required this.apiService, required this.sharedPreferencesManager});
}
