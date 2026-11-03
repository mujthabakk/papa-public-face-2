class ProductsModel {
  int? id;
  String? name;
  String? cover;
  String? extraField;
  int? status;
  List<SubCates>? subCates;

  ProductsModel(
      {this.id,
      this.name,
      this.cover,
      this.extraField,
      this.status,
      this.subCates});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'];
    cover = json['cover'];
    extraField = json['extra_field'];
    status = int.parse(json['status'].toString());
    final rawSubs = json['subCates'] ?? json['sub_cates'];
    if (rawSubs is List) {
      subCates = <SubCates>[];
      for (final v in rawSubs) {
        if (v is Map) {
          try {
            subCates?.add(SubCates.fromJson(Map<String, dynamic>.from(v)));
          } catch (_) {}
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['extra_field'] = extraField;
    data['status'] = status;
    if (subCates != null) {
      data['subCates'] = subCates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCates {
  int? id;
  String? name;
  String? cover;
  int? cateId;
  String? extraField;
  int? status;

  SubCates(
      {this.id,
      this.name,
      this.cover,
      this.cateId,
      this.extraField,
      this.status});

  SubCates.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    name = json['name']?.toString();
    cover = json['cover']?.toString();
    cateId = int.tryParse(json['cate_id']?.toString() ?? '');
    extraField = json['extra_field']?.toString();
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['cate_id'] = cateId;
    data['extra_field'] = extraField;
    data['status'] = status;
    return data;
  }
}
