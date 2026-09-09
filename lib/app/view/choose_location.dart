import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/choose_location_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseLocationController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 48),
                Text(
                  'PAPA BEAR'.tr,
                  style: ThemeProvider.serif(
                    size: 32,
                    color: ThemeProvider.gold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your location to discover elite wellness nearby.'.tr,
                  textAlign: TextAlign.center,
                  style: ThemeProvider.sans(
                      size: 13, color: ThemeProvider.greyColor),
                ),
                const Spacer(),
                const Icon(Icons.location_on,
                    size: 88, color: ThemeProvider.gold),
                const Spacer(),
                EliteGoldButton(
                  label: 'USE CURRENT LOCATION'.tr,
                  icon: Icons.my_location,
                  onTap: value.getLocation,
                ),
                const SizedBox(height: 12),
                EliteGoldButton(
                  label: 'CHOOSE FROM MAP'.tr,
                  outlined: true,
                  icon: Icons.map_outlined,
                  onTap: value.onChooseLocation,
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      );
    });
  }
}
