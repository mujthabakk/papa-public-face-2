import 'package:flutter/foundation.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/checkout_payment_model.dart';
import 'package:salon_user/app/backend/models/payment_options_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class PaymentParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  PaymentParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> salonDetails(var body) async {
    return await apiService.postPublic(
      AppConstants.salonDetails,
      body,
    );
  }

  Future<Response> getPremium(var body) async {
    return await apiService.postPublic(AppConstants.checkPremium, body);
  }

  Future<Response> getPayments() async {
    var response = await apiService.getPrivate(AppConstants.getPayments,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> createAppoinments(var body) async {
    return await apiService.postPrivate(AppConstants.createAppointments, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getInstaMojoPayLink(var param) async {
    return await apiService.postPrivate(AppConstants.payWithInstaMojo, param,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> getSavedAddress(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSavedAddress,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  String getUID() {
    return sharedPreferencesManager.getString('uid') ?? '';
  }

  String getEmail() {
    return sharedPreferencesManager.getString('email') ?? '';
  }

  String getPhone() {
    return sharedPreferencesManager.getString('phone') ?? '';
  }

  String getName() {
    String firstName = sharedPreferencesManager.getString('first_name') ?? '';
    String lastName = sharedPreferencesManager.getString('last_name') ?? '';
    return '$firstName $lastName';
  }

  String getFirstName() {
    return sharedPreferencesManager.getString('first_name') ?? '';
  }

  String getLastName() {
    return sharedPreferencesManager.getString('last_name') ?? '';
  }

  String getAppLogo() {
    return sharedPreferencesManager.getString('appLogo') ?? '';
  }

  String getCurrencyCode() {
    return sharedPreferencesManager.getString('currencyCode') ??
        AppConstants.defaultCurrencyCode;
  }

  String getCurrencySide() {
    return sharedPreferencesManager.getString('currencySide') ??
        AppConstants.defaultCurrencySide;
  }

  String getCurrencySymbol() {
    return sharedPreferencesManager.getString('currencySymbol') ??
        AppConstants.defaultCurrencySymbol;
  }

  Future<Response> getMyWalletBalance() async {
    return await apiService.postPrivate(
        AppConstants.getMyWalletBalance,
        {'id': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> checkCod() async {
    return await apiService.postPrivate(
        AppConstants.checkCod,
        {'uid': sharedPreferencesManager.getString('uid')},
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> verifyRazorPurchase(var payKey) async {
    return await apiService.getPrivate(
        AppConstants.verifyRazorPayments + payKey,
        sharedPreferencesManager.getString('token') ?? '');
  }

  int? getUidInt() {
    final uid = sharedPreferencesManager.getString('uid');
    if (uid == null || uid.isEmpty) return null;
    return int.tryParse(uid);
  }

  String getToken() => sharedPreferencesManager.getString('token') ?? '';

  /// Send ONLY uid + book_id.
  Future<({bool success, String message, PaymentOptionsModel? data})>
      getPaymentOptions({required int bookId}) async {
    final uid = getUidInt();
    if (uid == null) {
      return (
        success: false,
        message: 'Please log in to continue.',
        data: null
      );
    }
    final response = await apiService.postPrivate(
      AppConstants.paymentsGetPaymentOptions,
      {'uid': uid, 'book_id': bookId},
      getToken(),
    );
    return _parsePaymentOptions(response);
  }

  Future<({bool success, String message, PaymentOptionsModel? data})>
      getPaymentStatus({required int bookId}) async {
    final uid = getUidInt();
    if (uid == null) {
      return (
        success: false,
        message: 'Please log in to continue.',
        data: null
      );
    }
    final response = await apiService.postPrivate(
      AppConstants.paymentsGetStatus,
      {'uid': uid, 'book_id': bookId},
      getToken(),
    );
    return _parsePaymentOptions(response);
  }

  /// Complete-service payload for the logged-in user. Send uid only.
  Future<List<Map<String, dynamic>>> getCompleteServiceNotification() async {
    final uid = getUidInt();
    if (uid == null) return [];
    final response = await apiService.postPrivate(
      AppConstants.paymentsGetCompleteServiceNotification,
      {'uid': uid},
      getToken(),
    );
    final map = ApiBody.asMap(response.body);
    if (map == null || map['success'] != true) return [];
    final data = map['data'];
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }
    if (data is Map) {
      return [Map<String, dynamic>.from(data)];
    }
    return [];
  }

  ({bool success, String message, PaymentOptionsModel? data})
      _parsePaymentOptions(Response response) {
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
      data: PaymentOptionsModel.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Future<PaymentSocketConfig> getSocketConfig() async {
    final uid = getUidInt();
    try {
      final token = getToken();
      // Must send uid + Bearer — the backend keys the per-customer channel
      // (payment-status-<uid>) off this uid.
      final Response response;
      if (uid != null && token.isNotEmpty) {
        response = await apiService.postPrivate(
          AppConstants.paymentsSocketConfig,
          {'uid': uid},
          token,
        );
      } else {
        response = await apiService.postPublic(
          AppConstants.paymentsSocketConfig,
          {},
        );
      }
      final map = ApiBody.asMap(response.body);
      final data = map != null ? ApiBody.asObject(map['data']) : null;
      if (data != null) {
        return PaymentSocketConfig.fromJson(data, uid: uid);
      }
    } catch (e) {
      debugPrint('getSocketConfig failed, using defaults: $e');
    }
    return PaymentSocketConfig.defaults(uid: uid);
  }

  Future<({bool success, String message, CheckoutPaymentUrlData? data})>
      generateCheckoutPaymentUrl({
    required int appointmentId,
    double? amount,
  }) async {
    final uid = getUidInt();
    if (uid == null) {
      return (
        success: false,
        message: 'Please log in to continue.',
        data: null,
      );
    }

    // Backend charges stored INR grand_total. Do not send converted QAR.
    final payload = <String, dynamic>{
      'uid': uid,
      'user_id': uid,
      'appointment_id': appointmentId,
      'book_id': appointmentId,
    };

    final response = await apiService.postPrivate(
      AppConstants.paymentsPayNow,
      payload,
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
    if (map['success'] != true) {
      final legacy = await apiService.postPrivate(
        AppConstants.paymentsGeneratePaymentUrl,
        payload,
        getToken(),
      );
      return _parsePayUrl(legacy);
    }
    return _parsePayUrl(response);
  }

  ({bool success, String message, CheckoutPaymentUrlData? data}) _parsePayUrl(
      Response response) {
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
      data: CheckoutPaymentUrlData.fromJson(
        Map<String, dynamic>.from(data),
      ),
    );
  }

  Future<({bool success, String message, CheckoutVerifyData? data})>
      verifyCheckoutPayment({
    required int appointmentId,
    String? paymentLinkId,
  }) async {
    final uid = getUidInt();
    if (uid == null) {
      return (
        success: false,
        message: 'Please log in to continue.',
        data: null,
      );
    }

    final body = <String, dynamic>{
      'uid': uid,
      'book_id': appointmentId,
      'appointment_id': appointmentId,
    };
    if (paymentLinkId != null && paymentLinkId.isNotEmpty) {
      body['payment_link_id'] = paymentLinkId;
    }

    final response = await apiService.postPrivate(
      AppConstants.paymentsVerifyCheckoutPayment,
      body,
      getToken(),
    );
    final map = ApiBody.asMap(response.body);
    if (map == null ||
        (map['success'] != true && response.statusCode != 200)) {
      final legacy = await apiService.postPrivate(
        AppConstants.paymentsVerifyPayment,
        body,
        getToken(),
      );
      return _parseVerify(legacy);
    }
    return _parseVerify(response);
  }

  ({bool success, String message, CheckoutVerifyData? data}) _parseVerify(
      Response response) {
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
      data: CheckoutVerifyData.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
