import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/products_parse.dart';
import 'package:salon_user/app/controller/product_seller_controller.dart';

class ProductSellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProductSellerController(parser: Get.find<ProductsParser>()),
    );
  }
}
