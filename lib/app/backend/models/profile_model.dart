/*Papabear*/
class ProfileModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? cover;
  int? gender;
  String? type;
  String? fcmToken;
  String? stripeKey;
  String? extraField;
  String? preferredLanguage;
  String? preferredCountry;
  int? status;
  String? createdAt;
  String? updatedAt;

  ProfileModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.countryCode,
      this.mobile,
      this.cover,
      this.gender,
      this.type,
      this.fcmToken,
      this.stripeKey,
      this.extraField,
      this.preferredLanguage,
      this.preferredCountry,
      this.status,
      this.createdAt,
      this.updatedAt});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    email = json['email']?.toString();
    countryCode = json['country_code']?.toString();
    mobile = json['mobile']?.toString();
    cover = json['cover']?.toString();
    gender = int.tryParse(json['gender']?.toString() ?? '') ?? 1;
    type = json['type']?.toString();
    fcmToken = json['fcm_token']?.toString();
    stripeKey = json['stripe_key']?.toString();
    extraField = json['extra_field']?.toString();
    preferredLanguage = json['preferred_language']?.toString();
    preferredCountry = json['preferred_country']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['mobile'] = mobile;
    data['cover'] = cover;
    data['gender'] = gender;
    data['type'] = type;
    data['fcm_token'] = fcmToken;
    data['stripe_key'] = stripeKey;
    data['extra_field'] = extraField;
    data['preferred_language'] = preferredLanguage;
    data['preferred_country'] = preferredCountry;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
