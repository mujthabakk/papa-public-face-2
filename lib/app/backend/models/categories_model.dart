/*Papabear*/
class CategoriesModel {
  int? id;
  String? name;
  String? cover;
  String? extraField;
  int? services;
  int? status;

  CategoriesModel(
      {this.id,
      this.name,
      this.cover,
      this.extraField,
      this.services,
      this.status});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    cover = json['cover']?.toString();
    extraField = json['extra_field']?.toString();
    services = int.tryParse(json['services']?.toString() ?? '') ?? 0;
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['services'] = services;
    data['status'] = status;
    return data;
  }
}
