// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:salon_user/app/controller/service_cart_controller.dart';
// // import 'package:salon_user/app/controller/services_controller.dart';
// // import 'package:salon_user/app/env.dart';
// // import 'package:salon_user/app/util/theme.dart';

// // class ServicesScreen extends StatefulWidget {
// //   const ServicesScreen({Key? key}) : super(key: key);

// //   @override
// //   State<ServicesScreen> createState() => _ServicesScreenState();
// // }

// // class _ServicesScreenState extends State<ServicesScreen> {
// //   int tabID = 1;

// //   @override
// //   Widget build(BuildContext context) {
// //     return GetBuilder<ServicesController>(
// //       builder: (value) {
// //         return Scaffold(
// //           extendBodyBehindAppBar: true,
// //           backgroundColor: ThemeProvider.whiteColor,
// //           body: value.apiCalled == false
// //               ? const Center(
// //                   child:
// //                       CircularProgressIndicator(color: ThemeProvider.appColor),
// //                 )
// //               : CustomScrollView(
// //                   slivers: [
// //                     SliverAppBar(
// //                       backgroundColor: ThemeProvider.backgroundColor,
// //                       floating: true,
// //                       pinned: true,
// //                       toolbarHeight: 230,
// //                       snap: false,
// //                       elevation: 0,
// //                       forceElevated: true,
// //                       iconTheme:
// //                           const IconThemeData(color: ThemeProvider.appColor),
// //                       automaticallyImplyLeading: false,
// //                       titleSpacing: 0,
// //                       title: Column(
// //                         children: [
// //                           Container(
// //                             height: 160,
// //                             decoration: BoxDecoration(
// //                               image: DecorationImage(
// //                                   image: NetworkImage(
// //                                       '${Environments.imageURL}${value.salonDetails.cover.toString()}'),
// //                                   fit: BoxFit.cover),
// //                             ),
// //                             child: Stack(
// //                               children: [
// //                                 Align(
// //                                   alignment: Alignment.bottomCenter,
// //                                   child: Container(
// //                                     height: 100,
// //                                     width: MediaQuery.of(context).size.width,
// //                                     decoration: const BoxDecoration(
// //                                       gradient: LinearGradient(
// //                                         begin: Alignment.topCenter,
// //                                         end: Alignment.bottomCenter,
// //                                         colors: [
// //                                           Colors.transparent,
// //                                           Colors.black,
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 Align(
// //                                   alignment: Alignment.topCenter,
// //                                   child: Container(
// //                                     height: 50,
// //                                     width: MediaQuery.of(context).size.width,
// //                                     decoration: const BoxDecoration(
// //                                       gradient: LinearGradient(
// //                                         begin: Alignment.topCenter,
// //                                         end: Alignment.bottomCenter,
// //                                         colors: [
// //                                           Colors.black,
// //                                           Colors.transparent,
// //                                         ],
// //                                       ),
// //                                     ),
// //                                     child: Padding(
// //                                       padding: const EdgeInsets.symmetric(
// //                                           horizontal: 10, vertical: 10),
// //                                       child: Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           CircleAvatar(
// //                                             radius: 20,
// //                                             backgroundColor:
// //                                                 ThemeProvider.transparent,
// //                                             child: IconButton(
// //                                               icon: const Icon(
// //                                                 Icons.arrow_back,
// //                                                 color: ThemeProvider.whiteColor,
// //                                               ),
// //                                               onPressed: () {
// //                                                 Get.back();
// //                                               },
// //                                             ),
// //                                           ),
// //                                           // CircleAvatar(
// //                                           //   radius: 20,
// //                                           //   backgroundColor:
// //                                           //       ThemeProvider.transparent,
// //                                           //   child: IconButton(
// //                                           //     icon: const Icon(
// //                                           //       Icons.save_alt,
// //                                           //       color: ThemeProvider.whiteColor,
// //                                           //     ),
// //                                           //     onPressed: () {
// //                                           //       //
// //                                           //     },
// //                                           //   ),
// //                                           // ),
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 Padding(
// //                                   padding: const EdgeInsets.symmetric(
// //                                       horizontal: 10, vertical: 20),
// //                                   child: Column(
// //                                     crossAxisAlignment:
// //                                         CrossAxisAlignment.start,
// //                                     mainAxisAlignment: MainAxisAlignment.end,
// //                                     children: [
// //                                       Text(
// //                                         value.salonDetails.name.toString(),
// //                                         overflow: TextOverflow.ellipsis,
// //                                         style: const TextStyle(
// //                                             color: ThemeProvider.whiteColor,
// //                                             fontFamily: 'bold',
// //                                             fontSize: 17),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.only(
// //                                             top: 5, bottom: 3),
// //                                         child: Text(
// //                                           value.salonDetails.address.toString(),
// //                                           overflow: TextOverflow.ellipsis,
// //                                           style: const TextStyle(
// //                                               color: ThemeProvider.whiteColor,
// //                                               fontSize: 13),
// //                                         ),
// //                                       ),
// //                                       Row(
// //                                         mainAxisAlignment:
// //                                             MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           RichText(
// //                                             text: TextSpan(
// //                                               children: [
// //                                                 const WidgetSpan(
// //                                                   child: Icon(
// //                                                     Icons.star,
// //                                                     size: 15,
// //                                                     color: ThemeProvider
// //                                                         .orangeColor,
// //                                                   ),
// //                                                 ),
// //                                                 TextSpan(
// //                                                   text:
// //                                                       ' (${value.salonDetails.totalRating} ${'Reviews)'.tr}',
// //                                                   style: const TextStyle(
// //                                                       fontSize: 12,
// //                                                       color: ThemeProvider
// //                                                           .whiteColor),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           Container(
// //                                             height: 25,
// //                                             width: 60,
// //                                             decoration: BoxDecoration(
// //                                               borderRadius:
// //                                                   BorderRadius.circular(5),
// //                                               border: Border.all(
// //                                                   color:
// //                                                       ThemeProvider.greenColor),
// //                                             ),
// //                                             child: Center(
// //                                               child: Text(
// //                                                 'OPEN'.tr,
// //                                                 style: const TextStyle(
// //                                                     color: ThemeProvider
// //                                                         .greenColor,
// //                                                     fontSize: 10),
// //                                               ),
// //                                             ),
// //                                           ),
// //                                         ],
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 )
// //                               ],
// //                             ),
// //                           ),
// //                           Container(
// //                             color: ThemeProvider.appColor,
// //                             child: Padding(
// //                               padding: const EdgeInsets.symmetric(
// //                                   horizontal: 10, vertical: 10),
// //                               child: Row(
// //                                 mainAxisAlignment:
// //                                     MainAxisAlignment.spaceAround,
// //                                 children: [
// //                                   InkWell(
// //                                     onTap: () {
// //                                       //
// //                                       value.openWebsite();
// //                                     },
// //                                     child: Column(
// //                                       children: [
// //                                         const Icon(
// //                                           Icons.language,
// //                                           size: 40,
// //                                           color: ThemeProvider.greyColor,
// //                                         ),
// //                                         Text(
// //                                           'Website'.tr,
// //                                           style: const TextStyle(
// //                                               fontSize: 12,
// //                                               color: ThemeProvider.greyColor),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   InkWell(
// //                                     onTap: () {
// //                                       //
// //                                       value.callSalon();
// //                                     },
// //                                     child: Column(
// //                                       children: [
// //                                         const Icon(
// //                                           Icons.call,
// //                                           size: 40,
// //                                           color: ThemeProvider.greyColor,
// //                                         ),
// //                                         Text(
// //                                           'Call'.tr,
// //                                           style: const TextStyle(
// //                                               fontSize: 12,
// //                                               color: ThemeProvider.greyColor),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   InkWell(
// //                                     onTap: () {
// //                                       //
// //                                       value.onChat();
// //                                     },
// //                                     child: Column(
// //                                       children: [
// //                                         const Icon(
// //                                           Icons.chat_outlined,
// //                                           size: 40,
// //                                           color: ThemeProvider.greyColor,
// //                                         ),
// //                                         Text(
// //                                           'Chat'.tr,
// //                                           style: const TextStyle(
// //                                               fontSize: 12,
// //                                               color: ThemeProvider.greyColor),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   InkWell(
// //                                     onTap: () {
// //                                       //
// //                                       value.openMap();
// //                                     },
// //                                     child: Column(
// //                                       children: [
// //                                         const Icon(
// //                                           Icons.directions,
// //                                           size: 40,
// //                                           color: ThemeProvider.greyColor,
// //                                         ),
// //                                         Text(
// //                                           'Direction'.tr,
// //                                           style: const TextStyle(
// //                                               fontSize: 12,
// //                                               color: ThemeProvider.greyColor),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                   InkWell(
// //                                     onTap: () {
// //                                       ///
// //                                       value.share();
// //                                     },
// //                                     child: Column(
// //                                       children: [
// //                                         const Icon(
// //                                           Icons.offline_share,
// //                                           size: 40,
// //                                           color: ThemeProvider.greyColor,
// //                                         ),
// //                                         Text(
// //                                           'Share'.tr,
// //                                           style: const TextStyle(
// //                                               fontSize: 12,
// //                                               color: ThemeProvider.greyColor),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ],
// //                               ),
// //                             ),
// //                           ),
// //                           // Padding(
// //                           //   padding: const EdgeInsets.symmetric(
// //                           //       vertical: 5, horizontal: 10),
// //                           //   child: Row(
// //                           //     children: [
// //                           //       Text(
// //                           //         'Salon Specialist'.tr,
// //                           //         style: const TextStyle(
// //                           //             fontSize: 14,
// //                           //             fontFamily: 'bold',
// //                           //             color: ThemeProvider.blackColor),
// //                           //       ),
// //                           //     ],
// //                           //   ),
// //                           // ),
// //                           // Padding(
// //                           //   padding: const EdgeInsets.symmetric(horizontal: 10),
// //                           //   child: SingleChildScrollView(
// //                           //     scrollDirection: Axis.horizontal,
// //                           //     child: Row(
// //                           //       children: [
// //                           //         for (var item in value.specialistList)
// //                           //           Padding(
// //                           //             padding: const EdgeInsets.all(10.0),
// //                           //             child: Column(
// //                           //               children: [
// //                           //                 Container(
// //                           //                   decoration: BoxDecoration(
// //                           //                     borderRadius:
// //                           //                         BorderRadius.circular(100.0),
// //                           //                     border: Border.all(
// //                           //                       width: 2,
// //                           //                       color: ThemeProvider.appColor,
// //                           //                     ),
// //                           //                   ),
// //                           //                   child: Padding(
// //                           //                     padding:
// //                           //                         const EdgeInsets.all(3.0),
// //                           //                     child: ClipRRect(
// //                           //                       borderRadius:
// //                           //                           BorderRadius.circular(100),
// //                           //                       child: SizedBox.fromSize(
// //                           //                         size:
// //                           //                             const Size.fromRadius(25),
// //                           //                         child: FadeInImage(
// //                           //                           image: NetworkImage(
// //                           //                               '${Environments.imageURL}${item.cover}'),
// //                           //                           placeholder: const AssetImage(
// //                           //                               "assets/images/placeholder.jpeg"),
// //                           //                           imageErrorBuilder: (context,
// //                           //                               error, stackTrace) {
// //                           //                             return Image.asset(
// //                           //                                 'assets/images/notfound.png',
// //                           //                                 fit: BoxFit.cover);
// //                           //                           },
// //                           //                           fit: BoxFit.cover,
// //                           //                         ),
// //                           //                       ),
// //                           //                     ),
// //                           //                   ),
// //                           //                 ),
// //                           //                 Padding(
// //                           //                   padding: const EdgeInsets.only(
// //                           //                       top: 10, bottom: 3),
// //                           //                   child: Text(
// //                           //                     '${item.firstName} ${item.lastName}',
// //                           //                     style: const TextStyle(
// //                           //                         fontSize: 12,
// //                           //                         color:
// //                           //                             ThemeProvider.blackColor),
// //                           //                   ),
// //                           //                 ),
// //                           //               ],
// //                           //             ),
// //                           //           )
// //                           //       ],
// //                           //     ),
// //                           //   ),
// //                           // ),
// //                         ],
// //                       ),
// //                       bottom: PreferredSize(
// //                         preferredSize: const Size.fromHeight(56),
// //                         child: AppBar(
// //                           titleSpacing: 0,
// //                           automaticallyImplyLeading: false,
// //                           elevation: 0,
// //                           backgroundColor: ThemeProvider.backgroundColor,
// //                           title: DefaultTabController(
// //                             length: 4,
// //                             child: Column(
// //                               children: [
// //                                 TabBar(
// //                                   controller: value.tabController,
// //                                   labelColor: ThemeProvider.blackColor,
// //                                   isScrollable: false,
// //                                   labelStyle:
// //                                       const TextStyle(fontFamily: 'regular'),
// //                                   unselectedLabelColor: ThemeProvider.greyColor,
// //                                   labelPadding: const EdgeInsets.symmetric(
// //                                       horizontal: 10.0),
// //                                   indicator: const UnderlineTabIndicator(
// //                                     borderSide: BorderSide(
// //                                         width: 2.0,
// //                                         color: ThemeProvider.appColor),
// //                                   ),
// //                                   tabs: [
// //                                     Tab(
// //                                       text: 'Services'.tr,
// //                                     ),
// //                                     Tab(
// //                                       text: 'About'.tr,
// //                                     ),
// //                                     Tab(
// //                                       text: 'Gallary'.tr,
// //                                     ),
// //                                     Tab(
// //                                       text: 'Review'.tr,
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     SliverList(
// //                       delegate: SliverChildListDelegate(
// //                         [
// //                           SizedBox(
// //                             height: MediaQuery.of(context).size.height,
// //                             child: TabBarView(
// //                               controller: value.tabController,
// //                               children: [
// //                                 SingleChildScrollView(
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         horizontal: 10, vertical: 10),
// //                                     child: Column(
// //                                       children: [
// //                                         _buildSegment(),
// //                                         if (tabID == 1)
// //                                           //  for (var item in value.servicesList)
// //                                           Column(
// //                                             children: [
// //                                               Padding(
// //                                                 padding:
// //                                                     const EdgeInsets.all(10.0),
// //                                                 child: Column(
// //                                                   children: [
// //                                                     ListView.builder(
// //                                                       padding: EdgeInsets.zero,
// //                                                       itemCount: value
// //                                                           .servicesList.length,
// //                                                       physics:
// //                                                           const ScrollPhysics(),
// //                                                       shrinkWrap: true,
// //                                                       itemBuilder:
// //                                                           (context, i) =>
// //                                                               Column(
// //                                                         children: [
// //                                                           Container(
// //                                                             padding:
// //                                                                 const EdgeInsets
// //                                                                     .all(10),
// //                                                             margin:
// //                                                                 const EdgeInsets
// //                                                                     .symmetric(
// //                                                                     vertical:
// //                                                                         10),
// //                                                             decoration:
// //                                                                 BoxDecoration(
// //                                                               borderRadius:
// //                                                                   BorderRadius
// //                                                                       .circular(
// //                                                                           5),
// //                                                               color: ThemeProvider
// //                                                                   .whiteColor,
// //                                                               boxShadow: const [
// //                                                                 BoxShadow(
// //                                                                   color: ThemeProvider
// //                                                                       .greyColor,
// //                                                                   blurRadius:
// //                                                                       5.0,
// //                                                                   offset:
// //                                                                       Offset(
// //                                                                           0.7,
// //                                                                           2.0),
// //                                                                 ),
// //                                                               ],
// //                                                             ),
// //                                                             child: Row(
// //                                                               children: [
// //                                                                 Stack(
// //                                                                   children: [
// //                                                                     ClipRRect(
// //                                                                       borderRadius:
// //                                                                           BorderRadius.circular(
// //                                                                               5),
// //                                                                       child: SizedBox
// //                                                                           .fromSize(
// //                                                                         size: const Size
// //                                                                             .fromRadius(
// //                                                                             40),
// //                                                                         child:
// //                                                                             FadeInImage(
// //                                                                           image:
// //                                                                               NetworkImage('${Environments.imageURL}${value.servicesList[i].cover}'),
// //                                                                           placeholder:
// //                                                                               const AssetImage("assets/images/placeholder.jpeg"),
// //                                                                           imageErrorBuilder: (context,
// //                                                                               error,
// //                                                                               stackTrace) {
// //                                                                             return Image.asset('assets/images/notfound.png',
// //                                                                                 fit: BoxFit.cover);
// //                                                                           },
// //                                                                           fit: BoxFit
// //                                                                               .cover,
// //                                                                         ),
// //                                                                       ),
// //                                                                     ),
// //                                                                     Positioned(
// //                                                                       top: 0,
// //                                                                       left: 0,
// //                                                                       child:
// //                                                                           Container(
// //                                                                         height:
// //                                                                             20,
// //                                                                         width:
// //                                                                             40,
// //                                                                         decoration:
// //                                                                             BoxDecoration(
// //                                                                           color: ThemeProvider
// //                                                                               .blackColor
// //                                                                               .withOpacity(0.5),
// //                                                                           borderRadius:
// //                                                                               BorderRadius.circular(5),
// //                                                                         ),
// //                                                                         child:
// //                                                                             Center(
// //                                                                           child:
// //                                                                               Text(
// //                                                                             '${value.servicesList[i].discount}  %',
// //                                                                             overflow:
// //                                                                                 TextOverflow.ellipsis,
// //                                                                             style:
// //                                                                                 const TextStyle(fontSize: 10, color: ThemeProvider.whiteColor),
// //                                                                           ),
// //                                                                         ),
// //                                                                       ),
// //                                                                     ),
// //                                                                   ],
// //                                                                 ),
// //                                                                 const SizedBox(
// //                                                                     width: 10),
// //                                                                 Expanded(
// //                                                                   child: Stack(
// //                                                                     clipBehavior:
// //                                                                         Clip.none,
// //                                                                     children: [
// //                                                                       Positioned(
// //                                                                         right:
// //                                                                             20,
// //                                                                         top: 10,
// //                                                                         child:
// //                                                                             Checkbox(
// //                                                                           checkColor:
// //                                                                               Colors.white,
// //                                                                           activeColor:
// //                                                                               ThemeProvider.appColor,
// //                                                                           value: value
// //                                                                               .servicesList[i]
// //                                                                               .isChecked,
// //                                                                           onChanged:
// //                                                                               (status) {
// //                                                                             value.updateServiceStatusInCart(i,
// //                                                                                 status as bool);
// //                                                                           },
// //                                                                         ),
// //                                                                       ),
// //                                                                       Column(
// //                                                                         crossAxisAlignment:
// //                                                                             CrossAxisAlignment.start,
// //                                                                         children: [
// //                                                                           Text(
// //                                                                             value.servicesList[i].name.toString(),
// //                                                                             overflow:
// //                                                                                 TextOverflow.ellipsis,
// //                                                                             style:
// //                                                                                 const TextStyle(fontFamily: 'bold', fontSize: 14),
// //                                                                           ),
// //                                                                           const SizedBox(
// //                                                                               height: 2),
// //                                                                           Row(
// //                                                                             children: [
// //                                                                               //  const Icon(Icons.attach_money, size: 14, color: ThemeProvider.greyColor),
// //                                                                               const SizedBox(width: 4),
// //                                                                               RichText(
// //                                                                                 text: TextSpan(
// //                                                                                   children: [
// //                                                                                     TextSpan(
// //                                                                                       text: Get.find<ServicesController>().currencySide == 'left' ? '${Get.find<ServicesController>().currencySymbol}  ${value.servicesList[i].price}' : '  ${value.servicesList[i].price}${Get.find<ServicesController>().currencySymbol}',
// //                                                                                       style: const TextStyle(fontSize: 12, color: ThemeProvider.greyColor, decoration: TextDecoration.lineThrough),
// //                                                                                     ),
// //                                                                                     TextSpan(
// //                                                                                       text: Get.find<ServicesController>().currencySide == 'left' ? '${Get.find<ServicesController>().currencySymbol}  ${value.servicesList[i].off}' : '  ${value.servicesList[i].off}${Get.find<ServicesController>().currencySymbol}',
// //                                                                                       style: const TextStyle(fontSize: 12, color: ThemeProvider.greenColor, fontFamily: 'bold'),
// //                                                                                     ),
// //                                                                                   ],
// //                                                                                 ),
// //                                                                               ),
// //                                                                             ],
// //                                                                           ),
// //                                                                           Row(
// //                                                                             children: [
// //                                                                               const Icon(Icons.timer, size: 14, color: ThemeProvider.greyColor),
// //                                                                               const SizedBox(width: 4),
// //                                                                               Text(
// //                                                                                 '${value.servicesList[i].duration} min',
// //                                                                                 overflow: TextOverflow.ellipsis,
// //                                                                                 style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
// //                                                                               ),
// //                                                                             ],
// //                                                                           ),
// //                                                                           const SizedBox(
// //                                                                               height: 2),
// //                                                                           Row(
// //                                                                             children: [
// //                                                                               const Icon(Icons.person, size: 14, color: ThemeProvider.greyColor),
// //                                                                               const SizedBox(width: 4),
// //                                                                               Text(
// //                                                                                 _getGenderText(value.servicesList[i].gender),
// //                                                                                 style: const TextStyle(fontSize: 12, color: ThemeProvider.greyColor),
// //                                                                               ),
// //                                                                             ],
// //                                                                           ),
// //                                                                         ],
// //                                                                       ),
// //                                                                     ],
// //                                                                   ),
// //                                                                 ),
// //                                                               ],
// //                                                             ),
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           )
// //                                         else if (tabID == 2)
// //                                           for (var item in value.packagesList)
// //                                             Padding(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       vertical: 5),
// //                                               child: Column(
// //                                                 children: [
// //                                                   Container(
// //                                                     height: 150,
// //                                                     width: double.infinity,
// //                                                     decoration: BoxDecoration(
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               5),
// //                                                     ),
// //                                                     child: ClipRRect(
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               5),
// //                                                       child: FadeInImage(
// //                                                         image: NetworkImage(
// //                                                             '${Environments.imageURL}${item.cover}'),
// //                                                         placeholder:
// //                                                             const AssetImage(
// //                                                                 "assets/images/placeholder.jpeg"),
// //                                                         imageErrorBuilder:
// //                                                             (context, error,
// //                                                                 stackTrace) {
// //                                                           return Image.asset(
// //                                                               'assets/images/notfound.png',
// //                                                               fit:
// //                                                                   BoxFit.cover);
// //                                                         },
// //                                                         fit: BoxFit.cover,
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                   Padding(
// //                                                     padding:
// //                                                         const EdgeInsets.only(
// //                                                             top: 10, bottom: 3),
// //                                                     child: Row(
// //                                                       mainAxisAlignment:
// //                                                           MainAxisAlignment
// //                                                               .spaceBetween,
// //                                                       children: [
// //                                                         Expanded(
// //                                                           child: Text(
// //                                                             item.name
// //                                                                 .toString(),
// //                                                             maxLines: 1,
// //                                                             overflow:
// //                                                                 TextOverflow
// //                                                                     .ellipsis,
// //                                                             style: const TextStyle(
// //                                                                 color: ThemeProvider
// //                                                                     .blackColor,
// //                                                                 fontFamily:
// //                                                                     'bold'),
// //                                                           ),
// //                                                         ),
// //                                                         InkWell(
// //                                                           onTap: () {
// //                                                             value.onPackagesDetails(
// //                                                                 item.id as int,
// //                                                                 item.name
// //                                                                     .toString());
// //                                                           },
// //                                                           child: Text(
// //                                                             'View'.tr,
// //                                                             style: const TextStyle(
// //                                                                 color:
// //                                                                     ThemeProvider
// //                                                                         .appColor,
// //                                                                 fontFamily:
// //                                                                     'bold'),
// //                                                           ),
// //                                                         ),
// //                                                       ],
// //                                                     ),
// //                                                   ),
// //                                                   Row(
// //                                                     mainAxisAlignment:
// //                                                         MainAxisAlignment.start,
// //                                                     children: [
// //                                                       Text(
// //                                                         Get.find<ServicesController>()
// //                                                                     .currencySide ==
// //                                                                 'left'
// //                                                             ? '${Get.find<ServicesController>().currencySymbol}  ${item.price}'
// //                                                             : '  ${item.price}${Get.find<ServicesController>().currencySymbol}',
// //                                                         style: const TextStyle(
// //                                                             color: ThemeProvider
// //                                                                 .greyColor,
// //                                                             fontSize: 12),
// //                                                       ),
// //                                                     ],
// //                                                   )
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SingleChildScrollView(
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         horizontal: 10, vertical: 10),
// //                                     child: Column(
// //                                       children: [
// //                                         Column(
// //                                           crossAxisAlignment:
// //                                               CrossAxisAlignment.start,
// //                                           mainAxisAlignment:
// //                                               MainAxisAlignment.start,
// //                                           children: [
// //                                             Padding(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       vertical: 10),
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     'About'.tr,
// //                                                     style: const TextStyle(
// //                                                         fontSize: 14,
// //                                                         fontFamily: 'bold',
// //                                                         color: ThemeProvider
// //                                                             .blackColor),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             Text(
// //                                               value.salonDetails.about
// //                                                   .toString(),
// //                                               style: const TextStyle(
// //                                                   color:
// //                                                       ThemeProvider.blackColor,
// //                                                   fontSize: 15),
// //                                             ),
// //                                             Padding(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       vertical: 10),
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     'Opening Hour'.tr,
// //                                                     style: const TextStyle(
// //                                                         fontSize: 14,
// //                                                         fontFamily: 'bold',
// //                                                         color: ThemeProvider
// //                                                             .blackColor),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             Column(
// //                                                 children: List.generate(
// //                                               value.salonDetails.timing!.length,
// //                                               (index) => Padding(
// //                                                 padding:
// //                                                     const EdgeInsets.symmetric(
// //                                                         vertical: 5),
// //                                                 child: Row(
// //                                                   children: [
// //                                                     const Icon(Icons.circle,
// //                                                         color: ThemeProvider
// //                                                             .greenColor,
// //                                                         size: 15),
// //                                                     const SizedBox(width: 10),
// //                                                     Expanded(
// //                                                       child: Row(
// //                                                         mainAxisAlignment:
// //                                                             MainAxisAlignment
// //                                                                 .spaceBetween,
// //                                                         children: [
// //                                                           Text(
// //                                                             value.dayList[value
// //                                                                 .salonDetails
// //                                                                 .timing![index]
// //                                                                 .day as int],
// //                                                             style: const TextStyle(
// //                                                                 color: ThemeProvider
// //                                                                     .greyColor,
// //                                                                 fontSize: 12),
// //                                                           ),
// //                                                           Text(
// //                                                             '${value.salonDetails.timing![index].openTime}   :   ${value.salonDetails.timing![index].closeTime}',
// //                                                             style: const TextStyle(
// //                                                                 color: ThemeProvider
// //                                                                     .blackColor,
// //                                                                 fontSize: 12),
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 ),
// //                                               ),
// //                                             )),
// //                                             Padding(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       vertical: 10),
// //                                               child: Row(
// //                                                 children: [
// //                                                   Text(
// //                                                     'Address'.tr,
// //                                                     style: const TextStyle(
// //                                                         fontSize: 14,
// //                                                         fontFamily: 'bold',
// //                                                         color: ThemeProvider
// //                                                             .blackColor),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             Row(
// //                                               mainAxisAlignment:
// //                                                   MainAxisAlignment
// //                                                       .spaceBetween,
// //                                               crossAxisAlignment:
// //                                                   CrossAxisAlignment.start,
// //                                               children: [
// //                                                 Expanded(
// //                                                     child: Column(
// //                                                   crossAxisAlignment:
// //                                                       CrossAxisAlignment.start,
// //                                                   children: [
// //                                                     Padding(
// //                                                       padding:
// //                                                           const EdgeInsets.only(
// //                                                               right: 10),
// //                                                       child: Text(
// //                                                         value.salonDetails
// //                                                             .address
// //                                                             .toString(),
// //                                                         maxLines: 2,
// //                                                         overflow: TextOverflow
// //                                                             .ellipsis,
// //                                                         style: const TextStyle(
// //                                                             fontSize: 12,
// //                                                             color: ThemeProvider
// //                                                                 .greyColor),
// //                                                       ),
// //                                                     ),
// //                                                     const SizedBox(height: 10),
// //                                                     RichText(
// //                                                       text: TextSpan(
// //                                                         children: [
// //                                                           const WidgetSpan(
// //                                                             child: Icon(
// //                                                               Icons
// //                                                                   .near_me_outlined,
// //                                                               size: 15,
// //                                                               color: ThemeProvider
// //                                                                   .orangeColor,
// //                                                             ),
// //                                                           ),
// //                                                           TextSpan(
// //                                                             text:
// //                                                                 '${' Get Direction - '.tr}${value.getDistance}KM',
// //                                                             style: const TextStyle(
// //                                                                 fontSize: 12,
// //                                                                 color: ThemeProvider
// //                                                                     .orangeColor),
// //                                                           ),
// //                                                         ],
// //                                                       ),
// //                                                     ),
// //                                                   ],
// //                                                 )),
// //                                                 ClipRRect(
// //                                                   borderRadius:
// //                                                       BorderRadius.circular(5),
// //                                                   child: SizedBox.fromSize(
// //                                                     size: const Size.fromRadius(
// //                                                         35),
// //                                                     child: GoogleMap(
// //                                                         onMapCreated: value
// //                                                             .onMapCreated(),
// //                                                         markers: value.markers,
// //                                                         initialCameraPosition:
// //                                                             CameraPosition(
// //                                                                 target: LatLng(
// //                                                                     value.salonDetails
// //                                                                             .lat
// //                                                                         as double,
// //                                                                     value.salonDetails
// //                                                                             .lng
// //                                                                         as double),
// //                                                                 zoom: 5),
// //                                                         myLocationButtonEnabled:
// //                                                             false,
// //                                                         zoomControlsEnabled:
// //                                                             false),
// //                                                   ),
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                             Padding(
// //                                               padding:
// //                                                   const EdgeInsets.symmetric(
// //                                                       vertical: 10),
// //                                               child: Row(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment
// //                                                         .spaceBetween,
// //                                                 children: [
// //                                                   Text(
// //                                                     'Photos'.tr,
// //                                                     style: const TextStyle(
// //                                                         fontSize: 14,
// //                                                         fontFamily: 'bold',
// //                                                         color: ThemeProvider
// //                                                             .blackColor),
// //                                                   ),
// //                                                   Text(
// //                                                     'View All'.tr,
// //                                                     style: const TextStyle(
// //                                                         fontSize: 12,
// //                                                         color: ThemeProvider
// //                                                             .greyColor),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                             SingleChildScrollView(
// //                                               scrollDirection: Axis.horizontal,
// //                                               child: Row(
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.start,
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.start,
// //                                                 children: List.generate(
// //                                                   value.gallery.length,
// //                                                   (index) => Padding(
// //                                                     padding:
// //                                                         const EdgeInsets.all(
// //                                                             10.0),
// //                                                     child: ClipRRect(
// //                                                       borderRadius:
// //                                                           BorderRadius.circular(
// //                                                               5),
// //                                                       child: SizedBox.fromSize(
// //                                                         size: const Size
// //                                                             .fromRadius(35),
// //                                                         child: FadeInImage(
// //                                                           image: NetworkImage(
// //                                                               '${Environments.imageURL}${value.gallery[index].toString()}'),
// //                                                           placeholder:
// //                                                               const AssetImage(
// //                                                                   "assets/images/placeholder.jpeg"),
// //                                                           imageErrorBuilder:
// //                                                               (context, error,
// //                                                                   stackTrace) {
// //                                                             return Image.asset(
// //                                                                 'assets/images/notfound.png',
// //                                                                 fit: BoxFit
// //                                                                     .cover);
// //                                                           },
// //                                                           fit: BoxFit.cover,
// //                                                         ),
// //                                                       ),
// //                                                     ),
// //                                                   ),
// //                                                 ),
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                                 SingleChildScrollView(
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         horizontal: 10, vertical: 10),
// //                                     child: value.gallery.isNotEmpty
// //                                         ? Column(
// //                                             children: [
// //                                               GridView.count(
// //                                                 primary: false,
// //                                                 crossAxisCount: 2,
// //                                                 mainAxisSpacing: 10,
// //                                                 crossAxisSpacing: 10,
// //                                                 shrinkWrap: true,
// //                                                 childAspectRatio: 100 / 100,
// //                                                 padding: EdgeInsets.zero,
// //                                                 children: List.generate(
// //                                                   value.gallery.length,
// //                                                   (index) {
// //                                                     return Padding(
// //                                                       padding:
// //                                                           const EdgeInsets.all(
// //                                                               10.0),
// //                                                       child: ClipRRect(
// //                                                         borderRadius:
// //                                                             BorderRadius
// //                                                                 .circular(5),
// //                                                         child:
// //                                                             SizedBox.fromSize(
// //                                                           size: const Size
// //                                                               .fromRadius(35),
// //                                                           child: FadeInImage(
// //                                                             image: NetworkImage(
// //                                                                 '${Environments.imageURL}${value.gallery[index].toString()}'),
// //                                                             placeholder:
// //                                                                 const AssetImage(
// //                                                                     "assets/images/placeholder.jpeg"),
// //                                                             imageErrorBuilder:
// //                                                                 (context, error,
// //                                                                     stackTrace) {
// //                                                               return Image.asset(
// //                                                                   'assets/images/notfound.png',
// //                                                                   fit: BoxFit
// //                                                                       .cover);
// //                                                             },
// //                                                             fit: BoxFit.cover,
// //                                                           ),
// //                                                         ),
// //                                                       ),
// //                                                     );
// //                                                   },
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           )
// //                                         : Column(
// //                                             crossAxisAlignment:
// //                                                 CrossAxisAlignment.center,
// //                                             mainAxisAlignment:
// //                                                 MainAxisAlignment.center,
// //                                             children: [
// //                                               const SizedBox(height: 20),
// //                                               SizedBox(
// //                                                 height: 80,
// //                                                 width: 80,
// //                                                 child: Image.asset(
// //                                                   "assets/images/no-data.png",
// //                                                   fit: BoxFit.cover,
// //                                                 ),
// //                                               ),
// //                                               const SizedBox(
// //                                                 height: 30,
// //                                               ),
// //                                               Center(
// //                                                 child: Text(
// //                                                   'No Found'.tr,
// //                                                   style: const TextStyle(
// //                                                       fontFamily: 'bold'),
// //                                                 ),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                   ),
// //                                 ),
// //                                 SingleChildScrollView(
// //                                   child: Padding(
// //                                     padding: const EdgeInsets.symmetric(
// //                                         vertical: 10),
// //                                     child: Column(
// //                                       children: [
// //                                         Padding(
// //                                           padding: const EdgeInsets.only(
// //                                               top: 10, left: 10),
// //                                           child: Row(
// //                                             children: [
// //                                               Text(
// //                                                 '${'All Reviews '.tr}(${value.ownerReviewsList.length})',
// //                                                 style: const TextStyle(
// //                                                     color: ThemeProvider
// //                                                         .greyColor),
// //                                               ),
// //                                             ],
// //                                           ),
// //                                         ),
// //                                         value.ownerReviewsList.isNotEmpty
// //                                             ? Column(
// //                                                 children: List.generate(
// //                                                 value.ownerReviewsList.length,
// //                                                 (index) => Container(
// //                                                   margin: const EdgeInsets
// //                                                       .symmetric(vertical: 10),
// //                                                   decoration:
// //                                                       const BoxDecoration(
// //                                                     border: Border(
// //                                                         bottom: BorderSide(
// //                                                             color: ThemeProvider
// //                                                                 .backgroundColor),
// //                                                         top: BorderSide(
// //                                                             color: ThemeProvider
// //                                                                 .backgroundColor)),
// //                                                   ),
// //                                                   child: Column(
// //                                                     children: [
// //                                                       Padding(
// //                                                         padding:
// //                                                             const EdgeInsets
// //                                                                 .symmetric(
// //                                                                 horizontal: 10,
// //                                                                 vertical: 10),
// //                                                         child: Row(
// //                                                           children: [
// //                                                             ClipRRect(
// //                                                               borderRadius:
// //                                                                   BorderRadius
// //                                                                       .circular(
// //                                                                           100),
// //                                                               child: SizedBox
// //                                                                   .fromSize(
// //                                                                 size: const Size
// //                                                                     .fromRadius(
// //                                                                     30),
// //                                                                 child:
// //                                                                     FadeInImage(
// //                                                                   image: NetworkImage(
// //                                                                       '${Environments.imageURL}${value.ownerReviewsList[index].user!.cover.toString()}'),
// //                                                                   placeholder:
// //                                                                       const AssetImage(
// //                                                                           "assets/images/placeholder.jpeg"),
// //                                                                   imageErrorBuilder:
// //                                                                       (context,
// //                                                                           error,
// //                                                                           stackTrace) {
// //                                                                     return Image
// //                                                                         .asset(
// //                                                                       'assets/images/notfound.png',
// //                                                                       fit: BoxFit
// //                                                                           .cover,
// //                                                                       height:
// //                                                                           30,
// //                                                                       width: 30,
// //                                                                     );
// //                                                                   },
// //                                                                   fit: BoxFit
// //                                                                       .cover,
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                             Expanded(
// //                                                               child: Padding(
// //                                                                 padding: const EdgeInsets
// //                                                                     .symmetric(
// //                                                                     horizontal:
// //                                                                         10),
// //                                                                 child: Column(
// //                                                                   children: [
// //                                                                     Row(
// //                                                                       mainAxisAlignment:
// //                                                                           MainAxisAlignment
// //                                                                               .spaceBetween,
// //                                                                       children: [
// //                                                                         SizedBox(
// //                                                                           width:
// //                                                                               120,
// //                                                                           child:
// //                                                                               Text(
// //                                                                             '${value.ownerReviewsList[index].user!.firstName!} ${value.ownerReviewsList[index].user!.lastName!}',
// //                                                                             overflow:
// //                                                                                 TextOverflow.ellipsis,
// //                                                                             style:
// //                                                                                 const TextStyle(fontSize: 15),
// //                                                                           ),
// //                                                                         ),
// //                                                                         Row(
// //                                                                           children: [
// //                                                                             const Icon(
// //                                                                               Icons.star,
// //                                                                               color: ThemeProvider.orangeColor,
// //                                                                               size: 15,
// //                                                                             ),
// //                                                                             SizedBox(
// //                                                                               child: Text(
// //                                                                                 value.ownerReviewsList[index].rating.toString(),
// //                                                                                 overflow: TextOverflow.ellipsis,
// //                                                                                 style: const TextStyle(color: ThemeProvider.blackColor, fontSize: 12),
// //                                                                               ),
// //                                                                             ),
// //                                                                           ],
// //                                                                         ),
// //                                                                       ],
// //                                                                     ),
// //                                                                     Row(
// //                                                                       children: [
// //                                                                         Icon(
// //                                                                             Icons
// //                                                                                 .star,
// //                                                                             color: value.ownerReviewsList[index].rating! >= 1
// //                                                                                 ? ThemeProvider.orangeColor
// //                                                                                 : ThemeProvider.greyColor,
// //                                                                             size: 15),
// //                                                                         Icon(
// //                                                                             Icons
// //                                                                                 .star,
// //                                                                             color: value.ownerReviewsList[index].rating! >= 2
// //                                                                                 ? ThemeProvider.orangeColor
// //                                                                                 : ThemeProvider.greyColor,
// //                                                                             size: 15),
// //                                                                         Icon(
// //                                                                             Icons
// //                                                                                 .star,
// //                                                                             color: value.ownerReviewsList[index].rating! >= 3
// //                                                                                 ? ThemeProvider.orangeColor
// //                                                                                 : ThemeProvider.greyColor,
// //                                                                             size: 15),
// //                                                                         Icon(
// //                                                                             Icons
// //                                                                                 .star,
// //                                                                             color: value.ownerReviewsList[index].rating! >= 4
// //                                                                                 ? ThemeProvider.orangeColor
// //                                                                                 : ThemeProvider.greyColor,
// //                                                                             size: 15),
// //                                                                         Icon(
// //                                                                             Icons
// //                                                                                 .star,
// //                                                                             color: value.ownerReviewsList[index].rating! >= 5
// //                                                                                 ? ThemeProvider.orangeColor
// //                                                                                 : ThemeProvider.greyColor,
// //                                                                             size: 15),
// //                                                                       ],
// //                                                                     ),
// //                                                                   ],
// //                                                                 ),
// //                                                               ),
// //                                                             ),
// //                                                           ],
// //                                                         ),
// //                                                       ),
// //                                                       Padding(
// //                                                         padding:
// //                                                             const EdgeInsets
// //                                                                 .symmetric(
// //                                                                 horizontal: 10,
// //                                                                 vertical: 5),
// //                                                         child: Text(
// //                                                           value
// //                                                               .ownerReviewsList[
// //                                                                   index]
// //                                                               .notes!,
// //                                                           style:
// //                                                               const TextStyle(
// //                                                                   fontSize: 12),
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                 ),
// //                                               ))
// //                                             : Column(
// //                                                 crossAxisAlignment:
// //                                                     CrossAxisAlignment.center,
// //                                                 mainAxisAlignment:
// //                                                     MainAxisAlignment.center,
// //                                                 children: [
// //                                                   const SizedBox(height: 20),
// //                                                   SizedBox(
// //                                                     height: 80,
// //                                                     width: 80,
// //                                                     child: Image.asset(
// //                                                       "assets/images/no-data.png",
// //                                                       fit: BoxFit.cover,
// //                                                     ),
// //                                                   ),
// //                                                   const SizedBox(
// //                                                     height: 30,
// //                                                   ),
// //                                                   Center(
// //                                                     child: Text(
// //                                                       'No Found'.tr,
// //                                                       style: const TextStyle(
// //                                                           fontFamily: 'bold'),
// //                                                     ),
// //                                                   ),
// //                                                 ],
// //                                               ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //           bottomNavigationBar:
// //               Get.find<ServiceCartController>().totalItemsInCart > 0 &&
// //                       Get.find<ServiceCartController>().servicesFrom == 'salon'
// //                   ? SizedBox(
// //                       height: 70,
// //                       child: InkWell(
// //                         onTap: () {
// //                           value.onCheckout();
// //                         },
// //                         child: Container(
// //                           margin: const EdgeInsets.all(10),
// //                           padding: const EdgeInsets.symmetric(horizontal: 20),
// //                           decoration: BoxDecoration(
// //                             color: ThemeProvider.pink,
// //                             borderRadius: BorderRadius.circular(5),
// //                           ),
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 value.currencySide == 'left'
// //                                     ? '${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
// //                                     : ' ${Get.find<ServiceCartController>().totalItemsInCart} ${'Items'.tr} ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
// //                                 style: const TextStyle(
// //                                     color: ThemeProvider.whiteColor),
// //                               ),
// //                               Text(
// //                                 'Book Services'.tr,
// //                                 style: const TextStyle(
// //                                     color: ThemeProvider.whiteColor),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     )
// //                   : const SizedBox(),
// //         );
// //       },
// //     );
// //   }

// //   String _getGenderText(int? gender) {
// //     switch (gender) {
// //       case 0:
// //         return 'Male';
// //       case 1:
// //         return 'Female';
// //       case 2:
// //         return 'Kid';
// //       case 3:
// //         return 'Family';
// //       default:
// //         return 'Unknown'; // Fallback if gender is null or out of range
// //     }
// //   }

// //   Widget _buildSegment() {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 10),
// //       child: Container(
// //         decoration: BoxDecoration(
// //           border: Border.all(color: ThemeProvider.appColor),
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Expanded(
// //               child: InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     tabID = 1;
// //                   });
// //                 },
// //                 child: Container(
// //                   height: 30,
// //                   decoration: BoxDecoration(
// //                     color: tabID == 1
// //                         ? ThemeProvider.appColor
// //                         : Colors.transparent,
// //                     borderRadius: tabID == 1
// //                         ? const BorderRadius.only(
// //                             topLeft: Radius.circular(10),
// //                             bottomLeft: Radius.circular(10),
// //                           )
// //                         : BorderRadius.circular(0),
// //                   ),
// //                   child: Center(
// //                       child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 30),
// //                     child: Text('Services'.tr, style: segmentText(1)),
// //                   )),
// //                 ),
// //               ),
// //             ),
// //             Expanded(
// //               child: InkWell(
// //                 onTap: () {
// //                   setState(() {
// //                     tabID = 2;
// //                   });
// //                 },
// //                 child: Container(
// //                   height: 30,
// //                   decoration: BoxDecoration(
// //                     color: tabID == 2
// //                         ? ThemeProvider.appColor
// //                         : Colors.transparent,
// //                     borderRadius: tabID == 2
// //                         ? const BorderRadius.only(
// //                             topRight: Radius.circular(10),
// //                             bottomRight: Radius.circular(10),
// //                           )
// //                         : BorderRadius.circular(0),
// //                   ),
// //                   child: Center(
// //                       child: Padding(
// //                     padding: const EdgeInsets.symmetric(horizontal: 30),
// //                     child: Text('Packages'.tr, style: segmentText(2)),
// //                   )),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   segmentText(val) {
// //     return TextStyle(
// //         fontSize: 12,
// //         color:
// //             tabID == val ? ThemeProvider.whiteColor : ThemeProvider.greyColor);
// //   }
// // }

// // contentButtonStyle() {
// //   return const BoxDecoration(
// //     borderRadius: BorderRadius.all(
// //       Radius.circular(100.0),
// //     ),
// //     gradient: LinearGradient(
// //       begin: Alignment.centerLeft,
// //       end: Alignment.centerRight,
// //       colors: [
// //         Color.fromARGB(229, 52, 1, 255),
// //         Color.fromARGB(228, 111, 75, 255),
// //       ],
// //     ),
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:salon_user/app/backend/models/services_model.dart';
// import 'package:salon_user/app/controller/service_cart_controller.dart';
// import 'package:salon_user/app/controller/services_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:salon_user/app/view/imageviewer.dart';

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
//                                                 color: value.status == 'Closed'
//                                                     ? Colors.red
//                                                     : ThemeProvider.greenColor,
//                                               ),
//                                             ),
//                                             child: Center(
//                                               child: Text(
//                                                 value.status,
//                                                 style: TextStyle(
//                                                   color:
//                                                       value.status == 'Closed'
//                                                           ? Colors.red
//                                                           : ThemeProvider
//                                                               .greenColor,
//                                                   fontSize: 10,
//                                                 ),
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
//                                                           const BouncingScrollPhysics(), // Smooth scrolling
//                                                       shrinkWrap: true,
//                                                       itemBuilder:
//                                                           (context, i) {
//                                                         final service = value
//                                                             .servicesList[i];

//                                                         return Container(
//                                                           margin:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   vertical: 5,
//                                                                   horizontal:
//                                                                       0),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10),
//                                                             color: ThemeProvider
//                                                                 .whiteColor,
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: ThemeProvider
//                                                                     .greyColor
//                                                                     .withOpacity(
//                                                                         0.3),
//                                                                 blurRadius: 8,
//                                                                 offset:
//                                                                     const Offset(
//                                                                         0, 3),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                     .all(12.0),
//                                                             child: Row(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 // Image Stack
//                                                                 Stack(
//                                                                   children: [
//                                                                     ClipRRect(
//                                                                       borderRadius:
//                                                                           BorderRadius.circular(
//                                                                               8),
//                                                                       child:
//                                                                           SizedBox(
//                                                                         width:
//                                                                             100,
//                                                                         height:
//                                                                             150,
//                                                                         child:
//                                                                             FadeInImage(
//                                                                           image:
//                                                                               NetworkImage('${Environments.imageURL}${service.cover}'),
//                                                                           placeholder:
//                                                                               const AssetImage("assets/images/placeholder.jpeg"),
//                                                                           imageErrorBuilder: (context,
//                                                                               error,
//                                                                               stackTrace) {
//                                                                             return Image.asset(
//                                                                               'assets/images/notfound.png',
//                                                                               fit: BoxFit.cover,
//                                                                             );
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
//                                                                         padding: const EdgeInsets
//                                                                             .symmetric(
//                                                                             horizontal:
//                                                                                 6,
//                                                                             vertical:
//                                                                                 2),
//                                                                         decoration:
//                                                                             BoxDecoration(
//                                                                           color: ThemeProvider
//                                                                               .blackColor
//                                                                               .withOpacity(0.7),
//                                                                           borderRadius:
//                                                                               const BorderRadius.only(
//                                                                             topLeft:
//                                                                                 Radius.circular(8),
//                                                                             bottomRight:
//                                                                                 Radius.circular(8),
//                                                                           ),
//                                                                         ),
//                                                                         child:
//                                                                             Text(
//                                                                           '${service.discount}%',
//                                                                           style:
//                                                                               const TextStyle(
//                                                                             fontSize:
//                                                                                 12,
//                                                                             color:
//                                                                                 ThemeProvider.whiteColor,
//                                                                             fontWeight:
//                                                                                 FontWeight.bold,
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ),
//                                                                   ],
//                                                                 ),
//                                                                 const SizedBox(
//                                                                     width: 12),
//                                                                 // Details Column
//                                                                 Expanded(
//                                                                   child: Column(
//                                                                     crossAxisAlignment:
//                                                                         CrossAxisAlignment
//                                                                             .start,
//                                                                     children: [
//                                                                       Row(
//                                                                         mainAxisAlignment:
//                                                                             MainAxisAlignment.spaceBetween,
//                                                                         children: [
//                                                                           Expanded(
//                                                                             child:
//                                                                                 Text(
//                                                                               service.name.toString(),
//                                                                               maxLines: 2,
//                                                                               overflow: TextOverflow.ellipsis,
//                                                                               style: const TextStyle(
//                                                                                 fontFamily: 'bold',
//                                                                                 fontSize: 16,
//                                                                                 color: ThemeProvider.blackColor,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                           Checkbox(
//                                                                             value:
//                                                                                 service.isChecked,
//                                                                             onChanged:
//                                                                                 (status) {
//                                                                               value.updateServiceStatusInCart(i, status as bool);
//                                                                             },
//                                                                             checkColor:
//                                                                                 ThemeProvider.whiteColor,
//                                                                             activeColor:
//                                                                                 ThemeProvider.appColor,
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.circular(4),
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       const SizedBox(
//                                                                           height:
//                                                                               4),
//                                                                       RichText(
//                                                                         text:
//                                                                             TextSpan(
//                                                                           style:
//                                                                               const TextStyle(fontSize: 14),
//                                                                           children: [
//                                                                             TextSpan(
//                                                                               text: value.currencySide == 'left' ? '${value.currencySymbol} ${service.price}' : '${service.price}${value.currencySymbol}',
//                                                                               style: const TextStyle(
//                                                                                 color: ThemeProvider.greyColor,
//                                                                                 decoration: TextDecoration.lineThrough,
//                                                                               ),
//                                                                             ),
//                                                                             const WidgetSpan(child: SizedBox(width: 4)),
//                                                                             TextSpan(
//                                                                               text: value.currencySide == 'left' ? '${value.currencySymbol} ${service.off}' : '${service.off}${value.currencySymbol}',
//                                                                               style: const TextStyle(
//                                                                                 color: ThemeProvider.greenColor,
//                                                                                 fontWeight: FontWeight.bold,
//                                                                               ),
//                                                                             ),
//                                                                           ],
//                                                                         ),
//                                                                       ),
//                                                                       const SizedBox(
//                                                                           height:
//                                                                               6),
//                                                                       Row(
//                                                                         children: [
//                                                                           const Icon(
//                                                                               Icons.timer,
//                                                                               size: 16,
//                                                                               color: ThemeProvider.greyColor),
//                                                                           const SizedBox(
//                                                                               width: 4),
//                                                                           Text(
//                                                                             '${service.duration} min',
//                                                                             style:
//                                                                                 const TextStyle(
//                                                                               fontSize: 12,
//                                                                               color: ThemeProvider.greyColor,
//                                                                             ),
//                                                                           ),
//                                                                           const SizedBox(
//                                                                               width: 12),
//                                                                           const Icon(
//                                                                               Icons.person,
//                                                                               size: 16,
//                                                                               color: ThemeProvider.greyColor),
//                                                                           const SizedBox(
//                                                                               width: 4),
//                                                                           Text(
//                                                                             _getGenderText(service.gender),
//                                                                             style:
//                                                                                 const TextStyle(
//                                                                               fontSize: 12,
//                                                                               color: ThemeProvider.greyColor,
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       const SizedBox(
//                                                                           height:
//                                                                               8),
//                                                                       Align(
//                                                                         alignment:
//                                                                             Alignment.centerRight,
//                                                                         child:
//                                                                             ElevatedButton(
//                                                                           onPressed:
//                                                                               () {
//                                                                             _showServiceDetailsDialog(
//                                                                                 context,
//                                                                                 service,
//                                                                                 value);
//                                                                           },
//                                                                           style:
//                                                                               ElevatedButton.styleFrom(
//                                                                             foregroundColor:
//                                                                                 ThemeProvider.whiteColor,
//                                                                             backgroundColor:
//                                                                                 ThemeProvider.appColor,
//                                                                             padding:
//                                                                                 const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                                                                             shape:
//                                                                                 RoundedRectangleBorder(
//                                                                               borderRadius: BorderRadius.circular(8),
//                                                                             ),
//                                                                             elevation:
//                                                                                 0,
//                                                                           ),
//                                                                           child:
//                                                                               const Text(
//                                                                             'Details',
//                                                                             style:
//                                                                                 TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//                                                                           ),
//                                                                         ),
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         );
//                                                       },
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 50,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         else if (tabID == 2)
//                                           for (var item in value.packagesList)
//                                             Padding(
//                                               padding: const EdgeInsets
//                                                   .symmetric(
//                                                   vertical: 8,
//                                                   horizontal:
//                                                       16), // Adjusted for balance
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           12), // Softer corners
//                                                   color: ThemeProvider
//                                                       .whiteColor, // Card background
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: ThemeProvider
//                                                           .greyColor
//                                                           .withOpacity(
//                                                               0.2), // Subtle shadow
//                                                       blurRadius: 8,
//                                                       offset:
//                                                           const Offset(0, 4),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     // Image Section
//                                                     ClipRRect(
//                                                       borderRadius: const BorderRadius
//                                                           .vertical(
//                                                           top: Radius.circular(
//                                                               12)), // Rounded top
//                                                       child: SizedBox(
//                                                         height: 150,
//                                                         width: double.infinity,
//                                                         child: FadeInImage(
//                                                           image: NetworkImage(
//                                                               '${Environments.imageURL}${item.cover}'),
//                                                           placeholder:
//                                                               const AssetImage(
//                                                                   "assets/images/placeholder.jpeg"),
//                                                           imageErrorBuilder:
//                                                               (context, error,
//                                                                   stackTrace) {
//                                                             return Image.asset(
//                                                               'assets/images/notfound.png',
//                                                               fit: BoxFit.cover,
//                                                             );
//                                                           },
//                                                           fit: BoxFit.cover,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     // Content Section
//                                                     Padding(
//                                                       padding: const EdgeInsets
//                                                           .all(
//                                                           12.0), // Consistent inner padding
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           // Name and View Button Row
//                                                           Row(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .spaceBetween,
//                                                             children: [
//                                                               Expanded(
//                                                                 child: Text(
//                                                                   item.name
//                                                                       .toString(),
//                                                                   maxLines: 1,
//                                                                   overflow:
//                                                                       TextOverflow
//                                                                           .ellipsis,
//                                                                   style:
//                                                                       const TextStyle(
//                                                                     fontFamily:
//                                                                         'bold',
//                                                                     fontSize:
//                                                                         16, // Slightly larger for emphasis
//                                                                     color: ThemeProvider
//                                                                         .blackColor,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                               GestureDetector(
//                                                                 onTap: () {
//                                                                   value.onPackagesDetails(
//                                                                       item.id
//                                                                           as int,
//                                                                       item.name
//                                                                           .toString());
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           12,
//                                                                       vertical:
//                                                                           6),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     color: ThemeProvider
//                                                                         .appColor
//                                                                         .withOpacity(
//                                                                             0.1), // Subtle background
//                                                                     borderRadius:
//                                                                         BorderRadius
//                                                                             .circular(8),
//                                                                   ),
//                                                                   child: Text(
//                                                                     'View'.tr,
//                                                                     style:
//                                                                         const TextStyle(
//                                                                       fontFamily:
//                                                                           'bold',
//                                                                       fontSize:
//                                                                           12,
//                                                                       color: ThemeProvider
//                                                                           .appColor,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           const SizedBox(
//                                                               height:
//                                                                   8), // Spacing between elements
//                                                           // Price Row
//                                                           Row(
//                                                             children: [
//                                                               Column(
//                                                                 children: [
//                                                                   Text(
//                                                                     Get.find<ServicesController>().currencySide ==
//                                                                             'left'
//                                                                         ? '${Get.find<ServicesController>().currencySymbol} ${item.price}'
//                                                                         : '${item.price}${Get.find<ServicesController>().currencySymbol}',
//                                                                     style:
//                                                                         const TextStyle(
//                                                                       decoration:
//                                                                           TextDecoration
//                                                                               .lineThrough,
//                                                                       fontSize:
//                                                                           14,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       color: ThemeProvider
//                                                                           .greyColor,
//                                                                     ),
//                                                                   ),
//                                                                   Text(
//                                                                     Get.find<ServicesController>().currencySide ==
//                                                                             'left'
//                                                                         ? '${Get.find<ServicesController>().currencySymbol} ${item.off}'
//                                                                         : '${item.off}${Get.find<ServicesController>().currencySymbol}',
//                                                                     style:
//                                                                         const TextStyle(
//                                                                       fontSize:
//                                                                           18,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w900,
//                                                                       color: Color.fromARGB(
//                                                                           255,
//                                                                           14,
//                                                                           188,
//                                                                           14),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                         const SizedBox(
//                                           height: 380,
//                                         )
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 SingleChildScrollView(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(
//                                         16.0), // Consistent padding
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         // About Section
//                                         _buildSectionTitle('About'.tr),
//                                         const SizedBox(height: 8),
//                                         Text(
//                                           value.salonDetails.about.toString(),
//                                           style: const TextStyle(
//                                             fontSize: 14,
//                                             color: ThemeProvider.blackColor,
//                                             height:
//                                                 1.5, // Improved readability with line spacing
//                                           ),
//                                         ),

//                                         // Opening Hours Section
//                                         _buildSectionTitle('Opening Hour'.tr),
//                                         const SizedBox(height: 8),
//                                         Column(
//                                           children: List.generate(
//                                             value.salonDetails.timing!.length,
//                                             (index) => Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 6),
//                                               child: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.center,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.circle,
//                                                     color: ThemeProvider
//                                                         .greenColor,
//                                                     size: 10,
//                                                   ),
//                                                   const SizedBox(width: 12),
//                                                   Expanded(
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                           value.dayList[value
//                                                               .salonDetails
//                                                               .timing![index]
//                                                               .day as int],
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 14,
//                                                             color: ThemeProvider
//                                                                 .greyColor,
//                                                           ),
//                                                         ),
//                                                         Text(
//                                                           '${value.salonDetails.timing![index].openTime} - ${value.salonDetails.timing![index].closeTime}',
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 14,
//                                                             color: ThemeProvider
//                                                                 .blackColor,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),

//                                         // Address Section
//                                         _buildSectionTitle('Address'.tr),
//                                         const SizedBox(height: 8),
//                                         Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     value.salonDetails.address
//                                                         .toString(),
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                       fontSize: 14,
//                                                       color: ThemeProvider
//                                                           .greyColor,
//                                                     ),
//                                                   ),
//                                                   const SizedBox(height: 12),
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       // Add navigation logic here if needed
//                                                     },
//                                                     child: Row(
//                                                       children: [
//                                                         const SizedBox(
//                                                             width: 6),
//                                                         Text(
//                                                           '${'Get Direction'.tr} - ${value.getDistance} KM',
//                                                           style:
//                                                               const TextStyle(
//                                                             fontSize: 14,
//                                                             color: ThemeProvider
//                                                                 .orangeColor,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             const SizedBox(width: 16),
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               child: SizedBox(
//                                                 width: 100,
//                                                 height: 100,
//                                                 child: GoogleMap(
//                                                   onMapCreated:
//                                                       value.onMapCreated(),
//                                                   markers: value.markers,
//                                                   initialCameraPosition:
//                                                       CameraPosition(
//                                                     target: LatLng(
//                                                       value.salonDetails.lat
//                                                           as double,
//                                                       value.salonDetails.lng
//                                                           as double,
//                                                     ),
//                                                     zoom:
//                                                         12, // Adjusted zoom for better visibility
//                                                   ),
//                                                   myLocationButtonEnabled:
//                                                       false,
//                                                   zoomControlsEnabled: false,
//                                                   liteModeEnabled:
//                                                       true, // Lightweight map mode
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),

//                                         // Photos Section (Uncomment and enhance if needed)
//                                         /*
//         _buildSectionTitle('Photos'.tr),
//         const SizedBox(height: 8),
//         SizedBox(
//           height: 120,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: value.gallery.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: SizedBox(
//                     width: 120,
//                     child: FadeInImage(
//                       image: NetworkImage('${Environments.imageURL}${value.gallery[index].toString()}'),
//                       placeholder: const AssetImage("assets/images/placeholder.jpeg"),
//                       imageErrorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/images/notfound.png',
//                           fit: BoxFit.cover,
//                         );
//                       },
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {
//               // Add view all logic here
//             },
//             child: Text(
//               'View All'.tr,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: ThemeProvider.appColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//         */
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 value.isPremium
//                                     ? SingleChildScrollView(
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 10),
//                                           child: value.gallery.isNotEmpty
//                                               ? Column(
//                                                   children: [
//                                                     GridView.count(
//                                                       primary: false,
//                                                       crossAxisCount: 2,
//                                                       mainAxisSpacing: 10,
//                                                       crossAxisSpacing: 10,
//                                                       shrinkWrap: true,
//                                                       childAspectRatio:
//                                                           100 / 100,
//                                                       padding: EdgeInsets.zero,
//                                                       children: List.generate(
//                                                         value.gallery.length,
//                                                         (index) {
//                                                           return GestureDetector(
//                                                             onTap: () {
//                                                               Navigator.push(
//                                                                 context,
//                                                                 MaterialPageRoute(
//                                                                   builder:
//                                                                       (context) =>
//                                                                           ImageGalleryScreen(
//                                                                     gallery: value
//                                                                         .gallery,
//                                                                     initialIndex:
//                                                                         index,
//                                                                   ),
//                                                                 ),
//                                                               );
//                                                             },
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                       .all(
//                                                                       10.0),
//                                                               child: ClipRRect(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             5),
//                                                                 child: SizedBox
//                                                                     .fromSize(
//                                                                   size: const Size
//                                                                       .fromRadius(
//                                                                       35),
//                                                                   child:
//                                                                       FadeInImage(
//                                                                     image: NetworkImage(
//                                                                         '${Environments.imageURL}${value.gallery[index].toString()}'),
//                                                                     placeholder:
//                                                                         const AssetImage(
//                                                                             "assets/images/placeholder.jpeg"),
//                                                                     imageErrorBuilder:
//                                                                         (context,
//                                                                             error,
//                                                                             stackTrace) {
//                                                                       return Image.asset(
//                                                                           'assets/images/notfound.png',
//                                                                           fit: BoxFit
//                                                                               .cover);
//                                                                     },
//                                                                     fit: BoxFit
//                                                                         .cover,
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           );
//                                                         },
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 )
//                                               : Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   children: [
//                                                     const SizedBox(height: 20),
//                                                     SizedBox(
//                                                       height: 80,
//                                                       width: 80,
//                                                       child: Image.asset(
//                                                         "assets/images/no-data.png",
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 30,
//                                                     ),
//                                                     Center(
//                                                       child: Text(
//                                                         'No Found'.tr,
//                                                         style: const TextStyle(
//                                                             fontFamily: 'bold'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                         ),
//                                       )
//                                     : Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const SizedBox(height: 20),
//                                           SizedBox(
//                                             height: 80,
//                                             width: 80,
//                                             child: Image.asset(
//                                               "assets/images/no-data.png",
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 30,
//                                           ),
//                                           Center(
//                                             child: Text(
//                                               'Feature Not Available For This Business'
//                                                   .tr,
//                                               style: const TextStyle(
//                                                   fontFamily: 'bold'),
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 550,
//                                           ),
//                                         ],
//                                       ),
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
//           bottomNavigationBar: GetBuilder<ServiceCartController>(
//             builder: (cartController) {
//               return cartController.totalItemsInCart > 0 &&
//                       cartController.servicesFrom == 'salon'
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
//                                     ? '${cartController.totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${cartController.totalPrice}'
//                                     : '${cartController.totalItemsInCart} ${'Items'.tr} ${cartController.totalPrice}${value.currencySymbol}',
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
//                   : const SizedBox();
//             },
//           ),
//         );
//       },
//     );
//   }

//   // String _getGenderText(int? gender) {
//   //   switch (gender) {
//   //     case 0:
//   //       return 'Male';
//   //     case 1:
//   //       return 'Female';
//   //     case 2:
//   //       return 'Kid';
//   //     case 3:
//   //       return 'Family';
//   //     default:
//   //       return 'Unknown'; // Fallback if gender is null or out of range
//   //   }
//   // }

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

// // Helper function (assuming it exists elsewhere or define it here)
// String _getGenderText(int? genderCode) {
//   switch (genderCode) {
//     case 0:
//       return 'Kids';
//     case 1:
//       return 'Male';
//     case 2:
//       return 'Female';
//     case 3:
//       return 'Family';
//     default:
//       return 'Unknown';
//   }
// }

// void _showServiceDetailsDialog(BuildContext context, ServicesModel service,
//     ServicesController servicesController) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         title: Text(
//           service.name ?? 'Service Details',
//           style: const TextStyle(
//             fontFamily: 'bold',
//             fontSize: 20,
//             color: ThemeProvider.appColor,
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (service.descriptions != null &&
//                   service.descriptions!.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 8.0),
//                   child: Text(
//                     'Description: ${service.descriptions}',
//                     style: const TextStyle(
//                         fontSize: 14, color: ThemeProvider.greyColor),
//                   ),
//                 ),
//               _buildDetailRow(
//                 'Price',
//                 servicesController.currencySide == 'left'
//                     ? '${servicesController.currencySymbol} ${service.price}'
//                     : '${service.price}${servicesController.currencySymbol}',
//               ),
//               _buildDetailRow(
//                 'Offer Price',
//                 servicesController.currencySide == 'left'
//                     ? '${servicesController.currencySymbol} ${service.off}'
//                     : '${service.off}${servicesController.currencySymbol}',
//                 color: ThemeProvider.greenColor,
//                 fontWeight: FontWeight.bold,
//               ),
//               _buildDetailRow('Discount', '${service.discount}%'),
//               _buildDetailRow('Duration', '${service.duration} min'),
//               _buildDetailRow('Gender', _getGenderText(service.gender)),
//               if (service.extraField != null && service.extraField!.isNotEmpty)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   child: Text(
//                     'Extra Info: ${service.extraField}',
//                     style: const TextStyle(
//                         fontSize: 14, color: ThemeProvider.greyColor),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: ThemeProvider.appColor,
//               textStyle: const TextStyle(fontFamily: 'bold'),
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('Close'),
//           ),
//         ],
//       );
//     },
//   );
// }

// // Helper method for section titles
// Widget _buildSectionTitle(String title) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 20, bottom: 4),
//     child: Text(
//       title,
//       style: const TextStyle(
//         fontSize: 18,
//         fontFamily: 'bold',
//         color: ThemeProvider.blackColor,
//       ),
//     ),
//   );
// }

// // Helper method to create consistent detail rows
// Widget _buildDetailRow(String label, String value,
//     {Color? color, FontWeight? fontWeight}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 4.0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           '$label:',
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//             color: ThemeProvider.greyColor,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 14,
//             color: color ?? ThemeProvider.blackColor,
//             fontWeight: fontWeight ?? FontWeight.normal,
//           ),
//         ),
//       ],
//     ),
//   );
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
  // App Colors
  static const Color primary = ThemeProvider.pink;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFCBD5E1);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 3,
                  ),
                )
              : NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      _buildSliverAppBar(value, context),
                    ];
                  },
                  body: Column(
                    children: [
                      // Tab Bar

                      // Tab Content
                      Expanded(
                        child: TabBarView(
                          controller: value.tabController,
                          children: [
                            _buildServicesTab(value),
                            _buildAboutTab(value),
                            _buildGalleryTab(value),
                            _buildReviewsTab(value),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          bottomNavigationBar: _buildBottomNavigationBar(value),
        );
      },
    );
  }

  Widget _buildSliverAppBar(ServicesController value, BuildContext context) {
    return SliverAppBar(
      backgroundColor: cardBackground,
      floating: true,
      pinned: true,
      expandedHeight: 300,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Hero Image
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      '${Environments.imageURL}${value.salonDetails.cover.toString()}'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient overlay
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Back button
            // Positioned(
            //   top: 40,
            //   left: 1,
            //   child: Container(
            //     padding: const EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       // color: Color.fromARGB(13, 141, 141, 141).withOpacity(0.9),
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: IconButton(
            //       icon: const Icon(Icons.arrow_back, color: textPrimary),
            //       onPressed: () => Get.back(),
            //       padding: EdgeInsets.zero,
            //       constraints: const BoxConstraints(),
            //     ),
            //   ),
            // ),
            // Salon info
            Positioned(
              bottom: 140,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.salonDetails.name.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value.salonDetails.address.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: warning, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '(${value.salonDetails.totalRating} ${'Reviews'.tr})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: value.status == 'Closed' ? error : success,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          value.status ?? 'OPEN'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(0)),
                  boxShadow: const [
                    BoxShadow(
                      color: shadowLight,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.language, 'Website'.tr,
                          () => value.openWebsite()),
                      _buildActionButton(
                          Icons.call, 'Call'.tr, () => value.callSalon()),
                      _buildActionButton(
                          Icons.chat_outlined, 'Chat'.tr, () => value.onChat()),
                      _buildActionButton(Icons.directions, 'Direction'.tr,
                          () => value.openMap()),
                      _buildActionButton(
                          Icons.share, 'Share'.tr, () => value.share()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          color: cardBackground,
          child: TabBar(
            controller: value.tabController,
            labelColor: primary,
            unselectedLabelColor: textSecondary,
            indicatorColor: primary,
            indicatorWeight: 3,
            tabs: [
              Tab(text: 'Services'.tr),
              Tab(text: 'About'.tr),
              Tab(text: 'Gallery'.tr),
              Tab(text: 'Reviews'.tr),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesTab(ServicesController value) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildServiceSegmentControl(),
          const SizedBox(height: 16),
          if (tabID == 1)
            _buildServicesList(value)
          else
            _buildPackagesList(value),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildServiceSegmentControl() {
    return Container(
      decoration: BoxDecoration(
        color: surfaceBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => tabID = 1),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color:
                      tabID == 1 ? ThemeProvider.appColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Services'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tabID == 1 ? Colors.white : textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => tabID = 2),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: tabID == 2 ? primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Packages'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: tabID == 2 ? Colors.white : textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(ServicesController value) {
    return Column(
      children: List.generate(
        value.servicesList.length,
        (i) => _buildServiceCard(value.servicesList[i], i, value),
      ),
    );
  }

  Widget _buildServiceCard(
      ServicesModel service, int index, ServicesController value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Image
            Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      image: NetworkImage(
                          '${Environments.imageURL}${service.cover}'),
                      placeholder:
                          const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/notfound.png',
                            fit: BoxFit.cover);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (service.discount != null && service.discount! > 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: error,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${service.discount}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Service Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: service.isChecked,
                          onChanged: (status) {
                            value.updateServiceStatusInCart(
                                index, status as bool);
                          },
                          activeColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Row(
                    children: [
                      if (service.price != service.off) ...[
                        Text(
                          value.currencySide == 'left'
                              ? '${value.currencySymbol}${service.price}'
                              : '${service.price}${value.currencySymbol}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: textSecondary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        value.currencySide == 'left'
                            ? '${value.currencySymbol}${service.off}'
                            : '${service.off}${value.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Duration and Gender
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: info),
                            const SizedBox(width: 4),
                            Text(
                              '${service.duration} min',
                              style: const TextStyle(
                                fontSize: 12,
                                color: info,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getGenderText(service.gender),
                          style: const TextStyle(
                            fontSize: 12,
                            color: warning,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Details button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () =>
                          _showServiceDetailsDialog(context, service, value),
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
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
  }

  Widget _buildPackagesList(ServicesController value) {
    return Column(
      children: List.generate(
        value.packagesList.length,
        (i) => _buildPackageCard(value.packagesList[i], value),
      ),
    );
  }

  Widget _buildPackageCard(dynamic package, ServicesController value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 180,
              width: double.infinity,
              child: FadeInImage(
                image: NetworkImage('${Environments.imageURL}${package.cover}'),
                placeholder: const AssetImage("assets/images/placeholder.jpeg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/notfound.png',
                      fit: BoxFit.cover);
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        package.name.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        value.onPackagesDetails(
                            package.id as int, package.name.toString());
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: primary,
                        backgroundColor: primary.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'View'.tr,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (package.price != package.off) ...[
                      Text(
                        value.currencySide == 'left'
                            ? '${value.currencySymbol}${package.price}'
                            : '${package.price}${value.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      value.currencySide == 'left'
                          ? '${value.currencySymbol}${package.off}'
                          : '${package.off}${value.currencySymbol}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(ServicesController value) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAboutSection(value),
          const SizedBox(height: 24),
          _buildOpeningHoursSection(value),
          const SizedBox(height: 24),
          _buildAddressSection(value),
        ],
      ),
    );
  }

  Widget _buildAboutSection(ServicesController value) {
    return Container(
      width: double.infinity,
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
            Text(
              'About'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value.salonDetails.about.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHoursSection(ServicesController value) {
    return Container(
      width: double.infinity,
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
            Text(
              'Opening Hours'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              value.salonDetails.timing?.length ?? 0,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value.dayList[
                          value.salonDetails.timing![index].day as int],
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${_convertTo12HourFormat(value.salonDetails.timing![index].openTime)}  to  ${_convertTo12HourFormat(value.salonDetails.timing![index].closeTime)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper method to convert 24-hour format to 12-hour format
  String _convertTo12HourFormat(String? time) {
    if (time == null || time.isEmpty) return '';

    try {
      // Parse the time string (assuming format like "14:30" or "14:30:00")
      List<String> timeParts = time.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);

      // Convert to 12-hour format
      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      // Format the time string
      String formattedMinute = minute.toString().padLeft(2, '0');
      return '$displayHour:$formattedMinute $period';
    } catch (e) {
      // Return original time if parsing fails
      return time;
    }
  }

  Widget _buildAddressSection(ServicesController value) {
    return Container(
      width: double.infinity,
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
            Text(
              'Address'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.salonDetails.address.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.near_me, size: 16, color: primary),
                        const SizedBox(width: 6),
                        Text(
                          '${'Get Direction'.tr} - ${value.getDistance} KM',
                          style: const TextStyle(
                            fontSize: 14,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 250,
                    child: GoogleMap(
                      onMapCreated: value.onMapCreated(),
                      markers: value.markers,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          value.salonDetails.lat as double,
                          value.salonDetails.lng as double,
                        ),
                        zoom: 12,
                      ),
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      liteModeEnabled: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryTab(ServicesController value) {
    if (!value.isPremium) {
      return _buildFeatureNotAvailable();
    }

    if (value.gallery.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: value.gallery.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGalleryScreen(
                    gallery: value.gallery,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: shadowLight,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeInImage(
                  image: NetworkImage(
                      '${Environments.imageURL}${value.gallery[index].toString()}'),
                  placeholder:
                      const AssetImage("assets/images/placeholder.jpeg"),
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
    );
  }

  Widget _buildReviewsTab(ServicesController value) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'All Reviews'.tr} (${value.ownerReviewsList.length})',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (value.ownerReviewsList.isNotEmpty)
            ...List.generate(
              value.ownerReviewsList.length,
              (index) => _buildReviewCard(value.ownerReviewsList[index]),
            )
          else
            _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: FadeInImage(
                      image: NetworkImage(
                          '${Environments.imageURL}${review.user!.cover.toString()}'),
                      placeholder:
                          const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: surfaceBackground,
                          child: const Icon(Icons.person, color: textLight),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${review.user!.firstName!} ${review.user!.lastName!}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: starIndex < (review.rating ?? 0)
                                ? warning
                                : borderMedium,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (review.rating ?? 0).toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: warning,
                    ),
                  ),
                ),
              ],
            ),
            if (review.notes != null && review.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                review.notes!,
                style: const TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureNotAvailable() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: warning.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.lock_outline,
              color: warning,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Feature Not Available'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is not available for this business'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              color: textLight,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Data Found'.tr,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There is no content to display here'.tr,
            style: const TextStyle(
              fontSize: 14,
              color: textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(ServicesController value) {
    return GetBuilder<ServiceCartController>(
      builder: (cartController) {
        if (cartController.totalItemsInCart <= 0 ||
            cartController.servicesFrom != 'salon') {
          return const SizedBox.shrink();
        }

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
                  onTap: () => value.onCheckout(),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primary, primaryDark],
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${cartController.totalItemsInCart} ${'Items'.tr}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                value.currencySide == 'left'
                                    ? '${value.currencySymbol}${cartController.totalPrice.toStringAsFixed(2)}'
                                    : '${cartController.totalPrice.toStringAsFixed(2)}${value.currencySymbol}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Book Services'.tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
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
      },
    );
  }
}

// Helper function for gender text
String _getGenderText(int? genderCode) {
  switch (genderCode) {
    case 0:
      return 'Kids';
    case 1:
      return 'Male';
    case 2:
      return 'Female';
    case 3:
      return 'Family';
    default:
      return 'Unknown';
  }
}

// Service details dialog
void _showServiceDetailsDialog(BuildContext context, ServicesModel service,
    ServicesController servicesController) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: ThemeProvider.pink,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name ?? 'Service Details',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (service.descriptions != null &&
                        service.descriptions!.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.descriptions!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _buildDetailRow(
                        'Original Price',
                        servicesController.currencySide == 'left'
                            ? '${servicesController.currencySymbol}${service.price}'
                            : '${service.price}${servicesController.currencySymbol}'),
                    _buildDetailRow(
                        'Offer Price',
                        servicesController.currencySide == 'left'
                            ? '${servicesController.currencySymbol}${service.off}'
                            : '${service.off}${servicesController.currencySymbol}',
                        valueColor: const Color(0xFF10B981)),
                    _buildDetailRow('Discount', '${service.discount}%',
                        valueColor: const Color(0xFFEF4444)),
                    _buildDetailRow('Duration', '${service.duration} minutes'),
                    _buildDetailRow(
                        'Suitable For', _getGenderText(service.gender)),
                    if (service.extraField != null &&
                        service.extraField!.isNotEmpty)
                      _buildDetailRow('Additional Info', service.extraField!),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper method for detail rows
Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF2C3E50),
          ),
        ),
      ],
    ),
  );
}
