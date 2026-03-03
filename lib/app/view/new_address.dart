// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salon_user/app/controller/new_address_controller.dart';
// import 'package:salon_user/app/util/theme.dart';

// class NewAddressScreen extends StatefulWidget {
//   const NewAddressScreen({Key? key}) : super(key: key);

//   @override
//   State<NewAddressScreen> createState() => _NewAddressScreenState();
// }

// class _NewAddressScreenState extends State<NewAddressScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NewAddressController>(
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
//               'Add New Address'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: value.apiCalled == false
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     color: ThemeProvider.appColor,
//                   ),
//                 )
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: SizedBox(
//                             width: double.infinity,
//                             child: TextField(
//                               controller: value.addressTextEditor,
//                               decoration: InputDecoration(
//                                 labelText: 'Address'.tr,
//                                 labelStyle: const TextStyle(
//                                     color: ThemeProvider.appColor,
//                                     fontSize: 15),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 contentPadding: const EdgeInsets.only(
//                                     bottom: 8.0, top: 14.0),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ThemeProvider.appColor),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: SizedBox(
//                             width: double.infinity,
//                             child: TextField(
//                               controller: value.houseTextEditor,
//                               decoration: InputDecoration(
//                                 labelText: 'House / Flat No.'.tr,
//                                 labelStyle: const TextStyle(
//                                     color: ThemeProvider.appColor,
//                                     fontSize: 15),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 contentPadding: const EdgeInsets.only(
//                                     bottom: 8.0, top: 14.0),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ThemeProvider.appColor),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: SizedBox(
//                             width: double.infinity,
//                             child: TextField(
//                               controller: value.landmarkTextEditor,
//                               decoration: InputDecoration(
//                                 labelText: 'Landmark'.tr,
//                                 labelStyle: const TextStyle(
//                                     color: ThemeProvider.appColor,
//                                     fontSize: 15),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 contentPadding: const EdgeInsets.only(
//                                     bottom: 8.0, top: 14.0),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ThemeProvider.appColor),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           child: SizedBox(
//                             width: double.infinity,
//                             child: TextField(
//                               controller: value.pincodeTextEditor,
//                               decoration: InputDecoration(
//                                 labelText: 'Pincode'.tr,
//                                 labelStyle: const TextStyle(
//                                     color: ThemeProvider.appColor,
//                                     fontSize: 15),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 contentPadding: const EdgeInsets.only(
//                                     bottom: 8.0, top: 14.0),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: ThemeProvider.appColor),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                     borderSide: BorderSide(color: Colors.grey)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Column(
//                           children: [
//                             Container(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 10),
//                               decoration: BoxDecoration(
//                                 color: ThemeProvider.greyColor.shade200,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.search,
//                                     color: ThemeProvider.greyColor,
//                                   ),
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(left: 10),
//                                       child: TextField(
//                                         controller: value.searchbarText,
//                                         onChanged: (content) {
//                                           value.onSearchChanged(content);
//                                         },
//                                         decoration: InputDecoration(
//                                             border: InputBorder.none,
//                                             hintText: 'Search location'.tr),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 20,
//                             ),
//                             value.getList.isNotEmpty
//                                 ? Container(
//                                     decoration: const BoxDecoration(
//                                         color: ThemeProvider.whiteColor),
//                                     child: Column(
//                                       children: [
//                                         for (var item in value.getList)
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10, vertical: 10),
//                                             child: InkWell(
//                                               onTap: () {
//                                                 value.getLatLngFromAddressMap(
//                                                     item.description
//                                                         .toString());
//                                               },
//                                               child: Row(
//                                                 children: [
//                                                   const Icon(Icons.search),
//                                                   const SizedBox(
//                                                     width: 10,
//                                                   ),
//                                                   Text(
//                                                     item.description!.length >
//                                                             25
//                                                         ? '${item.description!.substring(0, 25)}...'
//                                                         : item.description!,
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                           )
//                                       ],
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                             value.getList.isEmpty
//                                 ? TextButton(
//                                     onPressed: () {
//                                       value.getLocation();
//                                     },
//                                     child: Text(
//                                       'Use My Current Location'
//                                           .tr
//                                           .toUpperCase(),
//                                       style: const TextStyle(
//                                           color: ThemeProvider.appColor,
//                                           letterSpacing: 1.1),
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                             SizedBox(
//                               height: value.getList.isEmpty ? 20 : 0,
//                             ),
//                             value.getList.isEmpty
//                                 ? SizedBox(
//                                     height: 300,
//                                     width: double.infinity,
//                                     child: Obx(() {
//                                       if (value.myLat.value == 0.0 &&
//                                           value.myLng.value == 0.0) {
//                                         return const Center(
//                                             child: CircularProgressIndicator());
//                                       } else {
//                                         return GoogleMap(
//                                           myLocationButtonEnabled: true,
//                                           myLocationEnabled: true,
//                                           onMapCreated: value.onMapCreated,
//                                           markers: value.markers,
//                                           initialCameraPosition: CameraPosition(
//                                             target: LatLng(value.myLat.value,
//                                                 value.myLng.value),
//                                             zoom: 15,
//                                           ),
//                                           onTap: (position) {
//                                             value.markers.clear();
//                                             value.moveMapToPosition(
//                                                 position.latitude,
//                                                 position.longitude);
//                                             value.myLat.value =
//                                                 position.latitude;
//                                             value.myLng.value =
//                                                 position.longitude;
//                                           },
//                                           onCameraMove: (position) {
//                                             //  value.moveMapToPosition(
//                                             // position.target.latitude,
//                                             // position.target.longitude);
//                                           },
//                                         );
//                                       }
//                                     }),
//                                   )
//                                 : const SizedBox(),
//                             SizedBox(
//                               height: value.getList.isEmpty ? 20 : 0,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Save Address'.tr,
//                               style: const TextStyle(
//                                   fontFamily: 'bold', fontSize: 14),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 value.onFilter(0);
//                               },
//                               child: ListTile(
//                                 leading: Icon(
//                                   Icons.home_outlined,
//                                   color: value.title == 0
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                                 minLeadingWidth: 0,
//                                 title: Text('Home'.tr),
//                                 trailing: Icon(
//                                   value.title == 0
//                                       ? Icons.radio_button_checked
//                                       : Icons.circle_outlined,
//                                   color: value.title == 0
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 value.onFilter(1);
//                               },
//                               child: ListTile(
//                                 leading: Icon(
//                                   Icons.work_outline,
//                                   color: value.title == 1
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                                 minLeadingWidth: 0,
//                                 title: Text('Work'.tr),
//                                 trailing: Icon(
//                                   value.title == 1
//                                       ? Icons.radio_button_checked
//                                       : Icons.circle_outlined,
//                                   color: value.title == 1
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 value.onFilter(2);
//                               },
//                               child: ListTile(
//                                 leading: Icon(
//                                   Icons.home_work_outlined,
//                                   color: value.title == 2
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                                 minLeadingWidth: 0,
//                                 title: Text('Other'.tr),
//                                 trailing: Icon(
//                                   value.title == 2
//                                       ? Icons.radio_button_checked
//                                       : Icons.circle_outlined,
//                                   color: value.title == 2
//                                       ? ThemeProvider.appColor
//                                       : ThemeProvider.greyColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//           bottomNavigationBar: value.action == 'new'
//               ? Padding(
//                   padding: const EdgeInsets.only(
//                       top: 20.0, bottom: 20, left: 20, right: 20),
//                   child: InkWell(
//                     onTap: () {
//                       value.getLatLngFromAddress();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 13.0),
//                       decoration: contentButtonStyle(),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Submit'.tr,
//                             style: const TextStyle(
//                                 color: ThemeProvider.whiteColor, fontSize: 17),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(
//                       top: 40.0, bottom: 20, left: 20, right: 20),
//                   child: InkWell(
//                     onTap: () {
//                       value.updateAddress();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(vertical: 13.0),
//                       decoration: const BoxDecoration(
//                           borderRadius: BorderRadius.all(
//                             Radius.circular(100.0),
//                           ),
//                           color: ThemeProvider.greenColor),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Update'.tr,
//                             style: const TextStyle(
//                                 color: ThemeProvider.whiteColor, fontSize: 17),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//         );
//       },
//     );
//   }
// }

// contentButtonStyle() {
//   return const BoxDecoration(
//     borderRadius: BorderRadius.all(
//       Radius.circular(100.0),
//     ),
//     gradient: LinearGradient(
//       begin: Alignment.centerLeft,
//       end: Alignment.centerRight,
//       colors: [
//         ThemeProvider.pink,
//         ThemeProvider.pink,
//       ],
//     ),
//   );
// }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salon_user/app/controller/new_address_controller.dart';
// import 'package:salon_user/app/util/theme.dart';

// class NewAddressScreen extends StatefulWidget {
//   const NewAddressScreen({Key? key}) : super(key: key);

//   @override
//   State<NewAddressScreen> createState() => _NewAddressScreenState();
// }

// class _NewAddressScreenState extends State<NewAddressScreen> {
//   // Modern Color Scheme
//   static const Color primary = ThemeProvider.pink;
//   static const Color primaryDark = ThemeProvider.pink;
//   static const Color success = Color(0xFF10B981);
//   static const Color warning = Color(0xFFF59E0B);
//   static const Color error = Color(0xFFEF4444);
//   static const Color info = Color(0xFF3B82F6);
//   static const Color background = Color(0xFFF8F9FA);
//   static const Color cardBackground = Colors.white;
//   static const Color textPrimary = Color(0xFF2C3E50);
//   static const Color textSecondary = Color(0xFF64748B);
//   static const Color textLight = Color(0xFF94A3B8);
//   static const Color borderLight = Color(0xFFE2E8F0);
//   static const Color shadowLight = Color(0x0F000000);
//   static const Color surfaceBackground = Color(0xFFF1F5F9);

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NewAddressController>(
//       builder: (value) {
//         return Scaffold(
//           backgroundColor: background,
//           appBar: _buildAppBar(value),
//           body: value.apiCalled == false
//               ? const Center(
//                   child: CircularProgressIndicator(
//                     color: primary,
//                     strokeWidth: 3,
//                   ),
//                 )
//               : _buildBody(value),
//           bottomNavigationBar: _buildBottomNavigationBar(value),
//         );
//       },
//     );
//   }

//   PreferredSizeWidget _buildAppBar(NewAddressController value) {
//     return AppBar(
//       backgroundColor: ThemeProvider.appColor,
//       elevation: 0,
//       centerTitle: true,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back, color: Colors.white),
//         onPressed: () => Get.back(),
//       ),
//       title: Text(
//         value.action == 'new' ? 'Add New Address'.tr : 'Edit Address'.tr,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               ThemeProvider.appColor,
//               ThemeProvider.appColor.withOpacity(0.8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBody(NewAddressController value) {
//     return SingleChildScrollView(
//       physics: const BouncingScrollPhysics(),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildAddressDetailsSection(value),
//             const SizedBox(height: 24),
//             _buildLocationSection(value),
//             const SizedBox(height: 24),
//             _buildAddressTypeSection(value),
//             const SizedBox(height: 100), // Bottom padding for FAB
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressDetailsSection(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: shadowLight,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.edit_location_alt,
//                     color: primary,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Address Details',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             _buildTextField(
//               controller: value.addressTextEditor,
//               label: 'Address'.tr,
//               icon: Icons.location_on_outlined,
//               hint: 'Enter your complete address',
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: value.houseTextEditor,
//               label: 'House / Flat No.'.tr,
//               icon: Icons.home_outlined,
//               hint: 'Building, house no., flat no.',
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: value.landmarkTextEditor,
//               label: 'Landmark'.tr,
//               icon: Icons.place_outlined,
//               hint: 'Nearby landmark (optional)',
//             ),
//             const SizedBox(height: 16),
//             _buildTextField(
//               controller: value.pincodeTextEditor,
//               label: 'Pincode'.tr,
//               icon: Icons.pin_drop_outlined,
//               hint: 'Enter your pincode',
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//     required String hint,
//     TextInputType? keyboardType,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: surfaceBackground,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: borderLight),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: keyboardType,
//         style: const TextStyle(
//           fontSize: 16,
//           color: textPrimary,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           labelStyle: const TextStyle(
//             color: textSecondary,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//           hintStyle: const TextStyle(
//             color: textLight,
//             fontSize: 14,
//           ),
//           prefixIcon: Container(
//             padding: const EdgeInsets.all(12),
//             child: Icon(
//               icon,
//               color: primary,
//               size: 20,
//             ),
//           ),
//           border: InputBorder.none,
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationSection(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: shadowLight,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: info.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.map_outlined,
//                     color: info,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Select Location',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),

//             // Search bar
//             _buildLocationSearchBar(value),
//             const SizedBox(height: 16),

//             // Search results or current location button
//             if (value.getList.isNotEmpty)
//               _buildSearchResults(value)
//             else ...[
//               _buildCurrentLocationButton(value),
//               const SizedBox(height: 16),
//               _buildMapWidget(value),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationSearchBar(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: surfaceBackground,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: borderLight),
//       ),
//       child: TextField(
//         controller: value.searchbarText,
//         onChanged: (content) => value.onSearchChanged(content),
//         style: const TextStyle(
//           fontSize: 16,
//           color: textPrimary,
//           fontWeight: FontWeight.w500,
//         ),
//         decoration: const InputDecoration(
//           hintText: 'Search location...',
//           hintStyle: TextStyle(
//             color: textLight,
//             fontSize: 14,
//           ),
//           prefixIcon: Icon(
//             Icons.search,
//             color: textSecondary,
//             size: 20,
//           ),
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchResults(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: surfaceBackground,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: borderLight),
//       ),
//       child: Column(
//         children: List.generate(
//           value.getList.length,
//           (index) {
//             final item = value.getList[index];
//             return Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 onTap: () =>
//                     value.getLatLngFromAddressMap(item.description.toString()),
//                 borderRadius: BorderRadius.circular(12),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: primary.withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.location_on,
//                           color: primary,
//                           size: 16,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           item.description!.length > 40
//                               ? '${item.description!.substring(0, 40)}...'
//                               : item.description!,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: textPrimary,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                       const Icon(
//                         Icons.arrow_forward_ios,
//                         color: textLight,
//                         size: 16,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCurrentLocationButton(NewAddressController value) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => value.getLocation(),
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: success.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: success.withOpacity(0.3)),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.my_location,
//                 color: success,
//                 size: 20,
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 'Use My Current Location'.tr,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: success,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMapWidget(NewAddressController value) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: borderLight),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Obx(() {
//           if (value.myLat.value == 0.0 && value.myLng.value == 0.0) {
//             return Container(
//               color: surfaceBackground,
//               child: const Center(
//                 child: CircularProgressIndicator(color: primary),
//               ),
//             );
//           } else {
//             return GoogleMap(
//               myLocationButtonEnabled: true,
//               myLocationEnabled: true,
//               onMapCreated: value.onMapCreated,
//               markers: value.markers,
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(value.myLat.value, value.myLng.value),
//                 zoom: 15,
//               ),
//               onTap: (position) {
//                 value.markers.clear();
//                 value.moveMapToPosition(position.latitude, position.longitude);
//                 value.myLat.value = position.latitude;
//                 value.myLng.value = position.longitude;
//               },
//               onCameraMove: (position) {
//                 // Handle camera movement if needed
//               },
//             );
//           }
//         }),
//       ),
//     );
//   }

//   Widget _buildAddressTypeSection(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: cardBackground,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: shadowLight,
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: warning.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Icon(
//                     Icons.label_outline,
//                     color: warning,
//                     size: 20,
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 const Text(
//                   'Save Address As',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: textPrimary,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Column(
//               children: [
//                 _buildAddressTypeOption(
//                   value: value,
//                   type: 0,
//                   icon: Icons.home,
//                   label: 'Home'.tr,
//                   color: success,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildAddressTypeOption(
//                   value: value,
//                   type: 1,
//                   icon: Icons.work,
//                   label: 'Work'.tr,
//                   color: info,
//                 ),
//                 const SizedBox(height: 12),
//                 _buildAddressTypeOption(
//                   value: value,
//                   type: 2,
//                   icon: Icons.location_on,
//                   label: 'Other'.tr,
//                   color: warning,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddressTypeOption({
//     required NewAddressController value,
//     required int type,
//     required IconData icon,
//     required String label,
//     required Color color,
//   }) {
//     final bool isSelected = value.title == type;

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () => value.onFilter(type),
//         borderRadius: BorderRadius.circular(12),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: isSelected ? color.withOpacity(0.1) : surfaceBackground,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: isSelected ? color : borderLight,
//               width: isSelected ? 2 : 1,
//             ),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? color : color.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: isSelected ? Colors.white : color,
//                   size: 20,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: isSelected ? color : textSecondary,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: BoxDecoration(
//                   color: isSelected ? color : Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected ? color : textLight,
//                     width: 2,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 14,
//                       )
//                     : const SizedBox(width: 14, height: 14),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar(NewAddressController value) {
//     return Container(
//       decoration: BoxDecoration(
//         color: cardBackground,
//         boxShadow: const [
//           BoxShadow(
//             color: shadowLight,
//             blurRadius: 20,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: () {
//                 if (value.action == 'new') {
//                   value.getLatLngFromAddress();
//                 } else {
//                   value.updateAddress();
//                 }
//               },
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 height: 56,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [primary, primaryDark],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: primary.withOpacity(0.3),
//                       blurRadius: 20,
//                       offset: const Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: Center(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         value.action == 'new'
//                             ? Icons.add_location_alt
//                             : Icons.update_outlined,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         value.action == 'new'
//                             ? 'Save Address'.tr
//                             : 'Update Address'.tr,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                           letterSpacing: 0.5,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/new_address_controller.dart';
import 'package:salon_user/app/util/theme.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({Key? key}) : super(key: key);

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.appColor;
  static const Color primaryDark = ThemeProvider.appColor;
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
    return GetBuilder<NewAddressController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          appBar: _buildAppBar(value),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 3,
                  ),
                )
              : _buildBody(value),
          bottomNavigationBar: _buildBottomNavigationBar(value),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(NewAddressController value) {
    return AppBar(
      backgroundColor: primary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Get.back(),
      ),
      title: Text(
        value.action == 'new' ? 'Add New Address'.tr : 'Edit Address'.tr,
        style: const TextStyle(
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
              primary,
              primary.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NewAddressController value) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressDetailsSection(value),
            const SizedBox(height: 24),
            _buildLocationSection(value),
            const SizedBox(height: 24),
            _buildAddressTypeSection(value),
            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailsSection(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.edit_location_alt,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Address Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: value.addressTextEditor,
              label: 'Address'.tr,
              icon: Icons.location_on_outlined,
              hint: 'Enter your complete address',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: value.houseTextEditor,
              label: 'House / Flat No.'.tr,
              icon: Icons.home_outlined,
              hint: 'Building, house no., flat no.',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: value.landmarkTextEditor,
              label: 'Landmark'.tr,
              icon: Icons.place_outlined,
              hint: 'Nearby landmark (optional)',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: value.pincodeTextEditor,
              label: 'Pincode'.tr,
              icon: Icons.pin_drop_outlined,
              hint: 'Enter your pincode',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            color: textLight,
            fontSize: 14,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: primary,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Widget _buildLocationSection(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.map_outlined,
                    color: info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Select Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Search bar
            _buildLocationSearchBar(value),
            const SizedBox(height: 16),

            // Search results or current location button
            if (value.getList.isNotEmpty)
              _buildSearchResults(value)
            else ...[
              _buildCurrentLocationButton(value),
              const SizedBox(height: 16),
              _buildMapWidget(value),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSearchBar(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: TextField(
        controller: value.searchbarText,
        onChanged: (content) => value.onSearchChanged(content),
        style: const TextStyle(
          fontSize: 16,
          color: textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          hintText: 'Search location...',
          hintStyle: TextStyle(
            color: textLight,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: textSecondary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSearchResults(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: Column(
        children: List.generate(
          value.getList.length,
          (index) {
            final item = value.getList[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    value.getLatLngFromAddressMap(item.description.toString()),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: primary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.description!.length > 40
                              ? '${item.description!.substring(0, 40)}...'
                              : item.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: textLight,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentLocationButton(NewAddressController value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => value.getLocation(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: success.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.my_location,
                color: success,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Use My Current Location'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: success,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapWidget(NewAddressController value) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Obx(() {
          if (value.myLat.value == 0.0 && value.myLng.value == 0.0) {
            return Container(
              color: surfaceBackground,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primary),
                    SizedBox(height: 16),
                    Text(
                      'Loading map...',
                      style: TextStyle(color: textSecondary),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Stack(
              children: [
                GoogleMap(
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  onMapCreated: value.onMapCreated,
                  markers: value.markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(value.myLat.value, value.myLng.value),
                    zoom: 16,
                  ),
                  onTap: value.onMapTap,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  tiltGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: true,
                ),
                // Custom location button
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () => value.getLocation(),
                    backgroundColor: cardBackground,
                    foregroundColor: primary,
                    elevation: 4,
                    child: const Icon(Icons.my_location, size: 20),
                  ),
                ),
                // Location info overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardBackground.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: shadowLight,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: primary,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tap on the map to select your exact location',
                            style: const TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Widget _buildAddressTypeSection(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.label_outline,
                    color: warning,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Save Address As',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildAddressTypeOption(
                  value: value,
                  type: 0,
                  icon: Icons.home,
                  label: 'Home'.tr,
                  color: success,
                ),
                const SizedBox(height: 12),
                _buildAddressTypeOption(
                  value: value,
                  type: 1,
                  icon: Icons.work,
                  label: 'Work'.tr,
                  color: info,
                ),
                const SizedBox(height: 12),
                _buildAddressTypeOption(
                  value: value,
                  type: 2,
                  icon: Icons.location_on,
                  label: 'Other'.tr,
                  color: warning,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressTypeOption({
    required NewAddressController value,
    required int type,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final bool isSelected = value.title == type;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => value.onFilter(type),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : surfaceBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : borderLight,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : textSecondary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? color : textLight,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : const SizedBox(width: 14, height: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(NewAddressController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (value.action == 'new') {
                  value.getLatLngFromAddress();
                } else {
                  value.updateAddress();
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeProvider.pink, ThemeProvider.pink],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        value.action == 'new'
                            ? Icons.add_location_alt
                            : Icons.update_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        value.action == 'new'
                            ? 'Save Address'.tr
                            : 'Update Address'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
