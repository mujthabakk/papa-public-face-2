import 'dart:async';

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
import 'package:salon_user/app/backend/models/sold_by_model.dart';
import 'package:salon_user/app/backend/models/timed_offer_model.dart';
import 'package:salon_user/app/backend/models/top_partner_model.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/backend/parse/coupon_parse.dart';
import 'package:salon_user/app/backend/parse/home_parse.dart';
import 'package:salon_user/app/helper/home_sections.dart';
import 'package:salon_user/app/controller/all_categories_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/categories_list_controller.dart';
import 'package:salon_user/app/controller/category_search_controller.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/product_seller_controller.dart';
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
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController
    with CountryScopedRefresh
    implements GetxService {
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

  /// PDF: salon/getHomeData + products/getPublicHome → product_sellers / sellers.
  List<SoldByModel> _productSellers = <SoldByModel>[];
  List<SoldByModel> get productSellers => _productSellers;

  List<CouponsModel> _offersList = <CouponsModel>[];
  List<CouponsModel> get offersList => _offersList;

  List<TimedOfferIcon> _timedOffers = <TimedOfferIcon>[];
  List<TimedOfferIcon> get timedOffers => _timedOffers;

  List<TopPartnerModel> _topPartners = <TopPartnerModel>[];
  List<TopPartnerModel> get topPartners => _topPartners;


  bool apiCalled = false;
  int _homeFetchId = 0;

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
    markCountryFresh();
    getHomeData();
  }

  Future<void> getHomeData() async {
    final fetchId = ++_homeFetchId;
    final keepUi = apiCalled &&
        (_salonList.isNotEmpty ||
            _categoriesList.isNotEmpty ||
            _offersList.isNotEmpty);
    if (!keepUi) {
      apiCalled = false;
      update();
    }

    var param = {
      "lat": parser.getLat(),
      "lng": parser.getLng(),
    };

    final timedFuture = parser.getTimedOffersHome();
    Response response = await parser.getHomeData(param);
    if (fetchId != _homeFetchId) return;
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();

    _salonList = [];
    _categoriesList = [];
    _individualList = [];
    _bannerList = [];
    _productsList = [];
    _productSellers = [];
    _offersList = [];
    _timedOffers = [];
    _topPartners = [];

    final map = ApiBody.asMap(response.body);
    if (map != null) {
      HomeSections.applyFromJson(map);
      final nested = map['data'];
      if (nested is Map) {
        _applyHomeMap(Map<String, dynamic>.from(nested));
      }
      if (_salonList.isEmpty &&
          _categoriesList.isEmpty &&
          _individualList.isEmpty) {
        _applyHomeMap(map);
      } else {
        _parseTopPartners(map['top_partners'] ?? map['topPartners']);
      }
      if (_bannerList.isEmpty) {
        _parseBanners(map['banners']);
      }
      _enforceHomeSectionFlags();
    } else if (!ApiBody.isSuccess(response)) {
      debugPrint('getHomeData status ${response.statusCode}');
    }

    haveData = _salonList.isNotEmpty || _individualList.isNotEmpty;
    apiCalled = true;
    update();

    unawaited(_finishHomeExtras(timedFuture, fetchId));
  }

  Future<void> _finishHomeExtras(Future<Response> timedFuture, int fetchId) async {
    await Future.wait([
      () async {
        try {
          await _loadTimedOffersFrom(await timedFuture);
        } catch (e) {
          debugPrint('timedOffers extra: $e');
        }
      }(),
      _fillMissingHomeSections(),
    ]);
    if (fetchId != _homeFetchId) return;
    checkCartData();
    haveData = _salonList.isNotEmpty || _individualList.isNotEmpty;
    update();
  }

  void _applyHomeMap(Map<String, dynamic> myMap) {
    HomeSections.applyFromJson(myMap);
    _parseSalons(myMap['salon'] ?? myMap['salons']);
    _parseCategories(myMap['categories']);
    _parseIndividuals(myMap['individual'] ?? myMap['individuals']);
    _parseBanners(myMap['banners']);
    _parseProducts(myMap['products']);
    _parseProductSellers(
        myMap['product_sellers'] ?? myMap['sellers'] ?? myMap['productSellers']);
    _setOffers(myMap['offers'] ?? myMap['coupons'] ?? myMap);
    _parseTimedOffers(myMap['timed_offers'] ?? myMap['timedOffers']);
    _parseTopPartners(myMap['top_partners'] ?? myMap['topPartners']);
    _enforceHomeSectionFlags();
  }

  void _parseProductSellers(dynamic raw) {
    if (raw == null) return;
    final items = ApiBody.asItemList(raw, keys: const [
      'product_sellers',
      'sellers',
      'data',
      'items',
      'result',
      'list',
    ]);
    if (items.isEmpty) return;
    final seen = <int>{for (final s in _productSellers) s.sellerUid};
    for (final data in items) {
      try {
        if (data is! Map) continue;
        final seller =
            SoldByModel.fromJson(Map<String, dynamic>.from(data));
        final uid = seller.sellerUid;
        if (uid <= 0 || seen.contains(uid)) continue;
        seen.add(uid);
        _productSellers.add(seller);
      } catch (e) {
        debugPrint('Skip product seller: $e');
      }
    }
  }

  void _enforceHomeSectionFlags() {
    if (!HomeSections.showPartners) {
      _salonList = [];
      _topPartners = [];
    }
    if (!HomeSections.showFreelancers) {
      _individualList = [];
    }
    if (!HomeSections.showProducts) {
      _productsList = [];
    }
  }

  void _parseTopPartners(dynamic raw) {
    if (_topPartners.isNotEmpty) return;
    final items = ApiBody.asItemList(raw, keys: const [
      'top_partners',
      'topPartners',
      'data',
      'items',
      'result',
      'list',
    ]);
    for (final data in items) {
      try {
        final map = ApiBody.asObject(data);
        if (map == null) continue;
        final partner = TopPartnerModel.fromJson(map);
        if ((partner.uid ?? 0) <= 0 && (partner.name ?? '').isEmpty) continue;
        _topPartners.add(partner);
      } catch (e) {
        debugPrint('Skip top partner: $e');
      }
    }
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
    if (_bannerList.isNotEmpty) return;
    final items = ApiBody.asItemList(raw, keys: const [
      'banners',
      'data',
      'items',
      'result',
      'list',
    ]);
    final now = DateTime.now();
    for (final data in items) {
      try {
        final map = ApiBody.asObject(data);
        if (map == null) continue;
        final banner = BannerModel.fromJson(map);
        if ((banner.status ?? 1) == 0) continue;
        if ((banner.cover ?? '').isEmpty) continue;
        if (!_isBannerLive(banner, now)) continue;
        _bannerList.add(banner);
      } catch (e) {
        debugPrint('Skip banner: $e');
      }
    }
  }

  bool _isBannerLive(BannerModel banner, DateTime now) {
    final from = DateTime.tryParse(banner.from ?? '');
    final to = DateTime.tryParse(banner.to ?? '');
    if (from != null && now.isBefore(DateTime(from.year, from.month, from.day))) {
      return false;
    }
    if (to != null) {
      final end = DateTime(to.year, to.month, to.day, 23, 59, 59);
      if (now.isAfter(end)) return false;
    }
    return true;
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
    if (HomeSections.showPartners && _salonList.isEmpty) {
      jobs.add(_loadTopSalons(latLng));
    }
    if (HomeSections.showFreelancers && _individualList.isEmpty) {
      jobs.add(_loadTopFreelancers(latLng));
    }
    if (HomeSections.showProducts && _productsList.isEmpty) {
      jobs.add(_loadTopProducts(latLng));
    }
    if (_bannerList.isEmpty) jobs.add(_loadBanners(latLng));
    if (HomeSections.showPartners && _topPartners.isEmpty) {
      jobs.add(_loadTopPartners(latLng));
    }
    if (jobs.isNotEmpty) await Future.wait(jobs);
    _enforceHomeSectionFlags();
  }

  Future<void> _loadTopPartners(Map<String, dynamic> param) async {
    try {
      final response = await parser.getTopPartners(param);
      final map = ApiBody.asMap(response.body);
      _parseTopPartners(map?['data'] ?? map?['top_partners'] ?? response.body);
    } catch (e) {
      debugPrint('loadTopPartners: $e');
    }
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

  Future<void> _loadBanners(Map<String, dynamic> param) async {
    try {
      final response = await parser.getBannerData(param);
      final map = ApiBody.asMap(response.body);
      _parseBanners(map?['banners'] ?? response.body);
    } catch (e) {
      debugPrint('loadBanners: $e');
    }
  }

  Future<void> _loadTopProducts(Map<String, dynamic> param) async {
    try {
      // PDF: getPublicHome first (may 500 on backend) → topProducts → getAll.
      // No distance filter — products show in every location.
      Response? response;
      try {
        response = await parser.getProductsPublicHome({});
        if (response.statusCode != 200) response = null;
      } catch (_) {
        response = null;
      }
      response ??= await parser.getTopProducts(param);
      if (response.statusCode != 200) {
        response = await parser.getProductsAll({...param, 'limit': 40});
      }
      final map = ApiBody.asMap(response.body);
      final list = ApiBody.asList(
        map?['products'] ??
            map?['top_products'] ??
            map?['data'] ??
            response.body,
        keys: const ['products', 'top_products', 'data', 'items', 'result'],
      );
      _parseProducts(list);
      _parseProductSellers(
          map?['sellers'] ?? map?['product_sellers'] ?? map?['productSellers']);
      // Product offers from getPublicHome (when available).
      if (_offersList.isEmpty && map != null) {
        _setOffers(map['offers'] ?? map['coupons']);
      }
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

  void onTopPartner(TopPartnerModel partner) {
    final uid = partner.uid ?? partner.salonId ?? 0;
    if (uid <= 0) return;
    onServices(uid);
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

  void onProductStores() {
    Get.delete<ProductSellerController>(force: true);
    Get.toNamed(AppRouter.getProductSellerRoutes());
  }

  void onProductSeller(SoldByModel seller) {
    Get.delete<ProductSellerController>(force: true);
    Get.toNamed(AppRouter.getProductSellerRoutes(), arguments: [
      seller.sellerUid,
      seller.displayName,
      seller.cover ?? '',
      seller.address ?? '',
    ]);
  }

  void onAllOffersList() {
    Get.delete<CouponController>(force: true);
    Get.toNamed(AppRouter.getCouponRoutes());
  }

  /// VIEW DETAILS: this shop/offer only. VIEW ALL uses [onAllOffersList].
  void openExclusiveOffer(CouponsModel offer) {
    if (CouponParser.presentOffer(offer)) return;
    Get.delete<CouponController>(force: true);
    Get.toNamed(
      AppRouter.getCouponRoutes(),
      arguments: {
        'offerId': offer.id,
        'single': true,
        'seed': offer,
      },
    );
  }

  void claimOffer(CouponsModel offer) {
    if (CouponParser.presentOffer(offer)) return;
    if (offer.canBook) {
      bookExclusiveOffer(offer);
      return;
    }
    final code = offer.code ?? '';
    if (code.isEmpty) {
      showToast('Data is not available'.tr);
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
    final items = raw is List
        ? raw
        : ApiBody.asList(raw, keys: const [
            'offers',
            'coupons',
            'data',
            'items',
            'result',
            'list',
          ]);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final data in items) {
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
      _setOffers(response.body);
      if (_offersList.isEmpty) {
        response = await parser.getPublicHomeOffers();
        _setOffers(response.body);
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

  void onBannerItem(BannerModel item) {
    final action = (item.clickAction ?? '').trim().toLowerCase();
    final type = '${item.type ?? 0}';
    final value = (item.value ?? '').trim();
    final link = (item.link ?? '').trim();
    if (action == 'link' || type == '5') {
      final url = link.isNotEmpty ? link : value;
      if (url.isNotEmpty) launchInBrowser(url);
      return;
    }
    onBanner(value, type);
  }

  void onBanner(String value, String type) {
    debugPrint(value);
    debugPrint(type);
    final id = int.tryParse(value) ?? 0;
    if (type == '0') {
      Get.delete<UnifiedSearchController>(force: true);
      Get.toNamed(AppRouter.getCategoriesListRoutes(),
          arguments: [value, 'Offers']);
    } else if (type == '1') {
      if (id <= 0) return;
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [id]);
    } else if (type == '2') {
      if (id <= 0) return;
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(), arguments: [id]);
    } else if (type == '3') {
      Get.find<CategoriesController>().onCategoryExpand(value);
      Get.find<TabsController>().updateTabId(3);
    } else if (type == '4') {
      Get.delete<ProductsDetailsController>(force: true);
      Get.toNamed(AppRouter.getProductsDetailsRoutes(), arguments: [value]);
    } else if (type == '5') {
      if (value.isNotEmpty) launchInBrowser(value);
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
