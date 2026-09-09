class UpgradePaymentUrlData {
  final int orderId;
  final int uid;
  final int planId;
  final String planName;
  final double planAmount;
  final String paymentUrl;
  final String paymentLink;
  final String paymentLinkId;
  final String status;

  UpgradePaymentUrlData({
    required this.orderId,
    required this.uid,
    required this.planId,
    required this.planName,
    required this.planAmount,
    required this.paymentUrl,
    required this.paymentLink,
    required this.paymentLinkId,
    required this.status,
  });

  factory UpgradePaymentUrlData.fromJson(Map<String, dynamic> json) {
    return UpgradePaymentUrlData(
      orderId: int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
      uid: int.tryParse(json['uid']?.toString() ?? '') ?? 0,
      planId: int.tryParse(json['plan_id']?.toString() ?? '') ?? 0,
      planName: json['plan_name']?.toString() ?? '',
      planAmount: double.tryParse(json['plan_amount']?.toString() ?? '') ?? 0,
      paymentUrl: json['payment_url']?.toString() ??
          json['payment_link']?.toString() ??
          '',
      paymentLink: json['payment_link']?.toString() ??
          json['payment_url']?.toString() ??
          '',
      paymentLinkId: json['payment_link_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class UpgradeVerifyData {
  final int orderId;
  final String paymentStatus;
  final bool isPremium;
  final String? upgradeExpiresAt;
  final double amount;
  final int planId;

  UpgradeVerifyData({
    required this.orderId,
    required this.paymentStatus,
    required this.isPremium,
    this.upgradeExpiresAt,
    required this.amount,
    required this.planId,
  });

  bool get isPaid => paymentStatus.toLowerCase() == 'paid';

  factory UpgradeVerifyData.fromJson(Map<String, dynamic> json) {
    return UpgradeVerifyData(
      orderId: int.tryParse(json['order_id']?.toString() ?? '') ?? 0,
      paymentStatus: json['payment_status']?.toString() ?? 'pending',
      isPremium: json['is_premium'] == true,
      upgradeExpiresAt: json['upgrade_expires_at']?.toString(),
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      planId: int.tryParse(json['plan_id']?.toString() ?? '') ?? 0,
    );
  }
}
