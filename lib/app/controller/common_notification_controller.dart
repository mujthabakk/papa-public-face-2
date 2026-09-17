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
    final type = notification.type.toLowerCase();
    final isPayNotice = notification.data.showPopup ||
        type.contains('payment') ||
        notification.data.action == 'pay_now';
    if (isPayNotice) return;
    if (notification.isUnread) {
      readNotifications(notification.id);
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          ThemeProvider.appColor.withOpacity(0.1),
                      child: const Icon(
                        Icons.notifications_active,
                        color: ThemeProvider.appColor,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildDetailRow(
                  icon: Icons.monetization_on,
                  label: 'Price',
                  value: notification.data.price.toString(),
                ),
                _buildDetailRow(
                  icon: Icons.business,
                  label: 'Business',
                  value: notification.data.businessName,
                ),
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: notification.data.date,
                ),
                const SizedBox(height: 15),
                Text(
                  notification.message,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Dismiss',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        if (notification.data.appointmentId != null) {
                          onAppointment(notification.data.appointmentId!);
                        } else if (notification.data.orderId != null) {
                          onProductDetail(notification.data.orderId!);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.appColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        'More Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: ThemeProvider.appColor.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
        // Revert by refreshing list
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

    // Optimistic
    for (final n in _notificationList) {
      if (n.isUnread) n.markReadLocally();
    }
    safeUpdate();

    try {
      // Try bulk first
      final bulk = await parser.readAllNotifications(uid: uid);
      final bulkOk = bulk.statusCode == 200;
      if (bulkOk) return;

      // Fallback: one-by-one without full list refresh each time
      for (final id in unreadIds) {
        await parser.readNotification(notificationId: id, uid: uid);
      }
    } catch (e) {
      debugPrint('markAllRead error: $e');
      await getAllNotifications(uid);
    }
  }
}
