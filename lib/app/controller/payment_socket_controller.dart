import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/payment_parse.dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/helper/payment_socket_service.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/upgrade_payment.dart';

/// Dashboard listener on the per-customer channel `payment-status-<uid>`:
///   - `pay-now-popup`     → owner marked "Service completed"; show the
///                           Pay Now modal (payment_url). Never shows
///                           "payment successful" for this event.
///   - `payment-completed` → customer actually paid; mark paid ONLY when
///                           payload.is_paid == true.
class PaymentSocketController extends GetxController implements GetxService {
  final PaymentParser parser;
  final PaymentSocketService _socket = PaymentSocketService();

  int _lastBookId = 0;
  DateTime? _lastAt;
  bool _starting = false;

  PaymentSocketController({required this.parser});

  bool get isLoggedIn {
    final uid = parser.getUidInt();
    final token = parser.getToken();
    return uid != null && token.isNotEmpty;
  }

  String get loggedInUid => parser.getUidInt()?.toString() ?? '';

  @override
  void onInit() {
    super.onInit();
    if (isLoggedIn) {
      startListening();
    }
  }

  Future<void> startListening() async {
    if (_starting) return;
    final uid = parser.getUidInt();
    if (uid == null) return;
    _starting = true;
    try {
      // Authenticated socketConfig so the channel is the real
      // `payment-status-<uid>` for this customer.
      final config = await parser.getSocketConfig();
      await _socket.start(
        config: config,
        uid: uid,
        onPayNowPopup: onPayNowPopup,
        onCompleted: onPaymentCompleted,
      );
    } finally {
      _starting = false;
    }
  }

  Future<void> stopListening() async {
    await _socket.stop();
  }

  bool _isForMe(Map<String, dynamic> payload) {
    final eventUid = payload['uid']?.toString() ?? '';
    return loggedInUid.isNotEmpty &&
        (eventUid.isEmpty || eventUid == loggedInUid);
  }

  bool _isDuplicate(int bookId) {
    final now = DateTime.now();
    final duplicate = bookId > 0 &&
        bookId == _lastBookId &&
        _lastAt != null &&
        now.difference(_lastAt!).inSeconds < 4;
    if (!duplicate) {
      _lastBookId = bookId;
      _lastAt = now;
    }
    return duplicate;
  }

  /// Owner tapped "Service completed" → always show the Pay Now modal.
  /// Never marks the booking paid and never shows "payment successful".
  void onPayNowPopup(Map<String, dynamic> payload) {
    if (!_isForMe(payload)) return;

    final bookId = _readInt(payload, const [
      'book_id',
      'appointment_id',
      'appointmentId',
      'id',
      'booking_id',
    ]);
    if (_isDuplicate(bookId)) return;

    _showPayPopup(payload, bookId);
  }

  /// Customer actually paid → mark paid ONLY when payload.is_paid == true.
  void onPaymentCompleted(Map<String, dynamic> payload) {
    if (!_isForMe(payload)) return;

    final isPaid = payload['is_paid'] == true ||
        payload['is_paid']?.toString() == '1' ||
        payload['is_paid']?.toString().toLowerCase() == 'true';
    if (!isPaid) return;

    final bookId = _readInt(payload, const [
      'book_id',
      'appointment_id',
      'appointmentId',
      'id',
      'booking_id',
    ]);
    if (_isDuplicate(bookId)) return;

    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (Get.isRegistered<AppointmentDetailController>()) {
      final detail = Get.find<AppointmentDetailController>();
      if (bookId == 0 || detail.appointmentId == bookId) {
        detail.applyPaymentCompletedFromSocket(payload);
      }
    }

    if (Get.isRegistered<BookingController>()) {
      Get.find<BookingController>().getAppointmentById();
    }

    showToast('Payment successful'.tr, isError: false);
  }

  void _showPayPopup(Map<String, dynamic> payload, int bookId) {
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    final title = (payload['popup_title'] ??
            payload['title'] ??
            'Service completed')
        .toString()
        .trim();
    final paymentUrl = (payload['payment_url'] ??
            payload['checkout_url'] ??
            payload['url'] ??
            '')
        .toString()
        .trim();
    final message = (payload['message'] ?? payload['popup_message'] ?? '')
        .toString()
        .trim();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context == null) return;
      Get.dialog(
        Dialog(
          backgroundColor: ThemeProvider.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.payments_outlined,
                    color: ThemeProvider.gold, size: 48),
                const SizedBox(height: 14),
                Text(
                  title.tr,
                  textAlign: TextAlign.center,
                  style: ThemeProvider.serif(
                      size: 20, color: ThemeProvider.gold),
                ),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.sans(size: 13, color: Colors.white70),
                  ),
                ],
                if (bookId > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '#PB-$bookId',
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.gold),
                  ),
                ],
                const SizedBox(height: 18),
                if (paymentUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        openUpgradePaymentWebView(
                          paymentUrl: paymentUrl,
                          appointmentId: bookId,
                          onPaid: () {
                            if (Get.isRegistered<
                                AppointmentDetailController>()) {
                              Get.find<AppointmentDetailController>()
                                  .applyPaymentCompletedFromSocket({
                                ...payload,
                                'is_paid': true,
                                'show_popup': false,
                              });
                            }
                          },
                        );
                      },
                      child: Text(
                        'Pay Now'.tr,
                        style: ThemeProvider.sans(
                            size: 13, weight: FontWeight.w700),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        if (bookId > 0) {
                          Get.delete<AppointmentDetailController>(force: true);
                          Get.toNamed(
                            AppRouter.getAppointmentDetailRoutes(),
                            arguments: [bookId],
                          );
                        }
                      },
                      child: Text(
                        bookId > 0 ? 'View Invoice'.tr : 'OK'.tr,
                        style: ThemeProvider.sans(
                            size: 13, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'Close'.tr,
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.greyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    });
  }

  int _readInt(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final v = data[key];
      if (v == null) continue;
      final n = int.tryParse(v.toString());
      if (n != null && n != 0) return n;
    }
    return 0;
  }

  @override
  void onClose() {
    _socket.stop();
    super.onClose();
  }
}
