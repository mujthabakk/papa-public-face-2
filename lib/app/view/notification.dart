import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/common_notification_model.dart';
import 'package:salon_user/app/controller/common_notification_controller.dart';
import 'package:salon_user/app/util/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommonNotificationController>(
      builder: (controller) {
        final items = _filtered(controller.notificationList);
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: ThemeProvider.gold, size: 20),
              onPressed: () => Get.back(),
            ),
            title: Text('Notifications'.tr,
              style: ThemeProvider.serif(size: 22, color: ThemeProvider.gold),
            ),
            centerTitle: true,
            actions: [
              TextButton(
                onPressed: () => controller.markAllRead(),
                child: Text('READ ALL'.tr,
                  style: ThemeProvider.sans(
                    size: 11,
                    weight: FontWeight.w700,
                    color: ThemeProvider.greyColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _chip('All'),
                    _chip(
                      'Unread',
                      badge: Get.find<CommonNotificationController>().unreadCount,
                    ),
                    _chip('Offers'),
                    _chip('Alerts'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: controller.isLoading &&
                        controller.notificationList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: ThemeProvider.gold),
                      )
                    : items.isEmpty
                        ? Center(
                            child: Text(
                              _filter == 'All'
                                  ? 'No notifications yet'.tr
                                  : 'No ${_filter.toLowerCase()} notifications'
                                      .tr,
                              style: ThemeProvider.sans(
                                size: 13,
                                color: ThemeProvider.greyColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final n = items[index];
                              final showHeader = index == 0 ||
                                  _section(items[index - 1]) != _section(n);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (showHeader)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 10),
                                      child: Text(
                                        _section(n),
                                        style: ThemeProvider.sans(
                                          size: 11,
                                          weight: FontWeight.w700,
                                          color: ThemeProvider.greyColor,
                                          letterSpacing: 1.4,
                                        ),
                                      ),
                                    ),
                                  _card(controller, n),
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<NotificationItem> _filtered(List<NotificationItem> all) {
    switch (_filter) {
      case 'Unread':
        return all.where((n) => n.isUnread).toList();
      case 'Offers':
        return all
            .where((n) =>
                n.type.toLowerCase().contains('promo') ||
                n.type.toLowerCase().contains('offer') ||
                n.title.toLowerCase().contains('offer'))
            .toList();
      case 'Alerts':
        return all
            .where((n) {
              final t = n.type.toLowerCase();
              final title = n.title.toLowerCase();
              return t.contains('payment') ||
                  t.contains('security') ||
                  t == 'alert' ||
                  t.contains('appointment') ||
                  title.contains('cancelled') ||
                  title.contains('completed') ||
                  title.contains('accepted');
            })
            .toList();
      default:
        return all;
    }
  }

  String _section(NotificationItem n) {
    final raw = n.data.date;
    if (raw.isEmpty) return 'EARLIER';
    try {
      final d = DateTime.tryParse(raw);
      if (d == null) return 'EARLIER';
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final day = DateTime(d.year, d.month, d.day);
      if (day == today) return 'NEW TODAY';
      if (day == today.subtract(const Duration(days: 1))) return 'YESTERDAY';
    } catch (_) {}
    return 'EARLIER';
  }

  Widget _chip(String label, {int badge = 0}) {
    final selected = _filter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (badge > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: selected ? Colors.black : ThemeProvider.gold,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badge',
                  style: ThemeProvider.sans(
                    size: 10,
                    weight: FontWeight.w700,
                    color: selected ? ThemeProvider.gold : Colors.black,
                  ),
                ),
              ),
            ],
          ],
        ),
        selected: selected,
        onSelected: (_) => setState(() => _filter = label),
        selectedColor: ThemeProvider.gold,
        backgroundColor: Colors.transparent,
        side: BorderSide(
          color: selected ? ThemeProvider.gold : const Color(0xFF3A3A3A),
        ),
        labelStyle: ThemeProvider.sans(
          size: 12,
          weight: FontWeight.w600,
          color: selected ? Colors.black : Colors.white70,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _card(CommonNotificationController controller, NotificationItem n) {
    final unread = n.isUnread;
    final type = n.type.toLowerCase();
    final isAppointment = type.contains('appointment');
    final isOffer = type.contains('promo') ||
        type.contains('offer') ||
        n.title.toLowerCase().contains('offer');
    return InkWell(
      onTap: () {
        controller.openNotification(n);
        if (n.isClosedAppointment && n.data.appointmentId != null) {
          controller.onAppointment(n.data.appointmentId!);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ThemeProvider.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_iconFor(type),
                      color: ThemeProvider.gold, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        n.title,
                        style: ThemeProvider.serif(
                          size: 16,
                          color: unread || isOffer
                              ? ThemeProvider.gold
                              : ThemeProvider.whiteColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        n.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeProvider.sans(
                            size: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      n.data.date,
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.greyColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    if (unread) ...[
                      const SizedBox(height: 6),
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: ThemeProvider.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (n.showCodPayNow) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.openNotification(n);
                    if (n.data.appointmentId != null) {
                      controller.onAppointment(n.data.appointmentId!);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.gold,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(0, 40),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Pay Now'.tr,
                      style: ThemeProvider.sans(
                          size: 12, weight: FontWeight.w700)),
                ),
              ),
            ] else if (n.canManageAppointment) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        controller.openNotification(n);
                        if (n.data.appointmentId != null) {
                          controller.onAppointment(n.data.appointmentId!);
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF3A3A3A)),
                        minimumSize: const Size(0, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Reschedule'.tr,
                          style: ThemeProvider.sans(
                              size: 12, weight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.openNotification(n);
                        if (n.data.appointmentId != null) {
                          controller.onAppointment(n.data.appointmentId!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Cancel'.tr,
                          style: ThemeProvider.sans(
                              size: 12, weight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ] else if (!isAppointment) ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => controller.showNotificationDialog(context, n),
                child: Text(
                  isOffer ? 'REDEEM NOW  >' : 'VIEW DETAILS  >',
                  style: ThemeProvider.sans(
                    size: 11,
                    weight: FontWeight.w700,
                    color: ThemeProvider.gold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }

  IconData _iconFor(String type) {
    if (type.contains('appointment')) return Icons.calendar_today_outlined;
    if (type.contains('offer') || type.contains('promo')) {
      return Icons.local_offer_outlined;
    }
    if (type.contains('payment')) return Icons.payments_outlined;
    if (type.contains('security')) return Icons.settings_outlined;
    return Icons.notifications_none;
  }
}
