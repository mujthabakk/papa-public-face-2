class TaxSettingsData {
  final double taxRate;
  final bool taxInclusive;
  final String mode;
  final String description;

  TaxSettingsData({
    required this.taxRate,
    required this.taxInclusive,
    required this.mode,
    required this.description,
  });

  factory TaxSettingsData.fromJson(Map<String, dynamic> json) {
    return TaxSettingsData(
      taxRate: double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0,
      taxInclusive: json['tax_inclusive'] == true ||
          json['tax_inclusive']?.toString() == '1',
      mode: json['mode']?.toString() ?? 'inclusive',
      description: json['description']?.toString() ?? '',
    );
  }
}

class PricingBookingFields {
  final double total;
  final double serviceTax;
  final double grandTotal;

  PricingBookingFields({
    required this.total,
    required this.serviceTax,
    required this.grandTotal,
  });

  factory PricingBookingFields.fromJson(Map<String, dynamic> json) {
    return PricingBookingFields(
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
      serviceTax: double.tryParse(json['serviceTax']?.toString() ?? '') ?? 0,
      grandTotal:
          double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
    );
  }
}

class PricingOrderFields {
  final double total;
  final double tax;
  final double grandTotal;

  PricingOrderFields({
    required this.total,
    required this.tax,
    required this.grandTotal,
  });

  factory PricingOrderFields.fromJson(Map<String, dynamic> json) {
    return PricingOrderFields(
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0,
      grandTotal:
          double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
    );
  }
}

class AppointmentPricingData {
  final double taxRate;
  final bool taxInclusive;
  final double servicesAmount;
  final double discount;
  final double distanceCost;
  final double walletAmount;
  final double taxableValue;
  final double serviceTax;
  final double grandTotal;
  final PricingBookingFields bookingFields;

  AppointmentPricingData({
    required this.taxRate,
    required this.taxInclusive,
    required this.servicesAmount,
    required this.discount,
    required this.distanceCost,
    required this.walletAmount,
    required this.taxableValue,
    required this.serviceTax,
    required this.grandTotal,
    required this.bookingFields,
  });

  factory AppointmentPricingData.fromJson(Map<String, dynamic> json) {
    final bookingRaw = json['booking_fields'];
    return AppointmentPricingData(
      taxRate: double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0,
      taxInclusive: json['tax_inclusive'] == true ||
          json['tax_inclusive']?.toString() == '1',
      servicesAmount:
          double.tryParse(json['services_amount']?.toString() ?? '') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0,
      distanceCost:
          double.tryParse(json['distance_cost']?.toString() ?? '') ?? 0,
      walletAmount:
          double.tryParse(json['wallet_amount']?.toString() ?? '') ?? 0,
      taxableValue:
          double.tryParse(json['taxable_value']?.toString() ?? '') ?? 0,
      serviceTax: double.tryParse(json['service_tax']?.toString() ??
              json['serviceTax']?.toString() ??
              '') ??
          0,
      grandTotal: double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
      bookingFields: bookingRaw is Map
          ? PricingBookingFields.fromJson(
              Map<String, dynamic>.from(bookingRaw),
            )
          : PricingBookingFields(
              total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
              serviceTax: double.tryParse(json['serviceTax']?.toString() ?? '') ??
                  0,
              grandTotal:
                  double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
            ),
    );
  }
}

class ProductPricingData {
  final double taxRate;
  final bool taxInclusive;
  final double itemsAmount;
  final double discount;
  final double deliveryCharge;
  final double walletAmount;
  final double taxableValue;
  final double tax;
  final double grandTotal;
  final PricingOrderFields orderFields;

  ProductPricingData({
    required this.taxRate,
    required this.taxInclusive,
    required this.itemsAmount,
    required this.discount,
    required this.deliveryCharge,
    required this.walletAmount,
    required this.taxableValue,
    required this.tax,
    required this.grandTotal,
    required this.orderFields,
  });

  factory ProductPricingData.fromJson(Map<String, dynamic> json) {
    final orderRaw = json['order_fields'];
    return ProductPricingData(
      taxRate: double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0,
      taxInclusive: json['tax_inclusive'] == true ||
          json['tax_inclusive']?.toString() == '1',
      itemsAmount:
          double.tryParse(json['items_amount']?.toString() ?? '') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0,
      deliveryCharge:
          double.tryParse(json['delivery_charge']?.toString() ?? '') ?? 0,
      walletAmount:
          double.tryParse(json['wallet_amount']?.toString() ?? '') ?? 0,
      taxableValue:
          double.tryParse(json['taxable_value']?.toString() ?? '') ?? 0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0,
      grandTotal: double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
      orderFields: orderRaw is Map
          ? PricingOrderFields.fromJson(Map<String, dynamic>.from(orderRaw))
          : PricingOrderFields(
              total: double.tryParse(json['total']?.toString() ?? '') ?? 0,
              tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0,
              grandTotal:
                  double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
            ),
    );
  }
}
