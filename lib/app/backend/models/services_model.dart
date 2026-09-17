// class ServicesModel {
//   int? id;
//   int? uid;
//   int? cateId;
//   String? name;
//   String? cover;
//   double? duration;
//   double? price;
//   double? off;
//   double? discount;
//   String? descriptions;
//   String? images;
//   String? extraField;
//   int? status;
//   late bool? isChecked;

//   ServicesModel(
//       {this.id,
//       this.uid,
//       this.cateId,
//       this.name,
//       this.cover,
//       this.duration,
//       this.price,
//       this.off,
//       this.discount,
//       this.descriptions,
//       this.images,
//       this.extraField,
//       this.isChecked = false,
//       this.status});

//   ServicesModel.fromJson(Map<String, dynamic> json) {
//     id = int.parse(json['id'].toString());
//     uid = int.parse(json['uid'].toString());
//     cateId = int.parse(json['cate_id'].toString());
//     name = json['name'];
//     cover = json['cover'];
//     duration = double.parse(json['duration'].toString());
//     price = double.parse(json['price'].toString());
//     off = double.parse(json['off'].toString());
//     discount = double.parse(json['discount'].toString());
//     descriptions = json['descriptions'];
//     images = json['images'];
//     extraField = json['extra_field'];
//     status = int.parse(json['status'].toString());
//     isChecked = json['isChecked'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['uid'] = uid;
//     data['cate_id'] = cateId;
//     data['name'] = name;
//     data['cover'] = cover;
//     data['duration'] = duration;
//     data['price'] = price;
//     data['off'] = off;
//     data['discount'] = discount;
//     data['descriptions'] = descriptions;
//     data['images'] = images;
//     data['extra_field'] = extraField;
//     data['status'] = status;
//     data['isChecked'] = isChecked;
//     return data;
//   }
// }
class ServicesModel {
  int? id;
  int? uid;
  int? serviceId;
  String? cover;
  double? duration;
  double? price;
  double? off;
  double? discount;
  String? descriptions;
  String? images;
  String? extraField;
  int? gender;
  int? status;
  String? name;
  bool? isChecked;
  double? rating;
  int? totalRating;
  int? reviewCount;
  double? shopPrice;
  double? taxableValue;
  double? gstAmount;
  double? vatAmount;
  double? apiTaxAmount;
  String taxType = '';
  double? customerPays;
  double? taxRate;
  bool taxInclusive = false;

  ServicesModel(
      {this.id,
      this.uid,
      this.serviceId,
      this.cover,
      this.duration,
      this.price,
      this.off,
      this.discount,
      this.descriptions,
      this.images,
      this.extraField,
      this.gender,
      this.status,
      this.name,
      this.isChecked = false,
      this.rating,
      this.totalRating,
      this.reviewCount,
      this.shopPrice,
      this.taxableValue,
      this.gstAmount,
      this.vatAmount,
      this.apiTaxAmount,
      this.taxType = '',
      this.customerPays,
      this.taxRate,
      this.taxInclusive = false});

  ServicesModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
    uid = int.tryParse(json['uid']?.toString() ?? '') ?? 0;
    serviceId = int.tryParse(
          json['service_id']?.toString() ?? json['cate_id']?.toString() ?? '',
        ) ??
        0;
    cover = json['cover']?.toString();
    duration = double.tryParse(json['duration']?.toString() ?? '') ?? 0;
    price = double.tryParse(json['price']?.toString() ?? '') ?? 0;
    off = double.tryParse(json['off']?.toString() ?? '') ?? 0;
    discount = double.tryParse(json['discount']?.toString() ?? '') ?? 0;
    descriptions = json['descriptions']?.toString();
    images = json['images']?.toString();
    extraField = json['extra_field']?.toString();
    gender = int.tryParse(json['gender']?.toString() ?? '') ?? 0;
    status = int.tryParse(json['status']?.toString() ?? '') ?? 1;
    name = json['name']?.toString();
    isChecked = json['isChecked'] == true;
    rating = double.tryParse(json['rating']?.toString() ?? '') ?? 0;
    totalRating = int.tryParse(json['total_rating']?.toString() ?? '') ?? 0;
    reviewCount = int.tryParse(
          json['review_count']?.toString() ??
              json['reviews']?.toString() ??
              json['total_rating']?.toString() ??
              '',
        ) ??
        0;
    shopPrice = double.tryParse(json['shop_price']?.toString() ?? '') ?? 0;
    taxableValue =
        double.tryParse(json['taxable_value']?.toString() ?? '') ?? 0;
    gstAmount = double.tryParse(json['gst_amount']?.toString() ?? '') ?? 0;
    vatAmount = double.tryParse(json['vat_amount']?.toString() ?? '') ?? 0;
    apiTaxAmount = double.tryParse(
          json['taxable_amount']?.toString() ??
              json['tax_amount']?.toString() ??
              '',
        ) ??
        0;
    taxType = (json['tax_type'] ?? json['taxType'] ?? '').toString().trim();
    customerPays =
        double.tryParse(json['customer_pays']?.toString() ?? '') ?? 0;
    taxRate = double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0;
    taxInclusive = json['tax_inclusive'] == true ||
        json['tax_inclusive']?.toString() == '1';
  }

  double get resolvedTaxAmount {
    if ((apiTaxAmount ?? 0) > 0) return apiTaxAmount!;
    if ((vatAmount ?? 0) > 0) return vatAmount!;
    if ((gstAmount ?? 0) > 0) return gstAmount!;
    return 0;
  }

  String get resolvedTaxType {
    if (taxType.isNotEmpty) return taxType;
    if ((vatAmount ?? 0) > 0) return 'VAT';
    if ((gstAmount ?? 0) > 0) return 'GST';
    return 'Tax';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['service_id'] = serviceId;
    data['cover'] = cover;
    data['duration'] = duration;
    data['price'] = price;
    data['off'] = off;
    data['discount'] = discount;
    data['descriptions'] = descriptions;
    data['images'] = images;
    data['extra_field'] = extraField;
    data['gender'] = gender;
    data['status'] = status;
    data['name'] = name;
    data['isChecked'] = isChecked;
    data['rating'] = rating;
    data['total_rating'] = totalRating;
    data['review_count'] = reviewCount;
    data['shop_price'] = shopPrice;
    data['taxable_value'] = taxableValue;
    data['taxable_amount'] = apiTaxAmount;
    data['gst_amount'] = gstAmount;
    data['vat_amount'] = vatAmount;
    data['tax_amount'] = apiTaxAmount;
    data['tax_type'] = taxType;
    data['customer_pays'] = customerPays;
    data['tax_rate'] = taxRate;
    data['tax_inclusive'] = taxInclusive;
    return data;
  }
}
