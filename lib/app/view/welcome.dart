import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),
              Text(
                'PAPA BEAR',
                style: ThemeProvider.serif(
                  size: 36,
                  color: ThemeProvider.gold,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Book an Appointment for Salon, Spa & Barber.'.tr,
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                    size: 14, color: ThemeProvider.greyColor),
              ),
              const Spacer(),
              EliteGoldButton(
                label: 'SIGN IN',
                onTap: () => Get.toNamed(AppRouter.getLoginRoute()),
              ),
              const SizedBox(height: 12),
              EliteGoldButton(
                label: 'CREATE ACCOUNT',
                outlined: true,
                onTap: () => Get.toNamed(AppRouter.getRegisterRoute()),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}
