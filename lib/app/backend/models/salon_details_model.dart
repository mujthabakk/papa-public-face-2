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
  List<String> facilities = [];
  List<String> facilityIds = [];
  List<String> features = [];

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
    facilities = [];
    facilityIds = [];
    features = [];
    _splitIdsAndNames(
      _parseNamedList(json, const [
        'facilities',
        'facility',
        'amenities',
        'amenity',
      ]),
      names: facilities,
      ids: facilityIds,
    );
    for (final item in _parseNamedList(json, const [
      'features',
      'feature',
      'key_features',
      'highlights',
    ])) {
      if (!RegExp(r'^\d+$').hasMatch(item)) {
        _addUnique(features, item);
      }
    }
    if (serviceAtHome == 1 || inHome == 1) {
      _addUnique(facilities, 'Home Service');
    }
    if (haveShop == 1) _addUnique(facilities, 'In Salon');
    if (haveStylist == 1) _addUnique(facilities, 'Stylists');
    if (verified == 1) _addUnique(features, 'Verified');
    if (popular == 1) _addUnique(features, 'Popular');
  }

  static void _splitIdsAndNames(
    List<String> raw, {
    required List<String> names,
    required List<String> ids,
  }) {
    for (final item in raw) {
      if (RegExp(r'^\d+$').hasMatch(item)) {
        _addUnique(ids, item);
      } else {
        _addUnique(names, item);
      }
    }
  }

  static void _addUnique(List<String> list, String value) {
    if (!list.contains(value)) list.add(value);
  }

  static List<String> _parseNamedList(
      Map<String, dynamic> json, List<String> keys) {
    final values = <String>[];
    Map<String, dynamic>? extra;
    final rawExtra = json['extra_field'];
    if (rawExtra is Map) {
      extra = Map<String, dynamic>.from(rawExtra);
    } else if (rawExtra is String &&
        rawExtra.isNotEmpty &&
        rawExtra != 'NA') {
      try {
        final decoded = jsonDecode(rawExtra);
        if (decoded is Map) extra = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    for (final key in keys) {
      _collectStrings(values, json[key]);
      if (extra != null) _collectStrings(values, extra[key]);
    }
    return values;
  }

  static void _collectStrings(List<String> out, dynamic raw) {
    if (raw == null) return;
    if (raw is List) {
      for (final item in raw) {
        if (item is Map) {
          final name = item['name'] ?? item['title'] ?? item['label'];
          _collectStrings(out, name);
        } else {
          _collectStrings(out, item);
        }
      }
      return;
    }
    final text = raw.toString().trim();
    if (text.isEmpty || text == 'NA' || text == 'null') return;
    if (text.startsWith('[')) {
      try {
        _collectStrings(out, jsonDecode(text));
        return;
      } catch (_) {}
    }
    for (final part in text.split(',')) {
      final name = part.trim();
      if (name.isNotEmpty && !out.contains(name)) out.add(name);
    }
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
