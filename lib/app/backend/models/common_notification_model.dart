import 'dart:convert';

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
    return NotificationModel(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
              ?.map((e) => NotificationItem.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? 0,
    );
  }
}

class NotificationItem {
  final int id;
  final String uid;
  final String title;
  final String message;
  final String type;
  final String status;
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

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      uid: json['uid'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final int? appointmentId;
  final int? orderId;
  final String businessName;
  final num price;
  final String date;
  final String status;

  NotificationData({
    this.appointmentId,
    this.orderId,
    required this.businessName,
    required this.price,
    required this.date,
    required this.status,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      appointmentId: json['appointment_id'],
      orderId: json['order_id'],
      businessName: json['business_name'] ?? '',
      price: json['price'] ?? 0,
      date: json['date'] ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}
