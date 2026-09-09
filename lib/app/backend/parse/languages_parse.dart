/*Papabear*/
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/language_model.dart';
import 'package:salon_user/app/backend/models/locale_api_model.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class LanguagesParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LanguagesParser({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  void saveLanguage(String code) {
    sharedPreferencesManager.putString(LocaleHelper.prefLanguage, code);
  }

  void saveCountry(String code) {
    sharedPreferencesManager.putString(LocaleHelper.prefCountry, code);
  }

  void saveCountryName(String name) {
    sharedPreferencesManager.putString(LocaleHelper.prefCountryName, name);
  }

  String getCountryName() {
    return sharedPreferencesManager.getString(LocaleHelper.prefCountryName) ??
        '';
  }

  void saveDirection(String direction) {
    sharedPreferencesManager.putString(LocaleHelper.prefDirection, direction);
  }

  void saveIsRtl(bool value) {
    sharedPreferencesManager.putBool(LocaleHelper.prefIsRtl, value);
  }

  String getDefault() {
    return sharedPreferencesManager.getString(LocaleHelper.prefLanguage) ??
        AppConstants.defaultLanguageApp;
  }

  String getCountry() {
    return sharedPreferencesManager.getString(LocaleHelper.prefCountry) ?? 'IN';
  }

  bool getIsRtl() {
    return sharedPreferencesManager.getBool(LocaleHelper.prefIsRtl);
  }

  String getDirection() {
    return sharedPreferencesManager.getString(LocaleHelper.prefDirection) ??
        'ltr';
  }

  String? getUid() {
    final uid = sharedPreferencesManager.getString('uid');
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  /// Main picker API: countries + languages (+ optional country filter).
  Future<ActiveCountriesResult> fetchActiveCountries({
    String? country,
  }) async {
    final path = (country != null && country.isNotEmpty)
        ? '${AppConstants.getActiveCountries}?country=$country'
        : AppConstants.getActiveCountries;
    final response = await apiService.getPublic(path);
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return ActiveCountriesResult(
        meta: LocaleMeta(
          locale: getDefault(),
          direction: getDirection(),
          isRtl: getIsRtl(),
        ),
        countries: List<LocaleCountryItem>.from(AppConstants.defaultCountries),
        languages: List<LanguageModel>.from(AppConstants.languages),
      );
    }

    final result = ActiveCountriesResult.fromJson(map);
    return ActiveCountriesResult(
      meta: result.meta,
      countries: result.countries.isNotEmpty
          ? result.countries
          : List<LocaleCountryItem>.from(AppConstants.defaultCountries),
      languages: result.languages.isNotEmpty
          ? result.languages
          : List<LanguageModel>.from(AppConstants.languages),
      selectedLanguage: result.selectedLanguage,
      selectedCountry: result.selectedCountry,
    );
  }

  Future<LocaleLanguagesResult> fetchLanguages() async {
    final response = await apiService.postPublic(AppConstants.getLanguages, {});
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return LocaleLanguagesResult(
        meta: LocaleMeta(locale: getDefault(), direction: 'ltr', isRtl: false),
        languages: List<LanguageModel>.from(AppConstants.languages),
      );
    }

    final meta = LocaleMeta.fromJson(map);
    final data = map['data'];
    final list = data is List
        ? data
            .whereType<Map>()
            .map((e) => LanguageModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <LanguageModel>[];

    return LocaleLanguagesResult(
      meta: meta,
      languages: list.isNotEmpty
          ? list
          : List<LanguageModel>.from(AppConstants.languages),
    );
  }

  Future<LocaleConfigResult> fetchConfig({
    required String lang,
    required String country,
  }) async {
    final response = await apiService.postPublic(AppConstants.getLocaleConfig, {
      'lang': lang,
      'country': country,
    });
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return LocaleConfigResult(
        meta: LocaleMeta(locale: lang, direction: 'ltr', isRtl: false),
      );
    }

    final meta = LocaleMeta.fromJson(map);
    LocaleConfigData? config;
    final data = map['data'];
    if (data is Map) {
      config = LocaleConfigData.fromJson(Map<String, dynamic>.from(data));
    }

    return LocaleConfigResult(meta: meta, config: config);
  }

  Future<LocaleUiStringsResult> fetchUiStrings(String lang) async {
    final response = await apiService.postPublic(AppConstants.getUiStrings, {
      'lang': lang,
    });
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return LocaleUiStringsResult(
        meta: LocaleMeta(locale: lang, direction: 'ltr', isRtl: false),
        strings: {},
      );
    }

    final meta = LocaleMeta.fromJson(map);
    final strings = <String, String>{};
    final data = map['data'];
    if (data is Map) {
      final raw = data['strings'];
      if (raw is Map) {
        raw.forEach((key, value) {
          strings[key.toString()] = value?.toString() ?? '';
        });
      }
    }

    return LocaleUiStringsResult(meta: meta, strings: strings);
  }

  Future<bool> saveUserPreference({
    required String userId,
    required String language,
    required String country,
  }) async {
    final response =
        await apiService.postPublic(AppConstants.saveUserPreference, {
      'user_id': userId,
      'language': language,
      'country': country,
    });
    final map = ApiBody.asMap(response.body);
    return response.statusCode == 200 && map?['success'] == true;
  }

  Future<List<LocaleCountryItem>> fetchCountries() async {
    final result = await fetchActiveCountries();
    return result.countries;
  }

  Future<List<LocaleCountryItem>> fetchStates(String countryCode) async {
    final response = await apiService.getPublic(
      '${AppConstants.getActiveStates}?country=$countryCode',
    );
    final map = ApiBody.asMap(response.body);
    if (map == null) return [];
    final list = ApiBody.asList(map['data'], keys: const ['data']);
    return list
        .whereType<Map>()
        .map((e) => LocaleCountryItem.fromJson(Map<String, dynamic>.from(e)))
        .where((c) => c.code.isNotEmpty || c.name.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>?> fetchAppSettingsByLanguage(String lang) async {
    final response = await apiService.postPublic(
      AppConstants.getAppSettingsByLanguageId,
      {'lang': lang},
    );
    return ApiBody.asMap(response.body);
  }

  /// Load logged-in user profile (includes preferred_language / preferred_country).
  Future<Map<String, dynamic>?> fetchUserProfile(String uid) async {
    final token = sharedPreferencesManager.getString('token');
    if (token == null || token.isEmpty) return null;
    final response = await apiService.postPrivate(
      AppConstants.getUserProfile,
      {'id': uid},
      token,
    );
    final map = ApiBody.asMap(response.body);
    if (map == null || map['success'] != true) return null;
    final data = map['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  /// Guide: profile/update with { id, language, country }
  Future<Map<String, dynamic>?> updateProfileLocale({
    required String uid,
    required String language,
    required String country,
  }) async {
    final token = sharedPreferencesManager.getString('token');
    if (token == null || token.isEmpty) return null;
    final response = await apiService.postPrivate(
      AppConstants.updateProfile,
      {
        'id': uid,
        'language': language,
        'country': country,
      },
      token,
    );
    final map = ApiBody.asMap(response.body);
    if (response.statusCode == 200 && map?['success'] == true) {
      final data = map?['data'];
      if (data is Map) return Map<String, dynamic>.from(data);
      return map;
    }
    return null;
  }
}
