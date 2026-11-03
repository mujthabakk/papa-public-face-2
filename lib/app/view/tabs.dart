import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/util/constant.dart';
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
    final desktop = Desktop.of(context);
    // Web uses the top site header; native desktop keeps the left rail.
    final showRail = desktop && !GetPlatform.isWeb;
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              bottomNavigationBar: desktop || value.tabId == 4
                  ? null
                  : EliteBottomNav(
                      tabId: value.tabId,
                      onSelect: value.updateTabId,
                    ),
              body: Row(
                children: [
                  if (showRail) _rail(value),
                  Expanded(
                    child: IndexedStack(
                      index: value.tabId,
                      children: [
                        pages[0],
                        pages[1],
                        value.tabId == 2 ? pages[2] : const SizedBox.shrink(),
                        pages[3],
                        pages[4],
                        pages[5],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _rail(TabsController value) {
    const items = <(IconData, IconData, String, int)>[
      (Icons.home_outlined, Icons.home, 'Home', 0),
      (Icons.location_on_outlined, Icons.location_on, 'Nearby', 1),
      (Icons.qr_code_2_outlined, Icons.qr_code_2, 'Scan', 2),
      (Icons.shopping_bag_outlined, Icons.shopping_bag, 'Products', 3),
      (Icons.event_note_outlined, Icons.event_note, 'Bookings', 4),
      (Icons.person_outline, Icons.person, 'Profile', 5),
    ];
    return Container(
      width: Desktop.sidebarWidth,
      decoration: const BoxDecoration(
        color: ThemeProvider.surface,
        border: Border(
          right: BorderSide(color: Color(0x22F2D338)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ThemeProvider.gold,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.spa, color: Colors.black, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppConstants.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.serif(
                        size: 16,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...items.map((item) {
              final selected = value.tabId == item.$4;
              return Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                child: Material(
                  color: selected
                      ? ThemeProvider.gold.withValues(alpha: 0.16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () => value.updateTabId(item.$4),
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            selected ? item.$2 : item.$1,
                            color: selected
                                ? ThemeProvider.gold
                                : Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.$3.tr,
                              style: ThemeProvider.sans(
                                size: 13,
                                weight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? ThemeProvider.gold
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Text(
                'Desktop'.tr,
                style: ThemeProvider.sans(
                  size: 10,
                  color: ThemeProvider.greyColor,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
