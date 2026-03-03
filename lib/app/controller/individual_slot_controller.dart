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
import 'package:salon_user/app/backend/parse/individual_slot_parse.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/individual_payment_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class IndividualSlotController extends GetxController implements GetxService {
  final IndividualSlotParser parser;

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

  bool apiCalled = false;
  String uid = '';

  SlotModel _slotList = SlotModel();
  SlotModel get slotList => _slotList;

  IndividualSlotController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    if (Get.find<IndividualCheckoutController>()
            .savedInCart
            .services!
            .isNotEmpty ||
        Get.find<IndividualCheckoutController>()
            .savedInCart
            .packages!
            .isNotEmpty) {
      if (Get.find<IndividualCheckoutController>()
          .savedInCart
          .services!
          .isNotEmpty) {
        uid = Get.find<IndividualCheckoutController>()
            .savedInCart
            .services![0]
            .uid
            .toString();
      } else if (Get.find<IndividualCheckoutController>()
          .savedInCart
          .packages!
          .isNotEmpty) {
        uid = Get.find<IndividualCheckoutController>()
            .savedInCart
            .packages![0]
            .uid
            .toString();
      }

      var dayName = Jiffy.now().format(pattern: "EEEE"); // Tuesday
      debugPrint(dayName);
      int index = dayList.indexOf(dayName);
      var date = Jiffy.now().format(pattern: 'yyyy-MM-dd');
      savedDate = date;
      update();
      getSlotsForBookings(index, date);
    } else {
      onBack();
    }
  }

  // Future<void> getSlotsForBookings(int index, String date) async {
  //   var response = await parser.getSlots(
  //     {"week_id": index, "date": date, "uid": uid, "from": "individual"},
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

  //       // Decode `slots` correctly since it's a stringified JSON array
  //       if (body['slots'] != null &&
  //           body['slots'] != 'NA' &&
  //           body['slots'] != '') {
  //         List<dynamic> slotList = jsonDecode(body['slots']);
  //         datas.slots =
  //             slotList.map((slot) => SlotTimeModel.fromJson(slot)).toList();
  //       } else {
  //         datas.slots = []; // Ensure it's not null
  //       }

  //       // Get current date and time
  //       DateTime now = DateTime.now();
  //       String todayDate = DateFormat('yyyy-MM-dd').format(now);

  //       if (date == todayDate) {
  //         // Debugging: Print current time
  //         print("Current time: ${DateFormat('hh:mm a').format(now)}");

  //         // Filter out past slots
  //         datas.slots = datas.slots!.where((slot) {
  //           try {
  //             DateTime slotTime = DateFormat('hh:mm a').parse(slot.startTime!);
  //             DateTime currentTime = DateFormat('hh:mm a')
  //                 .parse(DateFormat('hh:mm a').format(now));

  //             bool isFutureSlot = slotTime.isAfter(currentTime);
  //             print(
  //                 "Checking slot: ${slot.startTime} => Allowed: $isFutureSlot");
  //             return isFutureSlot;
  //           } catch (e) {
  //             print("Error parsing time: ${slot.startTime}, Error: $e");
  //             return false; // If parsing fails, ignore this slot
  //           }
  //         }).toList();
  //       }

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

// Updated method with proper time sorting
  Future<void> getSlotsForBookings(int index, String date) async {
    var response = await parser.getSlots(
      {"week_id": index, "date": date, "uid": uid, "from": "individual"},
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

        // Sort slots by start time in ascending order
        if (datas.slots != null && datas.slots!.isNotEmpty) {
          datas.slots!.sort((a, b) {
            try {
              // Parse time strings to DateTime for proper comparison
              DateTime timeA = DateFormat('hh:mm a').parse(a.startTime!);
              DateTime timeB = DateFormat('hh:mm a').parse(b.startTime!);
              return timeA.compareTo(timeB);
            } catch (e) {
              print("Error sorting slots: $e");
              // If parsing fails, try string comparison as fallback
              return a.startTime!.compareTo(b.startTime!);
            }
          });

          print("Slots after sorting:");
          for (var slot in datas.slots!) {
            print(
                "${slot.startTime} - ${slot.endTime} (Available: ${slot.available})");
          }
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

// Helper method if you want to sort slots separately
  List<SlotTimeModel> sortSlotsByTime(List<SlotTimeModel> slots) {
    if (slots.isEmpty) return slots;

    List<SlotTimeModel> sortedSlots = List.from(slots);

    sortedSlots.sort((a, b) {
      try {
        // Convert 12-hour format to 24-hour for proper comparison
        DateTime timeA = DateFormat('hh:mm a').parse(a.startTime!);
        DateTime timeB = DateFormat('hh:mm a').parse(b.startTime!);

        return timeA.compareTo(timeB);
      } catch (e) {
        print("Error parsing time for sorting: $e");
        // Fallback to string comparison if parsing fails
        return a.startTime!.compareTo(b.startTime!);
      }
    });

    return sortedSlots;
  }

// Alternative helper method using 24-hour conversion
  DateTime convertTo24HourFormat(String time12Hour) {
    try {
      return DateFormat('hh:mm a').parse(time12Hour);
    } catch (e) {
      print("Error converting time format: $e");
      // Return a default time if parsing fails
      return DateTime(2000, 1, 1, 0, 0);
    }
  }

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

  void onPayment() {
    if (selectedSlotIndex == '') {
      showToast('Please select Slots'.tr);
      return;
    }

    Get.delete<IndividualPaymentController>(force: true);
    Get.toNamed(AppRouter.getIndividualPayment());
  }
}
