import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/booking_controller.dart';
import 'package:salon_user/app/controller/categories_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';

/// After guest login: choose location first, then return to the page
/// that asked for login (shop, checkout, cart, etc.).
class PostLoginNav {
  static String? route;
  static dynamic arguments;

  static const _skip = {
    '/',
    '/splash',
    '/welcome',
    '/login',
    '/register',
    '/reset_password',
    '/choose_location',
    '/find_location',
    '/firebase_auth',
    '/tabs',
  };

  static void capture() {
    final current = Get.currentRoute;
    if (_skip.contains(current)) return;
    route = current;
    arguments = Get.arguments;
  }

  static void clear() {
    route = null;
    arguments = null;
  }

  static bool get hasReturn {
    final r = route;
    return r != null && r.isNotEmpty && !_skip.contains(r);
  }

  static void _resetTabs() {
    Get.delete<TabsController>(force: true);
    Get.delete<HomeController>(force: true);
    Get.delete<NearController>(force: true);
    Get.delete<CategoriesController>(force: true);
    Get.delete<BookingController>(force: true);
    Get.delete<AccountController>(force: true);
  }

  static Future<void> finishAfterLocation() async {
    _resetTabs();
    final r = route;
    final a = arguments;
    clear();
    Get.offAllNamed(AppRouter.getTabsBarRoute());
    if (r == null || r.isEmpty || _skip.contains(r)) return;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    Get.toNamed(r, arguments: a);
  }
}
