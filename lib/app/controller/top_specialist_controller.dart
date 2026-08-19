import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/top_freelancer_model.dart';
import 'package:salon_user/app/backend/parse/top_specialist_parse.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class TopSpecialistController extends GetxController implements GetxService {
  final TopSpecialistParser parser;

  List<TopFreelancerModel> _topFreelancerList = <TopFreelancerModel>[];
  List<TopFreelancerModel> get topFreelancerList => _topFreelancerList;

  String topFreelancerId = '';
  String topFreelancerName = '';

  bool apiCalled = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  TopSpecialistController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    getDataFromCategories();
  }

  Future<void> getDataFromCategories() async {
    var param = {"lat": parser.getLat(), "lng": parser.getLng()};
    Response response = await parser.getTopFreelancer(param);
    apiCalled = true;

    if (ApiBody.isSuccess(response) ||
        ApiBody.asList(response.body).isNotEmpty) {
      _topFreelancerList = [];
      for (final data in ApiBody.asList(response.body)) {
        try {
          if (data is! Map) continue;
          _topFreelancerList.add(
              TopFreelancerModel.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          debugPrint('Skip freelancer: $e');
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onSpecialist(int uid) {
    Get.delete<SpecialistController>(force: true);
    Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
  }
}
