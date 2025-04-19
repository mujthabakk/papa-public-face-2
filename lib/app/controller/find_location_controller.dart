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
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/helper/uuid_generator.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class FindLocationController extends GetxController implements GetxService {
  final FindLocationParser parser;
  late GoogleMapController mapController;

  final Set<Marker> markers = {};
  final searchbarText = TextEditingController();
  List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
  List<GooglePlacesModel> get getList => _getList;

  final RxDouble myLat = 0.0.obs;
  final RxDouble myLng = 0.0.obs;

  bool isConfirmed = false;

  FindLocationController({required this.parser});

  @override
  Future<void> onInit() async {
    super.onInit();
    getCurrentLocation();

    // var pinPosition = LatLng(myLat, myLng);
    // markers.add(Marker(
    //   markerId: const MarkerId('sourcePin'),
    //   position: pinPosition, // updated position
    // ));
  }

  void getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      myLat.value = position.latitude;
      myLng.value = position.longitude;

      var pinPosition = LatLng(myLat.value, myLng.value);
      markers.add(
        Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition,
        ),
      );

      update(); // Update the UI with new marker position
    } catch (e) {
      debugPrint("Error fetching location: $e");
      showToast(e.toString());
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
    // var pinPosition = LatLng(myLat, myLng);
    mapController = controller;

    getCurrentLocation();
    markers.add(
      Marker(
        markerId: MarkerId('Id-1'),
        position: LatLng(myLat.value, myLng.value),
      ),
    );
    update();
  }

  void onSearchChanged(String value) {
    debugPrint(value);
    if (value.isNotEmpty) {
      getPlacesList(value);
    }
  }

  Future<void> getPlacesList(String value) async {
    String googleURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var sessionToken = Uuid().generateV4();
    var googleKey = Environments.googleMapsKey;
    String request =
        '$googleURL?input=$value&key=$googleKey&sessiontoken=$sessionToken&types=locality';

    '$googleURL?input=$value&key=$Environments.googleMapsKey&sessiontoken=$sessionToken';
    Response response = await parser.getPlacesList(request);
    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['predictions'];
      _getList = [];
      body.forEach((data) {
        GooglePlacesModel datas = GooglePlacesModel.fromJson(data);
        _getList.add(datas);
      });
      isConfirmed = false;

      update();
      debugPrint(_getList.length.toString());
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> getLatLngFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    debugPrint(locations.toString());
    if (locations.isNotEmpty) {
      _getList = [];
      searchbarText.text = address;
      myLat.value = locations[0].latitude;
      myLng.value = locations[0].longitude;
      debugPrint('Lat ----' +
          myLat.value.toString() +
          'Lng -----' +
          myLng.value.toString());
      isConfirmed = true;
      var pinPosition = LatLng(myLat.value, myLng.value);
      markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      markers.add(Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition, // updated position
      ));

      update();
    }
  }

  void moveMapToPosition(double lat, double lng) {
    final newPosition = LatLng(lat, lng);

    // Update marker position
    markers.removeWhere((m) => m.markerId.value == 'sourcePin');
    markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: newPosition,
      ),
    );

    // Move the camera to the new position
    mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));

    update(); // Refresh the UI to reflect marker changes
  }

  void onConfirmLocation() {
    getLatLngFromAddress(searchbarText.text);
    parser.saveLatLng(myLat.value, myLng.value, searchbarText.text);
    Get.delete<TabsController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<NearController>(force: true);
    Get.delete<CategoriesController>(force: true);
    Get.delete<BookingController>(force: true);
    Get.delete<AccountController>(force: true);
    Get.offAndToNamed(AppRouter.getTabsBarRoute());
  }
}
