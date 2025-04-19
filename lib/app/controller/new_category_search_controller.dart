/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/banner_model.dart';
import 'package:salon_user/app/backend/models/salon_model.dart';
import 'package:salon_user/app/backend/models/search_individual_model.dart';
import 'package:salon_user/app/backend/parse/search_parse.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/categories_list_controller.dart';
import 'package:salon_user/app/controller/filter_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:url_launcher/url_launcher.dart';

class NewCatSearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController();
  RxBool isEmpty = true.obs;

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<SearchIndividualModel> _individualList = <SearchIndividualModel>[];
  List<SearchIndividualModel> get individualList => _individualList;

  List<BannerModel> _bannerList = <BannerModel>[];
  List<BannerModel> get bannerList => _bannerList;

  String selectedCateId = '';
  String selectedCateName = '';

  String title = '';
  NewCatSearchController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    title = parser.getAddressName();
    selectedCateId = Get.arguments[0].toString();
    selectedCateName = Get.arguments[1].toString();
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onFilter() {
    Get.delete<FilterController>(force: true);
    Get.toNamed(AppRouter.getFilterRoutes());
  }

  searchProducts(String name) {
    if (name.isNotEmpty && name != '') {
      getSearchResult(name);
    } else {
      _salonList = [];
      _individualList = [];
      isEmpty = true.obs;
      update();
    }
  }

  Future<void> getBannerData() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getBannerData(param);
    // apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var bannerData = myMap['banners'];
      _bannerList = [];

      bannerData.forEach((data) {
        BannerModel banner = BannerModel.fromJson(data);
        _bannerList.add(banner);
      });
      debugPrint(bannerList.length.toString());

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onBanner(String value, String type) {
    debugPrint(value);
    debugPrint(type);
    if (type == '0') {
      debugPrint('category');
      Get.delete<CategoriesListController>(force: true);
      Get.toNamed(AppRouter.getCategoriesListRoutes(),
          arguments: [value, 'Offers']);
    } else if (type == '1') {
      debugPrint('individual');
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(),
          arguments: [int.parse(value.toString())]);
    } else if (type == '2') {
      debugPrint('salon');
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(),
          arguments: [int.parse(value.toString())]);
    } else if (type == '3') {
      debugPrint('product category');
      Get.find<CategoriesController>().onCategoryExpand(value);
      Get.find<TabsController>().updateTabId(3);
    } else if (type == '4') {
      debugPrint('products');
      Get.delete<ProductsDetailsController>(force: true);
      Get.toNamed(AppRouter.getProductsDetailsRoutes(), arguments: [value]);
    } else if (type == '5') {
      debugPrint('external links');
      launchInBrowser(value);
    }
  }

  Future<void> launchInBrowser(String link) async {
    var url = Uri.parse(link);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw '${'Could not launch'.tr} $url';
    }
  }

  void getSearchResult(String query) async {
    var param = {
      "param": query,
      "lat": parser.getLat(),
      "lng": parser.getLng()
    };
    Response response = await parser.getSearchResult(param);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['salon'];
      var individualData = myMap['individual'];
      _salonList = [];
      _individualList = [];

      salonData.forEach((data) {
        SalonModel salon = SalonModel.fromJson(data);
        _salonList.add(salon);
      });

      individualData.forEach((data) {
        SearchIndividualModel individual = SearchIndividualModel.fromJson(data);
        _individualList.add(individual);
      });
      isEmpty = false.obs;
      debugPrint(salonList.length.toString());
      debugPrint(individualList.length.toString());
    } else {
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  void clearData() {
    searchController.clear();
    _salonList = [];
    _individualList = [];
    isEmpty = true.obs;
    update();
  }

  void onServices(int uid) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }
}
