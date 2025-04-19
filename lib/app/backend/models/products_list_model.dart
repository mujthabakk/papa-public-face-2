import 'dart:convert';

class ProductsListModel {
  int? id;
  int? freelacerId;
  String? cover;
  String? name;
  List<String>? images; // 🔄 Changed from String? to List<String>?
  double? originalPrice;
  double? sellPrice;
  double? discount;
  int? cateId;
  int? subCateId;
  int? inHome;
  int? isSingle;
  int? haveGram;
  String? gram;
  int? haveKg;
  String? kg;
  int? havePcs;
  String? pcs;
  int? haveLiter;
  String? liter;
  int? haveMl;
  String? ml;
  String? descriptions;
  String? keyFeatures;
  String? disclaimer;
  String? expDate;
  int? inOffer;
  int? inStock;
  double? rating;
  int? totalRating;
  int? status;
  String? extraField;
  late int quantity;

  ProductsListModel({
    this.id,
    this.freelacerId,
    this.cover,
    this.name,
    this.images,
    this.originalPrice,
    this.sellPrice,
    this.discount,
    this.cateId,
    this.subCateId,
    this.inHome,
    this.isSingle,
    this.haveGram,
    this.gram,
    this.haveKg,
    this.kg,
    this.havePcs,
    this.pcs,
    this.haveLiter,
    this.liter,
    this.haveMl,
    this.ml,
    this.descriptions,
    this.keyFeatures,
    this.disclaimer,
    this.expDate,
    this.inOffer,
    this.inStock,
    this.rating,
    this.totalRating,
    this.status,
    this.extraField,
    this.quantity = 0,
  });

  ProductsListModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    freelacerId = int.tryParse(json['freelacer_id'].toString());
    cover = json['cover'];
    name = json['name'];

    // 🔄 Convert stringified list to List<String>
    try {
      List<dynamic> decodedImages = jsonDecode(json['images'] ?? '[]');
      images = decodedImages
          .whereType<String>()
          .where((e) => e.trim().isNotEmpty)
          .toList();
    } catch (e) {
      images = [];
    }

    originalPrice = double.tryParse(json['original_price'].toString());
    sellPrice = double.tryParse(json['sell_price'].toString());
    discount = double.tryParse(json['discount'].toString());
    cateId = int.tryParse(json['cate_id'].toString());
    subCateId = int.tryParse(json['sub_cate_id'].toString());
    inHome = int.tryParse(json['in_home'].toString());
    isSingle = int.tryParse(json['is_single'].toString());
    haveGram = int.tryParse(json['have_gram'].toString());
    gram = json['gram'];
    haveKg = int.tryParse(json['have_kg'].toString());
    kg = json['kg'];
    havePcs = int.tryParse(json['have_pcs'].toString());
    pcs = json['pcs'];
    haveLiter = int.tryParse(json['have_liter'].toString());
    liter = json['liter'];
    haveMl = int.tryParse(json['have_ml'].toString());
    ml = json['ml'];
    descriptions = json['descriptions'];
    keyFeatures = json['key_features'];
    disclaimer = json['disclaimer'];
    expDate = json['exp_date'];
    inOffer = int.tryParse(json['in_offer'].toString());
    inStock = int.tryParse(json['in_stock'].toString());
    rating = double.tryParse(json['rating'].toString());
    totalRating = int.tryParse(json['total_rating'].toString());
    status = int.tryParse(json['status'].toString());
    extraField = json['extra_field'];

    if (json['quantity'] != null &&
        json['quantity'] != 0 &&
        json['quantity'] != '') {
      quantity = int.tryParse(json['quantity'].toString()) ?? 0;
    } else {
      quantity = 0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['freelacer_id'] = freelacerId;
    data['cover'] = cover;
    data['name'] = name;
    data['images'] = jsonEncode(images ?? []); // 🔄 Store back as JSON string
    data['original_price'] = originalPrice;
    data['sell_price'] = sellPrice;
    data['discount'] = discount;
    data['cate_id'] = cateId;
    data['sub_cate_id'] = subCateId;
    data['in_home'] = inHome;
    data['is_single'] = isSingle;
    data['have_gram'] = haveGram;
    data['gram'] = gram;
    data['have_kg'] = haveKg;
    data['kg'] = kg;
    data['have_pcs'] = havePcs;
    data['pcs'] = pcs;
    data['have_liter'] = haveLiter;
    data['liter'] = liter;
    data['have_ml'] = haveMl;
    data['ml'] = ml;
    data['descriptions'] = descriptions;
    data['key_features'] = keyFeatures;
    data['disclaimer'] = disclaimer;
    data['exp_date'] = expDate;
    data['in_offer'] = inOffer;
    data['in_stock'] = inStock;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['status'] = status;
    data['extra_field'] = extraField;
    data['quantity'] = quantity;
    return data;
  }
}
