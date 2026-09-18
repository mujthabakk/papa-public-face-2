/*Papabear*/
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/models/profile_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  EditProfileParser(
      {required this.sharedPreferencesManager, required this.apiService});

  Future<Response> getUserByID(var body) async {
    var response = await apiService.postPrivate(AppConstants.getUserByID, body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> uploadImage(XFile data) async {
    return await apiService
        .uploadFiles(AppConstants.uploadImage, [MultipartBody('image', data)]);
  }

  Future<Response> onUpdateInfo(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateInfo, body,
        sharedPreferencesManager.getString('token') ?? '');
    sharedPreferencesManager.putString('cover', body['cover']);
    sharedPreferencesManager.putString('first_name', body['first_name']);
    sharedPreferencesManager.putString('last_name', body['last_name']);
    return response;
  }

  Future<Response> onUpdateCover(var body) async {
    var response = await apiService.postPrivate(AppConstants.updateInfo, body,
        sharedPreferencesManager.getString('token') ?? '');
    sharedPreferencesManager.putString('cover', body['cover']);
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '0';
  }

  void savePlan(UserPlan? plan) {
    if (plan == null) return;
    sharedPreferencesManager.putString('plan_code', plan.code ?? '');
    sharedPreferencesManager.putString(
        'plan_is_premium', plan.isPremium ? '1' : '0');
    sharedPreferencesManager.putString(
        'plan_expires', plan.upgradeExpiresAt ?? '');
    sharedPreferencesManager.putString(
        'plan_released_access', plan.releasedAccess ?? '');
  }

  setCover(String cover) {
    sharedPreferencesManager.putString('cover', cover);
  }
}
