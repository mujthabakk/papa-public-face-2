import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/common_notification_controller.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';

/// Website header shown on desktop after onboarding / auth.
class WebShell extends StatelessWidget {
  final Widget child;
  final String route;
  const WebShell({Key? key, required this.child, this.route = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Desktop.of(context) || Desktop.hideSiteChrome(route)) return child;
    final inner = Desktop.isMainShell(route)
        ? child
        : LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 1200,
                    minHeight: constraints.maxHeight,
                    maxHeight: constraints.maxHeight,
                  ),
                  child: child,
                ),
              );
            },
          );
    return ColoredBox(
      color: ThemeProvider.backgroundColor,
      child: Column(
        children: [
          Get.isRegistered<TabsController>()
              ? GetBuilder<TabsController>(builder: (_) => const _WebHeader())
              : const _WebHeader(),
          Expanded(child: inner),
        ],
      ),
    );
  }
}

class _WebHeader extends StatelessWidget {
  const _WebHeader();

  void _openTab(int id) {
    if (Get.currentRoute != AppRouter.tabsBarRoutes) {
      Get.offAllNamed(AppRouter.getTabsBarRoute());
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<TabsController>()) {
        Get.find<TabsController>().updateTabId(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final route = Get.currentRoute;
    int? tabId;
    if (Get.isRegistered<TabsController>()) {
      tabId = Get.find<TabsController>().tabId;
    }
    return Material(
      color: ThemeProvider.surface,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0x22F2D338)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _openTab(0),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: ThemeProvider.gold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          const Icon(Icons.spa, color: Colors.black, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppConstants.appName,
                      style: ThemeProvider.serif(
                        size: 18,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _nav('Home', 0, tabId, route),
                      _nav('Nearby', 1, tabId, route),
                      _nav('Shop', 3, tabId, route),
                      _nav('Bookings', 4, tabId, route),
                      _nav('Account', 5, tabId, route),
                    ],
                  ),
                ),
              ),
              _icon(Icons.search,
                  () => Get.toNamed(AppRouter.getSearchRoutes())),
              if (Get.isRegistered<CommonNotificationController>())
                _icon(Icons.notifications_none,
                    () => Get.toNamed(AppRouter.getNotificatinRoutes())),
              _icon(Icons.translate, () {
                if (Get.isRegistered<LanguagesController>()) {
                  Get.find<LanguagesController>()
                      .showLocaleSettings(initialTab: 0);
                }
              }),
              _icon(
                Icons.shopping_bag_outlined,
                () {
                  final products = Get.isRegistered<ProductCartController>() &&
                      Get.find<ProductCartController>().savedInCart.isNotEmpty;
                  if (products) {
                    Get.toNamed(AppRouter.getCartRoutes());
                  } else {
                    Get.toNamed(AppRouter.getCheckoutRoutes());
                  }
                },
                badge: _cartCount(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _cartCount() {
    var n = 0;
    if (Get.isRegistered<ProductCartController>()) {
      n += Get.find<ProductCartController>().savedInCart.length;
    }
    if (Get.isRegistered<ServiceCartController>()) {
      final c = Get.find<ServiceCartController>().savedInCart;
      n += (c.services?.length ?? 0) + (c.packages?.length ?? 0);
    }
    return n;
  }

  Widget _icon(IconData icon, VoidCallback onTap, {int badge = 0}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Badge(
          isLabelVisible: badge > 0,
          backgroundColor: ThemeProvider.gold,
          label: Text(
            '$badge',
            style: const TextStyle(
                color: Colors.black, fontSize: 10, fontWeight: FontWeight.w700),
          ),
          child: Icon(icon, color: ThemeProvider.gold),
        ),
      ),
    );
  }

  Widget _nav(String label, int tab, int? tabId, String route) {
    final selected = route == AppRouter.tabsBarRoutes && tabId == tab;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => _openTab(tab),
        child: Text(
          label.tr,
          style: ThemeProvider.sans(
            size: 13,
            weight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? ThemeProvider.gold : Colors.white70,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

/// Left brand panel used on splash / welcome / login / register.
class DesktopBrandPane extends StatelessWidget {
  final String headline;
  final String subtitle;
  const DesktopBrandPane({
    Key? key,
    this.headline = 'PAPA BEAR',
    this.subtitle = 'Salons, specialists, and products — in one place.',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 28),
                Text(
                  headline.tr,
                  style: ThemeProvider.serif(
                    size: 42,
                    color: ThemeProvider.gold,
                    letterSpacing: 4,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  subtitle.tr,
                  style: ThemeProvider.sans(
                      size: 16, color: ThemeProvider.greyColor),
                ),
                const SizedBox(height: 32),
                _point(Icons.storefront_outlined, 'Salons & spas near you'),
                _point(Icons.event_available_outlined, 'Book in a few taps'),
                _point(Icons.shopping_bag_outlined, 'Shop products & offers'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _point(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: ThemeProvider.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.tr,
              style: ThemeProvider.sans(size: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
