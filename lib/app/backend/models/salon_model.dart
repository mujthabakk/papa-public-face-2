class SalonModel {
  int? serviceId;
  String? serviceName;
  int? id;
  int? uid;
  String? name;
  double? rating;
  int? totalRating;
  String? address;
  String? cover;
  double? salonLat;
  double? salonLng;
  bool? isPremium;
  double? distance;
  int? gender;
  int? status;
  int? duration;
  double? price;
  double? off;
  double? discount;
  //List<int>? categories; // For parsing "categories"
  int? reviewCount;

  SalonModel({
    this.serviceId,
    this.serviceName,
    this.id,
    this.uid,
    this.status,
    this.name,
    this.rating,
    this.totalRating,
    this.isPremium,
    this.address,
    this.cover,
    this.salonLat,
    this.salonLng,
    this.distance,
    this.gender,
    this.duration,
    this.price,
    this.off,
    this.discount,
    // this.categories,
    this.reviewCount, // Default to 0 if not provided
  });

  // Parsing JSON data with null checks and default values
  SalonModel.fromJson(Map<String, dynamic> json) {
    serviceId = int.tryParse(json['service_id']?.toString() ?? '') ?? 0;
    serviceName = json['service_name']?.toString() ?? 'Unknown Service';
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    name = json['name']?.toString() ?? 'Unknown Name';
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    isPremium = json['is_premium'] == true ||
        json['is_premium']?.toString() == '1';
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0.0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    address = json['address']?.toString() ?? 'Unknown Address';
    cover = json['cover']?.toString() ?? '';
    salonLat = double.tryParse(
            (json['salon_lat'] ?? json['lat'])?.toString() ?? '') ??
        0.0;
    salonLng = double.tryParse(
            (json['salon_lng'] ?? json['lng'])?.toString() ?? '') ??
        0.0;
    distance = double.tryParse(json['distance']?.toString() ?? '') ?? 0.0;
    gender = int.tryParse(json['gender']?.toString() ?? '') ?? 0;
    duration = int.tryParse(json['duration']?.toString() ?? '') ?? 0;
    price = double.tryParse(json['price']?.toString() ?? '') ?? 0.0;
    off = double.tryParse(json['off']?.toString() ?? '') ?? 0.0;
    discount = double.tryParse(json['discount']?.toString() ?? '') ?? 0.0;
    // categories = json['categories'] != null
    //     ? (json['categories'] as String)
    //         .replaceAll(RegExp(r'[\[\]]'), '') // Remove brackets
    //         .split(',')
    //         .map((e) => int.tryParse(e) ?? 0)
    //         .toList()
    //     : <int>[]; // Empty list if no categories
    reviewCount = json['review_count'] ?? 0;
  }

  // Serializing to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['rating'] = rating;
    data['is_premium'] = isPremium;
    data['total_rating'] = totalRating;
    data['status'] = status;
    data['address'] = address;
    data['cover'] = cover;
    data['salon_lat'] = salonLat;
    data['salon_lng'] = salonLng;
    data['distance'] = distance;
    data['gender'] = gender;
    data['duration'] = duration;
    data['price'] = price;
    data['off'] = off;
    data['discount'] = discount;
    //data['categories'] = categories;
    data['review_count'] = reviewCount;
    return data;
  }
}
