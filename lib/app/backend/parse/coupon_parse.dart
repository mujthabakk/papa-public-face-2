import 'package:flutter/material.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class OfferApplyGate {
  final bool canApply;
  final String message;
  final bool isFirstUser;
  final bool showPopup;
  final String popupTitle;
  final String popupMessage;
  final String deniedReason;

  const OfferApplyGate({
    required this.canApply,
    this.message = '',
    this.isFirstUser = false,
    this.showPopup = false,
    this.popupTitle = '',
    this.popupMessage = '',
    this.deniedReason = '',
  });

  factory OfferApplyGate.fromOffer(CouponsModel offer) {
    return OfferApplyGate(
      canApply: offer.canApply && !offer.alreadyUsed,
      isFirstUser: offer.isFirstTimeUserOffer,
      showPopup: offer.showPopup,
      popupTitle: offer.popupTitle ?? '',
      popupMessage: offer.popupMessage ?? '',
      deniedReason: offer.deniedReason ?? '',
      message: offer.alreadyUsed
          ? 'This offer has already been used.'
          : (offer.deniedReason ?? ''),
    );
  }

  String get displayTitle => popupTitle.trim().isNotEmpty
      ? popupTitle.trim()
      : 'Offer unavailable';

  String get displayMessage {
    final popup = popupMessage.trim();
    if (popup.isNotEmpty) return popup;
    final denied = deniedReason.trim();
    if (denied.isNotEmpty) return denied;
    final body = message.trim();
    if (body.isNotEmpty) return body;
    return CouponParser.firstUserOnlyMessage;
  }
}

class CouponParser {
  static const firstUserOnlyMessage =
      'This offer is for first-time users only.';

  static bool presentGate(OfferApplyGate gate) {
    if (gate.showPopup) {
      Get.dialog(
        AlertDialog(
          backgroundColor: ThemeProvider.surface,
          title: Text(
            gate.displayTitle.tr,
            style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
          ),
          content: Text(
            gate.displayMessage.tr,
            style: ThemeProvider.sans(size: 14, color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'OK'.tr,
                style: ThemeProvider.sans(
                  size: 14,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
            ),
          ],
        ),
      );
      return true;
    }
    if (!gate.canApply) {
      showToast(gate.displayMessage.tr);
      return true;
    }
    return false;
  }

  static bool presentOffer(CouponsModel offer) {
    return presentGate(OfferApplyGate.fromOffer(offer));
  }

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
    final body = <String, dynamic>{
      'lat': sharedPreferencesManager.getDouble('lat') ?? 0.0,
      'lng': sharedPreferencesManager.getDouble('lng') ?? 0.0,
    };
    final country = sharedPreferencesManager
            .getString(LocaleHelper.prefCountryName) ??
        sharedPreferencesManager.getString(LocaleHelper.prefCountry) ??
        '';
    if (country.isNotEmpty) body['country'] = country;
    return body;
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

  Future<OfferApplyGate> validateApply({
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
    return OfferApplyGate(
      canApply: canApply,
      message: message,
      isFirstUser: map['is_first_user'] == true,
      showPopup: map['show_popup'] == true ||
          map['show_popup']?.toString() == '1',
      popupTitle: (map['popup_title'] ?? '').toString().trim(),
      popupMessage: (map['popup_message'] ?? '').toString().trim(),
      deniedReason: (map['denied_reason'] ?? '').toString().trim(),
    );
  }

  List<CouponsModel> parseOffers(dynamic body) {
    final offers = <CouponsModel>[];
    for (final item in ApiBody.asList(body, keys: const [
      'offers',
      'coupons',
      'data',
      'items',
      'result',
      'list',
    ])) {
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

  Future<CouponsModel?> findEligibleOffer(String code) async {
    return matchOffer(await loadEligibleOffers(), code);
  }
}
