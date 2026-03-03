import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/find_location_controller.dart';
import 'package:salon_user/app/util/theme.dart';

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
      final controller = Get.find<FindLocationController>();
      controller.resetSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindLocationController>(builder: (value) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            'Find Location'.tr,
            style: ThemeProvider.titleStyle,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.cancel_outlined,
                color: ThemeProvider.whiteColor,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: ThemeProvider.greyColor.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: ThemeProvider.greyColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: TextField(
                          controller: value.searchbarText,
                          onChanged: (content) {
                            value.onSearchChanged(content);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search location'.tr,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (value.savedAddress.isNotEmpty)
                InkWell(
                  onTap: () {
                    value.useSavedLocation();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: ThemeProvider.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ThemeProvider.appColor,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: ThemeProvider.appColor,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Active Location'.tr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: ThemeProvider.appColor,
                                  fontFamily: 'bold',
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                value.savedAddress,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ThemeProvider.greyColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: ThemeProvider.appColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              value.getList.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: ThemeProvider.whiteColor),
                          child: Column(
                            children: [
                              for (var item in value.getList)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: InkWell(
                                    onTap: () {
                                      value.getLatLngFromAddress(
                                          item.description.toString());
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.search),
                                        const SizedBox(width: 10),
                                        Text(
                                          item.description!.length > 25
                                              ? '${item.description!.substring(0, 25)}...'
                                              : item.description!,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
              value.getList.isEmpty
                  ? TextButton(
                      onPressed: () {
                        value.getLocation();
                      },
                      child: Text(
                        'Use My Current Location'.tr.toUpperCase(),
                        style: const TextStyle(
                          color: ThemeProvider.appColor,
                          letterSpacing: 1.1,
                        ),
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: value.getList.isEmpty ? 20 : 0),
              value.getList.isEmpty
                  ? Expanded(
                      child: Obx(() {
                        if (value.myLat.value == 0.0 &&
                            value.myLng.value == 0.0) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return GoogleMap(
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            onMapCreated: value.onMapCreated,
                            markers: value.markers,
                            initialCameraPosition: CameraPosition(
                              target:
                                  LatLng(value.myLat.value, value.myLng.value),
                              zoom: 15,
                            ),
                            onTap: (position) {
                              value.markers.clear();
                              value.moveMapToPosition(
                                  position.latitude, position.longitude);
                              value.myLat.value = position.latitude;
                              value.myLng.value = position.longitude;
                            },
                            onCameraMove: (position) {
                              //  value.moveMapToPosition(position.target.latitude,
                              //position.target.longitude);
                            },
                          );
                        }
                      }),
                    )
                  : const SizedBox(),
              SizedBox(height: value.getList.isEmpty ? 20 : 0),
              value.getList.isEmpty && value.myLat.value != 0.0 && value.myLng.value != 0.0
                  ? ElevatedButton(
                      onPressed: () {
                        value.onConfirmLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: ThemeProvider.whiteColor,
                        backgroundColor: ThemeProvider.appColor,
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Confirm Location'.tr.toUpperCase(),
                        style: const TextStyle(
                          color: ThemeProvider.whiteColor,
                          fontSize: 14,
                          letterSpacing: 1.1,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
