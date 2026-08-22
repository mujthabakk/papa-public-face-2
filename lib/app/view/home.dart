import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
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

  @override
  Widget build(BuildContext context) {
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
                          child: EliteAppBar(
                            onMenu: () =>
                                _scaffoldKey.currentState?.openDrawer(),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                                  padding: const EdgeInsets.only(bottom: 90),
                                  children: [
                                    const SizedBox(height: 8),
                                    EliteSearchBar(
                                      hint: 'Search services...'.tr,
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
                                        : const EliteApiUnavailable(),
                                    EliteSectionHeader(
                                      title: 'Exclusive Offers'.tr,
                                      action: 'VIEW ALL',
                                      onAction: value.onAllOffersList,
                                    ),
                                    value.offersList.isNotEmpty
                                        ? _offers(value)
                                        : const EliteApiUnavailable(),
                                    EliteSectionHeader(
                                      title: 'Featured Centers'.tr,
                                      action: 'VIEW ALL',
                                      onAction: value.onAllOffers,
                                    ),
                                    value.salonList.isNotEmpty
                                        ? _centers(value)
                                        : const EliteApiUnavailable(),
                                    EliteSectionHeader(
                                      title: 'Top Freelancers'.tr,
                                      onAction: value.onAllSpecialist,
                                    ),
                                    value.individualList.isNotEmpty
                                        ? _freelancers(value)
                                        : const EliteApiUnavailable(),
                                    EliteSectionHeader(
                                      title: 'Top Products'.tr,
                                      action: 'VIEW ALL',
                                      onAction: value.onTopProducts,
                                    ),
                                    value.productsList.isNotEmpty
                                        ? _products(value)
                                        : const EliteApiUnavailable(),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value.currencySide == 'left'
                                  ? '${cartController.totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${cartController.totalPrice}'
                                  : '${cartController.totalItemsInCart} ${'Items'.tr} ${cartController.totalPrice}${value.currencySymbol}',
                              style: ThemeProvider.sans(
                                size: 13,
                                weight: FontWeight.w600,
                                color: ThemeProvider.blackColor,
                              ),
                            ),
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
            onTap: () => value.onBanner(
              item.value ?? '',
              '${item.type ?? 0}',
            ),
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
              : '${value.currencySymbol}${(offer.discount ?? 0).toStringAsFixed(0)} OFF';
          return GestureDetector(
            onTap: () => value.claimOffer(offer),
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    discountLabel,
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
                    offer.canBook ? 'BOOK NOW  →' : 'COPY CODE  →',
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
          );
        },
      ),
    );
  }

  Widget _products(HomeController value) {
    return SizedBox(
      height: 268,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.productsList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final p = value.productsList[index];
          return GestureDetector(
            onTap: () => value.onProduct(p.id as int),
            child: Container(
              width: 168,
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
                        width: 168,
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
                          style: ThemeProvider.serif(
                            size: 16,
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
                              'ADD',
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
                              'BOOK NOW',
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
