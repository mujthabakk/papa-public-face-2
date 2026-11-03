import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Layout breakpoints. APIs stay the same; chrome and density change.
class Desktop {
  static const double tablet = 700;
  static const double desktop = 1024;
  static const double wide = 1400;
  static const double contentMax = 1280;
  static const double sidebarWidth = 232;
  static final ValueNotifier<String> route = ValueNotifier<String>('/');

  static bool isMainShell(String route) =>
      route == '/tabs' || route == '/home';

  static bool hideSiteChrome(String route) {
    const hidden = {
      '/',
      '/splash',
      '/welcome',
      '/login',
      '/register',
      '/reset_password',
      '/choose_location',
      '/find_location',
    };
    return hidden.contains(route);
  }

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
    // Phone-width browsers keep the mobile UI. Everything else on web is desktop.
    if (kIsWeb) return w >= 600;
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

  static double listBottom(BuildContext context) => of(context) ? 28 : 100;

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

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

/// Pass-through. Pages own their own max-width; locking the navigator
/// height was blocking mouse-wheel scroll on web.
class DesktopPageFrame extends StatelessWidget {
  final Widget child;
  const DesktopPageFrame({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}

/// Optional inner content width for list pages that should not stretch.
class DesktopContent extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  const DesktopContent({
    Key? key,
    required this.child,
    this.maxWidth = Desktop.contentMax,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Desktop.of(context)) return child;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
