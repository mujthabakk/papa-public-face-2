import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';
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

/// Bumped when the user changes country so screens can refetch on reopen.
class LocaleRefresh {
  static int countryEpoch = 0;

  static void bumpCountry() => countryEpoch++;
}

mixin CountryScopedRefresh on GetxController {
  int countryDataEpoch = LocaleRefresh.countryEpoch;

  void markCountryFresh() {
    countryDataEpoch = LocaleRefresh.countryEpoch;
  }

  bool takeCountryRefresh() {
    if (countryDataEpoch == LocaleRefresh.countryEpoch) return false;
    countryDataEpoch = LocaleRefresh.countryEpoch;
    return true;
  }
}

/// Display currency from API prefs. Format is always `SYMBOL 12.34`.
class AppCurrency {
  static String code = AppConstants.defaultCurrencyCode;
  static String symbol = AppConstants.defaultCurrencySymbol;
  static String side = AppConstants.defaultCurrencySide;

  static void apply({String? code, String? symbol, String? side}) {
    final nextCode = (code ?? '').trim();
    if (nextCode.isNotEmpty) AppCurrency.code = nextCode.toUpperCase();
    final nextSymbol = (symbol ?? '').trim();
    if (nextSymbol.isNotEmpty) AppCurrency.symbol = nextSymbol;
    if (side == 'left' || side == 'right') AppCurrency.side = side!;
  }

  static String format(num? amount, {int digits = 2}) {
    final v = (amount ?? 0).toStringAsFixed(digits);
    final s = symbol.trim();
    if (s.isEmpty) return v;
    return '$s $v';
  }
}
