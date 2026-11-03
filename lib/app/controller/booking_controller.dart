import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/appointment_model.dart';
import 'package:salon_user/app/backend/parse/booking_parse.dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class BookingController extends GetxController
    with GetTickerProviderStateMixin, CountryScopedRefresh
    implements GetxService {
  final BookingParser parser;

  List<AppointmentModel> _appointmentList = <AppointmentModel>[];
  List<AppointmentModel> get appointmentList => _appointmentList;

  List<AppointmentModel> _appointmentListOld = <AppointmentModel>[];
  List<AppointmentModel> get appointmentListOld => _appointmentListOld;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<String> statusName = [
    'Created',
    'Accepted',
    'Rejected',
    'Ongoing',
    'Completed',
    'Cancelled',
    'Refunded',
    'Delayed',
    'Pending Payment',
  ];
  final Map<int, Color> statusColors = {
    0: Colors.blue, // Created
    1: Colors.green, // Accepted
    2: Colors.red, // Rejected
    3: Colors.orange, // Ongoing
    4: Colors.purple, // Completed
    5: Colors.grey, // Cancelled
    6: Colors.yellow, // Refunded
    7: Colors.brown, // Delayed
    8: Colors.teal, // Pending Payment
  };
  BookingController({required this.parser});

  bool apiCalled = false;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    tabController = TabController(length: 2, vsync: this);
    markCountryFresh();
    if (parser.haveLoggedIn() == true) {
      getAppointmentById();
    }
  }

  Future<void> getAppointmentById() async {
    try {
      final response = await parser.getAppointmentById().timeout(
        const Duration(seconds: 12),
        onTimeout: () => const Response(statusCode: 1, statusText: 'timeout'),
      );
      if (response.statusCode == 200 && response.body is Map) {
        final myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];
        _appointmentList = [];
        _appointmentListOld = [];
        final rows = body is List ? body : const [];
        for (final data in rows) {
          if (data is! Map) continue;
          try {
            final appointment = AppointmentModel.fromJson(
                Map<String, dynamic>.from(data));
            if (appointment.status == 0) {
              _appointmentList.add(appointment);
            } else {
              _appointmentListOld.add(appointment);
            }
          } catch (e) {
            debugPrint('appointment skip: $e');
          }
        }
      } else if (response.statusCode != 200 && response.statusCode != 1) {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('getAppointmentById: $e');
    } finally {
      apiCalled = true;
      update();
    }
  }

  void onAppointment(int id) {
    Get.delete<AppointmentDetailController>(force: true);
    Get.toNamed(AppRouter.getAppointmentDetailRoutes(), arguments: [id]);
  }

  void bookAgain(AppointmentModel a) {
    final salonId = a.salonId ?? 0;
    final freelancerId = a.freelancerId ?? 0;
    if (salonId != 0) {
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(), arguments: [salonId]);
      return;
    }
    if (freelancerId != 0) {
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [freelancerId]);
    }
  }

  void onLoginRoutes() {
    Get.delete<LoginController>(force: true);
    AppRouter.openLogin();
  }
}
