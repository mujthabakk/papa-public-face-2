import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/translator.dart';

class LocaleHelper {
  static const String prefLanguage = 'language';
  static const String prefCountry = 'country';
  static const String prefCountryName = 'country_name';
  static const String prefDirection = 'direction';
  static const String prefIsRtl = 'is_rtl';

  /// Maps getUiStrings API keys to existing app .tr keys.
  static const Map<String, String> uiKeyAliases = {
    'success': 'Success',
    'validation_error': 'Validation Error.',
    'data_not_found': 'Data not found.',
    'booking_created': 'Booking created',
    'cancel': 'Cancel',
    'continue': 'Continue',
    'submit': 'Submit',
  };

  static Locale toGetLocale(String code) {
    switch (code) {
      case 'ar':
        return const Locale('ar', 'AE');
      case 'hi':
        return const Locale('hi', 'IN');
      case 'es':
        return const Locale('es', 'DE');
      default:
        return const Locale('en', 'US');
    }
  }

  static String toTranslationKey(String code) {
    switch (code) {
      case 'ar':
        return 'ar_AE';
      case 'hi':
        return 'hi_IN';
      case 'es':
        return 'es_DE';
      default:
        return 'en_US';
    }
  }

  static bool isRtlCode(String code) => code == 'ar';

  static String directionForCode(String code) =>
      isRtlCode(code) ? 'rtl' : 'ltr';

  static TextDirection textDirection({required bool isRtl}) {
    return isRtl ? TextDirection.rtl : TextDirection.ltr;
  }

  /// Merge API UI strings into existing locale map (never wipe built-in .tr keys).
  static void applyUiStrings(String code, Map<String, String> strings) {
    final localeKey = toTranslationKey(code);
    final merged = <String, String>{};

    final fromApp = LocaleString().keys[localeKey];
    if (fromApp != null) merged.addAll(fromApp);

    final fromGet = Get.translations[localeKey];
    if (fromGet != null) merged.addAll(fromGet);

    if (strings.isNotEmpty) {
      merged.addAll(strings);
      uiKeyAliases.forEach((apiKey, trKey) {
        final value = strings[apiKey];
        if (value != null && value.isNotEmpty) {
          merged[trKey] = value;
        }
      });
    }

    if (merged.isEmpty) return;
    Get.addTranslations({localeKey: merged});
  }

  static void applyLocale(String code, {bool? isRtl}) {
    final locale = toGetLocale(code);
    void apply() {
      Get.updateLocale(locale);
    }

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      apply();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => apply());
    }
  }
}
