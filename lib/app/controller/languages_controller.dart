import 'dart:async';

/*Papabear*/
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/language_model.dart';
import 'package:salon_user/app/backend/models/locale_api_model.dart';
import 'package:salon_user/app/backend/parse/languages_parse.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/splash_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/locale_refresh.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';

class LanguagesController extends GetxController implements GetxService {
  final LanguagesParser parser;

  late String languageCode;
  late String countryCode;
  String countryName = '';
  bool isRtl = false;
  String direction = 'ltr';
  bool loading = false;

  /// Full language catalog from getActiveCountries.languages
  List<LanguageModel> allLanguages =
      List<LanguageModel>.from(AppConstants.languages);

  /// Languages shown in UI (filtered by selected country.languages)
  List<LanguageModel> languages =
      List<LanguageModel>.from(AppConstants.languages);

  List<LocaleCountryItem> countries =
      List<LocaleCountryItem>.from(AppConstants.defaultCountries);

  LanguagesController({required this.parser});

  Locale get appLocale => LocaleHelper.toGetLocale(languageCode);

  bool _updateScheduled = false;

  void safeUpdate() {
    if (isClosed) return;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      update();
      return;
    }
    if (_updateScheduled) return;
    _updateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      if (!isClosed) update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    languageCode = parser.getDefault();
    countryCode = parser.getCountry();
    countryName = parser.getCountryName();
    isRtl = parser.getIsRtl() || LocaleHelper.isRtlCode(languageCode);
    direction = parser.getDirection();
    if (direction.isEmpty) {
      direction = LocaleHelper.directionForCode(languageCode);
    }
    _refreshLanguagesForCountry();
    LocaleHelper.applyLocale(languageCode, isRtl: isRtl);
  }

  LanguageModel get selectedLanguage {
    final pool = languages.isNotEmpty ? languages : allLanguages;
    return pool.firstWhere(
      (e) => e.languageCode == languageCode,
      orElse: () => pool.isNotEmpty ? pool.first : allLanguages.first,
    );
  }

  LocaleCountryItem get selectedCountry {
    return countries.firstWhere(
      (c) => c.code == countryCode,
      orElse: () => LocaleCountryItem(
        name: countryName.isNotEmpty ? countryName : countryCode,
        nameEn: countryName.isNotEmpty ? countryName : countryCode,
        code: countryCode,
        countryCode: '',
      ),
    );
  }

  String get selectedCountryLabel =>
      countryName.isNotEmpty ? countryName : selectedCountry.displayName;

  /// Sync RTL/direction from API responses. Do not override user language choice.
  void applyResponseLocale(Map<String, dynamic> map) {
    final meta = LocaleMeta.fromJson(map);
    var changed = false;

    if (meta.isRtl != isRtl) {
      isRtl = meta.isRtl;
      parser.saveIsRtl(isRtl);
      changed = true;
    }

    if (meta.direction.isNotEmpty && meta.direction != direction) {
      direction = meta.direction;
      parser.saveDirection(direction);
      changed = true;
    }

    if (changed) {
      LocaleHelper.applyLocale(languageCode, isRtl: isRtl);
      safeUpdate();
    }
  }

  Future<void> _savePreferenceToServer() async {
    final uid = parser.getUid();
    if (uid == null) return;
    await parser.saveUserPreference(
      userId: uid,
      language: languageCode,
      country: countryCode,
    );
    final profile = await parser.updateProfileLocale(
      uid: uid,
      language: languageCode,
      country: countryCode,
    );
    if (profile != null) {
      await applyPreferredFromUser(profile, reloadUi: false);
    }
  }

  /// Apply preferred_language / preferred_country from profile API.
  /// Example: preferred_language=ar → entire app switches to Arabic.
  Future<void> applyPreferredFromUser(
    Map<String, dynamic> user, {
    bool reloadUi = true,
  }) async {
    final lang = (user['preferred_language'] ??
            user['language'] ??
            user['locale'] ??
            '')
        .toString()
        .trim()
        .toLowerCase()
        .split('_')
        .first;

    final countryRaw = (user['preferred_country'] ?? user['country'] ?? '')
        .toString()
        .trim();

    if (countryRaw.isNotEmpty) {
      final match = countries.firstWhere(
        (c) =>
            c.code.toLowerCase() == countryRaw.toLowerCase() ||
            c.name.toLowerCase() == countryRaw.toLowerCase() ||
            c.nameEn.toLowerCase() == countryRaw.toLowerCase() ||
            c.name.toLowerCase().contains(countryRaw.toLowerCase()) ||
            c.nameEn.toLowerCase().contains(countryRaw.toLowerCase()),
        orElse: () => LocaleCountryItem(
          name: countryRaw,
          nameEn: countryRaw,
          code: '',
          countryCode: '',
        ),
      );
      if (match.code.isNotEmpty) {
        countryCode = match.code;
        countryName = match.displayName;
        parser.saveCountry(countryCode);
        parser.saveCountryName(countryName);
      } else {
        countryName = countryRaw;
        parser.saveCountryName(countryName);
      }
      _refreshLanguagesForCountry();
    }

    if (lang.isNotEmpty &&
        (lang == 'en' || lang == 'ar' || lang == 'hi' || lang == 'es')) {
      _applyLocalLanguage(lang, persist: true);
      Get.updateLocale(LocaleHelper.toGetLocale(lang));
    }

    if (reloadUi) {
      try {
        final ui = await parser.fetchUiStrings(languageCode);
        LocaleHelper.applyUiStrings(languageCode, ui.strings);
      } catch (_) {}
      // Keep preferred language after any picker refresh.
      final keepLang = languageCode;
      try {
        await loadPicker(country: countryCode);
      } catch (_) {}
      if (languageCode != keepLang) {
        _applyLocalLanguage(keepLang, persist: true);
      }
      Get.updateLocale(LocaleHelper.toGetLocale(languageCode));
    }

    update();
  }

  /// On app enter: if logged in, load profile and switch to preferred_language.
  Future<void> syncPreferredFromProfile() async {
    final uid = parser.getUid();
    if (uid == null) return;
    final user = await parser.fetchUserProfile(uid);
    if (user == null) return;
    await applyPreferredFromUser(user, reloadUi: true);
  }

  /// Guide flow: getActiveCountries → fill countries + languages → UI strings.
  Future<void> initLocale() async {
    loading = true;
    safeUpdate();
    try {
      // 1) Preferred language from profile first (logged-in users).
      await syncPreferredFromProfile();
      // 2) Countries / languages catalog.
      await loadPicker(country: countryCode);
      // Restore preferred language if picker tried to change it.
      final saved = parser.getDefault();
      if (saved.isNotEmpty && saved != languageCode) {
        _applyLocalLanguage(saved, persist: true);
      }
      // 3) UI strings for active language (merge, don't wipe).
      final ui = await parser.fetchUiStrings(languageCode);
      LocaleHelper.applyUiStrings(languageCode, ui.strings);
      Get.updateLocale(LocaleHelper.toGetLocale(languageCode));
      unawaited(parser.fetchAppSettingsByLanguage(languageCode));
    } finally {
      loading = false;
      update();
    }
  }

  /// Main picker API (checklist #1).
  Future<void> loadPicker({String? country}) async {
    final result = await parser.fetchActiveCountries(
      country: country ?? countryCode,
    );

    if (result.countries.isNotEmpty) {
      countries = result.countries;
    }
    if (result.languages.isNotEmpty) {
      allLanguages = result.languages;
    }

    applyResponseLocale({
      'locale': result.meta.locale,
      'direction': result.meta.direction,
      'is_rtl': result.meta.isRtl,
    });

    // Resolve selected country label from list / selected_country
    final match = countries.firstWhere(
      (c) =>
          c.code == countryCode ||
          (result.selectedCountry.isNotEmpty &&
              (c.name == result.selectedCountry ||
                  c.nameEn == result.selectedCountry ||
                  c.code == result.selectedCountry)),
      orElse: () => countries.isNotEmpty
          ? countries.first
          : LocaleCountryItem(
              name: countryCode,
              nameEn: countryCode,
              code: countryCode,
              countryCode: '',
            ),
    );
    if (match.code.isNotEmpty) {
      if (countryCode.isEmpty ||
          !countries.any((c) => c.code == countryCode)) {
        countryCode = match.code;
        parser.saveCountry(countryCode);
      }
      countryName = match.displayName;
      parser.saveCountryName(countryName);
    }

    _refreshLanguagesForCountry();
    _ensureLanguageValidForCountry();
    safeUpdate();
  }

  /// Filter language dropdown by selected country's `languages` array.
  void _refreshLanguagesForCountry() {
    final country = selectedCountry;
    if (country.languages.isEmpty) {
      // Guide fallback: every country can open full catalog
      languages = List<LanguageModel>.from(allLanguages);
      return;
    }
    languages = allLanguages
        .where((l) => country.languages.contains(l.languageCode))
        .toList();
    if (languages.isEmpty) {
      languages = List<LanguageModel>.from(allLanguages);
    }
  }

  void _ensureLanguageValidForCountry() {
    // Keep user's preferred language even if country.languages is incomplete.
    // Only reset when the code is totally unknown in the catalog.
    final pool = allLanguages.isNotEmpty ? allLanguages : languages;
    if (pool.any((l) => l.languageCode == languageCode)) return;
    if (languages.any((l) => l.languageCode == languageCode)) return;
    final fallback = pool.isNotEmpty
        ? pool.first.languageCode
        : AppConstants.defaultLanguageApp;
    _applyLocalLanguage(fallback, persist: true);
  }

  Future<void> changeLanguage(String code) async {
    final next = code.trim().toLowerCase();
    if (next.isEmpty) return;

    _applyLocalLanguage(next, persist: true);
    // Immediate UI refresh so Home / tabs .tr strings switch now.
    Get.updateLocale(LocaleHelper.toGetLocale(next));
    update();
    _notifyAppUi();

    unawaited(_savePreferenceToServer());
    unawaited(_afterLanguageChanged(next));
  }

  void _notifyAppUi() {
    try {
      if (Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().update();
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<TabsController>()) {
        Get.find<TabsController>().update();
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().update();
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<NearController>()) {
        Get.find<NearController>().update();
      }
    } catch (_) {}
  }

  Future<void> _afterLanguageChanged(String code) async {
    try {
      final ui = await parser.fetchUiStrings(code);
      LocaleHelper.applyUiStrings(code, ui.strings);
    } catch (e) {
      debugPrint('fetchUiStrings failed: $e');
    }
    // Re-apply selected language (loadPicker must not override it).
    _applyLocalLanguage(code, persist: true);
    Get.updateLocale(LocaleHelper.toGetLocale(code));
    try {
      await loadPicker(country: countryCode);
      // Restore language again after picker refresh.
      if (languageCode != code) {
        _applyLocalLanguage(code, persist: true);
      }
    } catch (e) {
      debugPrint('loadPicker after language change failed: $e');
    }
    Get.updateLocale(LocaleHelper.toGetLocale(code));
    update();
    _notifyAppUi();
  }

  Future<void> changeCountry(String code) async {
    if (!_ensureLoggedInForCountry()) return;
    if (code == countryCode) return;
    final item = countries.firstWhere(
      (c) => c.code == code,
      orElse: () => LocaleCountryItem(
        name: code,
        nameEn: code,
        code: code,
        countryCode: '',
      ),
    );
    countryCode = code;
    countryName = item.displayName;
    parser.saveCountry(code);
    parser.saveCountryName(countryName);

    // Checklist: when country changes, refresh language list (country.languages)
    _refreshLanguagesForCountry();
    _ensureLanguageValidForCountry();
    safeUpdate();
    _notifyAppUi();

    await _savePreferenceToServer();
    await _reloadPrimaryTabsAfterCountryChange();
    unawaited(loadPicker(country: code));
  }

  Future<void> _reloadPrimaryTabsAfterCountryChange() async {
    LocaleRefresh.bumpCountry();
    try {
      if (Get.isRegistered<SplashController>()) {
        await Get.find<SplashController>().getConfigData();
      }
      await parser.fetchConfig(lang: languageCode, country: countryCode);
    } catch (e) {
      debugPrint('reload config after country failed: $e');
    }

    try {
      if (Get.isRegistered<ServiceCartController>()) {
        Get.find<ServiceCartController>().calcuate();
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<ProductCartController>()) {
        Get.find<ProductCartController>().update();
      }
    } catch (_) {}

    dropSecondaryCountryControllers();

    try {
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        home.currencySide = home.parser.getCurrencySide();
        home.currencySymbol = home.parser.getCurrencySymbol();
        home.markCountryFresh();
        unawaited(home.getHomeData());
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<NearController>()) {
        final near = Get.find<NearController>();
        near.markCountryFresh();
        unawaited(near.getHomeData());
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<CategoriesController>()) {
        final categories = Get.find<CategoriesController>();
        categories.currencySide = categories.parser.getCurrencySide();
        categories.currencySymbol = categories.parser.getCurrencySymbol();
        categories.markCountryFresh();
        unawaited(categories.getAllCategories());
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<BookingController>()) {
        final booking = Get.find<BookingController>();
        booking.currencySide = booking.parser.getCurrencySide();
        booking.currencySymbol = booking.parser.getCurrencySymbol();
        booking.markCountryFresh();
        if (booking.parser.haveLoggedIn()) {
          unawaited(booking.getAppointmentById());
        } else {
          booking.update();
        }
      }
    } catch (_) {}
    try {
      if (Get.isRegistered<AccountController>()) {
        Get.find<AccountController>().markCountryFresh();
        Get.find<AccountController>().changeInfo();
      }
    } catch (_) {}

    _notifyAppUi();
  }

  void _applyLocalLanguage(String code, {required bool persist}) {
    final pool = allLanguages.isNotEmpty ? allLanguages : languages;
    final selected = pool.firstWhere(
      (e) => e.languageCode == code,
      orElse: () => LanguageModel.fromJson({'code': code}),
    );

    languageCode = code;
    isRtl = selected.isRtl || LocaleHelper.isRtlCode(code);
    direction = selected.direction ?? LocaleHelper.directionForCode(code);

    if (persist) {
      parser.saveLanguage(code);
      parser.saveDirection(direction);
      parser.saveIsRtl(isRtl);
    }

    LocaleHelper.applyLocale(code, isRtl: isRtl);
  }

  void saveLanguages(String code) {
    changeLanguage(code);
  }

  void showLanguagePicker() => showLocaleSettings();

  void showCountryPicker() => showLocaleSettings(initialTab: 1);

  bool _ensureLoggedInForCountry() {
    if (parser.haveLoggedIn()) return true;
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    Get.delete<LoginController>(force: true);
    Get.toNamed(AppRouter.getLoginRoute());
    return false;
  }

  void showLocaleSettings({int initialTab = 0}) {
    if (initialTab == 1 && !_ensureLoggedInForCountry()) return;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isClosed) return;
      // Checklist: call getActiveCountries on language/country screen
      unawaited(loadPicker(country: countryCode));
      Get.bottomSheet(
        _LocaleSettingsSheet(initialTab: initialTab),
        isScrollControlled: true,
        isDismissible: !loading,
      );
    });
  }
}

class _LocaleSettingsSheet extends StatefulWidget {
  final int initialTab;

  const _LocaleSettingsSheet({this.initialTab = 0});

  @override
  State<_LocaleSettingsSheet> createState() => _LocaleSettingsSheetState();
}

class _LocaleSettingsSheetState extends State<_LocaleSettingsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
    _tabController.addListener(() {
      if (_tabController.index != 1) return;
      if (!Get.isRegistered<LanguagesController>()) return;
      final locale = Get.find<LanguagesController>();
      if (locale.parser.haveLoggedIn()) return;
      if (_tabController.index != 0) {
        _tabController.index = 0;
      }
      locale.showLocaleSettings(initialTab: 1);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (locale) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: ThemeProvider.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Preferences'.tr,
                style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
              ),
              const SizedBox(height: 14),
              TabBar(
                controller: _tabController,
                indicatorColor: ThemeProvider.gold,
                labelColor: ThemeProvider.gold,
                unselectedLabelColor: ThemeProvider.greyColor,
                labelStyle: ThemeProvider.sans(
                  size: 13,
                  weight: FontWeight.w700,
                ),
                tabs: [
                  Tab(text: 'Language'.tr),
                  Tab(text: 'Country/Region'.tr),
                ],
              ),
              const SizedBox(height: 8),
              if (locale.loading)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              else
                SizedBox(
                  height: 280,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _languageList(locale),
                      _countryList(locale),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _languageList(LanguagesController locale) {
    final list =
        locale.languages.isNotEmpty ? locale.languages : locale.allLanguages;
    return ListView(
      shrinkWrap: true,
      children: list
          .map(
            (l) => RadioListTile<String>(
              value: l.languageCode,
              groupValue: locale.languageCode,
              activeColor: ThemeProvider.gold,
              title: Text(l.displayName, style: ThemeProvider.sans(size: 15)),
              subtitle: l.nativeName != null && l.nativeName != l.languageName
                  ? Text(
                      l.languageName,
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ),
                    )
                  : null,
              onChanged: locale.loading
                  ? null
                  : (code) async {
                      if (code == null) return;
                      await locale.changeLanguage(code);
                    },
            ),
          )
          .toList(),
    );
  }

  Widget _countryList(LanguagesController locale) {
    final list = locale.countries.isNotEmpty
        ? locale.countries
        : AppConstants.defaultCountries;

    return ListView(
      shrinkWrap: true,
      children: list
          .map(
            (c) => RadioListTile<String>(
              value: c.code,
              groupValue: locale.countryCode,
              activeColor: ThemeProvider.gold,
              title: Text(c.displayName, style: ThemeProvider.sans(size: 15)),
              subtitle: c.countryCode.isNotEmpty
                  ? Text(
                      c.countryCode,
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ),
                    )
                  : null,
              onChanged: locale.loading
                  ? null
                  : (code) async {
                      if (code == null) return;
                      await locale.changeCountry(code);
                    },
            ),
          )
          .toList(),
    );
  }
}
