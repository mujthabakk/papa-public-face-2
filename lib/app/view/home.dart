import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/controller/common_notification_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/desktop.dart';
import 'package:salon_user/app/helper/home_sections.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/sidemenu.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:salon_user/app/view/widgets/spin_win_dialog.dart';
import 'package:skeletons/skeletons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _spinShown = false;

  String _hiName() {
    if (!Get.isRegistered<SharedPreferencesManager>()) return 'Hi';
    final prefs = Get.find<SharedPreferencesManager>();
    final name =
        '${prefs.getString('first_name') ?? ''} ${prefs.getString('last_name') ?? ''}'
            .trim();
    if (name.isEmpty) return 'Hi';
    return 'Hi $name';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LanguagesController>(
      builder: (_) {
        return GetBuilder<HomeController>(
          builder: (value) {
            if (value.apiCalled && !_spinShown) {
              _spinShown = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) checkAndShowSpinWinDialog();
              });
            }
            return Scaffold(
              key: _scaffoldKey,
              backgroundColor: ThemeProvider.backgroundColor,
              drawer: const SideMenuScreen(),
              body: value.apiCalled == false
                  ? _buildSkeleton()
                  : Column(
                      children: [
                        SafeArea(
                          bottom: false,
                          child: GetBuilder<CommonNotificationController>(
                            builder: (notify) => EliteAppBar(
                              title: _hiName(),
                              onMenu: () =>
                                  _scaffoldKey.currentState?.openDrawer(),
                              onNotification: () => Get.toNamed(
                                  AppRouter.getNotificatinRoutes()),
                              notificationCount: notify.unreadCount,
                              onLanguage: () => Get.find<LanguagesController>()
                                  .showLanguagePicker(),
                              onCountry: () => Get.find<LanguagesController>()
                                  .showCountryPicker(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                                  padding: const EdgeInsets.only(bottom: 90),
                                  children: [
                                    const SizedBox(height: 8),
                                    EliteSearchBar(
                                      hint: 'Search shops, freelancers, services...'.tr,
                                      onTap: value.onSearch,
                                      onFilter: value.onFilter,
                                    ),
                                    const SizedBox(height: 12),
                                    value.bannerList.isNotEmpty
                                        ? _banners(value)
                                        : const SizedBox.shrink(),
                                    EliteSectionHeader(
                                      title: 'Top Category'.tr,
                                      onAction: value.onAllCategories,
                                    ),
                                    (value.timedOffers.isNotEmpty ||
                                            value.categoriesList.isNotEmpty)
                                        ? _categoryRow(value)
                                        : const EliteApiUnavailable(
                                            title: 'No categories yet',
                                            icon: Icons.grid_view_outlined,
                                          ),
                                    EliteSectionHeader(
                                      title: 'Exclusive Offers'.tr,
                                      action: 'VIEW ALL'.tr,
                                      onAction: value.onAllOffersList,
                                    ),
                                    value.offersList.isNotEmpty
                                        ? _offers(value)
                                        : const EliteApiUnavailable(
                                            title: 'No offers right now',
                                            subtitle:
                                                'Check back soon for new deals.',
                                            icon: Icons.local_offer_outlined,
                                          ),
                                    if (HomeSections.showPartners) ...[
                                      EliteSectionHeader(
                                        title: 'Featured Centers'.tr,
                                        action: 'VIEW ALL'.tr,
                                        onAction: value.onAllOffers,
                                      ),
                                      value.salonList.isNotEmpty
                                          ? _centers(value)
                                          : const EliteApiUnavailable(
                                              title: 'No centers nearby',
                                              icon: Icons.storefront_outlined,
                                            ),
                                    ],
                                    if (HomeSections.showFreelancers) ...[
                                      EliteSectionHeader(
                                        title: 'Top Freelancers'.tr,
                                        onAction: value.onAllSpecialist,
                                      ),
                                      value.individualList.isNotEmpty
                                          ? _freelancers(value)
                                          : const EliteApiUnavailable(
                                              title: 'No experts nearby',
                                              icon: Icons.person_outline,
                                            ),
                                    ],
                                    if (HomeSections.showProducts) ...[
                                      EliteSectionHeader(
                                        title: 'Top Products'.tr,
                                        action: 'VIEW ALL'.tr,
                                        onAction: value.onTopProducts,
                                      ),
                                      value.productsList.isNotEmpty
                                          ? _products(value)
                                          : const EliteApiUnavailable(
                                              title: 'No products yet',
                                              icon: Icons.shopping_bag_outlined,
                                            ),
                                      if (value.productSellers.isNotEmpty) ...[
                                        EliteSectionHeader(
                                          title: 'Stores'.tr,
                                          action: 'VIEW ALL'.tr,
                                          onAction: value.onProductStores,
                                        ),
                                        _productStores(value),
                                      ],
                                    ],
                                    if (HomeSections.showPartners &&
                                        value.topPartners.isNotEmpty) ...[
                                      EliteSectionHeader(
                                        title: 'Top Partners'.tr,
                                      ),
                                      _topPartners(value),
                                    ],
                                  ],
                                ),
                        ),
                      ],
                    ),
              bottomNavigationBar: GetBuilder<ServiceCartController>(
                builder: (cartController) {
                  if (cartController.totalItemsInCart <= 0) {
                    return const SizedBox.shrink();
                  }
                  return SafeArea(
                    child: InkWell(
                      onTap: value.onCheckout,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: ThemeProvider.gold,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${cartController.totalItemsInCart} ${cartController.totalItemsInCart == 1 ? 'Item'.tr : 'Items'.tr}  ${'Pay Amount'.tr} ${elitePrice(value.currencySide, value.currencySymbol, cartController.totalPrice, digits: 2)}',
                                  maxLines: 1,
                                  style: ThemeProvider.sans(
                                    size: 13,
                                    weight: FontWeight.w600,
                                    color: ThemeProvider.blackColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Book Services'.tr,
                              style: ThemeProvider.sans(
                                size: 13,
                                weight: FontWeight.w700,
                                color: ThemeProvider.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _banners(HomeController value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: CarouselSlider.builder(
        itemCount: value.bannerList.length,
        itemBuilder: (context, index, realIndex) {
          final item = value.bannerList[index];
          final cover = item.cover ?? '';
          final url = cover.startsWith('http://') || cover.startsWith('https://')
              ? cover
              : '${Environments.imageURL}$cover';
          return GestureDetector(
            onTap: () => value.onBannerItem(item),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: EliteNetworkImage(
                url: url,
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 160,
          viewportFraction: 1,
          autoPlay: value.bannerList.length > 1,
          autoPlayInterval: const Duration(seconds: 4),
          enlargeCenterPage: false,
        ),
      ),
    );
  }

  Widget _categoryRow(HomeController value) {
    final timed = value.timedOffers;
    final cats = value.categoriesList;
    final total = timed.length + cats.length;
    return SizedBox(
      height: 118,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: total,
        itemBuilder: (context, index) {
          if (index < timed.length) {
            final item = timed[index];
            return _categoryIcon(
              name: item.name ?? '',
              cover: item.image ?? '',
              onTap: () => value.onTimedOffer(item),
            );
          }
          final item = cats[index - timed.length];
          return _categoryIcon(
            name: item.name ?? '',
            cover: item.cover ?? '',
            onTap: () =>
                value.onCategoriesList(item.id as int, item.name.toString()),
          );
        },
      ),
    );
  }

  Widget _categoryIcon({
    required String name,
    required String cover,
    required VoidCallback onTap,
  }) {
    final url = cover.startsWith('http://') || cover.startsWith('https://')
        ? cover
        : '${Environments.imageURL}$cover';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            Container(
              height: 78,
              width: 78,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ThemeProvider.gold, width: 0.6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: EliteNetworkImage(
                  url: url,
                  radius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: ThemeProvider.sans(
                size: 9,
                weight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _freelancers(HomeController value) {
    return SizedBox(
      height: 168,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: value.individualList.length,
        itemBuilder: (context, index) {
          final item = value.individualList[index];
          final name =
              '${item.userInfo?.firstName ?? ''} ${item.userInfo?.lastName ?? ''}'
                  .trim();
          return GestureDetector(
            onTap: () => value.onSpecialist(item.uid as int),
            child: Container(
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EliteNetworkImage(
                    url:
                        '${Environments.imageURL}${item.userInfo?.cover ?? ''}',
                    height: 110,
                    width: 110,
                    radius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.sans(
                      size: 11,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _offers(HomeController value) {
    if (value.offersList.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.offersList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final offer = value.offersList[index];
          final isPercent = offer.type == 1;
          final discountLabel = isPercent
              ? '${(offer.discount ?? 0).toStringAsFixed(0)}% OFF'
              : '${elitePrice(value.currencySide, value.currencySymbol, offer.discount, digits: 0)} OFF';
          final imageUrl = Environments.mediaUrl(offer.coverPath);
          return GestureDetector(
            onTap: () => value.openExclusiveOffer(offer),
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    EliteNetworkImage(
                      url: imageUrl,
                      width: 280,
                      height: 150,
                      radius: BorderRadius.circular(14),
                    ),
                  if (imageUrl.isNotEmpty)
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x99000000),
                            Color(0xCC000000),
                          ],
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discountLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.sans(
                            size: 22,
                            weight: FontWeight.w800,
                            color: ThemeProvider.gold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.serif(size: 18),
                        ),
                        if ((offer.shortDescriptions ?? '').isNotEmpty)
                          Text(
                            offer.shortDescriptions!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.sans(
                              size: 12,
                              color: Colors.white70,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          'VIEW DETAILS  →'.tr,
                          style: ThemeProvider.sans(
                            size: 12,
                            weight: FontWeight.w700,
                            color: ThemeProvider.gold,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _productStores(HomeController value) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.productSellers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final s = value.productSellers[i];
          return GestureDetector(
            onTap: () => value.onProductSeller(s),
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: EliteNetworkImage(
                      url: Environments.mediaUrl(s.cover),
                      width: 72,
                      height: 72,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.serif(size: 14),
                        ),
                        if ((s.address ?? '').isNotEmpty)
                          Text(
                            s.address!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.sans(
                              size: 11,
                              color: ThemeProvider.greyColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _products(HomeController value) {
    Widget card(int index, {required double width}) {
      final p = value.productsList[index];
      return GestureDetector(
            onTap: () => value.onProduct(p.id as int),
            child: Container(
              width: width,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EliteNetworkImage(
                        url: '${Environments.imageURL}${p.cover}',
                        height: 120,
                        width: width,
                      ),
                      if ((p.discount ?? 0) > 0)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: ThemeProvider.gold,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${p.discount!.toStringAsFixed(0)}% OFF',
                              style: ThemeProvider.sans(
                                size: 10,
                                weight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.serif(size: 14),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 12, color: ThemeProvider.gold),
                            const SizedBox(width: 4),
                            Text(
                              '${(p.rating ?? 0).toStringAsFixed(1)} (${p.totalRating ?? 0})',
                              style: ThemeProvider.sans(
                                size: 11,
                                color: ThemeProvider.greyColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if ((p.originalPrice ?? 0) > (p.sellPrice ?? 0))
                          Text(
                            elitePrice(value.currencySide, value.currencySymbol,
                                p.originalPrice, digits: 0),
                            style: ThemeProvider.sans(
                              size: 11,
                              color: ThemeProvider.greyColor,
                            ).copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        Text(
                          elitePrice(value.currencySide, value.currencySymbol,
                              p.sellPrice ?? p.originalPrice, digits: 0),
                          style: ThemeProvider.price(
                            size: 14,
                            weight: FontWeight.w700,
                            color: ThemeProvider.gold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => value.addToCart(index),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.gold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'ADD'.tr,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    if (Desktop.of(context)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.productsList.length,
          gridDelegate: Desktop.productGridDelegate(context),
          itemBuilder: (_, i) => card(i, width: double.infinity),
        ),
      );
    }

    return SizedBox(
      height: 268,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.productsList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => card(index, width: 168),
      ),
    );
  }

  Widget _centers(HomeController value) {
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.salonList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = value.salonList[index];
          return GestureDetector(
            onTap: () => value.onServices(item.uid as int),
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EliteNetworkImage(
                        url: '${Environments.imageURL}${item.cover}',
                        height: 140,
                        width: 260,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: ThemeProvider.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                (item.rating ?? 0).toStringAsFixed(1),
                                style: ThemeProvider.sans(
                                    size: 12, weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.serif(size: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: ThemeProvider.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.address ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeProvider.sans(
                                  size: 11,
                                  color: ThemeProvider.greyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: () =>
                                value.onServices(item.uid as int),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.gold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'BOOK NOW'.tr,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topPartners(HomeController value) {
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.topPartners.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = value.topPartners[index];
          final cover = item.cover ?? '';
          final imageUrl = cover.startsWith('http')
              ? cover
              : '${Environments.imageURL}$cover';
          final distance = item.distance;
          return GestureDetector(
            onTap: () => value.onTopPartner(item),
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      EliteNetworkImage(
                        url: imageUrl,
                        height: 140,
                        width: 260,
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star,
                                  color: ThemeProvider.gold, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                (item.rating ?? 0).toStringAsFixed(1),
                                style: ThemeProvider.sans(
                                    size: 12, weight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.serif(size: 16),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                color: ThemeProvider.gold, size: 14),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.city?.isNotEmpty == true
                                    ? item.city!
                                    : (item.address ?? ''),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeProvider.sans(
                                  size: 11,
                                  color: ThemeProvider.greyColor,
                                ),
                              ),
                            ),
                            if (distance != null && distance > 0)
                              Text(
                                '${distance.toStringAsFixed(1)} km',
                                style: ThemeProvider.sans(
                                  size: 10,
                                  weight: FontWeight.w600,
                                  color: ThemeProvider.gold,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 34,
                          child: ElevatedButton(
                            onPressed: () => value.onTopPartner(item),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeProvider.gold,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'VIEW'.tr,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w700,
                                color: Colors.black,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            SkeletonLine(
              style: SkeletonLineStyle(height: 200, width: double.infinity),
            ),
            const SizedBox(height: 20),
            SkeletonParagraph(),
          ],
        ),
      ),
    );
  }
}
