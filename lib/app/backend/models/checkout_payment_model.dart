class CheckoutPaymentUrlData {
  final int appointmentId;
  final int bookId;
  final int uid;
  final double amount;
  final String currency;
  final String paymentUrl;
  final String paymentLink;
  final String paymentLinkId;
  final String referenceId;
  final String status;

  CheckoutPaymentUrlData({
    required this.appointmentId,
    required this.bookId,
    required this.uid,
    required this.amount,
    required this.currency,
    required this.paymentUrl,
    required this.paymentLink,
    required this.paymentLinkId,
    required this.referenceId,
    required this.status,
  });

  factory CheckoutPaymentUrlData.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['appointment_id']?.toString() ?? '') ??
        int.tryParse(json['book_id']?.toString() ?? '') ??
        0;
    return CheckoutPaymentUrlData(
      appointmentId: id,
      bookId: int.tryParse(json['book_id']?.toString() ?? '') ?? id,
      uid: int.tryParse(json['uid']?.toString() ?? '') ?? 0,
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      currency: json['currency']?.toString() ?? 'INR',
      paymentUrl: json['payment_url']?.toString() ??
          json['payment_link']?.toString() ??
          '',
      paymentLink: json['payment_link']?.toString() ??
          json['payment_url']?.toString() ??
          '',
      paymentLinkId: json['payment_link_id']?.toString() ?? '',
      referenceId: json['reference_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
    );
  }
}

class CheckoutVerifyData {
  final int appointmentId;
  final int bookId;
  final String paymentStatus;
  final double amount;
  final bool paidFlag;

  CheckoutVerifyData({
    required this.appointmentId,
    required this.bookId,
    required this.paymentStatus,
    required this.amount,
    this.paidFlag = false,
  });

  bool get isPaid {
    if (paidFlag) return true;
    final s = paymentStatus.toLowerCase();
    return s == 'paid' || s == 'success' || s == 'completed';
  }

  factory CheckoutVerifyData.fromJson(Map<String, dynamic> json) {
    final id = int.tryParse(json['appointment_id']?.toString() ?? '') ??
        int.tryParse(json['book_id']?.toString() ?? '') ??
        int.tryParse(json['id']?.toString() ?? '') ??
        0;
    return CheckoutVerifyData(
      appointmentId: id,
      bookId: int.tryParse(json['book_id']?.toString() ?? '') ?? id,
      paymentStatus: json['payment_status']?.toString() ??
          json['status']?.toString() ??
          'pending',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      paidFlag: json['is_paid'] == true || json['is_paid']?.toString() == '1',
    );
  }
}
