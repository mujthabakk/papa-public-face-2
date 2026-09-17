import 'package:get/get.dart';
import 'package:salon_user/app/controller/all_categories_controller.dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/categories_list_controller.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/individual_categories_controller.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/individual_list_controller.dart';
import 'package:salon_user/app/controller/individual_packages_controller.dart';
import 'package:salon_user/app/controller/individual_payment_controller.dart';
import 'package:salon_user/app/controller/packages_details_controller.dart';
import 'package:salon_user/app/controller/payment_controller.dart';
import 'package:salon_user/app/controller/product_order_controller.dart';
import 'package:salon_user/app/controller/product_order_detail_controller.dart';
import 'package:salon_user/app/controller/product_payment_controller.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/controller/refer_and_earn_controller.dart';
import 'package:salon_user/app/controller/selected_services_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/controller/timed_offer_controller.dart';
import 'package:salon_user/app/controller/top_offers_controller.dart';
import 'package:salon_user/app/controller/top_packages_controller.dart';
import 'package:salon_user/app/controller/top_products_controller.dart';
import 'package:salon_user/app/controller/top_specialist_controller.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';

/// Drops inner-page controllers so they refetch the next time those screens open.
void dropSecondaryCountryControllers() {
  void drop<T>() {
    if (Get.isRegistered<T>()) {
      try {
        Get.delete<T>(force: true);
      } catch (_) {}
    }
  }

  drop<WalletController>();
  drop<ServicesController>();
  drop<SpecialistController>();
  drop<TimedOfferController>();
  drop<CouponController>();
  drop<UnifiedSearchController>();
  drop<ProductsController>();
  drop<ProductsDetailsController>();
  drop<TopProductsControllrer>();
  drop<TopSpecialistController>();
  drop<TopOffersController>();
  drop<TopPackagesController>();
  drop<AllCategoriesController>();
  drop<CategoriesListController>();
  drop<IndividualListController>();
  drop<IndividualCategoriesController>();
  drop<CheckoutController>();
  drop<PaymentController>();
  drop<ProductPaymentController>();
  drop<IndividualPaymentController>();
  drop<IndividualCheckoutController>();
  drop<AppointmentDetailController>();
  drop<ProductOrderController>();
  drop<ProductOrderDetailController>();
  drop<ReferAndEarnController>();
  drop<CartController>();
  drop<SelectedServicesController>();
  drop<PackagesDetailsController>();
  drop<IndividualPackagesController>();
}
