import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/owner_reviews_model.dart';
import 'package:salon_user/app/backend/models/packages_model.dart';
import 'package:salon_user/app/backend/models/salon_details_model.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/backend/models/specialist_model.dart';
import 'package:salon_user/app/backend/models/timing_model.dart';
import 'package:salon_user/app/backend/parse/services_parse.dart';
import 'package:salon_user/app/controller/chat_controller.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/packages_details_controller.dart';
import 'package:salon_user/app/controller/selected_services_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final ServicesParser parser;
  late TabController tabController;

  int tabID = 1;

  String title = 'Select Service';

  List<String> dayList = [
    'Sunday'.tr,
    'Monday'.tr,
    'Tuesday'.tr,
    'Wednesday'.tr,
    'Thursday'.tr,
    'Friday'.tr,
    'Saturday'.tr
  ];

  List<String> gallery = [];

  SalonDetailsModel _salonDetails = SalonDetailsModel();
  SalonDetailsModel get salonDetails => _salonDetails;

  bool _isPremium = false;
  bool get isPremium => _isPremium;

  List<CategoriesModel> _categoriesList = <CategoriesModel>[];
  List<CategoriesModel> get categoriesList => _categoriesList;

  List<PackagesModel> _packagesList = <PackagesModel>[];

  List<ServicesModel> _servicesList = <ServicesModel>[];

  List<PackagesModel> get packagesList => _packagesList;
  List<ServicesModel> get servicesList => _servicesList;

  List<SpecialistModel> _specialistList = <SpecialistModel>[];
  List<SpecialistModel> get specialistList => _specialistList;

  List<OwnerReviewsModel> _ownerReviewsList = <OwnerReviewsModel>[];
  List<OwnerReviewsModel> get ownerReviewsList => _ownerReviewsList;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;
  String status = 'Closed';
  String selectedService = '';
  String selectedServiceName = '';

  bool apiCalled = false;
  bool reviewsCalled = false;

  int salonId = 0;
  final Set<Marker> markers = {};
  String getDistance = '';
  ServicesController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      debugPrint(tabController.index.toString());
      if (tabController.index == 3) {
        reviewsCalled = false;
        update();
        getOwnerReviews();
      }
    });
    int checkPremium = 0;
    List<dynamic>? arguments = Get.arguments;
    salonId = Get.arguments[0];

    checkPremium =
        (arguments != null && arguments.length > 1 && arguments[1] is int)
            ? arguments[1]
            : 0; // Default value to prevent errors
    if (checkPremium == 1) {
      getPremium2();
    }

    getSalonDetails();
    getPremium();

    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
  }

  String checkSalonStatus(TimingModel? salonDetails) {
    // Get current device date and time
    DateTime now = DateTime.now();
    // Map Dart's weekday (1=Monday, 7=Sunday) to API's day (0=Sunday, 6=Saturday)
    int currentDay = now.weekday % 7; // 5 (Friday) -> 5, 7 (Sunday) -> 0
    String currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    print(
        'DEBUG: Current Day (API format): $currentDay, Current Time: $currentTime');

    // Check if salonDetails is null or has missing fields
    if (salonDetails == null ||
        salonDetails.day == null ||
        salonDetails.openTime == null ||
        salonDetails.closeTime == null) {
      print(
          'DEBUG: SalonDetails is null or has missing fields: ${salonDetails?.toJson()}');
      return "Closed";
    }

    // Check if the provided timing is for the current day
    if (salonDetails.day != currentDay) {
      print(
          'DEBUG: Timing day (${salonDetails.day}) does not match current day ($currentDay)');
      return "Closed";
    }

    // Get opening and closing times
    String openTime = salonDetails.openTime!;
    String closeTime = salonDetails.closeTime!;
    print('DEBUG: Open Time: $openTime, Close Time: $closeTime');

    try {
      // Convert times to minutes for comparison
      int currentMinutes = _timeToMinutes(currentTime);
      int openMinutes = _timeToMinutes(openTime);
      int closeMinutes = _timeToMinutes(closeTime);
      print(
          'DEBUG: Current Minutes: $currentMinutes, Open Minutes: $openMinutes, Close Minutes: $closeMinutes');

      // Handle case where closing time is past midnight
      if (closeMinutes <= openMinutes) {
        print('DEBUG: Adjusting for past midnight');
        closeMinutes += 24 * 60; // Add 24 hours to closing time
        if (currentMinutes < openMinutes && currentMinutes < 12 * 60) {
          currentMinutes += 24 * 60;
          print('DEBUG: Adjusted current minutes to: $currentMinutes');
        }
      }

      // Check if current time falls within opening hours
      if (currentMinutes >= openMinutes && currentMinutes <= closeMinutes) {
        print('DEBUG: Salon is Open');
        return "Open";
      }
      print('DEBUG: Salon is Closed (time comparison failed)');
      return "Closed";
    } catch (e) {
      print('DEBUG: Error in time parsing: $e');
      return "Closed";
    }
  }

// Helper function to convert time string (HH:mm) to minutes since midnight
  int _timeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length != 2) throw FormatException('Invalid time format: $time');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  Future<void> getSalonDetails() async {
    var response = await parser.salonDetails({"id": salonId});
    apiCalled = true;
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      var salonCategories = myMap['categories'];
      var salonPackages = myMap['packages'];
      var salonSpecialist = myMap['specialist'];
      var salonServices = myMap['services'];

      // Parse the timing string into a List<TimingModel>
      List<TimingModel> timings = [];
      if (body['timing'] != null && body['timing'].isNotEmpty) {
        try {
          var timingData = jsonDecode(body['timing']) as List<dynamic>;
          timings = timingData
              .map((e) => TimingModel.fromJson(e as Map<String, dynamic>))
              .toList();
          debugPrint(
              'DEBUG: Parsed timings: ${timings.map((t) => t.toJson()).toList()}');
        } catch (e) {
          debugPrint('DEBUG: Error parsing timings: $e');
        }
      } else {
        debugPrint('DEBUG: Timing data is null or empty in API response');
      }

      // Find the TimingModel for the current day
      DateTime now = DateTime.now();
      int currentDay =
          now.weekday % 7; // 1=Monday, 5=Friday, 7=Sunday -> 0=Sunday, 5=Friday
      TimingModel? currentTiming;
      for (var timing in timings) {
        if (timing.day == currentDay) {
          currentTiming = timing;
          debugPrint(
              'DEBUG: Found timing for day $currentDay: ${currentTiming.toJson()}');
          break;
        }
      }

      // Initialize salonDetails and check status
      _salonDetails = SalonDetailsModel.fromJson(body);
      _salonDetails.timing =
          timings; // Store the parsed timings in salonDetails
      status = checkSalonStatus(currentTiming); // Pass the specific TimingModel
      debugPrint('DEBUG: Salon Status: $status');

      _categoriesList = [];
      _packagesList = [];
      _specialistList = [];
      _servicesList = [];

      if (_salonDetails.images != 'NA' &&
          _salonDetails.images != null &&
          _salonDetails.images != '') {
        var imgs = jsonDecode(_salonDetails.images!);
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

      salonCategories.forEach((data) {
        CategoriesModel categories = CategoriesModel.fromJson(data);
        _categoriesList.add(categories);
      });
      debugPrint('DEBUG: Categories count: ${_categoriesList.length}');

      salonServices.forEach((data) {
        ServicesModel services = ServicesModel.fromJson(data);
        debugPrint('DEBUG: Service ID: ${services.id}');
        if (Get.find<ServiceCartController>()
            .checkServiceInCart(services.id as int)) {
          services.isChecked = true;
        } else {
          services.isChecked = false;
        }
        _servicesList.add(services);
      });
      _servicesList.removeWhere((services) => services.status == 0);
      debugPrint('DEBUG: Service list count: ${_servicesList.length}');

      salonPackages.forEach((data) {
        PackagesModel packages = PackagesModel.fromJson(data);
        _packagesList.add(packages);
      });
      _packagesList.removeWhere((packages) => packages.status == 0);
      debugPrint('DEBUG: Packages count: ${_packagesList.length}');

      salonSpecialist.forEach((data) {
        SpecialistModel specialist = SpecialistModel.fromJson(data);
        _specialistList.add(specialist);
      });
      _specialistList.removeWhere((specialist) => specialist.status == 0);
      debugPrint('DEBUG: Specialist count: ${_specialistList.length}');

      double storeDistance = 0.0;
      double totalMeters = 0.0;
      storeDistance = Geolocator.distanceBetween(
        double.tryParse(_salonDetails.lat.toString()) ?? 0.0,
        double.tryParse(_salonDetails.lng.toString()) ?? 0.0,
        double.tryParse(parser.getLat().toString()) ?? 0.0,
        double.tryParse(parser.getLng().toString()) ?? 0.0,
      );
      totalMeters = totalMeters + storeDistance;
      double distance = double.parse((storeDistance / 1000).toStringAsFixed(2));
      debugPrint('DEBUG: Distance: $distance km');

      getDistance = distance.toString();
      update();
    } else {
      debugPrint('DEBUG: API call failed with status: ${response.statusCode}');
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getOwnerReviews() async {
    var response = await parser.getOwnerReviewsList({"id": salonId});
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

  Future<void> getPremium() async {
    var response = await parser.getPremium({"uid": salonId});

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
    var response = await parser.getPremium({"uid": salonId});

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      print(response.body + "QRresponse");

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
      ApiChecker.checkApi(response);
    }
  }

  onMapCreated() {
    markers.add(
      Marker(
        markerId: const MarkerId('Id-1'),
        position:
            LatLng(salonDetails.lat as double, salonDetails.lng as double),
      ),
    );
  }

  // void onBookAppointment() {
  //   Get.delete<BookAppointmentController>(force: true);
  //   Get.toNamed(AppRouter.getBookAppointmentRoutes());
  // }

  void onServicesView(int id, String name) {
    Get.delete<SelectedServicesController>(force: true);
    Get.toNamed(AppRouter.getSelectedServicesRoutes(),
        arguments: [id, name, salonDetails.uid]);
  }

  void onPackagesDetails(int id, String name) {
    Get.delete<PackagesDetailsController>(force: true);
    Get.toNamed(AppRouter.getPackagesDetailsRoutes(), arguments: [id, name]);
  }

  Future<void> openWebsite() async {
    final website = salonDetails.website;
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

  Future<void> callSalon() async {
    // if (isPremium) {
    //   final Uri launchUri = Uri(
    //     scheme: 'tel',
    //     path: salonDetails.mobile.toString(),
    //   );
    //   await launchUrl(launchUri);
    // } else {
    //   showToast('Feature not available for this business'.tr);
    // }
    showToast('Feature not available right now'.tr);
  }

  Future<void> openMap() async {
    double latitude = salonDetails.lat as double;
    double longitude = salonDetails.lng as double;
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

  Future<void> share() async {
    // String lat = salonDetails.lat.toString();
    //  String lng = salonDetails.lng.toString();
    // await FlutterShare.share(
    //     title: Environments.appName,
    //     text: '${'Checkout this business'.tr} ${salonDetails.name}',
    //     linkUrl: 'https://maps.google.com/?q=$lat,$lng&z=8',
    //     chooserTitle: 'Share with'.tr);

    await Share.share(
      'Checkout PapaBear App\nhttps://play.google.com/store/apps/details?id=com.papabear.userapp',
      subject: Environments.appName,
    );
  }

  void onChat() {
    debugPrint('on chat');
    // if (parser.isLogin() == true) {
    //   Get.delete<ChatController>(force: true);
    //   Get.toNamed(AppRouter.getChatRoutes(), arguments: [
    //     salonDetails.uid.toString(),
    //     salonDetails.name.toString()
    //   ]);
    // } else {
    //   Get.delete<LoginController>(force: true);
    //   Get.toNamed(AppRouter.getLoginRoute());
    // }
    showToast('Feature not available right now'.tr);
  }

  void onCheckout() {
    Get.delete<CheckoutController>(force: true);
    Get.toNamed(AppRouter.getCheckoutRoutes());
  }

  void updateScreen() {
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
            .addServiceToCart(_servicesList[index], 'salon');
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
              .addServiceToCart(_servicesList[index], 'salon');
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
              .addServiceToCart(_servicesList[index], 'salon');
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

  void onBack() {
    Get.find<ServicesController>().updateScreen();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
