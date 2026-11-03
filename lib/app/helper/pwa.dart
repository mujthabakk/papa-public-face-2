import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/helper/pwa_stub.dart'
    if (dart.library.js_interop) 'package:salon_user/app/helper/pwa_web.dart';
import 'package:salon_user/app/util/theme.dart';

/// Progressive Web App install helpers. No-ops on native builds.
class Pwa {
  static bool get isWeb => kIsWeb;

  static bool get standalone => pwaStandalone();

  static bool get showInstall => kIsWeb && !pwaStandalone();

  static Future<void> promptInstall() async {
    if (!kIsWeb || pwaStandalone()) return;
    if (pwaCanInstall()) {
      await pwaInstall();
      return;
    }
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    Get.dialog(
      AlertDialog(
        backgroundColor: ThemeProvider.surface,
        title: Text(
          'Install PapaBear'.tr,
          style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
        ),
        content: Text(
          ios
              ? 'Tap Share, then Add to Home Screen.'.tr
              : 'Use your browser menu and choose Install app or Add to Home Screen.'.tr,
          style: ThemeProvider.sans(size: 14, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'.tr,
                style: ThemeProvider.sans(size: 14, color: ThemeProvider.gold)),
          ),
        ],
      ),
    );
  }
}
