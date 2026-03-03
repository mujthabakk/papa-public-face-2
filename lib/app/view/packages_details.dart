import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/packages_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
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
          return const Center(
            child: CircularProgressIndicator(color: ThemeProvider.appColor),
          );
        }

        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                backgroundColor: ThemeProvider.backgroundColor,
                pinned: true,
                expandedHeight: 250.0,
                iconTheme: const IconThemeData(color: Colors.black),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isShrink
                        ? ThemeProvider.blackColor
                        : ThemeProvider.whiteColor,
                  ),
                  onPressed: controller.onBack,
                ),
                title: Text(
                  'Packages Details'.tr,
                  style: TextStyle(
                    color: isShrink
                        ? ThemeProvider.blackColor
                        : ThemeProvider.whiteColor,
                    fontFamily: 'bold',
                    fontSize: 18,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Image.network(
                      '${Environments.imageURL}${controller.packagesDetails.cover}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/notfound.png',
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ],
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Services Included'.tr, Icons.spa),
                  _buildCard(_buildServicesList(controller)),
                  _buildSectionTitle('Specialist'.tr, Icons.people_alt),
                  _buildCard(_buildSpecialistList(controller)),
                  _buildSectionTitle('Package Details'.tr, Icons.info),
                  _buildCard(_buildPackageDetails(controller)),
                  _buildSectionTitle('About'.tr, Icons.description),
                  _buildCard(
                    Text(
                      controller.packagesDetails.descriptions!,
                      style: const TextStyle(
                          fontSize: 15, color: ThemeProvider.blackColor),
                    ),
                  ),
                  _buildSectionTitle('Photos'.tr, Icons.photo_library),
                  _buildGallery(controller),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomNavBar(controller),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, size: 22, color: ThemeProvider.appColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ThemeProvider.blackColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDetails(PackagesDetailsController controller) {
    return Column(
      children: [
        _buildDetailRow(
          Icons.assignment,
          controller.packagesDetails.name!,
          backgroundColor: Colors.purple.shade50,
          iconColor: Colors.purple,
        ),
        const SizedBox(height: 12),
        _buildDetailRow(
          Icons.timer,
          '${controller.packagesDetails.duration} min',
          backgroundColor: Colors.blue.shade50,
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildPriceRow(controller),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label, {
    Color? backgroundColor,
    Color iconColor = Colors.black,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: iconColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(PackagesDetailsController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.currency_rupee, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.currencySide == 'left'
                    ? '${controller.currencySymbol}${controller.packagesDetails.price}'
                    : '${controller.packagesDetails.price}${controller.currencySymbol}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                controller.currencySide == 'left'
                    ? '${controller.currencySymbol}${controller.packagesDetails.off}'
                    : '${controller.packagesDetails.off}${controller.currencySymbol}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//   Widget _buildDetailRow(
//     IconData icon,
//     String label, {
//     Color color = Colors.black,
//     Color? backgroundColor,
//     Color iconColor = Colors.black,
//     TextStyle? textStyle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: BoxDecoration(
//         color: backgroundColor ?? Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             color: iconColor,
//             size: 28,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               label,
//               style: textStyle ??
//                   TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                     color: color,
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

Widget _buildCard(Widget child) {
  return SizedBox(
    width: double.infinity,
    child: Card(
      color: const Color.fromARGB(255, 248, 248, 248),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    ),
  );
}

Widget _buildServicesList(PackagesDetailsController controller) {
  return Column(
    children: controller.packagesDetails.services!.map((service) {
      return ListTile(
        leading: const Icon(Icons.assignment, color: ThemeProvider.appColor),
        title: Row(
          children: [
            Expanded(
              child: Text(service.name!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  )),
            ),
            const SizedBox(width: 10),
            _buildGenderIcon(service.gender),
            const SizedBox(width: 5),
          ],
        ),
        trailing: Text(
          controller.currencySide == 'left'
              ? '${controller.currencySymbol}${service.price}'
              : '${service.price}${controller.currencySymbol}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList(),
  );
}

Widget _buildGenderIcon(int? gender) {
  if (gender == null) return const SizedBox.shrink();
  switch (gender) {
    case 0:
      return const Icon(Icons.child_care, size: 16, color: Colors.orange);
    case 1:
      return const Icon(Icons.male, size: 16, color: Colors.blue);
    case 2:
      return const Icon(Icons.female, size: 16, color: Colors.pink);
    default:
      return const Icon(Icons.group, size: 16, color: Colors.green);
  }
}

Widget _buildSpecialistList(PackagesDetailsController controller) {
  return SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.packagesDetails.specialist!.length,
      itemBuilder: (context, index) {
        final specialist = controller.packagesDetails.specialist![index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: ThemeProvider.appColor.withOpacity(0.1),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    '${Environments.imageURL}${specialist.cover}',
                  ),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 4),
              Text('${specialist.firstName} ${specialist.lastName}',
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildGallery(PackagesDetailsController controller) {
  return SizedBox(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.gallery.length,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                '${Environments.imageURL}${controller.gallery[index]}',
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildBottomNavBar(PackagesDetailsController controller) {
  return controller.packagesDetails.isBooked!
      ? Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.remove_shopping_cart,
                      color: Colors.white),
                  label: Text('Remove Package'.tr,
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.blackColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.removePackageFromCart,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart_checkout,
                      color: Colors.white),
                  label: Text('Checkout'.tr,
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.pink,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: controller.onCheckout,
                ),
              ),
            ],
          ),
        )
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            icon: Icon(
              controller.packagesDetails.isBooked!
                  ? Icons.remove_shopping_cart
                  : Icons.shopping_cart_checkout,
              color: Colors.white,
            ),
            label: Text(
              'Book Now'.tr,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.appColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            onPressed: controller.addPackageToCart,
          ),
        );
}
