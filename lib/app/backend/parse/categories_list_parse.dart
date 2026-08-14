/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class CategoriesListParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CategoriesListParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getDataFromCategories(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.getDataFromCategories,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }
}
