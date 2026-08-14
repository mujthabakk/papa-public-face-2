import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/reset_password_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class SideMenuScreen extends StatefulWidget {
  const SideMenuScreen({Key? key}) : super(key: key);

  @override
  State<SideMenuScreen> createState() => _SideMenuScreenState();
}

class _SideMenuScreenState extends State<SideMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (value) {
      return Drawer(
        backgroundColor: ThemeProvider.backgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ThemeProvider.gold, width: 2.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: value.parser.haveLoggedIn()
                                ? EliteNetworkImage(
                                    url:
                                        '${Environments.imageURL}${value.cover}',
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset('assets/images/placeholder.jpeg',
                                    fit: BoxFit.cover),
                          ),
                        ),
                        if (value.parser.haveLoggedIn())
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: ThemeProvider.gold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  size: 14, color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      value.parser.haveLoggedIn()
                          ? '${value.firstName} ${value.lastName}'
                          : 'Guest',
                      style: ThemeProvider.serif(
                        size: 26,
                        color: ThemeProvider.gold,
                        weight: FontWeight.w600,
                      ),
                    ),
                    if (value.parser.haveLoggedIn() && value.email.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          value.email,
                          style: ThemeProvider.sans(
                            size: 12,
                            color: ThemeProvider.greyColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _item(Icons.home_outlined, 'Home', () {
                      Navigator.pop(context);
                      Get.find<TabsController>().updateTabId(0);
                    }, active: true),
                    _item(Icons.location_on_outlined, 'Nearby', () {
                      Navigator.pop(context);
                      Get.find<TabsController>().updateTabId(1);
                    }),
                    if (value.parser.haveLoggedIn())
                      _item(Icons.calendar_today_outlined, 'My Appointments',
                          () {
                        Navigator.pop(context);
                        Get.find<TabsController>().updateTabId(4);
                      }),
                    _item(Icons.grid_view_outlined, 'Categories', () {
                      Navigator.pop(context);
                      Get.find<TabsController>().updateTabId(3);
                    }),
                    if (value.parser.haveLoggedIn())
                      _item(Icons.card_giftcard_outlined, 'Redeem Rewards', () {
                        Navigator.pop(context);
                        Get.toNamed(AppRouter.getCouponRoutes());
                      }),
                    _item(Icons.shopping_cart_outlined, 'Cart', () {
                      Navigator.pop(context);
                      Get.toNamed(AppRouter.getCartRoutes());
                    }),
                    if (value.parser.haveLoggedIn())
                      _item(Icons.card_giftcard, 'Refer & Earn', () {
                        Navigator.pop(context);
                        Get.toNamed(AppRouter.referAndEarnRoutes);
                      }, highlight: true),
                    _item(Icons.settings_outlined, 'Settings', () {
                      Navigator.pop(context);
                      Get.delete<ResetPasswordController>(force: true);
                      Get.toNamed(AppRouter.getResetPasswordRoute());
                    }),
                    if (!value.parser.haveLoggedIn())
                      _item(Icons.login, 'Sign In / Sign Up', () {
                        Navigator.pop(context);
                        value.onLogin();
                      }, highlight: true),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (value.parser.haveLoggedIn()) {
                      value.logout();
                    } else {
                      value.onLogin();
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFF3A3A3A)),
                    foregroundColor: ThemeProvider.logoutRose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'LOGOUT SESSION',
                        style: ThemeProvider.sans(
                          size: 12,
                          weight: FontWeight.w600,
                          color: ThemeProvider.logoutRose,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                  child: Text(
                    'PAPA BEAR ELITE V4.2.1',
                    style: ThemeProvider.sans(
                      size: 10,
                      color: const Color(0xFF5A5A5A),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _item(IconData icon, String label, VoidCallback onTap,
      {bool active = false, bool highlight = false}) {
    final color = active || highlight
        ? ThemeProvider.gold
        : const Color(0xFFBDBDBD);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF2A2A2A) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          label,
          style: ThemeProvider.sans(
            size: 15,
            weight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}
