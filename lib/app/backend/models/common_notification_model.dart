class NotificationModel {
  final bool success;
  final List<NotificationItem> data;
  final int status;

  NotificationModel({
    required this.success,
    required this.data,
    required this.status,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final list = <NotificationItem>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map) {
          list.add(NotificationItem.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    return NotificationModel(
      success: json['success'] == true || json['success']?.toString() == '1',
      data: list,
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

    final rawMessage = json['message']?.toString() ?? '';
    final message = rawMessage
        .replaceAll('Reminder Description: null', '')
        .replaceAll(' null', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return NotificationItem(
      id: id,
      uid: json['uid']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: message,
      type: json['type']?.toString() ?? '',
      status: status.isEmpty ? 'unread' : status,
      data: NotificationData.fromJson(
        json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : <String, dynamic>{},
      ),
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
