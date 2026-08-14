import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/controller/top_specialist_controller.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/sidemenu.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class NearScreen extends StatefulWidget {
  const NearScreen({Key? key}) : super(key: key);

  @override
  State<NearScreen> createState() => _NearScreenState();
}

class _NearScreenState extends State<NearScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _chip = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NearController>(
      builder: (value) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ThemeProvider.backgroundColor,
          drawer: const SideMenuScreen(),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.haveData == true
                  ? _content(value)
                  : _empty(),
        );
      },
    );
  }

  Widget _content(NearController value) {
    var salons = [...value.salonList];
    if (_chip == 2) {
      salons.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }
    if (_chip == 1) {
      salons = salons.where((s) => (s.status ?? 1) == 1).toList();
    }

    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: EliteAppBar(
            onMenu: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ),
        EliteSearchBar(
          hint: 'Search services...'.tr,
          onTap: () {
            Get.delete<UnifiedSearchController>(force: true);
            Get.toNamed(AppRouter.getSearchRoutes());
          },
          onFilter: value.onFilter,
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _chipBtn('Map', 0),
              const SizedBox(width: 8),
              _chipBtn('Open Now', 1),
              const SizedBox(width: 8),
              _chipBtn('Top Rated', 2),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 90),
            children: [
              if (_chip == 0 && value.markers.isNotEmpty)
                Container(
                  height: 180,
                  margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: false,
                    tiltGesturesEnabled: false,
                    onMapCreated: (c) {
                      if (!value.googleMapsController.isCompleted) {
                        value.googleMapsController.complete(c);
                      }
                    },
                    style: Utils.mapStyles,
                    markers: value.markers,
                    mapType: MapType.normal,
                    initialCameraPosition: value.initialCameraPosition,
                    zoomControlsEnabled: false,
                  ),
                ),
              if (value.individualList.isNotEmpty) ...[
                EliteSectionHeader(
                  title: 'TOP FREELANCERS'.tr,
                  action: 'VIEW ALL >',
                  goldTitle: true,
                  onAction: () {
                    Get.delete<TopSpecialistController>(force: true);
                    Get.toNamed(AppRouter.getTopSpecialistRoutes());
                  },
                ),
                SizedBox(
                height: 150,
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
                        width: 96,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(color: ThemeProvider.gold),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: EliteNetworkImage(
                                url:
                                    '${Environments.imageURL}${item.userInfo?.cover ?? ''}',
                                height: 88,
                                width: 88,
                                radius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name.toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: ThemeProvider.serif(
                                size: 12,
                                color: ThemeProvider.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ],
              if (salons.isNotEmpty) ...[
                EliteSectionHeader(
                  title: 'NEARBY CENTERS'.tr,
                  goldTitle: true,
                ),
                ...salons.map((item) => _centerCard(value, item)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _chipBtn(String label, int index) {
    final selected = _chip == index;
    return GestureDetector(
      onTap: () => setState(() => _chip = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? ThemeProvider.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? ThemeProvider.gold : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: ThemeProvider.sans(
            size: 12,
            weight: FontWeight.w600,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _centerCard(NearController value, dynamic item) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}${item.cover}',
                width: 88,
                height: 88,
                radius: BorderRadius.circular(10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.serif(
                              size: 16,
                              color: ThemeProvider.gold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '★ ${(item.rating ?? 0).toStringAsFixed(1)}',
                            style: ThemeProvider.sans(size: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.address ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(
                          size: 11, color: ThemeProvider.greyColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(item.distance ?? 0).toStringAsFixed(1)} mi away',
                      style: ThemeProvider.sans(
                        size: 11,
                        color: ThemeProvider.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: ThemeProvider.gold,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'OPEN NOW',
                style: ThemeProvider.sans(size: 11, color: Colors.white70),
              ),
              const Spacer(),
              EliteGoldButton(
                label: 'BOOK NOW',
                icon: Icons.calendar_today,
                onTap: () => value.onServices(item.uid as int),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/no-data.png', height: 100, width: 100),
          const SizedBox(height: 20),
          Text(
            'No Data Found Near You!'.tr,
            style: ThemeProvider.serif(size: 16, color: ThemeProvider.gold),
          ),
        ],
      ),
    );
  }
}
