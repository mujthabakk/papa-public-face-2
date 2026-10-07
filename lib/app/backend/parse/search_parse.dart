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
    final payload = body is Map
        ? Map<String, dynamic>.from(body)
        : <String, dynamic>{};
    final query = (payload['param'] ?? payload['q'] ?? '').toString().trim();
    if (query.isNotEmpty) {
      payload['param'] = query;
      payload['q'] = payload['q'] ?? query;
      payload['keyword'] = payload['keyword'] ?? query;
      payload['name'] = payload['name'] ?? query;
      payload['search'] = payload['search'] ?? query;
    }
    return await apiService.postPublic(AppConstants.searchResult, payload);
  }

  Future<Response> searchProducts(String query) async {
    return apiService.postPublic(AppConstants.getTopProducts, {
      'lat': getLat(),
      'lng': getLng(),
      'param': query,
      'q': query,
      'keyword': query,
      'name': query,
      'search': query,
    });
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
