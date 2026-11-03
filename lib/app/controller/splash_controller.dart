import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/language_model.dart';
import 'package:salon_user/app/backend/models/settings_model.dart';
import 'package:salon_user/app/backend/models/support_model.dart';
import 'package:salon_user/app/backend/parse/pricing_parse.dart';
import 'package:salon_user/app/backend/parse/splash_parse.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';

class SplashController extends GetxController implements GetxService {
  final SplashParser parser;

  late LanguageModel _defaultLanguage;
  LanguageModel get defaultLanguage => _defaultLanguage;
  late SettingsModel _settingsModel;
  SettingsModel get settinsModel => _settingsModel;

  late SupportModel _supportModel;
  SupportModel get supportModel => _supportModel;
  SplashController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    unawaited(_saveFcmToken());
  }

  Future<void> _saveFcmToken() async {
    try {
      if (Firebase.apps.isEmpty) return;
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      debugPrint(token);
      parser.saveDeviceToken(token);
    } catch (e) {
      debugPrint('FCM token skipped: $e');
    }
  }

  Future<bool> initSharedData() {
    return parser.initAppSettings();
  }

  /// Loads app settings.
  /// Language API may omit `support` — merge with getDefault so splash
  /// does not falsely show Connection Failed.
  Future<bool> getConfigData() async {
    final lang = parser.getLanguagesCode();
    bool isSuccess = false;

    try {
      final langResponse = await parser.getAppSettingsByLanguage(lang);
      Response? defaultResponse;

      Map<String, dynamic>? settingsJson;
      Map<String, dynamic>? supportJson;
      Map<String, String> uiStrings = {};

      void absorb(Map<String, dynamic>? map) {
        if (map == null) return;
        final data = ApiBody.asObject(map['data']);
        if (data == null) return;
        final settings = ApiBody.asObject(data['settings']);
        final support = ApiBody.asObject(data['support']);
        if (settings != null) settingsJson = settings;
        if (support != null) supportJson = support;

        final rawUi = data['ui_strings'] ?? data['strings'];
        if (rawUi is Map) {
          rawUi.forEach((key, value) {
            final text = value?.toString() ?? '';
            if (text.isNotEmpty) uiStrings[key.toString()] = text;
          });
        }
      }

      absorb(ApiBody.asMap(langResponse.body));
      if (settingsJson == null) {
        defaultResponse = await parser.getAppSettings();
        absorb(ApiBody.asMap(defaultResponse.body));
      } else {
        unawaited(parser.getAppSettings());
      }

      if (settingsJson == null) {
        debugPrint('Splash: settings missing from both language + default APIs');
        if ((defaultResponse?.statusCode ?? 0) != 200 &&
            langResponse.statusCode != 200) {
          ApiChecker.checkApi(
            (defaultResponse?.statusCode ?? 0) != 0
                ? defaultResponse!
                : langResponse,
          );
        }
        update();
        return false;
      }

      supportJson ??= {
        'id': 0,
        'first_name': 'Support',
        'last_name': '',
      };

      final appSettingsInfo = SettingsModel.fromJson(settingsJson!);
      _settingsModel = appSettingsInfo;

      final supportModelInfo = SupportModel.fromJson(supportJson!);
      _supportModel = supportModelInfo;

      parser.saveBasicInfo(
        appSettingsInfo.currencyCode,
        appSettingsInfo.currencySide,
        appSettingsInfo.currencySymbol,
        appSettingsInfo.smsName,
        appSettingsInfo.userVerifyWith,
        appSettingsInfo.userLogin,
        appSettingsInfo.email,
        appSettingsInfo.name,
        0,
        appSettingsInfo.deliveryCharge,
        appSettingsInfo.tax,
        appSettingsInfo.logo,
        '${supportModelInfo.firstName ?? ''} ${supportModelInfo.lastName ?? ''}'
            .trim(),
        supportModelInfo.id,
        appSettingsInfo.mobile?.toString() ?? '',
        appSettingsInfo.allowDistance,
        appSettingsInfo.serviceCharge,
      );

      if (uiStrings.isNotEmpty) {
        LocaleHelper.applyUiStrings(lang, uiStrings);
      }

      isSuccess = true;
      unawaited(_loadTaxSettings());
    } catch (e, st) {
      debugPrint('Splash getConfigData error: $e\n$st');
      isSuccess = false;
    }

    update();
    return isSuccess;
  }

  Future<void> _loadTaxSettings() async {
    if (!Get.isRegistered<PricingParser>()) return;
    final parser = Get.find<PricingParser>();
    final country = Get.isRegistered<LanguagesController>()
        ? Get.find<LanguagesController>().countryCode
        : null;
    await Future.wait([
      parser.fetchTaxAvailability(country: country),
      parser.fetchTaxSettings(),
      parser.fetchHomeSections(country: country),
    ]);
  }

  Future<void> initLocale() async {
    if (!Get.isRegistered<LanguagesController>()) return;
    await Get.find<LanguagesController>().initLocale();
  }

  String getLanguageCode() {
    return parser.getLanguagesCode();
  }
}
