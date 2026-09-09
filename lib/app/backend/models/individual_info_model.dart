import 'dart:convert';

import 'package:salon_user/app/backend/models/salon_social_model.dart';
import 'package:salon_user/app/backend/models/timing_model.dart';

class IndividualInfoModel {
  int? id;
  int? uid;
  String? background;
  String? categories;
  String? address;
  double? lat;
  double? lng;
  int? cid;
  String? about;
  double? rating;
  double? feeStart;
  int? totalRating;
  String? website;
  List<TimingModel>? timing;
  String? images;
  String? zipcode;
  int? verified;
  int? inHome;
  int? popular;
  int? haveShop;
  String? extraField;
  int? status;
  String? email;
  String? mobile;
  SalonSocialLinks? socialLinks;

  IndividualInfoModel(
      {this.id,
      this.uid,
      this.background,
      this.categories,
      this.address,
      this.lat,
      this.lng,
      this.cid,
      this.about,
      this.rating,
      this.feeStart,
      this.totalRating,
      this.website,
      this.timing,
      this.images,
      this.zipcode,
      this.verified,
      this.inHome,
      this.popular,
      this.haveShop,
      this.extraField,
      this.status,
      this.email,
      this.mobile});

  IndividualInfoModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    background = json['background']?.toString();
    categories = json['categories']?.toString();
    address = json['address']?.toString();
    lat = double.tryParse(json['lat']?.toString() ?? '') ?? 0;
    lng = double.tryParse(json['lng']?.toString() ?? '') ?? 0;
    cid = int.tryParse(json['cid']?.toString() ?? '') ?? 0;
    about = json['about']?.toString();
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0;
    feeStart = double.tryParse(json['fee_start']?.toString() ?? '') ?? 0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    website = json['website']?.toString();
    timing = _parseTiming(json['timing']);
    images = json['images']?.toString();
    zipcode = json['zipcode']?.toString();
    verified = int.tryParse(json['verified']?.toString() ?? '') ?? 0;
    inHome = int.tryParse(json['in_home']?.toString() ?? '') ?? 0;
    popular = int.tryParse(json['popular']?.toString() ?? '') ?? 0;
    haveShop = int.tryParse(json['have_shop']?.toString() ?? '') ?? 0;
    extraField = json['extra_field']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '') ?? 0;
    email = json['email']?.toString();
    mobile = json['mobile']?.toString();
    socialLinks = SalonSocialLinks.fromJson(json);
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
    data['background'] = background;
    data['categories'] = categories;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['cid'] = cid;
    data['about'] = about;
    data['rating'] = rating;
    data['fee_start'] = feeStart;
    data['total_rating'] = totalRating;
    data['website'] = website;
    data['timing'] = timing;
    data['images'] = images;
    data['zipcode'] = zipcode;
    data['verified'] = verified;
    data['in_home'] = inHome;
    data['popular'] = popular;
    data['have_shop'] = haveShop;
    data['extra_field'] = extraField;
    data['status'] = status;
    data['email'] = email;
    data['mobile'] = mobile;
    return data;
  }

  SalonSocialLinks get contactLinks =>
      socialLinks ?? SalonSocialLinks.fromJson(toJson());
}
