import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/near_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/util/theme.dart';

class NearScreen extends StatefulWidget {
  const NearScreen({Key? key}) : super(key: key);

  @override
  State<NearScreen> createState() => _NearScreenState();
}

class _NearScreenState extends State<NearScreen> {
  @override
  Widget build(BuildContext context) {
    void _onMapCreated(GoogleMapController controller) {
      controller.setMapStyle(Utils.mapStyles);
      Get.find<NearController>().googleMapsController.complete(controller);
    }

    return GetBuilder<NearController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: ThemeProvider.appColor,
                  ),
                )
              : value.haveData == true
                  ? _buildContent(value, _onMapCreated)
                  : _buildNoDataView(),
        );
      },
    );
  }

  // Main content with map and lists
  Widget _buildContent(
      NearController value, void Function(GoogleMapController) onMapCreated) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 400,
            child: GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              onMapCreated: onMapCreated,
              markers: value.markers,
              mapType: MapType.hybrid,
              scrollGesturesEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              initialCameraPosition: value.initialCameraPosition,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: ThemeProvider.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Top Freelancers'.tr),
                _buildSpecialistList(value),
                const SizedBox(height: 5),
                _buildSectionTitle('Top Wellness Centers'.tr),
                _buildSalonList(value),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'bold',
          color: ThemeProvider.blackColor,
        ),
      ),
    );
  }

  // Specialist horizontal list
  Widget _buildSpecialistList(NearController value) {
    return SizedBox(
      height: 130,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var item in Get.find<NearController>().individualList)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        value.onSpecialist(
                          item.uid as int,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(
                            width: 2,
                            color: ThemeProvider.appColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(35),
                              child: FadeInImage(
                                image: NetworkImage(
                                    '${Environments.imageURL}${item.userInfo?.cover.toString()}'),
                                placeholder: const AssetImage(
                                    "assets/images/placeholder.jpeg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/notfound.png',
                                      fit: BoxFit.cover);
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.userInfo!.firstName.toString(),
                      style: const TextStyle(fontFamily: 'semibold'),
                    ),
                    Text(
                      item.userInfo!.lastName.toString(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  // Salon horizontal list
  Widget _buildSalonList(NearController value) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: value.salonList.length,
        itemBuilder: (context, index) {
          var item = value.salonList[index];
          return _buildSalonItem(
            item.cover.toString(),
            item.name.toString(),
            item.rating.toString(),
            item.address.toString(),
            () => value.onServices(item.uid as int),
          );
        },
      ),
    );
  }

  // Salon item widget
  Widget _buildSalonItem(String imageUrl, String name, String rating,
      String address, VoidCallback onTap) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ThemeProvider.greyColor.shade300),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: FadeInImage(
                height: 120,
                width: double.infinity,
                image: NetworkImage('${Environments.imageURL}$imageUrl'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png',
                      fit: BoxFit.cover);
                },
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                              fontSize: 13.5, fontFamily: 'semibold'),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Text(rating, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    maxLines: 1,
                    address.length > 20
                        ? '${address.substring(0, 20)}...'
                        : address,
                    style: const TextStyle(
                        fontSize: 12, color: ThemeProvider.greyColor),
                  ),
                  const SizedBox(height: 2),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today, size: 14),
                      label: Text('Book Now'.tr,
                          style: const TextStyle(fontSize: 14)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ThemeProvider.appColor,
                        side: BorderSide(color: ThemeProvider.appColor),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: onTap,
                    ),
                  ),
                  // Align(
                  //   alignment: Alignment.bottomRight,
                  //   child: ElevatedButton(
                  //     onPressed: onTap,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: ThemeProvider.appColor,
                  //       foregroundColor: Colors.white,
                  //       minimumSize: const Size(60, 30),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(8)),
                  //     ),
                  //     child:
                  //         Text('Book'.tr, style: const TextStyle(fontSize: 12)),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // No data view
  Widget _buildNoDataView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/no-data.png",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            'No Data Found Near You!'.tr,
            style: const TextStyle(fontFamily: 'bold', fontSize: 16),
          ),
        ],
      ),
    );
  }
}
