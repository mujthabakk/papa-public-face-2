/*Papabear*/
class TopSalonModel {
  int? id;
  int? uid;
  String? name;
  double? rating;
  int? totalRating;
  String? address;
  String? cover;
  List<Categories>? categories;
  double? distance;

  TopSalonModel(
      {this.id,
      this.uid,
      this.name,
      this.rating,
      this.totalRating,
      this.address,
      this.cover,
      this.categories,
      this.distance});

  TopSalonModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    name = json['name']?.toString();
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    address = json['address']?.toString();
    cover = json['cover']?.toString();
    if (json['categories'] is List) {
      categories = <Categories>[];
      for (final v in json['categories']) {
        if (v is Map) {
          categories!.add(Categories.fromJson(Map<String, dynamic>.from(v)));
        }
      }
    }
    distance = double.tryParse(json['distance']?.toString() ?? '') ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['name'] = name;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['address'] = address;
    data['cover'] = cover;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['distance'] = distance;
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
