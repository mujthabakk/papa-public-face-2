import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (lang) {
        final account = Get.isRegistered<AccountController>()
            ? Get.find<AccountController>()
            : null;
        final selected = AppConstants.languages.firstWhere(
          (e) => e.languageCode == lang.languageCode,
          orElse: () => AppConstants.languages.first,
        );
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(showBack: true, title: 'PAPA BEAR'),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              if (account != null && account.parser.haveLoggedIn())
                EliteCard(
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeProvider.gold),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: EliteNetworkImage(
                            url: '${Environments.imageURL}${account.cover}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${account.firstName} ${account.lastName}',
                              style: ThemeProvider.serif(size: 20),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              account.email,
                              style: ThemeProvider.sans(
                                  size: 12, color: ThemeProvider.greyColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              _header('PREFERENCES'),
              EliteCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _row(
                      Icons.public,
                      'Language',
                      trailingText: selected.languageName,
                      onTap: () => _pickLanguage(lang),
                    ),
                    const Divider(height: 1, color: Color(0xFF2C2C2C)),
                    _row(
                      Icons.public,
                      'Country/Region',
                      trailingText: selected.countryCode,
                    ),
                  ],
                ),
              ),
              _header('APP SETTINGS'),
              EliteCard(
                padding: EdgeInsets.zero,
                child:                     _row(
                      Icons.notifications_none,
                      'Notifications',
                      onTap: () =>
                          Get.toNamed(AppRouter.getNotificatinRoutes()),
                    ),
              ),
              _header('INFORMATION'),
              EliteCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _row(
                      Icons.description_outlined,
                      'Terms of Service',
                      trailing: const Icon(Icons.open_in_new,
                          size: 16, color: ThemeProvider.greyColor),
                      onTap: () => account?.onAppPages(
                          'Terms & Conditions'.tr, '3'),
                    ),
                    const Divider(height: 1, color: Color(0xFF2C2C2C)),
                    _row(
                      Icons.shield_outlined,
                      'Privacy Policy',
                      trailing: const Icon(Icons.open_in_new,
                          size: 16, color: ThemeProvider.greyColor),
                      onTap: () =>
                          account?.onAppPages('Privacy Policy'.tr, '2'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              if (account != null && account.parser.haveLoggedIn())
                OutlinedButton(
                  onPressed: () => _logout(account),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: const BorderSide(color: ThemeProvider.logoutRose),
                    foregroundColor: ThemeProvider.logoutRose,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'TERMINATE SESSION',
                    style: ThemeProvider.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: ThemeProvider.logoutRose,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              Text(
                'Version ${AppConstants.appName} • 1.0.12',
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                    size: 11, color: ThemeProvider.greyColor),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        text,
        style: ThemeProvider.sans(
          size: 11,
          weight: FontWeight.w700,
          color: ThemeProvider.greyColor,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _row(
    IconData icon,
    String label, {
    String? trailingText,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: ThemeProvider.gold),
      title: Text(label, style: ThemeProvider.sans(size: 14)),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null)
                Text(
                  trailingText,
                  style: ThemeProvider.sans(
                      size: 13, color: ThemeProvider.gold),
                ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right,
                  color: ThemeProvider.greyColor, size: 18),
            ],
          ),
    );
  }

  void _pickLanguage(LanguagesController lang) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Language', style: ThemeProvider.serif(size: 18)),
            const SizedBox(height: 8),
            ...AppConstants.languages.map(
              (l) => RadioListTile<String>(
                value: l.languageCode,
                groupValue: lang.languageCode,
                activeColor: ThemeProvider.gold,
                title: Text(l.languageName, style: ThemeProvider.sans()),
                onChanged: (code) {
                  if (code != null) lang.saveLanguages(code);
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(AccountController value) {
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
            child: const Text('TERMINATE SESSION'),
          ),
        ],
      ),
    );
  }
}
