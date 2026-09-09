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
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint(value.toString());
      parser.saveDeviceToken(value.toString());
    });
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
      final defaultResponse = await parser.getAppSettings();

      final langMap = ApiBody.asMap(langResponse.body);
      final defaultMap = ApiBody.asMap(defaultResponse.body);

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

      // Prefer language settings; fill missing support from default.
      absorb(langMap);
      absorb(defaultMap);

      if (settingsJson == null) {
        debugPrint('Splash: settings missing from both language + default APIs');
        if (defaultResponse.statusCode != 200 &&
            langResponse.statusCode != 200) {
          ApiChecker.checkApi(
            defaultResponse.statusCode != 0
                ? defaultResponse
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
    await Get.find<PricingParser>().fetchTaxSettings();
  }

  Future<void> initLocale() async {
    if (!Get.isRegistered<LanguagesController>()) return;
    await Get.find<LanguagesController>().initLocale();
  }

  String getLanguageCode() {
    return parser.getLanguagesCode();
  }
}
