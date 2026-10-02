class PaymentModel {
  int? id;
  String? name;
  String? cover;
  int? env;
  int? status;
  String? currencyCode;
  String? extraField;
  String? type;

  PaymentModel({
    this.id,
    this.name,
    this.cover,
    this.env,
    this.status,
    this.currencyCode,
    this.extraField,
    this.type,
  });

  bool get isCod {
    final t = (type ?? '').toLowerCase();
    if (t == 'cod') return true;
    return id == 1;
  }

  bool get isOnline => !isCod;

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    cover = json['cover']?.toString();
    env = int.tryParse(json['env']?.toString() ?? '');
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    currencyCode = json['currency_code']?.toString();
    extraField = json['extra_field']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cover': cover,
      'env': env,
      'status': status,
      'currency_code': currencyCode,
      'extra_field': extraField,
      'type': type,
    };
  }
}
