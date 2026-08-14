import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/choose_location_controller.dart';
import 'package:salon_user/app/util/constant.dart';
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.translate, color: ThemeProvider.gold),
              color: ThemeProvider.surface,
              onSelected: (code) {
                Get.updateLocale(Locale(code));
                value.saveLanguage(code);
              },
              itemBuilder: (context) => AppConstants.languages
                  .map((e) => PopupMenuItem<String>(
                        value: e.languageCode,
                        child: Text(e.languageName,
                            style: ThemeProvider.sans(size: 14)),
                      ))
                  .toList(),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  'PAPA BEAR',
                  style: ThemeProvider.serif(
                    size: 32,
                    color: ThemeProvider.gold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose your location to discover elite wellness nearby.',
                  textAlign: TextAlign.center,
                  style: ThemeProvider.sans(
                      size: 13, color: ThemeProvider.greyColor),
                ),
                const Spacer(),
                const Icon(Icons.location_on, size: 88, color: ThemeProvider.gold),
                const Spacer(),
                EliteGoldButton(
                  label: 'USE CURRENT LOCATION',
                  icon: Icons.my_location,
                  onTap: value.getLocation,
                ),
                const SizedBox(height: 12),
                EliteGoldButton(
                  label: 'CHOOSE FROM MAP',
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
