import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/products_model.dart';
import 'package:salon_user/app/backend/parse/categories_parse.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class CategoriesController extends GetxController implements GetxService {
  final CategoriesParser parser;

  String selectedCategory = '';

  List<ProductsModel> _productsList = <ProductsModel>[];
  List<ProductsModel> get productsList => _productsList;

  bool apiCalled = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  CategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getAllCategories();
  }

  void onCategoryExpand(String id) {
    selectedCategory = id;
    update();
  }

  Future<void> getAllCategories() async {
    var response = await parser.getAllCategories();
    apiCalled = true;
    if (ApiBody.isSuccess(response) ||
        ApiBody.asList(response.body).isNotEmpty) {
      _productsList = [];
      for (final data in ApiBody.asList(response.body)) {
        try {
          if (data is! Map) continue;
          _productsList
              .add(ProductsModel.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          debugPrint('Skip shop category: $e');
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  List<ProductsModel> getItemsBySubCategory(String subCateId) {
    // Assuming `subCates` contains a list of subcategories for each category
    List<ProductsModel> items = [];
    for (var category in _productsList) {
      for (var subCate in category.subCates ?? []) {
        if (subCate.id.toString() == subCateId) {
          items = subCate.items ?? [];
          break;
        }
      }
    }
    return items;
  }

  void onProducts(int cateId, int subCateId) {
    Get.delete<ProductsController>(force: true);
    Get.toNamed(AppRouter.getProductsRoutes(), arguments: [cateId, subCateId]);
  }

  void onSubcategories(int cateId) {
    Get.delete<CategoriesController>(force: true);
    Get.toNamed(AppRouter.getProductsSubcategoriesRoutes(),
        arguments: [cateId]);
  }

  void onCart() {
    Get.delete<CartController>(force: true);
    Get.toNamed(AppRouter.getCartRoutes());
  }

  void updateScreen() {
    update();
  }
}
