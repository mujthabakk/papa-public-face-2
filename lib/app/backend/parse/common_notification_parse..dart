import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class CommonNotificationParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CommonNotificationParser(
      {required this.apiService, required this.sharedPreferencesManager});

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  Future<Response> getAllNotification(var uid) async {
    return await apiService.postPrivate(AppConstants.commonNotificationAll,
        {'uid': uid}, sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> readNotification(var uid) async {
    return await apiService.postPrivate(AppConstants.readNotificationAll,
        {'id': uid}, sharedPreferencesManager.getString('token') ?? '');
  }
}
