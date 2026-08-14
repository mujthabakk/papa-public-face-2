import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class RescheduleSlotScreen extends StatefulWidget {
  const RescheduleSlotScreen({Key? key}) : super(key: key);

  @override
  State<RescheduleSlotScreen> createState() => _RescheduleSlotScreenState();
}

class _RescheduleSlotScreenState extends State<RescheduleSlotScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RescheduleSlotController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Reschedule Slots'.tr,
              style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Select Date'.tr,
                              style: const TextStyle(
                                  fontFamily: 'bold', fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          height: 120,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: ThemeProvider.whiteColor,
                            boxShadow: const [
                              BoxShadow(
                                color: ThemeProvider.greyColor,
                                blurRadius: 5.0,
                                offset: Offset(0.7, 2.0),
                              ),
                            ],
                          ),
                          child: DatePicker(
                            DateTime.now(),
                            width: 60,
                            height: 90,
                            controller: value.controller,
                            initialSelectedDate: DateTime.now(),
                            selectionColor: ThemeProvider.gold,
                            selectedTextColor: Colors.black,
                            activeDates: List.generate(
                                30,
                                (index) =>
                                    DateTime.now().add(Duration(days: index))),
                            onDateChange: (date) {
                              value.onDateChange(date);
                            },
                          ),
                        ),
                        value.haveData == false
                            ? Center(
                                child: Text('No Slots Found'.tr),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Slots'.tr,
                                    style: const TextStyle(
                                        fontFamily: 'bold', fontSize: 14),
                                  ),
                                ],
                              ),
                        value.haveData == false
                            ? const SizedBox()
                            : Container(
                                width: double.infinity,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ThemeProvider.whiteColor,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: ThemeProvider.greyColor,
                                      blurRadius: 5.0,
                                      offset: Offset(0.7, 2.0),
                                    ),
                                  ],
                                ),
                                child: Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(
                                    value.slotList.slots!.length,
                                    (i) => GestureDetector(
                                      onTap: () {
                                        value.onSelectSlot(
                                            '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}');
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        decoration: BoxDecoration(
                                          // color: Colors.white,
                                          color: value.isBooked(
                                                  '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}')
                                              ? Colors.grey
                                              : value.selectedSlotIndex ==
                                                      '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}'
                                                  ? ThemeProvider.appColor
                                                  : Colors.white,

                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 6,
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.16),
                                            )
                                          ],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        child: Text(
                                          '${value.slotList.slots![i].startTime} to ${value.slotList.slots![i].endTime}',
                                          style: TextStyle(
                                              color: value.isBooked(
                                                          '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}') ||
                                                      value.selectedSlotIndex ==
                                                          '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       'Select Specialist'.tr,
                        //       style: const TextStyle(
                        //           fontFamily: 'bold', fontSize: 14),
                        //     ),
                        //   ],
                        // ),
                        // SingleChildScrollView(
                        //   scrollDirection: Axis.horizontal,
                        //   child: Row(
                        //     children: List.generate(
                        //         value.specialistList.length,
                        //         (index) => Padding(
                        //               padding: const EdgeInsets.all(10.0),
                        //               child: Column(
                        //                 children: [
                        //                   Stack(
                        //                     clipBehavior: Clip.none,
                        //                     alignment: Alignment.topRight,
                        //                     children: [
                        //                       ClipRRect(
                        //                         borderRadius:
                        //                             BorderRadius.circular(5),
                        //                         child: SizedBox.fromSize(
                        //                           size:
                        //                               const Size.fromRadius(40),
                        //                           child: FadeInImage(
                        //                             image: NetworkImage(
                        //                                 '${Environments.imageURL}${value.specialistList[index].cover}'),
                        //                             placeholder: const AssetImage(
                        //                                 "assets/images/placeholder.jpeg"),
                        //                             imageErrorBuilder: (context,
                        //                                 error, stackTrace) {
                        //                               return Image.asset(
                        //                                   'assets/images/notfound.png',
                        //                                   fit: BoxFit.cover);
                        //                             },
                        //                             fit: BoxFit.cover,
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       Positioned(
                        //                         top: -12,
                        //                         right: -12,
                        //                         child: IconButton(
                        //                           onPressed: () {
                        //                             value.saveSpecialist(value
                        //                                 .specialistList[index]
                        //                                 .id as int);
                        //                           },
                        //                           icon: Icon(value
                        //                                       .selectedSpecialist ==
                        //                                   value
                        //                                       .specialistList[
                        //                                           index]
                        //                                       .id
                        //                                       .toString()
                        //                               ? Icons
                        //                                   .check_circle_outline
                        //                               : Icons.circle_outlined),
                        //                           color: ThemeProvider.appColor,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                   Padding(
                        //                     padding: const EdgeInsets.only(
                        //                         top: 10, bottom: 3),
                        //                     child: Text(
                        //                       '${value.specialistList[index].firstName} ${value.specialistList[index].lastName}',
                        //                       style: const TextStyle(
                        //                           fontSize: 12,
                        //                           color:
                        //                               ThemeProvider.blackColor),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             )),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
          bottomNavigationBar: InkWell(
            onTap: () {
              value.onUpdateAppointmentStatus();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13.0),
              decoration: const BoxDecoration(
                color: ThemeProvider.pink,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0),
                    child: Text(
                      'Reschedule Appointment'.tr,
                      style: const TextStyle(
                          color: ThemeProvider.whiteColor, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
