import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/util/toast.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
      return;
    }
    if (response.statusCode == 1 || response.statusCode == 0) {
      showToast(response.statusText?.tr ?? 'Connection failed!'.tr);
      return;
    }
    final message = ApiBody.message(response);
    if (message != null && message.isNotEmpty) {
      showToast(message.tr);
      return;
    }
    final code = response.statusCode ?? 0;
    if (code >= 500) {
      debugPrint('API $code ${response.statusText ?? ''}');
      return;
    }
    showToast('Something went wrong!'.tr);
  }
}
