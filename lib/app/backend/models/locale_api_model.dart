import 'package:salon_user/app/backend/models/language_model.dart';

class LocaleMeta {
  final String locale;
  final String direction;
  final bool isRtl;

  LocaleMeta({
    required this.locale,
    required this.direction,
    required this.isRtl,
  });

  factory LocaleMeta.fromJson(Map<String, dynamic> json) {
    return LocaleMeta(
      locale: json['locale']?.toString() ?? 'en',
      direction: json['direction']?.toString() ?? 'ltr',
      isRtl: json['is_rtl'] == true || json['is_rtl']?.toString() == '1',
    );
  }
}

class LocaleConfigData {
  final String locale;
  final String defaultLanguage;
  final String defaultCountry;
  final String selectedLanguage;
  final String selectedCountry;
  final String currencyCode;
  final String currencySymbol;
  final List<LocaleCountryItem> countries;

  LocaleConfigData({
    required this.locale,
    required this.defaultLanguage,
    required this.defaultCountry,
    required this.selectedLanguage,
    required this.selectedCountry,
    this.currencyCode = '',
    this.currencySymbol = '',
    required this.countries,
  });

  factory LocaleConfigData.fromJson(Map<String, dynamic> json) {
    final countriesRaw = json['countries'];
    String currencyCode = json['currencyCode']?.toString() ??
        json['currency_code']?.toString() ??
        json['currency']?.toString() ??
        '';
    String currencySymbol = json['currencySymbol']?.toString() ??
        json['currency_symbol']?.toString() ??
        '';
    final conv = json['currency_conversion'];
    if (conv is Map) {
      if (currencyCode.isEmpty) {
        currencyCode = conv['to']?.toString() ?? '';
      }
    }
    return LocaleConfigData(
      locale: json['locale']?.toString() ?? 'en',
      defaultLanguage: json['default_language']?.toString() ?? 'en',
      defaultCountry: json['default_country']?.toString() ?? '',
      selectedLanguage: json['selected_language']?.toString() ?? 'en',
      selectedCountry: json['selected_country']?.toString() ?? '',
      currencyCode: currencyCode.toUpperCase(),
      currencySymbol: currencySymbol,
      countries: countriesRaw is List
          ? countriesRaw
              .whereType<Map>()
              .map((e) => LocaleCountryItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList()
          : [],
    );
  }
}

class LocaleCountryItem {
  final int? id;
  final String name;
  final String nameEn;
  final String code;
  final String countryCode;
  final List<String> languages;

  LocaleCountryItem({
    this.id,
    required this.name,
    required this.nameEn,
    required this.code,
    required this.countryCode,
    this.languages = const [],
  });

  factory LocaleCountryItem.fromJson(Map<String, dynamic> json) {
    final langsRaw = json['languages'];
    final langs = <String>[];
    if (langsRaw is List) {
      for (final e in langsRaw) {
        final code = e?.toString() ?? '';
        if (code.isNotEmpty) langs.add(code);
      }
    }
    return LocaleCountryItem(
      id: int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      nameEn: json['name_en']?.toString() ?? json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      countryCode: json['country_code']?.toString() ?? '',
      languages: langs,
    );
  }

  String get displayName => name.isNotEmpty ? name : nameEn;
}

/// Response from cities/getActiveCountries (main picker API).
class ActiveCountriesResult {
  final LocaleMeta meta;
  final List<LocaleCountryItem> countries;
  final List<LanguageModel> languages;
  final String selectedLanguage;
  final String selectedCountry;

  ActiveCountriesResult({
    required this.meta,
    required this.countries,
    required this.languages,
    this.selectedLanguage = '',
    this.selectedCountry = '',
  });

  factory ActiveCountriesResult.fromJson(Map<String, dynamic> map) {
    final meta = LocaleMeta.fromJson(map);

    List rawCountries = const [];
    if (map['countries'] is List) {
      rawCountries = map['countries'] as List;
    } else if (map['data'] is List) {
      rawCountries = map['data'] as List;
    }

    final countries = rawCountries
        .whereType<Map>()
        .map((e) => LocaleCountryItem.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.code.isNotEmpty)
        .toList();

    final langs = <LanguageModel>[];
    final rawLangs = map['languages'];
    if (rawLangs is List) {
      for (final e in rawLangs.whereType<Map>()) {
        langs.add(LanguageModel.fromJson(Map<String, dynamic>.from(e)));
      }
    }

    return ActiveCountriesResult(
      meta: meta,
      countries: countries,
      languages: langs,
      selectedLanguage: map['selected_language']?.toString() ?? '',
      selectedCountry: map['selected_country']?.toString() ?? '',
    );
  }
}

class LocaleLanguagesResult {
  final LocaleMeta meta;
  final List<LanguageModel> languages;

  LocaleLanguagesResult({required this.meta, required this.languages});
}

class LocaleConfigResult {
  final LocaleMeta meta;
  final LocaleConfigData? config;

  LocaleConfigResult({required this.meta, this.config});
}

class LocaleUiStringsResult {
  final LocaleMeta meta;
  final Map<String, String> strings;

  LocaleUiStringsResult({required this.meta, required this.strings});
}
