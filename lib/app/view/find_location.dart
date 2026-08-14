import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/find_location_controller.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class FindLocationScreen extends StatefulWidget {
  const FindLocationScreen({Key? key}) : super(key: key);

  @override
  State<FindLocationScreen> createState() => _FindLocationScreenState();
}

class _FindLocationScreenState extends State<FindLocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<FindLocationController>().resetSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindLocationController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: const EliteAppBar(
          showBack: true,
          title: 'Find Location',
          leadingLabel: 'CANCEL',
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: ThemeProvider.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2C2C2C)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: ThemeProvider.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: value.searchbarText,
                        onChanged: value.onSearchChanged,
                        style: ThemeProvider.sans(size: 14),
                        cursorColor: ThemeProvider.gold,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search location'.tr,
                          hintStyle: ThemeProvider.sans(
                              size: 14, color: ThemeProvider.greyColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (value.savedAddress.isNotEmpty) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: value.useSavedLocation,
                  child: EliteCard(
                    margin: EdgeInsets.zero,
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: ThemeProvider.gold),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Active Location'.tr,
                                style: ThemeProvider.sans(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: ThemeProvider.gold,
                                ),
                              ),
                              Text(
                                value.savedAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ThemeProvider.sans(
                                    size: 12, color: ThemeProvider.greyColor),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: ThemeProvider.gold),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (value.getList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: value.getList.length,
                    itemBuilder: (context, index) {
                      final item = value.getList[index];
                      return ListTile(
                        onTap: () => value.getLatLngFromAddress(
                            item.description.toString()),
                        leading: const Icon(Icons.search,
                            color: ThemeProvider.gold),
                        title: Text(
                          item.description ?? '',
                          style: ThemeProvider.sans(size: 13),
                        ),
                      );
                    },
                  ),
                )
              else ...[
                TextButton(
                  onPressed: value.getLocation,
                  child: Text(
                    'Use My Current Location'.tr.toUpperCase(),
                    style: ThemeProvider.sans(
                      size: 12,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Obx(() {
                    if (value.myLat.value == 0.0 && value.myLng.value == 0.0) {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: ThemeProvider.gold),
                      );
                    }
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: GoogleMap(
                        style: Utils.mapStyles,
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        onMapCreated: value.onMapCreated,
                        markers: value.markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(value.myLat.value, value.myLng.value),
                          zoom: 15,
                        ),
                        onTap: (position) {
                          value.markers.clear();
                          value.moveMapToPosition(
                              position.latitude, position.longitude);
                          value.myLat.value = position.latitude;
                          value.myLng.value = position.longitude;
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Obx(() => value.myLat.value != 0.0 && value.myLng.value != 0.0
                    ? EliteGoldButton(
                        label: 'CONFIRM LOCATION',
                        onTap: value.onConfirmLocation,
                      )
                    : const SizedBox()),
              ],
            ],
          ),
        ),
      );
    });
  }
}
