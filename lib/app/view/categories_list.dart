// /*
//   Authors : initappz (Rahul Jograna)
//   Website : https://initappz.com/
//   App Name : Ultimate Salon Full App Flutter V2
//   This App Template Source code is licensed as per the
//   terms found in the Website https://initappz.com/license
//   Copyright and Good Faith Purchasers © 2023-present initappz.
// */
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/categories_list_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class CategoriesListScreen extends StatefulWidget {
//   const CategoriesListScreen({Key? key}) : super(key: key);

//   @override
//   State<CategoriesListScreen> createState() => _CategoriesListScreenState();
// }

// class _CategoriesListScreenState extends State<CategoriesListScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CategoriesListController>(
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
//               value.selectedCateName,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: value.apiCalled == false
//               ? SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: SkeletonParagraph(
//                           style: SkeletonParagraphStyle(
//                             lines: 1,
//                             spacing: 6,
//                             lineStyle: SkeletonLineStyle(
//                               randomLength: true,
//                               height: 20,
//                               borderRadius: BorderRadius.circular(8),
//                               minLength: MediaQuery.of(context).size.width / 5,
//                             ),
//                           ),
//                         ),
//                       ),
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: List.generate(
//                               7,
//                               (index) => const Padding(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 10),
//                                     child: SkeletonAvatar(
//                                       style: SkeletonAvatarStyle(
//                                           shape: BoxShape.circle,
//                                           width: 60,
//                                           height: 60),
//                                     ),
//                                   )),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                         child: SkeletonParagraph(
//                           style: SkeletonParagraphStyle(
//                             lines: 1,
//                             spacing: 6,
//                             lineStyle: SkeletonLineStyle(
//                               randomLength: true,
//                               height: 20,
//                               borderRadius: BorderRadius.circular(8),
//                               minLength: MediaQuery.of(context).size.width / 5,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Column(
//                         children: List.generate(
//                             10,
//                             (index) => Container(
//                                   padding: const EdgeInsets.all(10),
//                                   margin: const EdgeInsets.symmetric(
//                                       vertical: 10, horizontal: 10),
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                     color: ThemeProvider.whiteColor,
//                                     boxShadow: const [
//                                       BoxShadow(
//                                           color: ThemeProvider.greyColor,
//                                           blurRadius: 5.0,
//                                           offset: Offset(0.7, 2.0)),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10),
//                                             child: SkeletonLine(
//                                               style: SkeletonLineStyle(
//                                                   height: 80,
//                                                   width: 80,
//                                                   borderRadius:
//                                                       BorderRadius.circular(5)),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Column(
//                                               children: [
//                                                 SkeletonParagraph(
//                                                   style: SkeletonParagraphStyle(
//                                                     lines: 1,
//                                                     spacing: 6,
//                                                     lineStyle:
//                                                         SkeletonLineStyle(
//                                                       randomLength: true,
//                                                       height: 20,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8),
//                                                       minLength:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               3,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SkeletonParagraph(
//                                                   style: SkeletonParagraphStyle(
//                                                     lines: 1,
//                                                     spacing: 6,
//                                                     lineStyle:
//                                                         SkeletonLineStyle(
//                                                       randomLength: true,
//                                                       height: 10,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8),
//                                                       minLength:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               7,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 SkeletonParagraph(
//                                                   style: SkeletonParagraphStyle(
//                                                     lines: 1,
//                                                     spacing: 6,
//                                                     lineStyle:
//                                                         SkeletonLineStyle(
//                                                       randomLength: true,
//                                                       height: 10,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               8),
//                                                       minLength:
//                                                           MediaQuery.of(context)
//                                                                   .size
//                                                                   .width /
//                                                               7,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                       )
//                     ],
//                   ),
//                 )
//               : value.haveData == true
//                   ? SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 10),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Specialist'.tr,
//                                     style: const TextStyle(
//                                         fontSize: 14, fontFamily: 'bold'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 5),
//                               child: SingleChildScrollView(
//                                 scrollDirection: Axis.horizontal,
//                                 child: Row(
//                                   children: [
//                                     for (var item in value.individualCateList)
//                                       GestureDetector(
//                                         onTap: () {
//                                           value.onSpecialist(item.uid as int);
//                                         },
//                                         child: Container(
//                                           margin: const EdgeInsets.symmetric(
//                                             horizontal: 10,
//                                           ),
//                                           child: Column(
//                                             children: [
//                                               ClipRRect(
//                                                 borderRadius:
//                                                     BorderRadius.circular(100),
//                                                 child: SizedBox.fromSize(
//                                                   size:
//                                                       const Size.fromRadius(30),
//                                                   child: FadeInImage(
//                                                     image: NetworkImage(
//                                                         '${Environments.imageURL}${item.userInfo!.cover}'),
//                                                     placeholder: const AssetImage(
//                                                         "assets/images/placeholder.jpeg"),
//                                                     imageErrorBuilder: (context,
//                                                         error, stackTrace) {
//                                                       return Image.asset(
//                                                           'assets/images/notfound.png',
//                                                           fit: BoxFit.cover);
//                                                     },
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Column(
//                                                 children: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 10),
//                                                     child: Text(
//                                                       '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
//                                                       style: const TextStyle(
//                                                           fontSize: 10,
//                                                           color: ThemeProvider
//                                                               .greyColor,
//                                                           fontFamily: 'bold'),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(vertical: 10),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     'Salon'.tr,
//                                     style: const TextStyle(
//                                         fontSize: 14, fontFamily: 'bold'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             for (var item in value.salonCateList)
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: ThemeProvider.whiteColor,
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         color: ThemeProvider.greyColor,
//                                         blurRadius: 5.0,
//                                         offset: Offset(0.7, 2.0)),
//                                   ],
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     value.onServices(item.uid as int);
//                                   },
//                                   child: Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             child: SizedBox.fromSize(
//                                               size: const Size.fromRadius(40),
//                                               child: FadeInImage(
//                                                 image: NetworkImage(
//                                                     '${Environments.imageURL}${item.cover}'),
//                                                 placeholder: const AssetImage(
//                                                     "assets/images/placeholder.jpeg"),
//                                                 imageErrorBuilder: (context,
//                                                     error, stackTrace) {
//                                                   return Image.asset(
//                                                       'assets/images/notfound.png',
//                                                       fit: BoxFit.cover);
//                                                 },
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 10),
//                                           Expanded(
//                                             child: Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   item.name.toString(),
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                   style: const TextStyle(
//                                                       fontFamily: 'bold',
//                                                       fontSize: 14),
//                                                 ),
//                                                 const SizedBox(height: 2),
//                                                 item.categories!.length <= 2
//                                                     ? Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: List.generate(
//                                                           item.categories!
//                                                               .length,
//                                                           (subIndex) => Text(
//                                                             item
//                                                                 .categories![
//                                                                     subIndex]
//                                                                 .name
//                                                                 .toString(),
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                           ),
//                                                         ),
//                                                       )
//                                                     : Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                             for (var cate
//                                                                 in item
//                                                                     .categories!
//                                                                     .take(2))
//                                                               Text(cate.name
//                                                                   .toString()),
//                                                             const Text(
//                                                                 'and more')
//                                                           ]),
//                                                 const SizedBox(height: 3),
//                                                 RichText(
//                                                   text: TextSpan(
//                                                     children: [
//                                                       WidgetSpan(
//                                                         child: Icon(
//                                                           Icons.star,
//                                                           size: 15,
//                                                           color: item.rating! >=
//                                                                   1
//                                                               ? ThemeProvider
//                                                                   .orangeColor
//                                                               : ThemeProvider
//                                                                   .greyColor,
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Icon(
//                                                           Icons.star,
//                                                           size: 15,
//                                                           color: item.rating! >=
//                                                                   2
//                                                               ? ThemeProvider
//                                                                   .orangeColor
//                                                               : ThemeProvider
//                                                                   .greyColor,
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Icon(
//                                                           Icons.star,
//                                                           size: 15,
//                                                           color: item.rating! >=
//                                                                   3
//                                                               ? ThemeProvider
//                                                                   .orangeColor
//                                                               : ThemeProvider
//                                                                   .greyColor,
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Icon(
//                                                           Icons.star,
//                                                           size: 15,
//                                                           color: item.rating! >=
//                                                                   4
//                                                               ? ThemeProvider
//                                                                   .orangeColor
//                                                               : ThemeProvider
//                                                                   .greyColor,
//                                                         ),
//                                                       ),
//                                                       WidgetSpan(
//                                                         child: Icon(
//                                                           Icons.star,
//                                                           size: 15,
//                                                           color: item.rating! >=
//                                                                   5
//                                                               ? ThemeProvider
//                                                                   .orangeColor
//                                                               : ThemeProvider
//                                                                   .greyColor,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     )
//                   : Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 20),
//                         SizedBox(
//                           height: 80,
//                           width: 80,
//                           child: Image.asset(
//                             "assets/images/no-data.png",
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Center(
//                           child: Text(
//                             'No Data Found Near You!'.tr,
//                             style: const TextStyle(fontFamily: 'bold'),
//                           ),
//                         ),
//                       ],
//                     ),
//         );
//       },
//     );
//   }
// }

/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/new_category_search_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/helper/router.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class CategoriesListScreen extends StatefulWidget {
//   const CategoriesListScreen({Key? key}) : super(key: key);

//   @override
//   State<CategoriesListScreen> createState() => _CategoriesListScreenState();
// }

// class _CategoriesListScreenState extends State<CategoriesListScreen>
//     with SingleTickerProviderStateMixin {
//   final CarouselController _controller = CarouselController();
//   late final TabController _tabController;
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<NewCatSearchController>(
//       builder: (value) {
//         return Scaffold(
//           body: NestedScrollView(
//             headerSliverBuilder:
//                 (BuildContext context, bool innerBoxIsScrolled) {
//               return <Widget>[
//                 SliverAppBar(
//                   toolbarHeight: 115,
//                   automaticallyImplyLeading: false,
//                   backgroundColor: ThemeProvider.appColor,
//                   title: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               value.onBack();
//                             },
//                             child: const Icon(
//                               Icons.arrow_back,
//                               color: ThemeProvider.whiteColor,
//                             ),
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 20.0),
//                                 child: Text(
//                                   value.selectedCateName,
//                                   style: const TextStyle(
//                                       fontSize: 20,
//                                       color: ThemeProvider.whiteColor,
//                                       fontFamily: 'bold'),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           InkWell(
//                             onTap: () {
//                               Get.toNamed(AppRouter.getFindLocationRoutes());
//                             },
//                             child: const Icon(
//                               Icons.location_on,
//                               color: Colors.white,
//                               size: 18,
//                             ),
//                             //  Text(
//                             //   'value.title',
//                             //   textAlign: TextAlign.center,
//                             //   style: const TextStyle(
//                             //       color: Colors.white,
//                             //       fontFamily: 'bold',
//                             //       fontSize: 14),
//                             // ),
//                           ),
//                           // const Icon(
//                           //   Icons.location_on,
//                           //   color: ThemeProvider.whiteColor,
//                           //   size: 15,
//                           // ),
//                           const SizedBox(width: 10),
//                           InkWell(
//                             onTap: () {
//                               Get.toNamed(AppRouter.getFindLocationRoutes());
//                             },
//                             child: Text(
//                               value.title.length > 30
//                                   ? value.title.substring(0, 30)
//                                   : value.title.toString(),
//                               style: const TextStyle(
//                                   fontSize: 13,
//                                   color: ThemeProvider.whiteColor),
//                             ),
//                           ),
//                           // const SizedBox(width: 5),
//                           // const Icon(
//                           //   Icons.near_me_outlined,
//                           //   color: ThemeProvider.whiteColor,
//                           //   size: 15,
//                           // ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 5),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10.0, vertical: 10.0),
//                           child: SizedBox(
//                             height: 40,
//                             child: TextField(
//                               controller: value.searchController,
//                               onChanged: value.searchProducts,
//                               style: const TextStyle(
//                                   color: ThemeProvider.blackColor),
//                               decoration: InputDecoration(
//                                 hintText: 'Search For Services.....'.tr,
//                                 prefixIcon: const Icon(Icons.search),
//                                 hintStyle: const TextStyle(
//                                     color: ThemeProvider.greyColor),
//                                 border: const OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                     color: ThemeProvider.whiteColor,
//                                   ),
//                                 ),
//                                 enabledBorder: const OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                     color: ThemeProvider.transparent,
//                                   ),
//                                 ),
//                                 focusedBorder: const OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10)),
//                                   borderSide: BorderSide(
//                                     color: ThemeProvider.transparent,
//                                   ),
//                                 ),
//                                 filled: true,
//                                 fillColor: ThemeProvider.whiteColor,
//                                 contentPadding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 0),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   pinned: true,
//                   elevation: 10,
//                   floating: true,
//                   forceElevated: innerBoxIsScrolled,
//                   bottom: TabBar(
//                     labelStyle: const TextStyle(fontFamily: 'bold'),
//                     tabs: const <Tab>[
//                       Tab(
//                         text: 'Shops',
//                       ),
//                       Tab(text: 'Freelancers'),
//                     ],
//                     controller: _tabController,
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(controller: _tabController, children: <Widget>[
//               ListView(children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 15),
//                         child: adBanner(value),
//                       ),
//                       // value.salonList.isNotEmpty
//                       //     ? _buildTitle('   Showing Partners'.tr)
//                       //     : const SizedBox(),
//                       Column(
//                         children: [
//                           Container(
//                               margin: const EdgeInsets.symmetric(vertical: 0),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: ThemeProvider.backgroundColor),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: List.generate(
//                                   value.salonList.length,
//                                   (index) {
//                                     List<Widget> columnChildren = [];

//                                     // Add ad banner after every 5th element
//                                     if ((index + 1) % 4 == 0) {
//                                       columnChildren.add(adBanner(value));
//                                     }

//                                     // Add salon item
//                                     columnChildren.add(
//                                       Container(
//                                         width: double.infinity,
//                                         padding: const EdgeInsets.all(10),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                   child: SizedBox(
//                                                     height: 200,
//                                                     width: 120,
//                                                     child: FittedBox(
//                                                       fit: BoxFit.cover,
//                                                       child: FadeInImage(
//                                                         image: NetworkImage(
//                                                             '${Environments.imageURL}${value.salonList[index].cover.toString()}'),
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
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 10,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     value.onServices(value
//                                                         .salonList[index]
//                                                         .uid as int);
//                                                   },
//                                                   child: Container(
//                                                     width: 120,
//                                                     height: 40,
//                                                     decoration: BoxDecoration(
//                                                       color: ThemeProvider
//                                                           .appColor,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                     ),
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 5),
//                                                     child: Center(
//                                                       child: Text(
//                                                         'Book'.tr,
//                                                         style: const TextStyle(
//                                                             fontFamily: 'bold',
//                                                             color: ThemeProvider
//                                                                 .whiteColor),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Expanded(
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const Text(
//                                                       'Hydra facial',
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: TextStyle(
//                                                           fontFamily: 'bold',
//                                                           fontSize: 17),
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         SizedBox(
//                                                           width: 120,
//                                                           child: Text(
//                                                             value
//                                                                 .salonList[
//                                                                     index]
//                                                                 .name!,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style:
//                                                                 const TextStyle(
//                                                                     fontFamily:
//                                                                         'bold',
//                                                                     fontSize:
//                                                                         12),
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             const Icon(
//                                                               Icons.location_on,
//                                                               size: 15,
//                                                               color:
//                                                                   ThemeProvider
//                                                                       .greyColor,
//                                                             ),
//                                                             Text(
//                                                               '${value.salonList[index].distance}KM',
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               textAlign:
//                                                                   TextAlign.end,
//                                                               style: const TextStyle(
//                                                                   color: ThemeProvider
//                                                                       .greyColor,
//                                                                   fontSize: 12),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         SizedBox(
//                                                           width: 180,
//                                                           child: Text(
//                                                             value
//                                                                 .salonList[
//                                                                     index]
//                                                                 .address!,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.star,
//                                                           color: ThemeProvider
//                                                               .orangeColor,
//                                                           size: 15,
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             value
//                                                                 .salonList[
//                                                                     index]
//                                                                 .rating
//                                                                 .toString(),
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: const Color
//                                                                   .fromARGB(255,
//                                                                   244, 12, 117),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           2),
//                                                             ),
//                                                             child:
//                                                                 const Padding(
//                                                               padding:
//                                                                   EdgeInsets
//                                                                       .all(5.0),
//                                                               child: Text(
//                                                                 '7.3',
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .white),
//                                                               ),
//                                                             )),
//                                                         const Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             'Good',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                         const Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             '155 Reviews',
//                                                             style: TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment.end,
//                                                       children: [
//                                                         Text(
//                                                           '\$220',
//                                                           style: TextStyle(
//                                                               fontFamily:
//                                                                   'bold',
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       244,
//                                                                       12,
//                                                                       117),
//                                                               fontSize: 17),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Text(
//                                                           '10% off',
//                                                           style: TextStyle(
//                                                               fontFamily:
//                                                                   'bold',
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       244,
//                                                                       12,
//                                                                       117),
//                                                               fontSize: 17),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     const Align(
//                                                       alignment:
//                                                           Alignment.topRight,
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .end,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .end,
//                                                         children: [
//                                                           Text(
//                                                             '\$200.00',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'bold',
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         68,
//                                                                         68,
//                                                                         68),
//                                                                 fontSize: 22),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 10,
//                                                           ),
//                                                           Text(
//                                                             '+ 50 taxes and charges',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 11),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 18,
//                                                           ),
//                                                           Text(
//                                                             'Free cancellation\nNo payment needed\nPay at shop',
//                                                             textAlign:
//                                                                 TextAlign.right,
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'bold',
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         21,
//                                                                         192,
//                                                                         8),
//                                                                 fontSize: 13),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );

//                                     return Column(
//                                       children: columnChildren,
//                                     );
//                                   },
//                                 ),
//                               ))
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ]),
//               ListView(children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(top: 15),
//                         child: adBanner(value),
//                       ),
//                       // value.salonList.isNotEmpty
//                       //     ? _buildTitle('   Showing Partners'.tr)
//                       //     : const SizedBox(),
//                       Column(
//                         children: [
//                           Container(
//                               margin: const EdgeInsets.symmetric(vertical: 0),
//                               decoration: const BoxDecoration(
//                                 border: Border(
//                                   bottom: BorderSide(
//                                       color: ThemeProvider.backgroundColor),
//                                 ),
//                               ),
//                               child: Column(
//                                 children: List.generate(
//                                   value.individualList.length,
//                                   (index) {
//                                     List<Widget> columnChildren = [];

//                                     // Add ad banner after every 5th element
//                                     if ((index + 1) % 4 == 0) {
//                                       columnChildren.add(adBanner(value));
//                                     }

//                                     // Add salon item
//                                     columnChildren.add(
//                                       Container(
//                                         width: double.infinity,
//                                         padding: const EdgeInsets.all(10),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(5),
//                                                   child: SizedBox(
//                                                     height: 200,
//                                                     width: 120,
//                                                     child: FittedBox(
//                                                       fit: BoxFit.cover,
//                                                       child: FadeInImage(
//                                                         image: NetworkImage(
//                                                             '${Environments.imageURL}${value.individualList[index].cover.toString()}'),
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
//                                                 ),
//                                                 const SizedBox(
//                                                   height: 10,
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     value.onServices(value
//                                                         .individualList[index]
//                                                         .uid as int);
//                                                   },
//                                                   child: Container(
//                                                     width: 120,
//                                                     height: 40,
//                                                     decoration: BoxDecoration(
//                                                       color: ThemeProvider
//                                                           .appColor,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               100),
//                                                     ),
//                                                     padding: const EdgeInsets
//                                                         .symmetric(
//                                                         horizontal: 10,
//                                                         vertical: 5),
//                                                     child: Center(
//                                                       child: Text(
//                                                         'Book'.tr,
//                                                         style: const TextStyle(
//                                                             fontFamily: 'bold',
//                                                             color: ThemeProvider
//                                                                 .whiteColor),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             Expanded(
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 10),
//                                                 child: Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       value
//                                                           .individualList[index]
//                                                           .serviceName!,
//                                                       overflow:
//                                                           TextOverflow.ellipsis,
//                                                       style: const TextStyle(
//                                                           fontFamily: 'bold',
//                                                           fontSize: 17),
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         SizedBox(
//                                                           width: 120,
//                                                           child: Text(
//                                                             value
//                                                                 .individualList[
//                                                                     index]
//                                                                 .name!,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style:
//                                                                 const TextStyle(
//                                                                     fontFamily:
//                                                                         'bold',
//                                                                     fontSize:
//                                                                         12),
//                                                           ),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             const Icon(
//                                                               Icons.location_on,
//                                                               size: 15,
//                                                               color:
//                                                                   ThemeProvider
//                                                                       .greyColor,
//                                                             ),
//                                                             Text(
//                                                               '${value.individualList[index].distance} KM',
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               textAlign:
//                                                                   TextAlign.end,
//                                                               style: const TextStyle(
//                                                                   color: ThemeProvider
//                                                                       .greyColor,
//                                                                   fontSize: 12),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         SizedBox(
//                                                           width: 180,
//                                                           child: Text(
//                                                             value
//                                                                 .individualList[
//                                                                     index]
//                                                                 .address!,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         const Icon(
//                                                           Icons.star,
//                                                           color: ThemeProvider
//                                                               .orangeColor,
//                                                           size: 15,
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             value
//                                                                 .salonList[
//                                                                     index]
//                                                                 .rating
//                                                                 .toString(),
//                                                             style: const TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 2,
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         Container(
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: const Color
//                                                                   .fromARGB(255,
//                                                                   244, 12, 117),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           2),
//                                                             ),
//                                                             child:
//                                                                 const Padding(
//                                                               padding:
//                                                                   EdgeInsets
//                                                                       .all(5.0),
//                                                               child: Text(
//                                                                 '7.3',
//                                                                 style: TextStyle(
//                                                                     color: Colors
//                                                                         .white),
//                                                               ),
//                                                             )),
//                                                         const Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             'Good',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                         const Padding(
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                                   horizontal:
//                                                                       5),
//                                                           child: Text(
//                                                             '155 Reviews',
//                                                             style: TextStyle(
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w600,
//                                                                 fontSize: 12),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment.end,
//                                                       children: [
//                                                         Text(
//                                                           '\$220',
//                                                           style: TextStyle(
//                                                               fontFamily:
//                                                                   'bold',
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       244,
//                                                                       12,
//                                                                       117),
//                                                               fontSize: 17),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Text(
//                                                           '10% off',
//                                                           style: TextStyle(
//                                                               fontFamily:
//                                                                   'bold',
//                                                               color: Color
//                                                                   .fromARGB(
//                                                                       255,
//                                                                       244,
//                                                                       12,
//                                                                       117),
//                                                               fontSize: 17),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     const Align(
//                                                       alignment:
//                                                           Alignment.topRight,
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .end,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .end,
//                                                         children: [
//                                                           Text(
//                                                             '\$200.00',
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'bold',
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         68,
//                                                                         68,
//                                                                         68),
//                                                                 fontSize: 22),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 10,
//                                                           ),
//                                                           Text(
//                                                             '+ 50 taxes and charges',
//                                                             style: TextStyle(
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w700,
//                                                                 color: ThemeProvider
//                                                                     .greyColor,
//                                                                 fontSize: 11),
//                                                           ),
//                                                           SizedBox(
//                                                             height: 18,
//                                                           ),
//                                                           Text(
//                                                             'Free cancellation\nNo payment needed\nPay in person',
//                                                             textAlign:
//                                                                 TextAlign.right,
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'bold',
//                                                                 color: Color
//                                                                     .fromARGB(
//                                                                         255,
//                                                                         21,
//                                                                         192,
//                                                                         8),
//                                                                 fontSize: 13),
//                                                           )
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );

//                                     return Column(
//                                       children: columnChildren,
//                                     );
//                                   },
//                                 ),
//                               ))
//                         ],
//                       )
//                     ],
//                   ),
//                 )
//               ]),
//             ]),
//             // StatisticsPage(),
//             //HistoryPage(),
//           ),
//         );
//       },
//     );
//   }

//   CarouselSlider adBanner(NewCatSearchController value) {
//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 160,
//         viewportFraction: 0.80,
//         initialPage: 0,
//         enableInfiniteScroll: true,
//         reverse: false,
//         autoPlay: true,
//         autoPlayInterval: const Duration(seconds: 3),
//         autoPlayAnimationDuration: const Duration(milliseconds: 800),
//         autoPlayCurve: Curves.fastOutSlowIn,
//         enlargeCenterPage: false,
//         scrollDirection: Axis.horizontal,
//       ),
//       carouselController: _controller,
//       items: List.generate(
//         value.bannerList.length,
//         (index) => GestureDetector(
//           onTap: () {
//             value.onBanner(value.bannerList[index].value.toString(),
//                 value.bannerList[index].type.toString());
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: SizedBox(
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Stack(
//                     clipBehavior: Clip.none,
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       SizedBox(
//                         height: 170,
//                         width: double.infinity,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: FadeInImage(
//                             image: NetworkImage(
//                                 '${Environments.imageURL}${value.bannerList[index].cover.toString()}'),
//                             placeholder: const AssetImage(
//                                 "assets/images/placeholder.jpeg"),
//                             imageErrorBuilder: (context, error, stackTrace) {
//                               return Image.asset('assets/images/notfound.png',
//                                   fit: BoxFit.cover);
//                             },
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         height: 50,
//                         width: double.infinity,
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           ),
//                           color: ThemeProvider.blackColor.withOpacity(0.5),
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               value.bannerList[index].title.toString(),
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                   color: ThemeProvider.whiteColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTitle(txt) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Text(
//             '$txt',
//             style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/category_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';

class CategoriesListScreen extends StatefulWidget {
  const CategoriesListScreen({Key? key}) : super(key: key);

  @override
  @override
  State<CategoriesListScreen> createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen>
    with SingleTickerProviderStateMixin {
  final CarouselController _controller = CarouselController();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategorySearchController>(
      builder: (value) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  toolbarHeight: 100,
                  automaticallyImplyLeading: false,
                  backgroundColor: ThemeProvider.appColor,
                  title: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              value.onBack();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: ThemeProvider.whiteColor,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, right: 10.0),
                                child:
                                    // Text(
                                    //   'Search'.tr,
                                    //   style: const TextStyle(
                                    //       fontSize: 17,
                                    //       color: ThemeProvider.whiteColor,
                                    //       fontFamily: 'bold'),
                                    // ),
                                    Image.asset(
                                  'assets/images/logo_horizontal.png',
                                  height: 40,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Get.toNamed(AppRouter.getFindLocationRoutes());
                      //       },
                      //       child: const Icon(
                      //         Icons.location_on,
                      //         color: Colors.white,
                      //         size: 16,
                      //       ),
                      //       //  Text(
                      //       //   'value.title',
                      //       //   textAlign: TextAlign.center,
                      //       //   style: const TextStyle(
                      //       //       color: Colors.white,
                      //       //       fontFamily: 'bold',
                      //       //       fontSize: 14),
                      //       // ),
                      //     ),
                      //     // const Icon(
                      //     //   Icons.location_on,
                      //     //   color: ThemeProvider.whiteColor,
                      //     //   size: 15,
                      //     // ),
                      //     const SizedBox(width: 10),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.toNamed(AppRouter.getFindLocationRoutes());
                      //       },
                      //       child: Text(
                      //         value.title.length > 30
                      //             ? value.title.substring(0, 30)
                      //             : value.title.toString(),
                      //         style: const TextStyle(
                      //             fontSize: 10,
                      //             color: ThemeProvider.whiteColor),
                      //       ),
                      //     ),
                      //     // const SizedBox(width: 5),
                      //     // const Icon(
                      //     //   Icons.near_me_outlined,
                      //     //   color: ThemeProvider.whiteColor,
                      //     //   size: 15,
                      //     // ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 3,
                      // ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                              child: SizedBox(
                                height: 38,
                                child: Stack(
                                  children: [
                                    // TextField(
                                    //   controller: value.searchController,
                                    //   onChanged: value.searchProducts,
                                    //   style: const TextStyle(
                                    //       color: ThemeProvider.blackColor),
                                    //   decoration: InputDecoration(
                                    //     hintText: 'Search For Services.....'.tr,
                                    //     prefixIcon: const Icon(Icons.search),
                                    //     hintStyle: const TextStyle(
                                    //         color: ThemeProvider.greyColor),
                                    //     border: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(10)),
                                    //       borderSide: BorderSide(
                                    //         color: ThemeProvider.whiteColor,
                                    //       ),
                                    //     ),
                                    //     enabledBorder: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(10)),
                                    //       borderSide: BorderSide(
                                    //         color: ThemeProvider.transparent,
                                    //       ),
                                    //     ),
                                    //     focusedBorder: const OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(10)),
                                    //       borderSide: BorderSide(
                                    //         color: ThemeProvider.transparent,
                                    //       ),
                                    //     ),
                                    //     filled: true,
                                    //     fillColor: ThemeProvider.whiteColor,
                                    //     contentPadding:
                                    //         const EdgeInsets.symmetric(
                                    //             horizontal: 10, vertical: 0),
                                    //   ),
                                    // ),
                                    Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue
                                          textEditingValue) async {
                                        if (textEditingValue.text == '') {
                                          return const [];
                                        }

                                        // Call your API here and return the list of options
                                        List<String> options = await value
                                            .fetchAutoCompleteServices(
                                                textEditingValue.text);

                                        return options;
                                      },
                                      onSelected: (String selection) {
                                        value.searchProducts(
                                            context, selection);
                                        FocusScope.of(context).unfocus();
                                      },
                                      fieldViewBuilder: (BuildContext context,
                                          TextEditingController
                                              textEditingController,
                                          FocusNode focusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextField(
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                          style: const TextStyle(
                                              color: ThemeProvider.blackColor),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Search For Services...'.tr,
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            hintStyle: const TextStyle(
                                                fontSize: 13,
                                                color: ThemeProvider.greyColor),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color:
                                                      ThemeProvider.whiteColor),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: ThemeProvider
                                                      .transparent),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              borderSide: BorderSide(
                                                  color: ThemeProvider
                                                      .transparent),
                                            ),
                                            filled: true,
                                            fillColor: ThemeProvider.whiteColor,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 0),
                                          ),
                                        );
                                      },
                                    ),

                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 32,
                                            child: IconButton(
                                              color: const Color.fromARGB(
                                                  255, 138, 138, 138),
                                              onPressed: () {
                                                value.genderDialog(context);
                                              },
                                              icon: const Icon(
                                                Icons.person,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 31,
                                            child: IconButton(
                                              color: const Color.fromARGB(
                                                  255, 138, 138, 138),
                                              onPressed: () {
                                                Get.toNamed(AppRouter
                                                    .getFindLocationRoutes());
                                              },
                                              icon: const Icon(
                                                Icons.location_on,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            child: IconButton(
                                              color: const Color.fromARGB(
                                                  255, 138, 138, 138),
                                              onPressed: () {
                                                value.onFilter();
                                              },
                                              icon: const Icon(
                                                Icons.manage_search,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 0,
                          ),
                          // SizedBox(
                          //   height: 25,
                          //   child: Center(
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Checkbox(
                          //               side: const BorderSide(
                          //                   width: 2,
                          //                   color: Color.fromARGB(
                          //                       255, 134, 133, 131)),
                          //               value: value.isMale,
                          //               onChanged: (bool? boolValue) {
                          //                 value.isMaleSelected(boolValue!);
                          //               },
                          //             ),
                          //             const Text(
                          //               "Male",
                          //               style: TextStyle(fontSize: 13),
                          //             ),
                          //             const Icon(
                          //               Icons.man_outlined,
                          //               size: 20,
                          //             )
                          //           ],
                          //         ),
                          //         Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Checkbox(
                          //               side: const BorderSide(
                          //                   width: 2,
                          //                   color: Color.fromARGB(
                          //                       255, 134, 133, 131)),
                          //               value: value.isFemale,
                          //               onChanged: (bool? boolValue) {
                          //                 value.isFemaleSelected(boolValue!);
                          //               },
                          //             ),
                          //             const Text(
                          //               "Female",
                          //               style: TextStyle(fontSize: 13),
                          //             ),
                          //             const Icon(
                          //               Icons.woman_outlined,
                          //               size: 20,
                          //             )
                          //           ],
                          //         ),
                          //         Row(
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: [
                          //             Checkbox(
                          //               side: const BorderSide(
                          //                   width: 2,
                          //                   color: Color.fromARGB(
                          //                       255, 134, 133, 131)),
                          //               value: value.isKid,
                          //               onChanged: (bool? boolValue) {
                          //                 value.isKidSelected(boolValue!);
                          //               },
                          //             ),
                          //             const Text(
                          //               "Kid  ",
                          //               style: TextStyle(fontSize: 13),
                          //             ),
                          //             const Icon(
                          //               Icons.child_care_outlined,
                          //               size: 20,
                          //             )
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                  pinned: true,
                  elevation: 10,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  bottom: TabBar(
                    labelStyle:
                        const TextStyle(fontFamily: 'bold', fontSize: 13),
                    tabs: const <Tab>[
                      Tab(
                        text: 'Shops',
                      ),
                      Tab(text: 'Freelancers'),
                    ],
                    controller: _tabController,
                  ),
                ),
              ];
            },
            body: TabBarView(controller: _tabController, children: <Widget>[
              value.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(children: <Widget>[
                      Column(
                        children: [
                          adBanner(value),
                          value.isEmptySearchSalon
                              ? const Text(
                                  'Result Not Found',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: ThemeProvider
                                                      .backgroundColor),
                                            ),
                                          ),
                                          child: Column(
                                            children: List.generate(
                                              value.salonList.length,
                                              (index) {
                                                List<Widget> columnChildren =
                                                    [];

                                                // Add ad banner after every 5th element
                                                if ((index + 1) % 4 == 0) {
                                                  columnChildren
                                                      .add(adBanner(value));
                                                }

                                                // Add salon item
                                                columnChildren.add(
                                                  GestureDetector(
                                                    onTap: () {
                                                      value.onServices(value
                                                          .salonList[index]
                                                          .uid as int);
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3.0),
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 190,
                                                                    width: 120,
                                                                    child:
                                                                        FittedBox(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      child:
                                                                          FadeInImage(
                                                                        image: NetworkImage(
                                                                            '${Environments.imageURL}${value.salonList[index].cover.toString()}'),
                                                                        placeholder:
                                                                            const AssetImage("assets/images/placeholder.jpeg"),
                                                                        imageErrorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Image.asset(
                                                                              'assets/images/notfound.png',
                                                                              fit: BoxFit.cover);
                                                                        },
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                // const SizedBox(
                                                                //   height: 10,
                                                                // ),
                                                                // GestureDetector(
                                                                //   onTap: () {
                                                                //     value.onServices(value
                                                                //         .salonList[
                                                                //             index]
                                                                //         .uid as int);
                                                                //   },
                                                                //   child:
                                                                //       Container(
                                                                //     width: 120,
                                                                //     height: 40,
                                                                //     decoration:
                                                                //         BoxDecoration(
                                                                //       color: ThemeProvider
                                                                //           .appColor,
                                                                //       borderRadius:
                                                                //           BorderRadius.circular(
                                                                //               100),
                                                                //     ),
                                                                //     padding: const EdgeInsets
                                                                //         .symmetric(
                                                                //         horizontal:
                                                                //             10,
                                                                //         vertical:
                                                                //             5),
                                                                //     child: Center(
                                                                //       child: Text(
                                                                //         'Book'.tr,
                                                                //         style: const TextStyle(
                                                                //             fontFamily:
                                                                //                 'bold',
                                                                //             color:
                                                                //                 ThemeProvider.whiteColor),
                                                                //       ),
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      value
                                                                          .salonList[
                                                                              index]
                                                                          .serviceName!,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'bold',
                                                                          fontSize:
                                                                              16),
                                                                    ),
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
                                                                            value.salonList[index].name!,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(fontFamily: 'bold', fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.location_on,
                                                                              size: 15,
                                                                              color: ThemeProvider.greyColor,
                                                                            ),
                                                                            Text(
                                                                              '${value.salonList[index].distance.toString().substring(0, 3)} KM',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              textAlign: TextAlign.end,
                                                                              style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 3,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              180,
                                                                          child:
                                                                              Text(
                                                                            value.salonList[index].address!,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          ' ${value.salonList[index].duration} min  ',
                                                                          style: const TextStyle(
                                                                              fontWeight: FontWeight.w700,
                                                                              color: ThemeProvider.greyColor,
                                                                              fontSize: 11),
                                                                        ),
                                                                        const Icon(
                                                                          Icons
                                                                              .timer,
                                                                          color:
                                                                              ThemeProvider.greyColor,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          _getGenderText(value
                                                                              .salonList[index]
                                                                              .gender),
                                                                          style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: ThemeProvider.greyColor),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                5),
                                                                        const Icon(
                                                                            Icons
                                                                                .person,
                                                                            size:
                                                                                14,
                                                                            color:
                                                                                ThemeProvider.greyColor),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .star,
                                                                          color:
                                                                              ThemeProvider.orangeColor,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 5),
                                                                          child:
                                                                              Text(
                                                                            value.salonList[index].rating.toString(),
                                                                            style:
                                                                                const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: 5),
                                                                          child:
                                                                              Text(
                                                                            '${value.salonList[index].reviewCount} Reviews',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: TextStyle(
                                                                                color: ThemeProvider.greyColor,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 4,
                                                                    ),
                                                                    // Row(
                                                                    //   children: [
                                                                    //     Container(
                                                                    //         decoration:
                                                                    //             BoxDecoration(
                                                                    //           color: const Color.fromARGB(
                                                                    //               255,
                                                                    //               244,
                                                                    //               12,
                                                                    //               117),
                                                                    //           borderRadius:
                                                                    //               BorderRadius.circular(2),
                                                                    //         ),
                                                                    //         child:
                                                                    //             Padding(
                                                                    //           padding:
                                                                    //               EdgeInsets.all(5.0),
                                                                    //           child:
                                                                    //               Text(
                                                                    //             '${value.salonList[index].totalRating}',
                                                                    //             style: const TextStyle(color: Colors.white),
                                                                    //           ),
                                                                    //         )),
                                                                    //     const Padding(
                                                                    //       padding:
                                                                    //           EdgeInsets.symmetric(horizontal: 5),
                                                                    //       child:
                                                                    //           Text(
                                                                    //         '155 Reviews',
                                                                    //         style: TextStyle(
                                                                    //             color: ThemeProvider.greyColor,
                                                                    //             fontWeight: FontWeight.w600,
                                                                    //             fontSize: 12),
                                                                    //       ),
                                                                    //     ),
                                                                    //   ],
                                                                    // ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          '₹ ${(value.salonList[index].discount! + value.salonList[index].price!).toStringAsFixed(2)}',
                                                                          style: const TextStyle(
                                                                              decoration: TextDecoration.lineThrough, // Strikethrough effect

                                                                              fontFamily: 'bold',
                                                                              color: Color.fromARGB(255, 244, 12, 117),
                                                                              fontSize: 14),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          // '10% off',
                                                                          '${value.salonList[index].discount} % off',

                                                                          style: const TextStyle(
                                                                              fontFamily: 'bold',
                                                                              color: Color.fromARGB(255, 244, 12, 117),
                                                                              fontSize: 14),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            '₹ ${value.salonList[index].price}',
                                                                            style: const TextStyle(
                                                                                fontFamily: 'bold',
                                                                                color: Color.fromARGB(255, 68, 68, 68),
                                                                                fontSize: 22),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          const Text(
                                                                            'Free cancellation\nNo payment needed, Pay at shop',
                                                                            textAlign:
                                                                                TextAlign.right,
                                                                            style: TextStyle(
                                                                                fontFamily: 'bold',
                                                                                color: Color.fromARGB(255, 21, 192, 8),
                                                                                fontSize: 10),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );

                                                return Column(
                                                  children: columnChildren,
                                                );
                                              },
                                            ),
                                          ))
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ]),
              ListView(children: <Widget>[
                Column(
                  children: [
                    adBanner(value),
                    value.isEmptySearchFreelancer
                        ? const Text(
                            'Result Not Found',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color:
                                                ThemeProvider.backgroundColor),
                                      ),
                                    ),
                                    child: Column(
                                      children: List.generate(
                                        value.individualList.length,
                                        (index) {
                                          List<Widget> columnChildren = [];

                                          // Add ad banner after every 5th element
                                          if ((index + 1) % 4 == 0) {
                                            columnChildren.add(adBanner(value));
                                          }

                                          // Add salon item
                                          columnChildren.add(
                                            GestureDetector(
                                              onTap: () {
                                                value.onSpecialist(value
                                                    .individualList[index]
                                                    .uid as int);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3.0),
                                                child: Card(
                                                  elevation: 8,
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          3),
                                                              child: SizedBox(
                                                                height: 190,
                                                                width: 120,
                                                                child:
                                                                    FittedBox(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  child:
                                                                      FadeInImage(
                                                                    image: NetworkImage(
                                                                        '${Environments.imageURL}${value.individualList[index].cover.toString()}'),
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
                                                            // const SizedBox(
                                                            //   height: 10,
                                                            // ),
                                                            // GestureDetector(
                                                            //   onTap: () {
                                                            //     value.onSpecialist(value
                                                            //         .individualList[
                                                            //             index]
                                                            //         .uid as int);
                                                            //   },
                                                            //   child: Container(
                                                            //     width: 120,
                                                            //     height: 40,
                                                            //     decoration:
                                                            //         BoxDecoration(
                                                            //       color: ThemeProvider
                                                            //           .appColor,
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .circular(
                                                            //                   100),
                                                            //     ),
                                                            //     padding: const EdgeInsets
                                                            //         .symmetric(
                                                            //         horizontal:
                                                            //             10,
                                                            //         vertical:
                                                            //             5),
                                                            //     child: Center(
                                                            //       child: Text(
                                                            //         'Add to cart'
                                                            //             .tr,
                                                            //         style: const TextStyle(
                                                            //             fontFamily:
                                                            //                 'bold',
                                                            //             color: ThemeProvider
                                                            //                 .whiteColor),
                                                            //       ),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  value
                                                                      .individualList[
                                                                          index]
                                                                      .serviceName!,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'bold',
                                                                      fontSize:
                                                                          16),
                                                                ),
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
                                                                        value
                                                                            .individualList[index]
                                                                            .name!,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'bold',
                                                                            fontSize:
                                                                                12),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              ThemeProvider.greyColor,
                                                                        ),
                                                                        Text(
                                                                          '${value.individualList[index].distance.toString().substring(0, 3)} KM',
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          textAlign:
                                                                              TextAlign.end,
                                                                          style: const TextStyle(
                                                                              color: ThemeProvider.greyColor,
                                                                              fontSize: 12),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 3,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width:
                                                                          180,
                                                                      child:
                                                                          Text(
                                                                        value
                                                                            .individualList[index]
                                                                            .address!,
                                                                        // 'Ground Floor, 2-A, Ram Square',
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            color:
                                                                                ThemeProvider.greyColor,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      ' ${value.individualList[index].duration} min  ',
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          color: ThemeProvider
                                                                              .greyColor,
                                                                          fontSize:
                                                                              11),
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .timer,
                                                                      color: ThemeProvider
                                                                          .greyColor,
                                                                      size: 20,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 5,
                                                                    ),
                                                                    Text(
                                                                      _getGenderText(value
                                                                          .individualList[
                                                                              index]
                                                                          .gender),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              ThemeProvider.greyColor),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
                                                                    const Icon(
                                                                        Icons
                                                                            .person,
                                                                        size:
                                                                            14,
                                                                        color: ThemeProvider
                                                                            .greyColor),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: ThemeProvider
                                                                          .orangeColor,
                                                                      size: 15,
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        value
                                                                            .individualList[index]
                                                                            .rating
                                                                            .toString(),
                                                                        // '4.5',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                ThemeProvider.greyColor,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      child:
                                                                          Text(
                                                                        '${value.individualList[index].reviewCount} Reviews',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                ThemeProvider.greyColor,
                                                                            fontWeight: FontWeight.w600,
                                                                            fontSize: 12),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 4,
                                                                ),
                                                                // Row(
                                                                //   children: [
                                                                //     Container(
                                                                //         decoration:
                                                                //             BoxDecoration(
                                                                //           color: const Color
                                                                //               .fromARGB(
                                                                //               255,
                                                                //               244,
                                                                //               12,
                                                                //               117),
                                                                //           borderRadius:
                                                                //               BorderRadius.circular(2),
                                                                //         ),
                                                                //         child:
                                                                //             const Padding(
                                                                //           padding:
                                                                //               EdgeInsets.all(5.0),
                                                                //           child:
                                                                //               Text(
                                                                //             '7.3',
                                                                //             style:
                                                                //                 TextStyle(color: Colors.white),
                                                                //           ),
                                                                //         )),
                                                                //     const Padding(
                                                                //       padding: EdgeInsets.symmetric(
                                                                //           horizontal:
                                                                //               5),
                                                                //       child:
                                                                //           Text(
                                                                //         'Good',
                                                                //         style: TextStyle(
                                                                //             fontWeight:
                                                                //                 FontWeight.w600,
                                                                //             color: ThemeProvider.greyColor,
                                                                //             fontSize: 12),
                                                                //       ),
                                                                //     ),
                                                                //     const Padding(
                                                                //       padding: EdgeInsets.symmetric(
                                                                //           horizontal:
                                                                //               5),
                                                                //       child:
                                                                //           Text(
                                                                //         '155 Reviews',
                                                                //         style: TextStyle(
                                                                //             color:
                                                                //                 ThemeProvider.greyColor,
                                                                //             fontWeight: FontWeight.w600,
                                                                //             fontSize: 12),
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      '₹ ${(value.individualList[index].discount! + value.individualList[index].price!).toStringAsFixed(2)}',
                                                                      style: const TextStyle(
                                                                          decoration: TextDecoration.lineThrough, // Strikethrough effect

                                                                          fontFamily: 'bold',
                                                                          color: Color.fromARGB(255, 244, 12, 117),
                                                                          fontSize: 14),
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text(
                                                                      // '10% off',
                                                                      '${value.individualList[index].discount} % off',

                                                                      style: const TextStyle(
                                                                          fontFamily:
                                                                              'bold',
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              244,
                                                                              12,
                                                                              117),
                                                                          fontSize:
                                                                              14),
                                                                    )
                                                                  ],
                                                                ),
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '₹ ${value.individualList[index].price}',
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'bold',
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                68,
                                                                                68,
                                                                                68),
                                                                            fontSize:
                                                                                22),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      const Text(
                                                                        'Free cancellation\nNo payment needed, Pay at shop',
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'bold',
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                21,
                                                                                192,
                                                                                8),
                                                                            fontSize:
                                                                                10),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );

                                          return Column(
                                            children: columnChildren,
                                          );
                                        },
                                      ),
                                    ))
                              ],
                            ),
                          )
                  ],
                )
              ]),
            ]),
            // StatisticsPage(),
            //HistoryPage(),
          ),
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

  CarouselSlider adBanner(CategorySearchController value) {
    value.getBannerData;
    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        viewportFraction: 1,
        initialPage: 0,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 300),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
      carouselController: _controller,
      items: List.generate(
        value.bannerList.length,
        (index) => GestureDetector(
          onTap: () {
            value.onBanner(value.bannerList[index].value.toString(),
                value.bannerList[index].type.toString());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: FadeInImage(
                            image: NetworkImage(
                                '${Environments.imageURL}${value.bannerList[index].cover.toString()}'),
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpeg"),
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/notfound.png',
                                  fit: BoxFit.cover);
                            },
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Container(
                      //   height: 40,
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   decoration: BoxDecoration(
                      //     borderRadius: const BorderRadius.only(
                      //       bottomLeft: Radius.circular(0),
                      //       bottomRight: Radius.circular(0),
                      //     ),
                      //     color: ThemeProvider.blackColor.withOpacity(0.5),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         value.bannerList[index].title.toString(),
                      //         overflow: TextOverflow.ellipsis,
                      //         style: const TextStyle(
                      //             color: ThemeProvider.whiteColor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(txt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$txt',
            style: const TextStyle(fontSize: 14, fontFamily: 'bold'),
          ),
        ],
      ),
    );
  }
}
