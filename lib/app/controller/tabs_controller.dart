import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:salon_user/app/backend/parse/tabs_parse.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/payment_socket_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';

class TabsController extends GetxController
    with GetTickerProviderStateMixin
    implements GetxService {
  final TabsParser parser;
  int cartTotal = 0;
  int tabId = 0;
  late TabController tabController;
  TabsController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 6, vsync: this, initialIndex: tabId);
    // Dashboard socket: popup when COD / online payment completes.
    if (Get.isRegistered<PaymentSocketController>()) {
      Get.find<PaymentSocketController>().startListening();
    }
  }

  void updateCartValue() {
    cartTotal = Get.find<ProductCartController>().savedInCart.length;
    update();
  }

  void cleanLoginCreds() {
    // parser.cleanData();
  }

  void updateTabId(int id) {
    tabId = id;
    tabController.animateTo(tabId);
    _refreshTabIfCountryChanged(id);
    update();
  }

  void _refreshTabIfCountryChanged(int id) {
    try {
      if (id == 0 && Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        if (home.takeCountryRefresh()) {
          home.currencySide = home.parser.getCurrencySide();
          home.currencySymbol = home.parser.getCurrencySymbol();
          home.getHomeData();
        }
      } else if (id == 1 && Get.isRegistered<NearController>()) {
        final near = Get.find<NearController>();
        if (near.takeCountryRefresh()) {
          near.getHomeData();
        }
      } else if (id == 3 && Get.isRegistered<CategoriesController>()) {
        final categories = Get.find<CategoriesController>();
        if (categories.takeCountryRefresh()) {
          categories.currencySide = categories.parser.getCurrencySide();
          categories.currencySymbol = categories.parser.getCurrencySymbol();
          categories.getAllCategories();
        }
      } else if (id == 4 && Get.isRegistered<BookingController>()) {
        final booking = Get.find<BookingController>();
        if (booking.takeCountryRefresh()) {
          booking.currencySide = booking.parser.getCurrencySide();
          booking.currencySymbol = booking.parser.getCurrencySymbol();
          if (booking.parser.haveLoggedIn()) {
            booking.getAppointmentById();
          } else {
            booking.update();
          }
        }
      } else if (id == 5 && Get.isRegistered<AccountController>()) {
        final account = Get.find<AccountController>();
        if (account.takeCountryRefresh()) {
          account.changeInfo();
        }
      }
    } catch (_) {}
  }
}
