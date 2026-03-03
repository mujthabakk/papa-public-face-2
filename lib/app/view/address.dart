// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/address_controller.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class AddressScreen extends StatefulWidget {
//   const AddressScreen({Key? key}) : super(key: key);

//   @override
//   State<AddressScreen> createState() => _AddressScreenState();
// }

// class _AddressScreenState extends State<AddressScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AddressController>(
//       builder: (value) {
//         return Scaffold(
//           backgroundColor: ThemeProvider.whiteColor,
//           appBar: AppBar(
//             backgroundColor: ThemeProvider.appColor,
//             elevation: 0,
//             iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//             titleSpacing: 0,
//             centerTitle: true,
//             title: Text(
//               'Address'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//             actions: [
//               Container(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: ThemeProvider.whiteColor,
//                   borderRadius: BorderRadius.circular(5),
//                 ),
//                 child: InkWell(
//                   onTap: () {
//                     value.onAddNew();
//                   },
//                   child: Center(
//                     child: Text(
//                       'Add New'.tr,
//                       style: const TextStyle(
//                           fontSize: 10,
//                           fontFamily: 'bold',
//                           color: ThemeProvider.blackColor),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           body: value.apiCalled == false
//               ? SkeletonListView()
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: List.generate(
//                         value.addressList.length,
//                         (index) => Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 7),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             value.titles[value
//                                                     .addressList[index]
//                                                     .title as int]
//                                                 .toString(),
//                                             style: const TextStyle(
//                                                 color: ThemeProvider.blackColor,
//                                                 fontSize: 14,
//                                                 fontFamily: 'semibold'),
//                                           ),
//                                           Text(
//                                             '${value.addressList[index].address} ${value.addressList[index].house} ${value.addressList[index].landmark} ${value.addressList[index].pincode}',
//                                             style: const TextStyle(
//                                               color: ThemeProvider.greyColor,
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       value.onEdit(
//                                           value.addressList[index].id as int);
//                                     },
//                                     child: const Icon(
//                                       Icons.edit_note,
//                                       color: ThemeProvider.appColor,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   InkWell(
//                                     onTap: () {
//                                       value.onDestroy(
//                                           value.addressList[index].id as int);
//                                     },
//                                     child: const Icon(
//                                       Icons.delete,
//                                       color: ThemeProvider.redColor,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/address_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.pink;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          appBar: _buildAppBar(value),
          body: value.apiCalled == false
              ? _buildSkeletonLoader()
              : _buildAddressList(value),
          floatingActionButton: _buildFloatingActionButton(value),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AddressController value) {
    return AppBar(
      backgroundColor: ThemeProvider.appColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'My Addresses',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeProvider.appColor,
              ThemeProvider.appColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          6,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 40,
                        height: 40,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 16,
                              width: 100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 14,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SkeletonLine(
                            style: SkeletonLineStyle(
                              height: 14,
                              width: 200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressList(AddressController value) {
    if (value.addressList.isEmpty) {
      return _buildEmptyState(value);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Addresses'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: value.addressList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildAddressCard(value, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressController value, int index) {
    final address = value.addressList[index];
    final addressType = value.titles[address.title as int].toString();

    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderLight),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with type and actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getAddressTypeColor(addressType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getAddressTypeIcon(addressType),
                    color: _getAddressTypeColor(addressType),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        addressType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Tap to view full address',
                        style: TextStyle(
                          fontSize: 12,
                          color: textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButton(
                  icon: Icons.edit_outlined,
                  color: info,
                  onTap: () => value.onEdit(address.id as int),
                ),
                const SizedBox(width: 8),
                _buildActionButton(
                  icon: Icons.delete_outline,
                  color: error,
                  onTap: () => _showDeleteDialog(value, address.id as int),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Address details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: surfaceBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressDetailRow(
                    Icons.location_on_outlined,
                    'Address',
                    address.address ?? '',
                  ),
                  if (address.house != null && address.house!.isNotEmpty)
                    _buildAddressDetailRow(
                      Icons.home_outlined,
                      'House/Building',
                      address.house!,
                    ),
                  if (address.landmark != null && address.landmark!.isNotEmpty)
                    _buildAddressDetailRow(
                      Icons.place_outlined,
                      'Landmark',
                      address.landmark!,
                    ),
                  if (address.pincode != null && address.pincode!.isNotEmpty)
                    _buildAddressDetailRow(
                      Icons.pin_drop_outlined,
                      'Pincode',
                      address.pincode!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AddressController value) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 48,
                color: primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Addresses Found'.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first address to get started with deliveries',
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => value.onAddNew(),
              icon: const Icon(Icons.add_location_alt, size: 20),
              label: Text('Add New Address'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(AddressController value) {
    if (value.addressList.isEmpty) return const SizedBox.shrink();

    return FloatingActionButton.extended(
      onPressed: () => value.onAddNew(),
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 8,
      icon: const Icon(Icons.add, size: 20),
      label: Text(
        'Add New'.tr,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'work':
      case 'office':
        return Icons.work;
      case 'other':
        return Icons.location_on;
      default:
        return Icons.place;
    }
  }

  Color _getAddressTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'home':
        return success;
      case 'work':
      case 'office':
        return info;
      case 'other':
        return warning;
      default:
        return primary;
    }
  }

  void _showDeleteDialog(AddressController value, int addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: error,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Delete Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textPrimary,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this address? This action cannot be undone.',
            style: TextStyle(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                value.onDestroy(addressId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
