import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/individual_info_model.dart';
import 'package:salon_user/app/backend/models/packages_model.dart';
import 'package:salon_user/app/backend/models/owner_reviews_model.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/backend/models/userinfo_model.dart';
import 'package:salon_user/app/backend/parse/specialist_parse.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/individual_list_controller.dart';
import 'package:salon_user/app/controller/individual_packages_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialistController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final SpecialistParser parser;

  int tabID = 1;

  String title = 'Select Service'.tr;

  List<String> dayList = [
    'Sunday'.tr,
    'Monday'.tr,
    'Tuesday'.tr,
    'Wednesday'.tr,
    'Thursday'.tr,
    'Friday'.tr,
    'Saturday'.tr
  ];
  bool _isPremium = false;
  bool get isPremium => _isPremium;
  List<String> gallery = [];

  IndividualInfoModel _individualDetails = IndividualInfoModel();
  IndividualInfoModel get individualDetails => _individualDetails;

  UserInfoModel _userInfo = UserInfoModel();
  UserInfoModel get userInfo => _userInfo;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  List<PackagesModel> _packagesList = <PackagesModel>[];
  List<PackagesModel> get packagesList => _packagesList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<OwnerReviewsModel> _ownerReviewsList = <OwnerReviewsModel>[];
  List<OwnerReviewsModel> get ownerReviewsList => _ownerReviewsList;

  ////////////////

  List<ServicesModel> _servicesList = <ServicesModel>[];
  List<ServicesModel> get servicesList => _servicesList;

  String selectedService = '';
  String selectedServiceName = '';

  bool apiCalled = false;
  bool reviewsCalled = false;

  int individualId = 0;
  final Set<Marker> markers = {};
  String getDistance = '';
  SpecialistController({required this.parser});

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      debugPrint(tabController.index.toString());
      if (tabController.index == 3) {
        debugPrint('get reviews');
        reviewsCalled = false;
        update();
        getOwnerReviews();
      }
    });

    int checkPremium = 0;

    List<dynamic>? arguments = Get.arguments;
    individualId = Get.arguments[0];

    checkPremium =
        (arguments != null && arguments.length > 1 && arguments[1] is int)
            ? arguments[1]
            : 0; // Default value to prevent errors
    if (checkPremium == 1) {
      getPremium2();
    }
    getindividualDetails();
    debugPrint('individual id --> $individualId');
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  Future<void> getPremium() async {
    var response = await parser.getPremium({"uid": individualId});

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

      bool isPremium =
          myMap['is_premium'] ?? false; // Extracting `is_premium` value

      // You can store `isPremium` in a variable or state if needed
      _isPremium = isPremium; // Assuming `_isPremium` is a controller variable

      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void getPremium2() async {
    var response = await parser.getPremium({"uid": individualId});

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      // print(response.body + "QRresponse");

      bool isPremiumd =
          myMap['is_premium'] ?? false; // Extracting `is_premium` value
      // You can store `isPremium` in a variable or state if needed
      isPremiumd; // Assuming `_isPremium` is a controller variable

      if (!isPremiumd) {
        Get.dialog(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Material(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Not Available...!",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Feature Not Available For This Business",
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    child: const Text('OK'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(0, 45),
                                      backgroundColor: ThemeProvider.pink,
                                      foregroundColor: const Color(0xFFFFFFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                      Get.back();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      update();
    } else {
      Get.back();
      showToast('User Not Found');
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getindividualDetails() async {
    var response = await parser.individualDetails({"id": individualId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      var salonCategories = myMap['categories'];
      var salonPackages = myMap['packages'];
      var user = myMap['userInfo'];
      var salonServices = myMap['services'];

      _individualDetails = IndividualInfoModel();
      _userInfo = UserInfoModel();
      _categoriesList = [];
      _packagesList = [];
      _servicesList = [];

      IndividualInfoModel services = IndividualInfoModel.fromJson(body);
      _individualDetails = services;
      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(_individualDetails.lat.toString()) ?? 0.0,
        double.tryParse(_individualDetails.lng.toString()) ?? 0.0,
        double.tryParse(parser.getLat().toString()) ?? 0.0,
        double.tryParse(parser.getLng().toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint(distance.toString());
      getDistance = distance.toString();
      if (individualDetails.images != 'NA' &&
          individualDetails.images != null &&
          individualDetails.images != '') {
        var imgs = jsonDecode(individualDetails.images!);
        gallery = [];
        if (imgs.length > 0) {
          imgs.forEach((element) {
            if (element != '') {
              gallery.add(element);
            }
          });
          update();
        }
      }

      UserInfoModel userDetails = UserInfoModel.fromJson(user);
      _userInfo = userDetails;

      salonCategories.forEach((data) {
        CategoriesModel categories = CategoriesModel.fromJson(data);
        _categoriesList.add(categories);
      });
      debugPrint(categoriesList.length.toString());

      salonServices.forEach((data) {
        ServicesModel services = ServicesModel.fromJson(data);
        debugPrint(services.id.toString());
        if (Get.find<ServiceCartController>()
            .checkServiceInCart(services.id as int)) {
          services.isChecked = true;
        } else {
          services.isChecked = false;
        }
        _servicesList.add(services);
      });
      debugPrint('Service list' + _servicesList.length.toString());

      salonPackages.forEach((data) {
        PackagesModel packages = PackagesModel.fromJson(data);
        _packagesList.add(packages);
      });
      debugPrint(packagesList.length.toString());

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void updateServiceStatusInCart(int index, bool status) {
    debugPrint('service id $index');
    debugPrint('service status $status');
    if (Get.find<ServiceCartController>().savedInCart.services!.isEmpty &&
        Get.find<ServiceCartController>().savedInCart.packages!.isEmpty) {
      _servicesList[index].isChecked = status;
      if (status == true) {
        Get.find<ServiceCartController>()
            .addServiceToCart(_servicesList[index], 'individual');
      } else {
        Get.find<ServiceCartController>()
            .removeServiceFromCart(_servicesList[index].id as int);
      }
    } else if (Get.find<ServiceCartController>()
        .savedInCart
        .packages!
        .isNotEmpty) {
      int freelancerPackagesId =
          Get.find<ServiceCartController>().getPackageFreelancerId();
      if (freelancerPackagesId == _servicesList[index].uid) {
        _servicesList[index].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_servicesList[index], 'individual');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_servicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other Shop/Freelancer'.tr);
      }
    } else {
      int freelancerIdServices =
          Get.find<ServiceCartController>().getServiceFreelancerId();

      if (freelancerIdServices == _servicesList[index].uid) {
        _servicesList[index].isChecked = status;
        if (status == true) {
          Get.find<ServiceCartController>()
              .addServiceToCart(_servicesList[index], 'individual');
        } else {
          Get.find<ServiceCartController>()
              .removeServiceFromCart(_servicesList[index].id as int);
        }
      } else {
        showToast(
            'We already have service or package with other Shop/Freelancer'.tr);
        update();
      }
    }
    Get.find<HomeController>().updateScreen();
    update();
  }

  Future<void> getOwnerReviews() async {
    var response = await parser.getOwnerReviewsList({"id": individualId});
    reviewsCalled = true;
    _ownerReviewsList = [];
    update();
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];

      body.forEach((data) {
        OwnerReviewsModel reviews = OwnerReviewsModel.fromJson(data);
        _ownerReviewsList.add(reviews);
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onServicesView(int id, String name) {
    Get.delete<IndividualListController>(force: true);
    Get.toNamed(AppRouter.getIndividualList(),
        arguments: [id, name, individualDetails.uid]);
  }

  void onPackagesDetails(int id, String name) {
    Get.delete<IndividualPackagesController>(force: true);
    Get.toNamed(AppRouter.getIndividualPackages(), arguments: [id, name]);
  }

  onMapCreated() {
    markers.add(
      Marker(
        markerId: const MarkerId('Id-1'),
        position: LatLng(
            individualDetails.lat as double, individualDetails.lng as double),
      ),
    );
  }

  Future<void> openMap() async {
    double latitude = individualDetails.lat as double;
    double longitude = individualDetails.lng as double;
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    var url = Uri.parse(googleUrl);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> openWebsite() async {
    final website = individualDetails.website;
    if (website != null && website != 'NA' && website.isNotEmpty) {
      String urlString = website;
      // Ensure the URL has a valid scheme
      if (!urlString.startsWith('http://') &&
          !urlString.startsWith('https://')) {
        urlString = 'http://$urlString';
      }
      try {
        final url = Uri.parse(urlString);
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          showToast('Could not launch website'.tr);
        }
      } catch (e) {
        showToast('Invalid website URL'.tr);
      }
    } else {
      showToast('No Website Found'.tr);
    }
  }

  Future<void> callIndividual() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: individualDetails.mobile.toString(),
    );
    await launchUrl(launchUri);
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: Environments.appName,
        linkUrl: individualDetails.website.toString(),
        chooserTitle: 'Share with'.tr);
  }

  void onChat() {
    debugPrint('on chat');
    if (parser.isLogin() == true) {
      Get.delete<ChatController>(force: true);
      Get.toNamed(AppRouter.getChatRoutes(), arguments: [
        individualDetails.uid.toString(),
        '${userInfo.firstName} ${userInfo.lastName}'
      ]);
    } else {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
    }
  }

  void onCheckout() {
    Get.delete<IndividualCheckoutController>(force: true);
    Get.toNamed(AppRouter.getIndividualCheckout());
  }
}
