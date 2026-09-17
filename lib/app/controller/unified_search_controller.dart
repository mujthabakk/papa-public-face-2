import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/banner_model.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/facilities_model.dart';
import 'package:salon_user/app/backend/models/salon_model.dart';
import 'package:salon_user/app/backend/models/search_individual_model.dart';
import 'package:salon_user/app/backend/parse/search_parse.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/categories_list_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/filter_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:url_launcher/url_launcher.dart';

enum Gender { kid, male, female, family }

enum SearchMode { general, category }

class UnifiedSearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController();
  RxBool isEmpty = true.obs;
  String lastSearch = '';

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<SearchIndividualModel> _individualList = <SearchIndividualModel>[];
  List<SearchIndividualModel> get individualList => _individualList;

  List<SalonModel> _serviceList = <SalonModel>[];
  List<SalonModel> _localShops = <SalonModel>[];
  List<SearchIndividualModel> _localFreelancers = <SearchIndividualModel>[];
  List<SalonModel> _localServices = <SalonModel>[];
  Timer? _searchDebounce;

  bool _isRealServiceName(String? name) {
    final n = (name ?? '').trim().toLowerCase();
    return n.isNotEmpty && n != 'unknown service';
  }

  bool _hit(String q, List<String?> fields) {
    if (q.isEmpty) return true;
    return fields.any((f) => (f ?? '').toLowerCase().contains(q));
  }

  bool get _genderFilterActive => isMale || isFemale || isKid || isFamily;

  bool _matchesSelectedGender(int? gender) {
    if (!_genderFilterActive) return true;
    return gender == genderId;
  }

  List<SalonModel> _filterShops(List<SalonModel> source) {
    final q = searchValue.trim().toLowerCase();
    if (q.isEmpty && !hasSearched) return <SalonModel>[];
    return source.where((s) {
      if (!_matchesSelectedGender(s.gender)) return false;
      if (q.isEmpty) return true;
      return _hit(q, [s.name, s.serviceName, s.address]);
    }).toList();
  }

  List<SearchIndividualModel> _filterPeople(List<SearchIndividualModel> source) {
    final q = searchValue.trim().toLowerCase();
    if (q.isEmpty && !hasSearched) return <SearchIndividualModel>[];
    return source.where((s) {
      if (!_matchesSelectedGender(s.gender)) return false;
      if (q.isEmpty) return true;
      return _hit(q, [s.name, s.serviceName, s.address]);
    }).toList();
  }

  List<SalonModel> _mergeShops(List<SalonModel> a, List<SalonModel> b) {
    final out = <SalonModel>[...a];
    for (final item in b) {
      final uid = item.uid ?? 0;
      if (uid > 0 && out.any((e) => e.uid == uid)) continue;
      if (uid <= 0 &&
          out.any((e) =>
              (e.name ?? '').toLowerCase() == (item.name ?? '').toLowerCase())) {
        continue;
      }
      out.add(item);
    }
    return out;
  }

  List<SalonModel> _mergeServices(List<SalonModel> a, List<SalonModel> b) {
    final out = <SalonModel>[...a];
    for (final item in b) {
      final sid = item.serviceId ?? item.id ?? 0;
      if (sid > 0 &&
          out.any((e) => (e.serviceId ?? e.id) == sid && e.uid == item.uid)) {
        continue;
      }
      if (sid <= 0 &&
          out.any((e) =>
              (e.serviceName ?? '').toLowerCase() ==
                  (item.serviceName ?? '').toLowerCase() &&
              e.uid == item.uid)) {
        continue;
      }
      out.add(item);
    }
    return out;
  }

  /// Frontend name filter over shop / freelancer / service results.
  List<SalonModel> get filteredSalonList =>
      _mergeShops(_filterShops(_salonList), _filterShops(_localShops));

  List<SearchIndividualModel> get filteredIndividualList {
    final q = searchValue.trim().toLowerCase();
    final api = _filterPeople(_individualList);
    final local = _filterPeople(_localFreelancers);
    final out = <SearchIndividualModel>[...api];
    for (final item in local) {
      if ((item.uid ?? 0) > 0 && out.any((e) => e.uid == item.uid)) continue;
      out.add(item);
    }
    if (q.isEmpty && !hasSearched) return <SearchIndividualModel>[];
    return out;
  }

  List<SalonModel> get filteredServiceList => _mergeServices(
        _filterShops(_serviceList),
        _filterShops(_localServices),
      );

  List<BannerModel> _bannerList = <BannerModel>[];
  List<BannerModel> get bannerList => _bannerList;

  String selectedCateId = '';
  String selectedCateName = '';

  String searchValue = '';

  bool isMale = false;
  bool isFemale = false;
  bool isKid = false;
  bool isFamily = false;
  int genderId = 1;

  bool isLoading = false;
  bool isEmptySearchSalon = false;
  bool isEmptySearchFreelancer = false;
  bool isEmptySearchService = false;
  bool hasSearched = false;
  bool rateSelected = false;

  var selectedGender = Gender.male.obs;
  var currentRangeValues = const RangeValues(0, 200).obs;
  var currentRangeValuesPrice = const RangeValues(0, 70000).obs;
  var tabID = 0.obs;
  var starValue = 4.0.obs;
  var selectedSortOption = 'Ascending'.obs;
  var isSelected = List<bool>.generate(50, (index) => false).obs;
  var isSelectedCat = List<bool>.generate(50, (index) => false).obs;

  List<FacilitiesModel> chipLabels = [];
  List<String> facilitiesIds = [];
  List<String> selectedcat = [];

  List<String> sortingOptions = [
    'Ascending',
    'Descending',
  ];

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  // Mode detection
  SearchMode mode = SearchMode.general;
  bool get isCategoryMode => mode == SearchMode.category;
  bool get isGeneralMode => mode == SearchMode.general;

  String title = '';
  UnifiedSearchController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    // Detect mode based on arguments
    if (Get.arguments != null && Get.arguments.length >= 2) {
      // Category mode - has [categoryId, categoryName]
      mode = SearchMode.category;
      selectedCateId = Get.arguments[0].toString();
      selectedCateName = Get.arguments[1].toString();
      selectedcat.add(selectedCateId);

      debugPrint('Mode: Category');
      debugPrint('catID: $selectedCateId');
      debugPrint('catName: $selectedCateName');
    } else {
      // General search mode
      mode = SearchMode.general;
      debugPrint('Mode: General Search');
    }

    title = parser.getAddressName();
    getFacilitiesData();
    getAllCategories();
    getBannerData();
    _seedLocalCatalog();

    // Auto-load results only in category mode
    if (isCategoryMode) {
      getSearchResultInit();
    }

    update();
  }

  void refreshLocationData() {
    title = parser.getAddressName();
    update();
  }

  void updateGender(Gender? gender) {
    selectedGender.value = gender!;
    if (selectedGender.value == Gender.male) {
      isMaleSelected(true);
    } else if (selectedGender.value == Gender.female) {
      isFemaleSelected(true);
    } else if (selectedGender.value == Gender.kid) {
      isKidSelected(true);
    } else if (selectedGender.value == Gender.family) {
      isFamilySelected(true);
    }
    update();
  }

  void updateRating(double rating) {
    starValue.value = rating;
    rateSelected = true;
    update();
  }

  void setSearchValue(String value) {
    searchValue = value;
    if (!isGeneralMode) {
      update();
      return;
    }
    final q = value.trim();
    if (q.isEmpty) {
      _searchDebounce?.cancel();
      hasSearched = false;
      _salonList = [];
      _individualList = [];
      _serviceList = [];
      update();
      return;
    }
    hasSearched = true;
    update();
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      getSearchResult(q);
    });
  }

  searchProducts(
    BuildContext context,
    String query,
  ) {
    searchValue = query.trim();

    if (isCategoryMode) {
      if (!(isFemale || isKid || isMale || isFamily)) {
        FocusManager.instance.primaryFocus?.unfocus();
        genderDialog(context);
        return;
      }
      if (searchValue.isEmpty) {
        getSearchResultInit();
        return;
      }
      getSearchResult(searchValue);
      return;
    }

    // General mode: shop / freelancer / service search (API + frontend).
    if (!(isFemale || isKid || isMale || isFamily)) {
      isMale = true;
      genderId = 1;
      selectedGender.value = Gender.male;
    }
    if (searchValue.isEmpty) {
      _searchDebounce?.cancel();
      _salonList = [];
      _individualList = [];
      _serviceList = [];
      hasSearched = false;
      isEmpty = true.obs;
      update();
      return;
    }
    hasSearched = true;
    isEmpty = false.obs;
    update();
    _searchDebounce?.cancel();
    getSearchResult(searchValue);
  }

  void _seedLocalCatalog() {
    if (!Get.isRegistered<HomeController>()) return;
    final home = Get.find<HomeController>();
    _localShops = [];
    _localServices = [];
    _localFreelancers = [];

    for (final s in home.salonList) {
      if (_isRealServiceName(s.serviceName)) {
        _localServices.add(s);
      }
      if (!_localShops.any((e) => e.uid != null && e.uid == s.uid)) {
        _localShops.add(s);
      }
    }
    for (final c in home.categoriesList) {
      final name = (c.name ?? '').trim();
      if (name.isEmpty) continue;
      _localServices.add(SalonModel(
        id: c.id,
        serviceId: c.id,
        serviceName: name,
        name: name,
        cover: c.cover,
        status: 1,
      ));
    }
    for (final p in home.topPartners) {
      final uid = p.uid ?? p.salonId ?? p.id ?? 0;
      if (uid <= 0 || _localShops.any((e) => e.uid == uid)) continue;
      _localShops.add(SalonModel(
        uid: uid,
        name: p.name,
        cover: p.cover,
        address: p.address ?? p.city,
        rating: p.rating,
        totalRating: p.totalRating ?? p.reviewsCount,
        reviewCount: p.reviewsCount,
        distance: p.distance,
        status: 1,
      ));
    }
    for (final i in home.individualList) {
      final name =
          '${i.userInfo?.firstName ?? ''} ${i.userInfo?.lastName ?? ''}'.trim();
      _localFreelancers.add(SearchIndividualModel(
        uid: i.uid ?? i.id,
        id: i.id,
        name: name.isEmpty ? 'Freelancer' : name,
        cover: i.userInfo?.cover,
        distance: i.distance,
        status: 1,
      ));
    }
  }

  void toggleChip(int index) {
    isSelected[index] = !isSelected[index];
    if (isSelected[index]) {
      facilitiesIds.add(chipLabels[index].id.toString());
    } else {
      facilitiesIds.remove(chipLabels[index].id.toString());
    }
    print(facilitiesIds);
    update();
  }

  void toggleChipCat(int index) {
    isSelectedCat[index] = !isSelectedCat[index];

    if (isSelectedCat[index]) {
      selectedcat.add(categoriesList[index].id.toString());
    } else {
      selectedcat.remove(categoriesList[index].id.toString());
    }
    print(selectedcat);
    update();
  }

  void updateSortOption(String? newValue) {
    selectedSortOption.value = newValue!;
  }

  void updateTabID(int id) {
    tabID.value = id;
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onFilter() {
    Get.delete<FilterController>(force: true);
    // Use appropriate filter route based on mode
    if (isCategoryMode) {
      Get.toNamed(AppRouter.getFilterRoutesCat());
    } else {
      Get.toNamed(AppRouter.getFilterRoutes());
    }
  }

  void isKidSelected(bool value) {
    isKid = value;
    isFemale = false;
    isMale = false;
    isFamily = false;
    genderId = 0;
    print('genderid $genderId');
    update();
  }

  void isMaleSelected(bool value) {
    isMale = value;
    isFemale = false;
    isKid = false;
    isFamily = false;
    genderId = 1;
    print('genderid $genderId');
    update();
  }

  void isFemaleSelected(bool value) {
    isFemale = value;
    isFamily = false;
    isKid = false;
    isMale = false;
    genderId = 2;
    print('genderid $genderId');
    update();
  }

  void isFamilySelected(bool value) {
    isFamily = value;
    isFemale = false;
    isKid = false;
    isMale = false;
    genderId = 3;
    print('genderid $genderId');
    update();
  }

  Future<List<String>> fetchAutoCompleteServices(String keyword) async {
    final query = keyword.trim();
    if (query.isEmpty) return [];

    final suggestions = <String>{};

    // Local suggestions from already-loaded shop / freelancer names.
    for (final s in _salonList) {
      final name = (s.name ?? '').trim();
      if (name.isNotEmpty &&
          name.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(name);
      }
      final service = (s.serviceName ?? '').trim();
      if (service.isNotEmpty &&
          service.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(service);
      }
    }
    for (final s in _localShops) {
      final name = (s.name ?? '').trim();
      if (name.isNotEmpty &&
          name.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(name);
      }
    }
    for (final s in _localServices) {
      final service = (s.serviceName ?? s.name ?? '').trim();
      if (service.isNotEmpty &&
          service.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(service);
      }
    }
    for (final s in _individualList) {
      final name = (s.name ?? '').trim();
      if (name.isNotEmpty &&
          name.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(name);
      }
    }
    for (final s in _localFreelancers) {
      final name = (s.name ?? '').trim();
      if (name.isNotEmpty &&
          name.toLowerCase().contains(query.toLowerCase())) {
        suggestions.add(name);
      }
    }

    try {
      final response = await http
          .get(Uri.parse('${AppConstants.fetchAutoCompleteServices}$query'));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          for (final item in decoded) {
            final text = item.toString().trim();
            if (text.isNotEmpty &&
                text.toLowerCase().contains(query.toLowerCase())) {
              suggestions.add(text);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Autocomplete failed: $e');
    }

    // Also pull live shop/freelancer name matches from search API.
    try {
      final response = await parser.getSearchResult({
        "category": '',
        "rating": '',
        "gender": genderId,
        "distance_from": '0',
        "distance_to": '200',
        "price_start": '0',
        "price_end": '70000',
        "price_sort": selectedSortOption.value,
        "lat": parser.getLat(),
        "lng": parser.getLng(),
        "param": query,
        "facilities": '',
      });
      final map = ApiBody.asMap(response.body);
      if (map != null) {
        for (final data in ApiBody.asItemList(map['partners'] ?? map['salon'],
            keys: const ['partners', 'salon', 'salons', 'data'])) {
          final item = ApiBody.asObject(data);
          final name = item?['name']?.toString().trim() ?? '';
          if (name.isNotEmpty &&
              name.toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(name);
          }
        }
        for (final data in ApiBody.asItemList(
            map['freelancers'] ?? map['individual'],
            keys: const ['freelancers', 'individual', 'individuals', 'data'])) {
          final item = ApiBody.asObject(data);
          final name = item?['name']?.toString().trim() ?? '';
          if (name.isNotEmpty &&
              name.toLowerCase().contains(query.toLowerCase())) {
            suggestions.add(name);
          }
        }
      }
    } catch (e) {
      debugPrint('Name autocomplete failed: $e');
    }

    final list = suggestions.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list.take(12).toList();
  }

  void getSearchResult(String query) async {
    lastSearch = query;
    hasSearched = true;
    String rating = starValue.value.toString();
    isEmptySearchFreelancer = false;
    isEmptySearchSalon = false;
    isLoading = true;
    update();
    String selCat;

    if (selectedcat.isEmpty) {
      selCat = '';
    } else {
      selCat = selectedcat.last;
    }
    if (!rateSelected) {
      rating = '';
    }

    print(selCat);
    String facilities = '';

    if (facilitiesIds.isNotEmpty) {
      facilities = facilitiesIds.join(',');
    }

    var param = {
      "category": selCat,
      "rating": rating,
      "gender": genderId,
      "distance_from": currentRangeValues.value.start.round().toString(),
      "distance_to": currentRangeValues.value.end.round().toString(),
      "price_start": currentRangeValuesPrice.value.start.round().toString(),
      "price_end": currentRangeValuesPrice.value.end.round().toString(),
      "price_sort": selectedSortOption.value,
      "lat": parser.getLat(),
      "lng": parser.getLng(),
      "param": query,
      "facilities": facilities,
    };

    debugPrint(
        '[SEARCH_API_PAYLOAD] mode=general lat=${param["lat"]}, lng=${param["lng"]}, query=$query');

    print('lat ${parser.getLat()}');
    print('lng ${parser.getLng()}');

    Response? response;
    try {
      response = await parser.getSearchResult(param);
    } catch (e) {
      debugPrint('Search API failed, using frontend: $e');
    }
    isLoading = false;
    _salonList = [];
    _individualList = [];
    _serviceList = [];
    var apiOk = false;
    try {
      apiOk = response != null &&
          (ApiBody.isSuccess(response) ||
              ApiBody.asMap(response.body) != null);
    } catch (_) {
      apiOk = false;
    }
    if (apiOk && response != null) {
      final map = ApiBody.asMap(response.body) ?? {};
      for (final data in ApiBody.asItemList(map['partners'] ?? map['salon'],
          keys: const ['partners', 'salon', 'salons', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _salonList.add(SalonModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search salon: $e');
        }
      }
      for (final data in ApiBody.asItemList(
          map['freelancers'] ?? map['individual'],
          keys: const ['freelancers', 'individual', 'individuals', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _individualList.add(SearchIndividualModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search freelancer: $e');
        }
      }
      for (final data in ApiBody.asItemList(
          map['services'] ?? map['service'],
          keys: const ['services', 'service', 'treatments', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _serviceList.add(SalonModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search service: $e');
        }
      }

      if (isGeneralMode) {
        _salonList.removeWhere((salon) => salon.status == 0);
        _individualList.removeWhere((individual) => individual.status == 0);
        _serviceList.removeWhere((service) => service.status == 0);
      }
      _salonList.removeWhere((s) => !_matchesSelectedGender(s.gender));
      _individualList.removeWhere((s) => !_matchesSelectedGender(s.gender));
      _serviceList.removeWhere((s) => !_matchesSelectedGender(s.gender));
      isEmpty = false.obs;
    } else {
      isEmpty = false.obs;
    }

    if (isGeneralMode) {
      _seedLocalCatalog();
    }
    isEmptySearchSalon = filteredSalonList.isEmpty;
    isEmptySearchFreelancer = filteredIndividualList.isEmpty;
    isEmptySearchService = filteredServiceList.isEmpty;
    if (!apiOk &&
        isEmptySearchSalon &&
        isEmptySearchFreelancer &&
        isEmptySearchService &&
        response != null) {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getSearchResultInit() async {
    String rating = starValue.value.toString();
    isEmptySearchFreelancer = false;
    isEmptySearchSalon = false;
    isLoading = true;
    update();
    String selCat;

    if (selectedcat.isEmpty) {
      selCat = selectedCateId;
    } else {
      selCat = selectedcat.last;
    }
    if (!rateSelected) {
      rating = '';
    }

    print(selCat);
    String facilities = '';

    if (facilitiesIds.isNotEmpty) {
      facilities = facilitiesIds.join(',');
    }

    var param = {
      "category": selectedCateId,
      "gender": genderId,
      "distance_from": currentRangeValues.value.start.round().toString(),
      "distance_to": currentRangeValues.value.end.round().toString(),
      "lat": parser.getLat(),
      "lng": parser.getLng(),
    };

    debugPrint(
        '[SEARCH_API_PAYLOAD] mode=category lat=${param["lat"]}, lng=${param["lng"]}, category=$selectedCateId');

    print('lat ${parser.getLat()}');
    print('lng ${parser.getLng()}');

    Response response = await parser.getSearchResult(param);
    isLoading = false;
    _salonList = [];
    _individualList = [];
    if (ApiBody.isSuccess(response) || ApiBody.asMap(response.body) != null) {
      final map = ApiBody.asMap(response.body) ?? {};
      for (final data in ApiBody.asItemList(map['partners'] ?? map['salon'],
          keys: const ['partners', 'salon', 'salons', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _salonList.add(SalonModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search salon: $e');
        }
      }
      for (final data in ApiBody.asItemList(
          map['freelancers'] ?? map['individual'],
          keys: const ['freelancers', 'individual', 'individuals', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _individualList.add(SearchIndividualModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search freelancer: $e');
        }
      }
      _salonList.removeWhere((s) => !_matchesSelectedGender(s.gender));
      _individualList.removeWhere((s) => !_matchesSelectedGender(s.gender));
      isEmptySearchSalon = _salonList.isEmpty;
      isEmptySearchFreelancer = _individualList.isEmpty;
      isEmpty = false.obs;
    } else {
      isEmpty = false.obs;
      isEmptySearchSalon = true;
      isEmptySearchFreelancer = true;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getAllCategories() async {
    var response = await parser.getAllCategories();
    _categoriesList = [];
    if (ApiBody.isSuccess(response) || ApiBody.asMap(response.body) != null) {
      final map = ApiBody.asMap(response.body) ?? {};
      for (final data in ApiBody.asItemList(map['data'],
          keys: const ['data', 'categories'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _categoriesList.add(CategoriesModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search category: $e');
        }
      }
      isSelectedCat =
          List<bool>.generate(categoriesList.length, (index) => false).obs;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void genderDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color.fromARGB(255, 51, 51, 51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Your Type',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose a type for more\nrefined search result',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 194, 160, 61)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _typeOption(context, 'Male', 'assets/images/male.png',
                      Icons.male, () => isMaleSelected(true)),
                  _typeOption(context, 'Female', 'assets/images/female.png',
                      Icons.female, () => isFemaleSelected(true)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _typeOption(context, 'Kid', 'assets/images/kid.png',
                      Icons.child_care, () => isKidSelected(true)),
                  _typeOption(context, 'Family', 'assets/images/family.jpeg',
                      Icons.family_restroom, () => isFamilySelected(true)),
                ],
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.amber),
              ),
            ],
          ),
        ),
      ),
      barrierColor: const Color(0xB8000000),
    );
  }

  Widget _typeOption(
    BuildContext context,
    String label,
    String asset,
    IconData fallback,
    VoidCallback onSelect,
  ) {
    return GestureDetector(
      onTap: () {
        onSelect();
        Get.back();
        if (isCategoryMode || searchValue.isNotEmpty) {
          searchProducts(context, searchValue);
        }
      },
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC7C6C0), width: 2),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(fallback,
                  size: 42, color: Colors.amber),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber),
          ),
        ],
      ),
    );
  }

  Future<void> getBannerData() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getBannerData(param);
    _bannerList = [];
    if (ApiBody.isSuccess(response) || ApiBody.asMap(response.body) != null) {
      final map = ApiBody.asMap(response.body) ?? {};
      for (final data in ApiBody.asItemList(map['banners'],
          keys: const ['banners', 'data'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          _bannerList.add(BannerModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip search banner: $e');
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getFacilitiesData() async {
    Response response = await parser.getFacilitiesData();
    chipLabels = [];
    if (ApiBody.isSuccess(response) || ApiBody.asMap(response.body) != null) {
      final map = ApiBody.asMap(response.body) ?? {};
      for (final data in ApiBody.asItemList(map['data'],
          keys: const ['data', 'facilities'])) {
        try {
          final item = ApiBody.asObject(data);
          if (item == null) continue;
          chipLabels.add(FacilitiesModel.fromJson(item));
        } catch (e) {
          debugPrint('Skip facility: $e');
        }
      }
      isSelected = List<bool>.generate(chipLabels.length, (index) => false).obs;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onBanner(String value, String type) {
    onBack();
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

  void clearFilters() {
    selectedcat.clear();
    rateSelected = false;
    starValue.value = 4.0;
    selectedSortOption.value = 'Ascending';
    currentRangeValues.value = const RangeValues(1, 20);
    currentRangeValuesPrice.value = const RangeValues(10, 50000);
    facilitiesIds.clear();
    isSelectedCat =
        List<bool>.generate(categoriesList.length, (index) => false).obs;
    isSelected = List<bool>.generate(chipLabels.length, (index) => false).obs;

    Get.snackbar('Filters Cleared', 'All Filters Cleared',
        backgroundColor: Colors.red);
    update();
  }

  void clearData() {
    searchController.clear();
    searchValue = '';
    hasSearched = false;
    _salonList = [];
    _individualList = [];
    _serviceList = [];
    isEmpty = true.obs;
    update();
  }

  void onServices(int uid) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }

  void onServiceResult(SalonModel s) {
    if ((s.uid ?? 0) > 0) {
      onServices(s.uid ?? 0);
      return;
    }
    final cateId = s.serviceId ?? s.id ?? 0;
    if (cateId > 0) {
      Get.toNamed(
        AppRouter.getCategoriesListRoutes(),
        arguments: [cateId.toString(), s.serviceName ?? s.name ?? 'Services'],
      );
    }
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }
}
