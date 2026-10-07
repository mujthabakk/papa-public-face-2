import 'package:salon_user/app/backend/api/api_response.dart';

class PartnerAdModel {
  int? id;
  String? country;
  String? city;
  int? cityId;
  String? title;
  String? image;
  String? link;
  int? sortOrder;
  int? status;
  String? fromDate;
  String? toDate;

  PartnerAdModel({
    this.id,
    this.country,
    this.city,
    this.cityId,
    this.title,
    this.image,
    this.link,
    this.sortOrder,
    this.status,
    this.fromDate,
    this.toDate,
  });

  factory PartnerAdModel.fromJson(Map<String, dynamic> json) {
    return PartnerAdModel(
      id: ApiBody.asInt(json['id']),
      country: ApiBody.text(json['country']),
      city: ApiBody.text(json['city']),
      cityId: ApiBody.asInt(json['city_id']),
      title: ApiBody.text(json['title']),
      image: ApiBody.text(json['image'] ?? json['cover']),
      link: ApiBody.text(json['link'] ?? json['value'] ?? json['url']),
      sortOrder: ApiBody.asInt(json['sort_order']),
      status: ApiBody.asInt(json['status'], fallback: 1),
      fromDate: ApiBody.text(json['from_date'] ?? json['from']),
      toDate: ApiBody.text(json['to_date'] ?? json['to']),
    );
  }
}
