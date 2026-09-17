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
      showToast(_connectionMessage(response.statusText));
      return;
    }
    final message = ApiBody.message(response);
    if (message != null && message.isNotEmpty) {
      // Backend already returns localized message when lang is set.
      showToast(message);
      return;
    }
    final code = response.statusCode ?? 0;
    if (code >= 500) {
      debugPrint('API $code ${response.statusText ?? ''}');
      return;
    }
    showToast('Something went wrong!'.tr);
  }

  static String _connectionMessage(String? text) {
    final raw = (text ?? '').toLowerCase();
    if (raw.contains('clientexception') ||
        raw.contains('socket') ||
        raw.contains('network is unreachable') ||
        raw.contains('failed host lookup') ||
        raw.contains('connection failed') ||
        raw.contains('timed out') ||
        raw.contains('timeout')) {
      return 'No Internet Connection'.tr;
    }
    if (text != null &&
        text.isNotEmpty &&
        !text.contains('Exception') &&
        text.length < 80) {
      return text.tr;
    }
    return 'Connection failed!'.tr;
  }
}
