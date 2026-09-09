/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class CategoriesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CategoriesParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getAllCategories() async {
    var response = await apiService.getPublic(AppConstants.getProducts);
    return response;
  }

  Future<Response> getProductsForYou() async {
    return apiService.postPublic(
      AppConstants.getTopProducts,
      {'lat': getLat(), 'lng': getLng()},
    );
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
