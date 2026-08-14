import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/account.dart';
import 'package:salon_user/app/view/booking.dart';
import 'package:salon_user/app/view/categories.dart';
import 'package:salon_user/app/view/home.dart';
import 'package:salon_user/app/view/near.dart';
import 'package:salon_user/app/view/qr_screen.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

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
          backgroundColor: ThemeProvider.backgroundColor,
          floatingActionButton: value.tabId == 2 ? null : const EliteCartFab(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: EliteBottomNav(
            tabId: value.tabId,
            onSelect: value.updateTabId,
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
