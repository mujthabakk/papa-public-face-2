// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salon_user/app/controller/service_cart_controller.dart';
// import 'package:salon_user/app/controller/services_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';

// class ServicesScreen extends StatefulWidget {
//   const ServicesScreen({Key? key}) : super(key: key);

//   @override
//   State<ServicesScreen> createState() => _ServicesScreenState();
// }

// class _ServicesScreenState extends State<ServicesScreen> {
//   int tabID = 1;

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ServicesController>(
//       builder: (value) {
//         return Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: ThemeProvider.whiteColor,
//           body: value.apiCalled == false
//               ? const Center(
//                   child:
//                       CircularProgressIndicator(color: ThemeProvider.appColor),
//                 )
//               : CustomScrollView(
//                   slivers: [
//                     SliverAppBar(
//                       backgroundColor: ThemeProvider.backgroundColor,
//                       floating: true,
//                       pinned: true,
//                       toolbarHeight: 230,
//                       snap: false,
//                       elevation: 0,
//                       forceElevated: true,
//                       iconTheme:
//                           const IconThemeData(color: ThemeProvider.appColor),
//                       automaticallyImplyLeading: false,
//                       titleSpacing: 0,
//                       title: Column(
//                         children: [
//                           Container(
//                             height: 160,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                   image: NetworkImage(
//                                       '${Environments.imageURL}${value.salonDetails.cover.toString()}'),
//                                   fit: BoxFit.cover),
//                             ),
//                             child: Stack(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.bottomCenter,
//                                   child: Container(
//                                     height: 100,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: const BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           Colors.transparent,
//                                           Colors.black,
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Align(
//                                   alignment: Alignment.topCenter,
//                                   child: Container(
//                                     height: 50,
//                                     width: MediaQuery.of(context).size.width,
//                                     decoration: const BoxDecoration(
//                                       gradient: LinearGradient(
//                                         begin: Alignment.topCenter,
//                                         end: Alignment.bottomCenter,
//                                         colors: [
//                                           Colors.black,
//                                           Colors.transparent,
//                                         ],
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 10),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           CircleAvatar(
//                                             radius: 20,
//                                             backgroundColor:
//                                                 ThemeProvider.transparent,
//                                             child: IconButton(
//                                               icon: const Icon(
//                                                 Icons.arrow_back,
//                                                 color: ThemeProvider.whiteColor,
//                                               ),
//                                               onPressed: () {
//                                                 Get.back();
//                                               },
//                                             ),
//                                           ),
//                                           // CircleAvatar(
//                                           //   radius: 20,
//                                           //   backgroundColor:
//                                           //       ThemeProvider.transparent,
//                                           //   child: IconButton(
//                                           //     icon: const Icon(
//                                           //       Icons.save_alt,
//                                           //       color: ThemeProvider.whiteColor,
//                                           //     ),
//                                           //     onPressed: () {
//                                           //       //
//                                           //     },
//                                           //   ),
//                                           // ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 20),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       Text(
//                                         value.salonDetails.name.toString(),
//                                         overflow: TextOverflow.ellipsis,
//                                         style: const TextStyle(
//                                             color: ThemeProvider.whiteColor,
//                                             fontFamily: 'bold',
//                                             fontSize: 17),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 5, bottom: 3),
//                                         child: Text(
//                                           value.salonDetails.address.toString(),
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.whiteColor,
//                                               fontSize: 13),
//                                         ),
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           RichText(
//                                             text: TextSpan(
//                                               children: [
//                                                 const WidgetSpan(
//                                                   child: Icon(
//                                                     Icons.star,
//                                                     size: 15,
//                                                     color: ThemeProvider
//                                                         .orangeColor,
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text:
//                                                       ' (${value.salonDetails.totalRating} ${'Reviews)'.tr}',
//                                                   style: const TextStyle(
//                                                       fontSize: 12,
//                                                       color: ThemeProvider
//                                                           .whiteColor),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           Container(
//                                             height: 25,
//                                             width: 60,
//                                             decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               border: Border.all(
//                                                   color:
//                                                       ThemeProvider.greenColor),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 'OPEN'.tr,
//                                                 style: const TextStyle(
//                                                     color: ThemeProvider
//                                                         .greenColor,
//                                                     fontSize: 10),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Container(
//                             color: ThemeProvider.appColor,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       //
//                                       value.openWebsite();
//                                     },
//                                     child: Column(
//                                       children: [
//                                         const Icon(
//                                           Icons.language,
//                                           size: 40,
//                                           color: ThemeProvider.greyColor,
//                                         ),
//                                         Text(
//                                           'Website'.tr,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: ThemeProvider.greyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       //
//                                       value.callSalon();
//                                     },
//                                     child: Column(
//                                       children: [
//                                         const Icon(
//                                           Icons.call,
//                                           size: 40,
//                                           color: ThemeProvider.greyColor,
//                                         ),
//                                         Text(
//                                           'Call'.tr,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: ThemeProvider.greyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       //
//                                       value.onChat();
//                                     },
//                                     child: Column(
//                                       children: [
//                                         const Icon(
//                                           Icons.chat_outlined,
//                                           size: 40,
//                                           color: ThemeProvider.greyColor,
//                                         ),
//                                         Text(
//                                           'Chat'.tr,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: ThemeProvider.greyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       //
//                                       value.openMap();
//                                     },
//                                     child: Column(
//                                       children: [
//                                         const Icon(
//                                           Icons.directions,
//                                           size: 40,
//                                           color: ThemeProvider.greyColor,
//                                         ),
//                                         Text(
//                                           'Direction'.tr,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: ThemeProvider.greyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   InkWell(
//                                     onTap: () {
//                                       ///
//                                       value.share();
//                                     },
//                                     child: Column(
//                                       children: [
//                                         const Icon(
//                                           Icons.offline_share,
//                                           size: 40,
//                                           color: ThemeProvider.greyColor,
//                                         ),
//                                         Text(
//                                           'Share'.tr,
//                                           style: const TextStyle(
//                                               fontSize: 12,
//                                               color: ThemeProvider.greyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(
//                           //       vertical: 5, horizontal: 10),
//                           //   child: Row(
//                           //     children: [
//                           //       Text(
//                           //         'Salon Specialist'.tr,
//                           //         style: const TextStyle(
//                           //             fontSize: 14,
//                           //             fontFamily: 'bold',
//                           //             color: ThemeProvider.blackColor),
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                           // Padding(
//                           //   padding: const EdgeInsets.symmetric(horizontal: 10),
//                           //   child: SingleChildScrollView(
//                           //     scrollDirection: Axis.horizontal,
//                           //     child: Row(
//                           //       children: [
//                           //         for (var item in value.specialistList)
//                           //           Padding(
//                           //             padding: const EdgeInsets.all(10.0),
//                           //             child: Column(
//                           //               children: [
//                           //                 Container(
//                           //                   decoration: BoxDecoration(
//                           //                     borderRadius:
//                           //                         BorderRadius.circular(100.0),
//                           //                     border: Border.all(
//                           //                       width: 2,
//                           //                       color: ThemeProvider.appColor,
//                           //                     ),
//                           //                   ),
//                           //                   child: Padding(
//                           //                     padding:
//                           //                         const EdgeInsets.all(3.0),
//                           //                     child: ClipRRect(
//                           //                       borderRadius:
//                           //                           BorderRadius.circular(100),
//                           //                       child: SizedBox.fromSize(
//                           //                         size:
//                           //                             const Size.fromRadius(25),
//                           //                         child: FadeInImage(
//                           //                           image: NetworkImage(
//                           //                               '${Environments.imageURL}${item.cover}'),
//                           //                           placeholder: const AssetImage(
//                           //                               "assets/images/placeholder.jpeg"),
//                           //                           imageErrorBuilder: (context,
//                           //                               error, stackTrace) {
//                           //                             return Image.asset(
//                           //                                 'assets/images/notfound.png',
//                           //                                 fit: BoxFit.cover);
//                           //                           },
//                           //                           fit: BoxFit.cover,
//                           //                         ),
//                           //                       ),
//                           //                     ),
//                           //                   ),
//                           //                 ),
//                           //                 Padding(
//                           //                   padding: const EdgeInsets.only(
//                           //                       top: 10, bottom: 3),
//                           //                   child: Text(
//                           //                     '${item.firstName} ${item.lastName}',
//                           //                     style: const TextStyle(
//                           //                         fontSize: 12,
//                           //                         color:
//                           //                             ThemeProvider.blackColor),
//                           //                   ),
//                           //                 ),
//                           //               ],
//                           //             ),
//                           //           )
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                       bottom: PreferredSize(
//                         preferredSize: const Size.fromHeight(56),
//                         child: AppBar(
//                           titleSpacing: 0,
//                           automaticallyImplyLeading: false,
//                           elevation: 0,
//                           backgroundColor: ThemeProvider.backgroundColor,
//                           title: DefaultTabController(
//                             length: 4,
//                             child: Column(
//                               children: [
//                                 TabBar(
//                                   controller: value.tabController,
//                                   labelColor: ThemeProvider.blackColor,
//                                   isScrollable: false,
//                                   labelStyle:
//                                       const TextStyle(fontFamily: 'regular'),
//                                   unselectedLabelColor: ThemeProvider.greyColor,
//                                   labelPadding: const EdgeInsets.symmetric(
//                                       horizontal: 10.0),
//                                   indicator: const UnderlineTabIndicator(
//                                     borderSide: BorderSide(
//                                         width: 2.0,
//                                         color: ThemeProvider.appColor),
//                                   ),
//                                   tabs: [
//                                     Tab(
//                                       text: 'Services'.tr,
//                                     ),
//                                     Tab(
//                                       text: 'About'.tr,
//                                     ),
//                                     Tab(
//                                       text: 'Gallary'.tr,
//                                     ),
//                                     Tab(
//                                       text: 'Review'.tr,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SliverList(
//                       delegate: SliverChildListDelegate(
//                         [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height,
//                             child: TabBarView(
//                               controller: value.tabController,
//                               children: [
//                                 SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 10),
//                                     child: Column(
//                                       children: [
//                                         _buildSegment(),
//                                         if (tabID == 1)
//                                           //  for (var item in value.servicesList)
//                                           Column(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(10.0),
//                                                 child: Column(
//                                                   children: [
//                                                     ListView.builder(
//                                                       padding: EdgeInsets.zero,
//                                                       itemCount: value
//                                                           .servicesList.length,
//                                                       physics:
//                                                           const ScrollPhysics(),
//                                                       shrinkWrap: true,
//                                                       itemBuilder:
//                                                           (context, i) =>
//                                                               Column(
//                                                         children: [
//                                                           Container(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(10),
//                                                             margin:
//                                                                 const EdgeInsets
//                                                                     .symmetric(
//                                                                     vertical:
//                                                                         10),
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           5),
//                                                               color: ThemeProvider
//                                                                   .whiteColor,
//                                                               boxShadow: const [
//                                                                 BoxShadow(
//                                                                   color: ThemeProvider
//                                                                       .greyColor,
//                                                                   blurRadius:
//                                                                       5.0,
//                                                                   offset:
//                                                                       Offset(
//                                                                           0.7,
//                                                                           2.0),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                             child: Row(
//                                                               children: [
//                                                                 Stack(
//                                                                   children: [
//                                                                     ClipRRect(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               5),
//                                                                       child: SizedBox
//                                                                           .fromSize(
//                                                                         size: const Size
//                                                                             .fromRadius(
//                                                                             40),
//                                                                         child:
//                                                                             FadeInImage(
//                                                                           image:
//                                                                               NetworkImage('${Environments.imageURL}${value.servicesList[i].cover}'),
//                                                                           placeholder:
//                                                                               const AssetImage("assets/images/placeholder.jpeg"),
//                                                                           imageErrorBuilder: (context,
//                                                                               error,
//                                                                               stackTrace) {
//                                                                             return Image.asset('assets/images/notfound.png',
//                                                                                 fit: BoxFit.cover);
//                                                                           },
//                                                                           fit: BoxFit
//                                                                               .cover,
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                     Positioned(
//                                                                       top: 0,
//                                                                       left: 0,
//                                                                       child:
//                                                                           Container(
//                                                                         height:
//                                                                             20,
//                                                                         width:
//                                                                             40,
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color: ThemeProvider
//                                                                               .blackColor
//                                                                               .withOpacity(0.5),
//                                                                           borderRadius:
//                                                                               BorderRadius.circular(5),
//                                                                         ),
//                                                                         child:
//                                                                             Center(
//                                                                           child:
//                                                                               Text(
//                                                                             '${value.servicesList[i].discount}  %',
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             style:
//                                                                                 const TextStyle(fontSize: 10, color: ThemeProvider.whiteColor),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 const SizedBox(
//                                                                     width: 10),
//                                                                 Expanded(
//                                                                   child: Stack(
//                                                                     clipBehavior:
//                                                                         Clip.none,
//                                                                     children: [
//                                                                       Positioned(
//                                                                         right:
//                                                                             20,
//                                                                         top: 10,
//                                                                         child:
//                                                                             Checkbox(
//                                                                           checkColor:
//                                                                               Colors.white,
//                                                                           activeColor:
//                                                                               ThemeProvider.appColor,
//                                                                           value: value
//                                                                               .servicesList[i]
//                                                                               .isChecked,
//                                                                           onChanged:
//                                                                               (status) {
//                                                                             value.updateServiceStatusInCart(i,
//                                                                                 status as bool);
//                                                                           },
//                                                                         ),
//                                                                       ),
//                                                                       Column(
//                                                                         crossAxisAlignment:
//                                                                             CrossAxisAlignment.start,
//                                                                         children: [
//                                                                           Text(
//                                                                             value.servicesList[i].name.toString(),
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             style:
//                                                                                 const TextStyle(fontFamily: 'bold', fontSize: 14),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               height: 2),
//                                                                           Row(
//                                                                             children: [
//                                                                               //  const Icon(Icons.attach_money, size: 14, color: ThemeProvider.greyColor),
//                                                                               const SizedBox(width: 4),
//                                                                               RichText(
//                                                                                 text: TextSpan(
//                                                                                   children: [
//                                                                                     TextSpan(
//                                                                                       text: Get.find<ServicesController>().currencySide == 'left' ? '${Get.find<ServicesController>().currencySymbol}  ${value.servicesList[i].price}' : '  ${value.servicesList[i].price}${Get.find<ServicesController>().currencySymbol}',
//                                                                                       style: const TextStyle(fontSize: 12, color: ThemeProvider.greyColor, decoration: TextDecoration.lineThrough),
//                                                                                     ),
//                                                                                     TextSpan(
//                                                                                       text: Get.find<ServicesController>().currencySide == 'left' ? '${Get.find<ServicesController>().currencySymbol}  ${value.servicesList[i].off}' : '  ${value.servicesList[i].off}${Get.find<ServicesController>().currencySymbol}',
//                                                                                       style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'bold'),
//                                                                                     ),
//                                                                                   ],
//                                                                                 ),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           Row(
//                                                                             children: [
//                                                                               const Icon(Icons.timer, size: 14, color: ThemeProvider.greyColor),
//                                                                               const SizedBox(width: 4),
//                                                                               Text(
//                                                                                 '${value.servicesList[i].duration} min',
//                                                                                 overflow: TextOverflow.ellipsis,
//                                                                                 style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               height: 2),
//                                                                           Row(
//                                                                             children: [
//                                                                               const Icon(Icons.person, size: 14, color: ThemeProvider.greyColor),
//                                                                               const SizedBox(width: 4),
//                                                                               Text(
//                                                                                 _getGenderText(value.servicesList[i].gender),
//                                                                                 style: const TextStyle(fontSize: 12, color: ThemeProvider.greyColor),
//                                                                               ),
//                                                                             ],
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         else if (tabID == 2)
//                                           for (var item in value.packagesList)
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 5),
//                                               child: Column(
//                                                 children: [
//                                                   Container(
//                                                     height: 150,
//                                                     width: double.infinity,
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5),
//                                                     ),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5),
//                                                       child: FadeInImage(
//                                                         image: NetworkImage(
//                                                             '${Environments.imageURL}${item.cover}'),
//                                                         placeholder:
//                                                             const AssetImage(
//                                                                 "assets/images/placeholder.jpeg"),
//                                                         imageErrorBuilder:
//                                                             (context, error,
//                                                                 stackTrace) {
//                                                           return Image.asset(
//                                                               'assets/images/notfound.png',
//                                                               fit:
//                                                                   BoxFit.cover);
//                                                         },
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 10, bottom: 3),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Expanded(
//                                                           child: Text(
//                                                             item.name
//                                                                 .toString(),
//                                                             maxLines: 1,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .blackColor,
//                                                                 fontFamily:
//                                                                     'bold'),
//                                                           ),
//                                                         ),
//                                                         InkWell(
//                                                           onTap: () {
//                                                             value.onPackagesDetails(
//                                                                 item.id as int,
//                                                                 item.name
//                                                                     .toString());
//                                                           },
//                                                           child: Text(
//                                                             'View'.tr,
//                                                             style: const TextStyle(
//                                                                 color:
//                                                                     ThemeProvider
//                                                                         .appColor,
//                                                                 fontFamily:
//                                                                     'bold'),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: [
//                                                       Text(
//                                                         Get.find<ServicesController>()
//                                                                     .currencySide ==
//                                                                 'left'
//                                                             ? '${Get.find<ServicesController>().currencySymbol}  ${item.price}'
//                                                             : '  ${item.price}${Get.find<ServicesController>().currencySymbol}',
//                                                         style: const TextStyle(
//                                                             color: ThemeProvider
//                                                                 .greyColor,
//                                                             fontSize: 12),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 10),
//                                     child: Column(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     'About'.tr,
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontFamily: 'bold',
//                                                         color: ThemeProvider
//                                                             .blackColor),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Text(
//                                               value.salonDetails.about
//                                                   .toString(),
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.blackColor,
//                                                   fontSize: 15),
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     'Opening Hour'.tr,
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontFamily: 'bold',
//                                                         color: ThemeProvider
//                                                             .blackColor),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Column(
//                                                 children: List.generate(
//                                               value.salonDetails.timing!.length,
//                                               (index) => Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 5),
//                                                 child: Row(
//                                                   children: [
//                                                     const Icon(Icons.circle,
//                                                         color: ThemeProvider
//                                                             .greenColor,
//                                                         size: 15),
//                                                     const SizedBox(width: 10),
//                                                     Expanded(
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           Text(
//                                                             value.dayList[value
//                                                                 .salonDetails
//                                                                 .timing![index]
//                                                                 .day as int],
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                           Text(
//                                                             '${value.salonDetails.timing![index].openTime}   :   ${value.salonDetails.timing![index].closeTime}',
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .blackColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             )),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                               child: Row(
//                                                 children: [
//                                                   Text(
//                                                     'Address'.tr,
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontFamily: 'bold',
//                                                         color: ThemeProvider
//                                                             .blackColor),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Expanded(
//                                                     child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               right: 10),
//                                                       child: Text(
//                                                         value.salonDetails
//                                                             .address
//                                                             .toString(),
//                                                         maxLines: 2,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: const TextStyle(
//                                                             fontSize: 12,
//                                                             color: ThemeProvider
//                                                                 .greyColor),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(height: 10),
//                                                     RichText(
//                                                       text: TextSpan(
//                                                         children: [
//                                                           const WidgetSpan(
//                                                             child: Icon(
//                                                               Icons
//                                                                   .near_me_outlined,
//                                                               size: 15,
//                                                               color: ThemeProvider
//                                                                   .orangeColor,
//                                                             ),
//                                                           ),
//                                                           TextSpan(
//                                                             text:
//                                                                 '${' Get Direction - '.tr}${value.getDistance}KM',
//                                                             style: const TextStyle(
//                                                                 fontSize: 12,
//                                                                 color: ThemeProvider
//                                                                     .orangeColor),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )),
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                   child: SizedBox.fromSize(
//                                                     size: const Size.fromRadius(
//                                                         35),
//                                                     child: GoogleMap(
//                                                         onMapCreated: value
//                                                             .onMapCreated(),
//                                                         markers: value.markers,
//                                                         initialCameraPosition:
//                                                             CameraPosition(
//                                                                 target: LatLng(
//                                                                     value.salonDetails
//                                                                             .lat
//                                                                         as double,
//                                                                     value.salonDetails
//                                                                             .lng
//                                                                         as double),
//                                                                 zoom: 5),
//                                                         myLocationButtonEnabled:
//                                                             false,
//                                                         zoomControlsEnabled:
//                                                             false),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 10),
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   Text(
//                                                     'Photos'.tr,
//                                                     style: const TextStyle(
//                                                         fontSize: 14,
//                                                         fontFamily: 'bold',
//                                                         color: ThemeProvider
//                                                             .blackColor),
//                                                   ),
//                                                   Text(
//                                                     'View All'.tr,
//                                                     style: const TextStyle(
//                                                         fontSize: 12,
//                                                         color: ThemeProvider
//                                                             .greyColor),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             SingleChildScrollView(
//                                               scrollDirection: Axis.horizontal,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: List.generate(
//                                                   value.gallery.length,
//                                                   (index) => Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             10.0),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               5),
//                                                       child: SizedBox.fromSize(
//                                                         size: const Size
//                                                             .fromRadius(35),
//                                                         child: FadeInImage(
//                                                           image: NetworkImage(
//                                                               '${Environments.imageURL}${value.gallery[index].toString()}'),
//                                                           placeholder:
//                                                               const AssetImage(
//                                                                   "assets/images/placeholder.jpeg"),
//                                                           imageErrorBuilder:
//                                                               (context, error,
//                                                                   stackTrace) {
//                                                             return Image.asset(
//                                                                 'assets/images/notfound.png',
//                                                                 fit: BoxFit
//                                                                     .cover);
//                                                           },
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 10),
//                                     child: value.gallery.isNotEmpty
//                                         ? Column(
//                                             children: [
//                                               GridView.count(
//                                                 primary: false,
//                                                 crossAxisCount: 2,
//                                                 mainAxisSpacing: 10,
//                                                 crossAxisSpacing: 10,
//                                                 shrinkWrap: true,
//                                                 childAspectRatio: 100 / 100,
//                                                 padding: EdgeInsets.zero,
//                                                 children: List.generate(
//                                                   value.gallery.length,
//                                                   (index) {
//                                                     return Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               10.0),
//                                                       child: ClipRRect(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(5),
//                                                         child:
//                                                             SizedBox.fromSize(
//                                                           size: const Size
//                                                               .fromRadius(35),
//                                                           child: FadeInImage(
//                                                             image: NetworkImage(
//                                                                 '${Environments.imageURL}${value.gallery[index].toString()}'),
//                                                             placeholder:
//                                                                 const AssetImage(
//                                                                     "assets/images/placeholder.jpeg"),
//                                                             imageErrorBuilder:
//                                                                 (context, error,
//                                                                     stackTrace) {
//                                                               return Image.asset(
//                                                                   'assets/images/notfound.png',
//                                                                   fit: BoxFit
//                                                                       .cover);
//                                                             },
//                                                             fit: BoxFit.cover,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.center,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               const SizedBox(height: 20),
//                                               SizedBox(
//                                                 height: 80,
//                                                 width: 80,
//                                                 child: Image.asset(
//                                                   "assets/images/no-data.png",
//                                                   fit: BoxFit.cover,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 height: 30,
//                                               ),
//                                               Center(
//                                                 child: Text(
//                                                   'No Found'.tr,
//                                                   style: const TextStyle(
//                                                       fontFamily: 'bold'),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                   ),
//                                 ),
//                                 SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10),
//                                     child: Column(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               top: 10, left: 10),
//                                           child: Row(
//                                             children: [
//                                               Text(
//                                                 '${'All Reviews '.tr}(${value.ownerReviewsList.length})',
//                                                 style: const TextStyle(
//                                                     color: ThemeProvider
//                                                         .greyColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         value.ownerReviewsList.isNotEmpty
//                                             ? Column(
//                                                 children: List.generate(
//                                                 value.ownerReviewsList.length,
//                                                 (index) => Container(
//                                                   margin: const EdgeInsets
//                                                       .symmetric(vertical: 10),
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     border: Border(
//                                                         bottom: BorderSide(
//                                                             color: ThemeProvider
//                                                                 .backgroundColor),
//                                                         top: BorderSide(
//                                                             color: ThemeProvider
//                                                                 .backgroundColor)),
//                                                   ),
//                                                   child: Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal: 10,
//                                                                 vertical: 10),
//                                                         child: Row(
//                                                           children: [
//                                                             ClipRRect(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           100),
//                                                               child: SizedBox
//                                                                   .fromSize(
//                                                                 size: const Size
//                                                                     .fromRadius(
//                                                                     30),
//                                                                 child:
//                                                                     FadeInImage(
//                                                                   image: NetworkImage(
//                                                                       '${Environments.imageURL}${value.ownerReviewsList[index].user!.cover.toString()}'),
//                                                                   placeholder:
//                                                                       const AssetImage(
//                                                                           "assets/images/placeholder.jpeg"),
//                                                                   imageErrorBuilder:
//                                                                       (context,
//                                                                           error,
//                                                                           stackTrace) {
//                                                                     return Image
//                                                                         .asset(
//                                                                       'assets/images/notfound.png',
//                                                                       fit: BoxFit
//                                                                           .cover,
//                                                                       height:
//                                                                           30,
//                                                                       width: 30,
//                                                                     );
//                                                                   },
//                                                                   fit: BoxFit
//                                                                       .cover,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                             Expanded(
//                                                               child: Padding(
//                                                                 padding: const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         10),
//                                                                 child: Column(
//                                                                   children: [
//                                                                     Row(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .spaceBetween,
//                                                                       children: [
//                                                                         SizedBox(
//                                                                           width:
//                                                                               120,
//                                                                           child:
//                                                                               Text(
//                                                                             '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
//                                                                             overflow:
//                                                                                 TextOverflow.ellipsis,
//                                                                             style:
//                                                                                 const TextStyle(fontSize: 15),
//                                                                           ),
//                                                                         ),
//                                                                         Row(
//                                                                           children: [
//                                                                             const Icon(
//                                                                               Icons.star,
//                                                                               color: ThemeProvider.orangeColor,
//                                                                               size: 15,
//                                                                             ),
//                                                                             SizedBox(
//                                                                               child: Text(
//                                                                                 value.ownerReviewsList[index].rating.toString(),
//                                                                                 overflow: TextOverflow.ellipsis,
//                                                                                 style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 12),
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                     Row(
//                                                                       children: [
//                                                                         Icon(
//                                                                             Icons
//                                                                                 .star,
//                                                                             color: value.ownerReviewsList[index].rating! >= 1
//                                                                                 ? ThemeProvider.orangeColor
//                                                                                 : ThemeProvider.greyColor,
//                                                                             size: 15),
//                                                                         Icon(
//                                                                             Icons
//                                                                                 .star,
//                                                                             color: value.ownerReviewsList[index].rating! >= 2
//                                                                                 ? ThemeProvider.orangeColor
//                                                                                 : ThemeProvider.greyColor,
//                                                                             size: 15),
//                                                                         Icon(
//                                                                             Icons
//                                                                                 .star,
//                                                                             color: value.ownerReviewsList[index].rating! >= 3
//                                                                                 ? ThemeProvider.orangeColor
//                                                                                 : ThemeProvider.greyColor,
//                                                                             size: 15),
//                                                                         Icon(
//                                                                             Icons
//                                                                                 .star,
//                                                                             color: value.ownerReviewsList[index].rating! >= 4
//                                                                                 ? ThemeProvider.orangeColor
//                                                                                 : ThemeProvider.greyColor,
//                                                                             size: 15),
//                                                                         Icon(
//                                                                             Icons
//                                                                                 .star,
//                                                                             color: value.ownerReviewsList[index].rating! >= 5
//                                                                                 ? ThemeProvider.orangeColor
//                                                                                 : ThemeProvider.greyColor,
//                                                                             size: 15),
//                                                                       ],
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .symmetric(
//                                                                 horizontal: 10,
//                                                                 vertical: 5),
//                                                         child: Text(
//                                                           value
//                                                               .ownerReviewsList[
//                                                                   index]
//                                                               .notes!,
//                                                           style:
//                                                               const TextStyle(
//                                                                   fontSize: 12),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ))
//                                             : Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   const SizedBox(height: 20),
//                                                   SizedBox(
//                                                     height: 80,
//                                                     width: 80,
//                                                     child: Image.asset(
//                                                       "assets/images/no-data.png",
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(
//                                                     height: 30,
//                                                   ),
//                                                   Center(
//                                                     child: Text(
//                                                       'No Found'.tr,
//                                                       style: const TextStyle(
//                                                           fontFamily: 'bold'),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//           bottomNavigationBar:
//               Get.find<ServiceCartController>().totalItemsInCart > 0 &&
//                       Get.find<ServiceCartController>().servicesFrom == 'salon'
//                   ? SizedBox(
//                       height: 70,
//                       child: InkWell(
//                         onTap: () {
//                           value.onCheckout();
//                         },
//                         child: Container(
//                           margin: const EdgeInsets.all(10),
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           decoration: BoxDecoration(
//                             color: ThemeProvider.pink,
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 value.currencySide == 'left'
//                                     ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
//                                     : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
//                                 style: const TextStyle(
//                                     color: ThemeProvider.whiteColor),
//                               ),
//                               Text(
//                                 'Book Services'.tr,
//                                 style: const TextStyle(
//                                     color: ThemeProvider.whiteColor),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )
//                   : const SizedBox(),
//         );
//       },
//     );
//   }

//   String _getGenderText(int? gender) {
//     switch (gender) {
//       case 0:
//         return 'Male';
//       case 1:
//         return 'Female';
//       case 2:
//         return 'Kid';
//       case 3:
//         return 'Family';
//       default:
//         return 'Unknown'; // Fallback if gender is null or out of range
//     }
//   }

//   Widget _buildSegment() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(color: ThemeProvider.appColor),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     tabID = 1;
//                   });
//                 },
//                 child: Container(
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: tabID == 1
//                         ? ThemeProvider.appColor
//                         : Colors.transparent,
//                     borderRadius: tabID == 1
//                         ? const BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             bottomLeft: Radius.circular(10),
//                           )
//                         : BorderRadius.circular(0),
//                   ),
//                   child: Center(
//                       child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Text('Services'.tr, style: segmentText(1)),
//                   )),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: InkWell(
//                 onTap: () {
//                   setState(() {
//                     tabID = 2;
//                   });
//                 },
//                 child: Container(
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: tabID == 2
//                         ? ThemeProvider.appColor
//                         : Colors.transparent,
//                     borderRadius: tabID == 2
//                         ? const BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           )
//                         : BorderRadius.circular(0),
//                   ),
//                   child: Center(
//                       child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30),
//                     child: Text('Packages'.tr, style: segmentText(2)),
//                   )),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   segmentText(val) {
//     return TextStyle(
//         fontSize: 12,
//         color:
//             tabID == val ? ThemeProvider.whiteColor : ThemeProvider.greyColor);
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
//         Color.fromARGB(229, 52, 1, 255),
//         Color.fromARGB(228, 111, 75, 255),
//       ],
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/imageviewer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: ThemeProvider.whiteColor,
          body: value.apiCalled == false
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: ThemeProvider.backgroundColor,
                      floating: true,
                      pinned: true,
                      toolbarHeight: 230,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        children: [
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${Environments.imageURL}${value.salonDetails.cover.toString()}'),
                                  fit: BoxFit.cover),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor:
                                                ThemeProvider.transparent,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.arrow_back,
                                                color: ThemeProvider.whiteColor,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                          ),
                                          // CircleAvatar(
                                          //   radius: 20,
                                          //   backgroundColor:
                                          //       ThemeProvider.transparent,
                                          //   child: IconButton(
                                          //     icon: const Icon(
                                          //       Icons.save_alt,
                                          //       color: ThemeProvider.whiteColor,
                                          //     ),
                                          //     onPressed: () {
                                          //       //
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        value.salonDetails.name.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: ThemeProvider.whiteColor,
                                            fontFamily: 'bold',
                                            fontSize: 17),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5, bottom: 3),
                                        child: Text(
                                          value.salonDetails.address.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: ThemeProvider.whiteColor,
                                              fontSize: 13),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                const WidgetSpan(
                                                  child: Icon(
                                                    Icons.star,
                                                    size: 15,
                                                    color: ThemeProvider
                                                        .orangeColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' (${value.salonDetails.totalRating} ${'Reviews)'.tr}',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: ThemeProvider
                                                          .whiteColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 25,
                                            width: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                color: value.status == 'Closed'
                                                    ? Colors.red
                                                    : ThemeProvider.greenColor,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                value.status,
                                                style: TextStyle(
                                                  color:
                                                      value.status == 'Closed'
                                                          ? Colors.red
                                                          : ThemeProvider
                                                              .greenColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: ThemeProvider.appColor,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      //
                                      value.openWebsite();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.language,
                                          size: 40,
                                          color: ThemeProvider.greyColor,
                                        ),
                                        Text(
                                          'Website'.tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //
                                      value.callSalon();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.call,
                                          size: 40,
                                          color: ThemeProvider.greyColor,
                                        ),
                                        Text(
                                          'Call'.tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //
                                      value.onChat();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.chat_outlined,
                                          size: 40,
                                          color: ThemeProvider.greyColor,
                                        ),
                                        Text(
                                          'Chat'.tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      //
                                      value.openMap();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.directions,
                                          size: 40,
                                          color: ThemeProvider.greyColor,
                                        ),
                                        Text(
                                          'Direction'.tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ///
                                      value.share();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.offline_share,
                                          size: 40,
                                          color: ThemeProvider.greyColor,
                                        ),
                                        Text(
                                          'Share'.tr,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 10),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         'Salon Specialist'.tr,
                          //         style: const TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: 'bold',
                          //             color: ThemeProvider.blackColor),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                          //   child: SingleChildScrollView(
                          //     scrollDirection: Axis.horizontal,
                          //     child: Row(
                          //       children: [
                          //         for (var item in value.specialistList)
                          //           Padding(
                          //             padding: const EdgeInsets.all(10.0),
                          //             child: Column(
                          //               children: [
                          //                 Container(
                          //                   decoration: BoxDecoration(
                          //                     borderRadius:
                          //                         BorderRadius.circular(100.0),
                          //                     border: Border.all(
                          //                       width: 2,
                          //                       color: ThemeProvider.appColor,
                          //                     ),
                          //                   ),
                          //                   child: Padding(
                          //                     padding:
                          //                         const EdgeInsets.all(3.0),
                          //                     child: ClipRRect(
                          //                       borderRadius:
                          //                           BorderRadius.circular(100),
                          //                       child: SizedBox.fromSize(
                          //                         size:
                          //                             const Size.fromRadius(25),
                          //                         child: FadeInImage(
                          //                           image: NetworkImage(
                          //                               '${Environments.imageURL}${item.cover}'),
                          //                           placeholder: const AssetImage(
                          //                               "assets/images/placeholder.jpeg"),
                          //                           imageErrorBuilder: (context,
                          //                               error, stackTrace) {
                          //                             return Image.asset(
                          //                                 'assets/images/notfound.png',
                          //                                 fit: BoxFit.cover);
                          //                           },
                          //                           fit: BoxFit.cover,
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 ),
                          //                 Padding(
                          //                   padding: const EdgeInsets.only(
                          //                       top: 10, bottom: 3),
                          //                   child: Text(
                          //                     '${item.firstName} ${item.lastName}',
                          //                     style: const TextStyle(
                          //                         fontSize: 12,
                          //                         color:
                          //                             ThemeProvider.blackColor),
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(56),
                        child: AppBar(
                          titleSpacing: 0,
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          backgroundColor: ThemeProvider.backgroundColor,
                          title: DefaultTabController(
                            length: 4,
                            child: Column(
                              children: [
                                TabBar(
                                  controller: value.tabController,
                                  labelColor: ThemeProvider.blackColor,
                                  isScrollable: false,
                                  labelStyle:
                                      const TextStyle(fontFamily: 'regular'),
                                  unselectedLabelColor: ThemeProvider.greyColor,
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  indicator: const UnderlineTabIndicator(
                                    borderSide: BorderSide(
                                        width: 2.0,
                                        color: ThemeProvider.appColor),
                                  ),
                                  tabs: [
                                    Tab(
                                      text: 'Services'.tr,
                                    ),
                                    Tab(
                                      text: 'About'.tr,
                                    ),
                                    Tab(
                                      text: 'Gallary'.tr,
                                    ),
                                    Tab(
                                      text: 'Review'.tr,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: TabBarView(
                              controller: value.tabController,
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        _buildSegment(),
                                        if (tabID == 1)
                                          //  for (var item in value.servicesList)
                                          Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    ListView.builder(
                                                      padding: EdgeInsets.zero,
                                                      itemCount: value
                                                          .servicesList.length,
                                                      physics:
                                                          const BouncingScrollPhysics(), // Smooth scrolling
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, i) {
                                                        final service = value
                                                            .servicesList[i];

                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      0),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: ThemeProvider
                                                                .whiteColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: ThemeProvider
                                                                    .greyColor
                                                                    .withOpacity(
                                                                        0.3),
                                                                blurRadius: 8,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(12.0),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                // Image Stack
                                                                Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            100,
                                                                        height:
                                                                            150,
                                                                        child:
                                                                            FadeInImage(
                                                                          image:
                                                                              NetworkImage('${Environments.imageURL}${service.cover}'),
                                                                          placeholder:
                                                                              const AssetImage("assets/images/placeholder.jpeg"),
                                                                          imageErrorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset(
                                                                              'assets/images/notfound.png',
                                                                              fit: BoxFit.cover,
                                                                            );
                                                                          },
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                      top: 0,
                                                                      left: 0,
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                6,
                                                                            vertical:
                                                                                2),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: ThemeProvider
                                                                              .blackColor
                                                                              .withOpacity(0.7),
                                                                          borderRadius:
                                                                              const BorderRadius.only(
                                                                            topLeft:
                                                                                Radius.circular(8),
                                                                            bottomRight:
                                                                                Radius.circular(8),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          '${service.discount}%',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                ThemeProvider.whiteColor,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                    width: 12),
                                                                // Details Column
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              service.name.toString(),
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'bold',
                                                                                fontSize: 16,
                                                                                color: ThemeProvider.blackColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Checkbox(
                                                                            value:
                                                                                service.isChecked,
                                                                            onChanged:
                                                                                (status) {
                                                                              value.updateServiceStatusInCart(i, status as bool);
                                                                            },
                                                                            checkColor:
                                                                                ThemeProvider.whiteColor,
                                                                            activeColor:
                                                                                ThemeProvider.appColor,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              4),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          style:
                                                                              const TextStyle(fontSize: 14),
                                                                          children: [
                                                                            TextSpan(
                                                                              text: value.currencySide == 'left' ? '${value.currencySymbol} ${service.price}' : '${service.price}${value.currencySymbol}',
                                                                              style: const TextStyle(
                                                                                color: ThemeProvider.greyColor,
                                                                                decoration: TextDecoration.lineThrough,
                                                                              ),
                                                                            ),
                                                                            const WidgetSpan(child: SizedBox(width: 4)),
                                                                            TextSpan(
                                                                              text: value.currencySide == 'left' ? '${value.currencySymbol} ${service.off}' : '${service.off}${value.currencySymbol}',
                                                                              style: const TextStyle(
                                                                                color: ThemeProvider.greenColor,
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              6),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.timer,
                                                                              size: 16,
                                                                              color: ThemeProvider.greyColor),
                                                                          const SizedBox(
                                                                              width: 4),
                                                                          Text(
                                                                            '${service.duration} min',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              color: ThemeProvider.greyColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 12),
                                                                          const Icon(
                                                                              Icons.person,
                                                                              size: 16,
                                                                              color: ThemeProvider.greyColor),
                                                                          const SizedBox(
                                                                              width: 4),
                                                                          Text(
                                                                            _getGenderText(service.gender),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              color: ThemeProvider.greyColor,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              8),
                                                                      Align(
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            _showServiceDetailsDialog(
                                                                                context,
                                                                                service,
                                                                                value);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            foregroundColor:
                                                                                ThemeProvider.whiteColor,
                                                                            backgroundColor:
                                                                                ThemeProvider.appColor,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                            elevation:
                                                                                0,
                                                                          ),
                                                                          child:
                                                                              const Text(
                                                                            'Details',
                                                                            style:
                                                                                TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        else if (tabID == 2)
                                          for (var item in value.packagesList)
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  vertical: 8,
                                                  horizontal:
                                                      16), // Adjusted for balance
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // Softer corners
                                                  color: ThemeProvider
                                                      .whiteColor, // Card background
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ThemeProvider
                                                          .greyColor
                                                          .withOpacity(
                                                              0.2), // Subtle shadow
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Image Section
                                                    ClipRRect(
                                                      borderRadius: const BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              12)), // Rounded top
                                                      child: SizedBox(
                                                        height: 150,
                                                        width: double.infinity,
                                                        child: FadeInImage(
                                                          image: NetworkImage(
                                                              '${Environments.imageURL}${item.cover}'),
                                                          placeholder:
                                                              const AssetImage(
                                                                  "assets/images/placeholder.jpeg"),
                                                          imageErrorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return Image.asset(
                                                              'assets/images/notfound.png',
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    // Content Section
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .all(
                                                          12.0), // Consistent inner padding
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Name and View Button Row
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  item.name
                                                                      .toString(),
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        'bold',
                                                                    fontSize:
                                                                        16, // Slightly larger for emphasis
                                                                    color: ThemeProvider
                                                                        .blackColor,
                                                                  ),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  value.onPackagesDetails(
                                                                      item.id
                                                                          as int,
                                                                      item.name
                                                                          .toString());
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          6),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ThemeProvider
                                                                        .appColor
                                                                        .withOpacity(
                                                                            0.1), // Subtle background
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Text(
                                                                    'View'.tr,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'bold',
                                                                      fontSize:
                                                                          12,
                                                                      color: ThemeProvider
                                                                          .appColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height:
                                                                  8), // Spacing between elements
                                                          // Price Row
                                                          Row(
                                                            children: [
                                                              Text(
                                                                Get.find<ServicesController>()
                                                                            .currencySide ==
                                                                        'left'
                                                                    ? '${Get.find<ServicesController>().currencySymbol} ${item.price}'
                                                                    : '${item.price}${Get.find<ServicesController>().currencySymbol}',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: ThemeProvider
                                                                      .greyColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        const SizedBox(
                                          height: 380,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        16.0), // Consistent padding
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // About Section
                                        _buildSectionTitle('About'.tr),
                                        const SizedBox(height: 8),
                                        Text(
                                          value.salonDetails.about.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: ThemeProvider.blackColor,
                                            height:
                                                1.5, // Improved readability with line spacing
                                          ),
                                        ),

                                        // Opening Hours Section
                                        _buildSectionTitle('Opening Hour'.tr),
                                        const SizedBox(height: 8),
                                        Column(
                                          children: List.generate(
                                            value.salonDetails.timing!.length,
                                            (index) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: ThemeProvider
                                                        .greenColor,
                                                    size: 10,
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          value.dayList[value
                                                              .salonDetails
                                                              .timing![index]
                                                              .day as int],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: ThemeProvider
                                                                .greyColor,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${value.salonDetails.timing![index].openTime} - ${value.salonDetails.timing![index].closeTime}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: ThemeProvider
                                                                .blackColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Address Section
                                        _buildSectionTitle('Address'.tr),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    value.salonDetails.address
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .greyColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Add navigation logic here if needed
                                                    },
                                                    child: Row(
                                                      children: [
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          '${'Get Direction'.tr} - ${value.getDistance} KM',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            color: ThemeProvider
                                                                .orangeColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: GoogleMap(
                                                  onMapCreated:
                                                      value.onMapCreated(),
                                                  markers: value.markers,
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: LatLng(
                                                      value.salonDetails.lat
                                                          as double,
                                                      value.salonDetails.lng
                                                          as double,
                                                    ),
                                                    zoom:
                                                        12, // Adjusted zoom for better visibility
                                                  ),
                                                  myLocationButtonEnabled:
                                                      false,
                                                  zoomControlsEnabled: false,
                                                  liteModeEnabled:
                                                      true, // Lightweight map mode
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Photos Section (Uncomment and enhance if needed)
                                        /*
        _buildSectionTitle('Photos'.tr),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: value.gallery.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 120,
                    child: FadeInImage(
                      image: NetworkImage('${Environments.imageURL}${value.gallery[index].toString()}'),
                      placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/notfound.png',
                          fit: BoxFit.cover,
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Add view all logic here
            },
            child: Text(
              'View All'.tr,
              style: const TextStyle(
                fontSize: 12,
                color: ThemeProvider.appColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        */
                                      ],
                                    ),
                                  ),
                                ),
                                value.isPremium
                                    ? SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: value.gallery.isNotEmpty
                                              ? Column(
                                                  children: [
                                                    GridView.count(
                                                      primary: false,
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 10,
                                                      crossAxisSpacing: 10,
                                                      shrinkWrap: true,
                                                      childAspectRatio:
                                                          100 / 100,
                                                      padding: EdgeInsets.zero,
                                                      children: List.generate(
                                                        value.gallery.length,
                                                        (index) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ImageGalleryScreen(
                                                                    gallery: value
                                                                        .gallery,
                                                                    initialIndex:
                                                                        index,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                child: SizedBox
                                                                    .fromSize(
                                                                  size: const Size
                                                                      .fromRadius(
                                                                      35),
                                                                  child:
                                                                      FadeInImage(
                                                                    image: NetworkImage(
                                                                        '${Environments.imageURL}${value.gallery[index].toString()}'),
                                                                    placeholder:
                                                                        const AssetImage(
                                                                            "assets/images/placeholder.jpeg"),
                                                                    imageErrorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return Image.asset(
                                                                          'assets/images/notfound.png',
                                                                          fit: BoxFit
                                                                              .cover);
                                                                    },
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    SizedBox(
                                                      height: 80,
                                                      width: 80,
                                                      child: Image.asset(
                                                        "assets/images/no-data.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                        'No Found'.tr,
                                                        style: const TextStyle(
                                                            fontFamily: 'bold'),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            height: 80,
                                            width: 80,
                                            child: Image.asset(
                                              "assets/images/no-data.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          Center(
                                            child: Text(
                                              'Feature Not Available For This Business'
                                                  .tr,
                                              style: const TextStyle(
                                                  fontFamily: 'bold'),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 550,
                                          ),
                                        ],
                                      ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10, left: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${'All Reviews '.tr}(${value.ownerReviewsList.length})',
                                                style: const TextStyle(
                                                    color: ThemeProvider
                                                        .greyColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                        value.ownerReviewsList.isNotEmpty
                                            ? Column(
                                                children: List.generate(
                                                value.ownerReviewsList.length,
                                                (index) => Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: ThemeProvider
                                                                .backgroundColor),
                                                        top: BorderSide(
                                                            color: ThemeProvider
                                                                .backgroundColor)),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: SizedBox
                                                                  .fromSize(
                                                                size: const Size
                                                                    .fromRadius(
                                                                    30),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.imageURL}${value.ownerReviewsList[index].user!.cover.toString()}'),
                                                                  placeholder:
                                                                      const AssetImage(
                                                                          "assets/images/placeholder.jpeg"),
                                                                  imageErrorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return Image
                                                                        .asset(
                                                                      'assets/images/notfound.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                    );
                                                                  },
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              120,
                                                                          child:
                                                                              Text(
                                                                            '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontSize: 15),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.star,
                                                                              color: ThemeProvider.orangeColor,
                                                                              size: 15,
                                                                            ),
                                                                            SizedBox(
                                                                              child: Text(
                                                                                value.ownerReviewsList[index].rating.toString(),
                                                                                overflow: TextOverflow.ellipsis,
                                                                                style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color: value.ownerReviewsList[index].rating! >= 1
                                                                                ? ThemeProvider.orangeColor
                                                                                : ThemeProvider.greyColor,
                                                                            size: 15),
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color: value.ownerReviewsList[index].rating! >= 2
                                                                                ? ThemeProvider.orangeColor
                                                                                : ThemeProvider.greyColor,
                                                                            size: 15),
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color: value.ownerReviewsList[index].rating! >= 3
                                                                                ? ThemeProvider.orangeColor
                                                                                : ThemeProvider.greyColor,
                                                                            size: 15),
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color: value.ownerReviewsList[index].rating! >= 4
                                                                                ? ThemeProvider.orangeColor
                                                                                : ThemeProvider.greyColor,
                                                                            size: 15),
                                                                        Icon(
                                                                            Icons
                                                                                .star,
                                                                            color: value.ownerReviewsList[index].rating! >= 5
                                                                                ? ThemeProvider.orangeColor
                                                                                : ThemeProvider.greyColor,
                                                                            size: 15),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 10,
                                                                vertical: 5),
                                                        child: Text(
                                                          value
                                                              .ownerReviewsList[
                                                                  index]
                                                              .notes!,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 20),
                                                  SizedBox(
                                                    height: 80,
                                                    width: 80,
                                                    child: Image.asset(
                                                      "assets/images/no-data.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'No Found'.tr,
                                                      style: const TextStyle(
                                                          fontFamily: 'bold'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          bottomNavigationBar:
              Get.find<ServiceCartController>().totalItemsInCart > 0 &&
                      Get.find<ServiceCartController>().servicesFrom == 'salon'
                  ? SizedBox(
                      height: 70,
                      child: InkWell(
                        onTap: () {
                          value.onCheckout();
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: ThemeProvider.pink,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.currencySide == 'left'
                                    ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
                                    : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                              Text(
                                'Book Services'.tr,
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
        );
      },
    );
  }

  String _getGenderText(int? gender) {
    switch (gender) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      case 2:
        return 'Kid';
      case 3:
        return 'Family';
      default:
        return 'Unknown'; // Fallback if gender is null or out of range
    }
  }

  Widget _buildSegment() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeProvider.appColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    tabID = 1;
                  });
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: tabID == 1
                        ? ThemeProvider.appColor
                        : Colors.transparent,
                    borderRadius: tabID == 1
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          )
                        : BorderRadius.circular(0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Services'.tr, style: segmentText(1)),
                  )),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    tabID = 2;
                  });
                },
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: tabID == 2
                        ? ThemeProvider.appColor
                        : Colors.transparent,
                    borderRadius: tabID == 2
                        ? const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )
                        : BorderRadius.circular(0),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Packages'.tr, style: segmentText(2)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  segmentText(val) {
    return TextStyle(
        fontSize: 12,
        color:
            tabID == val ? ThemeProvider.whiteColor : ThemeProvider.greyColor);
  }
}

// Helper function (assuming it exists elsewhere or define it here)
String _getGenderText(int? genderCode) {
  switch (genderCode) {
    case 0:
      return 'Unisex'; // Example
    case 1:
      return 'Male'; // Example
    case 2:
      return 'Female'; // Example
    default:
      return 'N/A';
  }
}

void _showServiceDetailsDialog(BuildContext context, ServicesModel service,
    ServicesController servicesController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          service.name ?? 'Service Details',
          style: const TextStyle(
            fontFamily: 'bold',
            fontSize: 20,
            color: ThemeProvider.appColor,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (service.descriptions != null &&
                  service.descriptions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Description: ${service.descriptions}',
                    style: const TextStyle(
                        fontSize: 14, color: ThemeProvider.greyColor),
                  ),
                ),
              _buildDetailRow(
                'Price',
                servicesController.currencySide == 'left'
                    ? '${servicesController.currencySymbol} ${service.price}'
                    : '${service.price}${servicesController.currencySymbol}',
              ),
              _buildDetailRow(
                'Offer Price',
                servicesController.currencySide == 'left'
                    ? '${servicesController.currencySymbol} ${service.off}'
                    : '${service.off}${servicesController.currencySymbol}',
                color: ThemeProvider.greenColor,
                fontWeight: FontWeight.bold,
              ),
              _buildDetailRow('Discount', '${service.discount}%'),
              _buildDetailRow('Duration', '${service.duration} min'),
              _buildDetailRow('Gender', _getGenderText(service.gender)),
              if (service.extraField != null && service.extraField!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Extra Info: ${service.extraField}',
                    style: const TextStyle(
                        fontSize: 14, color: ThemeProvider.greyColor),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: ThemeProvider.appColor,
              textStyle: const TextStyle(fontFamily: 'bold'),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

// Helper method for section titles
Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'bold',
        color: ThemeProvider.blackColor,
      ),
    ),
  );
}

// Helper method to create consistent detail rows
Widget _buildDetailRow(String label, String value,
    {Color? color, FontWeight? fontWeight}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ThemeProvider.greyColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color ?? ThemeProvider.blackColor,
            fontWeight: fontWeight ?? FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

contentButtonStyle() {
  return const BoxDecoration(
    borderRadius: BorderRadius.all(
      Radius.circular(100.0),
    ),
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(229, 52, 1, 255),
        Color.fromARGB(228, 111, 75, 255),
      ],
    ),
  );
}
