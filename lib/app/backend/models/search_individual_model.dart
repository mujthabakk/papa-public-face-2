// class SearchIndividualModel {
//   int? id;
//   int? uid;
//   String? lat;
//   String? lng;
//   String? firstName;
//   String? lastName;
//   String? cover;
//   double? distance;

//   SearchIndividualModel(
//       {this.id,
//       this.uid,
//       this.lat,
//       this.lng,
//       this.firstName,
//       this.lastName,
//       this.cover,
//       this.distance});

//   SearchIndividualModel.fromJson(Map<String, dynamic> json) {
//     id = int.parse(json['id'].toString());
//     uid = int.parse(json['uid'].toString());
//     lat = json['lat'];
//     lng = json['lng'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     cover = json['cover'];
//     distance = double.parse(json['distance'].toString());
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['uid'] = uid;
//     data['lat'] = lat;
//     data['lng'] = lng;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['cover'] = cover;
//     data['distance'] = distance;
//     return data;
//   }
// }

class SearchIndividualModel {
  int? serviceId;
  String? serviceName;
  int? id;
  int? uid;
  String? name;
  double? rating;
  int? totalRating;
  String? address;
  String? cover;
  bool? isPremium;
  int? status;

  double? salonLat;
  double? salonLng;
  double? distance;
  int? gender;
  int? duration;
  double? price;
  double? off;
  double? discount;
  // List<int>? categories; // For parsing "categories"
  int? reviewCount;

  SearchIndividualModel({
    this.serviceId,
    this.serviceName,
    this.id,
    this.uid,
    this.name,
    this.status,
    this.rating,
    this.isPremium,
    this.totalRating,
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
    //  this.categories,
    this.reviewCount, // Default to 0 if not provided
  });

  SearchIndividualModel.fromJson(Map<String, dynamic> json) {
    serviceId = int.tryParse(json['service_id']?.toString() ?? '') ?? 0;
    serviceName = json['service_name']?.toString() ?? 'Unknown Service';
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    name = json['name']?.toString() ?? 'Unknown Name';
    isPremium = json['is_premium'] == true ||
        json['is_premium']?.toString() == '1';
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
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
    reviewCount = int.tryParse(json['review_count']?.toString() ?? '') ?? 0;
  }

  // Serializing to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = serviceId;
    data['service_name'] = serviceName;
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['is_premium'] = isPremium;
    data['status'] = status;

    data['rating'] = rating;
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
