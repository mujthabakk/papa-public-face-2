/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class NearParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NearParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Map<String, dynamic> listingPayload([dynamic extra]) {
    final payload = extra is Map
        ? Map<String, dynamic>.from(extra)
        : <String, dynamic>{};
    payload['lat'] = payload['lat'] ?? getLat();
    payload['lng'] = payload['lng'] ?? getLng();
    final country = sharedPreferencesManager
            .getString(LocaleHelper.prefCountryName) ??
        sharedPreferencesManager.getString(LocaleHelper.prefCountry) ??
        '';
    if (country.isNotEmpty) {
      payload['country'] = payload['country'] ?? country;
    }
    final cityId = sharedPreferencesManager.getInt('city_id') ?? 0;
    if (cityId > 0) {
      payload['city_id'] = payload['city_id'] ?? cityId;
    }
    final uid = sharedPreferencesManager.getString('uid');
    if (uid != null && uid.isNotEmpty && uid != '0') {
      payload['uid'] = payload['uid'] ?? int.tryParse(uid) ?? uid;
    }
    return payload;
  }

  Future<Response> getHomeData(var body) async {
    return apiService.postPublic(
        AppConstants.getHomeData, listingPayload(body));
  }

  Future<Response> getTopSalon(var body) {
    return apiService.postPublic(
        AppConstants.getTopSalon, listingPayload(body));
  }

  Future<Response> getTopFreelancer(var body) {
    return apiService.postPublic(
        AppConstants.getTopFreelancer, listingPayload(body));
  }

  Future<Response> getSalonDetails(var body) {
    return apiService.postPublic(AppConstants.salonDetails, body);
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
