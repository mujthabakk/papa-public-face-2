import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';
import 'package:salon_user/app/backend/models/sold_by_model.dart';
import 'package:salon_user/app/backend/parse/products_parse.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class ProductSellerController extends GetxController implements GetxService {
  final ProductsParser parser;

  ProductSellerController({required this.parser});

  bool apiCalled = false;
  int sellerUid = 0;
  String sellerName = '';
  String sellerCover = '';
  String sellerAddress = '';

  List<ProductsListModel> _products = [];
  List<ProductsListModel> get products => _products;

  List<SoldByModel> _sellers = [];
  List<SoldByModel> get sellers => _sellers;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      sellerUid = int.tryParse('${args[0]}') ?? 0;
      if (args.length > 1) sellerName = args[1]?.toString() ?? '';
      if (args.length > 2) sellerCover = args[2]?.toString() ?? '';
      if (args.length > 3) sellerAddress = args[3]?.toString() ?? '';
    } else if (args is Map) {
      sellerUid = int.tryParse('${args['id'] ?? args['uid'] ?? 0}') ?? 0;
      sellerName = args['name']?.toString() ?? '';
      sellerCover = args['cover']?.toString() ?? '';
      sellerAddress = args['address']?.toString() ?? '';
    }
    if (sellerUid > 0) {
      loadSellerProducts();
    } else {
      loadSellers();
    }
  }

  Future<void> loadSellers() async {
    apiCalled = false;
    update();
    try {
      final response = await parser.getSellers();
      _sellers = [];
      for (final raw in ApiBody.asList(response.body)) {
        if (raw is! Map) continue;
        try {
          _sellers.add(SoldByModel.fromJson(Map<String, dynamic>.from(raw)));
        } catch (e) {
          debugPrint('skip seller: $e');
        }
      }
    } catch (e) {
      debugPrint('loadSellers: $e');
    }
    apiCalled = true;
    update();
  }

  Future<void> loadSellerProducts() async {
    apiCalled = false;
    update();
    try {
      var response = await parser.getBySeller(sellerUid);
      if (response.statusCode != 200) {
        response = await parser.getAllProducts(sellerUid: sellerUid);
      }
      _products = [];
      for (final raw in ApiBody.asList(response.body,
          keys: const ['data', 'products', 'items', 'result', 'list'])) {
        if (raw is! Map) continue;
        try {
          final p =
              ProductsListModel.fromJson(Map<String, dynamic>.from(raw));
          if ((p.status ?? 1) == 0) continue;
          _products.add(p);
        } catch (e) {
          debugPrint('skip seller product: $e');
        }
      }
      _syncCartQty();
    } catch (e) {
      debugPrint('loadSellerProducts: $e');
      ApiChecker.checkApi(const Response(statusCode: 1));
    }
    apiCalled = true;
    update();
  }

  void _syncCartQty() {
    if (!Get.isRegistered<ProductCartController>()) return;
    final cart = Get.find<ProductCartController>();
    for (final p in _products) {
      final id = p.id ?? 0;
      if (id > 0 && cart.checkProductInCart(id)) {
        p.quantity = cart.getQuantity(id);
      } else {
        p.quantity = 0;
      }
    }
  }

  void openSeller(SoldByModel s) {
    Get.delete<ProductSellerController>(force: true);
    Get.toNamed(AppRouter.getProductSellerRoutes(), arguments: [
      s.sellerUid,
      s.displayName,
      s.cover ?? '',
      s.address ?? '',
    ]);
  }

  void onProduct(int id) {
    Get.delete<ProductsDetailsController>(force: true);
    Get.toNamed(AppRouter.getProductsDetailsRoutes(), arguments: [id]);
  }
}
