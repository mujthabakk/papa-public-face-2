class IndividualModel {
  int? id;
  int? uid;
  double? lat;
  double? lng;
  double? distance;
  UserInfo? userInfo;

  IndividualModel({this.id, this.uid, this.distance, this.userInfo});

  IndividualModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    distance = double.tryParse(json['distance']?.toString() ?? '') ?? 0;
    lat = double.tryParse(json['lat']?.toString() ?? '') ?? 0;
    lng = double.tryParse(json['lng']?.toString() ?? '') ?? 0;
    if (json['userInfo'] is Map) {
      userInfo = UserInfo.fromJson(Map<String, dynamic>.from(json['userInfo']));
    } else if (json['first_name'] != null || json['cover'] != null) {
      userInfo = UserInfo.fromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['lat'] = lat;
    data['lng'] = lng;
    data['distance'] = distance;
    if (userInfo != null) {
      data['userInfo'] = userInfo!.toJson();
    }
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
