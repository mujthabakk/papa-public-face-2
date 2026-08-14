import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/models/packages_model.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/map_style.dart';
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
    final close = (value.salonDetails.timing ?? []).where((t) {
      return t.day == DateTime.now().weekday % 7;
    });
    final until = close.isEmpty ? '' : _to12(close.first.closeTime);
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
        value.salonDetails.name ?? 'Sanctuary',
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
                  Text(
                    value.salonDetails.name ?? '',
                    style: ThemeProvider.serif(
                        size: 28, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      if ((value.salonDetails.address ?? '').isNotEmpty)
                        _meta(Icons.location_on, value.salonDetails.address ?? ''),
                      _meta(
                        Icons.star,
                        '${(value.salonDetails.rating ?? 0).toStringAsFixed(1)} (${value.salonDetails.totalRating ?? 0} Reviews)',
                      ),
                    ],
                  ),
                  if (until.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _meta(Icons.access_time, 'Open until $until',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About the Sanctuary',
                  style: ThemeProvider.serif(
                      size: 20, color: ThemeProvider.gold),
                ),
                const SizedBox(height: 10),
                Text(
                  value.salonDetails.about ?? '',
                  style: ThemeProvider.sans(
                    size: 13,
                    color: Colors.white70,
                  ).copyWith(height: 1.55),
                ),
              ],
            ),
          ),
          _featureGrid(),
          if (value.categoriesList.isNotEmpty ||
              value.servicesList.isNotEmpty)
            ..._serviceSections(value),
          if (value.packagesList.isNotEmpty) _packages(value),
          _location(value),
          if (value.gallery.isNotEmpty) _gallery(value),
          if (value.specialistList.isNotEmpty) _specialists(value),
          _reviews(value),
        ],
      ),
    );
  }

  Widget _featureGrid() {
    const items = [
      (Icons.spa_outlined, 'Holistic'),
      (Icons.science_outlined, 'Bio-Tech'),
      (Icons.self_improvement, 'Zen Focus'),
      (Icons.verified_outlined, 'Certified'),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
        children: items
            .map(
              (e) => Container(
                decoration: BoxDecoration(
                  color: ThemeProvider.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(e.$1, color: ThemeProvider.gold, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      e.$2,
                      style: ThemeProvider.sans(
                        size: 12,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
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
    return EliteCard(
      padding: const EdgeInsets.all(12),
      borderColor: selected ? ThemeProvider.gold : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteNetworkImage(
            url: '${Environments.imageURL}${service.cover}',
            height: 160,
            width: double.infinity,
            radius: BorderRadius.circular(12),
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
              Text(
                elitePrice(
                  value.currencySide,
                  value.currencySymbol,
                  (service.discount ?? 0) > 0 ? service.off : service.price,
                ),
                style: ThemeProvider.serif(
                    size: 20, color: ThemeProvider.gold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _chip(Icons.access_time, '${service.duration?.toInt() ?? 0} Mins'),
              const SizedBox(width: 12),
              _chip(Icons.bolt, _gender(service.gender)),
            ],
          ),
          if ((service.descriptions ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              service.descriptions!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
        const EliteSectionBar(title: 'Combo Packages'),
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
                        style: ThemeProvider.serif(
                            size: 18, color: ThemeProvider.gold),
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
                        label: 'Book Bundle',
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
    final today = DateTime.now().weekday % 7;
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EliteSectionBar(title: 'Location & Hours'),
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
                liteModeEnabled: true,
                onTap: (_) => value.openMap(),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
        const EliteSectionBar(title: 'Gallery'),
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
          title: 'Practitioners',
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
          title: 'Reviews',
          trailing: '${value.ownerReviewsList.length}',
        ),
        if (value.ownerReviewsList.isEmpty)
          Text('No reviews yet',
              style: ThemeProvider.sans(size: 13, color: Colors.white70))
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
