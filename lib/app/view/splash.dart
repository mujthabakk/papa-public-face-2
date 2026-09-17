import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/splash_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Get.find<SplashController>().initSharedData();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routing());
  }

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription.cancel();
  }

  void _routing() {
    Future(() async {
      try {
        final splash = Get.find<SplashController>();
        final configFuture = splash.getConfigData();
        unawaited(splash.initLocale());
        final isSuccess = await configFuture;
        if (!mounted) return;
        if (isSuccess) {
          Get.offNamed(AppRouter.getInitialRoute());
        } else {
          Get.toNamed(AppRouter.getErrorRoutes());
        }
      } catch (e) {
        debugPrint('Splash routing failed: $e');
        if (!mounted) return;
        Get.toNamed(AppRouter.getErrorRoutes());
      }
    });
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      e;
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    bool isNotConnected = !result.contains(ConnectivityResult.wifi) &&
        !result.contains(ConnectivityResult.mobile);
    if (isNotConnected) {
      showToast('No Internet Connection'.tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (value) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(alignment: AlignmentDirectional.center, children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.translate, color: ThemeProvider.gold),
              onPressed: () => Get.find<LanguagesController>()
                  .showLocaleSettings(initialTab: 0),
            ),
          ),
          const Center(
            child: SizedBox(
              height: 260,
              child: Column(
                children: [
                  Image(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                    height: 250,
                    width: 250,
                    alignment: Alignment.center,
                  ),
                  // Text(
                  //   'PapaBear',
                  //   style: TextStyle(
                  //       fontSize: 21,
                  //       fontWeight: FontWeight.w800,
                  //       color: Color.fromARGB(255, 71, 55, 9)),
                  // )
                ],
              ),
            ),
          ),
          // const Positioned(
          //   top: 100,
          //   child: Image(
          //     image: AssetImage('assets/images/logo_white.png'),
          //     fit: BoxFit.cover,
          //     height: 50,
          //     width: 50,
          //     alignment: Alignment.center,
          //   ), //CircularAvatar
          // ),
          Positioned(
            top: 180,
            child: Center(
              child: Text('PAPA BEAR'.tr,
                style: ThemeProvider.serif(
                    color: ThemeProvider.gold,
                    size: 22,
                    weight: FontWeight.w700,
                    letterSpacing: 3),
              ),
            ),
          ),
          const Positioned(
            bottom: 50,
            child: Center(
              child: CircularProgressIndicator(
                color: ThemeProvider.whiteColor,
              ),
            ), //CircularAvatar
          ),
          Positioned(
            bottom: 20,
            child: Center(
              child: Text(
                'Developed By '.tr + Environments.companyName,
                style: const TextStyle(
                    color: ThemeProvider.whiteColor, fontFamily: 'bold'),
              ),
            ),
          ),
        ]),
      );
    });
  }
}
