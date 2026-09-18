import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/packages_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';
import 'package:salon_user/app/view/imageviewer.dart';

class PackagesDetailsScreen extends StatefulWidget {
  const PackagesDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PackagesDetailsScreen> createState() => _PackagesDetailsScreenState();
}

class _PackagesDetailsScreenState extends State<PackagesDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool lastStatus = true;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PackagesDetailsController>(
      builder: (controller) {
        if (!controller.apiCalled) {
          return const Scaffold(
            backgroundColor: ThemeProvider.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(color: ThemeProvider.gold),
            ),
          );
        }

        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: ThemeProvider.backgroundColor,
                pinned: true,
                expandedHeight: 250.0,
                iconTheme: const IconThemeData(color: ThemeProvider.gold),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: ThemeProvider.gold),
                  onPressed: controller.onBack,
                ),
                title: Text(
                  'Packages Details'.tr,
                  style: ThemeProvider.serif(
                    size: 18,
                    color: ThemeProvider.gold,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        '${Environments.imageURL}${controller.packagesDetails.cover}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/notfound.png',
                                fit: BoxFit.cover),
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black87, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                Text(
                  controller.packagesDetails.name ?? '',
                  style: ThemeProvider.serif(
                    size: 24,
                    color: ThemeProvider.gold,
                  ),
                ),
                const SizedBox(height: 16),
                _sectionTitle('Services Included'.tr, Icons.spa_outlined),
                EliteCard(child: _servicesList(controller)),
                const SizedBox(height: 16),
                _sectionTitle('Specialist'.tr, Icons.people_alt_outlined),
                EliteCard(child: _specialistList(controller)),
                const SizedBox(height: 16),
                _sectionTitle('Package Details'.tr, Icons.info_outline),
                EliteCard(child: _packageMeta(controller)),
                if ((controller.packagesDetails.descriptions ?? '')
                    .isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('About'.tr, Icons.description_outlined),
                  EliteCard(
                    child: Text(
                      controller.packagesDetails.descriptions ?? '',
                      style: ThemeProvider.sans(
                        size: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
                if (controller.gallery.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('Photos'.tr, Icons.photo_library_outlined),
                  _gallery(controller),
                ],
              ],
            ),
          ),
          bottomNavigationBar: _bottomBar(controller),
        );
      },
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: ThemeProvider.gold),
          const SizedBox(width: 8),
          Text(
            title,
            style: ThemeProvider.sans(
              size: 12,
              weight: FontWeight.w700,
              color: ThemeProvider.gold,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _packageMeta(PackagesDetailsController controller) {
    return Column(
      children: [
        _metaRow(
          Icons.assignment_outlined,
          controller.packagesDetails.name ?? '',
        ),
        const SizedBox(height: 10),
        _metaRow(
          Icons.timer_outlined,
          '${controller.packagesDetails.duration ?? 0} min',
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ThemeProvider.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              const Icon(Icons.payments_outlined,
                  color: ThemeProvider.gold, size: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if ((controller.packagesDetails.price ?? 0) >
                      (controller.packagesDetails.off ?? 0))
                    Text(
                      elitePrice(
                          controller.currencySide,
                          controller.currencySymbol,
                          controller.packagesDetails.price,
                          digits: 2),
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                  Text(
                    elitePrice(
                        controller.currencySide,
                        controller.currencySymbol,
                        (controller.packagesDetails.off ?? 0) > 0
                            ? controller.packagesDetails.off
                            : controller.packagesDetails.price,
                        digits: 2),
                    style: ThemeProvider.price(
                      size: 18,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metaRow(IconData icon, String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          Icon(icon, color: ThemeProvider.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: ThemeProvider.sans(size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _servicesList(PackagesDetailsController controller) {
    final services = controller.packagesDetails.services ?? [];
    return Column(
      children: services.map((service) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(Icons.spa_outlined,
                  color: ThemeProvider.gold, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  service.name ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.sans(size: 14, color: Colors.white),
                ),
              ),
              _genderIcon(service.gender),
              const SizedBox(width: 8),
              Text(
                elitePrice(controller.currencySide, controller.currencySymbol,
                    service.price,
                    digits: 2),
                style: ThemeProvider.price(
                  size: 13,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _genderIcon(int? gender) {
    if (gender == null) return const SizedBox.shrink();
    switch (gender) {
      case 0:
        return const Icon(Icons.child_care, size: 16, color: ThemeProvider.gold);
      case 1:
        return const Icon(Icons.male, size: 16, color: ThemeProvider.gold);
      case 2:
        return const Icon(Icons.female, size: 16, color: ThemeProvider.gold);
      default:
        return const Icon(Icons.group, size: 16, color: ThemeProvider.gold);
    }
  }

  Widget _specialistList(PackagesDetailsController controller) {
    final specialists = controller.packagesDetails.specialist ?? [];
    if (specialists.isEmpty) {
      return Text('No specialist listed'.tr,
          style: ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor));
    }
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final specialist = specialists[index];
          return SizedBox(
            width: 84,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: ThemeProvider.gold.withValues(alpha: 0.2),
                  backgroundImage: NetworkImage(
                    '${Environments.imageURL}${specialist.cover}',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${specialist.firstName ?? ''} ${specialist.lastName ?? ''}'
                      .trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: ThemeProvider.sans(size: 11, color: Colors.white70),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _gallery(PackagesDetailsController controller) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.gallery.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    gallery: controller.gallery,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${Environments.imageURL}${controller.gallery[index]}',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(Icons.broken_image,
                      color: ThemeProvider.greyColor),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomBar(PackagesDetailsController controller) {
    final booked = controller.packagesDetails.isBooked == true;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: booked
            ? Row(
                children: [
                  Expanded(
                    child: EliteGoldButton(
                      outlined: true,
                      label: 'Remove Package'.tr,
                      icon: Icons.remove_shopping_cart_outlined,
                      onTap: controller.removePackageFromCart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: EliteGoldButton(
                      label: 'Checkout'.tr,
                      icon: Icons.shopping_cart_checkout,
                      onTap: controller.onCheckout,
                    ),
                  ),
                ],
              )
            : EliteGoldButton(
                label: 'Book Now'.tr,
                icon: Icons.shopping_cart_outlined,
                onTap: controller.addPackageToCart,
              ),
      ),
    );
  }
}
