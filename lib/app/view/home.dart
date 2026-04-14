import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/account_controller.dart';
import 'package:salon_user/app/controller/home_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CarouselSliderController _controller = CarouselSliderController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var top = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (value) {
        return GetBuilder<AccountController>(
            // Use GetBuilder for the new controller
            builder: (accController) {
          return Scaffold(
            key: _scaffoldKey,
            drawerEnableOpenDragGesture: false,
            // drawer: const SideMenuScreen(),
            body: value.apiCalled == false
                ? SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SkeletonLine(
                                  style: SkeletonLineStyle(
                                      height: 220,
                                      width: double.infinity,
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 6,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength: MediaQuery.of(context).size.width,
                                )),
                          ),
                        ),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                7,
                                (index) => const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                            shape: BoxShape.circle,
                                            width: 60,
                                            height: 60),
                                      ),
                                    )),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: List.generate(
                                7,
                                (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: SkeletonLine(
                                        style: SkeletonLineStyle(
                                            height: 170,
                                            width: 250,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    )),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                                7,
                                (index) => const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SkeletonAvatar(
                                        style: SkeletonAvatarStyle(
                                            shape: BoxShape.circle,
                                            width: 60,
                                            height: 60),
                                      ),
                                    )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SkeletonParagraph(
                            style: SkeletonParagraphStyle(
                                lines: 1,
                                spacing: 6,
                                lineStyle: SkeletonLineStyle(
                                  randomLength: true,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(8),
                                  minLength: MediaQuery.of(context).size.width,
                                )),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Row(
                            children: List.generate(
                                7,
                                (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: SkeletonLine(
                                        style: SkeletonLineStyle(
                                            height: 170,
                                            width: 250,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: ThemeProvider.appColor,
                        pinned: false,
                        snap: false,
                        floating: true,
                        automaticallyImplyLeading: false,
                        elevation: 10,
                        toolbarHeight:
                            MediaQuery.of(context).size.height * 0.074,
                        collapsedHeight:
                            MediaQuery.of(context).size.height * 0.086,
                        expandedHeight:
                            MediaQuery.of(context).size.height * 0.163,
                        iconTheme: const IconThemeData(
                            color: ThemeProvider.whiteColor),
                        flexibleSpace: LayoutBuilder(
                          builder: (ctx, cons) {
                            top = cons.biggest.height;
                            return FlexibleSpaceBar(
                              titlePadding: const EdgeInsets.all(15),
                              centerTitle: false,
                              // Remove the title section completely - we'll handle everything in the background
                              title: null,
                              background: Container(
                                width: double.infinity,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/images/logo_horizontal.png',
                                                height: 50,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '🎉 Hi ${accController.firstName} ${accController.lastName}',
                                                  style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.end,
                                                ),
                                              ),
                                              const SizedBox(width: 28),
                                            ],
                                          )),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(width: 12),
                                          Flexible(
                                            child: InkWell(
                                              onTap: () {
                                                value.onSearch();
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Search services'.tr,
                                                      style: const TextStyle(
                                                        color: ThemeProvider
                                                            .greyColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.search_outlined,
                                                      color: ThemeProvider
                                                          .greyColor,
                                                      size: 16,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Use Stack to ensure icons are always clickable regardless of AppBar state
                                          Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 0),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 2.0),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.toNamed(AppRouter
                                                              .getFindLocationRoutes());
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: const Icon(
                                                            Icons.location_on,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20.0),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.toNamed(AppRouter
                                                              .getNotificatinRoutes());
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: const Icon(
                                                            Icons.notifications,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SingleChildScrollView(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: value.haveData == true
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0),
                                          child: CarouselSlider(
                                            options: CarouselOptions(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              viewportFraction: 1,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 100),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: false,
                                              scrollDirection: Axis.horizontal,
                                            ),
                                            carouselController: _controller,
                                            items: List.generate(
                                              value.bannerList.length,
                                              (index) => GestureDetector(
                                                onTap: () {
                                                  value.onBanner(
                                                      value.bannerList[index]
                                                          .value
                                                          .toString(),
                                                      value.bannerList[index]
                                                          .type
                                                          .toString());
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0,
                                                      vertical: 0),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      children: [
                                                        Stack(
                                                          clipBehavior:
                                                              Clip.none,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              width: double
                                                                  .infinity,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0),
                                                                child:
                                                                    FadeInImage(
                                                                  image: NetworkImage(
                                                                      '${Environments.imageURL}${value.bannerList[index].cover.toString()}'),
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
                                                            // Container(
                                                            //   height: 40,
                                                            //   width: double
                                                            //       .infinity,
                                                            //   padding:
                                                            //       const EdgeInsets
                                                            //           .symmetric(
                                                            //           horizontal:
                                                            //               15),
                                                            //   decoration:
                                                            //       BoxDecoration(
                                                            //     borderRadius:
                                                            //         const BorderRadius
                                                            //             .only(
                                                            //       bottomLeft: Radius
                                                            //           .circular(
                                                            //               0),
                                                            //       bottomRight: Radius
                                                            //           .circular(
                                                            //               0),
                                                            //     ),
                                                            //     color: ThemeProvider
                                                            //         .blackColor
                                                            //         .withOpacity(
                                                            //             0.5),
                                                            //   ),
                                                            //   child: Column(
                                                            //     mainAxisAlignment:
                                                            //         MainAxisAlignment
                                                            //             .center,
                                                            //     crossAxisAlignment:
                                                            //         CrossAxisAlignment
                                                            //             .start,
                                                            //     children: [
                                                            //       Text(
                                                            //         value
                                                            //             .bannerList[
                                                            //                 index]
                                                            //             .title
                                                            //             .toString(),
                                                            //         overflow:
                                                            //             TextOverflow
                                                            //                 .ellipsis,
                                                            //         style: const TextStyle(
                                                            //             color: ThemeProvider
                                                            //                 .whiteColor),
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
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Top Categories'.tr,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'bold'),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .blackColor),
                                                ),
                                                onPressed: () {
                                                  value.onAllCategories();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'View all'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 14,
                                                      color: Color.fromARGB(
                                                          255, 82, 82, 82),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: SizedBox(
                                            height:
                                                120, // Constrain size for ListView horizontal
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  value.categoriesList.length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    value.categoriesList[index];
                                                return InkWell(
                                                  onTap: () {
                                                    value.onCategoriesList(
                                                        item.id as int,
                                                        item.name.toString());
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 5,
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child:
                                                              SizedBox.fromSize(
                                                            size: const Size
                                                                .fromRadius(35),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  '${Environments.imageURL}${item.cover.toString()}',
                                                              fit: BoxFit.cover,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Image(
                                                                      image: AssetImage(
                                                                          "assets/images/placeholder.jpeg"),
                                                                      fit: BoxFit
                                                                          .cover),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Image.asset(
                                                                      "assets/images/notfound.png",
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ),
                                                          ),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 10),
                                                              child: Text(
                                                                item.name!.length >
                                                                        15
                                                                    ? '${item.name!.substring(0, 15)}...'
                                                                    : item.name
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: ThemeProvider
                                                                        .greyColor,
                                                                    fontFamily:
                                                                        'bold'),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Column(
                                            children: [
                                              // Header Section
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Top Wellness Centers'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ThemeProvider
                                                            .blackColor,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          value.onAllOffers,
                                                      style:
                                                          TextButton.styleFrom(
                                                        foregroundColor:
                                                            ThemeProvider
                                                                .appColor,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'View all'.tr,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      90,
                                                                      90,
                                                                      90),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          const Icon(
                                                            Icons
                                                                .arrow_forward_ios_rounded,
                                                            size: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    82,
                                                                    82,
                                                                    82),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Horizontal Scroll Section
                                              SizedBox(
                                                height: 250,
                                                child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      value.salonList.length,
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      const SizedBox(width: 12),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final item =
                                                        value.salonList[index];
                                                    return InkWell(
                                                      onTap: () =>
                                                          value.onServices(
                                                              item.uid as int),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: SizedBox(
                                                        width: 170,
                                                        child: Card(
                                                          elevation: 2,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Image Section
                                                              ClipRRect(
                                                                borderRadius: const BorderRadius
                                                                    .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            12)),
                                                                child: Stack(
                                                                  children: [
                                                                    CachedNetworkImage(
                                                                      height:
                                                                          120,
                                                                      width: double
                                                                          .infinity,
                                                                      imageUrl:
                                                                          '${Environments.imageURL}${item.cover}',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      placeholder: (context, url) => const Image(
                                                                          image: AssetImage(
                                                                              "assets/images/placeholder.jpeg"),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Image.asset(
                                                                              "assets/images/notfound.png",
                                                                              fit: BoxFit.cover),
                                                                    ),
                                                                    Positioned(
                                                                      top: 8,
                                                                      right: 8,
                                                                      child:
                                                                          Container(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                4),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.black54,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            const Icon(Icons.star_rounded,
                                                                                color: Colors.amber,
                                                                                size: 16),
                                                                            const SizedBox(width: 4),
                                                                            Text(
                                                                              item.rating.toString(),
                                                                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              // Content Section
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      item.name
                                                                          .toString(),
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14.5,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            4),
                                                                    Text(
                                                                      item.address ??
                                                                          '',
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .grey
                                                                              .shade600),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    SizedBox(
                                                                      width: double
                                                                          .infinity,
                                                                      child: OutlinedButton
                                                                          .icon(
                                                                        icon: const Icon(
                                                                            Icons
                                                                                .calendar_today,
                                                                            size:
                                                                                14),
                                                                        label: Text(
                                                                            'Book Now'
                                                                                .tr,
                                                                            style:
                                                                                const TextStyle(fontSize: 14)),
                                                                        style: OutlinedButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              ThemeProvider.appColor,
                                                                          side:
                                                                              BorderSide(color: ThemeProvider.appColor),
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8),
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          value.onServices(item.uid
                                                                              as int);
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Top Freelancers'.tr,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'bold'),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .blackColor),
                                                ),
                                                onPressed: () {
                                                  value.onAllSpecialist();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'View all'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 14,
                                                      color: Color.fromARGB(
                                                          255, 82, 82, 82),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: SizedBox(
                                            height:
                                                130, // Constrain size for ListView horizontal
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  value.individualList.length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    value.individualList[index];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          value.onSpecialist(
                                                            item.uid as int,
                                                          );
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100.0),
                                                            border: Border.all(
                                                              width: 2,
                                                              color:
                                                                  ThemeProvider
                                                                      .appColor,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              child: SizedBox
                                                                  .fromSize(
                                                                size: const Size
                                                                    .fromRadius(
                                                                    35),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      '${Environments.imageURL}${item.userInfo?.cover.toString()}',
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      const Image(
                                                                          image: AssetImage(
                                                                              "assets/images/placeholder.jpeg"),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Image.asset(
                                                                          "assets/images/notfound.png",
                                                                          fit: BoxFit
                                                                              .cover),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      Text(
                                                        item.userInfo!.firstName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'semibold'),
                                                      ),
                                                      Text(
                                                        item.userInfo!.lastName
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontFamily:
                                                                'semibold'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Top Products'.tr,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: 'bold'),
                                              ),
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: ThemeProvider
                                                          .blackColor),
                                                ),
                                                onPressed: () {
                                                  value.onTopProducts();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'View all'.tr,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      size: 14,
                                                      color: Color.fromARGB(
                                                          255, 82, 82, 82),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 290,
                                                child: ListView.separated(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      value.productsList.length,
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      const SizedBox(width: 12),
                                                  itemBuilder:
                                                      (context, index) {
                                                    final product = value
                                                        .productsList[index];
                                                    return SizedBox(
                                                      width: 160,
                                                      child: Card(
                                                        elevation: 2,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          onTap: () =>
                                                              value.onProduct(
                                                                  product.id
                                                                      as int),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Image with Discount Badge
                                                              Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .vertical(
                                                                      top: Radius
                                                                          .circular(
                                                                              12),
                                                                    ),
                                                                    child:
                                                                        FadeInImage(
                                                                      height:
                                                                          120,
                                                                      width: double
                                                                          .infinity,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image:
                                                                          NetworkImage(
                                                                        '${Environments.imageURL}${product.cover}',
                                                                      ),
                                                                      placeholder:
                                                                          const AssetImage(
                                                                        "assets/images/placeholder.jpeg",
                                                                      ),
                                                                      imageErrorBuilder: (context,
                                                                              error,
                                                                              stackTrace) =>
                                                                          Image
                                                                              .asset(
                                                                        'assets/images/notfound.png',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if ((product.discount ??
                                                                          0) >
                                                                      0)
                                                                    Positioned(
                                                                      top: 8,
                                                                      left: 8,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                          vertical:
                                                                              4,
                                                                        ),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .green
                                                                              .shade600,
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                        child:
                                                                            Text(
                                                                          '${product.discount}% OFF',
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),

                                                              // Product Details
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        12),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      product.name ??
                                                                          '',
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            4),

                                                                    // Star Rating
                                                                    Row(
                                                                      children: [
                                                                        ...List.generate(
                                                                            5,
                                                                            (starIndex) => Icon(
                                                                                  Icons.star_rounded,
                                                                                  size: 16,
                                                                                  color: starIndex < (product.rating ?? 0) ? ThemeProvider.orangeColor : Colors.grey.shade300,
                                                                                )),
                                                                        const SizedBox(
                                                                            width:
                                                                                4),
                                                                        Text(
                                                                          '(${product.totalRating ?? 0})',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.grey.shade600,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),

                                                                    // Pricing
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        if (product.originalPrice !=
                                                                            null)
                                                                          Text(
                                                                            value.currencySide == 'left'
                                                                                ? '${value.currencySymbol}${product.originalPrice}'
                                                                                : '${product.originalPrice}${value.currencySymbol}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.grey.shade500,
                                                                              decoration: TextDecoration.lineThrough,
                                                                            ),
                                                                          ),
                                                                        Text(
                                                                          value.currencySide == 'left'
                                                                              ? '${value.currencySymbol}${product.sellPrice ?? ''}'
                                                                              : '${product.sellPrice ?? ''}${value.currencySymbol}',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color:
                                                                                ThemeProvider.appColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),

                                                                    // Add to Cart Button
                                                                    if (product
                                                                            .quantity ==
                                                                        0)
                                                                      SizedBox(
                                                                        width: double
                                                                            .infinity,
                                                                        child:
                                                                            ElevatedButton(
                                                                          onPressed: () =>
                                                                              value.addToCart(index),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                ThemeProvider.appColor,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 8),
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Text(
                                                                            'ADD'.tr,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.white,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    else
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          IconButton(
                                                                              icon: const Icon(Icons.remove),
                                                                              onPressed: () => value.updateProductQuantityRemove(index),
                                                                              style: IconButton.styleFrom(
                                                                                backgroundColor: Colors.grey.shade200,
                                                                                padding: const EdgeInsets.all(4),
                                                                              )),
                                                                          Text(
                                                                            product.quantity.toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                const Icon(Icons.add),
                                                                            onPressed: () =>
                                                                                value.updateProductQuantity(index),
                                                                            style:
                                                                                IconButton.styleFrom(
                                                                              backgroundColor: Colors.grey.shade200,
                                                                              padding: const EdgeInsets.all(4),
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
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
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
                                            'No Data Found Near You!'.tr,
                                            style: const TextStyle(
                                                fontFamily: 'bold'),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            bottomNavigationBar: GetBuilder<ServiceCartController>(
              builder: (cartController) {
                return cartController.totalItemsInCart > 0
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
                                      ? '${cartController.totalItemsInCart} ${'Items'.tr} ${value.currencySymbol} ${cartController.totalPrice}'
                                      : '${cartController.totalItemsInCart} ${'Items'.tr} ${cartController.totalPrice}${value.currencySymbol}',
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
                    : const SizedBox();
              },
            ),
          );
        });
      },
    );
  }
}
