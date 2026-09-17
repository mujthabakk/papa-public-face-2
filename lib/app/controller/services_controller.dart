import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/categories_model.dart';
import 'package:salon_user/app/backend/models/owner_reviews_model.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
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
import 'package:salon_user/app/util/open_hours.dart';
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
  int catalogTab = 0;

  void setCatalogTab(int index) {
    if (catalogTab == index) return;
    catalogTab = index;
    update();
  }

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
  List<int> offerServiceIds = [];
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
    salonId = int.tryParse('${Get.arguments[0]}') ?? 0;
    if (arguments != null && arguments.length > 2) {
      offerServiceIds = parseIdList(arguments[2]);
    }

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
      if (body is! Map) {
        update();
        return;
      }
      final salonMap = Map<String, dynamic>.from(body);
      for (final key in ['facilities', 'features', 'amenities', 'key_features']) {
        if (salonMap[key] == null && myMap[key] != null) {
          salonMap[key] = myMap[key];
        }
      }
      var salonCategories = myMap['categories'];
      var salonPackages = myMap['packages'];
      var salonSpecialist = myMap['specialist'];
      var salonServices = myMap['services'];

      // Parse the timing string into a List<TimingModel>
      List<TimingModel> timings = [];
      final rawTiming = salonMap['timing'];
      if (rawTiming != null && rawTiming.toString().isNotEmpty) {
        try {
          var timingData = rawTiming is List
              ? rawTiming
              : jsonDecode(rawTiming.toString()) as List<dynamic>;
          timings = timingData
              .whereType<Map>()
              .map((e) => TimingModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        } catch (e) {
          debugPrint('DEBUG: Error parsing timings: $e');
        }
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
      _salonDetails = SalonDetailsModel.fromJson(salonMap);
      _salonDetails.timing = timings;
      status = OpenHours.isOpen(timings) ? 'Open' : 'Closed';
      debugPrint('DEBUG: Salon Status: $status');

      _categoriesList = [];
      _packagesList = [];
      _specialistList = [];
      _servicesList = [];

      gallery = [];
      if (_salonDetails.images != 'NA' &&
          _salonDetails.images != null &&
          _salonDetails.images != '') {
        try {
          final imgs = jsonDecode(_salonDetails.images!);
          if (imgs is List) {
            for (final element in imgs) {
              final path = element?.toString() ?? '';
              if (path.isNotEmpty && path != 'NA') gallery.add(path);
            }
          }
        } catch (e) {
          debugPrint('Skip gallery parse: $e');
        }
      }

      if (salonCategories is List) {
        for (final data in salonCategories) {
          try {
            if (data is! Map) continue;
            _categoriesList.add(
                CategoriesModel.fromJson(Map<String, dynamic>.from(data)));
          } catch (e) {
            debugPrint('Skip category parse: $e');
          }
        }
      }

      if (salonServices is List) {
        for (final data in salonServices) {
          try {
            if (data is! Map) continue;
            ServicesModel services =
                ServicesModel.fromJson(Map<String, dynamic>.from(data));
            if ((services.id ?? 0) <= 0) continue;
            if (Get.find<ServiceCartController>()
                .checkServiceInCart(services.id as int)) {
              services.isChecked = true;
            } else {
              services.isChecked = false;
            }
            _servicesList.add(services);
          } catch (e) {
            debugPrint('Skip service parse: $e');
          }
        }
      }
      _servicesList.removeWhere((service) =>
          service.status == 0 &&
          !offerServiceIds.contains(service.id) &&
          !offerServiceIds.contains(service.serviceId));
      _dedupeDuplicateServices();
      _applyOfferPricing();
      _applyOfferServiceSelection();

      if (salonPackages is List) {
        for (final data in salonPackages) {
          try {
            if (data is! Map) continue;
            _packagesList.add(
                PackagesModel.fromJson(Map<String, dynamic>.from(data)));
          } catch (e) {
            debugPrint('Skip package parse: $e');
          }
        }
      }
      _packagesList.removeWhere((packages) => packages.status == 0);

      if (salonSpecialist is List) {
        for (final data in salonSpecialist) {
          try {
            if (data is! Map) continue;
            _specialistList.add(
                SpecialistModel.fromJson(Map<String, dynamic>.from(data)));
          } catch (e) {
            debugPrint('Skip specialist parse: $e');
          }
        }
      }
      _specialistList.removeWhere((specialist) => specialist.status == 0);

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
      _resolveFacilityNames();
    } else {
      debugPrint('DEBUG: API call failed with status: ${response.statusCode}');
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> _resolveFacilityNames() async {
    final ids = _salonDetails.facilityIds;
    if (ids.isEmpty) return;
    try {
      final response = await parser.getFacilities();
      final namesById = <String, String>{};
      for (final item in ApiBody.asList(response.body,
          keys: const ['data', 'facilities', 'items', 'list', 'result'])) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final id = map['id']?.toString() ?? '';
        final name =
            (map['name'] ?? map['title'] ?? map['label'] ?? '').toString().trim();
        if (id.isEmpty || name.isEmpty || name == 'NA') continue;
        namesById[id] = name;
      }
      var added = false;
      for (final id in ids) {
        final name = namesById[id];
        if (name == null || name.isEmpty) continue;
        if (!_salonDetails.facilities.contains(name)) {
          _salonDetails.facilities.add(name);
          added = true;
        }
      }
      if (added) update();
    } catch (e) {
      debugPrint('Skip facility names: $e');
    }
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

  Future<void> openExternalUrl(String? raw, {String? missingMessage}) async {
    if (!_validUrl(raw)) {
      showToast(missingMessage ?? 'Link not available'.tr);
      return;
    }
    var urlString = raw!.trim();
    if (!urlString.startsWith('http://') && !urlString.startsWith('https://')) {
      urlString = 'https://$urlString';
    }
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        showToast('Could not open link'.tr);
      }
    } catch (_) {
      showToast('Invalid link'.tr);
    }
  }

  bool _validUrl(String? value) =>
      value != null && value.isNotEmpty && value != 'NA';

  Future<void> openWebsite() async {
    final website =
        salonDetails.contactLinks.website ?? salonDetails.website;
    await openExternalUrl(website, missingMessage: 'No Website Found'.tr);
  }

  Future<void> openInstagram() async {
    await openExternalUrl(
      salonDetails.contactLinks.instagram,
      missingMessage: 'Instagram link not available'.tr,
    );
  }

  Future<void> openYoutube() async {
    await openExternalUrl(
      salonDetails.contactLinks.youtube,
      missingMessage: 'YouTube link not available'.tr,
    );
  }

  Future<void> openFacebook() async {
    await openExternalUrl(
      salonDetails.contactLinks.facebook,
      missingMessage: 'Facebook link not available'.tr,
    );
  }

  Future<void> openWhatsapp() async {
    final raw = salonDetails.contactLinks.whatsapp;
    if (raw == null || raw.isEmpty || raw == 'NA') {
      showToast('WhatsApp not available'.tr);
      return;
    }
    if (raw.contains('http') || raw.contains('wa.me')) {
      await openExternalUrl(raw);
      return;
    }
    final digits = raw.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      showToast('WhatsApp not available'.tr);
    }
  }

  Future<void> openTwitter() async {
    await openExternalUrl(
      salonDetails.contactLinks.twitter,
      missingMessage: 'Twitter link not available'.tr,
    );
  }

  Future<void> openLinkedin() async {
    await openExternalUrl(
      salonDetails.contactLinks.linkedin,
      missingMessage: 'LinkedIn link not available'.tr,
    );
  }

  Future<void> callSalon() async {
    if (parser.isLogin() != true) {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
      return;
    }
    if (!salonDetails.contactLinks.callEnabled) {
      showToast('Call not available for this shop'.tr);
      return;
    }
    final mobile =
        salonDetails.contactLinks.phone ?? salonDetails.mobile?.toString();
    if (mobile == null || mobile.isEmpty || mobile == 'NA') {
      showToast('Phone number not available'.tr);
      return;
    }
    final uri = Uri(scheme: 'tel', path: mobile);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showToast('Could not start call'.tr);
    }
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
    if (!salonDetails.contactLinks.chatEnabled) {
      showToast('Chat not available for this shop'.tr);
      return;
    }
    if (parser.isLogin() != true) {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
      return;
    }
    Get.delete<ChatController>(force: true);
    Get.toNamed(AppRouter.getChatRoutes(), arguments: [
      salonDetails.uid.toString(),
      salonDetails.name.toString(),
    ]);
  }

  void onCheckout() {
    Get.delete<CheckoutController>(force: true);
    Get.toNamed(AppRouter.getCheckoutRoutes());
  }

  void updateScreen() {
    update();
  }

  bool _isOfferService(ServicesModel service) {
    if (offerServiceIds.isEmpty) return false;
    if (offerServiceIds.contains(service.id)) return true;
    final hasListing = _servicesList.any((s) => offerServiceIds.contains(s.id));
    if (hasListing) return false;
    return offerServiceIds.contains(service.serviceId);
  }

  void _dedupeDuplicateServices() {
    final preferred = <ServicesModel>[];
    final rest = <ServicesModel>[];
    for (final service in _servicesList) {
      if (offerServiceIds.contains(service.id)) {
        preferred.add(service);
      } else {
        rest.add(service);
      }
    }
    final seen = <String>{};
    final out = <ServicesModel>[];
    for (final service in [...preferred, ...rest]) {
      final key =
          '${service.serviceId ?? 0}|${(service.name ?? '').trim().toLowerCase()}|${service.price}|${service.duration}';
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(service);
    }
    _servicesList = out;
  }

  void _applyOfferPricing() {
    if (offerServiceIds.isEmpty) return;
    if (!Get.isRegistered<ServiceCartController>()) return;
    final coupon = Get.find<ServiceCartController>().selectedCoupon;
    if ((coupon.type ?? 1) != 1 || (coupon.discount ?? 0) <= 0) return;
    for (final service in _servicesList) {
      if (!_isOfferService(service)) continue;
      final price = service.price ?? 0;
      final currentOff = service.off ?? 0;
      if (currentOff > 0 && currentOff < price) continue;
      service.discount = coupon.discount;
      service.off =
          price * (1 - ((coupon.discount ?? 0) / 100));
    }
  }

  void _applyOfferServiceSelection() {
    if (offerServiceIds.isEmpty) return;
    final cart = Get.find<ServiceCartController>();
    final hasItems = cart.savedInCart.services!.isNotEmpty ||
        cart.savedInCart.packages!.isNotEmpty;
    if (hasItems) {
      final currentId = cart.savedInCart.services!.isNotEmpty
          ? cart.getServiceFreelancerId()
          : cart.getPackageFreelancerId();
      if (currentId != salonId) {
        cart.clearCart();
      }
    }
    final visibleIds = _servicesList.map((s) => s.id).toSet();
    for (final item in List<ServicesModel>.from(cart.savedInCart.services ?? [])) {
      if (!visibleIds.contains(item.id)) {
        cart.removeServiceFromCart(item.id as int);
      }
    }
    int? pick;
    for (var i = 0; i < _servicesList.length; i++) {
      if (_isOfferService(_servicesList[i])) {
        pick = i;
        break;
      }
    }
    if (pick == null) return;
    for (var i = 0; i < _servicesList.length; i++) {
      final checked = _servicesList[i].isChecked == true;
      if (i == pick) {
        if (!checked) updateServiceStatusInCart(i, true);
      } else if (checked && _isOfferService(_servicesList[i])) {
        updateServiceStatusInCart(i, false);
      }
    }
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
