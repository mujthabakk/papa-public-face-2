/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class NearParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  NearParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getHomeData(var body) async {
    final payload =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    final uid = sharedPreferencesManager.getString('uid');
    if (uid != null && uid.isNotEmpty && uid != '0') {
      payload['uid'] = int.tryParse(uid) ?? uid;
    }
    return apiService.postPublic(AppConstants.getHomeData, payload);
  }

  Future<Response> getTopSalon(var body) {
    return apiService.postPublic(AppConstants.getTopSalon, body);
  }

  Future<Response> getTopFreelancer(var body) {
    return apiService.postPublic(AppConstants.getTopFreelancer, body);
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
