class SpecialistModel {
  int? id;
  int? salonUid;
  String? cateId;
  String? firstName;
  String? lastName;
  String? cover;
  String? extraField;
  int? status;

  SpecialistModel(
      {this.id,
      this.salonUid,
      this.cateId,
      this.firstName,
      this.lastName,
      this.cover,
      this.extraField,
      this.status});

  SpecialistModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    salonUid = int.tryParse(json['salon_uid']?.toString() ?? '') ?? 0;
    cateId = json['cate_id']?.toString();
    firstName = json['first_name'];
    lastName = json['last_name'];
    cover = json['cover'];
    extraField = json['extra_field'];
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon_uid'] = salonUid;
    data['cate_id'] = cateId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
