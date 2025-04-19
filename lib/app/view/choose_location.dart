import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/choose_location_controller.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';

class ChooseLocationScreen extends StatefulWidget {
  const ChooseLocationScreen({Key? key}) : super(key: key);

  @override
  State<ChooseLocationScreen> createState() => _ChooseLocationScreenState();
}

class _ChooseLocationScreenState extends State<ChooseLocationScreen> {
  Widget getLanguages() {
    return PopupMenuButton(
      onSelected: (value) {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Icon(
          Icons.translate,
          color: ThemeProvider.appColor,
          size: 28,
        ),
      ),
      itemBuilder: (context) => AppConstants.languages
          .map((e) => PopupMenuItem<String>(
                value: e.languageCode.toString(),
                onTap: () {
                  var locale = Locale(e.languageCode.toString());
                  Get.updateLocale(locale);
                  Get.find<ChooseLocationController>()
                      .saveLanguage(e.languageCode);
                },
                child: Text(
                  e.languageName.toString(),
                  style: const TextStyle(
                    fontFamily: 'regular',
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChooseLocationController>(builder: (value) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // actions: [getLanguages()],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 11, 11, 11), // Light grayish-blue
                Color.fromARGB(255, 30, 30, 30), // Slightly darker shade
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ListView(
                //  mainAxisAlignment: MainAxisAlignment.center,
                //  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'PapaBear',
                  //   style: TextStyle(
                  //     fontSize: 36,
                  //     fontFamily: 'regular',
                  //     color: Colors.grey[700],
                  //     letterSpacing: 0.5,
                  //   ),
                  // ),
                  SizedBox(
                      height: 300,
                      child: Image.asset('assets/images/logo_gold.png')),
                  //const Spacer(flex: 1),
                  // Text(
                  //   'Access Your'.tr,
                  //   style: const TextStyle(
                  //     fontSize: 18,
                  //     fontFamily: 'regular',
                  //     color: Color.fromARGB(255, 217, 217, 217),
                  //     letterSpacing: 0.5,
                  //   ),
                  // ),
                  // const SizedBox(height: 0),
                  // Text(
                  //   'Location'.tr,
                  //   style: const TextStyle(
                  //     fontSize: 28,
                  //     fontFamily: 'bold',
                  //     color: Color.fromARGB(255, 198, 169, 42),
                  //     letterSpacing: 1.2,
                  //     shadows: [
                  //       Shadow(
                  //         color: Colors
                  //             .black26, // Shadow color (semi-transparent black)
                  //         offset: Offset(2, 2), // Shadow position (x, y)
                  //         blurRadius: 4, // Shadow blur radius
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/1.png',
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        value.getLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: ThemeProvider.whiteColor,
                        minimumSize: const Size(240, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        shadowColor: ThemeProvider.appColor.withOpacity(0.4),
                      ),
                      child: Text(
                        'USE CURRENT LOCATION'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'bold',
                          letterSpacing: 1.5,
                          color: ThemeProvider.blackColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        value.onChooseLocation();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeProvider.appColor,
                        minimumSize: const Size(250, 45),
                        side: const BorderSide(
                          color: ThemeProvider.whiteColor,
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        'CHOOSE LOCATION'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'semi-bold',
                          letterSpacing: 1.5,
                          color: ThemeProvider.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60), // or whatever space you want
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
