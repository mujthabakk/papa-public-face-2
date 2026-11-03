import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:salon_user/app/view/widgets/web_shell.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Widget _actions({required bool desktop}) {
    return Column(
      mainAxisSize: desktop ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (!desktop) ...[
          const Spacer(),
          Text(
            'PAPA BEAR'.tr,
            style: ThemeProvider.serif(
              size: 36,
              color: ThemeProvider.gold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Book an Appointment for Salon, Spa & Barber.'.tr,
          textAlign: TextAlign.center,
          style: ThemeProvider.sans(size: 14, color: ThemeProvider.greyColor),
        ),
        if (!desktop) const Spacer() else const SizedBox(height: 32),
        EliteGoldButton(
          label: 'SIGN IN'.tr,
          onTap: () => Get.toNamed(AppRouter.getLoginRoute()),
        ),
        const SizedBox(height: 12),
        EliteGoldButton(
          label: 'CREATE ACCOUNT'.tr,
          outlined: true,
          onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Get.toNamed(AppRouter.getChooseLocationRoutes()),
          child: Text(
            'Continue as guest'.tr,
            style: ThemeProvider.sans(size: 13, color: ThemeProvider.gold),
          ),
        ),
        if (!desktop) const SizedBox(height: 36),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = Desktop.of(context);
    if (desktop) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        body: Row(
          children: [
            const Expanded(flex: 6, child: DesktopBrandPane()),
            Expanded(
              flex: 5,
              child: Center(
                child: SizedBox(width: 440, child: _actions(desktop: true)),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: _actions(desktop: false),
        ),
      ),
    );
  }
}
