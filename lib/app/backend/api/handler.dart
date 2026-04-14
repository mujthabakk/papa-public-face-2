import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/toast.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
    } else if (response.statusCode == 1 || response.statusCode == 0) {
      showToast(response.statusText?.tr ?? 'Connection failed!'.tr);
    } else {
      String message = 'Something went wrong!'.tr;
      try {
        if (response.bodyString != null) {
          var body = jsonDecode(response.bodyString!);
          message = body['message'] ?? message;
        }
      } catch (e) {
        debugPrint('ApiChecker Decode Error: \$e');
      }
      showToast(message.tr);
    }
  }
}
