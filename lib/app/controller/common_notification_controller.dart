import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/common_notification_model.dart';
import 'package:salon_user/app/backend/parse/common_notification_parse..dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/controller/payment_socket_controller.dart';
import 'package:salon_user/app/controller/product_order_detail_controller.dart';
import 'package:salon_user/app/controller/reschedule_slot_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';

class CommonNotificationController extends GetxController
    implements GetxService {
  final CommonNotificationParser parser;

  String uid = '';
  bool apiCalled = false;
  bool _loading = false;
  bool _updateScheduled = false;
  List<NotificationItem> _notificationList = [];

  List<NotificationItem> get notificationList => _notificationList;

  int get unreadCount =>
      _notificationList.where((n) => n.isUnread).length;

  bool get isLoading => _loading;

  CommonNotificationController({required this.parser});

  void safeUpdate() {
    if (isClosed) return;
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      update();
      return;
    }
    if (_updateScheduled) return;
    _updateScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScheduled = false;
      if (!isClosed) update();
    });
  }

  @override
  void onInit() {
    super.onInit();
    uid = parser.getUID();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;
      if (uid.isNotEmpty) {
        getAllNotifications(uid);
      }
    });
  }

  Future<void> refreshNotifications() async {
    uid = parser.getUID();
    if (uid.isEmpty) return;
    await getAllNotifications(uid);
  }

  void showNotificationDialog(
      BuildContext context, NotificationItem notification) {
    openNotification(notification);
    final hasAppointment = (notification.data.appointmentId ?? 0) > 0;
    final hasOrder = (notification.data.orderId ?? 0) > 0;
    final business = notification.data.businessName.trim();
    final date = notification.data.date.trim();
    final price = notification.data.price;
    Get.bottomSheet(
      SafeArea(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: const BoxDecoration(
            color: ThemeProvider.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A3A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  notification.title,
                  style: ThemeProvider.serif(
                    size: 20,
                    color: ThemeProvider.gold,
                  ),
                ),
                if (date.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    date,
                    style: ThemeProvider.sans(
                      size: 12,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  notification.message,
                  style: ThemeProvider.sans(
                    size: 14,
                    color: Colors.white70,
                  ).copyWith(height: 1.5),
                ),
                if (business.isNotEmpty)
                  _buildDetailRow(
                    icon: Icons.storefront_outlined,
                    label: 'Business'.tr,
                    value: business,
                  ),
                if (price > 0)
                  _buildDetailRow(
                    icon: Icons.payments_outlined,
                    label: 'Amount'.tr,
                    value: price.toString(),
                  ),
                const SizedBox(height: 20),
                if (hasAppointment || hasOrder)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        if (hasAppointment) {
                          onAppointment(notification.data.appointmentId!);
                        } else {
                          onProductDetail(notification.data.orderId!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(0, 46),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        hasAppointment
                            ? 'View Appointment'.tr
                            : 'View Order'.tr,
                        style: ThemeProvider.sans(
                          size: 13,
                          weight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF3A3A3A)),
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Close'.tr,
                          style: ThemeProvider.sans(
                              size: 13, weight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          Icon(icon, color: ThemeProvider.gold, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ThemeProvider.sans(
                    size: 11,
                    color: ThemeProvider.greyColor,
                  ),
                ),
                Text(
                  value,
                  style: ThemeProvider.sans(
                    size: 14,
                    weight: FontWeight.w600,
                    color: ThemeProvider.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Open a notification: mark read, then pull complete-service payload
  /// when the socket may have been missed (background).
  void openNotification(NotificationItem notification) {
    if (notification.isUnread) {
      readNotifications(notification.id);
    }
    final bookId = notification.data.payBookId;
    if (bookId <= 0) return;
    if (!Get.isRegistered<PaymentSocketController>()) return;
    final pay = Get.find<PaymentSocketController>();
    pay.watchBookId(bookId, fetchNow: false);
    pay.fetchCompleteServiceNotification(
      fallback: notification.data.extra,
    );
  }

  void onProductDetail(int id) {
    Get.delete<ProductOrderDetailController>(force: true);
    Get.toNamed(AppRouter.getProductOrderDetail(), arguments: [id]);
  }

  void onAppointment(int id) {
    Get.delete<AppointmentDetailController>(force: true);
    Get.toNamed(AppRouter.getAppointmentDetailRoutes(), arguments: [id]);
  }

  void onReschedule(NotificationItem n) {
    final id = n.data.appointmentId ?? n.data.bookId ?? n.data.payBookId;
    if (id <= 0) return;
    Get.delete<RescheduleSlotController>(force: true);
    Get.toNamed(AppRouter.getRescheduleSlotRoutes(), arguments: [id]);
  }

  Future<void> getAllNotifications(String uidParam) async {
    if (_loading) return;
    _loading = true;
    uid = parser.getUID();
    safeUpdate();

    try {
      final Response response = await parser.getAllNotification(uid);
      final items = NotificationModel.fromResponse(response.body);
      _notificationList = items;
      debugPrint(
          'Notifications loaded: ${_notificationList.length}, unread=$unreadCount');
      if (Get.isRegistered<PaymentSocketController>()) {
        final pay = Get.find<PaymentSocketController>();
        for (final n in _notificationList) {
          final id = n.data.payBookId;
          if (id > 0 && n.data.showPopup && !n.data.isPaid) {
            pay.watchBookId(id, fetchNow: false);
          }
        }
      }
      if (response.statusCode != 200 && items.isEmpty) {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('getAllNotifications error: $e');
    } finally {
      apiCalled = true;
      _loading = false;
      safeUpdate();
    }
  }

  /// Mark one notification read (optimistic UI + API).
  Future<void> readNotifications(int notificationId) async {
    if (notificationId <= 0) return;
    uid = parser.getUID();

    final idx = _notificationList.indexWhere((n) => n.id == notificationId);
    if (idx >= 0 && _notificationList[idx].isUnread) {
      _notificationList[idx].markReadLocally();
      safeUpdate();
    }

    try {
      final Response response = await parser.readNotification(
        notificationId: notificationId,
        uid: uid,
      );
      final ok = response.statusCode == 200;
      final body = response.body;
      final success = body is Map
          ? (body['success'] == true || body['success']?.toString() == '1')
          : ok;
      if (!ok && !success) {
        ApiChecker.checkApi(response);
        await getAllNotifications(uid);
      }
    } catch (e) {
      debugPrint('readNotifications error: $e');
      await getAllNotifications(uid);
    }
  }

  /// Mark all unread as read (Clear All).
  Future<void> markAllRead() async {
    uid = parser.getUID();
    final unreadIds =
        _notificationList.where((n) => n.isUnread).map((n) => n.id).toList();
    if (unreadIds.isEmpty) return;

    for (final n in _notificationList) {
      if (n.isUnread) n.markReadLocally();
    }
    safeUpdate();

    try {
      final bulk = await parser.readAllNotifications(uid: uid);
      final bulkOk = bulk.statusCode == 200;
      if (bulkOk) return;

      for (final id in unreadIds) {
        await parser.readNotification(notificationId: id, uid: uid);
      }
    } catch (e) {
      debugPrint('markAllRead error: $e');
      await getAllNotifications(uid);
    }
  }
}
