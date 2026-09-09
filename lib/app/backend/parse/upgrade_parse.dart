import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/upgrade_payment_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class UpgradeParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  UpgradeParser({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  int? getUidInt() {
    final uid = sharedPreferencesManager.getString('uid');
    if (uid == null || uid.isEmpty) return null;
    return int.tryParse(uid);
  }

  String getToken() => sharedPreferencesManager.getString('token') ?? '';

  Future<({bool success, String message, UpgradePaymentUrlData? data})>
      generatePaymentUrl({
    required int planId,
    double? planAmount,
  }) async {
    final uid = getUidInt();
    if (uid == null) {
      return (success: false, message: 'Please log in to continue.', data: null);
    }
    final body = <String, dynamic>{
      'uid': uid,
      'plan_id': planId,
    };
    if (planAmount != null) body['plan_amount'] = planAmount;

    final response = await apiService.postPrivate(
      AppConstants.upgradeGeneratePaymentUrl,
      body,
      getToken(),
    );
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (
        success: false,
        message: ApiService.connectionIssue,
        data: null,
      );
    }
    final message = map['message']?.toString() ?? '';
    if (map['success'] != true) {
      return (success: false, message: message, data: null);
    }
    final data = map['data'];
    if (data is! Map) {
      return (success: false, message: message, data: null);
    }
    return (
      success: true,
      message: message,
      data: UpgradePaymentUrlData.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Future<({bool success, String message, UpgradeVerifyData? data})>
      verifyPayment({
    int? orderId,
    String? paymentLinkId,
  }) async {
    final uid = getUidInt();
    if (uid == null) {
      return (success: false, message: 'Please log in to continue.', data: null);
    }
    final body = <String, dynamic>{'uid': uid};
    if (orderId != null && orderId > 0) {
      body['order_id'] = orderId;
    } else if (paymentLinkId != null && paymentLinkId.isNotEmpty) {
      body['payment_link_id'] = paymentLinkId;
    }

    final response = await apiService.postPrivate(
      AppConstants.upgradeVerifyPayment,
      body,
      getToken(),
    );
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (
        success: false,
        message: ApiService.connectionIssue,
        data: null,
      );
    }
    final message = map['message']?.toString() ?? '';
    if (map['success'] != true) {
      return (success: false, message: message, data: null);
    }
    final data = map['data'];
    if (data is! Map) {
      return (success: false, message: message, data: null);
    }
    return (
      success: true,
      message: message,
      data: UpgradeVerifyData.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
