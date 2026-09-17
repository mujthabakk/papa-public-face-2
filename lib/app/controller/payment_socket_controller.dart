import 'dart:async';
import 'dart:convert';

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

/// Public customer socket (not partner).
/// After login + whenever a booking/invoice opens: POST socketConfig `{uid}`,
/// subscribe to `payment-status-<uid>` (and shared `payment-status`).
/// Keep the connection while the app is in the foreground.
class PaymentSocketController extends GetxController
    with WidgetsBindingObserver
    implements GetxService {
  final PaymentParser parser;
  final PaymentSocketService _socket = PaymentSocketService();

  final Map<String, DateTime> _seen = {};
  final Set<int> _watchBookIds = {};
  final Set<int> _dismissedBookIds = {};
  final Set<int> _shownPopupBookIds = {};
  final List<PendingPayOption> pendingPayOptions = [];
  String _loadedUid = '';
  bool _starting = false;
  bool _pendingStart = false;
  bool _polling = false;
  Timer? _pollTimer;

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
    WidgetsBinding.instance.addObserver(this);
    _loadPayState();
    if (isLoggedIn) {
      startListening();
      startCompleteServicePoll();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isLoggedIn) {
      startListening();
      startCompleteServicePoll();
    } else if (state == AppLifecycleState.paused) {
      stopCompleteServicePoll();
    }
  }

  /// Handshake + subscribe. Safe to call again from invoice / resume.
  Future<void> startListening() async {
    if (!isLoggedIn) return;
    if (_starting) {
      _pendingStart = true;
      return;
    }
    final uid = parser.getUidInt();
    if (uid == null) return;
    _starting = true;
    _loadPayState();
    try {
      final config = await parser.getSocketConfig();
      await _socket.start(
        config: config,
        uid: uid,
        onPayNowPopup: onPayNowPopup,
        onCompleted: onPaymentCompleted,
      );
      startCompleteServicePoll();
    } finally {
      _starting = false;
      if (_pendingStart) {
        _pendingStart = false;
        startListening();
      }
    }
  }

  Future<void> stopListening() async {
    stopCompleteServicePoll();
    await _socket.stop();
  }

  void watchBookId(int bookId, {bool fetchNow = true}) {
    if (bookId <= 0) return;
    _watchBookIds.add(bookId);
    startCompleteServicePoll();
    if (fetchNow) {
      fetchCompleteServiceNotification();
    }
  }

  void startCompleteServicePoll() {
    if (!isLoggedIn) return;
    if (_pollTimer != null && _pollTimer!.isActive) return;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _pollCompleteService();
    });
    _pollCompleteService();
  }

  void stopCompleteServicePoll() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  String get _dismissedPrefsKey =>
      'pay_now_popup_closed_by_user_${loggedInUid}';

  String get _shownPrefsKey => 'pay_now_popup_shown_${loggedInUid}';

  String get _pendingPrefsKey => 'pay_now_pending_${loggedInUid}';

  void _loadPayState() {
    if (loggedInUid.isEmpty) return;
    if (_loadedUid == loggedInUid) return;
    _loadedUid = loggedInUid;
    final dismissed =
        parser.sharedPreferencesManager.getStringList(_dismissedPrefsKey) ??
            [];
    _dismissedBookIds
      ..clear()
      ..addAll(dismissed.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0));
    final shown =
        parser.sharedPreferencesManager.getStringList(_shownPrefsKey) ?? [];
    _shownPopupBookIds
      ..clear()
      ..addAll(shown.map((e) => int.tryParse(e) ?? 0).where((e) => e > 0));
    final pending =
        parser.sharedPreferencesManager.getStringList(_pendingPrefsKey) ?? [];
    pendingPayOptions
      ..clear()
      ..addAll(pending
          .map(PendingPayOption.tryParse)
          .whereType<PendingPayOption>());
  }

  void _persistDismissed() {
    if (loggedInUid.isEmpty) return;
    parser.sharedPreferencesManager.putStringList(
      _dismissedPrefsKey,
      _dismissedBookIds.map((e) => e.toString()).toList(),
    );
    parser.sharedPreferencesManager.putStringList(
      _shownPrefsKey,
      _shownPopupBookIds.map((e) => e.toString()).toList(),
    );
  }

  void _markPayPopupShown(int bookId) {
    if (bookId <= 0) return;
    _shownPopupBookIds.add(bookId);
    _persistDismissed();
  }

  void _markPayPopupClosed(int bookId) {
    if (bookId <= 0) return;
    _dismissedBookIds.add(bookId);
    _shownPopupBookIds.add(bookId);
    _persistDismissed();
    update();
  }

  bool _alreadyShowedPayPopup(int bookId) =>
      bookId > 0 &&
      (_shownPopupBookIds.contains(bookId) ||
          _dismissedBookIds.contains(bookId));

  void _persistPending() {
    if (loggedInUid.isEmpty) return;
    parser.sharedPreferencesManager.putStringList(
      _pendingPrefsKey,
      pendingPayOptions.map((e) => e.encode()).toList(),
    );
  }

  void _upsertPending(Map<String, dynamic> payload, int bookId) {
    if (bookId <= 0) return;
    final option = PendingPayOption.fromPayload(payload, bookId);
    pendingPayOptions.removeWhere((e) => e.bookId == bookId);
    pendingPayOptions.insert(0, option);
    _persistPending();
    update();
  }

  void _removePending(int bookId) {
    if (bookId <= 0) return;
    pendingPayOptions.removeWhere((e) => e.bookId == bookId);
    _watchBookIds.remove(bookId);
    _persistPending();
    _persistDismissed();
    update();
  }

  void openPendingPay(PendingPayOption option) {
    if (option.paymentUrl.isNotEmpty) {
      openUpgradePaymentWebView(
        paymentUrl: option.paymentUrl,
        appointmentId: option.bookId,
      );
      return;
    }
    if (option.bookId > 0) {
      Get.delete<AppointmentDetailController>(force: true);
      Get.toNamed(
        AppRouter.getAppointmentDetailRoutes(),
        arguments: [option.bookId],
      );
    }
  }

  Future<void> _pollCompleteService() async {
    if (_polling || !isLoggedIn) return;
    _polling = true;
    try {
      await fetchCompleteServiceNotification();
    } finally {
      _polling = false;
    }
  }

  /// POST getCompleteServiceNotification `{ uid }` every 3s.
  /// Popup shows once per book_id in the response.
  Future<void> fetchCompleteServiceNotification({
    Map<String, dynamic>? fallback,
  }) async {
    if (!isLoggedIn) return;
    try {
      final rows = await parser.getCompleteServiceNotification();
      if (rows.isNotEmpty) {
        for (final data in rows) {
          applyCompleteServicePayload(data);
        }
        return;
      }
    } catch (e) {
      // Quiet: this runs every 3s.
    }
    if (fallback != null) {
      applyCompleteServicePayload(fallback);
    }
  }

  void applyCompleteServicePayload(Map<String, dynamic> data) {
    if (!_isForMe(data) &&
        (data['uid']?.toString().isNotEmpty ?? false)) {
      return;
    }
    final isPaid = data['is_paid'] == true ||
        data['is_paid']?.toString() == '1' ||
        data['action']?.toString() == 'paid';
    final showPopup = data['show_popup'] == true ||
        data['show_popup']?.toString() == '1' ||
        data['popup'] == true ||
        data['popup']?.toString() == '1' ||
        data['show_pay_now'] == true ||
        data['show_pay_now']?.toString() == '1' ||
        data['action']?.toString() == 'pay_now' ||
        data['can_pay_now'] == true;
    final bookId = _readInt(data, const [
      'book_id',
      'appointment_id',
      'appointmentId',
      'id',
      'booking_id',
    ]);
    if (isPaid) {
      final wasPending =
          pendingPayOptions.any((e) => e.bookId == bookId) ||
              _watchBookIds.contains(bookId);
      _watchBookIds.remove(bookId);
      _removePending(bookId);
      if (wasPending) onPaymentCompleted(data);
      return;
    }
    if (_isCancelledPayload(data)) return;
    if (!showPopup) return;
    if (!_isCodPayload(data)) return;
    if (_isCancelledPayload(data)) return;
    _upsertPending(data, bookId);
    if (bookId > 0) _watchBookIds.add(bookId);
    if (_alreadyShowedPayPopup(bookId)) return;
    _presentPayPopupOnce(data, bookId);
  }

  bool _isForMe(Map<String, dynamic> payload) {
    final eventUid = payload['uid']?.toString() ?? '';
    return loggedInUid.isNotEmpty &&
        (eventUid.isEmpty || eventUid == loggedInUid);
  }

  bool _isCancelledPayload(Map<String, dynamic> data) {
    final st = int.tryParse(
          data['appointment_status']?.toString() ??
              data['booking_status']?.toString() ??
              data['status']?.toString() ??
              '',
        ) ??
        -1;
    if (st == 2 || st == 5 || st == 6) return true;
    final blob =
        '${data['title'] ?? ''} ${data['message'] ?? ''} ${data['status'] ?? ''} ${data['status_label'] ?? ''} ${data['action'] ?? ''}'
            .toLowerCase();
    return blob.contains('cancel') ||
        blob.contains('reject') ||
        blob.contains('refund');
  }

  bool _isCodPayload(Map<String, dynamic> data) {
    final method = int.tryParse(
          data['pay_method']?.toString() ??
              data['payment_method']?.toString() ??
              '',
        ) ??
        0;
    final label = (data['pay_method_label'] ??
            data['paid'] ??
            data['payment_method'] ??
            '')
        .toString()
        .toLowerCase();
    if (method == 1 || label.contains('cod') || label.contains('cash')) {
      return true;
    }
    if (method >= 2) return false;
    return data['show_cod'] == true || data['show_cod']?.toString() == '1';
  }

  bool _isDuplicate(String event, int bookId) {
    final key = '$event:$bookId';
    final now = DateTime.now();
    final last = _seen[key];
    if (last != null && now.difference(last).inSeconds < 12) return true;
    _seen[key] = now;
    return false;
  }

  /// Socket missed fallback uses the same payload. Popup still once per book_id.
  void onPayNowPopup(Map<String, dynamic> payload) {
    if (!_isForMe(payload)) return;
    if (_isCancelledPayload(payload)) return;
    if (!_isCodPayload(payload)) return;

    final bookId = _readInt(payload, const [
      'book_id',
      'appointment_id',
      'appointmentId',
      'id',
      'booking_id',
    ]);
    if (bookId > 0) _watchBookIds.add(bookId);
    startCompleteServicePoll();
    fetchCompleteServiceNotification(fallback: payload);
  }

  void _presentPayPopupOnce(Map<String, dynamic> payload, int bookId) {
    if (_alreadyShowedPayPopup(bookId)) return;
    if (Get.isDialogOpen == true) return;
    _showPayPopup(payload, bookId);
  }

  /// Razorpay / cash cleared → mark paid only if is_paid == true.
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
    if (_isDuplicate('payment-completed', bookId)) return;

    _removePending(bookId);

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
    final title = (payload['popup_title'] ??
            payload['title'] ??
            'Service completed — Pay now')
        .toString()
        .replaceAll('\n', ' ')
        .trim();
    final paymentUrl = (payload['payment_url'] ??
            payload['payment_link'] ??
            payload['checkout_url'] ??
            payload['url'] ??
            '')
        .toString()
        .trim();
    final message = (payload['popup_message'] ?? payload['message'] ?? '')
        .toString()
        .replaceAll('\n', ' ')
        .trim();
    final button = (payload['popup_button'] ?? 'Pay Now').toString().trim();

    void open() {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => open());
        return;
      }
      if (Get.isDialogOpen == true) return;
      _markPayPopupShown(bookId);
      var closedByUser = true;
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
                  title,
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
                        closedByUser = false;
                        Get.back();
                        openUpgradePaymentWebView(
                          paymentUrl: paymentUrl,
                          appointmentId: bookId,
                        );
                      },
                      child: Text(
                        button,
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
                        closedByUser = false;
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
      ).then((_) {
        if (closedByUser) _markPayPopupClosed(bookId);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => open());
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
    WidgetsBinding.instance.removeObserver(this);
    stopCompleteServicePoll();
    _socket.stop();
    super.onClose();
  }
}

class PendingPayOption {
  final int bookId;
  final String paymentUrl;
  final String title;
  final String message;
  final String amount;

  PendingPayOption({
    required this.bookId,
    required this.paymentUrl,
    required this.title,
    required this.message,
    required this.amount,
  });

  String get label => bookId > 0 ? '#PB-$bookId' : title;

  factory PendingPayOption.fromPayload(Map<String, dynamic> payload, int bookId) {
    return PendingPayOption(
      bookId: bookId,
      paymentUrl: (payload['payment_url'] ??
              payload['checkout_url'] ??
              payload['url'] ??
              '')
          .toString()
          .trim(),
      title: (payload['popup_title'] ?? payload['title'] ?? 'Pay now')
          .toString()
          .trim(),
      message: (payload['message'] ?? payload['popup_message'] ?? '')
          .toString()
          .trim(),
      amount: (payload['amount'] ??
              payload['grand_total'] ??
              payload['total'] ??
              payload['price'] ??
              '')
          .toString()
          .trim(),
    );
  }

  String encode() => jsonEncode({
        'bookId': bookId,
        'paymentUrl': paymentUrl,
        'title': title,
        'message': message,
        'amount': amount,
      });

  static PendingPayOption? tryParse(String raw) {
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      final id = int.tryParse(map['bookId']?.toString() ?? '') ?? 0;
      if (id <= 0) return null;
      return PendingPayOption(
        bookId: id,
        paymentUrl: map['paymentUrl']?.toString() ?? '',
        title: map['title']?.toString() ?? 'Pay now',
        message: map['message']?.toString() ?? '',
        amount: map['amount']?.toString() ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
