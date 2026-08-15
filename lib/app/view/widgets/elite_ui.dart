import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/tabs_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';

class EliteAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onMenu;
  final VoidCallback? onSearch;
  final VoidCallback? onMore;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final bool showBack;
  final String? title;
  final String? leadingLabel;

  const EliteAppBar({
    Key? key,
    this.onMenu,
    this.onSearch,
    this.onMore,
    this.onFavorite,
    this.isFavorite = false,
    this.showBack = false,
    this.title,
    this.leadingLabel,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeProvider.backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: leadingLabel != null ? 110 : 56,
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
          : IconButton(
              icon: Icon(
                showBack ? Icons.arrow_back_ios_new : Icons.menu,
                color: ThemeProvider.gold,
                size: 22,
              ),
              onPressed: showBack
                  ? () => Get.back()
                  : (onMenu ??
                      () {
                        Scaffold.maybeOf(context)?.openDrawer();
                      }),
            ),
      title: Text(
        title ?? 'PAPA BEAR',
        style: ThemeProvider.serif(
          size: 20,
          weight: FontWeight.w700,
          color: ThemeProvider.gold,
          letterSpacing: 2.4,
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
            icon: const Icon(Icons.search, color: ThemeProvider.gold, size: 22),
            onPressed: onSearch,
          ),
        if (onMore != null)
          IconButton(
            icon: const Icon(Icons.more_vert, color: ThemeProvider.gold, size: 22),
            onPressed: onMore,
          ),
      ],
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
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
    this.action = 'SEE ALL',
    this.onAction,
    this.goldTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
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

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Container(
        color: ThemeProvider.surface,
        child: const Center(
          child: CircularProgressIndicator(
            color: ThemeProvider.gold,
            strokeWidth: 2,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/notfound.png',
        fit: fit,
        width: width,
        height: height,
      ),
    );
    if (radius == null) return image;
    return ClipRRect(borderRadius: radius!, child: image);
  }
}

class EliteGoldButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final IconData? icon;

  const EliteGoldButton({
    Key? key,
    required this.label,
    required this.onTap,
    this.outlined = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeProvider.gold,
          minimumSize: const Size(double.infinity, 42),
          side: const BorderSide(color: ThemeProvider.gold),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: icon == null
            ? Text(
                label,
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
                    style: ThemeProvider.sans(
                      size: 11,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
      );
    }
    final child = Text(
      label,
      style: ThemeProvider.sans(
        size: 11,
        weight: FontWeight.w700,
        color: ThemeProvider.blackColor,
        letterSpacing: 0.6,
      ),
    );
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeProvider.gold,
        foregroundColor: ThemeProvider.blackColor,
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
    );
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
                    Get.find<TabsController>().updateTabId(0);
                    Get.toNamed(AppRouter.getCheckoutRoutes());
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
                          child: Text(
                            '$count',
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
    const items = [
      (Icons.home_outlined, 'Home', 0),
      (Icons.location_on_outlined, 'Nearby', 1),
      (Icons.qr_code_2, 'Scan', 2),
      (Icons.grid_view_outlined, 'Categories', 3),
      (Icons.person_outline, 'Profile', 5),
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

String elitePrice(String side, String symbol, num? amount, {int digits = 0}) {
  final v = (amount ?? 0).toStringAsFixed(digits);
  return side == 'left' ? '$symbol$v' : '$v$symbol';
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
          Text(
            '$quantity',
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

class EliteApiUnavailable extends StatelessWidget {
  final double minHeight;

  const EliteApiUnavailable({Key? key, this.minHeight = 72}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Text(
        'API is not available'.tr,
        textAlign: TextAlign.center,
        style: ThemeProvider.sans(
          size: 13,
          color: ThemeProvider.greyColor,
        ),
      ),
    );
  }
}
