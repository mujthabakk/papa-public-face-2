import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/choose_location_controller.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:salon_user/app/view/widgets/web_shell.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  Widget _actions(ChooseLocationController value, {required bool desktop}) {
    return Column(
      mainAxisSize: desktop ? MainAxisSize.min : MainAxisSize.max,
      children: [
        if (!desktop) ...[
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
        ],
        Text(
          desktop
              ? 'Choose your location'.tr
              : 'Choose your location to discover elite wellness nearby.'.tr,
          textAlign: TextAlign.center,
          style: ThemeProvider.sans(
            size: desktop ? 22 : 13,
            color: desktop ? Colors.white : ThemeProvider.greyColor,
          ),
        ),
        if (!desktop) const Spacer() else const SizedBox(height: 28),
        if (!desktop) ...[
          const Icon(Icons.location_on, size: 88, color: ThemeProvider.gold),
          const Spacer(),
        ],
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
        if (value.hasLastLocation) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: value.continueLastLocation,
            child: Text(
              'CONTINUE WITH LAST LOCATION'.tr,
              style: ThemeProvider.sans(
                size: 12,
                weight: FontWeight.w700,
                color: ThemeProvider.gold,
              ),
            ),
          ),
        ],
        if (!desktop) const SizedBox(height: 36),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseLocationController>(builder: (value) {
      final desktop = Desktop.of(context);
      if (desktop) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          body: Row(
            children: [
              const Expanded(child: DesktopBrandPane()),
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: 420,
                    child: _actions(value, desktop: true),
                  ),
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
            child: _actions(value, desktop: false),
          ),
        ),
      );
    });
  }
}
