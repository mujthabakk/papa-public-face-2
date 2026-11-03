import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/salon_social_model.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/helper/media_cache.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';

class EliteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onBack;
  final VoidCallback? onSearch;
  final VoidCallback? onMore;
  final VoidCallback? onFavorite;
  final VoidCallback? onLanguage;
  final VoidCallback? onCountry;
  final VoidCallback? onNotification;
  final int notificationCount;
  final bool isFavorite;
  final bool showBack;
  final String? title;
  final String? leadingLabel;

  const EliteAppBar({
    Key? key,
    this.onMenu,
    this.onBack,
    this.onSearch,
    this.onMore,
    this.onFavorite,
    this.onLanguage,
    this.onCountry,
    this.onNotification,
    this.notificationCount = 0,
    this.isFavorite = false,
    this.showBack = false,
    this.title,
    this.leadingLabel,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    // Force LTR so icons keep English positions (menu left / actions right).
    // Translated title text still follows app locale via .tr callers.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppBar(
        backgroundColor: ThemeProvider.backgroundColor,
        elevation: 0,
        centerTitle: !Desktop.of(context),
        automaticallyImplyLeading: false,
        leadingWidth: leadingLabel != null
            ? 110
            : (Desktop.of(context) && !showBack ? 12 : 56),
        leading: leadingLabel != null
            ? TextButton.icon(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: ThemeProvider.gold, size: 16),
                label: Text(
                  leadingLabel!,
                  style: ThemeProvider.sans(
                    size: 11,
                    weight: FontWeight.w700,
                    color: ThemeProvider.gold,
                    letterSpacing: 0.8,
                  ),
                ),
              )
            : (Desktop.of(context) && !showBack
                ? const SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      showBack ? Icons.arrow_back_ios_new : Icons.menu,
                      color: ThemeProvider.gold,
                      size: 22,
                    ),
                    onPressed: showBack
                        ? (onBack ?? () => Get.back())
                        : (onMenu ??
                            () {
                              Scaffold.maybeOf(context)?.openDrawer();
                            }),
                  )),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title ?? 'PAPA BEAR',
            maxLines: 1,
            style: ThemeProvider.serif(
              size: (title ?? 'PAPA BEAR') == 'PAPA BEAR' ? 20 : 17,
              weight: FontWeight.w700,
              color: ThemeProvider.gold,
              letterSpacing: (title ?? 'PAPA BEAR') == 'PAPA BEAR' ? 2.4 : 0.2,
            ),
          ),
        ),
        actions: [
          if (onFavorite != null)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: ThemeProvider.gold,
                size: 22,
              ),
              onPressed: onFavorite,
            ),
          if (onSearch != null)
            IconButton(
              icon:
                  const Icon(Icons.search, color: ThemeProvider.gold, size: 22),
              onPressed: onSearch,
            ),
          if (onNotification != null && !Desktop.of(context))
            IconButton(
              tooltip: 'Notifications'.tr,
              onPressed: onNotification,
              icon: Badge(
                isLabelVisible: notificationCount > 0,
                backgroundColor: ThemeProvider.redColor,
                label: Text(
                  notificationCount > 99 ? '99+' : '$notificationCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: ThemeProvider.gold,
                  size: 24,
                ),
              ),
            ),
          if (onLanguage != null && !Desktop.of(context))
            IconButton(
              tooltip: 'Language'.tr,
              icon: const Icon(Icons.translate,
                  color: ThemeProvider.gold, size: 22),
              onPressed: onLanguage,
            ),
          if (onCountry != null && !Desktop.of(context))
            IconButton(
              tooltip: 'Country/Region'.tr,
              icon: const Icon(Icons.public,
                  color: ThemeProvider.gold, size: 22),
              onPressed: onCountry,
            ),
          if (onMore != null)
            IconButton(
              icon: const Icon(Icons.more_vert,
                  color: ThemeProvider.gold, size: 22),
              onPressed: onMore,
            ),
        ],
      ),
    );
  }
}

class EliteSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;
  final VoidCallback? onFilter;

  const EliteSearchBar({
    Key? key,
    required this.hint,
    required this.onTap,
    this.onFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Desktop.of(context) ? 40 : 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.circular(ThemeProvider.radiusSm),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: ThemeProvider.gold, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hint,
                style: ThemeProvider.sans(
                  size: 13,
                  color: ThemeProvider.greyColor,
                ),
              ),
            ),
            if (onFilter != null)
              GestureDetector(
                onTap: onFilter,
                child: const Icon(Icons.tune, color: ThemeProvider.gold, size: 18),
              ),
          ],
        ),
      ),
    );
  }
}

class EliteSectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onAction;
  final bool goldTitle;

  const EliteSectionHeader({
    Key? key,
    required this.title,
    this.action = 'VIEW ALL',
    this.onAction,
    this.goldTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Desktop.of(context) ? 28 : 16, 22, Desktop.of(context) ? 28 : 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ThemeProvider.serif(
                size: 20,
                weight: FontWeight.w600,
                color: goldTitle ? ThemeProvider.gold : ThemeProvider.whiteColor,
              ),
            ),
          ),
          if (onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action,
                style: ThemeProvider.sans(
                  size: 11,
                  weight: FontWeight.w600,
                  color: ThemeProvider.gold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EliteNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;

  const EliteNetworkImage({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
  }) : super(key: key);

  bool get _isValidUrl {
    final resolved = Environments.mediaUrl(url);
    if (resolved.isEmpty) return false;
    final uri = Uri.tryParse(resolved);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return false;
    // Need a real object key after the host (not just bucket root).
    final path = uri.path.replaceAll('/', '');
    return path.isNotEmpty;
  }

  double? _finite(double? value) =>
      value != null && value.isFinite && value > 0 ? value : null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _finite(width) ??
            (constraints.hasBoundedWidth ? _finite(constraints.maxWidth) : null);
        final h = _finite(height) ??
            (constraints.hasBoundedHeight
                ? _finite(constraints.maxHeight)
                : null);
        Widget child;
        if (!_isValidUrl) {
          child = Image.asset(
            'assets/images/notfound.png',
            fit: fit,
            width: w,
            height: h,
          );
        } else {
          final dpr = MediaQuery.maybeOf(context)?.devicePixelRatio ?? 2;
          final cacheW = w == null
              ? null
              : (w * dpr).round().clamp(64, 1080);
          child = CachedNetworkImage(
            imageUrl: Environments.mediaUrl(url),
            cacheManager: MediaCache.manager,
            cacheKey: Environments.mediaUrl(url),
            width: w,
            height: h,
            memCacheWidth: cacheW,
            fit: fit,
            fadeInDuration: const Duration(milliseconds: 120),
            fadeOutDuration: Duration.zero,
            useOldImageOnUrlChange: true,
            placeholder: (context, url) => ColoredBox(
              color: ThemeProvider.surface,
              child: SizedBox(width: w, height: h),
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/notfound.png',
              fit: fit,
              width: w,
              height: h,
            ),
          );
        }
        if (radius == null) return child;
        return ClipRRect(borderRadius: radius!, child: child);
      },
    );
  }
}

class EliteGoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final bool enabled;
  final bool expand;
  final IconData? icon;

  const EliteGoldButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.enabled = true,
    this.expand = true,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget wrap(Widget button) {
      if (!expand) return button;
      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.hasBoundedWidth) {
            return SizedBox(width: constraints.maxWidth, child: button);
          }
          return button;
        },
      );
    }

    if (outlined) {
      return wrap(OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeProvider.gold,
          minimumSize: const Size(72, 42),
          side: const BorderSide(color: ThemeProvider.gold),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: icon == null
            ? Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ThemeProvider.sans(
                  size: 11,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                  letterSpacing: 0.8,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: ThemeProvider.gold),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.sans(
                      size: 11,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
      ));
    }
    final child = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: ThemeProvider.sans(
        size: 11,
        weight: FontWeight.w700,
        color: enabled ? ThemeProvider.blackColor : ThemeProvider.greyColor,
        letterSpacing: 0.6,
      ),
    );
    return wrap(ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            enabled ? ThemeProvider.gold : const Color(0xFF3A3A3A),
        foregroundColor:
            enabled ? ThemeProvider.blackColor : ThemeProvider.greyColor,
        disabledBackgroundColor: const Color(0xFF3A3A3A),
        disabledForegroundColor: ThemeProvider.greyColor,
        elevation: 0,
        minimumSize: const Size(0, 42),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: icon == null
          ? child
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: ThemeProvider.blackColor),
                const SizedBox(width: 6),
                child,
              ],
            ),
    ));
  }
}

class EliteCartFab extends StatelessWidget {
  const EliteCartFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductCartController>(
      builder: (productCart) {
        return GetBuilder<ServiceCartController>(
          builder: (serviceCart) {
            final count =
                productCart.savedInCart.length + serviceCart.totalItemsInCart;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  if (serviceCart.totalItemsInCart > 0) {
                    if (serviceCart.servicesFrom == 'individual') {
                      Get.toNamed(AppRouter.getIndividualCheckout());
                    } else {
                      Get.delete<CheckoutController>(force: true);
                      Get.toNamed(AppRouter.getCheckoutRoutes());
                    }
                  } else {
                    Get.toNamed(AppRouter.getCartRoutes());
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: ThemeProvider.gold,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    if (count > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          constraints:
                              const BoxConstraints(minWidth: 18, minHeight: 18),
                          decoration: const BoxDecoration(
                            color: ThemeProvider.redColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text('$count',
                            textAlign: TextAlign.center,
                            style: ThemeProvider.sans(
                              size: 9,
                              weight: FontWeight.w700,
                              color: ThemeProvider.whiteColor,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class EliteBottomNav extends StatelessWidget {
  final int tabId;
  final ValueChanged<int> onSelect;

  const EliteBottomNav({
    Key? key,
    required this.tabId,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, 'Home'.tr, 0),
      (Icons.location_on_outlined, 'Nearby'.tr, 1),
      (Icons.qr_code_2, 'Scan'.tr, 2),
      (Icons.shopping_bag_outlined, 'Products'.tr, 3),
      (Icons.person_outline, 'Profile'.tr, 5),
    ];

    return Container(
      color: ThemeProvider.backgroundColor,
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: SafeArea(
        top: false,
        child: Row(
          children: items.map((item) {
            final isCenter = item.$3 == 2;
            final selected = tabId == item.$3;
            if (isCenter) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: ThemeProvider.gold,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: ThemeProvider.appColorShadow,
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.qr_code_2,
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelect(item.$3),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$1,
                      color: selected ? ThemeProvider.gold : Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: ThemeProvider.sans(
                        size: 10,
                        weight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected ? ThemeProvider.gold : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

String elitePrice(String side, String symbol, num? amount, {int digits = 2}) {
  if (AppCurrency.symbol.trim().isEmpty) {
    AppCurrency.apply(symbol: symbol, side: side);
  }
  return AppCurrency.format(amount, digits: digits);
}

class EliteCashbackHint extends StatelessWidget {
  final double percentage;
  final double previewAmount;
  final String currencySide;
  final String currencySymbol;
  final EdgeInsetsGeometry padding;

  const EliteCashbackHint({
    Key? key,
    required this.percentage,
    this.previewAmount = 0,
    this.currencySide = '',
    this.currencySymbol = '',
    this.padding = const EdgeInsets.only(top: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (percentage <= 0) return const SizedBox.shrink();
    final pct = percentage % 1 == 0
        ? percentage.toStringAsFixed(0)
        : percentage.toStringAsFixed(2);
    return Padding(
      padding: padding,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: ThemeProvider.gold.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ThemeProvider.gold.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_balance_wallet_outlined,
                color: ThemeProvider.gold, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get $pct% cashback after service is completed',
                    style: ThemeProvider.sans(
                      size: 12,
                      weight: FontWeight.w600,
                      color: ThemeProvider.gold,
                    ),
                  ),
                  if (previewAmount > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      elitePrice(currencySide, currencySymbol, previewAmount),
                      style: ThemeProvider.sans(
                        size: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EliteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color? borderColor;
  final double radius;

  const EliteCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 14),
    this.borderColor,
    this.radius = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      child: child,
    );
  }
}

class EliteSectionBar extends StatelessWidget {
  final String title;
  final String? trailing;
  final Color titleColor;

  const EliteSectionBar({
    Key? key,
    required this.title,
    this.trailing,
    this.titleColor = ThemeProvider.whiteColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 18,
            margin: const EdgeInsets.only(right: 10),
            color: ThemeProvider.gold,
          ),
          Expanded(
            child: Text(
              title,
              style: ThemeProvider.serif(size: 20, color: titleColor),
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: ThemeProvider.sans(
                size: 11,
                color: ThemeProvider.greyColor,
              ),
            ),
        ],
      ),
    );
  }
}

class EliteQtyStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const EliteQtyStepper({
    Key? key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onMinus,
            icon: const Icon(Icons.remove, size: 16, color: ThemeProvider.gold),
          ),
          Text('$quantity',
            style: ThemeProvider.serif(size: 16, color: ThemeProvider.gold),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onPlus,
            icon: const Icon(Icons.add, size: 16, color: ThemeProvider.gold),
          ),
        ],
      ),
    );
  }
}

double eliteSafeRating(num? rating, {num? reviews}) {
  final value = (rating ?? 0).toDouble();
  final count = (reviews ?? 0).toInt();
  if (count <= 0 || value <= 0 || value > 5) return 0;
  return value;
}

class EliteApiUnavailable extends StatelessWidget {
  final double minHeight;
  final String? title;
  final String? subtitle;
  final IconData? icon;

  const EliteApiUnavailable({
    Key? key,
    this.minHeight = 72,
    this.title,
    this.subtitle,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heading = title ?? 'Data is not available';
    final detail = subtitle ??
        (title == null ? 'Please try again later.' : null);
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 36,
            color: ThemeProvider.gold.withValues(alpha: 0.75),
          ),
          const SizedBox(height: 10),
          Text(
            heading.tr,
            textAlign: TextAlign.center,
            style: ThemeProvider.sans(
              size: 14,
              weight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          if (detail != null && detail.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              detail.tr,
              textAlign: TextAlign.center,
              style: ThemeProvider.sans(
                size: 12,
                color: ThemeProvider.greyColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EliteSheetAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  const EliteSheetAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });
}

void showEliteBottomSheet(
  BuildContext context, {
  required String title,
  required List<EliteSheetAction> actions,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: ThemeProvider.surface,
    barrierColor: Colors.black54,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeProvider.greyColor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              title,
              style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A), height: 1),
            ...actions.map((action) {
              final iconColor = action.destructive
                  ? ThemeProvider.logoutRose
                  : ThemeProvider.gold;
              final textColor =
                  action.destructive ? ThemeProvider.logoutRose : Colors.white;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: action.onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Row(
                      children: [
                        Icon(action.icon, color: iconColor, size: 22),
                        const SizedBox(width: 14),
                        Text(
                          action.label,
                          style: ThemeProvider.sans(
                            size: 15,
                            weight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ),
  );
}

class EliteLoginPromptCard extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;

  const EliteLoginPromptCard({
    Key? key,
    required this.message,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: ThemeProvider.sans(size: 13, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          EliteGoldButton(
            label: 'Sign In / Sign Up'.tr,
            onTap: () {
              if (onTap != null) {
                onTap!();
                return;
              }
              AppRouter.openLogin();
            },
          ),
        ],
      ),
    );
  }
}

class EliteConnectSection extends StatelessWidget {
  final SalonSocialLinks links;
  final VoidCallback onCall;
  final VoidCallback onChat;
  final VoidCallback onWebsite;
  final VoidCallback onInstagram;
  final VoidCallback onYoutube;
  final VoidCallback onFacebook;
  final VoidCallback onWhatsapp;
  final VoidCallback onTwitter;
  final VoidCallback onLinkedin;
  /// When false, Call/Chat/social are hidden and a login CTA is shown.
  final bool isAuthenticated;
  final VoidCallback? onLoginRequired;

  const EliteConnectSection({
    Key? key,
    required this.links,
    required this.onCall,
    required this.onChat,
    required this.onWebsite,
    required this.onInstagram,
    required this.onYoutube,
    required this.onFacebook,
    required this.onWhatsapp,
    required this.onTwitter,
    required this.onLinkedin,
    this.isAuthenticated = true,
    this.onLoginRequired,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAuthenticated) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: EliteLoginPromptCard(
          message: 'Opps, Please Login or Register first!'.tr,
          onTap: onLoginRequired,
        ),
      );
    }

    if (!links.hasConnectActions) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: EliteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EliteSectionBar(title: 'Connect'.tr),
            Row(
              children: [
                Expanded(
                  child: _action(
                    icon: Icons.phone_outlined,
                    label: 'Call'.tr,
                    enabled: links.canCall,
                    onTap: onCall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _action(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chat'.tr,
                    enabled: links.canChat,
                    onTap: onChat,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _action(
                    icon: Icons.language,
                    label: 'Website'.tr,
                    enabled: links.canWebsite,
                    onTap: onWebsite,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
              Text('Social Media'.tr,
                style: ThemeProvider.sans(
                  size: 11,
                  color: ThemeProvider.greyColor,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _social(
                    icon: Icons.camera_alt_outlined,
                    label: 'Instagram'.tr,
                    enabled: links.hasInstagram,
                    onTap: onInstagram,
                  ),
                  _social(
                    icon: Icons.play_circle_outline,
                    label: 'YouTube'.tr,
                    enabled: links.hasYoutube,
                    onTap: onYoutube,
                  ),
                  _social(
                    icon: Icons.facebook_outlined,
                    label: 'Facebook'.tr,
                    enabled: links.hasFacebook,
                    onTap: onFacebook,
                  ),
                  _social(
                    icon: Icons.chat_outlined,
                    label: 'WhatsApp'.tr,
                    enabled: links.hasWhatsapp,
                    onTap: onWhatsapp,
                  ),
                  _social(
                    icon: Icons.alternate_email,
                    label: 'Twitter'.tr,
                    enabled: links.hasTwitter,
                    onTap: onTwitter,
                  ),
                  _social(
                    icon: Icons.business_center_outlined,
                    label: 'LinkedIn'.tr,
                    enabled: links.hasLinkedin,
                    onTap: onLinkedin,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _action({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled
                ? ThemeProvider.gold.withValues(alpha: 0.45)
                : const Color(0xFF2A2A2A),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: enabled ? ThemeProvider.gold : ThemeProvider.greyColor,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: ThemeProvider.sans(
                size: 11,
                weight: FontWeight.w600,
                color: enabled ? Colors.white : ThemeProvider.greyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _social({
    required IconData icon,
    required String label,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.32,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeProvider.gold.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: ThemeProvider.gold),
              const SizedBox(width: 6),
              Text(
                label,
                style: ThemeProvider.sans(size: 11, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two-column inner page for web. Mobile screens must not use this widget.
class WebInnerPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget main;
  final Widget? side;
  final double sideWidth;
  final bool expandMain;

  const WebInnerPage({
    Key? key,
    required this.title,
    required this.main,
    this.subtitle,
    this.side,
    this.sideWidth = 360,
    this.expandMain = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 12, 32, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: ThemeProvider.gold, size: 18),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.serif(
                          size: 28, weight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(left: 48, bottom: 4),
                  child: Text(
                    subtitle!,
                    style: ThemeProvider.sans(
                        size: 13, color: ThemeProvider.greyColor),
                  ),
                ),
              const SizedBox(height: 16),
              Expanded(
                child: side == null
                    ? (expandMain ? main : _webScroll(main, primary: true))
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: expandMain
                                ? main
                                : _webScroll(main, primary: true),
                          ),
                          const SizedBox(width: 28),
                          SizedBox(
                            width: sideWidth,
                            child: _webScroll(side),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _webScroll(Widget? child, {bool primary = false}) {
    return SingleChildScrollView(
      primary: primary,
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      child: child,
    );
  }
}
