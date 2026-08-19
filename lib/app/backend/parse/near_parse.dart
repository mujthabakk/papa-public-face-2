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
    var response = await apiService.postPublic(AppConstants.getHomeData, body);
    return response;
  }

  Future<Response> getTopSalon(var body) {
    return apiService.postPublic(AppConstants.getTopSalon, body);
  }

  Future<Response> getTopFreelancer(var body) {
    return apiService.postPublic(AppConstants.getTopFreelancer, body);
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
