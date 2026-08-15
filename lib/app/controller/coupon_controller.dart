import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  double? cartValue = 0.0;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is List && args.isNotEmpty) {
      if (args[0] == 'product') {
        action = 'product';
      } else if (args[0] == 'individual-service') {
        action = 'individual-service';
      } else {
        action = 'service';
      }
      if (args.length > 3) {
        uid = args[3].toString();
      }
      if (args.length > 4) {
        cartValue = double.tryParse(args[4].toString()) ?? 0.0;
      }
    } else {
      action = 'browse';
    }
    getCoupons();
  }

  Future<void> getCoupons() async {
    Response response = action == 'browse'
        ? await parser.getPublicHomeOffers()
        : await parser.getCouponCodes();
    apiCalled = true;

    if (response.statusCode == 200) {
      Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);
      var body = myMap['data'];
      _couponList = [];
      if (body is! List) {
        update();
        return;
      }

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

            // Check multiple conditions:
            // 1. Not expired (expiry date is after or same as current date)
            // 2. Freelancer ID matches
            // 3. Max usage not exceeded
            // 4. Coupon is active (status check)
            bool isNotExpired = expiryDate.isAfter(currentDate) ||
                expiryDate.isAtSameMomentAs(currentDate);

            bool isValidForFreelancer = uid.isEmpty ||
                action == 'browse' ||
                (data.freelancerIds != null &&
                    (data.freelancerIds == "ALL" ||
                        data.freelancerIds!
                            .split(',')
                            .contains(uid.toString())));

            bool isNotMaxUsageExceeded = data.maxUsageExceeded != true;

            bool isActive = data.status == 1; // Assuming 1 means active

            if (isNotExpired &&
                isValidForFreelancer &&
                isNotMaxUsageExceeded &&
                isActive) {
              _couponList.add(data);
            }
          } catch (e) {
            print("Error parsing date: ${data.expire}");
          }
        }
      });

      // Sort coupons by preference (optional)
      _couponList.sort((a, b) {
        // Sort by discount value (highest first)
        if (a.discount != null && b.discount != null) {
          return b.discount!.compareTo(a.discount!);
        }
        return 0;
      });

      update();
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveCoupon(int id) {
    String selectedCouponCodeTemp = id.toString();
    CouponsModel savedCoupon = CouponsModel();
    if (action == 'service') {
      if (selectedCouponCodeTemp != '') {
        savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCodeTemp);
      }
    } else if (action == 'product') {
      if (selectedCouponCodeTemp != '') {
        savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCodeTemp);
      }
    } else {
      if (selectedCouponCodeTemp != '') {
        savedCoupon = _couponList.firstWhere(
            (element) => element.id.toString() == selectedCouponCodeTemp);
      }
    }
    if (cartValue! < savedCoupon.minCartValue!) {
      Get.snackbar(
        '', // Empty title as we'll use messageText
        '',
        titleText: Container(), // Hide default title
        messageText: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.block,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Coupon Cannot Be Applied',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Current vs Required comparison
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Cart Value:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${cartValue!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Minimum Required:',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '₹${savedCoupon.minCartValue!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Amount needed
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.orange.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Add ₹${(savedCoupon.minCartValue! - cartValue!).toStringAsFixed(2)} more to apply this coupon',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[400]!.withOpacity(0.95),
        borderRadius: 16,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        duration: const Duration(seconds: 4),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        animationDuration: const Duration(milliseconds: 600),
        boxShadows: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      );
      return;
    }
    selectedCouponCode = id.toString();
    update();
  }

  void onSaveCoupon() {
    if (action == 'browse') {
      Get.back();
      return;
    }
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
    if (action == 'browse') {
      Get.back();
      return;
    }
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
