import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/banner_model.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/facilities_model.dart';
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
import 'package:salon_user/app/util/constant.dart';
import 'package:url_launcher/url_launcher.dart';

enum Gender { male, female, kid, family }

class CategorySearchController extends GetxController implements GetxService {
  final SearchParser parser;
  TextEditingController searchController = TextEditingController();
  RxBool isEmpty = true.obs;
  String lastSearch = '';

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<SearchIndividualModel> _individualList = <SearchIndividualModel>[];
  List<SearchIndividualModel> get individualList => _individualList;

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
  bool rateSelected = false;

  var selectedGender = Gender.male.obs;
  var currentRangeValues = const RangeValues(0, 200).obs;
  var currentRangeValuesPrice = const RangeValues(0, 70000).obs;
  var tabID = 1.obs;
  var starValue = 4.0.obs;
  var selectedSortOption = 'Ascending'.obs;
  var isSelected = List<bool>.generate(50, (index) => false)
      .obs; // Update the size if chipLabels changes
  var isSelectedCat = List<bool>.generate(50, (index) => false)
      .obs; // Update the size if chipLabels changes; //
  List<FacilitiesModel> chipLabels = [
    // 'Hairstyle',
    // 'Makeup',
    // 'Hair Styling',
    // 'Spa',
    // 'Facial Makeup',
    // 'Trim & Shaving',
    // 'Free Cancellation',
    // 'Facial Makeup',
    // 'Smoking Area',
    // 'Caffeteria'
  ];

  List<String> facilitiesIds = [];
  List<String> selectedcat = [];

  List<String> sortingOptions = [
    'Ascending',
    'Descending',
  ];

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

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
    update();
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
  }

  String title = '';
  CategorySearchController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    selectedCateId = Get.arguments[0].toString();
    selectedCateName = Get.arguments[1].toString();

    selectedcat.add(selectedCateId);

    debugPrint('catID' + selectedCateId);
    debugPrint('catName' + selectedCateName);

    title = parser.getAddressName();
    getFacilitiesData();
    getAllCategories();
    getBannerData();
    getSearchResultInit();
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onFilter() {
    Get.delete<FilterController>(force: true);
    Get.toNamed(AppRouter.getFilterRoutesCat());
  }

  void isMaleSelected(bool value) {
    isMale = value;
    isFemale = false;
    isKid = false;
    isFamily = false;
    genderId = 0;
    print('genderid $genderId');
    update();
  }

  void isFemaleSelected(bool value) {
    isFemale = value;
    isFamily = false;
    isKid = false;
    isMale = false;
    genderId = 1;
    print('genderid $genderId');
    update();
  }

  void isKidSelected(bool value) {
    isKid = value;
    isFemale = false;
    isMale = false;
    isFamily = false;
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
    final response = await http
        .get(Uri.parse('${AppConstants.fetchAutoCompleteServices}$keyword'));

    if (response.statusCode == 200) {
      List<String> options = (jsonDecode(response.body) as List)
          .map((item) => item.toString())
          .where((item) => item.toLowerCase().startsWith(keyword.toLowerCase()))
          .toList();
      return options;
    } else {
      throw Exception('Failed to load options');
    }
  }

  searchProducts(
    BuildContext context,
    String query,
  ) {
    // searchValue = query;
    // if (isFemale || isKid || isMale || isFamily) {
    //   if (query.isNotEmpty && query != '') {
    //     getSearchResult(
    //       query,
    //     );
    //   } else {
    //     _salonList = [];
    //     _individualList = [];
    //     isEmpty = true.obs;
    //     update();
    //   }
    // } else {
    //   genderDialog(context);
    // }

    if (isFemale || isKid || isMale || isFamily) {
      getSearchResult(
        query,
      );
    } else {
      genderDialog(context);
    }
  }

  void getSearchResult(
    String query,
    //double? distancefrom,
    // double? distanceto,
  ) async {
    lastSearch = query;
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

    print('lat ${parser.getLat()}');
    print('lng ${parser.getLng()}');

    Response response = await parser.getSearchResult(param);
    if (response.statusCode == 200) {
      isLoading = false;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['partners'];
      var individualData = myMap['freelancers'];
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

      if (_salonList.isEmpty) {
        isEmptySearchSalon = true;
      }
      if (_individualList.isEmpty) {
        isEmptySearchFreelancer = true;
      }

      isEmpty = false.obs;
      debugPrint(salonList.length.toString());
      debugPrint(individualList.length.toString());
    } else {
      isLoading = false;
      isEmpty = false.obs;
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
      // "rating": rating,
      // "gender": genderId,
      "distance_from": currentRangeValues.value.start.round().toString(),
      "distance_to": currentRangeValues.value.end.round().toString(),
      //  "price_start": currentRangeValuesPrice.value.start.round().toString(),
      //  "price_end": currentRangeValuesPrice.value.end.round().toString(),
      // "price_sort": selectedSortOption.value,
      "lat": parser.getLat(),
      "lng": parser.getLng(),
      //"param": query,
      //"facilities": facilities,
    };

    print('lat ${parser.getLat()}');
    print('lng ${parser.getLng()}');

    Response response = await parser.getSearchResult(param);
    if (response.statusCode == 200) {
      isLoading = false;
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var salonData = myMap['partners'];
      var individualData = myMap['freelancers'];
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

      if (_salonList.isEmpty) {
        isEmptySearchSalon = true;
      }
      if (_individualList.isEmpty) {
        isEmptySearchFreelancer = true;
      }

      isEmpty = false.obs;
      debugPrint(salonList.length.toString());
      debugPrint(individualList.length.toString());
    } else {
      isLoading = false;
      isEmpty = false.obs;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getAllCategories() async {
    var response = await parser.getAllCategories();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _categoriesList = [];
      body.forEach((data) {
        CategoriesModel cateData = CategoriesModel.fromJson(data);
        _categoriesList.add(cateData);
      });
      isSelectedCat =
          List<bool>.generate(categoriesList.length, (index) => false).obs;

      debugPrint(categoriesList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void genderDialog(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height *
              0.68, // Set height to 80% of the screen height
          child: Container(
            color: Color.fromARGB(
                255, 51, 51, 51), // Set background color to black
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 20),
                const Text(
                  'Select Your Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber, // Set text color to golden
                  ),
                ),
                SizedBox(height: 25),
                const Text(
                  'Choose a type for more \nrefined search result',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 194, 160, 61)),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isMaleSelected(true);
                            //if (searchValue != "") {
                            searchProducts(context, searchValue);
                            //}
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 199, 198, 192),
                                width: 2, // Set outline width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset("assets/images/male.png",
                                  width: 100, height: 100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Male",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                    //SizedBox(width: 10),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isFemaleSelected(true);
                            // if (searchValue != "") {
                            searchProducts(context, searchValue);
                            // }
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 199, 198,
                                    192), // Set outline color to golden
                                width: 2, // Set outline width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset("assets/images/female.png",
                                  width: 100, height: 100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Female",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isKidSelected(true);
                            // if (searchValue != "") {
                            searchProducts(context, searchValue);
                            // }
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 199, 198,
                                    192), // Set outline color to golden
                                width: 2, // Set outline width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset("assets/images/kid.png",
                                  width: 100, height: 100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Kid",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isFamilySelected(true);
                            //if (searchValue != "") {
                            searchProducts(context, searchValue);
                            // }
                            Get.back();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 199, 198,
                                    192), // Set outline color to golden
                                width: 2, // Set outline width
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset("assets/images/family.jpeg",
                                  width: 100, height: 100),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Family",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Color.fromARGB(255, 73, 73, 72), // Set background color
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.amber, // Set icon color to golden
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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

  Future<void> getFacilitiesData() async {
    //var param = {"uid": 1};
    Response response = await parser.getFacilitiesData();
    // apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var bannerData = myMap['data'];
      chipLabels = [];

      bannerData.forEach((data) {
        FacilitiesModel chip = FacilitiesModel.fromJson(data);
        chipLabels.add(chip);
      });
      isSelected = List<bool>.generate(chipLabels.length, (index) => false).obs;
      debugPrint(chipLabels.length.toString());

      update();
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
