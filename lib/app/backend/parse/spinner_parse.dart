import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/spinner_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class SpinnerParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  SpinnerParser({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  bool isLoggedIn() {
    final uid = sharedPreferencesManager.getString('uid');
    final token = sharedPreferencesManager.getString('token');
    return uid != null &&
        uid.isNotEmpty &&
        token != null &&
        token.isNotEmpty;
  }

  int? getUidInt() {
    final uid = sharedPreferencesManager.getString('uid');
    if (uid == null || uid.isEmpty) return null;
    return int.tryParse(uid);
  }

  Map<String, dynamic> _uidBody() {
    return {'uid': getUidInt()};
  }

  Future<Response> getStatusRaw() async {
    return apiService.postPrivate(
      AppConstants.spinnerGetStatus,
      _uidBody(),
      sharedPreferencesManager.getString('token') ?? '',
    );
  }

  Future<Response> spinRaw() async {
    return apiService.postPrivate(
      AppConstants.spinnerSpin,
      _uidBody(),
      sharedPreferencesManager.getString('token') ?? '',
    );
  }

  Future<Response> redeemRaw() async {
    return apiService.postPrivate(
      AppConstants.spinnerRedeem,
      _uidBody(),
      sharedPreferencesManager.getString('token') ?? '',
    );
  }

  Future<SpinnerStatus?> fetchStatus() async {
    if (!isLoggedIn()) return null;
    final response = await getStatusRaw();
    final map = ApiBody.asMap(response.body);
    if (map == null || map['success'] != true) return null;
    final data = map['data'];
    if (data is! Map) return null;
    return SpinnerStatus.fromJson(Map<String, dynamic>.from(data));
  }

  Future<({bool success, String message, SpinnerSpinResult? data})> spin() async {
    final response = await spinRaw();
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (success: false, message: ApiService.connectionIssue, data: null);
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
      data: SpinnerSpinResult.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Future<({bool success, String message, SpinnerRedeemResult? data})> redeem() async {
    final response = await redeemRaw();
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (success: false, message: ApiService.connectionIssue, data: null);
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
      data: SpinnerRedeemResult.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
