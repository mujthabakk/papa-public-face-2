import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/packages_details_model.dart';
import 'package:salon_user/app/backend/models/service_cart_model.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/backend/parse/service_cart_parse.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/facebook_service.dart';

class ServiceCartController extends GetxController implements GetxService {
  final ServiceCartParser parser;
  ServiceCartModel _savedInCart = ServiceCartModel();
  ServiceCartModel get savedInCart => _savedInCart;

  int _totalItemsInCart = 0;
  int get totalItemsInCart => _totalItemsInCart;
  set totalItemsInCartNow(int value) => _totalItemsInCart = value;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  double _walletDiscount = 0.0;
  double get walletDiscount => _walletDiscount;

  double _orderTax = 0.0;
  double get orderTax => _orderTax;

  double _serviceCharge = 0.0;
  double get serviceCharge => _serviceCharge;

  double _serviceChargeAmount = 0.0;
  double get serviceChargeAmount => _serviceChargeAmount;

  double _orderPrice = 0.0;
  double get orderPrice => _orderPrice;

  double _shippingPrice = 0.0;
  double get shippingPrice => _shippingPrice;

  double _minOrderPrice = 0.0;
  double get minOrderPrice => _minOrderPrice;

  double _freeShipping = 0.0;
  double get freeShipping => _freeShipping;

  late CouponsModel _selectedCoupon = CouponsModel();
  CouponsModel get selectedCoupon => _selectedCoupon;

  int _shippingMethod = AppConstants.defaultShippingMethod;
  int get shippingMethod => _shippingMethod;

  bool isWalletChecked = false;
  double taxAmount = 0.0;

  int salonId = 0;
  String servicesFrom = '';
  ServiceCartController({required this.parser});

  //set _totalItemsInCart to 0

  void getCart() {
    _savedInCart = ServiceCartModel();
    _savedInCart.services = [];
    _savedInCart.packages = [];
    _savedInCart.services!.addAll(parser.getServices());
    _savedInCart.packages!.addAll(parser.getPackages());
    servicesFrom = parser.getServicesFrom();
    _serviceCharge = parser.serviceChargePrice();
    _orderTax = parser.taxOrderPrice();
    salonId = parser.getSalonId();
    _shippingPrice = parser.getShippingPrice();
    _shippingMethod = parser.getShippingMethod();
    _minOrderPrice = 0;
    _freeShipping = 0;
    calcuate();
    update();
  }

  void onSaveCoupon(CouponsModel offer) {
    _selectedCoupon = offer;
    update();
    calcuate();
  }

  void clearCart() {
    _savedInCart = ServiceCartModel();
    _totalPrice = 0.0;
    _grandTotal = 0.0;
    salonId = 0;
    servicesFrom = '';
    _walletDiscount = 0.0;
    _orderPrice = 0.0;
    _totalItemsInCart = 0;
    parser.saveService([]);
    parser.savePackages([]);
    getCart();
    update();
  }

  void addServiceToCart(ServicesModel service, String from) {
    servicesFrom = from;
    parser.saveServiceFrom(from);
    _savedInCart.services!.add(service);
    salonId = service.uid!;
    parser.saveSalonId(salonId);
    parser.saveService(_savedInCart.services as List<ServicesModel>);
    FacebookService.logAddToCart(
      id: service.id.toString(),
      type: 'service',
      price: service.discount! > 0 ? service.off!.toDouble() : service.price!.toDouble(),
      currency: AppConstants.defaultCurrencySymbol,
    );
    calcuate();
    update();
  }

  void addPackageToCart(PackagesDetailsModel package, String from) {
    servicesFrom = from;
    parser.saveServiceFrom(from);
    _savedInCart.packages!.add(package);
    salonId = package.uid!;
    parser.saveSalonId(salonId);
    parser.savePackages(_savedInCart.packages as List<PackagesDetailsModel>);
    FacebookService.logAddToCart(
      id: package.id.toString(),
      type: 'package',
      price: package.discount! > 0 ? package.off!.toDouble() : package.price!.toDouble(),
      currency: AppConstants.defaultCurrencySymbol,
    );
    calcuate();
    update();
  }

  bool checkServiceInCart(int id) {
    debugPrint(savedInCart.services!.length.toString());
    return savedInCart.services!
        .where((element) => element.id == id)
        .isNotEmpty;
  }

  bool checkPackageInCart(int id) {
    return savedInCart.packages!
        .where((element) => element.id == id)
        .isNotEmpty;
  }

  int getServiceFreelancerId() {
    return savedInCart.services![0].uid as int;
  }

  int getPackageFreelancerId() {
    return savedInCart.packages![0].uid as int;
  }

  void removeServiceFromCart(int id) {
    _savedInCart.services!.removeWhere((element) => element.id == id);
    parser.saveService(_savedInCart.services as List<ServicesModel>);
    update();
    calcuate();
  }

  void removePackageFromCart(int id) {
    _savedInCart.packages!.removeWhere((element) => element.id == id);
    parser.savePackages(_savedInCart.packages as List<PackagesDetailsModel>);
    update();
    calcuate();
  }

  void calcuate() {
    double total = 0.0;
    for (var element in _savedInCart.services!) {
      if (element.discount! > 0) {
        total = total + element.off!;
      } else {
        total = total + element.price!;
      }
    }
    for (var element in _savedInCart.packages!) {
      if (element.discount! > 0) {
        total = total + element.off!;
      } else {
        total = total + element.price!;
      }
    }
    _totalItemsInCart =
        _savedInCart.services!.length + _savedInCart.packages!.length;
    _totalPrice = total;
    calculateAllCharge();
    update();
  }

  calculateAllCharge() {
    _totalPrice = double.parse((_totalPrice).toStringAsFixed(2));
    double totalPrice = _totalPrice;

    // double totalPrice = _totalPrice + serviceCharge;

    taxAmount = _totalPrice * (orderTax / 100);
    taxAmount = taxAmount.toPrecision(2);

    _serviceChargeAmount = _totalPrice * (_serviceCharge / 100);
    _serviceChargeAmount = _serviceChargeAmount.toPrecision(2);

    // _grandTotal = double.parse((totalPrice).toStringAsFixed(2));

    _grandTotal = double.parse(
        (totalPrice + taxAmount + _serviceChargeAmount).toStringAsFixed(2));
    update();
  }
}
