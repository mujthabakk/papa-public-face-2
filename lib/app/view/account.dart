// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/account_controller.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({Key? key}) : super(key: key);

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AccountController>(builder: (value) {
//       return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: value.parser.haveLoggedIn() == true
//             ? AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: ThemeProvider.appColor,
//                 elevation: 3,
//                 toolbarHeight: 180,
//                 iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//                 titleSpacing: 0,
//                 title: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 20),
//                       child: Column(
//                         children: [
//                           Container(
//                             height: 80,
//                             width: 80,
//                             padding: const EdgeInsets.all(3),
//                             decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(100)),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(100),
//                               child: FadeInImage(
//                                 height: 80,
//                                 width: 80,
//                                 image: NetworkImage(
//                                     '${Environments.imageURL}${value.cover}'),
//                                 placeholder: const AssetImage(
//                                     "assets/images/placeholder.jpeg"),
//                                 imageErrorBuilder:
//                                     (context, error, stackTrace) {
//                                   return Image.asset(
//                                       'assets/images/notfound.png',
//                                       fit: BoxFit.fitWidth);
//                                 },
//                                 fit: BoxFit.fitWidth,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             '${value.firstName} ${value.lastName}',
//                             style: const TextStyle(
//                                 fontFamily: 'bold',
//                                 fontSize: 14,
//                                 color: ThemeProvider.whiteColor),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             'User Id -  ${value.userId}',
//                             style: const TextStyle(
//                                 fontFamily: 'regular',
//                                 fontSize: 12,
//                                 color: ThemeProvider.whiteColor),
//                           ),
//                           Text(
//                             value.email,
//                             style: const TextStyle(
//                                 color: ThemeProvider.whiteColor,
//                                 fontSize: 12,
//                                 fontFamily: 'regular'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : AppBar(
//                 automaticallyImplyLeading: false,
//                 backgroundColor: ThemeProvider.appColor,
//                 title: Text(
//                   'Account'.tr,
//                   style: ThemeProvider.titleStyle,
//                 ),
//               ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: ThemeProvider.whiteColor,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: ThemeProvider.greyColor,
//                         blurRadius: 5.0,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       value.parser.haveLoggedIn() == false
//                           ? InkWell(
//                               onTap: () {
//                                 value.onLogin();
//                               },
//                               child: _buildList(Icons.lock_clock_outlined,
//                                   'Sign In / Sign Up'.tr),
//                             )
//                           : const SizedBox(),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onEdit();
//                               },
//                               child: _buildList(Icons.account_circle_outlined,
//                                   'Edit Profile'.tr),
//                             )
//                           : const SizedBox(),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onProductOrder();
//                               },
//                               child: _buildList(
//                                   Icons.add_shopping_cart, 'Product Order'.tr),
//                             )
//                           : const SizedBox(),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onAddress();
//                               },
//                               child: _buildList(Icons.location_on_outlined,
//                                   'Your Address'.tr),
//                             )
//                           : const SizedBox(),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onWallet();
//                               },
//                               child: _buildList(
//                                   Icons.account_balance_wallet_outlined,
//                                   'Wallet'.tr),
//                             )
//                           : const SizedBox(),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onReferAndEarn();
//                               },
//                               child: _buildList(
//                                   Icons.savings_outlined, 'Refer & Earn'.tr),
//                             )
//                           : const SizedBox(),
//                       InkWell(
//                         onTap: () {
//                           value.onChangePassword();
//                         },
//                         child: _buildList(
//                             Icons.code_rounded, 'Change Password'.tr),
//                       ),
//                       // InkWell(
//                       //   onTap: () {
//                       //     value.onLanguages();
//                       //   },
//                       //   child:
//                       //       _buildList(Icons.language_outlined, 'Languages'.tr),
//                       // ),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.onAccountChat();
//                               },
//                               child: _buildList(
//                                   Icons.message_outlined, 'Chats'.tr),
//                             )
//                           : const SizedBox(),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: ThemeProvider.whiteColor,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: ThemeProvider.greyColor,
//                         blurRadius: 5.0,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       InkWell(
//                         onTap: () async {
//                           String phone = '+919562121333';
//                           var whatsappUrl = "whatsapp://send?phone=$phone";
//                           await launchUrl(Uri.parse(whatsappUrl));
//                         },
//                         child: _buildListImg(
//                             IconButton(
//                               onPressed: () async {
//                                 const phoneNumber =
//                                     '+919562121333'; // Replace with your WhatsApp number
//                                 final Uri whatsappUrl =
//                                     Uri.parse('https://wa.me/$phoneNumber');

//                                 try {
//                                   if (await canLaunchUrl(whatsappUrl)) {
//                                     await launchUrl(
//                                       whatsappUrl,
//                                       mode: LaunchMode
//                                           .externalApplication, // Ensures it opens in WhatsApp
//                                     );
//                                   } else {
//                                     Get.snackbar(
//                                       'Error',
//                                       'Could not open WhatsApp',
//                                       snackPosition: SnackPosition.BOTTOM,
//                                       backgroundColor: Colors.red,
//                                       colorText: Colors.white,
//                                     );
//                                   }
//                                 } catch (e) {
//                                   Get.snackbar(
//                                     'Error',
//                                     'An error occurred: $e',
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     backgroundColor: Colors.red,
//                                     colorText: Colors.white,
//                                   );
//                                 }
//                               },
//                               icon: Image.asset('assets/icons/wapp.png'),
//                             ),
//                             'WhatsApp Support'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onContactUs();
//                         },
//                         child: _buildList(
//                             Icons.contact_page_outlined, 'Contact Us'.tr),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: ThemeProvider.whiteColor,
//                     boxShadow: const [
//                       BoxShadow(
//                         color: ThemeProvider.greyColor,
//                         blurRadius: 5.0,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages(
//                               'Frequently Asked Questions'.tr, '5');
//                         },
//                         child: _buildList(Icons.flag_outlined,
//                             'Frequently Asked Questions'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages(
//                               'Cancellation & Refund Policy'.tr, '4');
//                         },
//                         child: _buildList(Icons.free_cancellation,
//                             'Cancellation & Refund Policy'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages('Terms & Conditions'.tr, '3');
//                         },
//                         child: _buildList(Icons.privacy_tip_outlined,
//                             'Terms & Conditions'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages('Cookie Policy'.tr, '8');
//                         },
//                         child: _buildList(Icons.cookie, 'Cookie Policy'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages('Privacy Policy'.tr, '2');
//                         },
//                         child: _buildList(
//                             Icons.security_outlined, 'Privacy Policy'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages('Help'.tr, '6');
//                         },
//                         child: _buildList(Icons.help_outline, 'Help'.tr),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           value.onAppPages('About us'.tr, '1');
//                         },
//                         child: _buildList(Icons.info_outline, 'About'.tr),
//                       ),
//                       value.parser.haveLoggedIn() == true
//                           ? InkWell(
//                               onTap: () {
//                                 value.logout();
//                               },
//                               child: _buildList(Icons.logout, 'Logout'.tr),
//                             )
//                           : const SizedBox()
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _buildList(icn, txt) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: ThemeProvider.appColor,
//             child: Icon(
//               icn,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     '$txt',
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildListImg(icn, txt) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: ThemeProvider.appColor,
//             child: IconButton(
//               icon: Image.asset(
//                 'assets/icons/wapp.png',
//                 color: Colors.white,
//               ),
//               onPressed: () async {
//                 String phone = '+919562121333';
//                 var whatsappUrl = "whatsapp://send?phone=$phone";
//                 await launchUrl(Uri.parse(whatsappUrl));
//               },
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     '$txt',
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
//                   ),
//                 ),
//                 const Icon(Icons.chevron_right),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.appColor;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(builder: (value) {
      return Scaffold(
        backgroundColor: background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(value),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //if (value.parser.haveLoggedIn() == true) ...[
                    _buildAccountSection(value),
                    const SizedBox(height: 24),
                    // ],
                    _buildSupportSection(value),
                    const SizedBox(height: 24),
                    _buildLegalSection(value),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(AccountController value) {
    return SliverAppBar(
      expandedHeight: value.parser.haveLoggedIn() == true ? 280 : 120,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primary,
                primary.withOpacity(0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: value.parser.haveLoggedIn() == true
                ? _buildLoggedInHeader(value)
                : _buildLoggedOutHeader(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInHeader(AccountController value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile Picture
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: SizedBox(
                width: 112,
                height: 112,
                child: FadeInImage(
                  image: NetworkImage('${Environments.imageURL}${value.cover}'),
                  placeholder:
                      const AssetImage("assets/images/placeholder.jpeg"),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: surfaceBackground,
                      child: const Icon(
                        Icons.person,
                        size: 56,
                        color: textLight,
                      ),
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            '${value.firstName} ${value.lastName}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          // User ID
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'User ID: ${value.userId}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Email
          Text(
            value.email,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedOutHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your profile and preferences',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(AccountController value) {
    return _buildSection(
      title: 'Account Management',
      icon: Icons.person_outline,
      children: [
        if (value.parser.haveLoggedIn() == false)
          _buildMenuItem(
            icon: Icons.login,
            title: 'Sign In / Sign Up'.tr,
            subtitle: 'Access your account and services',
            onTap: () => value.onLogin(),
            iconColor: success,
          ),
        if (value.parser.haveLoggedIn() == true) ...[
          _buildMenuItem(
            icon: Icons.edit_outlined,
            title: 'Edit Profile'.tr,
            subtitle: 'Update your personal information',
            onTap: () => value.onEdit(),
            iconColor: info,
          ),
          _buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: 'Product Orders'.tr,
            subtitle: 'View your order history',
            onTap: () => value.onProductOrder(),
            iconColor: warning,
          ),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Your Addresses'.tr,
            subtitle: 'Manage delivery addresses',
            onTap: () => value.onAddress(),
            iconColor: error,
          ),
          _buildMenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Wallet'.tr,
            subtitle: 'View balance and transactions',
            onTap: () => value.onWallet(),
            iconColor: success,
          ),
          _buildMenuItem(
            icon: Icons.card_giftcard_outlined,
            title: 'Refer & Earn'.tr,
            subtitle: 'Invite friends and earn rewards',
            onTap: () => value.onReferAndEarn(),
            iconColor: primary,
          ),
          _buildMenuItem(
            icon: Icons.chat_bubble_outline,
            title: 'Chats'.tr,
            subtitle: 'Your conversation history',
            onTap: () => value.onAccountChat(),
            iconColor: info,
          ),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Change Password'.tr,
            subtitle: 'Update your security credentials',
            onTap: () => value.onChangePassword(),
            iconColor: error,
          ),
        ],
      ],
    );
  }

  Widget _buildSupportSection(AccountController value) {
    return _buildSection(
      title: 'Support & Help',
      icon: Icons.support_agent_outlined,
      children: [
        _buildMenuItem(
          icon: Icons.chat_outlined,
          title: 'WhatsApp Support'.tr,
          subtitle: 'Get instant help via WhatsApp',
          onTap: () => _openWhatsApp(),
          iconColor: success,
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              'assets/icons/wapp.png',
              width: 20,
              height: 20,
            ),
          ),
        ),
        if (value.parser.haveLoggedIn() == true) ...[
          _buildMenuItem(
            icon: Icons.delete_outline_outlined,
            title: 'Delete My Account'.tr,
            subtitle: 'Completely remove your account',
            onTap: () => value.onDeleteAccount(),
            iconColor: primary,
          ),
        ],
        _buildMenuItem(
          icon: Icons.contact_support_outlined,
          title: 'Contact Us'.tr,
          subtitle: 'Reach out to our support team',
          onTap: () => value.onContactUs(),
          iconColor: primary,
        ),
      ],
    );
  }

  Widget _buildLegalSection(AccountController value) {
    return _buildSection(
      title: 'Legal & Information',
      icon: Icons.info_outline,
      children: [
        _buildMenuItem(
          icon: Icons.quiz_outlined,
          title: 'Frequently Asked Questions'.tr,
          subtitle: 'Find answers to common questions',
          onTap: () => value.onAppPages('Frequently Asked Questions'.tr, '5'),
          iconColor: info,
        ),
        _buildMenuItem(
          icon: Icons.cancel_outlined,
          title: 'Cancellation & Refund Policy'.tr,
          subtitle: 'Learn about our refund process',
          onTap: () => value.onAppPages('Cancellation & Refund Policy'.tr, '4'),
          iconColor: warning,
        ),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions'.tr,
          subtitle: 'Read our terms of service',
          onTap: () => value.onAppPages('Terms & Conditions'.tr, '3'),
          iconColor: textSecondary,
        ),
        _buildMenuItem(
          icon: Icons.cookie_outlined,
          title: 'Cookie Policy'.tr,
          subtitle: 'How we use cookies',
          onTap: () => value.onAppPages('Cookie Policy'.tr, '8'),
          iconColor: warning,
        ),
        _buildMenuItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy'.tr,
          subtitle: 'How we protect your data',
          onTap: () => value.onAppPages('Privacy Policy'.tr, '2'),
          iconColor: success,
        ),
        _buildMenuItem(
          icon: Icons.help_outline,
          title: 'Help'.tr,
          subtitle: 'Get help using our app',
          onTap: () => value.onAppPages('Help'.tr, '6'),
          iconColor: primary,
        ),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About Us'.tr,
          subtitle: 'Learn more about our company',
          onTap: () => value.onAppPages('About us'.tr, '1'),
          iconColor: info,
        ),
        if (value.parser.haveLoggedIn() == true)
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout'.tr,
            subtitle: 'Sign out of your account',
            onTap: () => _showLogoutDialog(value),
            iconColor: error,
            showDivider: false,
          ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
    Widget? trailing,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing ??
                      const Icon(
                        Icons.chevron_right,
                        color: textLight,
                        size: 20,
                      ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Container(
            margin: const EdgeInsets.only(left: 68),
            height: 1,
            color: borderLight,
          ),
      ],
    );
  }

  Future<void> _openWhatsApp() async {
    const phoneNumber = '+919562121333';
    final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(
          whatsappUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Error',
          'Could not open WhatsApp',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: error,
          colorText: Colors.white,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: error,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void _showLogoutDialog(AccountController value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout,
                  color: error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              fontSize: 16,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                value.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
