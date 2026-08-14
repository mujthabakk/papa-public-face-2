import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/sidemenu.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:skeletons/skeletons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (value) {
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
                        EliteSearchBar(
                          hint: 'Search services...'.tr,
                          onTap: value.onSearch,
                          onFilter: value.onFilter,
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: _hasAny(value)
                              ? ListView(
                                  padding: const EdgeInsets.only(bottom: 90),
                                  children: [
                                    _hero(value),
                                    if (value.categoriesList.isNotEmpty) ...[
                                      EliteSectionHeader(
                                        title: 'Top Category'.tr,
                                        onAction: value.onAllCategories,
                                      ),
                                      _categories(value),
                                    ],
                                    if (value.individualList.isNotEmpty) ...[
                                      EliteSectionHeader(
                                        title: 'Top Freelancers'.tr,
                                        onAction: value.onAllSpecialist,
                                      ),
                                      _freelancers(value),
                                    ],
                                    if (value.productsList.isNotEmpty) ...[
                                      EliteSectionHeader(
                                        title: 'Exclusive Offers'.tr,
                                        action: 'VIEW ALL',
                                        onAction: value.onTopProducts,
                                      ),
                                      _offers(value),
                                    ],
                                    if (value.salonList.isNotEmpty) ...[
                                      EliteSectionHeader(
                                        title: 'Featured Centers'.tr,
                                        onAction: value.onAllOffers,
                                      ),
                                      ..._centers(value),
                                    ],
                                  ],
                                )
                              : _empty(),
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

  bool _hasAny(HomeController value) {
    return value.bannerList.isNotEmpty ||
        value.categoriesList.isNotEmpty ||
        value.individualList.isNotEmpty ||
        value.productsList.isNotEmpty ||
        value.salonList.isNotEmpty;
  }

  Widget _hero(HomeController value) {
    if (value.bannerList.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 210,
          viewportFraction: 1,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
        ),
        items: value.bannerList.map((banner) {
          return GestureDetector(
            onTap: () => value.onBanner(
                banner.value.toString(), banner.type.toString()),
            child: Stack(
              fit: StackFit.expand,
              children: [
                EliteNetworkImage(
                  url: '${Environments.imageURL}${banner.cover}',
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                if ((banner.title ?? '').toString().isNotEmpty ||
                    (banner.extraField ?? '').toString().isNotEmpty)
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((banner.title ?? '').toString().isNotEmpty)
                          Text(
                            banner.title.toString(),
                            style: ThemeProvider.serif(
                                size: 26, weight: FontWeight.w700),
                          ),
                        if ((banner.extraField ?? '').toString().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            banner.extraField.toString(),
                            style: ThemeProvider.sans(
                                size: 12, color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _categories(HomeController value) {
    return SizedBox(
      height: 118,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: value.categoriesList.length,
        itemBuilder: (context, index) {
          final item = value.categoriesList[index];
          return GestureDetector(
            onTap: () =>
                value.onCategoriesList(item.id as int, item.name.toString()),
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
                      padding: const EdgeInsets.all(14),
                      child: EliteNetworkImage(
                        url: '${Environments.imageURL}${item.cover}',
                        radius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (item.name ?? '').toUpperCase(),
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
        },
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
    if (value.productsList.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: value.productsList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final product = value.productsList[index];
          return GestureDetector(
            onTap: () => value.onProduct(product.id as int),
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
                  if ((product.discount ?? 0) > 0)
                    Text(
                      '${product.discount!.toStringAsFixed(0)}% OFF',
                      style: ThemeProvider.sans(
                        size: 22,
                        weight: FontWeight.w800,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  if ((product.discount ?? 0) > 0) const SizedBox(height: 4),
                  Text(
                    product.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.serif(size: 18),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => value.addToCart(index),
                    child: Text(
                      'CLAIM NOW  →',
                      style: ThemeProvider.sans(
                        size: 12,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                        letterSpacing: 0.8,
                      ),
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

  List<Widget> _centers(HomeController value) {
    return value.salonList.map((item) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: GestureDetector(
          onTap: () => value.onServices(item.uid as int),
          child: Container(
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
                      height: 170,
                      width: double.infinity,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
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
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeProvider.serif(size: 18),
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
                                      size: 12,
                                      color: ThemeProvider.greyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      EliteGoldButton(
                        label: 'BOOK NOW',
                        onTap: () => value.onServices(item.uid as int),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no-data.png', height: 80, width: 80),
          const SizedBox(height: 20),
          Text(
            'No Data Found Near You!'.tr,
            style: ThemeProvider.serif(size: 16, color: ThemeProvider.gold),
          ),
        ],
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
