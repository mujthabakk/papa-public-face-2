import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/models/product_salon_model.dart';
import 'package:salon_user/app/backend/parse/booking_parse.dart';
import 'package:salon_user/app/backend/parse/product_order_parse.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/product_order_detail_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';

class ProductOrderController extends GetxController implements GetxService {
  final ProductOrderParser parser;

  List<ProductSalonModel> _productSalonList = <ProductSalonModel>[];
  List<ProductSalonModel> get productSalonList => _productSalonList;

  List<ProductSalonModel> _productSalonListOld = <ProductSalonModel>[];
  List<ProductSalonModel> get productSalonListOld => _productSalonListOld;

  bool apiCalled = false;

  String currencySide = AppConstants.defaultCurrencySide;
  String currencySymbol = AppConstants.defaultCurrencySymbol;

  List<String> statusName = [
    'Created',
    'Accepted',
    'Rejected',
    'Ongoing',
    'Completed',
    'Cancelled',
    'Refunded',
    'Delayed',
    'Pending Payment',
  ];
  ProductOrderController({required this.parser});

  String statusLabel(int? status) {
    final i = status ?? 0;
    if (i < 0 || i >= statusName.length) return statusName.first;
    return statusName[i];
  }

  @override
  void onInit() {
    super.onInit();
    currencySide = parser.getCurrencySide();
    currencySymbol = parser.getCurrencySymbol();
    _ensureBookings();
    getProductById();
  }

  void _ensureBookings() {
    try {
      if (!Get.isRegistered<BookingController>()) {
        Get.put(
          BookingController(parser: Get.find<BookingParser>()),
          permanent: false,
        );
      } else {
        final booking = Get.find<BookingController>();
        if (!booking.apiCalled && booking.parser.haveLoggedIn()) {
          booking.getAppointmentById();
        }
      }
    } catch (e) {
      debugPrint('history bookings: $e');
    }
  }

  Future<void> getProductById() async {
    if (!parser.haveLoggedIn()) {
      apiCalled = true;
      update();
      return;
    }
    try {
      final response = await parser.getProductById().timeout(
        const Duration(seconds: 12),
        onTimeout: () => const Response(statusCode: 1, statusText: 'timeout'),
      );
      if (response.statusCode == 200 && response.body is Map) {
        final myMap = Map<String, dynamic>.from(response.body);
        final body = myMap['data'];
        _productSalonList = [];
        _productSalonListOld = [];
        final rows = body is List
            ? body
            : (body is Map && body['data'] is List)
                ? body['data'] as List
                : const [];
        for (final data in rows) {
          if (data is! Map) continue;
          try {
            final productSalon = ProductSalonModel.fromJson(
                Map<String, dynamic>.from(data));
            if (productSalon.status == 0) {
              _productSalonList.add(productSalon);
            } else {
              _productSalonListOld.add(productSalon);
            }
          } catch (e) {
            debugPrint('product order skip: $e');
          }
        }
      } else if (response.statusCode != 200 && response.statusCode != 1) {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('getProductById: $e');
    } finally {
      apiCalled = true;
      update();
    }
  }

  void onProductDetail(int id) {
    Get.delete<ProductOrderDetailController>(force: true);
    Get.toNamed(AppRouter.getProductOrderDetail(), arguments: [id]);
  }

  void bookAgain(ProductSalonModel o) {
    final salonId = o.salonId ?? 0;
    final freelancerId = o.freelancerId ?? 0;
    if (salonId != 0) {
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(), arguments: [salonId]);
      return;
    }
    if (freelancerId != 0) {
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [freelancerId]);
    }
  }
}
