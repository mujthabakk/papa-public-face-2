import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class TopProductsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  TopProductsParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getTopProducts() async {
    final latLng = {"lat": getLat(), "lng": getLng()};
    // PDF: prefer getPublicHome; backend may still 500 — fall through.
    try {
      final home = await apiService.postPublic(
          AppConstants.getProductsPublicHome, latLng);
      if (home.statusCode == 200) return home;
    } catch (_) {}
    final top = await apiService.postPublic(
        AppConstants.getTopProducts, latLng);
    if (top.statusCode == 200) return top;
    return apiService.postPublic(
        AppConstants.getProductsAll, {...latLng, 'limit': 40});
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
