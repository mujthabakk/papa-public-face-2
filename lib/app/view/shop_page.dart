import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/models/packages_model.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/controller/login_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/open_hours.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/imageviewer.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _liked = false;
  bool _askedReviews = false;

  String _gender(int? code) {
    switch (code) {
      case 0:
        return 'Kids';
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      case 3:
        return 'Family';
      default:
        return 'Signature';
    }
  }

  String _to12(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final parts = time.split(':');
      var hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return time;
    }
  }

  String _dayName(int? day) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    if (day == null || day < 0 || day > 6) return '';
    return days[day];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : CustomScrollView(
                  slivers: [
                    _hero(value),
                    SliverToBoxAdapter(child: _body(value)),
                  ],
                ),
          bottomNavigationBar: _bottomBar(value),
        );
      },
    );
  }

  Widget _hero(ServicesController value) {
    final cover =
        '${Environments.imageURL}${value.salonDetails.cover ?? ''}';
    final hoursLabel = OpenHours.label(value.salonDetails.timing);
    final isOpen = OpenHours.isOpen(value.salonDetails.timing);
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: ThemeProvider.backgroundColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: ThemeProvider.gold),
        onPressed: () => Get.back(),
      ),
      title: Text(
        value.salonDetails.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _liked ? Icons.favorite : Icons.favorite_border,
            color: ThemeProvider.gold,
          ),
          onPressed: () => setState(() => _liked = !_liked),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: ThemeProvider.gold),
          color: ThemeProvider.surface,
          onSelected: (v) {
            if (v == 'web') value.openWebsite();
            if (v == 'call') value.callSalon();
            if (v == 'chat') value.onChat();
            if (v == 'map') value.openMap();
            if (v == 'share') value.share();
          },
          itemBuilder: (_) => [
            _menu('web', 'Website'),
            _menu('call', 'Call'),
            _menu('chat', 'Chat'),
            _menu('map', 'Directions'),
            _menu('share', 'Share'),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            EliteNetworkImage(url: cover, fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xCC0D0D0D)],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          value.salonDetails.name ?? '',
                          style: ThemeProvider.serif(
                              size: 26, weight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOpen
                              ? const Color(0xFF2E7D32)
                              : ThemeProvider.greyColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isOpen ? 'Open'.tr : 'Closed'.tr,
                          style: ThemeProvider.sans(
                            size: 11,
                            weight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if ((value.salonDetails.address ?? '').isNotEmpty)
                    _meta(Icons.location_on, value.salonDetails.address ?? ''),
                  const SizedBox(height: 6),
                  _meta(
                    Icons.star,
                    '${(value.salonDetails.rating ?? 0).toStringAsFixed(1)} (${value.salonDetails.totalRating ?? 0} Reviews)',
                  ),
                  if (hoursLabel.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    _meta(Icons.access_time, hoursLabel,
                        color: ThemeProvider.gold),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _menu(String v, String label) {
    return PopupMenuItem(
      value: v,
      child: Text(label, style: ThemeProvider.sans(size: 13)),
    );
  }

  Widget _meta(IconData icon, String text, {Color color = Colors.white}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: ThemeProvider.gold),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ThemeProvider.sans(size: 12, color: color),
          ),
        ),
      ],
    );
  }

  Widget _body(ServicesController value) {
    final loggedIn = value.parser.isLogin();
    void goLogin() {
      Get.delete<LoginController>(force: true);
      Get.toNamed(AppRouter.getLoginRoute());
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _quickActions(value),
          _chipBlock('Facilities'.tr, value.salonDetails.facilities),
          _chipBlock('Features'.tr, value.salonDetails.features),
          _socialLinks(value),
          _location(value),
          if (loggedIn)
            EliteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About the Sanctuary'.tr,
                    style: ThemeProvider.serif(
                        size: 20, color: ThemeProvider.gold),
                  ),
                  const SizedBox(height: 10),
                  (value.salonDetails.about ?? '').isEmpty ||
                          value.salonDetails.about == 'NA'
                      ? Text(
                          'No details added yet'.tr,
                          style: ThemeProvider.sans(
                            size: 13,
                            color: ThemeProvider.greyColor,
                          ),
                        )
                      : Text(
                          value.salonDetails.about ?? '',
                          style: ThemeProvider.sans(
                            size: 13,
                            color: Colors.white70,
                          ).copyWith(height: 1.55),
                        ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EliteLoginPromptCard(
                message: 'Opps, Please Login or Register first!'.tr,
                onTap: goLogin,
              ),
            ),
          _catalogTabs(value),
          if (value.catalogTab == 0)
            ...(value.categoriesList.isNotEmpty ||
                    value.servicesList.isNotEmpty
                ? _serviceSections(value)
                : [
                    const EliteApiUnavailable(
                      title: 'No services available',
                      icon: Icons.spa_outlined,
                    ),
                  ])
          else if (value.packagesList.isNotEmpty)
            _packages(value)
          else
            const EliteApiUnavailable(
              title: 'No treatments available',
              icon: Icons.inventory_2_outlined,
            ),
          if (value.gallery.isNotEmpty) _gallery(value),
          if (value.specialistList.isNotEmpty) _specialists(value),
          _reviews(value),
        ],
      ),
    );
  }

  Widget _quickActions(ServicesController value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _quickItem(Icons.language, 'Website'.tr, value.openWebsite),
          _quickItem(Icons.phone_outlined, 'Call'.tr, value.callSalon),
          _quickItem(Icons.chat_bubble_outline, 'Chat'.tr, value.onChat),
          _quickItem(Icons.near_me_outlined, 'Direction'.tr, value.openMap),
          _quickItem(Icons.share_outlined, 'Share'.tr, value.share),
        ],
      ),
    );
  }

  Widget _quickItem(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Icon(icon, color: ThemeProvider.gold, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ThemeProvider.sans(size: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _catalogTabs(ServicesController value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            _catalogTab(value, 0, 'Services'.tr),
            _catalogTab(value, 1, 'Packages'.tr),
          ],
        ),
      ),
    );
  }

  Widget _catalogTab(ServicesController value, int index, String label) {
    final selected = value.catalogTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => value.setCatalogTab(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? ThemeProvider.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: ThemeProvider.sans(
              size: 13,
              weight: FontWeight.w700,
              color: selected ? Colors.black : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget _chipBlock(String title, List<String> items) {
    final visible = items
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && !RegExp(r'^\d+$').hasMatch(e))
        .toList();
    if (visible.isEmpty) return const SizedBox.shrink();
    const previewCount = 3;
    final preview = visible.take(previewCount).toList();
    final extra = visible.length - preview.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteSectionBar(title: title),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...preview.map(_facilityChip),
              if (extra > 0)
                GestureDetector(
                  onTap: () => _showAllChips(title, visible),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeProvider.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+$extra',
                      style: ThemeProvider.sans(
                        size: 12,
                        weight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              else if (visible.length > 1)
                GestureDetector(
                  onTap: () => _showAllChips(title, visible),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeProvider.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: ThemeProvider.gold),
                    ),
                    child: Text(
                      'All'.tr,
                      style: ThemeProvider.sans(
                        size: 12,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _facilityChip(String item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ThemeProvider.gold.withValues(alpha: 0.45)),
      ),
      child: Text(
        item,
        style: ThemeProvider.sans(size: 12, color: ThemeProvider.gold),
      ),
    );
  }

  void _showAllChips(String title, List<String> items) {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: ThemeProvider.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text(title, style: ThemeProvider.serif(size: 20)),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items.map(_facilityChip).toList(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _socialLinks(ServicesController value) {
    final links = value.salonDetails.contactLinks;
    final items = <({IconData icon, String label, bool enabled, VoidCallback onTap})>[
      (
        icon: Icons.camera_alt,
        label: 'Instagram'.tr,
        enabled: links.hasInstagram,
        onTap: value.openInstagram,
      ),
      (
        icon: Icons.play_circle_filled,
        label: 'YouTube'.tr,
        enabled: links.hasYoutube,
        onTap: value.openYoutube,
      ),
      (
        icon: Icons.facebook,
        label: 'Facebook'.tr,
        enabled: links.hasFacebook,
        onTap: value.openFacebook,
      ),
      (
        icon: Icons.chat,
        label: 'WhatsApp'.tr,
        enabled: links.hasWhatsapp,
        onTap: value.openWhatsapp,
      ),
      (
        icon: Icons.alternate_email,
        label: 'Twitter'.tr,
        enabled: links.hasTwitter,
        onTap: value.openTwitter,
      ),
      (
        icon: Icons.business_center,
        label: 'LinkedIn'.tr,
        enabled: links.hasLinkedin,
        onTap: value.openLinkedin,
      ),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteSectionBar(title: 'Social Media'.tr),
          const SizedBox(height: 4),
          Wrap(
            spacing: 14,
            runSpacing: 14,
            children: items
                .map(
                  (item) => Opacity(
                    opacity: item.enabled ? 1 : 0.32,
                    child: GestureDetector(
                      onTap: item.onTap,
                      child: SizedBox(
                        width: 68,
                        child: Column(
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ThemeProvider.surface,
                                border: Border.all(
                                  color: ThemeProvider.gold
                                      .withValues(alpha: 0.55),
                                  width: 1.4,
                                ),
                              ),
                              child: Icon(
                                item.icon,
                                size: 28,
                                color: ThemeProvider.gold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> _serviceSections(ServicesController value) {
    final used = <int>{};
    final widgets = <Widget>[];
    for (final cate in value.categoriesList) {
      final items = <MapEntry<int, ServicesModel>>[];
      for (var i = 0; i < value.servicesList.length; i++) {
        final s = value.servicesList[i];
        if (s.serviceId == cate.id) {
          items.add(MapEntry(i, s));
          used.add(i);
        }
      }
      if (items.isEmpty) continue;
      widgets.add(_sectionHeader(cate.name ?? 'Services', items.length));
      widgets.addAll(items.map((e) => _serviceCard(value, e.value, e.key)));
    }
    final leftover = <MapEntry<int, ServicesModel>>[];
    for (var i = 0; i < value.servicesList.length; i++) {
      if (!used.contains(i)) leftover.add(MapEntry(i, value.servicesList[i]));
    }
    if (leftover.isNotEmpty) {
      widgets.add(_sectionHeader('Curated Services', leftover.length));
      widgets.addAll(
          leftover.map((e) => _serviceCard(value, e.value, e.key)));
    }
    return widgets;
  }

  Widget _sectionHeader(String title, int count) {
    return EliteSectionBar(
      title: title,
      trailing: '$count Services',
    );
  }

  Widget _serviceCard(
      ServicesController value, ServicesModel service, int index) {
    final selected = service.isChecked == true;
    final hasOffer = (service.discount ?? 0) > 0;
    final offerPrice = hasOffer ? service.off : service.price;
    final serviceRating = (service.rating ?? 0) > 0
        ? service.rating!
        : (value.salonDetails.rating ?? 0);
    final reviewCount = (service.reviewCount ?? 0) > 0
        ? service.reviewCount!
        : (service.totalRating ?? 0) > 0
            ? service.totalRating!
            : (value.salonDetails.totalRating ?? 0);
    return EliteCard(
      padding: const EdgeInsets.all(12),
      borderColor: selected ? ThemeProvider.gold : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}${service.cover}',
                height: 160,
                width: double.infinity,
                radius: BorderRadius.circular(12),
              ),
              if (hasOffer)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeProvider.gold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${service.discount!.toStringAsFixed(0)}% OFF',
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: ThemeProvider.backgroundColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  service.name ?? '',
                  style: ThemeProvider.serif(size: 18),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    elitePrice(
                      value.currencySide,
                      value.currencySymbol,
                      offerPrice,
                    ),
                    style: ThemeProvider.price(
                        size: 18,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold),
                  ),
                  if (hasOffer) ...[
                    const SizedBox(height: 2),
                    Text(
                      elitePrice(
                        value.currencySide,
                        value.currencySymbol,
                        service.price,
                      ),
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.greyColor,
                      ).copyWith(decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Offer ${elitePrice(value.currencySide, value.currencySymbol, ((service.price ?? 0) - (service.off ?? 0)))}',
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w600,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _chip(Icons.access_time, '${service.duration?.toInt() ?? 0} Mins'),
              _chip(Icons.bolt, _gender(service.gender)),
              _chip(
                Icons.star,
                '${serviceRating.toStringAsFixed(1)} ($reviewCount Reviews)',
              ),
            ],
          ),
          if ((service.descriptions ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              service.descriptions!,
              style: ThemeProvider.sans(size: 13, color: Colors.white70),
            ),
          ],
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () =>
                  value.updateServiceStatusInCart(index, !selected),
              child: Text(
                selected ? 'SELECTED' : 'SELECT',
                style: ThemeProvider.sans(
                  size: 11,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: ThemeProvider.greyColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: ThemeProvider.sans(size: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _packages(ServicesController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EliteSectionBar(title: 'Combo Packages'.tr),
        ...value.packagesList.map((p) => _packageCard(value, p)),
      ],
    );
  }

  Widget _packageCard(ServicesController value, PackagesModel package) {
    final names = _packageNames(package, value);
    return EliteCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            EliteNetworkImage(
              url: '${Environments.imageURL}${package.cover}',
              height: 180,
              width: double.infinity,
            ),
            Container(
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color(0xE60D0D0D)],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(package.name ?? '',
                      style: ThemeProvider.serif(size: 18)),
                  const SizedBox(height: 6),
                  ...names.take(3).map(
                        (n) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.circle,
                                  size: 6, color: ThemeProvider.gold),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  n,
                                  style: ThemeProvider.sans(
                                      size: 12, color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        elitePrice(value.currencySide, value.currencySymbol,
                            (package.discount ?? 0) > 0
                                ? package.off
                                : package.price),
                        style: ThemeProvider.price(
                            size: 16,
                            weight: FontWeight.w700,
                            color: ThemeProvider.gold),
                      ),
                      if ((package.discount ?? 0) > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          elitePrice(value.currencySide, value.currencySymbol,
                              package.price),
                          style: ThemeProvider.sans(
                            size: 12,
                            color: ThemeProvider.greyColor,
                          ).copyWith(decoration: TextDecoration.lineThrough),
                        ),
                      ],
                      const Spacer(),
                      EliteGoldButton(
                        label: 'Book Bundle'.tr,
                        onTap: () => value.onPackagesDetails(
                            package.id as int, package.name.toString()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _packageNames(
      PackagesModel package, ServicesController value) {
    final ids = (package.serviceId ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty);
    final names = <String>[];
    for (final id in ids) {
      final match = value.servicesList.where(
          (s) => s.id.toString() == id || s.serviceId.toString() == id);
      names.add(match.isEmpty ? 'Included service' : (match.first.name ?? ''));
    }
    return names;
  }

  Widget _location(ServicesController value) {
    final lat = value.salonDetails.lat ?? 0;
    final lng = value.salonDetails.lng ?? 0;
    final hasMap = lat.abs() > 0.0001 && lng.abs() > 0.0001;
    final today = DateTime.now().weekday % 7;
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteSectionBar(title: 'Location & Hours'.tr),
          if (hasMap)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 140,
                child: GoogleMap(
                  style: Utils.mapStyles,
                  markers: {
                    Marker(
                      markerId: const MarkerId('salon'),
                      position: LatLng(lat, lng),
                    ),
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 14,
                  ),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  liteModeEnabled: false,
                  onTap: (_) => value.openMap(),
                ),
              ),
            ),
          if (hasMap) const SizedBox(height: 12),
          Text(
            value.salonDetails.address ?? '',
            style: ThemeProvider.sans(size: 13, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: value.openMap,
            child: Text(
              'Get Direction — ${value.getDistance} KM',
              style: ThemeProvider.sans(size: 12, color: ThemeProvider.gold),
            ),
          ),
          const SizedBox(height: 12),
          ...(value.salonDetails.timing ?? []).map((t) {
            final isToday = t.day == today;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _dayName(t.day),
                    style: ThemeProvider.sans(
                      size: 13,
                      color: isToday ? ThemeProvider.gold : Colors.white,
                    ),
                  ),
                  Text(
                    '${_to12(t.openTime)} - ${_to12(t.closeTime)}',
                    style: ThemeProvider.sans(
                      size: 13,
                      color: isToday ? ThemeProvider.gold : Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _gallery(ServicesController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EliteSectionBar(title: 'Gallery'.tr),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: value.gallery.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => Get.to(() => ImageGalleryScreen(
                    gallery: value.gallery,
                    initialIndex: i,
                  )),
              child: EliteNetworkImage(
                url: '${Environments.imageURL}${value.gallery[i]}',
                width: 110,
                height: 90,
                radius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _specialists(ServicesController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EliteSectionBar(
          title: 'Practitioners'.tr,
          trailing: '${value.specialistList.length}',
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: value.specialistList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final s = value.specialistList[i];
              return SizedBox(
                width: 88,
                child: Column(
                  children: [
                    EliteNetworkImage(
                      url: '${Environments.imageURL}${s.cover}',
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${s.firstName ?? ''} ${s.lastName ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(size: 11, color: ThemeProvider.gold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _reviews(ServicesController value) {
    if (!_askedReviews) {
      _askedReviews = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        value.getOwnerReviews();
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EliteSectionBar(
          title: 'Reviews'.tr,
          trailing: '${value.ownerReviewsList.length}',
        ),
        if (value.ownerReviewsList.isEmpty)
          const EliteApiUnavailable(
            title: 'No reviews yet',
            subtitle: 'Be the first to share your experience.',
            icon: Icons.rate_review_outlined,
          )
        else
          ...value.ownerReviewsList.take(6).map((r) {
            final name =
                '${r.user?.firstName ?? ''} ${r.user?.lastName ?? ''}'.trim();
            return EliteCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name.isEmpty ? 'Guest' : name,
                          style: ThemeProvider.serif(size: 15)),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: ThemeProvider.gold),
                      Text(
                        ' ${(r.rating ?? 0).toStringAsFixed(1)}',
                        style: ThemeProvider.sans(
                            size: 12, color: ThemeProvider.gold),
                      ),
                    ],
                  ),
                  if ((r.notes ?? '').isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(r.notes!,
                        style:
                            ThemeProvider.sans(size: 12, color: Colors.white70)),
                  ],
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _bottomBar(ServicesController value) {
    return GetBuilder<ServiceCartController>(
      builder: (cart) {
        if (cart.totalItemsInCart <= 0 || cart.servicesFrom != 'salon') {
          return const SizedBox.shrink();
        }
        return Container(
          color: ThemeProvider.backgroundColor,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: EliteGoldButton(
                label:
                    'BOOK NOW  ·  ${elitePrice(value.currencySide, value.currencySymbol, cart.totalPrice, digits: 2)}',
                onTap: value.onCheckout,
              ),
            ),
          ),
        );
      },
    );
  }
}
