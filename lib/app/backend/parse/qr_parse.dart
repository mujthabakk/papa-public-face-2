import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class QrParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  QrParser({required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getPremium(var body) async {
    return await apiService.postPublic(AppConstants.checkPremium, body);
  }
}
