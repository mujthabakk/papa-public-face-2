String? _offerString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty || text == 'null' || text == 'undefined') return null;
  return text;
}

List<int> parseIdList(dynamic raw) {
  final ids = <int>[];
  if (raw is! List) return ids;
  for (final item in raw) {
    final id = item is int ? item : int.tryParse('$item') ?? 0;
    if (id > 0) ids.add(id);
  }
  return ids;
}

class OfferPartnerModel {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? type;
  String? cover;
  String? image;
  String? address;
  String? lat;
  String? lng;

  OfferPartnerModel({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.type,
    this.cover,
    this.image,
    this.address,
    this.lat,
    this.lng,
  });

  factory OfferPartnerModel.fromJson(dynamic json) {
    final map =
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    Map<String, dynamic> location = {};
    if (map['location'] is Map) {
      location = Map<String, dynamic>.from(map['location']);
    }
    return OfferPartnerModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      firstName: _offerString(map['first_name']),
      lastName: _offerString(map['last_name']),
      name: _offerString(map['name']),
      type: _offerString(map['type']),
      cover: _offerString(map['cover']) ?? _offerString(map['image']),
      image: _offerString(map['image']) ?? _offerString(map['cover']),
      address: _offerString(map['address']) ?? _offerString(location['address']),
      lat: _offerString(map['lat']) ??
          _offerString(location['lat']) ??
          _offerString(location['latitude']),
      lng: _offerString(map['lng']) ??
          _offerString(location['lng']) ??
          _offerString(location['longitude']),
    );
  }

  String get displayName {
    if ((name ?? '').isNotEmpty) return name!;
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  String get coverPath => cover ?? image ?? '';
}

class OfferServiceModel {
  int? id;
  int? serviceId;
  String? name;
  String? cover;
  String? image;
  double? price;
  double? amount;
  double? duration;
  double? discount;
  int? status;

  OfferServiceModel({
    this.id,
    this.serviceId,
    this.name,
    this.cover,
    this.image,
    this.price,
    this.amount,
    this.duration,
    this.discount,
    this.status,
  });

  factory OfferServiceModel.fromJson(dynamic json) {
    final map =
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    return OfferServiceModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      serviceId: int.tryParse(map['service_id']?.toString() ?? ''),
      name: _offerString(map['name']),
      cover: _offerString(map['cover']) ?? _offerString(map['image']),
      image: _offerString(map['image']) ?? _offerString(map['cover']),
      price: double.tryParse(map['price']?.toString() ?? '') ??
          double.tryParse(map['amount']?.toString() ?? ''),
      amount: double.tryParse(map['amount']?.toString() ?? '') ??
          double.tryParse(map['price']?.toString() ?? ''),
      duration: double.tryParse(map['duration']?.toString() ?? ''),
      discount: double.tryParse(map['discount']?.toString() ?? ''),
      status: int.tryParse(map['status']?.toString() ?? ''),
    );
  }

  String get coverPath => cover ?? image ?? '';
}

class CouponsModel {
  int? id;
  String? name;
  String? shortDescriptions;
  String? code;
  int? type;
  int? forWhome;
  double? discount;
  double? upto;
  String? startDate;
  String? expire;
  String? freelancerIds;
  String? partnerIds;
  String? serviceIds;
  String? couponScope;
  int? maxUsage;
  double? minCartValue;
  int? validations;
  int? userLimitValidation;
  String? extraField;
  int? status;
  bool? maxUsageExceeded;
  List<OfferPartnerModel> partners = [];
  List<OfferServiceModel> services = [];
  OfferPartnerModel? partner;

  CouponsModel({
    this.id,
    this.name,
    this.shortDescriptions,
    this.code,
    this.type,
    this.forWhome,
    this.discount,
    this.upto,
    this.startDate,
    this.expire,
    this.freelancerIds,
    this.partnerIds,
    this.serviceIds,
    this.couponScope,
    this.maxUsage,
    this.minCartValue,
    this.validations,
    this.userLimitValidation,
    this.extraField,
    this.status,
    this.maxUsageExceeded,
    List<OfferPartnerModel>? partners,
    List<OfferServiceModel>? services,
    this.partner,
  }) {
    this.partners = partners ?? [];
    this.services = services ?? [];
  }

  static CouponsModel? tryParse(dynamic json) {
    try {
      if (json is! Map) return null;
      final model = CouponsModel.fromJson(Map<String, dynamic>.from(json));
      if ((model.id ?? 0) <= 0 &&
          (model.code ?? '').isEmpty &&
          (model.name ?? '').isEmpty) {
        return null;
      }
      return model;
    } catch (_) {
      return null;
    }
  }

  CouponsModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    name = _offerString(json['name']);
    shortDescriptions = _offerString(json['short_descriptions']);
    code = _offerString(json['code']);
    type = int.tryParse(json['type']?.toString() ?? '') ?? 1;
    forWhome = int.tryParse(json['for']?.toString() ?? '');
    discount = double.tryParse(json['discount']?.toString() ?? '') ?? 0;
    upto = double.tryParse(json['upto']?.toString() ?? '') ?? 0;
    startDate = _offerString(json['start_date']);
    expire = _offerString(json['expire']);
    freelancerIds = _offerString(json['freelancer_ids']) ??
        _offerString(json['partner_ids']);
    partnerIds = _offerString(json['partner_ids']);
    serviceIds = _offerString(json['service_ids']);
    couponScope = _offerString(json['coupon_scope']);
    maxUsage = int.tryParse(json['max_usage']?.toString() ?? '') ?? 0;
    minCartValue =
        double.tryParse(json['min_cart_value']?.toString() ?? '') ?? 0;
    validations = int.tryParse(json['validations']?.toString() ?? '') ?? 0;
    userLimitValidation =
        int.tryParse(json['user_limit_validation']?.toString() ?? '') ?? 0;
    extraField = _offerString(json['extra_field']);
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    maxUsageExceeded = json['max_usage_exceeded'] == true ||
        json['max_usage_exceeded']?.toString() == '1';

    try {
      final rawPartners = json['partners'];
      if (rawPartners is List) {
        partners = rawPartners
            .map((e) => OfferPartnerModel.fromJson(e))
            .where((p) => (p.id ?? 0) > 0)
            .toList();
      } else if (rawPartners is Map) {
        final parsed = OfferPartnerModel.fromJson(rawPartners);
        if ((parsed.id ?? 0) > 0) partners = [parsed];
      }
    } catch (_) {}

    try {
      if (json['partner'] is Map) {
        partner = OfferPartnerModel.fromJson(json['partner']);
        if (partners.isEmpty && (partner?.id ?? 0) > 0) {
          partners = [partner!];
        }
      }
    } catch (_) {}

    try {
      final rawServices = json['services'];
      if (rawServices is List) {
        services = rawServices
            .map((e) => OfferServiceModel.fromJson(e))
            .where((s) => (s.name ?? '').isNotEmpty)
            .toList();
      } else if (rawServices is Map) {
        final parsed = OfferServiceModel.fromJson(rawServices);
        if ((parsed.name ?? '').isNotEmpty) services = [parsed];
      }
    } catch (_) {}
  }

  bool get isPublicScope =>
      (couponScope ?? '').toLowerCase() == 'public' ||
      (partnerIds ?? '').toUpperCase() == 'ALL';

  bool get hasPartners =>
      partners.isNotEmpty ||
      (partner?.id ?? 0) > 0 ||
      ((partnerIds ?? '').isNotEmpty &&
          (partnerIds ?? '').toUpperCase() != 'ALL');

  bool get hasServices =>
      services.isNotEmpty ||
      ((serviceIds ?? '').isNotEmpty &&
          (serviceIds ?? '').toLowerCase() != 'null');

  bool get canBook => hasPartners && hasServices;

  List<int> get bookableServiceIds {
    final ids = <int>{};
    for (final service in services) {
      if ((service.id ?? 0) > 0) ids.add(service.id!);
      if ((service.serviceId ?? 0) > 0) ids.add(service.serviceId!);
    }
    for (final raw in (serviceIds ?? '').split(',')) {
      final id = int.tryParse(raw.trim()) ?? 0;
      if (id > 0) ids.add(id);
    }
    return ids.toList();
  }

  String get discountLabel {
    final value = discount ?? 0;
    final pretty = value.truncateToDouble() == value
        ? value.toStringAsFixed(0)
        : value.toString();
    if ((type ?? 1) == 1) return '$pretty% OFF';
    return '₹$pretty OFF';
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
    data['start_date'] = startDate;
    data['expire'] = expire;
    data['freelancer_ids'] = freelancerIds;
    data['partner_ids'] = partnerIds;
    data['service_ids'] = serviceIds;
    data['coupon_scope'] = couponScope;
    data['max_usage'] = maxUsage;
    data['min_cart_value'] = minCartValue;
    data['validations'] = validations;
    data['user_limit_validation'] = userLimitValidation;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['max_usage_exceeded'] = maxUsageExceeded;
    return data;
  }
}
