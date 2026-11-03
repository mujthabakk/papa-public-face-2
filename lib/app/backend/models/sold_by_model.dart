/*Papabear*/
class SoldByModel {
  int? id;
  int? uid;
  String? lastName;
  String? firstName;
  String? name;
  String? cover;
  String? address;
  int? status;
  int? productsCount;
  String? type;
  String? lat;
  String? lng;

  SoldByModel({
    this.id,
    this.uid,
    this.lastName,
    this.firstName,
    this.name,
    this.cover,
    this.address,
    this.status,
    this.productsCount,
    this.type,
    this.lat,
    this.lng,
  });

  String get displayName {
    final n = (name ?? '').trim();
    if (n.isNotEmpty) return n;
    return '${firstName ?? ''} ${lastName ?? ''}'.trim();
  }

  int get sellerUid {
    final u = uid ?? 0;
    if (u > 0) return u;
    return id ?? 0;
  }

  SoldByModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? id;
    lastName = json['last_name']?.toString();
    firstName = json['first_name']?.toString();
    name = json['name']?.toString() ??
        '${firstName ?? ''} ${lastName ?? ''}'.trim();
    cover = json['cover']?.toString() ?? json['image']?.toString();
    address = json['address']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '');
    productsCount = int.tryParse(json['products_count']?.toString() ?? '');
    type = json['type']?.toString() ?? 'product';
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['last_name'] = lastName;
    data['first_name'] = firstName;
    data['name'] = name;
    data['cover'] = cover;
    data['address'] = address;
    data['status'] = status;
    data['products_count'] = productsCount;
    data['type'] = type;
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
