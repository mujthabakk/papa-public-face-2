import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/sidemenu.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (value) {
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: ThemeProvider.backgroundColor,
        drawer: const SideMenuScreen(),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 100),
          children: [
            SafeArea(
              bottom: false,
              child: EliteAppBar(
                onMenu: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: ThemeProvider.gold, width: 3),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: ThemeProvider.appColorShadow,
                          blurRadius: 18,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: value.parser.haveLoggedIn()
                          ? EliteNetworkImage(
                              url: '${Environments.imageURL}${value.cover}',
                            )
                          : Image.asset('assets/images/placeholder.jpeg',
                              fit: BoxFit.cover),
                    ),
                  ),
                  if (value.parser.haveLoggedIn())
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: value.onEdit,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: ThemeProvider.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.black),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                value.parser.haveLoggedIn()
                    ? '${value.firstName} ${value.lastName}'
                    : 'Guest',
                style: ThemeProvider.serif(size: 24),
              ),
            ),
            if (value.parser.haveLoggedIn() && value.email.isNotEmpty)
              Center(
                child: Text(
                  value.email,
                  style: ThemeProvider.sans(
                      size: 12, color: ThemeProvider.greyColor),
                ),
              ),
            const SizedBox(height: 18),
            if (!value.parser.haveLoggedIn())
              _section('ACCOUNT', [
                _row(Icons.login, 'Sign In / Sign Up', value.onLogin),
              ]),
            if (value.parser.haveLoggedIn()) ...[
              _section('BOOKINGS', [
                _row(Icons.calendar_today_outlined, 'My Appointments', () {
                  Get.find<TabsController>().updateTabId(4);
                }),
                _row(Icons.history, 'My History', value.onProductOrder),
              ]),
              _section('OFFERS & REWARDS', [
                _row(Icons.local_offer_outlined, 'Exclusive Coupons', () {
                  Get.toNamed(AppRouter.getCouponRoutes());
                }),
                _row(Icons.discount_outlined, 'Shop Discounts', () {
                  Get.toNamed(AppRouter.getTopOffersRoutes());
                }),
                _row(Icons.card_giftcard_outlined, 'Refer & Earn',
                    value.onReferAndEarn),
              ]),
              _section('ACCOUNT MANAGEMENT', [
                _row(Icons.person_outline, 'Personal Information', value.onEdit),
                _row(Icons.lock_outline, 'Security & Password',
                    value.onChangePassword),
                _row(Icons.account_balance_wallet_outlined, 'Wallet',
                    value.onWallet),
                _row(Icons.location_on_outlined, 'Payment Methods',
                    value.onAddress),
                _row(Icons.chat_bubble_outline, 'Chats', value.onAccountChat),
              ]),
            ],
            _section('SUPPORT & HELP', [
              _row(Icons.support_agent_outlined, 'Help Center',
                  () => value.onAppPages('Help'.tr, '6')),
              _row(Icons.help_outline, 'Frequently Asked Questions',
                  () => value.onAppPages('Frequently Asked Questions'.tr, '5')),
              _row(Icons.chat_outlined, 'Priority VIP Support', _openWhatsApp),
              if (value.parser.haveLoggedIn())
                _row(Icons.delete_outline, 'Delete My Account',
                    value.onDeleteAccount),
            ]),
            _section('LEGAL & INFORMATION', [
              _row(Icons.privacy_tip_outlined, 'Privacy Policy',
                  () => value.onAppPages('Privacy Policy'.tr, '2')),
              _row(Icons.info_outline, 'About Papa Bear',
                  () => value.onAppPages('About us'.tr, '1')),
              _row(Icons.gavel_outlined, 'Terms & Conditions',
                  () => value.onAppPages('Terms & Conditions'.tr, '3')),
              _row(Icons.settings_outlined, 'Settings', value.onLanguages),
              _row(Icons.mail_outline, 'Contact Us', value.onContactUs),
            ]),
            if (value.parser.haveLoggedIn())
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: OutlinedButton(
                  onPressed: () => _showLogoutDialog(value),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: Color(0xFF3A3A3A)),
                    foregroundColor: ThemeProvider.logoutRose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Logout from VIP Portal',
                    style: ThemeProvider.sans(
                      size: 13,
                      weight: FontWeight.w600,
                      color: ThemeProvider.logoutRose,
                    ),
                  ),
                ),
              ),
            Center(
              child: Text(
                AppConstants.appName,
                style: ThemeProvider.sans(
                  size: 11,
                  color: const Color(0xFF5A5A5A),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeProvider.sans(
              size: 11,
              color: ThemeProvider.goldDeep,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String title, VoidCallback onTap,
      {String? badge}) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: ThemeProvider.gold, size: 22),
      title: Text(
        title,
        style: ThemeProvider.sans(size: 15, weight: FontWeight.w500),
      ),
      trailing: badge == null
          ? const Icon(Icons.chevron_right, color: Colors.white38)
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: ThemeProvider.gold,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: ThemeProvider.sans(
                  size: 9,
                  weight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
    );
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '+919562121333';
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    }
  }

  void _showLogoutDialog(AccountController value) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ThemeProvider.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Logout', style: ThemeProvider.serif(size: 20)),
        content: Text(
          'Are you sure you want to logout from your account?',
          style: ThemeProvider.sans(size: 14, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: ThemeProvider.sans(color: ThemeProvider.greyColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              value.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.logoutRose,
              foregroundColor: Colors.black,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
