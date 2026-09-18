import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';
import 'package:salon_user/app/backend/parse/product_cart_parse.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/util/constant.dart';

class ProductCartController extends GetxController implements GetxService {
  final ProductCartParser parser;

  List<ProductsListModel> _savedInCart = <ProductsListModel>[];
  List<ProductsListModel> get savedInCart => _savedInCart;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  double _grandTotal = 0.0;
  double get grandTotal => _grandTotal;

  double _walletDiscount = 0.0;
  double get walletDiscount => _walletDiscount;

  double taxAmount = 0.0;
  double taxableValue = 0.0;
  String taxTypeLabel = 'Tax';
  double _orderTax = 0.0;
  double get orderTax => _orderTax;

  double _serviceCharge = 0.0;
  double get serviceCharge => _serviceCharge;

  double _orderPrice = 0.0;
  double get orderPrice => _orderPrice;

  double _shippingPrice = 0.0;
  double get shippingPrice => _shippingPrice;

  double _freeShipping = 0.0;
  double get freeShipping => _freeShipping;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  int _shippingMethod = AppConstants.defaultShippingMethod;
  int get shippingMethod => _shippingMethod;

  bool isWalletChecked = false;

  ProductCartController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    _shippingPrice = parser.shippingPrice();
    _shippingMethod = parser.getShippingMethod();
    _freeShipping = parser.freeOrderPrice();
    _orderTax = parser.taxOrderPrice();
    _serviceCharge = parser.serviceChargePrice();
  }

  void getCart() {
    _savedInCart = [];
    _savedInCart.addAll(parser.getProduct());
    calcuate();
    update();
  }

  void addItem(ProductsListModel product) {
    _savedInCart.add(product);
    parser.saveProduct(_savedInCart);
    calcuate();
    update();
  }

  void removeItem(ProductsListModel product) {
    _savedInCart.removeWhere(
        (element) => element.id == product.id && element.name == product.name);
    parser.saveProduct(_savedInCart);
    calcuate();
    update();
  }

  void deleteFromList(ProductsListModel product) {
    _savedInCart.removeWhere(
        (element) => element.id == product.id && element.name == product.name);
    parser.saveProduct(_savedInCart);
    calcuate();
    update();
  }

  bool checkProductInCart(int id) {
    return savedInCart.where((element) => element.id == id).isNotEmpty;
  }

  void calcuate() {
    debugPrint(jsonEncode(_savedInCart));
    double total = 0;
    for (var element in _savedInCart) {
      total = total + element.unitPayPrice * element.quantity;
    }
    _totalPrice = total;
    debugPrint('total price mali');
    calculateAllCharge();
    update();
  }

  calculateAllCharge() {
    _totalPrice = double.parse((_totalPrice).toStringAsFixed(2));
    double totalPrice = _totalPrice;
    taxAmount = 0;
    taxableValue = 0;
    taxTypeLabel = 'Tax';
    var rate = _orderTax;
    for (final element in _savedInCart) {
      element.hydrateTax(fallbackRate: _orderTax > 0 ? _orderTax : 5);
      taxAmount += element.lineTaxAmount;
      taxableValue += element.lineTaxableValue;
      final itemRate = element.taxRate ?? 0;
      if (itemRate > rate) rate = itemRate;
      if (element.resolvedTaxType.isNotEmpty) {
        taxTypeLabel = element.resolvedTaxType;
      }
    }
    taxAmount = double.parse(taxAmount.toStringAsFixed(2));
    taxableValue = double.parse(taxableValue.toStringAsFixed(2));
    if (rate > 0) {
      _orderTax = rate;
    }

    _grandTotal = double.parse(
        (totalPrice + shippingMethod).toStringAsFixed(2));
    update();
  }

  int getQuantity(int id) {
    final index = savedInCart
        .indexWhere((element) => element.id == id && element.quantity >= 1);
    return index >= 0 ? savedInCart[index].quantity : 0;
  }

  void addQuantity(ProductsListModel product) {
    int index = savedInCart.indexWhere((element) => element.id == product.id);
    if (product.quantity <= 0) {
      removeItem(product);
    }
    _savedInCart[index].quantity = product.quantity;
    parser.saveProduct(_savedInCart);
    calcuate();
    update();
  }

  int getFreelancerId(ProductsListModel product) {
    return savedInCart[0].freelacerId as int;
  }

  void clearCart() {
    _savedInCart = [];
    _totalPrice = 0.0;
    _grandTotal = 0.0;
    _walletDiscount = 0.0;
    _orderPrice = 0.0;
    parser.saveProduct(_savedInCart);
    getCart();
    update();
    
    // Update tabs controller cart badge
    try {
      Get.find<TabsController>().updateCartValue();
    } catch (e) {
      // TabsController might not be available in some contexts
    }
  }
}
