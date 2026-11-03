/*Papabear*/
import 'dart:convert';

import 'package:salon_user/app/backend/models/address_model.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';

int? _toInt(dynamic v) {
  if (v == null || v == '' || v == 'NA') return null;
  return int.tryParse(v.toString());
}

double? _toDouble(dynamic v) {
  if (v == null || v == '' || v == 'NA') return null;
  return double.tryParse(v.toString());
}

dynamic _maybeDecode(dynamic value) {
  if (value == null || value == '' || value == 'NA') return null;
  if (value is Map || value is List) return value;
  if (value is String) {
    try {
      return jsonDecode(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

class ProductSalonModel {
  int? id;
  int? uid;
  int? freelancerId;
  int? salonId;
  String? dateTime;
  String? paidMethod;
  String? orderTo;
  List<ProductsListModel>? orders;
  String? notes;
  AddressModel? address;
  double? total;
  double? tax;
  double? grandTotal;
  double? discount;
  String? driverId;
  double? deliveryCharge;
  int? walletUsed;
  double? walletPrice;
  String? couponCode;
  String? extra;
  String? payKey;
  int? status;
  int? payStatus;
  String? extraField;
  String? createdAt;
  String? type;
  SalonInfo? salonInfo;
  FreelancerInfo? freelancerInfo;
  OwnerInfoModel? ownerInfo;
  ProductSalonModel(
      {this.id,
      this.uid,
      this.freelancerId,
      this.salonId,
      this.dateTime,
      this.paidMethod,
      this.orderTo,
      this.orders,
      this.notes,
      this.address,
      this.total,
      this.tax,
      this.grandTotal,
      this.discount,
      this.driverId,
      this.deliveryCharge,
      this.walletUsed,
      this.walletPrice,
      this.couponCode,
      this.extra,
      this.payKey,
      this.status,
      this.payStatus,
      this.extraField,
      this.createdAt,
      this.type,
      this.salonInfo,
      this.freelancerInfo,
      this.ownerInfo});

  ProductSalonModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    uid = _toInt(json['uid']);
    freelancerId = _toInt(json['freelancer_id']);
    salonId = _toInt(json['salon_id']);
    dateTime = json['date_time']?.toString();
    paidMethod = json['paid_method']?.toString();
    orderTo = json['order_to']?.toString();
    final decodedOrders = _maybeDecode(json['orders']);
    if (decodedOrders is List) {
      orders = <ProductsListModel>[];
      for (final element in decodedOrders) {
        if (element is Map) {
          try {
            orders!.add(
                ProductsListModel.fromJson(Map<String, dynamic>.from(element)));
          } catch (_) {}
        }
      }
    }
    notes = json['notes']?.toString();
    final decodedAddress = _maybeDecode(json['address']);
    if (decodedAddress is Map) {
      try {
        address =
            AddressModel.fromJson(Map<String, dynamic>.from(decodedAddress));
      } catch (_) {
        address = null;
      }
    }
    total = _toDouble(json['total']);
    tax = _toDouble(json['tax']);
    grandTotal = _toDouble(json['grand_total']);
    discount = _toDouble(json['discount']);
    driverId = json['driver_id']?.toString();
    deliveryCharge = _toDouble(json['delivery_charge']);
    walletUsed = _toInt(json['wallet_used']);
    walletPrice = _toDouble(json['wallet_price']);
    couponCode = json['coupon_code']?.toString();
    extra = json['extra']?.toString();
    payKey = json['pay_key']?.toString();
    status = _toInt(json['status']);
    payStatus = _toInt(json['payStatus'] ?? json['pay_status']);
    extraField = json['extra_field']?.toString();
    createdAt = json['created_at']?.toString();
    type = json['type']?.toString();
    if (json['salonInfo'] is Map) {
      salonInfo =
          SalonInfo.fromJson(Map<String, dynamic>.from(json['salonInfo']));
    }
    if (json['freelancerInfo'] is Map) {
      freelancerInfo = FreelancerInfo.fromJson(
          Map<String, dynamic>.from(json['freelancerInfo']));
    }
    if (json['ownerInfo'] is Map) {
      ownerInfo = OwnerInfoModel.fromJson(
          Map<String, dynamic>.from(json['ownerInfo']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uid'] = uid;
    data['freelancer_id'] = freelancerId;
    data['salon_id'] = salonId;
    data['date_time'] = dateTime;
    data['paid_method'] = paidMethod;
    data['order_to'] = orderTo;
    data['orders'] = orders;
    data['notes'] = notes;
    data['address'] = address;
    data['total'] = total;
    data['tax'] = tax;
    data['grand_total'] = grandTotal;
    data['discount'] = discount;
    data['driver_id'] = driverId;
    data['delivery_charge'] = deliveryCharge;
    data['wallet_used'] = walletUsed;
    data['wallet_price'] = walletPrice;
    data['coupon_code'] = couponCode;
    data['extra'] = extra;
    data['pay_key'] = payKey;
    data['status'] = status;
    data['payStatus'] = payStatus;
    data['extra_field'] = extraField;
    data['created_at'] = createdAt;
    data['type'] = type;
    if (salonInfo != null) {
      data['salonInfo'] = salonInfo!.toJson();
    }
    return data;
  }
}

class SalonInfo {
  String? name;
  String? cover;
  String? address;

  SalonInfo({this.name, this.cover, this.address});

  SalonInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cover = json['cover'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['cover'] = cover;
    data['address'] = address;
    return data;
  }
}

class FreelancerInfo {
  int? id;
  String? firstName;
  String? lastName;
  String? cover;
  String? type;

  FreelancerInfo(
      {this.id, this.firstName, this.lastName, this.cover, this.type});

  FreelancerInfo.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    firstName = json['first_name']?.toString();
    lastName = json['last_name']?.toString();
    cover = json['cover']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['cover'] = cover;
    data['type'] = type;
    return data;
  }
}

class OwnerInfoModel {
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? countryCode;
  String? fcmToken;
  String? cover;

  OwnerInfoModel(
      {this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.countryCode,
      this.fcmToken,
      this.cover});

  OwnerInfoModel.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    countryCode = json['country_code'];
    fcmToken = json['fcm_token'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['country_code'] = countryCode;
    data['fcm_token'] = fcmToken;
    data['cover'] = cover;
    return data;
  }
}
