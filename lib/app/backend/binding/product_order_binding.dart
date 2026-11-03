import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/product_order_parse.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';

class ProductOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      ProductOrderController(parser: Get.find<ProductOrderParser>()),
    );
  }
}
