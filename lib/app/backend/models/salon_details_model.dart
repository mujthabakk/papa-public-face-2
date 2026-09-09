import 'dart:convert';

import 'package:salon_user/app/backend/models/salon_social_model.dart';
import 'package:salon_user/app/backend/models/timing_model.dart';

class SalonDetailsModel {
  int? id;
  int? uid;
  String? name;
  String? cover;
  String? categories;
  String? address;
  double? lat;
  double? lng;
  int? cid;
  String? about;
  double? rating;
  int? totalRating;
  String? website;
  List<TimingModel>? timing;
  String? images;
  String? zipcode;
  int? serviceAtHome;
  int? verified;
  int? inHome;
  int? popular;
  int? haveShop;
  int? haveStylist;
  String? extraField;
  String? email;
  String? mobile;
  int? status;
  SalonSocialLinks? socialLinks;

  SalonDetailsModel(
      {this.id,
      this.uid,
      this.name,
      this.cover,
      this.categories,
      this.address,
      this.lat,
      this.lng,
      this.cid,
      this.about,
      this.rating,
      this.totalRating,
      this.website,
      this.timing,
      this.images,
      this.zipcode,
      this.serviceAtHome,
      this.verified,
      this.inHome,
      this.popular,
      this.haveShop,
      this.haveStylist,
      this.extraField,
      this.email,
      this.mobile,
      this.status});

  SalonDetailsModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    cover = json['cover']?.toString();
    categories = json['categories']?.toString();
    address = json['address']?.toString();
    lat = double.tryParse(json['lat']?.toString() ?? '') ?? 0;
    lng = double.tryParse(json['lng']?.toString() ?? '') ?? 0;
    cid = int.tryParse(json['cid']?.toString() ?? '') ?? 0;
    about = json['about']?.toString();
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    website = json['website']?.toString();
    timing = _parseTiming(json['timing']);
    images = json['images']?.toString();
    zipcode = json['zipcode']?.toString();
    serviceAtHome = int.tryParse(json['service_at_home']?.toString() ?? '') ?? 0;
    verified = int.tryParse(json['verified']?.toString() ?? '') ?? 0;
    inHome = int.tryParse(json['in_home']?.toString() ?? '') ?? 0;
    popular = int.tryParse(json['popular']?.toString() ?? '') ?? 0;
    haveShop = int.tryParse(json['have_shop']?.toString() ?? '') ?? 0;
    haveStylist = int.tryParse(json['have_stylist']?.toString() ?? '') ?? 0;
    extraField = json['extra_field']?.toString();
    email = json['email']?.toString();
    mobile = json['mobile']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '') ?? 0;
    socialLinks = SalonSocialLinks.fromSalonJson(json);
  }

  static List<TimingModel> _parseTiming(dynamic raw) {
    if (raw == null || raw == 'NA' || raw == '') return [];
    try {
      final items = raw is String ? jsonDecode(raw) : raw;
      if (items is! List) return [];
      return items
          .whereType<Map>()
          .map((v) => TimingModel.fromJson(Map<String, dynamic>.from(v)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['cover'] = cover;
    data['categories'] = categories;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['cid'] = cid;
    data['about'] = about;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['website'] = website;
    data['timing'] = timing;
    data['images'] = images;
    data['zipcode'] = zipcode;
    data['service_at_home'] = serviceAtHome;
    data['verified'] = verified;
    data['in_home'] = inHome;
    data['popular'] = popular;
    data['have_shop'] = haveShop;
    data['have_stylist'] = haveStylist;
    data['extra_field'] = extraField;
    data['email'] = email;
    data['mobile'] = mobile;
    data['status'] = status;
    return data;
  }

  SalonSocialLinks get contactLinks =>
      socialLinks ?? SalonSocialLinks.fromSalonJson(toJson());
}
