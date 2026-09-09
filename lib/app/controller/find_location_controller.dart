import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/google_places_model.dart';
import 'package:salon_user/app/backend/parse/find_location_parse.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/helper/uuid_generator.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class FindLocationController extends GetxController implements GetxService {
  final FindLocationParser parser;
  GoogleMapController? mapController;
  bool _mapReady = false;
  int mapRevision = 0;

  final Set<Marker> markers = {};
  final searchbarText = TextEditingController();
  List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
  List<GooglePlacesModel> get getList => _getList;

  final RxDouble myLat = 0.0.obs;
  final RxDouble myLng = 0.0.obs;
  int _locationRequestId = 0;
  bool _hasManualSelection = false;
  double mapZoom = 12;

  bool isConfirmed = false;
  String savedAddress = '';

  bool get hasMapPosition => myLat.value != 0.0 || myLng.value != 0.0;

  /// ISO country for Places API (e.g. qa for Qatar).
  String? get _countryIso {
    if (!Get.isRegistered<LanguagesController>()) return null;
    final locale = Get.find<LanguagesController>();
    final code = locale.countryCode.trim().toLowerCase();
    if (code.length == 2) return code;
    final name = locale.countryName.toLowerCase();
    if (name.contains('qatar')) return 'qa';
    if (name.contains('india')) return 'in';
    if (name.contains('uae') || name.contains('emirates')) return 'ae';
    if (name.contains('saudi')) return 'sa';
    return null;
  }

  LatLng? get _preferredCountryCenter {
    switch (_countryIso) {
      case 'qa':
        return const LatLng(25.2854, 51.5310); // Doha
      case 'ae':
        return const LatLng(25.2048, 55.2708); // Dubai
      case 'sa':
        return const LatLng(24.7136, 46.6753); // Riyadh
      case 'in':
        return const LatLng(28.6139, 77.2090); // Delhi
      case 'kw':
        return const LatLng(29.3759, 47.9774);
      case 'bh':
        return const LatLng(26.2235, 50.5876);
      case 'om':
        return const LatLng(23.5880, 58.3829);
      default:
        return null;
    }
  }

  FindLocationController({required this.parser});

  @override
  void onClose() {
    _mapReady = false;
    mapController?.dispose();
    mapController = null;
    super.onClose();
  }

  Future<void> _moveCameraSafely(LatLng target, {double? zoom}) async {
    final controller = mapController;
    if (!_mapReady || controller == null) return;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: zoom ?? mapZoom),
        ),
      );
    } catch (e) {
      debugPrint('Map camera skipped: $e');
    }
  }

  void _setPin(LatLng pin, {bool bumpMap = false}) {
    markers.removeWhere((m) => m.markerId.value == 'sourcePin');
    markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: pin,
      ),
    );
    if (bumpMap) mapRevision++;
  }

  bool _isCorruptSavedAddress(String address) {
    if (address.isEmpty) return false;
    final a = address.toLowerCase();
    // Bad geocode: "Qatar, Ardabil Province, Iran"
    return a.contains('ardabil') ||
        (a.contains('qatar') && a.contains('iran'));
  }

  Future<void> _applyCountryCenterFallback({String? label}) async {
    final center = _preferredCountryCenter;
    if (center == null) return;
    _hasManualSelection = true;
    _locationRequestId++;
    myLat.value = center.latitude;
    myLng.value = center.longitude;
    mapZoom = 11;
    searchbarText.text = label ??
        (Get.isRegistered<LanguagesController>()
            ? Get.find<LanguagesController>().selectedCountryLabel
            : '');
    _setPin(center, bumpMap: true);
    update();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveCameraSafely(center, zoom: mapZoom);
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    searchbarText.clear();
    _getList = [];

    savedAddress = parser.getSavedAddress();
    final savedLat = parser.getSavedLat();
    final savedLng = parser.getSavedLng();

    // Drop corrupt "Qatar in Iran" style saved locations
    if (_isCorruptSavedAddress(savedAddress)) {
      savedAddress = '';
      parser.saveLatLng(0.0, 0.0, '');
      searchbarText.clear();
      getCurrentLocation(updateSearchText: true);
      return;
    }

    if (savedLat != 0.0 && savedLng != 0.0 && savedAddress.isNotEmpty) {
      myLat.value = savedLat;
      myLng.value = savedLng;
      searchbarText.text = savedAddress;
      _setPin(LatLng(savedLat, savedLng));
      update();
    }

    getCurrentLocation(updateSearchText: searchbarText.text.isEmpty);
  }

  void getCurrentLocation({bool updateSearchText = false}) async {
    final int requestId = ++_locationRequestId;
    try {
      Position position = await determinePosition();

      if (requestId != _locationRequestId || _hasManualSelection) {
        return;
      }

      myLat.value = position.latitude;
      myLng.value = position.longitude;
      mapZoom = 15;

      var pinPosition = LatLng(myLat.value, myLng.value);
      _setPin(pinPosition, bumpMap: true);

      if (updateSearchText) {
        try {
          List<Placemark> placemarks =
              await placemarkFromCoordinates(myLat.value, myLng.value);

          if (requestId != _locationRequestId || _hasManualSelection) {
            return;
          }

          if (placemarks.isNotEmpty) {
            Placemark placeMark = placemarks[0];
            String name = placeMark.name.toString();
            String subLocality = placeMark.subLocality.toString();
            String locality = placeMark.locality.toString();
            String administrativeArea = placeMark.administrativeArea.toString();
            String postalCode = placeMark.postalCode.toString();
            String country = placeMark.country.toString();
            String address =
                "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
            searchbarText.text = address;
          }
        } catch (e) {
          debugPrint("Error getting address: $e");
        }
      }

      update();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraSafely(pinPosition, zoom: mapZoom);
      });
    } catch (e) {
      debugPrint("Error fetching location: $e");
      // GPS failed — still show selected country map (e.g. Qatar)
      if (!_hasManualSelection && !hasMapPosition) {
        await _applyCountryCenterFallback();
      } else {
        showToast(e.toString());
      }
    }
  }

  void getLocation() async {
    Get.dialog(
        SimpleDialog(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 30,
                ),
                const CircularProgressIndicator(
                  color: ThemeProvider.appColor,
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                    child: Text(
                  "Fetching Location".tr,
                  style: const TextStyle(fontFamily: 'bold'),
                )),
              ],
            )
          ],
        ),
        barrierDismissible: false);
    determinePosition().then((value) async {
      Get.back();
      debugPrint(value.toString());
      List<Placemark> newPlace =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String name = placeMark.name.toString();
      String subLocality = placeMark.subLocality.toString();
      String locality = placeMark.locality.toString();
      String administrativeArea = placeMark.administrativeArea.toString();
      String postalCode = placeMark.postalCode.toString();
      String country = placeMark.country.toString();
      String address =
          "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
      debugPrint(address);
      parser.saveLatLng(value.latitude, value.longitude, address);

      Get.delete<TabsController>(force: true);
      Get.delete<HomeController>(force: true);
      Get.delete<NearController>(force: true);
      Get.delete<CategoriesController>(force: true);
      Get.delete<BookingController>(force: true);
      Get.delete<AccountController>(force: true);
      Get.offAndToNamed(AppRouter.getTabsBarRoute());
    }).catchError((error) async {
      Get.back();
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.'.tr);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied'.tr);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.'
              .tr);
    }
    return await Geolocator.getCurrentPosition();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _mapReady = true;

    if (myLat.value == 0.0 && myLng.value == 0.0) {
      getCurrentLocation();
    } else {
      final pin = LatLng(myLat.value, myLng.value);
      _setPin(pin);
      _moveCameraSafely(pin, zoom: mapZoom);
    }
    update();
  }

  void onSearchChanged(String value) {
    debugPrint(value);
    if (value.isNotEmpty) {
      getPlacesList(value);
    } else {
      _getList = [];
      update();
    }
  }

  Future<void> getPlacesList(String value) async {
    String googleURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var sessionToken = Uuid().generateV4();
    var googleKey = Environments.googleMapsKey;
    final encoded = Uri.encodeQueryComponent(value);
    // Worldwide search — no country filter (India, Qatar, UAE, etc.)
    final request =
        '$googleURL?input=$encoded&key=$googleKey&sessiontoken=$sessionToken';

    Response response = await parser.getPlacesList(request);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      final status = myMap['status']?.toString() ?? '';
      if (status != 'OK' && status != 'ZERO_RESULTS') {
        debugPrint(
            'Places autocomplete status=$status error=${myMap['error_message']}');
      }
      var body = myMap['predictions'] ?? [];
      _getList = [];
      if (body is List) {
        for (final data in body) {
          if (data is Map) {
            _getList.add(
              GooglePlacesModel.fromJson(Map<String, dynamic>.from(data)),
            );
          }
        }
      }
      isConfirmed = false;
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> selectPlace(GooglePlacesModel place) async {
    final placeId = place.placeId;
    if (placeId != null && placeId.isNotEmpty) {
      await getLatLngFromPlaceId(placeId, fallbackAddress: place.description);
      return;
    }
    await getLatLngFromAddress(place.description.toString());
  }

  Future<void> getLatLngFromPlaceId(String placeId,
      {String? fallbackAddress}) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry,formatted_address&key=${Environments.googleMapsKey}';
    final response = await parser.getPlacesList(url);
    if (response.statusCode == 200) {
      final body = Map<String, dynamic>.from(response.body);
      final result = body['result'];
      if (result is Map) {
        final geometry = result['geometry'];
        final location = geometry is Map ? geometry['location'] : null;
        if (location is Map) {
          final lat = double.tryParse(location['lat'].toString());
          final lng = double.tryParse(location['lng'].toString());
          if (lat != null && lng != null) {
            _hasManualSelection = true;
            _locationRequestId++;
            _getList = [];
            myLat.value = lat;
            myLng.value = lng;
            mapZoom = 13;
            searchbarText.text =
                result['formatted_address']?.toString() ?? fallbackAddress ?? '';
            isConfirmed = true;
            final pin = LatLng(lat, lng);
            _setPin(pin, bumpMap: true);
            update();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _moveCameraSafely(pin, zoom: mapZoom);
            });
            return;
          }
        }
      }
    }
    if (fallbackAddress != null && fallbackAddress.isNotEmpty) {
      await getLatLngFromAddress(fallbackAddress);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    debugPrint(locations.toString());
    if (locations.isNotEmpty) {
      _hasManualSelection = true;
      _locationRequestId++;
      _getList = [];
      searchbarText.text = address;
      myLat.value = locations[0].latitude;
      myLng.value = locations[0].longitude;
      mapZoom = 12;
      isConfirmed = true;
      final pinPosition = LatLng(myLat.value, myLng.value);
      _setPin(pinPosition, bumpMap: true);
      update();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraSafely(pinPosition, zoom: mapZoom);
      });
    }
  }

  void moveMapToPosition(double lat, double lng) async {
    _hasManualSelection = true;
    _locationRequestId++;
    final newPosition = LatLng(lat, lng);
    myLat.value = lat;
    myLng.value = lng;
    mapZoom = 15;

    _setPin(newPosition);
    _moveCameraSafely(newPosition, zoom: mapZoom);

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[0];
        String name = placeMark.name.toString();
        String subLocality = placeMark.subLocality.toString();
        String locality = placeMark.locality.toString();
        String administrativeArea = placeMark.administrativeArea.toString();
        String postalCode = placeMark.postalCode.toString();
        String country = placeMark.country.toString();
        String address =
            "$name,$subLocality,$locality,$administrativeArea,$postalCode,$country";
        searchbarText.text = address;
      }
    } catch (e) {
      debugPrint("Error getting address: $e");
    }

    update();
  }

  void onConfirmLocation() {
    debugPrint(
        '[LOCATION_SAVE] lat=${myLat.value}, lng=${myLng.value}, address=${searchbarText.text}');
    parser.saveLatLng(myLat.value, myLng.value, searchbarText.text);
    Get.delete<TabsController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<NearController>(force: true);
    Get.delete<CategoriesController>(force: true);
    Get.delete<BookingController>(force: true);
    Get.delete<AccountController>(force: true);
    Get.offAndToNamed(AppRouter.getTabsBarRoute());
  }

  void resetSearch() {
    _hasManualSelection = false;
    searchbarText.clear();
    _getList = [];
    savedAddress = parser.getSavedAddress();
    if (_isCorruptSavedAddress(savedAddress)) {
      savedAddress = '';
      parser.saveLatLng(0.0, 0.0, '');
    }
    getCurrentLocation(updateSearchText: true);
  }

  void useSavedLocation() {
    double lat = parser.getSavedLat();
    double lng = parser.getSavedLng();
    String address = parser.getSavedAddress();

    if (_isCorruptSavedAddress(address)) {
      savedAddress = '';
      parser.saveLatLng(0.0, 0.0, '');
      getCurrentLocation(updateSearchText: true);
      return;
    }

    if (lat != 0.0 && lng != 0.0 && address.isNotEmpty) {
      _hasManualSelection = true;
      _locationRequestId++;
      _getList = [];
      myLat.value = lat;
      myLng.value = lng;
      searchbarText.text = address;
      mapZoom = 14;

      final pinPosition = LatLng(lat, lng);
      _setPin(pinPosition, bumpMap: true);

      update();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _moveCameraSafely(pinPosition, zoom: mapZoom);
      });
    }
  }
}
