import 'dart:convert';

import 'package:get/get.dart';
import 'package:salon_user/app/util/toast.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      showToast('Session expired!'.tr);
    } else {
      var body = jsonDecode(response.bodyString!);
      String message = body['message'] ?? 'Something went wrong!';
      showToast(message.toString().tr);
    }
  }
}
