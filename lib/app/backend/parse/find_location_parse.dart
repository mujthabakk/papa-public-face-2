/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class FindLocationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  FindLocationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getPlacesList(url) async {
    var response = await apiService.getOther(url);
    return response;
  }

  Future<Response> getHomeData(dynamic body) async {
    final payload =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    final uid = sharedPreferencesManager.getString('uid');
    if (uid != null && uid.isNotEmpty && uid != '0') {
      payload['uid'] = int.tryParse(uid) ?? uid;
    }
    return apiService.postPublic(AppConstants.getHomeData, payload);
  }

  void saveLatLng(var lat, var lng, var address) {
    sharedPreferencesManager.putDouble('lat', lat);
    sharedPreferencesManager.putDouble('lng', lng);
    sharedPreferencesManager.putString('address', address);
  }

  String getSavedAddress() {
    return sharedPreferencesManager.getString('address') ?? '';
  }

  double getSavedLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getSavedLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
