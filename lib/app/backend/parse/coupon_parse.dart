import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class CouponParser {
  static const firstUserOnlyMessage =
      'This offer is for first-time users only.';

  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CouponParser(
      {required this.apiService, required this.sharedPreferencesManager});

  String get uid {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  bool get hasUid {
    final value = uid.trim();
    return value.isNotEmpty && value != '0';
  }

  Map<String, dynamic> listingBody() {
    return {
      'lat': sharedPreferencesManager.getDouble('lat') ?? 0.0,
      'lng': sharedPreferencesManager.getDouble('lng') ?? 0.0,
    };
  }

  String listingQuery(String uri) {
    final lat = sharedPreferencesManager.getDouble('lat') ?? 0.0;
    final lng = sharedPreferencesManager.getDouble('lng') ?? 0.0;
    final sep = uri.contains('?') ? '&' : '?';
    return '$uri${sep}lat=$lat&lng=$lng';
  }

  Future<Response> getCouponCodes({bool includeUid = true}) async {
    if (!includeUid) {
      return apiService.getPublic(
        listingQuery(AppConstants.getCoupons),
        includeUid: false,
      );
    }
    return apiService.postPrivate(
      AppConstants.getCoupons,
      listingBody(),
      sharedPreferencesManager.getString('token') ?? '',
    );
  }

  Future<Response> getPublicHomeOffers({bool includeUid = true}) {
    if (!includeUid) {
      return apiService.getPublic(
        listingQuery(AppConstants.getPublicHomeOffers),
        includeUid: false,
      );
    }
    return apiService.postPublic(
      AppConstants.getPublicHomeOffers,
      listingBody(),
    );
  }

  Future<Response> getAllOffers({bool includeUid = true}) {
    if (!includeUid) {
      return apiService.getPublic(
        listingQuery(AppConstants.getAllOffers),
        includeUid: false,
      );
    }
    return apiService.postPublic(AppConstants.getAllOffers, listingBody());
  }

  Future<({bool canApply, String message, bool isFirstUser})> validateApply({
    String? code,
    int? id,
  }) async {
    final body = <String, dynamic>{};
    final trimmed = (code ?? '').trim();
    if (trimmed.isNotEmpty) body['code'] = trimmed;
    if (id != null && id > 0) body['id'] = id;
    final response =
        await apiService.postPublic(AppConstants.validateApplyOffer, body);
    final map = ApiBody.asMap(response.body) ?? {};
    final message = (map['message'] ?? ApiBody.message(response) ?? '')
        .toString()
        .trim();
    final canApply = map['success'] == true && map['can_apply'] == true;
    return (
      canApply: canApply,
      message: message,
      isFirstUser: map['is_first_user'] == true,
    );
  }

  List<CouponsModel> parseOffers(dynamic body) {
    final offers = <CouponsModel>[];
    for (final item in ApiBody.asList(body)) {
      final coupon = CouponsModel.tryParse(item);
      if (coupon != null) offers.add(coupon);
    }
    return offers;
  }

  CouponsModel? matchOffer(List<CouponsModel> offers, String code) {
    for (final coupon in offers) {
      if (CouponsModel.matchesCode(coupon, code)) return coupon;
    }
    return null;
  }

  Future<List<CouponsModel>> loadEligibleOffers() async {
    Response response = await getCouponCodes();
    var offers = parseOffers(response.body);
    if (offers.isEmpty) {
      response = await getAllOffers();
      offers = parseOffers(response.body);
    }
    if (offers.isEmpty) {
      response = await getPublicHomeOffers();
      offers = parseOffers(response.body);
    }
    return offers;
  }

  /// Eligible for this uid (backend hides first-user offers after a booking).
  Future<CouponsModel?> findEligibleOffer(String code) async {
    return matchOffer(await loadEligibleOffers(), code);
  }

  /// Returning users: offer exists globally as first-user only.
  Future<bool> isBlockedFirstUserOffer(String code) async {
    if (!hasUid) return false;
    if (CouponsModel.looksLikeFirstUserOffer(name: code, code: code)) {
      return true;
    }
    final catalog = parseOffers((await getAllOffers(includeUid: false)).body);
    final found = matchOffer(catalog, code);
    return found?.isFirstTimeUserOffer == true;
  }
}
