import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

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
        DateTime? selected;
        try {
          selected = DateTime.parse(value.savedDate);
        } catch (_) {
          selected = DateTime.now();
        }
        final days = List.generate(
          14,
          (i) => DateTime.now().add(Duration(days: i)),
        );
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Reschedule Slots'.tr,
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Text(
                      'Select Date'.tr,
                      style: ThemeProvider.serif(
                          size: 18, color: ThemeProvider.gold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 92,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: days.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final d = days[i];
                          final isSel = selected != null &&
                              d.year == selected.year &&
                              d.month == selected.month &&
                              d.day == selected.day;
                          return GestureDetector(
                            onTap: () => value.onDateChange(d),
                            child: Container(
                              width: 62,
                              decoration: BoxDecoration(
                                color: isSel
                                    ? ThemeProvider.gold
                                    : ThemeProvider.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSel
                                      ? ThemeProvider.gold
                                      : const Color(0xFF2A2A2A),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat('MMM').format(d).toUpperCase(),
                                    style: ThemeProvider.sans(
                                      size: 10,
                                      color: isSel
                                          ? Colors.black
                                          : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  Text(
                                    '${d.day}',
                                    style: ThemeProvider.serif(
                                      size: 20,
                                      color:
                                          isSel ? Colors.black : Colors.white,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('E').format(d).toUpperCase(),
                                    style: ThemeProvider.sans(
                                      size: 10,
                                      color: isSel
                                          ? Colors.black
                                          : ThemeProvider.greyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Select Slots'.tr,
                      style: ThemeProvider.serif(
                          size: 18, color: ThemeProvider.gold),
                    ),
                    const SizedBox(height: 10),
                    if (value.haveData == false ||
                        (value.slotList.slots ?? []).isEmpty)
                      const EliteApiUnavailable(
                        title: 'No slots available',
                        subtitle: 'Please try another date.',
                        icon: Icons.event_busy_outlined,
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(value.slotList.slots!.length,
                            (i) {
                          final slot = value.slotList.slots![i];
                          final key = '${slot.startTime}-${slot.endTime}';
                          final booked = value.isBooked(key);
                          final selectedSlot = value.selectedSlotIndex == key;
                          return GestureDetector(
                            onTap: booked
                                ? null
                                : () => value.onSelectSlot(key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedSlot
                                    ? ThemeProvider.gold
                                    : ThemeProvider.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: booked
                                      ? const Color(0xFF2A2A2A)
                                      : selectedSlot
                                          ? ThemeProvider.gold
                                          : const Color(0xFF3A3A3A),
                                ),
                              ),
                              child: Text(
                                booked
                                    ? 'Booked'
                                    : '${slot.startTime} to ${slot.endTime}',
                                style: ThemeProvider.sans(
                                  size: 12,
                                  weight: FontWeight.w600,
                                  color: booked
                                      ? ThemeProvider.greyColor
                                      : selectedSlot
                                          ? Colors.black
                                          : Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                  ],
                ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: EliteGoldButton(
                label: 'Reschedule Appointment'.tr,
                onTap: value.onUpdateAppointmentStatus,
              ),
            ),
          ),
        );
      },
    );
  }
}
