/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class ProductsParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  ProductsParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Map<String, dynamic> _body([Map<String, dynamic>? extra]) {
    final payload = <String, dynamic>{...?extra};
    payload['lat'] = payload['lat'] ?? getLat();
    payload['lng'] = payload['lng'] ?? getLng();
    return payload;
  }

  Future<Response> getproductsByIdAndCateId(var body) async {
    final payload = body is Map
        ? Map<String, dynamic>.from(body)
        : <String, dynamic>{};
    // PDF: no distance filter on product GETs.
    final public = await apiService.postPublic(
        AppConstants.getProductsByIdAndCateId, payload);
    if (public.statusCode == 200) return public;
    final get = await apiService.getPublic(AppConstants.getProductsByIdAndCateId);
    if (get.statusCode == 200) return get;
    return apiService.postPrivate(
        AppConstants.getProductsByIdAndCateId,
        payload,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getPublicHome([Map<String, dynamic>? extra]) async {
    final body = _body(extra);
    final post =
        await apiService.postPublic(AppConstants.getProductsPublicHome, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(AppConstants.getProductsPublicHome);
  }

  Future<Response> getAllProducts({
    int? cateId,
    int? subCateId,
    int? sellerUid,
    String? q,
    int limit = 40,
  }) async {
    // PDF: uid aliases seller_id / freelancer_id / freelacer_id; q aliases search/keyword.
    final query = (q ?? '').trim();
    final body = <String, dynamic>{
      if (cateId != null && cateId > 0) 'cate_id': cateId,
      if (subCateId != null && subCateId > 0) 'sub_cate_id': subCateId,
      if (sellerUid != null && sellerUid > 0) ...{
        'uid': sellerUid,
        'seller_id': sellerUid,
        'freelancer_id': sellerUid,
        'freelacer_id': sellerUid,
      },
      if (query.isNotEmpty) ...{
        'q': query,
        'search': query,
        'keyword': query,
      },
      'limit': limit.clamp(1, 100),
    };
    final post =
        await apiService.postPublic(AppConstants.getProductsAll, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(AppConstants.getProductsAll);
  }

  Future<Response> searchProducts(String q) async {
    final query = q.trim();
    // PDF: q (or search / keyword).
    final body = _body({
      'q': query,
      'search': query,
      'keyword': query,
    });
    final post =
        await apiService.postPublic(AppConstants.getProductsSearch, body);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(
        '${AppConstants.getProductsSearch}?q=${Uri.encodeQueryComponent(query)}');
  }

  Future<Response> getBySeller(int sellerUid) async {
    // PDF: id required; aliases uid/seller_id; routes getBySeller /
    // getFreelancerProducts / getSellerProducts.
    final body = {
      'id': sellerUid,
      'uid': sellerUid,
      'seller_id': sellerUid,
      'freelancer_id': sellerUid,
      'freelacer_id': sellerUid,
    };
    for (final path in [
      AppConstants.getProductsBySeller,
      AppConstants.getProductsFreelancerProducts,
      AppConstants.getProductsSellerProducts,
    ]) {
      final post = await apiService.postPublic(path, body);
      if (post.statusCode == 200) return post;
      final get = await apiService.getPublic('$path?id=$sellerUid');
      if (get.statusCode == 200) return get;
    }
    return apiService.postPublic(AppConstants.getProductsBySeller, body);
  }

  Future<Response> getSellers() async {
    // PDF aliases: getSellers / getStores / getProductSellers
    for (final path in [
      AppConstants.getProductsSellers,
      AppConstants.getProductsStores,
      AppConstants.getProductsProductSellers,
    ]) {
      final get = await apiService.getPublic(path);
      if (get.statusCode == 200) return get;
      final post = await apiService.postPublic(path, {});
      if (post.statusCode == 200) return post;
    }
    return apiService.getPublic(AppConstants.getProductsSellers);
  }

  Future<Response> getProductOffersActive() async {
    final post = await apiService.postPublic(
        AppConstants.getProductOffersActive, _body());
    if (post.statusCode == 200) return post;
    return apiService.getPublic(AppConstants.getProductOffersPublic);
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
