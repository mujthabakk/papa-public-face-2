import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/view/widgets/web_shell.dart';
import 'package:salon_user/app/helper/init.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/translator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salon_user/app/util/facebook_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _ignoreSimulatorEscapeKeyGlitch();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: ThemeProvider.backgroundColor,
    statusBarIconBrightness: Brightness.light,
  ));
  await dotenv.load(fileName: '.env');
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  await FacebookService.init();
  await MainBinding().dependencies();
  runApp(const MyApp());
}

/// iOS Simulator / macOS keyboard sends Escape KeyUp without KeyDown.
/// Flutter debug then asserts in HardwareKeyboard. Harmless; swallow it.
void _ignoreSimulatorEscapeKeyGlitch() {
  bool isKeyUpGlitch(Object error) {
    final text = error.toString();
    return text.contains('A KeyUpEvent is dispatched') ||
        text.contains('_pressedKeys.containsKey(event.physicalKey)');
  }

  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    if (isKeyUpGlitch(details.exception)) {
      HardwareKeyboard.instance.clearState();
      return;
    }
    previous?.call(details);
  };
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<ServiceCartController>()) {
      Get.find<ServiceCartController>().getCart();
    }
    if (Get.isRegistered<ProductCartController>()) {
      Get.find<ProductCartController>().getCart();
    }
    return ScreenUtilInit(
      designSize: kIsWeb ? const Size(1440, 900) : const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetBuilder<LanguagesController>(
          builder: (localeCtrl) {
            return GetMaterialApp(
              theme: dark,
              title: AppConstants.appName,
              color: ThemeProvider.gold,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              initialRoute: AppRouter.splash,
              getPages: AppRouter.routes,
              defaultTransition: Desktop.isDesktopPlatform
                  ? Transition.fadeIn
                  : Transition.native,
              scrollBehavior: const DesktopScrollBehavior(),
              routingCallback: (routing) {
                final name = routing?.current ?? '';
                if (name.isEmpty || Desktop.route.value == name) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (Desktop.route.value != name) {
                    Desktop.route.value = name;
                  }
                });
              },
              translations: LocaleString(),
              locale: localeCtrl.appLocale,
              fallbackLocale: const Locale('en', 'US'),
              builder: (context, child) {
                // Keep English layout positions (menu left, actions right).
                // Only locale/text changes with preferred_language.
                final page = child ?? const SizedBox.shrink();
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: DefaultTextStyle(
                    style: ThemeProvider.sans(size: 14),
                    child: ValueListenableBuilder<String>(
                      valueListenable: Desktop.route,
                      builder: (_, route, __) => WebShell(
                        route: route,
                        child: page,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
