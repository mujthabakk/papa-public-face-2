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

  /// PDF Products tab: prefer products/getPublicHome (categories + products).
  /// Fallback: GET product_categories/getHome, then getActive.
  Future<Response> getAllCategories() async {
    try {
      final publicHome = await apiService
          .postPublic(AppConstants.getProductsPublicHome, {});
      if (publicHome.statusCode == 200) {
        final body = publicHome.body;
        if (body is Map &&
            ((body['categories'] is List &&
                    (body['categories'] as List).isNotEmpty) ||
                (body['data'] is List && (body['data'] as List).isNotEmpty))) {
          return publicHome;
        }
      }
    } catch (_) {}

    final home = await apiService.getPublic(AppConstants.getProducts);
    if (home.statusCode == 200) return home;

    final activeGet =
        await apiService.getPublic(AppConstants.getProductCategoriesActive);
    if (activeGet.statusCode == 200) return activeGet;
    return apiService.postPublic(AppConstants.getProductCategoriesActive, {});
  }

  /// PDF: GET|POST product_sub_categories/getFromCateId { id: cate_id }
  Future<Response> getSubCategoriesFromCateId(int cateId) async {
    final body = {'id': cateId};
    final post = await apiService.postPublic(
        AppConstants.getProductSubCategoriesFromCateId, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(
        '${AppConstants.getProductSubCategoriesFromCateId}?id=$cateId');
  }

  Future<Response> getProductsForYou() async {
    // No distance filter on product GETs — lat/lng ignored by backend.
    final home = await apiService.postPublic(
      AppConstants.getProductsPublicHome,
      {},
    );
    if (home.statusCode == 200) return home;
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
