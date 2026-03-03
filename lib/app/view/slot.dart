// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:salon_user/app/controller/slot_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';

// class SlotScreen extends StatefulWidget {
//   const SlotScreen({Key? key}) : super(key: key);

//   @override
//   State<SlotScreen> createState() => _SlotScreenState();
// }

// class _SlotScreenState extends State<SlotScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<SlotController>(
//       builder: (value) {
//         return Scaffold(
//           backgroundColor: ThemeProvider.whiteColor,
//           appBar: AppBar(
//             backgroundColor: ThemeProvider.appColor,
//             elevation: 0,
//             iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//             titleSpacing: 0,
//             centerTitle: true,
//             title: Text(
//               'Slots'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: value.apiCalled == false
//               ? const Center(
//                   child:
//                       CircularProgressIndicator(color: ThemeProvider.appColor),
//                 )
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Select Date'.tr,
//                               style: const TextStyle(
//                                   fontFamily: 'bold', fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           height: 120,
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: ThemeProvider.whiteColor,
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: ThemeProvider.greyColor,
//                                 blurRadius: 5.0,
//                                 offset: Offset(0.7, 2.0),
//                               ),
//                             ],
//                           ),
//                           child: DatePicker(
//                             DateTime.now(),
//                             width: 60,
//                             height: 90,
//                             controller: value.controller,
//                             initialSelectedDate: DateTime.now(),
//                             selectionColor: ThemeProvider.appColor,
//                             selectedTextColor: Colors.white,
//                             activeDates: List.generate(
//                                 30,
//                                 (index) =>
//                                     DateTime.now().add(Duration(days: index))),
//                             onDateChange: (date) {
//                               value.onDateChange(date);
//                             },
//                           ),
//                         ),
//                         value.haveData == false
//                             ? Center(
//                                 child: Text('No Slots Found'.tr),
//                               )
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Select Slots'.tr,
//                                     style: const TextStyle(
//                                         fontFamily: 'bold', fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                         value.haveData == false
//                             ? const SizedBox()
//                             : Container(
//                                 width: double.infinity,
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: ThemeProvider.whiteColor,
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: ThemeProvider.greyColor,
//                                       blurRadius: 5.0,
//                                       offset: Offset(0.7, 2.0),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Wrap(
//                                   spacing: 6.0,
//                                   runSpacing: 6.0,
//                                   alignment: WrapAlignment.center,
//                                   children: List.generate(
//                                     value.slotList.slots!.length,
//                                     (i) => GestureDetector(
//                                       onTap: () {
//                                         value.onSelectSlot(
//                                             '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}');
//                                       },
//                                       child: Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             vertical: 8, horizontal: 4),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 8, vertical: 12),
//                                         decoration: BoxDecoration(
//                                           // color: Colors.white,
//                                           color: value.isBooked(
//                                                   '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}')
//                                               ? Colors.grey
//                                               : value.selectedSlotIndex ==
//                                                       '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}'
//                                                   ? ThemeProvider.appColor
//                                                   : Colors.white,

//                                           boxShadow: const [
//                                             BoxShadow(
//                                               offset: Offset(0, 0),
//                                               blurRadius: 6,
//                                               color:
//                                                   Color.fromRGBO(0, 0, 0, 0.16),
//                                             )
//                                           ],
//                                           borderRadius: const BorderRadius.all(
//                                               Radius.circular(50)),
//                                         ),
//                                         child: Text(
//                                           '${value.slotList.slots![i].startTime} to ${value.slotList.slots![i].endTime}',
//                                           style: TextStyle(
//                                               color: value.isBooked(
//                                                           '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}') ||
//                                                       value.selectedSlotIndex ==
//                                                           '${value.slotList.slots![i].startTime}-${value.slotList.slots![i].endTime}'
//                                                   ? Colors.white
//                                                   : Colors.black,
//                                               fontSize: 13),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Select Specialist'.tr,
//                               style: const TextStyle(
//                                   fontFamily: 'bold', fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: List.generate(
//                                 value.specialistList.length,
//                                 (index) => Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Column(
//                                         children: [
//                                           Stack(
//                                             clipBehavior: Clip.none,
//                                             alignment: Alignment.topRight,
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(5),
//                                                 child: SizedBox.fromSize(
//                                                   size:
//                                                       const Size.fromRadius(40),
//                                                   child: GestureDetector(
//                                                     onTap: () => value
//                                                         .saveSpecialist(value
//                                                             .specialistList[
//                                                                 index]
//                                                             .id as int),
//                                                     child: FadeInImage(
//                                                       image: NetworkImage(
//                                                           '${Environments.imageURL}${value.specialistList[index].cover}'),
//                                                       placeholder: const AssetImage(
//                                                           "assets/images/placeholder.jpeg"),
//                                                       imageErrorBuilder:
//                                                           (context, error,
//                                                               stackTrace) {
//                                                         return Image.asset(
//                                                             'assets/images/notfound.png',
//                                                             fit: BoxFit.cover);
//                                                       },
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: -12,
//                                                 right: -12,
//                                                 child: IconButton(
//                                                   onPressed: () {
//                                                     value.saveSpecialist(value
//                                                         .specialistList[index]
//                                                         .id as int);
//                                                   },
//                                                   icon: Icon(value
//                                                               .selectedSpecialist ==
//                                                           value
//                                                               .specialistList[
//                                                                   index]
//                                                               .id
//                                                               .toString()
//                                                       ? Icons
//                                                           .check_circle_outline
//                                                       : Icons.circle_outlined),
//                                                   color:
//                                                       ThemeProvider.greenColor,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 top: 10, bottom: 3),
//                                             child: Text(
//                                               '${value.specialistList[index].firstName} ${value.specialistList[index].lastName}',
//                                               style: const TextStyle(
//                                                   fontSize: 12,
//                                                   color:
//                                                       ThemeProvider.blackColor),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//           bottomNavigationBar: InkWell(
//             onTap: () {
//               value.onPayment();
//             },
//             child: Container(
//               height: 50,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 13.0),
//               decoration: const BoxDecoration(
//                 color: ThemeProvider.pink,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Make Payment'.tr,
//                     style: const TextStyle(
//                         color: ThemeProvider.whiteColor, fontSize: 17),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:salon_user/app/controller/slot_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({Key? key}) : super(key: key);

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  // App Colors
  static const Color primary = ThemeProvider.pink;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFCBD5E1);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: cardBackground,
            elevation: 0,
            iconTheme: const IconThemeData(color: textPrimary),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Book Appointment'.tr,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [borderLight, borderMedium],
                  ),
                ),
              ),
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 3,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Selection Section
                      _buildSectionTitle(
                          'Select Date'.tr, Icons.calendar_today),
                      const SizedBox(height: 12),
                      _buildDatePicker(value),
                      const SizedBox(height: 24),

                      // Time Slots Section
                      if (value.haveData) ...[
                        _buildSectionTitle(
                            'Available Slots'.tr, Icons.access_time),
                        const SizedBox(height: 12),
                        _buildTimeSlots(value),
                        const SizedBox(height: 24),
                      ] else ...[
                        _buildNoSlotsMessage(),
                        const SizedBox(height: 24),
                      ],

                      // Specialist Selection Section
                      if (value.specialistList.isNotEmpty) ...[
                        _buildSectionTitle(
                            'Choose Specialist'.tr, Icons.person),
                        const SizedBox(height: 12),
                        _buildSpecialistList(value),
                        const SizedBox(height: 80), // Bottom padding for button
                      ],
                    ],
                  ),
                ),
          bottomNavigationBar: _buildBottomButton(value),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(SlotController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferred date'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: DatePicker(
                DateTime.now(),
                width: 65,
                height: 90,
                controller: value.controller,
                initialSelectedDate: DateTime.now(),
                selectionColor: primary,
                selectedTextColor: Colors.white,
                dateTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
                dayTextStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
                monthTextStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
                activeDates: List.generate(
                  30,
                  (index) => DateTime.now().add(Duration(days: index)),
                ),
                onDateChange: (date) {
                  value.onDateChange(date);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots(SlotController value) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose your preferred time slot'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: List.generate(
                value.slotList.slots!.length,
                (i) => _buildTimeSlotChip(value, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotChip(SlotController value, int index) {
    final slot = value.slotList.slots![index];
    final slotTime = '${slot.startTime}-${slot.endTime}';
    final isBooked = value.isBooked(slotTime);
    final isSelected = value.selectedSlotIndex == slotTime;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isBooked) {
      backgroundColor = textLight.withOpacity(0.1);
      textColor = textLight;
      borderColor = textLight.withOpacity(0.3);
    } else if (isSelected) {
      backgroundColor = primary;
      textColor = Colors.white;
      borderColor = primary;
    } else {
      backgroundColor = cardBackground;
      textColor = textPrimary;
      borderColor = borderLight;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBooked ? null : () => value.onSelectSlot(slotTime),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: borderColor),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBooked) ...[
                Icon(
                  Icons.block,
                  size: 14,
                  color: textColor,
                ),
                const SizedBox(width: 6),
              ] else if (isSelected) ...[
                const Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                '${slot.startTime} to ${slot.endTime}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoSlotsMessage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.event_busy,
                color: warning,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No Slots Available'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select a different date to view available slots'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistList(SlotController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your preferred specialist'.tr,
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.specialistList.length,
                itemBuilder: (context, index) =>
                    _buildSpecialistCard(value, index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialistCard(SlotController value, int index) {
    final specialist = value.specialistList[index];
    final isSelected = value.selectedSpecialist == specialist.id.toString();

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => value.saveSpecialist(specialist.id as int),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? primary.withOpacity(0.1) : surfaceBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primary : borderLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected ? primary : borderLight,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: FadeInImage(
                          image: NetworkImage(
                              '${Environments.imageURL}${specialist.cover}'),
                          placeholder: const AssetImage(
                              "assets/images/placeholder.jpeg"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: surfaceBackground,
                              child: const Icon(
                                Icons.person,
                                color: textLight,
                                size: 30,
                              ),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: cardBackground, width: 2),
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${specialist.firstName} ${specialist.lastName}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? primary : textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(SlotController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => value.onPayment(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, primaryDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.payment,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Continue to Payment'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
