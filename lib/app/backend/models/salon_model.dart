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
    serviceId = json['service_id'] ?? 0; // Default to 0 if null
    serviceName = json['service_name'] ?? 'Unknown Service';
    id = json['id'] ?? 0;
    uid = json['uid'] ?? 0;
    name = json['name'] ?? 'Unknown Name';
    isPremium = json['isPremium'] ?? false;
    rating = json['rating'] != null
        ? double.tryParse(json['rating'].toString()) ?? 0.0
        : 0.0;
    totalRating = json['total_rating'] ?? 0;
    address = json['address'] ?? 'Unknown Address';
    cover = json['cover'] ?? ''; // Empty string if no image
    salonLat = json['salon_lat'] != null
        ? double.tryParse(json['salon_lat'].toString()) ?? 0.0
        : 0.0;
    salonLng = json['salon_lng'] != null
        ? double.tryParse(json['salon_lng'].toString()) ?? 0.0
        : 0.0;
    distance = json['distance'] != null
        ? double.tryParse(json['distance'].toString()) ?? 0.0
        : 0.0;
    gender = json['gender'] ?? 0;
    duration = json['duration'] != null
        ? int.tryParse(json['duration'].toString()) ?? 0
        : 0;
    price = json['price'] != null
        ? double.tryParse(json['price'].toString()) ?? 0.0
        : 0.0;
    off = json['off'] != null
        ? double.tryParse(json['off'].toString()) ?? 0.0
        : 0.0;
    discount = json['discount'] != null
        ? double.tryParse(json['discount'].toString()) ?? 0.0
        : 0.0;
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
    data['isPremium'] = isPremium;
    data['total_rating'] = totalRating;
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
