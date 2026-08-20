import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class HomeParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getHomeData(var body) async {
    var response = await apiService.postPublic(AppConstants.getHomeData, body);
    return response;
  }

  Future<Response> getAllCategories() {
    return apiService.getPublic(AppConstants.getAllCategories);
  }

  Future<Response> getAllOffers() {
    return apiService.getPublic(AppConstants.getAllOffers);
  }

  Future<Response> getPublicHomeOffers() {
    return apiService.getPublic(AppConstants.getPublicHomeOffers);
  }

  Future<Response> getTopSalon(var body) {
    return apiService.postPublic(AppConstants.getTopSalon, body);
  }

  Future<Response> getTopFreelancer(var body) {
    return apiService.postPublic(AppConstants.getTopFreelancer, body);
  }

  Future<Response> getBannerData(var body) {
    return apiService.postPublic(AppConstants.getBannerData, body);
  }

  Future<Response> getTopProducts(var body) {
    return apiService.postPublic(AppConstants.getTopProducts, body);
  }

  Future<Response> getTimedOffersHome() {
    return apiService.getPublic(AppConstants.getTimedOffersHome);
  }

  Future<Response> getTimedOffersAll({int? id, String? code}) {
    final params = <String, String>{};
    if (id != null && id > 0) params['id'] = '$id';
    if (code != null && code.isNotEmpty) params['code'] = code;
    if (params.isEmpty) {
      return apiService.getPublic(AppConstants.getTimedOffersAll);
    }
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return apiService.getPublic('${AppConstants.getTimedOffersAll}?$query');
  }

  Future<Response> postTimedOffersAll(Map<String, dynamic> body) {
    return apiService.postPublic(AppConstants.getTimedOffersAll, body);
  }

  String getAddressName() {
    return sharedPreferencesManager.getString('address') ?? 'Home';
  }

  double getLat() {
    return sharedPreferencesManager.getDouble('lat') ?? 0.0;
  }

  double getLng() {
    return sharedPreferencesManager.getDouble('lng') ?? 0.0;
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
  }
}
