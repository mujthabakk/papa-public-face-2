class CouponsModel {
  int? id;
  String? name;
  String? shortDescriptions;
  String? code;
  int? type;
  int? forWhome;
  double? discount;
  double? upto;
  String? expire;
  String? freelancerIds;
  int? maxUsage;
  double? minCartValue;
  int? validations;
  int? userLimitValidation;
  String? extraField;
  int? status;
  bool? maxUsageExceeded; // Added missing field

  CouponsModel({
    this.id,
    this.name,
    this.shortDescriptions,
    this.code,
    this.type,
    this.forWhome,
    this.discount,
    this.upto,
    this.expire,
    this.freelancerIds,
    this.maxUsage,
    this.minCartValue,
    this.validations,
    this.userLimitValidation,
    this.extraField,
    this.status,
    this.maxUsageExceeded, // Added to constructor
  });

  CouponsModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    shortDescriptions = json['short_descriptions']?.toString();
    code = json['code']?.toString();
    type = int.tryParse(json['type']?.toString() ?? '') ?? 1;
    discount = double.tryParse(json['discount']?.toString() ?? '') ?? 0;
    upto = double.tryParse(json['upto']?.toString() ?? '') ?? 0;
    expire = json['expire']?.toString();
    freelancerIds = json['freelancer_ids']?.toString();
    maxUsage = int.tryParse(json['max_usage']?.toString() ?? '') ?? 0;
    minCartValue = double.tryParse(json['min_cart_value']?.toString() ?? '') ?? 0;
    validations = int.tryParse(json['validations']?.toString() ?? '') ?? 0;
    userLimitValidation =
        int.tryParse(json['user_limit_validation']?.toString() ?? '') ?? 0;
    extraField = json['extra_field']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    maxUsageExceeded = json['max_usage_exceeded'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['short_descriptions'] = shortDescriptions;
    data['code'] = code;
    data['type'] = type;
    data['for'] = forWhome;
    data['discount'] = discount;
    data['upto'] = upto;
    data['expire'] = expire;
    data['freelancer_ids'] = freelancerIds;
    data['max_usage'] = maxUsage;
    data['min_cart_value'] = minCartValue;
    data['validations'] = validations;
    data['user_limit_validation'] = userLimitValidation;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['max_usage_exceeded'] = maxUsageExceeded; // Added to toJson
    return data;
  }
}
