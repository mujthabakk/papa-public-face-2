import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:salon_user/app/backend/models/appointment_model.dart';
import 'package:salon_user/app/controller/add_review_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _title(AppointmentModel a) {
    if (a.items?.services?.isNotEmpty == true) {
      return a.items!.services!.first.name ?? 'Appointment';
    }
    if (a.items?.packages?.isNotEmpty == true) {
      return a.items!.packages!.first.name ?? 'Appointment';
    }
    return a.salonInfo?.name ?? 'Appointment';
  }

  String _cover(AppointmentModel a) {
    if (a.items?.services?.isNotEmpty == true) {
      return a.items!.services!.first.cover ?? '';
    }
    if (a.items?.packages?.isNotEmpty == true) {
      return a.items!.packages!.first.cover ?? '';
    }
    return a.salonInfo?.cover ?? a.ownerInfo?.cover ?? '';
  }

  String _provider(AppointmentModel a) {
    if (a.salonId != 0 && a.salonInfo?.name != null) return a.salonInfo!.name!;
    if (a.ownerInfo != null) {
      return '${a.ownerInfo!.firstName ?? ''} ${a.ownerInfo!.lastName ?? ''}'
          .trim();
    }
    return 'Specialist';
  }

  String _date(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      return Jiffy.parse(raw).format(pattern: 'MMM dd, yyyy');
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookingController>(
      builder: (c) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'My Appointments',
            onMenu: () => Get.find<TabsController>().updateTabId(5),
            onMore: c.parser.haveLoggedIn() ? c.getAppointmentById : null,
          ),
          body: !c.parser.haveLoggedIn()
              ? _login(c)
              : c.apiCalled == false
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: ThemeProvider.gold),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      children: [
                        Text(
                          'NEXT SESSIONS',
                          style: ThemeProvider.sans(
                            size: 11,
                            color: ThemeProvider.gold,
                            letterSpacing: 1.4,
                          ),
                        ),
                        Text('Upcoming',
                            style: ThemeProvider.serif(size: 28)),
                        const SizedBox(height: 12),
                        if (c.appointmentList.isEmpty)
                          const EliteApiUnavailable()
                        else
                          ...c.appointmentList.map((a) => _upcoming(c, a)),
                        const SizedBox(height: 18),
                        Text(
                          'RECORD OF EXCELLENCE',
                          style: ThemeProvider.sans(
                            size: 11,
                            color: ThemeProvider.gold,
                            letterSpacing: 1.4,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text('History',
                                    style: ThemeProvider.serif(size: 28))),
                            Text('Download Receipts',
                                style: ThemeProvider.sans(
                                    size: 12, color: ThemeProvider.gold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        EliteCard(
                          child: c.appointmentListOld.isEmpty
                              ? const EliteApiUnavailable()
                              : Column(
                                  children: c.appointmentListOld
                                      .map((a) => _history(c, a))
                                      .toList(),
                                ),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _login(BookingController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Access Your Appointments',
                style: ThemeProvider.serif(size: 22)),
            const SizedBox(height: 8),
            Text(
              'Please log in to view your appointments.',
              style: ThemeProvider.sans(size: 13, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            EliteGoldButton(label: 'Login / Register', onTap: c.onLoginRoutes),
          ],
        ),
      ),
    );
  }

  Widget _upcoming(BookingController c, AppointmentModel a) {
    return GestureDetector(
      onTap: () => c.onAppointment(a.id as int),
      child: EliteCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${_cover(a)}',
              height: 140,
              width: double.infinity,
              radius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(_title(a), style: ThemeProvider.serif(size: 18)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: ThemeProvider.gold),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (c.statusName[a.status ?? 0]).toUpperCase(),
                    style: ThemeProvider.sans(
                        size: 9, color: ThemeProvider.gold, letterSpacing: 0.6),
                  ),
                ),
              ],
            ),
            Text('Specialist: ${_provider(a)}',
                style: ThemeProvider.sans(
                    size: 12, color: ThemeProvider.greyColor)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 13, color: ThemeProvider.greyColor),
                Text(' ${_date(a.saveDate)}',
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.greyColor)),
                const SizedBox(width: 14),
                const Icon(Icons.access_time,
                    size: 13, color: ThemeProvider.greyColor),
                Text(' ${a.slot ?? ''}',
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.greyColor)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: EliteGoldButton(
                    label: 'Reschedule',
                    onTap: () {
                      Get.delete<RescheduleSlotController>(force: true);
                      final uid = (a.salonId ?? 0) != 0
                          ? a.salonId
                          : a.freelancerId;
                      final type =
                          (a.salonId ?? 0) != 0 ? 'salon' : 'individual';
                      Get.toNamed(AppRouter.getRescheduleSlotRoutes(),
                          arguments: [a.id, uid, type]);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EliteGoldButton(
                    label: 'Cancel',
                    outlined: true,
                    onTap: () => c.onAppointment(a.id as int),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _history(BookingController c, AppointmentModel a) {
    final completed = a.status == 4;
    final cancelled = a.status == 5 || a.status == 2;
    return InkWell(
      onTap: () => c.onAppointment(a.id as int),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.spa_outlined,
                      color: ThemeProvider.gold, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_title(a), style: ThemeProvider.sans(size: 14)),
                      Text(_date(a.saveDate),
                          style: ThemeProvider.sans(
                              size: 11, color: ThemeProvider.greyColor)),
                    ],
                  ),
                ),
                Icon(
                  completed ? Icons.description_outlined : Icons.info_outline,
                  color: ThemeProvider.gold,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: completed
                        ? const Color(0x3322C55E)
                        : cancelled
                            ? const Color(0x33E53935)
                            : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (c.statusName[a.status ?? 0]).toUpperCase(),
                    style: ThemeProvider.sans(
                      size: 9,
                      color: completed
                          ? const Color(0xFF4ADE80)
                          : cancelled
                              ? const Color(0xFFE5B5A8)
                              : Colors.white70,
                    ),
                  ),
                ),
                const Spacer(),
                if (completed)
                  GestureDetector(
                    onTap: () {
                      Get.delete<AddReviewController>(force: true);
                      Get.toNamed(AppRouter.getAddReviewsRoutes(), arguments: [
                        'owner',
                        _cover(a),
                        _provider(a),
                        (a.salonId ?? 0) != 0
                            ? a.salonId.toString()
                            : a.freelancerId.toString(),
                      ]);
                    },
                    child: Text('WRITE REVIEW',
                        style: ThemeProvider.sans(
                            size: 10, color: ThemeProvider.gold)),
                  ),
              ],
            ),
            const Divider(color: Color(0xFF2A2A2A), height: 18),
          ],
        ),
      ),
    );
  }
}
