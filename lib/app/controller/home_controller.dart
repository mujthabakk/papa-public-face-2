import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/banner_model.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/individual_model.dart';
import 'package:salon_user/app/backend/models/products_list_model.dart';
import 'package:salon_user/app/backend/models/salon_model.dart';
import 'package:salon_user/app/backend/models/timed_offer_model.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/backend/parse/home_parse.dart';
import 'package:salon_user/app/controller/all_categories_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/categories_list_controller.dart';
import 'package:salon_user/app/controller/category_search_controller.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/controller/search_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/controller/timed_offer_controller.dart';
import 'package:salon_user/app/controller/top_offers_controller.dart';
import 'package:salon_user/app/controller/top_packages_controller.dart';
import 'package:salon_user/app/controller/top_products_controller.dart';
import 'package:salon_user/app/controller/top_specialist_controller.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController implements GetxService {
  final HomeParser parser;

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  List<IndividualModel> _individualList = <IndividualModel>[];
  List<IndividualModel> get individualList => _individualList;

  List<BannerModel> _bannerList = <BannerModel>[];
  List<BannerModel> get bannerList => _bannerList;

  List<ProductsListModel> _productsList = <ProductsListModel>[];
  List<ProductsListModel> get productsList => _productsList;

  List<CouponsModel> _offersList = <CouponsModel>[];
  List<CouponsModel> get offersList => _offersList;

  List<TimedOfferIcon> _timedOffers = <TimedOfferIcon>[];
  List<TimedOfferIcon> get timedOffers => _timedOffers;

  bool apiCalled = false;

  bool haveData = false;

  String title = '';
  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  HomeController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    title = parser.getAddressName();
    getHomeData();
  }

  Future<void> getHomeData() async {
    var param = {
      "lat": parser.getLat(),
      "lng": parser.getLng(),
    };

    _salonList = [];
    _categoriesList = [];
    _individualList = [];
    _bannerList = [];
    _productsList = [];
    _offersList = [];
    _timedOffers = [];

    final timedFuture = parser.getTimedOffersHome();
    Response response = await parser.getHomeData(param);
    final map = ApiBody.asMap(response.body);
    if (map != null) {
      final nested = map['data'];
      if (nested is Map) {
        _applyHomeMap(Map<String, dynamic>.from(nested));
      }
      if (_salonList.isEmpty &&
          _categoriesList.isEmpty &&
          _individualList.isEmpty) {
        _applyHomeMap(map);
      }
    } else if (!ApiBody.isSuccess(response)) {
      debugPrint('getHomeData status ${response.statusCode}');
    }

    await _loadTimedOffersFrom(await timedFuture);
    await _fillMissingHomeSections();
    checkCartData();
    haveData = _salonList.isNotEmpty || _individualList.isNotEmpty;
    apiCalled = true;
    update();
  }

  void _applyHomeMap(Map<String, dynamic> myMap) {
    _parseSalons(myMap['salon'] ?? myMap['salons']);
    _parseCategories(myMap['categories']);
    _parseIndividuals(myMap['individual'] ?? myMap['individuals']);
    _parseBanners(myMap['banners']);
    _parseProducts(myMap['products']);
    _setOffers(myMap['offers'] ?? myMap['data']);
    _parseTimedOffers(myMap['timed_offers'] ?? myMap['timedOffers']);
  }

  void _parseSalons(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _salonList.add(SalonModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip salon: $e');
      }
    }
  }

  void _parseCategories(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _categoriesList
            .add(CategoriesModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip category: $e');
      }
    }
  }

  void _parseIndividuals(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _individualList
            .add(IndividualModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip freelancer: $e');
      }
    }
  }

  void _parseBanners(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _bannerList.add(BannerModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip banner: $e');
      }
    }
  }

  void _parseProducts(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _productsList
            .add(ProductsListModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip product: $e');
      }
    }
    _productsList.removeWhere((product) => product.status == 0);
  }

  Future<void> _fillMissingHomeSections() async {
    final latLng = {"lat": parser.getLat(), "lng": parser.getLng()};
    final jobs = <Future<void>>[];
    if (_categoriesList.isEmpty) jobs.add(_loadCategories());
    if (_offersList.isEmpty) jobs.add(loadPublicOffers());
    if (_salonList.isEmpty) jobs.add(_loadTopSalons(latLng));
    if (_individualList.isEmpty) jobs.add(_loadTopFreelancers(latLng));
    if (_productsList.isEmpty) jobs.add(_loadTopProducts(latLng));
    if (jobs.isNotEmpty) await Future.wait(jobs);
  }

  Future<void> _loadCategories() async {
    try {
      final response = await parser.getAllCategories();
      _parseCategories(ApiBody.asList(response.body));
    } catch (e) {
      debugPrint('loadCategories: $e');
    }
  }

  Future<void> _loadTopSalons(Map<String, dynamic> param) async {
    try {
      final response = await parser.getTopSalon(param);
      _parseSalons(ApiBody.asList(response.body));
    } catch (e) {
      debugPrint('loadTopSalons: $e');
    }
  }

  Future<void> _loadTopFreelancers(Map<String, dynamic> param) async {
    try {
      final response = await parser.getTopFreelancer(param);
      _parseIndividuals(ApiBody.asList(response.body));
    } catch (e) {
      debugPrint('loadTopFreelancers: $e');
    }
  }

  Future<void> _loadTopProducts(Map<String, dynamic> param) async {
    try {
      final response = await parser.getTopProducts(param);
      _parseProducts(ApiBody.asList(response.body, keys: const [
        'products',
        'data',
        'items',
      ]));
    } catch (e) {
      debugPrint('loadTopProducts: $e');
    }
  }

  void _parseTimedOffers(dynamic raw) {
    if (raw is! List) return;
    final seen = <int>{};
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        final icon = TimedOfferIcon.fromJson(Map<String, dynamic>.from(data));
        final id = icon.id ?? 0;
        if (id > 0 && seen.contains(id)) continue;
        if (id > 0) seen.add(id);
        _timedOffers.add(icon);
      } catch (e) {
        debugPrint('Skip timed offer: $e');
      }
    }
  }

  Future<void> _loadTimedOffers() async {
    try {
      final response = await parser.getTimedOffersHome();
      await _loadTimedOffersFrom(response);
    } catch (e) {
      debugPrint('loadTimedOffers: $e');
    }
  }

  Future<void> _loadTimedOffersFrom(Response response) async {
    debugPrint(
        'timedOffers status=${response.statusCode} type=${response.body.runtimeType}');
    final source = response.body is String &&
            (response.body as String).trim().startsWith('<')
        ? null
        : (response.body ?? response.bodyString);
    final list = ApiBody.asList(
      source,
      keys: const [
        'data',
        'timed_offers',
        'campaigns',
        'offers',
        'items',
        'result',
      ],
    );
    debugPrint('timedOffers count=${list.length}');
    if (list.isEmpty) return;
    _timedOffers = [];
    _parseTimedOffers(list);
  }

  void onTimedOffer(TimedOfferIcon offer) {
    Get.delete<TimedOfferController>(force: true);
    Get.toNamed(
      AppRouter.getTimedOfferRoutes(),
      arguments: [offer.id, offer.code, offer.name, offer.image],
    );
  }

  void onServices(int uid) {
    print('$uid  uid');
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }

  void onAllCategories() {
    Get.delete<AllCategoriesController>(force: true);
    Get.toNamed(AppRouter.getAllCategoriesRoutes());
  }

  // void onCategoriesList(int id, String name) {
  //   Get.delete<CategoriesListController>(force: true);
  //   Get.toNamed(AppRouter.getCategoriesListRoutes(), arguments: [id, name]);
  // }

  // void onCategoriesList(int id, String name) {
  //   Get.delete<CategorySearchController>(force: true);
  //   Get.toNamed(AppRouter.getCategoriesListRoutes(), arguments: [id, name]);
  // }

  void onCategoriesList(int id, String name) {
    Get.delete<UnifiedSearchController>(force: true);
    Get.toNamed(AppRouter.getCategoriesListRoutes(), arguments: [id, name]);
  }

  void onAllSpecialist() {
    Get.delete<TopSpecialistController>(force: true);
    Get.toNamed(AppRouter.getTopSpecialistRoutes());
  }

  void onAllOffers() {
    Get.delete<TopOffersController>(force: true);
    Get.toNamed(AppRouter.getTopOffersRoutes());
  }

  void onAllPackages() {
    Get.delete<TopPackagesController>(force: true);
    Get.toNamed(AppRouter.getTopPackagesRoutes());
  }

  void onTopProducts() {
    Get.delete<TopProductsControllrer>(force: true);
    Get.toNamed(AppRouter.getTopProductsRoutes());
  }

  void onAllOffersList() {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes());
  }

  void claimOffer(CouponsModel offer) {
    if (offer.canBook) {
      bookExclusiveOffer(offer);
      return;
    }
    final code = offer.code ?? '';
    if (code.isEmpty) {
      showToast('API is not available'.tr);
      return;
    }
    Clipboard.setData(ClipboardData(text: code));
    successToast('Code copied');
  }

  void bookExclusiveOffer(CouponsModel offer) {
    final partners = <OfferPartnerModel>[];
    if (offer.partners.isNotEmpty) {
      partners.addAll(offer.partners);
    } else if ((offer.partner?.id ?? 0) > 0) {
      partners.add(offer.partner!);
    }
    if (partners.isEmpty) return;
    final ids = offer.bookableServiceIds;
    void open(OfferPartnerModel partner) {
      final id = partner.id ?? 0;
      if (id <= 0) return;
      if ((partner.type ?? '').toLowerCase() == 'individual') {
        Get.delete<SpecialistController>(force: true);
        Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [id, 0, ids]);
        return;
      }
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(), arguments: [id, 0, ids]);
    }

    if (partners.length == 1) {
      open(partners.first);
      return;
    }
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFF2D338),
                ),
              ),
              const SizedBox(height: 12),
              ...partners.map(
                (partner) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    partner.displayName.isEmpty
                        ? 'Partner'
                        : partner.displayName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Color(0xFFF2D338)),
                  onTap: () {
                    Get.back();
                    open(partner);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setOffers(dynamic raw) {
    _offersList = [];
    if (raw is! List) return;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final data in raw) {
      try {
        final offer = CouponsModel.tryParse(data);
        if (offer == null) continue;
        if (offer.status != 1) continue;
        if (offer.expire != null && offer.expire!.isNotEmpty) {
          final expire = DateTime.tryParse(offer.expire!);
          if (expire != null) {
            final end = DateTime(expire.year, expire.month, expire.day);
            if (end.isBefore(today)) continue;
          }
        }
        _offersList.add(offer);
      } catch (e) {
        debugPrint('Skip offer parse: $e');
      }
    }
  }

  Future<void> loadPublicOffers() async {
    try {
      var response = await parser.getAllOffers();
      _setOffers(ApiBody.asList(response.body));
      if (_offersList.isEmpty) {
        response = await parser.getPublicHomeOffers();
        _setOffers(ApiBody.asList(response.body));
      }
    } catch (e) {
      debugPrint('loadPublicOffers: $e');
    }
  }

  // void onSearch() {
  //   Get.delete<AppSearchController>(force: true);
  //   Get.toNamed(AppRouter.getSearchRoutes());
  // }
  void onSearch() {
    Get.delete<UnifiedSearchController>(force: true);
    Get.toNamed(AppRouter.getSearchRoutes());
  }

  void onFilter() {
    if (!Get.isRegistered<UnifiedSearchController>()) {
      Get.put(UnifiedSearchController(parser: Get.find()));
    }
    Get.toNamed(AppRouter.getFilterRoutes());
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
    Get.find<TabsController>().updateCartValue();
    update();
  }

  void onCheckout() {
    debugPrint('On Checkout');
    debugPrint(Get.find<ServiceCartController>().servicesFrom.toString());
    if (Get.find<ServiceCartController>().servicesFrom == 'individual') {
      Get.delete<IndividualCheckoutController>(force: true);
      Get.toNamed(AppRouter.getIndividualCheckout());
    } else {
      Get.delete<CheckoutController>(force: true);
      Get.toNamed(AppRouter.getCheckoutRoutes());
    }
  }

  void updateScreen() {
    update();
  }

  void onBanner(String value, String type) {
    debugPrint(value);
    debugPrint(type);
    if (type == '0') {
      debugPrint('category');
      Get.delete<UnifiedSearchController>(force: true);
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
}
