import 'package:geolocator/geolocator.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:get/get.dart';

class LoginParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  LoginParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Map<String, dynamic>> _withLoginLocation(dynamic body) async {
    final copy =
        body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    var lat = sharedPreferencesManager.getDouble('lat') ?? 0.0;
    var lng = sharedPreferencesManager.getDouble('lng') ?? 0.0;
    if (lat == 0.0 && lng == 0.0) {
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 4),
          ),
        );
        lat = pos.latitude;
        lng = pos.longitude;
        sharedPreferencesManager.putDouble('lat', lat);
        sharedPreferencesManager.putDouble('lng', lng);
      } catch (_) {}
    }
    if (lat != 0.0 && lng != 0.0) {
      copy['lat'] = lat;
      copy['lng'] = lng;
    }
    final country = sharedPreferencesManager.getString(LocaleHelper.prefCountry);
    if (country != null && country.isNotEmpty) {
      copy['country'] = country;
    }
    return copy;
  }

  Future<Response> onLogin(dynamic body) async {
    var response = await apiService.postPublic(
        AppConstants.onlogin, await _withLoginLocation(body));
    return response;
  }

  void saveToken(String token) {
    sharedPreferencesManager.putString('token', token);
  }

  void saveInfo(String id, String firstName, String lastName, String cover,
      String email, String mobile) {
    sharedPreferencesManager.putString('uid', id);
    sharedPreferencesManager.putString('first_name', firstName);
    sharedPreferencesManager.putString('last_name', lastName);
    sharedPreferencesManager.putString('email', email);
    sharedPreferencesManager.putString('cover', cover);
    sharedPreferencesManager.putString('phone', mobile);
  }

  void savePlanFromUser(Map<String, dynamic> user) {
    final planRaw = user['plan'];
    if (planRaw is! Map) return;
    final plan = Map<String, dynamic>.from(planRaw);
    sharedPreferencesManager.putString(
        'plan_code', plan['code']?.toString() ?? '');
    sharedPreferencesManager.putString(
        'plan_is_premium',
        (plan['is_premium'] == true || plan['is_premium']?.toString() == '1')
            ? '1'
            : '0');
    sharedPreferencesManager.putString(
        'plan_expires', plan['upgrade_expires_at']?.toString() ?? '');
    sharedPreferencesManager.putString(
        'plan_released_access', plan['released_access']?.toString() ?? '');
  }

  int userLogin() {
    return sharedPreferencesManager.getInt('userLogin') ??
        AppConstants.userLogin;
  }

  String smsName() {
    return sharedPreferencesManager.getString('smsName') ??
        AppConstants.defaultSMSGateway;
  }

  Future<Response> verifyPhoneWithFirebase(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhoneFirebase, param);
  }

  Future<Response> verifyPhone(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyPhone, param);
  }

  Future<Response> verifyOTP(dynamic param) async {
    return await apiService.postPublic(AppConstants.verifyOTP, param);
  }

  Future<Response> loginWithPhoneToken(dynamic param) async {
    return await apiService.postPublic(
        AppConstants.loginWithMobileToken, await _withLoginLocation(param));
  }

  Future<Response> updateProfile(var body, var token) async {
    var response =
        await apiService.postPrivate(AppConstants.updateFCM, body, token);
    return response;
  }

  String getFcmToken() {
    return sharedPreferencesManager.getString('fcm_token') ?? 'NA';
  }

  Future<Response> loginWithPhonePasswordPost(dynamic param) async {
    return await apiService.postPublic(
        AppConstants.loginWithPhonePassword, await _withLoginLocation(param));
  }
}
