import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/constant.dart';

class RescheduleSlotParser {
  final SharedPreferencesManager sharedPreferencesManager;
  final ApiService apiService;

  RescheduleSlotParser(
      {required this.apiService, required this.sharedPreferencesManager});

  Future<Response> getSlots(var body) {
    return apiService.postPrivate(AppConstants.getSlotsForBookings, body,
        sharedPreferencesManager.getString('token') ?? '');
  }

  Future<Response> onUpdateAppointmentStatus(var body) async {
    var response = await apiService.postPrivate(
        AppConstants.updateAppointmentStatus,
        body,
        sharedPreferencesManager.getString('token') ?? '');
    return response;
  }

  Future<Response> getSpecialist(var body) async {
    var response = await apiService.postPrivate(AppConstants.getSpecislistById,
        body, sharedPreferencesManager.getString('token') ?? '');
    return response;
  }
}
