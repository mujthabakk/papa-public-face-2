import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/top_salon_model.dart';
import 'package:salon_user/app/backend/parse/top_offers_parse.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/helper/router.dart';

class TopOffersController extends GetxController implements GetxService {
  final TopOffersParser parser;

  List<TopSalonModel> _topSalonList = <TopSalonModel>[];
  List<TopSalonModel> get topSalonList => _topSalonList;

  String topSalonId = '';
  String topSalonName = '';

  bool apiCalled = false;

  TopOffersController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    getTopSalon();
  }

  Future<void> getTopSalon() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getTopSalon(param);
    apiCalled = true;

    if (ApiBody.isSuccess(response) ||
        ApiBody.asList(response.body).isNotEmpty) {
      _topSalonList = [];
      for (final data in ApiBody.asList(response.body)) {
        try {
          if (data is! Map) continue;
          _topSalonList
              .add(TopSalonModel.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          debugPrint('Skip top salon: $e');
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onServices(int uid) {
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
  }
}
