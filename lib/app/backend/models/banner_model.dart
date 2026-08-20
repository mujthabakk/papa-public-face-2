import 'package:salon_user/app/backend/api/api_response.dart';

class BannerModel {
  int? id;
  int? cityId;
  String? cover;
  int? type;
  String? value;
  String? title;
  String? from;
  String? to;
  String? extraField;
  int? status;

  BannerModel(
      {this.id,
      this.cityId,
      this.cover,
      this.type,
      this.value,
      this.title,
      this.from,
      this.to,
      this.extraField,
      this.status});

  BannerModel.fromJson(Map<String, dynamic> json) {
    id = ApiBody.asInt(json['id']);
    cityId = ApiBody.asInt(json['city_id']);
    cover = ApiBody.text(json['cover'] ?? json['image']);
    type = ApiBody.asInt(json['type']);
    value = ApiBody.text(json['value']);
    title = ApiBody.text(json['title']);
    from = ApiBody.text(json['from']);
    to = ApiBody.text(json['to']);
    extraField = ApiBody.text(json['extra_field']);
    status = ApiBody.asInt(json['status'], fallback: 1);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city_id'] = cityId;
    data['cover'] = cover;
    data['type'] = type;
    data['value'] = value;
    data['title'] = title;
    data['from'] = from;
    data['to'] = to;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
