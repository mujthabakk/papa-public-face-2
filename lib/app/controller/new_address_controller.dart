// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart' as LocationGeo;
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salon_user/app/backend/api/handler.dart';
// import 'package:salon_user/app/backend/models/address_model.dart';
// import 'package:salon_user/app/backend/models/google_address_model.dart';
// import 'package:salon_user/app/backend/models/google_places_model.dart';
// import 'package:salon_user/app/backend/parse/new_address_parse.dart';
// import 'package:salon_user/app/controller/address_controller.dart';
// import 'package:salon_user/app/controller/address_list_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/helper/uuid_generator.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:salon_user/app/util/toast.dart';

// class NewAddressController extends GetxController implements GetxService {
//   late GoogleMapController mapController;

//   final Set<Marker> markers = {};
//   final searchbarText = TextEditingController();
//   List<GooglePlacesModel> _getList = <GooglePlacesModel>[];
//   List<GooglePlacesModel> get getList => _getList;
//   final RxDouble myLat = 0.0.obs;
//   final RxDouble myLng = 0.0.obs;

//   bool isConfirmed = false;
//   final NewAddressParser parser;
//   int title = 0;
//   final addressTextEditor = TextEditingController();
//   final houseTextEditor = TextEditingController();
//   final landmarkTextEditor = TextEditingController();
//   final pincodeTextEditor = TextEditingController();

//   int addressId = 0;
//   double lat = 0.0;
//   double lng = 0.0;
//   String action = 'new';

//   AddressModel _addressInfo = AddressModel();
//   AddressModel get addressInfo => _addressInfo;
//   bool apiCalled = false;

//   NewAddressController({required this.parser});

//   @override
//   void onInit() {
//     super.onInit();
//     getCurrentLocation();

//     if (Get.arguments[0] == 'update') {
//       action = 'update';
//       addressId = Get.arguments[1] as int;
//       debugPrint('address id --> $addressId');
//       getAddressById();
//     } else {
//       apiCalled = true;
//     }
//   }

//   void onFilter(int choice) {
//     title = choice;
//     update();
//   }

//   void onBack() {
//     var context = Get.context as BuildContext;
//     Navigator.of(context).pop(true);
//   }

//   void getLatLngFromAddress() async {
//     if (addressTextEditor.text == '' ||
//         addressTextEditor.text.isEmpty ||
//         houseTextEditor.text == '' ||
//         houseTextEditor.text.isEmpty ||
//         landmarkTextEditor.text == '' ||
//         landmarkTextEditor.text.isEmpty ||
//         pincodeTextEditor.text == '' ||
//         pincodeTextEditor.text.isEmpty) {
//       showToast('All fields are required'.tr);
//       return;
//     }

//     if (myLat.value == 0.0 || myLng.value == 0.0) {
//       showToast('Please select your location on map'.tr);
//       return;
//     }

//     Get.dialog(
//       SimpleDialog(
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 30,
//               ),
//               const CircularProgressIndicator(
//                 color: ThemeProvider.appColor,
//               ),
//               const SizedBox(
//                 width: 30,
//               ),
//               SizedBox(
//                   child: Text(
//                 "Please wait".tr,
//                 style: const TextStyle(fontFamily: 'bold'),
//               )),
//             ],
//           )
//         ],
//       ),
//       barrierDismissible: false,
//     );

//     // var response = await parser.getLatLngFromAddress(
//     //     'https://maps.googleapis.com/maps/api/geocode/json?address=${addressTextEditor.text} ${houseTextEditor.text} ${landmarkTextEditor.text}${pincodeTextEditor.text}&key=${Environments.googleMapsKey}');
//     // debugPrint(response.bodyString);
//     // Get.back();
//     // if (response.statusCode == 200) {
//     //   Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

//     //   GoogleAddresModel address = GoogleAddresModel.fromJson(myMap);
//     //   debugPrint(address.toString());
//     //   if (address.results!.isNotEmpty) {
//     //     debugPrint('ok');
//     if (action == 'new') {
//       debugPrint('create');
//       // lat = markers.first.position.latitude;
//       // lng = markers.first.position.longitude;

//       lat = myLat.value;
//       lng = myLng.value;

//       //  lat = address.results![0].geometry!.location!.lat!;
//       //  lng = address.results![0].geometry!.location!.lng!;
//       saveAddress();
//     } else {
//       debugPrint('update');
//       //  lat = markers.first.position.latitude;
//       // lng = markers.first.position.longitude;
//       lat = myLat.value;
//       lng = myLng.value;

//       // lat = address.results![0].geometry!.location!.lat!;
//       // lng = address.results![0].geometry!.location!.lng!;
//       updateAddress();
//     }
//     // } else {
//     //   showToast("could not determine your location");
//     //   update();
//     // }
//     // } else {
//     //   ApiChecker.checkApi(response);
//     //   update();
//     // }
//   }

//   Future<void> saveAddress() async {
//     if (lat == 0.0 || lng == 0.0) {
//       showToast('Please select a location from map');
//       return;
//     }

//     Get.dialog(
//       SimpleDialog(
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 30,
//               ),
//               const CircularProgressIndicator(
//                 color: ThemeProvider.appColor,
//               ),
//               const SizedBox(
//                 width: 30,
//               ),
//               SizedBox(
//                   child: Text(
//                 "Please wait".tr,
//                 style: const TextStyle(fontFamily: 'bold'),
//               )),
//             ],
//           )
//         ],
//       ),
//       barrierDismissible: false,
//     );

//     var body = {
//       "uid": parser.getUId(),
//       "title": title,
//       "address": addressTextEditor.text,
//       "house": houseTextEditor.text,
//       "landmark": landmarkTextEditor.text,
//       "pincode": pincodeTextEditor.text,
//       "lat": lat,
//       "lng": lng,
//       "status": 1
//     };
//     var response = await parser.saveAddress(body);
//     Get.back();

//     if (response.statusCode == 200) {
//       showSuccessDialog();
//     } else {
//       ApiChecker.checkApi(response);
//     }
//     update();
//   }

//   void showSuccessDialog() {
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Success icon
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: ThemeProvider.greenColor.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.check_circle_outline,
//                   size: 64,
//                   color: ThemeProvider.greenColor,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Success title
//               Text(
//                 'Address Saved'.tr,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: ThemeProvider.blackColor,
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // Success message
//               Text(
//                 'Your new address has been successfully saved.'.tr,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: ThemeProvider.greyColor,
//                   height: 1.4,
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Action buttons
//               Column(
//                 children: [
//                   // Book new appointment button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         onBack();
//                         onBack();
//                         onBack();

//                         Get.find<AddressController>().getSavedAddress();
//                         Get.find<AddressListController>().getSavedAddress();
//                       },
//                       icon: const Icon(Icons.schedule, size: 18),
//                       label: Text('Done'.tr),
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: ThemeProvider.whiteColor,
//                         backgroundColor: ThemeProvider.appColor,
//                         minimumSize: const Size.fromHeight(48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 0,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // // Done button
//                   // SizedBox(
//                   //   width: double.infinity,
//                   //   child: TextButton(
//                   //     onPressed: () {
//                   //       Navigator.pop(Get.context!);
//                   //     },
//                   //     style: TextButton.styleFrom(
//                   //       foregroundColor: ThemeProvider.greyColor,
//                   //       minimumSize: const Size.fromHeight(48),
//                   //       shape: RoundedRectangleBorder(
//                   //         borderRadius: BorderRadius.circular(8),
//                   //       ),
//                   //     ),
//                   //     child: Text(
//                   //       'Done'.tr,
//                   //       style: const TextStyle(
//                   //         fontSize: 16,
//                   //         fontWeight: FontWeight.w500,
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       barrierDismissible: false,
//     );
//   }

//   Future<void> getAddressById() async {
//     var param = {"id": addressId};

//     Response response = await parser.getAddressByID(param);
//     apiCalled = true;
//     if (response.statusCode == 200) {
//       _addressInfo = AddressModel();
//       Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
//       var body = myMap['data'];
//       AddressModel datas = AddressModel.fromJson(body);
//       _addressInfo = datas;
//       addressTextEditor.text = _addressInfo.address.toString();
//       houseTextEditor.text = _addressInfo.house.toString();
//       landmarkTextEditor.text = _addressInfo.landmark.toString();
//       pincodeTextEditor.text = _addressInfo.pincode.toString();
//       title = _addressInfo.title as int;
//       update();
//     } else {
//       ApiChecker.checkApi(response);
//     }
//   }

//   Future<void> updateAddress() async {
//     if (lat == 0.0 || lng == 0.0) {
//       showToast('Please select a location from map');
//       return;
//     }
//     var body = {
//       "title": title,
//       "address": addressTextEditor.text,
//       "house": houseTextEditor.text,
//       "landmark": landmarkTextEditor.text,
//       "pincode": pincodeTextEditor.text,
//       "lat": lat,
//       "lng": lng,
//       "id": addressId
//     };

//     Get.dialog(
//       SimpleDialog(
//         children: [
//           Row(
//             children: [
//               const SizedBox(
//                 width: 30,
//               ),
//               const CircularProgressIndicator(
//                 color: ThemeProvider.appColor,
//               ),
//               const SizedBox(
//                 width: 30,
//               ),
//               SizedBox(
//                   child: Text(
//                 "Please wait".tr,
//                 style: const TextStyle(fontFamily: 'bold'),
//               )),
//             ],
//           )
//         ],
//       ),
//       barrierDismissible: false,
//     );

//     var response = await parser.updateAddress(body);
//     Get.back();
//     if (response.statusCode == 200) {
//       successToast('Address Updated Successfully'.tr);
//       onBack();
//       Get.find<AddressController>().getSavedAddress();
//       Get.find<AddressListController>().getSavedAddress();
//     } else {
//       ApiChecker.checkApi(response);
//     }
//     update();
//   }

//   void getLocation() async {
//     Get.dialog(
//       SimpleDialog(
//         children: [
//           Row(
//             children: [
//               const SizedBox(width: 30),
//               const CircularProgressIndicator(color: ThemeProvider.appColor),
//               const SizedBox(width: 30),
//               SizedBox(
//                 child: Text(
//                   "Fetching Location".tr,
//                   style: const TextStyle(fontFamily: 'bold'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//     _determinePosition().then((value) async {
//       Get.back();
//       debugPrint(value.toString());
//       List<Placemark> newPlace =
//           await placemarkFromCoordinates(value.latitude, value.longitude);
//       Placemark placeMark = newPlace[0];
//       String address =
//           "${placeMark.name}, ${placeMark.subLocality}, ${placeMark.locality}, ${placeMark.administrativeArea}, ${placeMark.postalCode}, ${placeMark.country}";
//       debugPrint(address);
//       // parser.saveLatLng(value.latitude, value.longitude, address);
//     }).catchError((error) async {
//       Get.back();
//       showToast(error.toString());
//       await Geolocator.openLocationSettings();
//     });
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.'.tr);
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied'.tr);
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.'
//               .tr);
//     }

//     return await Geolocator.getCurrentPosition();
//   }

//   void onMapCreated(GoogleMapController controller) {
//     // var pinPosition = LatLng(myLat, myLng);
//     mapController = controller;

//     getCurrentLocation();
//     markers.add(
//       Marker(
//         markerId: MarkerId('Id-1'),
//         position: LatLng(myLat.value, myLng.value),
//       ),
//     );
//     update();
//   }

//   void onSearchChanged(String value) {
//     if (value.isNotEmpty) {
//       getPlacesList(value);
//     }
//   }

//   Future<void> getPlacesList(String value) async {
//     String googleURL =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//     var sessionToken = Uuid().generateV4();
//     var googleKey = Environments.googleMapsKey;
//     String request =
//         '$googleURL?input=$value&key=$googleKey&sessiontoken=$sessionToken&types=locality';

//     Response response = await parser.getPlacesList(request);
//     if (response.statusCode == 200) {
//       Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
//       var body = myMap['predictions'];
//       _getList = [];
//       body.forEach((data) {
//         GooglePlacesModel datas = GooglePlacesModel.fromJson(data);
//         _getList.add(datas);
//       });
//       isConfirmed = false;
//       update();
//       debugPrint(_getList.length.toString());
//     } else {
//       ApiChecker.checkApi(response);
//     }
//   }

//   void getCurrentLocation() async {
//     try {
//       Position position = await _determinePosition();
//       myLat.value = position.latitude;
//       myLng.value = position.longitude;

//       var pinPosition = LatLng(myLat.value, myLng.value);
//       markers.add(
//         Marker(
//           markerId: const MarkerId('sourcePin'),
//           position: pinPosition,
//         ),
//       );

//       update(); // Update the UI with new marker position
//     } catch (e) {
//       debugPrint("Error fetching location: $e");
//       showToast(e.toString());
//     }
//   }

//   void moveMapToPosition(double lat, double lng) {
//     final newPosition = LatLng(lat, lng);

//     // Update marker position
//     markers.removeWhere((m) => m.markerId.value == 'sourcePin');
//     markers.add(
//       Marker(
//         markerId: const MarkerId('sourcePin'),
//         position: newPosition,
//       ),
//     );

//     // Move the camera to the new position
//     mapController.animateCamera(CameraUpdate.newLatLng(newPosition));

//     update(); // Refresh the UI to reflect marker changes
//   }

//   Future<void> getLatLngFromAddressMap(String address) async {
//     List<LocationGeo.Location> locations = await locationFromAddress(address);
//     if (locations.isNotEmpty) {
//       myLat.value = locations[0].latitude;
//       myLng.value = locations[0].longitude;
//       isConfirmed = true;

//       var pinPosition = LatLng(myLat.value, myLng.value);
//       markers.removeWhere((m) => m.markerId.value == 'sourcePin');
//       markers.add(
//         Marker(
//           markerId: const MarkerId('sourcePin'),
//           position: pinPosition,
//         ),
//       );
//       searchbarText.text = address;
//       update();
//     }
//   }
// }
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
  final RxBool isMapReady = false.obs;

  bool isConfirmed = false;
  final NewAddressParser parser;
  int title = 0;
  final addressTextEditor = TextEditingController();
  final houseTextEditor = TextEditingController();
  final landmarkTextEditor = TextEditingController();
  final pincodeTextEditor = TextEditingController();

  int addressId = 0;
  String action = 'new';

  AddressModel _addressInfo = AddressModel();
  AddressModel get addressInfo => _addressInfo;
  bool apiCalled = false;

  NewAddressController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() async {
    try {
      // Check if this is an update action
      if (Get.arguments != null && Get.arguments.length > 0) {
        if (Get.arguments[0] == 'update') {
          action = 'update';
          addressId = Get.arguments[1] as int;
          debugPrint('address id --> $addressId');
          await getAddressById();
        } else {
          // For new address, get current location
          await getCurrentLocation();
          apiCalled = true;
        }
      } else {
        // For new address, get current location
        await getCurrentLocation();
        apiCalled = true;
      }
    } catch (e) {
      debugPrint('Error initializing controller: $e');
      apiCalled = true;
      showToast('Error initializing: ${e.toString()}');

      // Set default location if there's an error
      myLat.value = 37.7749; // Default coordinates
      myLng.value = -122.4194;
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
    // Validate form fields
    if (!_validateForm()) {
      return;
    }

    // Check if location is selected
    if (myLat.value == 0.0 || myLng.value == 0.0) {
      showToast('Please select your location on map'.tr);
      return;
    }

    _showLoadingDialog('Please wait'.tr);

    try {
      if (action == 'new') {
        await saveAddress();
      } else {
        await updateAddress();
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      showToast('Error: ${e.toString()}');
    }
  }

  bool _validateForm() {
    if (addressTextEditor.text.trim().isEmpty) {
      showToast('Address is required'.tr);
      return false;
    }
    if (houseTextEditor.text.trim().isEmpty) {
      showToast('House/Flat number is required'.tr);
      return false;
    }
    if (pincodeTextEditor.text.trim().isEmpty) {
      showToast('Pincode is required'.tr);
      return false;
    }
    return true;
  }

  void _showLoadingDialog(String message) {
    Get.dialog(
      SimpleDialog(
        children: [
          Row(
            children: [
              const SizedBox(width: 30),
              const CircularProgressIndicator(color: ThemeProvider.appColor),
              const SizedBox(width: 30),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontFamily: 'bold'),
                ),
              ),
            ],
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> saveAddress() async {
    if (myLat.value == 0.0 || myLng.value == 0.0) {
      Get.back(); // Close loading dialog
      showToast('Please select a location from map');
      return;
    }

    var body = {
      "uid": parser.getUId(),
      "title": title,
      "address": addressTextEditor.text.trim(),
      "house": houseTextEditor.text.trim(),
      "landmark": landmarkTextEditor.text.trim(),
      "pincode": pincodeTextEditor.text.trim(),
      "lat": myLat.value,
      "lng": myLng.value,
      "status": 1
    };

    try {
      var response = await parser.saveAddress(body);
      Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        showSuccessDialog();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      showToast('Error saving address: ${e.toString()}');
    }
    update();
  }

  void showSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeProvider.greenColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: ThemeProvider.greenColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Address Saved'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeProvider.blackColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your new address has been successfully saved.'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeProvider.greyColor,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back(); // Close dialog
                    onBack(); // Go back to previous screen

                    // Refresh address lists if controllers exist
                    try {
                      Get.find<AddressController>().getSavedAddress();
                    } catch (e) {
                      debugPrint('AddressController not found');
                    }
                    try {
                      Get.find<AddressListController>().getSavedAddress();
                    } catch (e) {
                      debugPrint('AddressListController not found');
                    }
                  },
                  icon: const Icon(Icons.check, size: 18),
                  label: Text('Done'.tr),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ThemeProvider.whiteColor,
                    backgroundColor: ThemeProvider.appColor,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> getAddressById() async {
    try {
      var param = {"id": addressId};
      Response response = await parser.getAddressByID(param);
      apiCalled = true;

      if (response.statusCode == 200) {
        _addressInfo = AddressModel();
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        var body = myMap['data'];
        AddressModel datas = AddressModel.fromJson(body);
        _addressInfo = datas;

        // Populate form fields
        addressTextEditor.text = _addressInfo.address?.toString() ?? '';
        houseTextEditor.text = _addressInfo.house?.toString() ?? '';
        landmarkTextEditor.text = _addressInfo.landmark?.toString() ?? '';
        pincodeTextEditor.text = _addressInfo.pincode?.toString() ?? '';
        title = _addressInfo.title as int? ?? 0;

        // Set location if available - with proper type conversion
        if (_addressInfo.lat != null && _addressInfo.lng != null) {
          // Convert to double safely
          double lat = _parseToDouble(_addressInfo.lat);
          double lng = _parseToDouble(_addressInfo.lng);

          if (lat != 0.0 && lng != 0.0) {
            myLat.value = lat;
            myLng.value = lng;
            _updateMapLocation(lat, lng);
          } else {
            // If coordinates are invalid, get current location as fallback
            await getCurrentLocation();
          }
        } else {
          // If no coordinates available, get current location
          await getCurrentLocation();
        }

        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      apiCalled = true;
      showToast('Error loading address');
      debugPrint('Error loading address: ${e.toString()}');

      // Fallback to current location if loading address fails
      try {
        await getCurrentLocation();
      } catch (locationError) {
        debugPrint('Error getting current location: $locationError');
        // Set default location
        myLat.value = 37.7749;
        myLng.value = -122.4194;
      }

      update();
    }
  }

  // Helper method to safely convert dynamic values to double
  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        debugPrint('Error parsing string to double: $value');
        return 0.0;
      }
    }

    return 0.0;
  }

  Future<void> updateAddress() async {
    if (myLat.value == 0.0 || myLng.value == 0.0) {
      Get.back(); // Close loading dialog
      showToast('Please select a location from map');
      return;
    }

    var body = {
      "title": title,
      "address": addressTextEditor.text.trim(),
      "house": houseTextEditor.text.trim(),
      "landmark": landmarkTextEditor.text.trim(),
      "pincode": pincodeTextEditor.text.trim(),
      "lat": myLat.value,
      "lng": myLng.value,
      "id": addressId
    };

    try {
      var response = await parser.updateAddress(body);
      Get.back(); // Close loading dialog

      if (response.statusCode == 200) {
        successToast('Address Updated Successfully'.tr);

        // Refresh address lists if controllers exist
        try {
          Get.find<AddressController>().getSavedAddress();
        } catch (e) {
          debugPrint('AddressController not found');
        }
        try {
          Get.find<AddressListController>().getSavedAddress();
        } catch (e) {
          debugPrint('AddressListController not found');
        }

        // Go back to previous screen
        onBack();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      Get.back(); // Close loading dialog
      showToast('Error updating address: ${e.toString()}');
    }
    update();
  }

  void getLocation() async {
    _showLoadingDialog("Fetching Location".tr);

    try {
      Position position = await _determinePosition();
      Get.back(); // Close loading dialog

      myLat.value = position.latitude;
      myLng.value = position.longitude;

      // Update map location
      _updateMapLocation(position.latitude, position.longitude);

      // Get address from coordinates
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark placeMark = placemarks[0];
          String address = _formatPlacemarkAddress(placeMark);
          debugPrint('Current address: $address');

          // // Optionally auto-fill address field
          // if (addressTextEditor.text.trim().isEmpty) {
          //   addressTextEditor.text = address;
          // }
        }
      } catch (e) {
        debugPrint('Error getting address from coordinates: $e');
      }

      update();
    } catch (error) {
      Get.back(); // Close loading dialog
      showToast(error.toString());

      // Try to open location settings
      try {
        await Geolocator.openLocationSettings();
      } catch (e) {
        debugPrint('Could not open location settings: $e');
      }
    }
  }

  String _formatPlacemarkAddress(Placemark placeMark) {
    List<String> addressParts = [];

    if (placeMark.name?.isNotEmpty == true) addressParts.add(placeMark.name!);
    if (placeMark.subLocality?.isNotEmpty == true)
      addressParts.add(placeMark.subLocality!);
    if (placeMark.locality?.isNotEmpty == true)
      addressParts.add(placeMark.locality!);
    if (placeMark.administrativeArea?.isNotEmpty == true)
      addressParts.add(placeMark.administrativeArea!);
    if (placeMark.postalCode?.isNotEmpty == true)
      addressParts.add(placeMark.postalCode!);
    if (placeMark.country?.isNotEmpty == true)
      addressParts.add(placeMark.country!);

    return addressParts.join(', ');
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

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapReady.value = true;

    // Set initial location if available
    if (myLat.value != 0.0 && myLng.value != 0.0) {
      _updateMapLocation(myLat.value, myLng.value);
    }

    update();
  }

  void onSearchChanged(String value) {
    if (value.trim().isNotEmpty) {
      getPlacesList(value.trim());
    } else {
      _getList.clear();
      update();
    }
  }

  Future<void> getPlacesList(String value) async {
    try {
      String googleURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      var sessionToken = Uuid().generateV4();
      var googleKey = Environments.googleMapsKey;
      String request =
          '$googleURL?input=$value&key=$googleKey&sessiontoken=$sessionToken&types=address';

      Response response = await parser.getPlacesList(request);

      if (response.statusCode == 200) {
        Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
        var body = myMap['predictions'];
        _getList = [];

        if (body != null) {
          for (var data in body) {
            GooglePlacesModel datas = GooglePlacesModel.fromJson(data);
            _getList.add(datas);
          }
        }

        isConfirmed = false;
        update();
        debugPrint('Places found: ${_getList.length}');
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('Error getting places list: $e');
      showToast('Error searching locations: ${e.toString()}');
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      myLat.value = position.latitude;
      myLng.value = position.longitude;

      _updateMapLocation(position.latitude, position.longitude);

      debugPrint(
          'Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      debugPrint("Error fetching location: $e");
      // Set default location (you can change this to your preferred default)
      myLat.value = 37.7749; // San Francisco default
      myLng.value = -122.4194;
      showToast(
          'Could not get current location. Please select manually on map.');
    }
  }

  void _updateMapLocation(double latitude, double longitude) {
    final newPosition = LatLng(latitude, longitude);

    // Clear existing markers
    markers.clear();

    // Add new marker
    markers.add(
      Marker(
        markerId: const MarkerId('selectedLocation'),
        position: newPosition,
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet:
              'Lat: ${latitude.toStringAsFixed(6)}, Lng: ${longitude.toStringAsFixed(6)}',
        ),
      ),
    );

    // Move camera to new position if map is ready
    if (isMapReady.value && mapController != null) {
      try {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 16.0),
        );
      } catch (e) {
        debugPrint('Error moving camera: $e');
      }
    }

    update();
  }

  // This method is called when user taps on the map
  void onMapTap(LatLng position) {
    myLat.value = position.latitude;
    myLng.value = position.longitude;

    _updateMapLocation(position.latitude, position.longitude);

    // Clear search results when user taps on map
    _getList.clear();
    searchbarText.clear();

    debugPrint('Map tapped at: ${position.latitude}, ${position.longitude}');

    // Optionally get address for tapped location
    _getAddressFromCoordinates(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark placeMark = placemarks[0];
        String address = _formatPlacemarkAddress(placeMark);

        // Update search bar with found address
        searchbarText.text = address;

        debugPrint('Address for tapped location: $address');
      }
    } catch (e) {
      debugPrint('Error getting address from coordinates: $e');
    }
  }

  Future<void> getLatLngFromAddressMap(String address) async {
    try {
      List<LocationGeo.Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        myLat.value = locations[0].latitude;
        myLng.value = locations[0].longitude;
        isConfirmed = true;

        _updateMapLocation(locations[0].latitude, locations[0].longitude);

        searchbarText.text = address;

        // Clear search results
        _getList.clear();

        update();

        debugPrint(
            'Location found for address: ${locations[0].latitude}, ${locations[0].longitude}');
      } else {
        showToast('Could not find location for this address');
      }
    } catch (e) {
      debugPrint('Error getting location from address: $e');
      showToast('Error finding location: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    // Clean up controllers
    searchbarText.dispose();
    addressTextEditor.dispose();
    houseTextEditor.dispose();
    landmarkTextEditor.dispose();
    pincodeTextEditor.dispose();
    super.onClose();
  }
}
