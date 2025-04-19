import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/parse/coupon_parse.dart';
import 'package:salon_user/app/controller/individual_payment_controller.dart';
import 'package:salon_user/app/controller/payment_controller.dart';
import 'package:salon_user/app/controller/product_payment_controller.dart';
import 'package:intl/intl.dart';

class CouponController extends GetxController implements GetxService {
  final CouponParser parser;

  String selectedCouponCode = '';
  bool apiCalled = false;
  String action = 'service';

  List<CouponsModel> _couponList = <CouponsModel>[];
  List<CouponsModel> get couponList => _couponList;
  CouponController({required this.parser});

  String uid = '';

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments[0] == 'product') {
      action = 'product';
    } else if (Get.arguments[0] == 'individual-service') {
      action = 'individual-service';
    } else {
      action = 'service';
    }
    uid = Get.arguments[3];
    getCoupons();
  }

  Future<void> getCoupons() async {
    Response response = await parser.getCouponCodes();
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _couponList = [];

      // Get the current device date without time (only YYYY-MM-DD)
      DateTime currentDate = DateTime.now();
      currentDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      body.forEach((element) {
        CouponsModel data = CouponsModel.fromJson(element);

        // Check if the coupon has a valid expiry date
        if (data.expire != null && data.expire!.isNotEmpty) {
          try {
            DateTime expiryDate = DateFormat("yyyy-MM-dd").parse(data.expire!);

            // Ensure expiry date is also compared without time
            expiryDate =
                DateTime(expiryDate.year, expiryDate.month, expiryDate.day);

            // Include coupons that are not expired or expire on the current day
            if ((expiryDate.isAfter(currentDate) ||
                    expiryDate.isAtSameMomentAs(currentDate)) &&
                data.freelancerIds != null &&
                data.freelancerIds!.split(',').contains(uid.toString())) {
              _couponList.add(data);
            }
          } catch (e) {
            print("Error parsing date: ${data.expire}");
          }
        }
      });

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveCoupon(int id) {
    selectedCouponCode = id.toString();
    update();
  }

  void onSaveCoupon() {
    if (action == 'service') {
      if (selectedCouponCode != '') {
        var savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCode);
        Get.find<PaymentController>().onSaveCoupon(savedCoupon);
      }
      onBack();
    } else if (action == 'product') {
      if (selectedCouponCode != '') {
        var savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCode);
        Get.find<ProductPaymentController>().onSaveCoupon(savedCoupon);
      }
      onProductBack();
    } else {
      if (selectedCouponCode != '') {
        var savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCode);
        Get.find<IndividualPaymentController>().onSaveCoupon(savedCoupon);
      }
      onIndividualBack();
    }
  }

  void onIndividualBack() {
    Get.find<IndividualPaymentController>().update();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onBack() {
    Get.find<PaymentController>().update();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }

  void onProductBack() {
    Get.find<ProductPaymentController>().update();
    var context = Get.context as BuildContext;
    Navigator.of(context).pop(true);
  }
}
