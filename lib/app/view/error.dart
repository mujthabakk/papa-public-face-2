/*Papabear*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);
  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeProvider.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 1,
          width: double.infinity,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 220,
                    width: 220,
                    child: Image.asset(
                      "assets/images/error.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Connection Failed'.tr,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.serif(
                      size: 22,
                      color: ThemeProvider.gold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Could not connect to network'.tr,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.sans(
                      size: 14,
                      color: ThemeProvider.whiteColor,
                    ),
                  ),
                  Text(
                    'Please check and try again'.tr,
                    textAlign: TextAlign.center,
                    style: ThemeProvider.sans(
                      size: 13,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(46),
                      ),
                      onPressed: () {
                        // Retry splash boot, not tabs (tabs need settings).
                        Get.offAllNamed(AppRouter.getSplashRoute());
                      },
                      child: Text(
                        "retry".tr.toUpperCase(),
                        style: ThemeProvider.sans(
                          size: 13,
                          weight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
