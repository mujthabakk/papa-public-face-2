import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/choose_location_parse.dart';
import 'package:salon_user/app/backend/parse/languages_parse.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/helper/geo_lookup.dart';
import 'package:salon_user/app/helper/post_login_nav.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:geolocator/geolocator.dart';

class ChooseLocationController extends GetxController implements GetxService {
  final ChooseLocationParser parser;

  ChooseLocationController({required this.parser});

  void onChooseLocation() {
    Get.toNamed(AppRouter.getFindLocationRoutes());
  }

  Future<void> continueLastLocation() async {
    final lat = parser.getLat();
    final lng = parser.getLng();
    String iso = '';
    String placeCountry = '';
    try {
      if (lat != 0 && lng != 0) {
        final geo = await reverseGeocode(lat, lng);
        iso = geo?.iso ?? '';
        placeCountry = geo?.country ?? '';
      }
    } catch (_) {}
    await _persistLocationPrefs(lat, lng, iso.length == 2 ? iso : null);
    if (iso.length == 2 && Get.isRegistered<LanguagesController>()) {
      await Get.find<LanguagesController>().applyCountryFromLocation(
        iso,
        placeCountryName: placeCountry,
        reloadHome: false,
      );
    }
    await PostLoginNav.finishAfterLocation();
  }

  bool get hasLastLocation {
    final lat = parser.getLat();
    final lng = parser.getLng();
    return lat != 0.0 && lng != 0.0;
  }

  void getLocation() async {
    ////// TEST DATA ////
    // parser.saveLatLng(21.7645, 72.1519, 'Bhavnagar Gujarat India');

    // Get.delete<TabsController>(force: true);
    // Get.delete<HomeController>(force: true);
    // Get.delete<NearController>(force: true);
    // Get.delete<CategoriesController>(force: true);
    // Get.delete<BookingController>(force: true);
    // Get.delete<AccountController>(force: true);
    // Get.offAndToNamed(AppRouter.getTabsBarRoute());

    /// TEST DATA //

    /////// REAL DATA /////
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
    _determinePosition().then((value) async {
      Get.back();
      debugPrint(value.toString());
      final geo = await reverseGeocode(value.latitude, value.longitude);
      final address = (geo?.address.isNotEmpty == true)
          ? geo!.address
          : '${value.latitude}, ${value.longitude}';
      parser.saveLatLng(value.latitude, value.longitude, address);
      final iso = (geo?.iso ?? '').toUpperCase();
      await _persistLocationPrefs(
        value.latitude,
        value.longitude,
        iso.length == 2 ? iso : null,
      );
      if (iso.length == 2 && Get.isRegistered<LanguagesController>()) {
        await Get.find<LanguagesController>().applyCountryFromLocation(
          iso,
          placeCountryName: geo?.country ?? '',
          reloadHome: false,
        );
      }

      await PostLoginNav.finishAfterLocation();
    }).catchError((error) async {
      Get.back();
      final text = error.toString();
      if (!text.toLowerCase().contains('unexpected null')) {
        showToast(text);
      }
      // Check for specific errors to decide which settings to open
      if (error.toString().contains('permanently denied')) {
        await Geolocator.openAppSettings();
      } else if (error.toString().contains('Location services are disabled')) {
        await Geolocator.openLocationSettings();
      }
      // If just "denied", do not open settings automatically
    });

    /////// REAL DATA /////
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _persistLocationPrefs(
    double lat,
    double lng, [
    String? countryIso,
  ]) async {
    if (!Get.isRegistered<LanguagesParser>()) return;
    await Get.find<LanguagesParser>().persistGpsPreference(
      lat: lat,
      lng: lng,
      countryIso: countryIso,
    );
  }

  void saveLanguage(String code) {
    parser.saveLanguage(code);
    update();
  }
}
