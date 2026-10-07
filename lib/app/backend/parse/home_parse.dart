import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class HomeParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  HomeParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Map<String, dynamic> listingPayload([dynamic extra]) {
    final payload = extra is Map
        ? Map<String, dynamic>.from(extra)
        : <String, dynamic>{};
    payload['lat'] = payload['lat'] ?? getLat();
    payload['lng'] = payload['lng'] ?? getLng();
    final country = sharedPreferencesManager
            .getString(LocaleHelper.prefCountryName) ??
        sharedPreferencesManager.getString(LocaleHelper.prefCountry) ??
        '';
    if (country.isNotEmpty) {
      payload['country'] = payload['country'] ?? country;
    }
    final cityId = sharedPreferencesManager.getInt('city_id') ?? 0;
    if (cityId > 0) {
      payload['city_id'] = payload['city_id'] ?? cityId;
    }
    final uid = sharedPreferencesManager.getString('uid');
    if (uid != null && uid.isNotEmpty && uid != '0') {
      payload['uid'] = payload['uid'] ?? int.tryParse(uid) ?? uid;
    }
    return payload;
  }

  Future<Response> getHomeData(var body) async {
    return apiService.postPublic(
        AppConstants.getHomeData, listingPayload(body));
  }

  Future<Response> getAllCategories() {
    return apiService.getPublic(AppConstants.getAllCategories);
  }

  Future<Response> getAllOffers() {
    return apiService.postPublic(
        AppConstants.getAllOffers, listingPayload());
  }

  Future<Response> getPublicHomeOffers() {
    return apiService.postPublic(
        AppConstants.getPublicHomeOffers, listingPayload());
  }

  Future<Response> getTopSalon(var body) {
    return apiService.postPublic(
        AppConstants.getTopSalon, listingPayload(body));
  }

  Future<Response> getTopFreelancer(var body) {
    return apiService.postPublic(
        AppConstants.getTopFreelancer, listingPayload(body));
  }

  Future<Response> getBannerData(var body) {
    return apiService.postPublic(
        AppConstants.getBannerData, listingPayload(body));
  }

  Future<Response> getTopProducts(var body) {
    return apiService.postPublic(
        AppConstants.getTopProducts, listingPayload(body));
  }

  Future<Response> getTopPartners(var body) async {
    final payload = listingPayload(body);
    final post = await apiService.postPublic(AppConstants.getTopPartners, payload);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(AppConstants.getTopPartners);
  }

  Future<Response> getPartnerAds(var body) async {
    final payload = listingPayload(body);
    final post = await apiService.postPublic(AppConstants.getPartnerAds, payload);
    if (post.statusCode == 200) return post;
    return apiService.getPublic(AppConstants.getPartnerAds);
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

  Future<Response> getPartnerOffer(int partnerUid) {
    return apiService.getPublic(
      '${AppConstants.getTimedOffersPartner}?uid=$partnerUid',
      includeUid: false,
    );
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
