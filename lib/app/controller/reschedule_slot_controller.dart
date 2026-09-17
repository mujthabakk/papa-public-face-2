import 'dart:convert';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/bookedslot_model.dart';
import 'package:salon_user/app/backend/models/slot_time_model.dart';
import 'package:salon_user/app/backend/models/slots_model.dart';
import 'package:salon_user/app/backend/models/specialist_model.dart';
import 'package:salon_user/app/backend/parse/reschedule_slot_parse.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class RescheduleSlotController extends GetxController implements GetxService {
  final RescheduleSlotParser parser;

  String appointmentId = '';

  String uid = '';
  String type = '';

  bool selected = false;
  String savedDate = '';
  List<String> bookedSlots = [];
  bool haveData = false;
  String selectedSlotIndex = '';
  DatePickerController controller = DatePickerController();
  DateTime selectedValue = DateTime.now();
  List<String> dayList = [
    'Sunday'.tr,
    'Monday'.tr,
    'Tuesday'.tr,
    'Wednesday'.tr,
    'Thursday'.tr,
    'Friday'.tr,
    'Saturday'.tr
  ];

  bool isChecked = false;

  List<SpecialistModel> _specialistList = <SpecialistModel>[];
  List<SpecialistModel> get specialistList => _specialistList;

  bool apiCalled = false;

  SlotModel _slotList = SlotModel();
  SlotModel get slotList => _slotList;

  String selectedSpecialist = '';
  RescheduleSlotController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    appointmentId = Get.arguments[0].toString();
    uid = Get.arguments[1].toString();
    type = Get.arguments[2].toString();

    var dayName = Jiffy.now().format(pattern: "EEEE"); // Tuesday
    debugPrint(dayName);
    int index = dayList.indexOf(dayName);
    var date = Jiffy.now().format(pattern: 'yyyy-MM-dd');
    savedDate = date;
    update();
    getSlotsForBookings(index, date);

    getSpecialist();
  }

  Future<void> getSpecialist() async {
    var response = await parser.getSpecialist({"id": uid});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonSpecialist = myMap['data'];

      _specialistList = [];

      salonSpecialist.forEach((data) {
        SpecialistModel specialist = SpecialistModel.fromJson(data);
        _specialistList.add(specialist);
      });
      debugPrint(specialistList.length.toString());

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSlotsForBookings(int index, String date) async {
    var response = await parser.getSlots(
      {
        "week_id": index,
        "date": date,
        "uid": int.tryParse(uid) ?? uid,
        "from": type,
      },
    );
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      var booked = myMap['bookedSlots'];
      _slotList = SlotModel();

      if (body != null) {
        haveData = true;
        SlotModel datas = SlotModel.fromJson(body);

        // Decode `slots` correctly since it's a stringified JSON array
        if (body['slots'] != null &&
            body['slots'] != 'NA' &&
            body['slots'] != '') {
          List<dynamic> slotList = jsonDecode(body['slots']);
          datas.slots =
              slotList.map((slot) => SlotTimeModel.fromJson(slot)).toList();
        } else {
          datas.slots = []; // Ensure it's not null
        }

        // Get current date and time
        DateTime now = DateTime.now();
        String todayDate = DateFormat('yyyy-MM-dd').format(now);

        if (date == todayDate) {
          // Debugging: Print current time
          print("Current time: ${DateFormat('hh:mm a').format(now)}");

          // Filter out past slots
          datas.slots = datas.slots!.where((slot) {
            try {
              DateTime slotTime = DateFormat('hh:mm a').parse(slot.startTime!);
              DateTime currentTime = DateFormat('hh:mm a')
                  .parse(DateFormat('hh:mm a').format(now));

              bool isFutureSlot = slotTime.isAfter(currentTime);
              print(
                  "Checking slot: ${slot.startTime} => Allowed: $isFutureSlot");
              return isFutureSlot;
            } catch (e) {
              print("Error parsing time: ${slot.startTime}, Error: $e");
              return false; // If parsing fails, ignore this slot
            }
          }).toList();
        }

        _slotList = datas;
        update();
      }

      if (booked != null) {
        bookedSlots = [];
        booked.forEach((element) {
          BookedSlotModel slot = BookedSlotModel.fromJson(element);
          bookedSlots.add(slot.slot.toString());
        });
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  // Future<void> getSlotsForBookings(int index, String date) async {
  //   var response = await parser.getSlots(
  //     {"week_id": index, "date": date, "uid": uid, "from": type},
  //   );
  //   apiCalled = true;

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
  //     var body = myMap['data'];
  //     var booked = myMap['bookedSlots'];
  //     _slotList = SlotModel();
  //     if (body != null) {
  //       haveData = true;
  //       SlotModel datas = SlotModel.fromJson(body);
  //       _slotList = datas;
  //       update();
  //     }

  //     if (booked != null) {
  //       bookedSlots = [];
  //       booked.forEach((element) {
  //         BookedSlotModel slot = BookedSlotModel.fromJson(element);
  //         bookedSlots.add(slot.slot.toString());
  //       });
  //     }
  //   } else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  Color getColor(Set<MaterialState> states) {
    return ThemeProvider.appColor;
  }

  bool isBooked(String slot) {
    return bookedSlots.contains(slot) ? true : false;
  }

  void onSelectSlot(String slot) {
    if (!bookedSlots.contains(slot)) {
      selectedSlotIndex = slot;
      update();
    }
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onDateChange(DateTime date) {
    selectedSlotIndex = '';
    haveData = false;
    debugPrint(date.toString());
    var dayName = Jiffy.parseFromDateTime(date).format(pattern: "EEEE");
    var selectedDate = Jiffy.parseFromDateTime(date).format(pattern: 'yyyy-MM-dd');
    savedDate = selectedDate;
    update();
    debugPrint(dayName);
    int index = dayList.indexOf(dayName);
    debugPrint(index.toString());
    getSlotsForBookings(index, selectedDate);
  }

  void saveSpecialist(int id) {
    debugPrint(id.toString());
    selectedSpecialist = id.toString();
    update();
  }

  Future<void> onUpdateAppointmentStatus() async {
    if (selectedSlotIndex == '') {
      showToast('Please select Slots'.tr);
      return;
    }
    // if (selectedSpecialist == '') {
    //   showToast('Please select specialist'.tr);
    //   return;
    // }
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: ThemeProvider.gold)),
      barrierDismissible: false,
      barrierColor: const Color(0xB8000000),
    );
    var body = {
      "id": appointmentId,
      "save_date": savedDate,
      'slot': selectedSlotIndex
    };
    debugPrint(body.toString());
    Response response = await parser.onUpdateAppointmentStatus(body);
    Get.back();
    if (response.statusCode == 200) {
      showRescheduleSuccessDialog();
    } else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  void showRescheduleSuccessDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: ThemeProvider.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeProvider.greenColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: ThemeProvider.greenColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Appointment Rescheduled'.tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.serif(
                  size: 20,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your appointment has been successfully rescheduled. You will receive a confirmation email shortly.'
                    .tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                  size: 14,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: EliteGoldButton(
                  label: 'Goto Appointments'.tr,
                  onTap: _goToAppointments,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: const Color(0xB8000000),
    );
  }

  void _goToAppointments() {
    if (Get.isRegistered<BookingController>()) {
      Get.find<BookingController>().getAppointmentById();
    }
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Get.offNamedUntil(
      AppRouter.getBookingRoutes(),
      (route) =>
          route.settings.name == AppRouter.tabsBarRoutes || route.isFirst,
    );
  }

  // void onCheckout() {
  //   if (parser.isLogin() == true) {
  //     if (selectedSlotIndex == '' || selectedSlotIndex.isEmpty) {
  //       showToast('Please select Slot');
  //       return;
  //     }
  //     Get.delete<CheckoutController>(force: true);
  //     Get.toNamed(AppRouter.getCheckoutRoute());
  //   } else {
  //     debugPrint('go to login');
  //     Get.delete<CheckoutController>(force: true);
  //     Get.toNamed(AppRouter.getLoginRoute(), arguments: ['booking']);
  //   }
  // }
}
