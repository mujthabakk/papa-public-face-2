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

  String getToken() {
    return sharedPreferencesManager.getString('token') ?? '';
  }

  Future<Response> getAllNotification(String uid) async {
    return await apiService.postPrivate(
      AppConstants.commonNotificationAll,
      {'uid': uid},
      getToken(),
    );
  }

  /// Mark one notification as read.
  Future<Response> readNotification({
    required int notificationId,
    required String uid,
  }) async {
    return await apiService.postPrivate(
      AppConstants.readNotificationAll,
      {
        'id': notificationId,
        'notification_id': notificationId,
        'uid': uid,
      },
      getToken(),
    );
  }

  /// Mark all notifications as read for this user (if backend supports).
  Future<Response> readAllNotifications({required String uid}) async {
    return await apiService.postPrivate(
      AppConstants.readNotificationAll,
      {
        'uid': uid,
        'all': 1,
        'mark_all': 1,
      },
      getToken(),
    );
  }
}
