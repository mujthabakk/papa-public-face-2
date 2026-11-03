import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class ProductsDetailsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProductsDetailsParser(
      {required this.apiService, required this.sharedPreferencesManager});

  /// Prefer public getById (PDF); fall back to legacy getProductInfo.
  Future<Response> getProductsInfo(var body) async {
    final payload = body is Map
        ? Map<String, dynamic>.from(body)
        : <String, dynamic>{'id': body};
    // PDF: id REQUIRED (alias product_id).
    final id = payload['id'] ?? payload['product_id'];
    if (id != null) {
      payload['id'] = id;
      payload['product_id'] = id;
    }
    final byId = await apiService.postPublic(
        AppConstants.getProductsById, payload);
    if (byId.statusCode == 200) return byId;

    final get = await apiService.getPublic(
        '${AppConstants.getProductsById}?id=${payload['id']}');
    if (get.statusCode == 200) return get;

    // Alias getProductInfo
    final info = await apiService.postPublic(
        AppConstants.getProductsInfo, payload);
    if (info.statusCode == 200) return info;

    return apiService.postPrivate(
      AppConstants.getProductsInfo,
      payload,
      sharedPreferencesManager.getString('token') ?? '',
    );
  }

  Future<Response> getVariants(int productId) async {
    final body = {'id': productId};
    final post =
        await apiService.postPublic(AppConstants.getProductsVariants, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(
        '${AppConstants.getProductsVariants}?id=$productId');
  }

  Future<Response> getGallery(int productId) async {
    final body = {'id': productId};
    final post =
        await apiService.postPublic(AppConstants.getProductsGallery, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(
        '${AppConstants.getProductsGallery}?id=$productId');
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
