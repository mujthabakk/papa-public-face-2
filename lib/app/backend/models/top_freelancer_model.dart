/*Papabear*/
class TopFreelancerModel {
  int? id;
  int? uid;
  List<Categories>? categories;
  double? feeStart;
  double? rating;
  int? totalRating;
  double? distance;
  UserInfo? userInfo;

  TopFreelancerModel(
      {this.id,
      this.uid,
      this.categories,
      this.feeStart,
      this.rating,
      this.totalRating,
      this.distance,
      this.userInfo});

  TopFreelancerModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    if (json['categories'] is List) {
      categories = <Categories>[];
      for (final v in json['categories']) {
        if (v is Map) {
          categories!.add(Categories.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
    feeStart = double.tryParse(json['fee_start']?.toString() ?? '') ?? 0;
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    distance = double.tryParse(json['distance']?.toString() ?? '') ?? 0;
    if (json['userInfo'] is Map) {
      userInfo = UserInfo.fromJson(Map<String, dynamic>.from(json['userInfo']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['fee_start'] = feeStart;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['distance'] = distance;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? cover;

  Categories({this.id, this.name, this.cover});

  Categories.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    cover = json['cover']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    return data;
  }
}

class UserInfo {
  String? firstName;
  String? lastName;
  String? cover;

  UserInfo({this.firstName, this.lastName, this.cover});

  UserInfo.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    return data;
  }
}
