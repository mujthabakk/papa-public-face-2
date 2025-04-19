import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as LocationGeo;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/address_model.dart';
import 'package:salon_user/app/backend/models/google_address_model.dart';
import 'package:salon_user/app/backend/models/google_places_model.dart';
import 'package:salon_user/app/backend/parse/new_address_parse.dart';
import 'package:salon_user/app/controller/address_controller.dart';
import 'package:salon_user/app/controller/address_list_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/uuid_generator.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class NewAddressController extends GetxController implements GetxService {
  late GoogleMapController mapController;

  final Set<Marker> markers = {};
  final searchbarText = TextEditingController();
  List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
  List<GooglePlacesModel> get getList => _getList;
  final RxDouble myLat = 0.0.obs;
  final RxDouble myLng = 0.0.obs;

  bool isConfirmed = false;
  final NewAddressParser parser;
  int title = 0;
  final addressTextEditor = TextEditingController();
  final houseTextEditor = TextEditingController();
  final landmarkTextEditor = TextEditingController();
  final pincodeTextEditor = TextEditingController();

  int addressId = 0;
  double lat = 0.0;
  double lng = 0.0;
  String action = 'new';

  AddressModel _addressInfo = AddressModel();
  AddressModel get addressInfo => _addressInfo;
  bool apiCalled = false;

  NewAddressController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();

    if (Get.arguments[0] == 'update') {
      action = 'update';
      addressId = Get.arguments[1] as int;
      debugPrint('address id --> $addressId');
      getAddressById();
    } else {
      apiCalled = true;
    }
  }

  void onFilter(int choice) {
    title = choice;
    update();
  }

  void onBack() {
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void getLatLngFromAddress() async {
    if (addressTextEditor.text == '' ||
        addressTextEditor.text.isEmpty ||
        houseTextEditor.text == '' ||
        houseTextEditor.text.isEmpty ||
        landmarkTextEditor.text == '' ||
        landmarkTextEditor.text.isEmpty ||
        pincodeTextEditor.text == '' ||
        pincodeTextEditor.text.isEmpty) {
      showToast('All fields are required'.tr);
      return;
    }

    if (myLat.value == 0.0 || myLng.value == 0.0) {
      showToast('Please select your location on map'.tr);
      return;
    }

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
                "Please wait".tr,
                style: const TextStyle(fontFamily: 'bold'),
              )),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    // var response = await parser.getLatLngFromAddress(
    //     'https://maps.googleapis.com/maps/api/geocode/json?address=${addressTextEditor.text} ${houseTextEditor.text} ${landmarkTextEditor.text}${pincodeTextEditor.text}&key=${Environments.googleMapsKey}');
    // debugPrint(response.bodyString);
    // Get.back();
    // if (response.statusCode == 200) {
    //   Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

    //   GoogleAddresModel address = GoogleAddresModel.fromJson(myMap);
    //   debugPrint(address.toString());
    //   if (address.results!.isNotEmpty) {
    //     debugPrint('ok');
    if (action == 'new') {
      debugPrint('create');
      // lat = markers.first.position.latitude;
      // lng = markers.first.position.longitude;

      lat = myLat.value;
      lng = myLng.value;

      //  lat = address.results![0].geometry!.location!.lat!;
      //  lng = address.results![0].geometry!.location!.lng!;
      saveAddress();
    } else {
      debugPrint('update');
      //  lat = markers.first.position.latitude;
      // lng = markers.first.position.longitude;
      lat = myLat.value;
      lng = myLng.value;

      // lat = address.results![0].geometry!.location!.lat!;
      // lng = address.results![0].geometry!.location!.lng!;
      updateAddress();
    }
    // } else {
    //   showToast("could not determine your location");
    //   update();
    // }
    // } else {
    //   ApiChecker.checkApi(response);
    //   update();
    // }
  }

  Future<void> saveAddress() async {
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
                "Please wait".tr,
                style: const TextStyle(fontFamily: 'bold'),
              )),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var body = {
      "uid": parser.getUId(),
      "title": title,
      "address": addressTextEditor.text,
      "house": houseTextEditor.text,
      "landmark": landmarkTextEditor.text,
      "pincode": pincodeTextEditor.text,
      "lat": lat,
      "lng": lng,
      "status": 1
    };
    var response = await parser.saveAddress(body);
    Get.back();

    if (response.statusCode == 200) {
      Get.find<AddressController>().getSavedAddress();
      Get.find<AddressListController>().getSavedAddress();
      successToast('Successfully Added'.tr);
      onBack();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getAddressById() async {
    var param = {"id": addressId};

    Response response = await parser.getAddressByID(param);
    apiCalled = true;
    if (response.statusCode == 200) {
      _addressInfo = AddressModel();
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      AddressModel datas = AddressModel.fromJson(body);
      _addressInfo = datas;
      addressTextEditor.text = _addressInfo.address.toString();
      houseTextEditor.text = _addressInfo.house.toString();
      landmarkTextEditor.text = _addressInfo.landmark.toString();
      pincodeTextEditor.text = _addressInfo.pincode.toString();
      title = _addressInfo.title as int;
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> updateAddress() async {
    var body = {
      "title": title,
      "address": addressTextEditor.text,
      "house": houseTextEditor.text,
      "landmark": landmarkTextEditor.text,
      "pincode": pincodeTextEditor.text,
      "lat": lat,
      "lng": lng,
      "id": addressId
    };

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
                "Please wait".tr,
                style: const TextStyle(fontFamily: 'bold'),
              )),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );

    var response = await parser.updateAddress(body);
    Get.back();
    if (response.statusCode == 200) {
      Get.find<AddressController>().getSavedAddress();
      Get.find<AddressListController>().getSavedAddress();
      successToast('Successfully Updated'.tr);
      onBack();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void getLocation() async {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              SizedBox(
                child: Text(
                  "Fetching Location".tr,
                  style: const TextStyle(fontFamily: 'bold'),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
    _determinePosition().then((value) async {
      Get.back();
      debugPrint(value.toString());
      List<Placemark> newPlace =
          await placemarkFromCoordinates(value.latitude, value.longitude);
      Placemark placeMark = newPlace[0];
      String address =
          "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
      debugPrint(address);
      // parser.saveLatLng(value.latitude, value.longitude, address);
    }).catchError((error) async {
      Get.back();
      showToast(error.toString());
      await Geolocator.openLocationSettings();
    });
  }

  Future<Position> _determinePosition() async {
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

  void getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
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
    mapController.animateCamera(CameraUpdate.newLatLng(newPosition));

    update(); // Refresh the UI to reflect marker changes
  }

  Future<void> getLatLngFromAddressMap(String address) async {
    List<LocationGeo.Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      myLat.value = locations[0].latitude;
      myLng.value = locations[0].longitude;
      isConfirmed = true;

      var pinPosition = LatLng(myLat.value, myLng.value);
      markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      markers.add(
        Marker(
          markerId: const MarkerId('sourcePin'),
          position: pinPosition,
        ),
      );
      searchbarText.text = address;
      update();
    }
  }
}
