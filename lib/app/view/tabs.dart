import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/account.dart';
import 'package:salon_user/app/view/booking.dart';
import 'package:salon_user/app/view/categories.dart';
import 'package:salon_user/app/view/home.dart';
import 'package:salon_user/app/view/near.dart';
import 'package:salon_user/app/view/qr_screen.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:salon_user/app/view/widgets/spin_win_dialog.dart';

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
    return GetBuilder<LanguagesController>(
      builder: (_) {
        return GetBuilder<TabsController>(builder: (value) {
      return DefaultTabController(
        length: 6,
        child: Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          floatingActionButton: value.tabId == 2 || value.tabId == 4
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (value.tabId == 0)
                      GestureDetector(
                        onTap: openSpinWinOrLogin,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: ThemeProvider.gold,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: ThemeProvider.appColorShadow,
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.casino_outlined,
                                  color: Colors.black, size: 20),
                              const SizedBox(width: 6),
                              Text(
                                'Spin & Win'.tr,
                                style: ThemeProvider.sans(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const EliteCartFab(),
                  ],
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          bottomNavigationBar: value.tabId == 4
              ? null
              : EliteBottomNav(
                  tabId: value.tabId,
                  onSelect: value.updateTabId,
                ),
          body: pages[value.tabId],
        ),
      );
        });
      },
    );
  }
}
