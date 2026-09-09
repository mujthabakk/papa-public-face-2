import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class SplashParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SplashParser(
      {required this.apiService, required this.sharedPreferencesManager});

  bool isNewUser() {
    return sharedPreferencesManager.getBool('welcome');
  }

  /// True when the user already picked a usable location (skip choose-location).
  bool hasSavedLocation() {
    final lat = sharedPreferencesManager.getDouble('lat') ?? 0.0;
    final lng = sharedPreferencesManager.getDouble('lng') ?? 0.0;
    final address =
        (sharedPreferencesManager.getString('address') ?? '').trim();
    return lat != 0.0 && lng != 0.0 && address.isNotEmpty;
  }

  Future<bool> initAppSettings() {
    return Future.value(true);
  }

  void saveWelcome(bool value) {
    sharedPreferencesManager.putBool('welcome', value);
  }

  Future<Response> getAppSettings() async {
    return apiService.getPublic(AppConstants.getAppSettings);
  }

  Future<Response> getAppSettingsByLanguage(String lang) async {
    return apiService.postPublic(
      AppConstants.getAppSettingsByLanguageId,
      {'lang': lang},
    );
  }

  String getLanguagesCode() {
    return sharedPreferencesManager.getString('language') ?? 'en';
  }

  void saveBasicInfo(
      var currencyCode,
      var currencySide,
      var currencySymbol,
      var smsName,
      var verifyWith,
      var userLogin,
      var supportEmail,
      var appName,
      var shipping,
      var shippingPrice,
      var tax,
      var appLogo,
      var supportName,
      var supportId,
      var supportPhone,
      var allowDistance,
      var serviceCharge) {
    sharedPreferencesManager.putString('currencyCode', currencyCode);
    sharedPreferencesManager.putString('currencySide', currencySide);
    sharedPreferencesManager.putString('currencySymbol', currencySymbol);
    sharedPreferencesManager.putString('smsName', smsName);
    sharedPreferencesManager.putInt('user_verify_with', verifyWith);
    sharedPreferencesManager.putInt('userLogin', userLogin);
    sharedPreferencesManager.putString('supportEmail', supportEmail);
    sharedPreferencesManager.putString('appName', appName);
    sharedPreferencesManager.putInt('shipping', shipping);
    sharedPreferencesManager.putDouble('shippingPrice', shippingPrice);
    sharedPreferencesManager.putDouble('tax', tax);
    sharedPreferencesManager.putString('appLogo', appLogo);
    sharedPreferencesManager.putInt('supportUID', supportId);
    sharedPreferencesManager.putString('supportName', supportName);
    sharedPreferencesManager.putString('supportPhone', supportPhone);
    sharedPreferencesManager.putDouble('allowDistance', allowDistance);
    sharedPreferencesManager.putDouble('serviceCharge', serviceCharge);
  }

  void saveDeviceToken(String token) {
    sharedPreferencesManager.putString('fcm_token', token);
  }
}
