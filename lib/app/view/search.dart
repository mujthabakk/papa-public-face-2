import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/search_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
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
    return GetBuilder<AppSearchController>(
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
                  : ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                                                                            value.salonList[index].rating!.toStringAsFixed(1),
                                                                            style:
                                                                                const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 5),
                                                                          child:
                                                                              Text(
                                                                            '${value.salonList[index].reviewCount} Reviews',
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style: const TextStyle(
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
                                                                          Text(
                                                                            value.salonList[index].isPremium!
                                                                                ? 'Free cancellation\nNo payment needed, Pay at shop'
                                                                                : 'Free cancellation\nPay at shop not available',
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
              ListView(padding: EdgeInsets.zero, children: <Widget>[
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
                                                                            .rating!
                                                                            .toStringAsFixed(1),
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
                                                                      Text(
                                                                        value.individualList[index].isPremium!
                                                                            ? 'Free cancellation\nNo payment needed, Pay at shop'
                                                                            : 'Free cancellation\nPay at shop not available',
                                                                        textAlign:
                                                                            TextAlign.right,
                                                                        style: const TextStyle(
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

  CarouselSlider adBanner(AppSearchController value) {
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
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
