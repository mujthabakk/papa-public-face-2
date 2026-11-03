import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/products_model.dart';
import 'package:salon_user/app/backend/parse/categories_parse.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/product_seller_controller.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class CategoriesController extends GetxController
    with CountryScopedRefresh
    implements GetxService {
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
    markCountryFresh();
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
        ApiBody.asList(response.body,
                keys: const ['categories', 'data', 'items', 'result', 'list'])
            .isNotEmpty) {
      _productsList = [];
      // getPublicHome nests under categories; getHome/getActive under data.
      final rows = ApiBody.asList(
        response.body,
        keys: const ['categories', 'data', 'items', 'result', 'list'],
      );
      for (final data in rows) {
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

  Future<void> ensureSubCategories(int cateId) async {
    ProductsModel? category;
    for (final c in _productsList) {
      if ((c.id ?? 0) == cateId) {
        category = c;
        break;
      }
    }
    if (category == null) return;
    if ((category.subCates ?? []).isNotEmpty) return;

    try {
      final response = await parser.getSubCategoriesFromCateId(cateId);
      final rows = ApiBody.asList(response.body);
      if (rows.isEmpty) return;
      final subs = <SubCates>[];
      for (final raw in rows) {
        if (raw is! Map) continue;
        try {
          subs.add(SubCates.fromJson(Map<String, dynamic>.from(raw)));
        } catch (e) {
          debugPrint('skip subcate: $e');
        }
      }
      category.subCates = subs;
      update();
    } catch (e) {
      debugPrint('ensureSubCategories: $e');
    }
  }

  void onSubcategories(int cateId) {
    ensureSubCategories(cateId);
    Get.toNamed(AppRouter.getProductsSubcategoriesRoutes(),
        arguments: [cateId]);
  }

  void onCart() {
    Get.delete<CartController>(force: true);
    Get.toNamed(AppRouter.getCartRoutes());
  }

  void onStores() {
    Get.delete<ProductSellerController>(force: true);
    Get.toNamed(AppRouter.getProductSellerRoutes());
  }

  void updateScreen() {
    update();
  }
}
