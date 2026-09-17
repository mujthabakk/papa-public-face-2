import 'package:salon_user/app/backend/api/api_response.dart';

class NotificationModel {
  final bool success;
  final List<NotificationItem> data;
  final int status;

  NotificationModel({
    required this.success,
    required this.data,
    required this.status,
  });

  static List<NotificationItem> fromResponse(dynamic body) {
    final list = ApiBody.asItemList(body, keys: const [
      'data',
      'notifications',
      'items',
      'result',
      'list',
    ]);
    final out = <NotificationItem>[];
    for (final e in list) {
      try {
        if (e is! Map) continue;
        final item = NotificationItem.fromJson(Map<String, dynamic>.from(e));
        if (item.id <= 0 && item.title.isEmpty && item.message.isEmpty) {
          continue;
        }
        out.add(item);
      } catch (err) {
        continue;
      }
    }
    return out;
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'] == true || json['success']?.toString() == '1',
      data: fromResponse(json),
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
    );
  }
}

class NotificationItem {
  final int id;
  final String uid;
  final String title;
  final String message;
  final String type;
  String status;
  final NotificationData data;

  NotificationItem({
    required this.id,
    required this.uid,
    required this.title,
    required this.message,
    required this.type,
    required this.status,
    required this.data,
  });

  /// Handles: unread/read, 0/1, false/true, is_read, etc.
  bool get isUnread {
    final s = status.trim().toLowerCase();
    if (s.isEmpty) return true;
    if (s == 'unread' || s == 'new' || s == '0' || s == 'false') return true;
    if (s == 'read' || s == 'seen' || s == '1' || s == 'true') return false;
    return s != 'read';
  }

  void markReadLocally() {
    status = 'read';
  }

  String get _blob =>
      '$title $message ${data.status} ${data.extra['status_label'] ?? ''}'
          .toLowerCase();

  bool get isCancelled {
    final st = data.appointmentStatus;
    if (st == 2 || st == 5 || st == 6) return true;
    return _blob.contains('cancel') ||
        _blob.contains('reject') ||
        _blob.contains('refund');
  }

  bool get isCompleted =>
      !isCancelled &&
      (data.appointmentStatus == 4 || _blob.contains('complet'));

  bool get isClosedAppointment => isCancelled || isCompleted;

  bool get canManageAppointment {
    if (isClosedAppointment) return false;
    final type = this.type.toLowerCase();
    if (!type.contains('appointment') &&
        !_blob.contains('appointment') &&
        !_blob.contains('booked') &&
        !_blob.contains('accepted')) {
      return false;
    }
    final st = data.appointmentStatus;
    if (st == 3 || st == 8) return false;
    return st <= 1 || st == 7 || st < 0;
  }

  bool get showCodPayNow {
    if (isCancelled) return false;
    if (!isCompleted) return false;
    if (data.isPaid) return false;
    if (!data.isCod) return false;
    return data.showPopup ||
        data.action == 'pay_now' ||
        data.extra['show_pay_now'] == true ||
        data.extra['can_pay_now'] == true ||
        data.isCod;
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['id']?.toString() ?? '') ?? 0;

    // Prefer explicit is_read / is_unread when present.
    String status = json['status']?.toString() ?? '';
    if (json.containsKey('is_read')) {
      final read = json['is_read'] == true ||
          json['is_read']?.toString() == '1' ||
          json['is_read']?.toString().toLowerCase() == 'true';
      status = read ? 'read' : 'unread';
    } else if (json.containsKey('is_unread')) {
      final unread = json['is_unread'] == true ||
          json['is_unread']?.toString() == '1' ||
          json['is_unread']?.toString().toLowerCase() == 'true';
      status = unread ? 'unread' : 'read';
    } else if (status == '0') {
      status = 'unread';
    } else if (status == '1') {
      status = 'read';
    }

    final rawMessage = (json['message'] ??
            json['body'] ??
            json['description'] ??
            json['content'] ??
            '')
        .toString();
    final message = rawMessage
        .replaceAll('Reminder Description: null', '')
        .replaceAll(' null', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final nested = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : <String, dynamic>{};
    nested.putIfAbsent('appointment_id', () => json['appointment_id']);
    nested.putIfAbsent('book_id', () => json['book_id'] ?? json['appointment_id']);
    nested.putIfAbsent('order_id', () => json['order_id']);
    nested.putIfAbsent(
        'date', () => json['date'] ?? json['created_at'] ?? json['updated_at']);
    nested.putIfAbsent('title', () => json['title']);
    nested.putIfAbsent('message', () => json['message']);

    return NotificationItem(
      id: id,
      uid: json['uid']?.toString() ?? '',
      title: (json['title'] ?? json['name'] ?? nested['title'] ?? '')
          .toString(),
      message: message,
      type: (json['type'] ?? nested['type'] ?? '').toString(),
      status: status.isEmpty ? 'unread' : status,
      data: NotificationData.fromJson(nested),
    );
  }
}

class NotificationData {
  final int? appointmentId;
  final int? orderId;
  final int? bookId;
  final String businessName;
  final String customerName;
  final num price;
  final String date;
  final String status;
  final String paymentUrl;
  final bool showPopup;
  final bool isPaid;
  final String action;
  final Map<String, dynamic> extra;

  NotificationData({
    this.appointmentId,
    this.orderId,
    this.bookId,
    required this.businessName,
    required this.price,
    required this.customerName,
    required this.date,
    required this.status,
    this.paymentUrl = '',
    this.showPopup = false,
    this.isPaid = false,
    this.action = '',
    this.extra = const {},
  });

  int get payBookId =>
      (bookId ?? 0) > 0 ? bookId! : (appointmentId ?? 0);

  int get appointmentStatus {
    final raw = extra['appointment_status'] ?? extra['booking_status'] ?? status;
    final parsed = int.tryParse(raw.toString());
    if (parsed != null) return parsed;
    final text = raw.toString().toLowerCase();
    if (text.contains('cancel') || text.contains('reject')) return 5;
    if (text.contains('complet')) return 4;
    if (text.contains('refund')) return 6;
    return -1;
  }

  int get payMethod =>
      int.tryParse((extra['pay_method'] ?? extra['payment_method'] ?? '').toString()) ??
      0;

  String get payMethodLabel =>
      (extra['pay_method_label'] ?? extra['paid'] ?? extra['payment_method'] ?? '')
          .toString();

  bool get isCod {
    if (payMethod == 1) return true;
    if (payMethod >= 2) return false;
    final label = payMethodLabel.toLowerCase();
    if (label.contains('cod') || label.contains('cash')) return true;
    final showCod = extra['show_cod'] == true || extra['show_cod']?.toString() == '1';
    return showCod;
  }

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    String rawDate = json['date']?.toString() ?? json['created_at']?.toString() ?? '';
    String formattedDate =
        rawDate.contains(' ') ? rawDate.split(' ').first : rawDate;
    final bookId = int.tryParse(
          json['book_id']?.toString() ?? json['appointment_id']?.toString() ?? '',
        ) ??
        0;
    final appointmentId = int.tryParse(
          json['appointment_id']?.toString() ?? json['book_id']?.toString() ?? '',
        ) ??
        0;
    return NotificationData(
      appointmentId: appointmentId > 0 ? appointmentId : null,
      bookId: bookId > 0 ? bookId : null,
      orderId: int.tryParse(json['order_id']?.toString() ?? ''),
      businessName: json['business_name']?.toString() ?? '',
      customerName: json['customer']?.toString() ?? '',
      price: num.tryParse(
            json['price']?.toString() ?? json['amount']?.toString() ?? '',
          ) ??
          0,
      date: formattedDate,
      status: json['status']?.toString() ?? '',
      paymentUrl: (json['payment_url'] ?? json['checkout_url'] ?? '')
          .toString(),
      showPopup: json['show_popup'] == true ||
          json['show_popup']?.toString() == '1',
      isPaid: json['is_paid'] == true || json['is_paid']?.toString() == '1',
      action: json['action']?.toString() ?? '',
      extra: Map<String, dynamic>.from(json),
    );
  }
}
