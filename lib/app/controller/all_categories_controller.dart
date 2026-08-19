import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/parse/all_categories_parse.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';

class AllCategoriesController extends GetxController implements GetxService {
  final AllCategoriesParser parser;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;
  bool apiCalled = false;

  AllCategoriesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    var response = await parser.getAllCategories();
    apiCalled = true;
    _categoriesList = [];
    for (final data in ApiBody.asList(response.body)) {
      try {
        if (data is! Map) continue;
        _categoriesList
            .add(CategoriesModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip category: $e');
      }
    }
    if (_categoriesList.isEmpty && !ApiBody.isSuccess(response)) {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onCategoriesList(int id, String name) {
    Get.delete<UnifiedSearchController>(force: true);
    Get.toNamed(AppRouter.getCategoriesListRoutes(), arguments: [id, name]);
  }
}
