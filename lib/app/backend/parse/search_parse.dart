import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class SearchParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SearchParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getSearchResult(var body) async {
    return await apiService.postPublic(AppConstants.searchResult, body);
  }

  Future<Response> getBannerData(var body) async {
    var response =
        await apiService.postPublic(AppConstants.getBannerData, body);
    return response;
  }

  Future<Response> getAllCategories() async {
    var response = await apiService.getPublic(AppConstants.getAllCategories);
    return response;
  }

  // Future<Response> getFacilitiesData(var body) async {
  //   var response =
  //       await apiService.postPublic(AppConstants.getFacilities, body);
  //   return response;
  // }
  Future<Response> getFacilitiesData() async {
    var response = await apiService.getPublic(AppConstants.getFacilitiesNew);
    return response;
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }

  String getAddressName() {
    return sharedPreferencesManager.getString('address') ?? 'Home';
  }
}
