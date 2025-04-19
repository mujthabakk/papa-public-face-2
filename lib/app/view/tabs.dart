import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/account.dart';
import 'package:salon_user/app/view/booking.dart';
import 'package:salon_user/app/view/categories.dart';
import 'package:salon_user/app/view/home.dart';
import 'package:salon_user/app/view/near.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:badges/badges.dart' as badges;
import 'package:salon_user/app/view/qr_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  Widget build(BuildContext context) {
    const List<Widget> pages = [
      HomeScreen(),
      NearScreen(),
      QRViewExample(),
      CategoriesScreen(),
      BookingScreen(),
      AccountScreen(),
    ];
    return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 6,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: InkWell(
                child: (GNav(
                  rippleColor: ThemeProvider.whiteColor,
                  hoverColor: ThemeProvider.appColor,
                  haptic: false,
                  curve: Curves.easeOutExpo,
                  tabBorderRadius: 4,
                  textStyle:
                      const TextStyle(fontFamily: 'bold', color: Colors.white),
                  duration: const Duration(milliseconds: 300),
                  gap: 6,
                  color: Colors.grey.shade400,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                  tabs: [
                    GButton(
                      icon: Icons.home_outlined,
                      text: 'Home'.tr,
                      backgroundColor: ThemeProvider.pink,
                    ),
                    GButton(
                      icon: Icons.location_on_outlined,
                      text: 'NearBy'.tr,
                      backgroundColor: ThemeProvider.pink,
                    ),
                    GButton(
                      icon: Icons.qr_code,
                      text: 'Scanner'.tr,
                      backgroundColor: ThemeProvider.pink,
                    ),
                    GButton(
                      icon: Icons.shopping_cart_outlined,
                      text: 'Shop'.tr,
                      backgroundColor: ThemeProvider.pink,
                      leading: badges.Badge(
                        showBadge: value.cartTotal > 0,
                        badgeStyle: badges.BadgeStyle(
                            badgeColor: value.tabId == 2
                                ? ThemeProvider.whiteColor
                                : ThemeProvider.whiteColor),
                        badgeContent: Text(
                          value.cartTotal.toString(),
                          style: TextStyle(
                              color: value.tabId == 2
                                  ? ThemeProvider.appColor
                                  : ThemeProvider.pink),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: value.tabId == 2 ? Colors.grey : Colors.grey,
                        ),
                      ),
                    ),
                    GButton(
                      icon: Icons.calendar_today_outlined,
                      text: 'Appoinment'.tr,
                      backgroundColor: ThemeProvider.pink,
                    ),
                    GButton(
                      icon: Icons.account_circle_outlined,
                      text: 'Account'.tr,
                      backgroundColor: ThemeProvider.pink,
                    ),
                  ],
                  selectedIndex: value.tabId,
                  onTabChange: (index) {
                    value.updateTabId(index);
                  },
                )),
              ),
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: value.tabController,
            children: pages,
          ),
        ),
      );
    });
  }
}
