import 'dart:convert';

List<String> _parseMediaList(dynamic raw) {
  if (raw == null || raw == '' || raw == 'NA') return [];
  try {
    dynamic decoded = raw;
    if (raw is String) {
      decoded = jsonDecode(raw);
    }
    if (decoded is List) {
      return decoded
          .map((e) {
            if (e is Map) {
              return (e['url'] ?? e['image'] ?? e['cover'] ?? e['path'] ?? '')
                  .toString();
            }
            return e?.toString() ?? '';
          })
          .where((e) => e.trim().isNotEmpty)
          .toList();
    }
  } catch (_) {}
  return [];
}

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
  double? shopPrice;
  double? taxableValue;
  double? taxableAmount;
  double? customerPays;
  double? taxRate;
  String taxType = '';
  bool taxInclusive = false;
  bool hasVariants = false;
  List<Map<String, dynamic>> variants = [];
  int? variantId;
  String? color;
  String? measurement;
  String? measurementType;
  String? measurementValue;
  /// PDF shared product object extras.
  List<Map<String, dynamic>> paymentMethods = [];
  int? returnable;
  int? returnDays;
  List<String> paymentMethodCodes = [];

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
    this.shopPrice,
    this.taxableValue,
    this.taxableAmount,
    this.customerPays,
    this.taxRate,
    this.taxType = '',
    this.taxInclusive = false,
    this.variantId,
    this.color,
    this.measurement,
    this.measurementType,
    this.measurementValue,
  });

  ProductsListModel.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    freelacerId = int.tryParse(json['freelacer_id'].toString());
    cover = json['cover'];
    name = json['name'];

    images = _parseMediaList(json['images']);
    final imagesList = _parseMediaList(json['images_list']);
    final gallery = _parseMediaList(json['gallery']);
    images = <String>{
      ...?images,
      ...imagesList,
      ...gallery,
    }.where((e) => e.trim().isNotEmpty).toList();
    hasVariants = json['has_variants'] == true ||
        json['has_variants']?.toString() == '1';
    variants = [];
    final rawVariants = json['variants'];
    if (rawVariants is List) {
      for (final v in rawVariants) {
        if (v is Map) {
          variants.add(Map<String, dynamic>.from(v));
        }
      }
      if (variants.isNotEmpty) hasVariants = true;
    }
    variantId = int.tryParse(json['variant_id']?.toString() ?? '');
    color = json['color']?.toString();
    measurement = json['measurement']?.toString();
    measurementType = json['measurement_type']?.toString();
    measurementValue = json['measurement_value']?.toString();

    originalPrice = double.tryParse(json['original_price'].toString());
    sellPrice = double.tryParse(json['sell_price']?.toString() ?? '') ??
        double.tryParse(json['amount']?.toString() ?? '') ??
        double.tryParse(json['shop_price']?.toString() ?? '');
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
    // PDF: stock / stock_qty / in_stock / stock_available
    inStock = int.tryParse(json['in_stock']?.toString() ?? '') ??
        int.tryParse(json['stock']?.toString() ?? '') ??
        int.tryParse(json['stock_qty']?.toString() ?? '') ??
        int.tryParse(json['stock_available']?.toString() ?? '');
    rating = double.tryParse(json['rating'].toString());
    totalRating = int.tryParse(json['total_rating'].toString());
    status = int.tryParse(json['status'].toString());
    extraField = json['extra_field'];
    shopPrice = double.tryParse(json['shop_price']?.toString() ?? '') ?? 0;
    returnable = int.tryParse(json['returnable']?.toString() ?? '') ??
        int.tryParse(json['return_option']?.toString() ?? '');
    returnDays = int.tryParse(json['return_days']?.toString() ?? '');
    paymentMethods = [];
    paymentMethodCodes = [];
    final rawPay = json['payment_methods'];
    if (rawPay is List) {
      for (final item in rawPay) {
        if (item is Map) {
          paymentMethods.add(Map<String, dynamic>.from(item));
          final code = (item['code'] ?? item['type'] ?? item['label'] ?? '')
              .toString()
              .trim();
          if (code.isNotEmpty) paymentMethodCodes.add(code);
        } else if (item != null) {
          paymentMethodCodes.add(item.toString());
        }
      }
    }
    final rawCodes = json['payment_method_codes'];
    if (rawCodes is List) {
      for (final c in rawCodes) {
        final s = c?.toString().trim() ?? '';
        if (s.isNotEmpty && !paymentMethodCodes.contains(s)) {
          paymentMethodCodes.add(s);
        }
      }
    }
    taxableValue =
        double.tryParse(json['taxable_value']?.toString() ?? '') ?? 0;
    taxableAmount = double.tryParse(
          json['taxable_amount']?.toString() ??
              json['tax_amount']?.toString() ??
              json['vat_amount']?.toString() ??
              json['gst_amount']?.toString() ??
              '',
        ) ??
        0;
    customerPays =
        double.tryParse(json['customer_pays']?.toString() ?? '') ?? 0;
    taxRate = double.tryParse(json['tax_rate']?.toString() ?? '') ?? 0;
    taxType = (json['tax_type'] ?? json['taxType'] ?? '').toString().trim();
    taxInclusive = json['tax_inclusive'] == true ||
        json['tax_inclusive']?.toString() == '1' ||
        json['tax_mode']?.toString() == 'inclusive';
    hydrateTax();

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
    data['variant_id'] = variantId;
    data['color'] = color;
    data['measurement'] = measurement;
    data['measurement_type'] = measurementType;
    data['measurement_value'] = measurementValue;
    data['has_variants'] = hasVariants;
    data['variants'] = variants;
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
    data['shop_price'] = shopPrice;
    data['taxable_value'] = taxableValue;
    data['taxable_amount'] = taxableAmount;
    data['customer_pays'] = customerPays;
    data['tax_rate'] = taxRate;
    data['tax_type'] = taxType;
    data['tax_inclusive'] = taxInclusive;
    return data;
  }

  double get unitPayPrice {
    if ((customerPays ?? 0) > 0) return customerPays!;
    if ((shopPrice ?? 0) > 0) return shopPrice!;
    if ((discount ?? 0) > 0) return sellPrice ?? 0;
    return originalPrice ?? 0;
  }

  int get _qty => quantity < 1 ? 1 : quantity;

  double get lineTaxableValue {
    hydrateTax();
    return (taxableValue ?? 0) * _qty;
  }

  double get lineTaxAmount {
    hydrateTax();
    return (taxableAmount ?? 0) * _qty;
  }

  String get resolvedTaxType {
    if (taxType.isNotEmpty) return taxType;
    return 'VAT';
  }

  void hydrateTax({double fallbackRate = 0}) {
    if ((taxableAmount ?? 0) > 0 && (taxableValue ?? 0) > 0) {
      if (taxType.isEmpty) taxType = 'VAT';
      return;
    }
    final rate = (taxRate ?? 0) > 0 ? taxRate! : fallbackRate;
    final pay = unitPayPrice;
    if (rate <= 0 || pay <= 0) return;
    taxRate = rate;
    if (taxType.isEmpty) taxType = 'VAT';
    if (taxInclusive || rate > 0) {
      taxInclusive = true;
      final net = pay / (1 + rate / 100);
      taxableValue = double.parse(net.toStringAsFixed(2));
      taxableAmount = double.parse((pay - net).toStringAsFixed(2));
    }
  }
}
