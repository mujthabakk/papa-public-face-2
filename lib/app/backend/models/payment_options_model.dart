import 'package:salon_user/app/util/constant.dart';

class PaymentOptionsModel {
  final int id;
  final int uid;
  final int bookId;
  final int appointmentId;
  final double amount;
  final String currency;
  final int payMethod;
  final String payMethodLabel;
  final int appointmentStatus;
  final String saveDate;
  final String slot;
  final int salonId;
  final int freelancerId;
  final bool isPaid;
  final bool canPayNow;
  final bool showPayNow;
  final bool showCod;
  final bool codAvailable;
  final bool onlineAvailable;
  final bool paymentRequired;
  final String message;
  final String paymentStatus;
  final String statusLabel;

  PaymentOptionsModel({
    this.id = 0,
    this.uid = 0,
    this.bookId = 0,
    this.appointmentId = 0,
    this.amount = 0,
    this.currency = 'INR',
    this.payMethod = 0,
    this.payMethodLabel = '',
    this.appointmentStatus = 0,
    this.saveDate = '',
    this.slot = '',
    this.salonId = 0,
    this.freelancerId = 0,
    this.isPaid = false,
    this.canPayNow = false,
    this.showPayNow = false,
    this.showCod = false,
    this.codAvailable = false,
    this.onlineAvailable = false,
    this.paymentRequired = false,
    this.message = '',
    this.paymentStatus = '',
    this.statusLabel = '',
  });

  factory PaymentOptionsModel.fromJson(Map<String, dynamic> json) {
    final nested = json['payment_options'];
    final src = nested is Map
        ? {...json, ...Map<String, dynamic>.from(nested)}
        : json;

    final bookId = int.tryParse(
          src['book_id']?.toString() ??
              src['appointment_id']?.toString() ??
              src['id']?.toString() ??
              '',
        ) ??
        0;

    return PaymentOptionsModel(
      id: int.tryParse(src['id']?.toString() ?? '') ?? bookId,
      uid: int.tryParse(src['uid']?.toString() ?? '') ?? 0,
      bookId: bookId,
      appointmentId: int.tryParse(src['appointment_id']?.toString() ?? '') ??
          bookId,
      amount: double.tryParse(
            src['amount']?.toString() ??
                src['grand_total']?.toString() ??
                '',
          ) ??
          0,
      currency: src['currency']?.toString() ?? 'INR',
      payMethod: int.tryParse(src['pay_method']?.toString() ?? '') ?? 0,
      payMethodLabel: src['pay_method_label']?.toString() ?? '',
      appointmentStatus: int.tryParse(
            src['appointment_status']?.toString() ??
                src['status']?.toString() ??
                '',
          ) ??
          0,
      saveDate: src['save_date']?.toString() ?? '',
      slot: src['slot']?.toString() ?? '',
      salonId: int.tryParse(src['salon_id']?.toString() ?? '') ?? 0,
      freelancerId: int.tryParse(src['freelancer_id']?.toString() ?? '') ?? 0,
      isPaid: src['is_paid'] == true ||
          src['is_paid']?.toString() == '1' ||
          src['payment_status']?.toString().toLowerCase() == 'paid',
      canPayNow: src['can_pay_now'] == true ||
          src['can_pay_now']?.toString() == '1',
      showPayNow: src['show_pay_now'] == true ||
          src['show_pay_now']?.toString() == '1',
      showCod:
          src['show_cod'] == true || src['show_cod']?.toString() == '1',
      codAvailable: src['cod_available'] == true ||
          src['cod_available']?.toString() == '1',
      onlineAvailable: src['online_available'] == true ||
          src['online_available']?.toString() == '1',
      paymentRequired: src['payment_required'] == true ||
          src['payment_required']?.toString() == '1',
      message: src['message']?.toString() ?? '',
      paymentStatus: src['payment_status']?.toString() ?? '',
      statusLabel: src['status_label']?.toString() ?? '',
    );
  }

  PaymentOptionsModel copyWith({
    bool? isPaid,
    bool? canPayNow,
    bool? showPayNow,
    bool? showCod,
    String? message,
    String? paymentStatus,
  }) {
    return PaymentOptionsModel(
      id: id,
      uid: uid,
      bookId: bookId,
      appointmentId: appointmentId,
      amount: amount,
      currency: currency,
      payMethod: payMethod,
      payMethodLabel: payMethodLabel,
      appointmentStatus: appointmentStatus,
      saveDate: saveDate,
      slot: slot,
      salonId: salonId,
      freelancerId: freelancerId,
      isPaid: isPaid ?? this.isPaid,
      canPayNow: canPayNow ?? this.canPayNow,
      showPayNow: showPayNow ?? this.showPayNow,
      showCod: showCod ?? this.showCod,
      codAvailable: codAvailable,
      onlineAvailable: onlineAvailable,
      paymentRequired: paymentRequired,
      message: message ?? this.message,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      statusLabel: statusLabel,
    );
  }
}

class PaymentSocketConfig {
  final String driver;
  final String key;
  final String cluster;
  final String wsUrl;
  final String wsHost;
  final int wssPort;
  final bool forceTls;
  final String channel;
  // Owner "Service completed" → Pay Now modal. Backend keys this as
  // `popup_event` (and duplicates it as the generic `event` field).
  final String payNowEvent;
  // Customer actually paid → mark paid. Backend keys this as `payment_event`
  // — NOT the generic `event` field, which is the pay-now-popup event above.
  final String event;
  final bool authRequired;

  PaymentSocketConfig({
    required this.key,
    required this.cluster,
    required this.channel,
    required this.event,
    this.payNowEvent = '',
    this.driver = 'pusher',
    this.wsUrl = '',
    this.wsHost = '',
    this.wssPort = 443,
    this.forceTls = true,
    this.authRequired = false,
  });

  /// Official app-team values: key/cluster/host/channel/events (TLS on ap2).
  /// Channel is per-customer: `payment-status-<uid>` when [uid] is known.
  factory PaymentSocketConfig.defaults({int? uid}) {
    return PaymentSocketConfig(
      key: AppConstants.paymentPusherKey,
      cluster: AppConstants.paymentPusherCluster,
      wsHost: AppConstants.paymentPusherHost,
      wssPort: AppConstants.paymentPusherPort,
      wsUrl: AppConstants.paymentPusherWsUrl,
      forceTls: AppConstants.paymentPusherForceTls,
      channel: uid != null
          ? '${AppConstants.paymentPusherChannel}-$uid'
          : AppConstants.paymentPusherChannel,
      payNowEvent: AppConstants.paymentPusherPayNowEvent,
      event: AppConstants.paymentPusherEvent,
    );
  }

  /// [uid] is used only to build the fallback channel if the backend response
  /// is missing one — the real channel from the API is `payment-status-<uid>`
  /// and must be trusted as-is, not rewritten back to a shared channel.
  factory PaymentSocketConfig.fromJson(Map<String, dynamic> json, {int? uid}) {
    final defaults = PaymentSocketConfig.defaults(uid: uid);
    final key = json['key']?.toString() ?? '';
    final cluster = json['cluster']?.toString() ?? '';
    var channel = json['channel']?.toString() ?? '';
    // Only reject an unresolved template, e.g. literal "payment-status-{uid}".
    if (channel.isEmpty || channel.contains('{')) {
      channel = defaults.channel;
    }
    return PaymentSocketConfig(
      driver: json['driver']?.toString() ?? 'pusher',
      key: key.isNotEmpty ? key : defaults.key,
      cluster: cluster.isNotEmpty ? cluster : defaults.cluster,
      wsUrl: json['ws_url']?.toString().isNotEmpty == true
          ? json['ws_url'].toString()
          : defaults.wsUrl,
      wsHost: (json['ws_host'] ?? json['host'])?.toString().isNotEmpty == true
          ? (json['ws_host'] ?? json['host']).toString()
          : defaults.wsHost,
      wssPort: int.tryParse(
            (json['wss_port'] ?? json['port'])?.toString() ?? '',
          ) ??
          defaults.wssPort,
      forceTls: json['force_tls'] != false && json['forceTLS'] != false,
      channel: channel,
      // popup_event (fallback: event) — pay-now-popup.
      payNowEvent: (json['popup_event'] ?? json['event'])
                  ?.toString()
                  .isNotEmpty ==
              true
          ? (json['popup_event'] ?? json['event']).toString()
          : defaults.payNowEvent,
      // payment_event ONLY — the generic `event` field is the pay-now-popup
      // event, not payment-completed, and must never be used as a fallback
      // here or every "payment-completed" broadcast silently gets dropped.
      event: json['payment_event']?.toString().isNotEmpty == true
          ? json['payment_event'].toString()
          : defaults.event,
      authRequired: json['auth_required'] == true,
    );
  }
}
