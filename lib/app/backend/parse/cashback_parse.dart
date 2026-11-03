import 'package:flutter/foundation.dart';
import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/cashback_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class CashbackParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  CashbackParser({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  /// POST cashback/getByUserType. Returns null on 404 / inactive / error.
  Future<CashbackSetting?> getByUserType(String userType) async {
    try {
      final response = await apiService.postPublic(
        AppConstants.cashbackGetByUserType,
        {'user_type': userType},
      );
      if (response.statusCode == 404) return null;
      final map = ApiBody.asMap(response.body);
      if (map == null) return null;
      if (map['success'] == false) return null;
      final data = map['data'];
      if (data is! Map) return null;
      final row = CashbackSetting.fromJson(Map<String, dynamic>.from(data));
      if (!row.isActive) return null;
      return row;
    } catch (e) {
      debugPrint('cashback getByUserType: $e');
      return null;
    }
  }

  Future<double> percentFor(String userType) async {
    final row = await getByUserType(userType);
    return row?.percentage ?? 0;
  }
}
