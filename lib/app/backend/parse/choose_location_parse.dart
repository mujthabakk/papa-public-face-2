import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

class ChooseLocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ChooseLocationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  void saveLatLng(var lat, var lng, var address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
  }

  void saveLanguage(String code) {
    sharedPreferencesManager.putString('language', code);
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }

  String getAddress() {
    return sharedPreferencesManager.getString('address') ?? '';
  }
}
