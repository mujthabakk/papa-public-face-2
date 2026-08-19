import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';
import 'package:salon_user/app/backend/parse/top_products_parse.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/toast.dart';

class TopProductsControllrer extends GetxController implements GetxService {
  final TopProductsParser parser;

  List<ProductsListModel> _productsList = <ProductsListModel>[];
  List<ProductsListModel> get productsList => _productsList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  bool apiCalled = false;
  TopProductsControllrer({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getTopProducts();
  }

  Future<void> getTopProducts() async {
    Response response = await parser.getTopProducts();
    apiCalled = true;

    if (ApiBody.isSuccess(response) ||
        ApiBody.asList(response.body, keys: const ['products', 'data', 'items'])
            .isNotEmpty) {
      _productsList = [];
      for (final data in ApiBody.asList(response.body,
          keys: const ['products', 'data', 'items'])) {
        try {
          if (data is! Map) continue;
          _productsList
              .add(ProductsListModel.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          debugPrint('Skip product: $e');
        }
      }
      _productsList.removeWhere((product) => product.status == 0);
      checkCartData();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void checkCartData() {
    for (var element in _productsList) {
      if (Get.find<ProductCartController>()
              .checkProductInCart(element.id as int) ==
          true) {
        element.quantity =
            Get.find<ProductCartController>().getQuantity(element.id as int);
      } else {
        element.quantity = 0;
      }
    }
    Get.find<HomeController>().checkCartData();
    Get.find<TabsController>().updateCartValue();
    update();
  }

  void onProduct(int id) {
    Get.delete<ProductsDetailsController>(force: true);
    Get.toNamed(AppRouter.getProductsDetailsRoutes(), arguments: [id]);
  }

  void addToCart(int index) {
    if (Get.find<ProductCartController>().savedInCart.isEmpty) {
      _productsList[index].quantity = 1;
      Get.find<ProductCartController>().addItem(_productsList[index]);
      checkCartData();
      update();
    } else {
      int freelancerId = Get.find<ProductCartController>()
          .getFreelancerId(_productsList[index]);

      if (freelancerId == _productsList[index].freelacerId) {
        _productsList[index].quantity = 1;
        Get.find<ProductCartController>().addItem(_productsList[index]);
        checkCartData();
        update();
      } else {
        showToast('We already have product with other freelancer'.tr);
        update();
      }
    }
  }

  void updateProductQuantity(int index) {
    _productsList[index].quantity = _productsList[index].quantity + 1;
    Get.find<ProductCartController>().addQuantity(_productsList[index]);
    checkCartData();
    update();
  }

  void updateProductQuantityRemove(int index) {
    if (_productsList[index].quantity == 1) {
      _productsList[index].quantity = 0;
      Get.find<ProductCartController>().removeItem(_productsList[index]);
    } else {
      _productsList[index].quantity = _productsList[index].quantity - 1;
      Get.find<ProductCartController>().addQuantity(_productsList[index]);
    }
    checkCartData();
    update();
  }

  void onCart() {
    Get.delete<CartController>(force: true);
    Get.toNamed(AppRouter.getCartRoutes());
  }
}
