class TopPartnerModel {
  int? id;
  int? uid;
  int? salonId;
  String? name;
  String? cover;
  String? address;
  String? lat;
  String? lng;
  double? rating;
  int? totalRating;
  int? reviewsCount;
  String? badge;
  int? sortOrder;
  String? city;
  double? distance;

  TopPartnerModel({
    this.id,
    this.uid,
    this.salonId,
    this.name,
    this.cover,
    this.address,
    this.lat,
    this.lng,
    this.rating,
    this.totalRating,
    this.reviewsCount,
    this.badge,
    this.sortOrder,
    this.city,
    this.distance,
  });

  factory TopPartnerModel.fromJson(Map<String, dynamic> json) {
    return TopPartnerModel(
      id: int.tryParse(json['id']?.toString() ?? ''),
      uid: int.tryParse(json['uid']?.toString() ?? ''),
      salonId: int.tryParse(json['salon_id']?.toString() ?? ''),
      name: json['name']?.toString(),
      cover: json['cover']?.toString(),
      address: json['address']?.toString(),
      lat: json['lat']?.toString(),
      lng: json['lng']?.toString(),
      rating: double.tryParse(json['rating']?.toString() ?? ''),
      totalRating: int.tryParse(json['total_rating']?.toString() ?? ''),
      reviewsCount: int.tryParse(
            json['reviewsCount']?.toString() ??
                json['reviews_count']?.toString() ??
                json['review_count']?.toString() ??
                '') ??
          0,
      badge: json['badge']?.toString(),
      sortOrder: int.tryParse(json['sort_order']?.toString() ?? ''),
      city: json['city']?.toString(),
      distance: double.tryParse(json['distance']?.toString() ?? ''),
    );
  }
}
