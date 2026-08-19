/*Papabear*/
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/individual_model.dart';
import 'package:salon_user/app/backend/models/salon_model.dart';
import 'package:salon_user/app/backend/parse/near_parse.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';

const double cameraZoom = 16;
const double cameraTilt = 80;
const double cameraBearing = 30;

class NearController extends GetxController implements GetxService {
  final NearParser parser;
  bool apiCalled = false;

  List<SalonModel> _salonList = <SalonModel>[];
  List<SalonModel> get salonList => _salonList;

  List<IndividualModel> _individualList = <IndividualModel>[];
  List<IndividualModel> get individualList => _individualList;

  final Set<Marker> markers = {};
  late CameraPosition initialCameraPosition;
  final Completer<GoogleMapController> googleMapsController = Completer();

  bool haveData = false;

  NearController({required this.parser});

  @override
  void onInit() {
    super.onInit();

    getHomeData();
  }

  Future<void> getHomeData() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    _salonList = [];
    _individualList = [];
    markers.clear();

    Response response = await parser.getHomeData(param);
    final map = ApiBody.asMap(response.body);
    if (map != null) {
      _parseSalons(map['salon'] ?? map['salons']);
      _parseIndividuals(map['individual'] ?? map['individuals']);
      if (_salonList.isEmpty && map['data'] is Map) {
        final nested = Map<String, dynamic>.from(map['data']);
        _parseSalons(nested['salon'] ?? nested['salons']);
        _parseIndividuals(nested['individual'] ?? nested['individuals']);
      }
    }

    if (_salonList.isEmpty) {
      try {
        final top = await parser.getTopSalon(param);
        _parseSalons(ApiBody.asList(top.body));
      } catch (e) {
        debugPrint('near top salon: $e');
      }
    }
    if (_individualList.isEmpty) {
      try {
        final top = await parser.getTopFreelancer(param);
        _parseIndividuals(ApiBody.asList(top.body));
      } catch (e) {
        debugPrint('near top freelancer: $e');
      }
    }

    var destPosition = LatLng(parser.getLat(), parser.getLng());
    initialCameraPosition = CameraPosition(
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
        target: destPosition);

    for (var element in _salonList) {
      final lat = element.salonLat ?? 0;
      final lng = element.salonLng ?? 0;
      if (lat == 0 && lng == 0) continue;
      markers.add(Marker(
        markerId: MarkerId('${element.id}salon'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: element.name,
          snippet: element.address,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    for (var element in _individualList) {
      final lat = element.lat ?? 0;
      final lng = element.lng ?? 0;
      if (lat == 0 && lng == 0) continue;
      markers.add(Marker(
        markerId: MarkerId('${element.uid}freelancer'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title:
              '${element.userInfo?.firstName ?? ''} ${element.userInfo?.lastName ?? ''}'
                  .trim(),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    }

    haveData = salonList.isNotEmpty || individualList.isNotEmpty;
    apiCalled = true;
    update();
  }

  void _parseSalons(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _salonList.add(SalonModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip near salon: $e');
      }
    }
  }

  void _parseIndividuals(dynamic raw) {
    if (raw is! List) return;
    for (final data in raw) {
      try {
        if (data is! Map) continue;
        _individualList
            .add(IndividualModel.fromJson(Map<String, dynamic>.from(data)));
      } catch (e) {
        debugPrint('Skip near freelancer: $e');
      }
    }
  }

  void onFilter() {
    if (!Get.isRegistered<UnifiedSearchController>()) {
      Get.put(UnifiedSearchController(parser: Get.find()));
    }
    Get.toNamed(AppRouter.getFilterRoutes(), arguments: ['']);
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
