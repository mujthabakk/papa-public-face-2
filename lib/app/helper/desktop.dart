import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/theme.dart';

/// Layout breakpoints. APIs stay the same; chrome and density change.
class Desktop {
  static const double tablet = 700;
  static const double desktop = 1024;
  static const double wide = 1400;
  static const double contentMax = 1360;
  static const double sidebarWidth = 232;

  static bool get isDesktopPlatform {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return true;
      default:
        return false;
    }
  }

  static bool of(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    // Web should use the desktop shell on laptops/tablets.
    if (kIsWeb) return w >= tablet;
    return w >= desktop;
  }

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= tablet && w < desktop;
  }

  static bool isWide(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= wide;

  static int productColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1500) return 5;
    if (w >= 1200) return 4;
    if (w >= 800) return 3;
    return 2;
  }

  static int categoryColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 3;
    if (w >= 800) return 2;
    return 1;
  }

  static int salonColumns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1400) return 3;
    if (w >= 1024) return 2;
    return 1;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    if (of(context)) return const EdgeInsets.fromLTRB(28, 12, 28, 28);
    if (isTablet(context)) return const EdgeInsets.fromLTRB(20, 8, 20, 24);
    return const EdgeInsets.fromLTRB(16, 8, 16, 24);
  }

  static SliverGridDelegate productGrid(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: productColumns(context),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: of(context) ? 0.74 : 0.68,
    );
  }

  static SliverGridDelegateWithFixedCrossAxisCount productGridDelegate(
      BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: productColumns(context),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: of(context) ? 0.74 : 0.72,
    );
  }
}

/// Mouse + trackpad scrolling on desktop / web.
class DesktopScrollBehavior extends MaterialScrollBehavior {
  const DesktopScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

/// Centers pushed routes on a wide canvas so phone layouts stay readable.
class DesktopPageFrame extends StatelessWidget {
  final Widget child;
  const DesktopPageFrame({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Desktop.of(context)) return child;
    // Tabs already use a full-width sidebar + content shell.
    if (Get.currentRoute == '/tabs') return child;
    return ColoredBox(
      color: ThemeProvider.backgroundColor,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Desktop.contentMax),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}
