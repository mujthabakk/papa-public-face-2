import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/backend/models/services_model.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/imageviewer.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({Key? key}) : super(key: key);

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  int tabID = 1;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecialistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          body: value.apiCalled == false
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.appColor),
                )
              : CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: const Color.fromARGB(245, 40, 40, 40),
                      floating: true,
                      pinned: true,
                      toolbarHeight: 400,
                      snap: false,
                      elevation: 0,
                      forceElevated: true,
                      iconTheme:
                          const IconThemeData(color: ThemeProvider.appColor),
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                height: 180,
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 50),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      '${Environments.imageURL}${value.individualDetails.background.toString()}'),
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
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            width: 3),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(40),
                                          child: FadeInImage(
                                            image: NetworkImage(
                                                '${Environments.imageURL}${value.userInfo.cover.toString()}'),
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
                                    const Positioned(
                                      right: 5,
                                      bottom: 5,
                                      child: SizedBox(
                                        height: 15,
                                        width: 15,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              ThemeProvider.greenColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Positioned(
                              //   bottom: -40,
                              //   left: 10,
                              //   child: Container(
                              //     height: 25,
                              //     width: 60,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(5),
                              //       border: Border.all(
                              //           color: ThemeProvider.greenColor),
                              //     ),
                              //     child: Center(
                              //       child: Text(
                              //         'OPEN'.tr,
                              //         style: const TextStyle(
                              //             color: ThemeProvider.greenColor,
                              //             fontSize: 10),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Text(
                            '${value.userInfo.firstName} ${value.userInfo.lastName}',
                            style: const TextStyle(
                              fontFamily: 'bold',
                              color: ThemeProvider.whiteColor,
                            ),
                          ),
                          // Text(
                          //   value.userInfo.email.toString(),
                          //   style: const TextStyle(
                          //       color: ThemeProvider.greyColor, fontSize: 12),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          value.individualDetails.rating! >= 1
                                              ? ThemeProvider.orangeColor
                                              : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          value.individualDetails.rating! >= 2
                                              ? ThemeProvider.orangeColor
                                              : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          value.individualDetails.rating! >= 3
                                              ? ThemeProvider.orangeColor
                                              : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          value.individualDetails.rating! >= 4
                                              ? ThemeProvider.orangeColor
                                              : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.star,
                                      size: 15,
                                      color:
                                          value.individualDetails.rating! >= 5
                                              ? ThemeProvider.orangeColor
                                              : ThemeProvider.greyColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ( ${value.individualDetails.totalRating} ${'Reviews)'.tr}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: ThemeProvider.greyColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.openWebsite();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.pink
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.language,
                                          size: 20,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Website'.tr,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.callIndividual();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.greyColor
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.call,
                                          size: 20,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Call'.tr,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.onChat();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.pink
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.chat_outlined,
                                          size: 20,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Chat'.tr,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.openMap();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.greyColor
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.directions,
                                          size: 20,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Direction'.tr,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.share();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: ThemeProvider.pink
                                              .withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: const Icon(
                                          Icons.share,
                                          size: 20,
                                          color: ThemeProvider.whiteColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Share'.tr,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                            length: 3,
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
                                      text: 'Gallery'.tr,
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
                                                          const BouncingScrollPhysics(),
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
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            color: ThemeProvider
                                                                .whiteColor,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: ThemeProvider
                                                                    .greyColor
                                                                    .withOpacity(
                                                                        0.2),
                                                                blurRadius: 8,
                                                                offset:
                                                                    const Offset(
                                                                        0, 3),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // Image with Discount
                                                              Stack(
                                                                children: [
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          150,
                                                                      child:
                                                                          FadeInImage(
                                                                        image: NetworkImage(
                                                                            '${Environments.imageURL}${service.cover}'),
                                                                        placeholder:
                                                                            const AssetImage("assets/images/placeholder.jpeg"),
                                                                        imageErrorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return Image
                                                                              .asset(
                                                                            'assets/images/notfound.png',
                                                                            fit:
                                                                                BoxFit.cover,
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
                                                                              8,
                                                                          vertical:
                                                                              4),
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
                                                              // Details Section
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            service.name.toString(),
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                const TextStyle(
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
                                                                            value.updateServiceStatusInCart(i,
                                                                                status as bool);
                                                                          },
                                                                          checkColor:
                                                                              ThemeProvider.whiteColor,
                                                                          activeColor:
                                                                              ThemeProvider.appColor,
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(4),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            6),
                                                                    RichText(
                                                                      text:
                                                                          TextSpan(
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                14),
                                                                        children: [
                                                                          TextSpan(
                                                                            text: Get.find<SpecialistController>().currencySide == 'left'
                                                                                ? '${Get.find<SpecialistController>().currencySymbol} ${service.price}'
                                                                                : '${service.price}${Get.find<SpecialistController>().currencySymbol}',
                                                                            style:
                                                                                const TextStyle(
                                                                              color: ThemeProvider.greyColor,
                                                                              decoration: TextDecoration.lineThrough,
                                                                            ),
                                                                          ),
                                                                          const WidgetSpan(
                                                                              child: SizedBox(width: 4)),
                                                                          TextSpan(
                                                                            text: Get.find<SpecialistController>().currencySide == 'left'
                                                                                ? '${Get.find<SpecialistController>().currencySymbol} ${service.off}'
                                                                                : '${service.off}${Get.find<SpecialistController>().currencySymbol}',
                                                                            style:
                                                                                const TextStyle(
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
                                                                            Icons
                                                                                .timer,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                ThemeProvider.greyColor),
                                                                        const SizedBox(
                                                                            width:
                                                                                6),
                                                                        Text(
                                                                          '${service.duration} min',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                ThemeProvider.greyColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            width:
                                                                                12),
                                                                        const Icon(
                                                                            Icons
                                                                                .person,
                                                                            size:
                                                                                16,
                                                                            color:
                                                                                ThemeProvider.greyColor),
                                                                        const SizedBox(
                                                                            width:
                                                                                6),
                                                                        Text(
                                                                          _getGenderText(
                                                                              service.gender),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                ThemeProvider.greyColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            8),
                                                                    // Details Button
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      child:
                                                                          ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          _showServiceDetailsDialog(
                                                                              context,
                                                                              service,
                                                                              value);
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          foregroundColor:
                                                                              ThemeProvider.whiteColor,
                                                                          backgroundColor:
                                                                              ThemeProvider.appColor,
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              horizontal: 16,
                                                                              vertical: 8),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          elevation:
                                                                              0,
                                                                        ),
                                                                        child:
                                                                            const Text(
                                                                          'Details',
                                                                          style: TextStyle(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 80,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        else if (tabID == 2)
                                          for (var item in value.packagesList)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      ThemeProvider.whiteColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ThemeProvider
                                                          .greyColor
                                                          .withOpacity(0.2),
                                                      blurRadius: 8,
                                                      offset:
                                                          const Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Image
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      12)),
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
                                                    // Details
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
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
                                                                        16,
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
                                                                            0.1),
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
                                                              height: 8),
                                                          Text(
                                                            Get.find<SpecialistController>()
                                                                        .currencySide ==
                                                                    'left'
                                                                ? '${Get.find<SpecialistController>().currencySymbol} ${item.price}'
                                                                : '${item.price}${Get.find<SpecialistController>().currencySymbol}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  ThemeProvider
                                                                      .greyColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        const SizedBox(
                                          height: 520,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        20.0), // Increased padding for breathing room
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // About Section
                                        _buildSectionTitle('About'.tr),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ThemeProvider.greyColor
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            value.individualDetails.about
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: ThemeProvider.blackColor,
                                              height:
                                                  1.5, // Enhanced readability
                                            ),
                                          ),
                                        ),

                                        // Opening Hours Section
                                        _buildSectionTitle('Opening Hours'.tr),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ThemeProvider.greyColor
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: List.generate(
                                              value.individualDetails.timing!
                                                  .length,
                                              (index) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 8,
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        color: ThemeProvider
                                                            .greenColor,
                                                        shape: BoxShape.circle,
                                                      ),
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
                                                                .individualDetails
                                                                .timing![index]
                                                                .day as int],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  ThemeProvider
                                                                      .greyColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${value.individualDetails.timing![index].openTime} - ${value.individualDetails.timing![index].closeTime}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: ThemeProvider
                                                                  .blackColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                        ),

                                        // Address Section
                                        _buildSectionTitle('Address'.tr),
                                        const SizedBox(height: 12),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ThemeProvider.greyColor
                                                    .withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      value.individualDetails
                                                          .address
                                                          .toString(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: ThemeProvider
                                                            .greyColor,
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Add navigation logic (e.g., open Google Maps with lat/lng)
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons.directions,
                                                            size: 18,
                                                            color: ThemeProvider
                                                                .orangeColor,
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Text(
                                                            '${'Get Directions'.tr}\n${value.getDistance} ${'KM'.tr}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: ThemeProvider
                                                                  .orangeColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
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
                                                  width: 120,
                                                  height: 120,
                                                  child: GoogleMap(
                                                    onMapCreated:
                                                        value.onMapCreated(),
                                                    markers: value.markers,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                        value.individualDetails
                                                            .lat as double,
                                                        value.individualDetails
                                                            .lng as double,
                                                      ),
                                                      zoom:
                                                          14, // Increased zoom for better detail
                                                    ),
                                                    myLocationButtonEnabled:
                                                        false,
                                                    zoomControlsEnabled: false,
                                                    liteModeEnabled:
                                                        true, // Lightweight mode for performance
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Photos Section (Uncomment and enhance if needed)
                                        /*
        _buildSectionTitle('Photos'.tr),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: ThemeProvider.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: ThemeProvider.greyColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Photos'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'bold',
                      color: ThemeProvider.blackColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add "View All" logic here
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
                ],
              ),
              const SizedBox(height: 10),
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
            ],
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
                      Get.find<ServiceCartController>().servicesFrom ==
                          'individual'
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
} // Helper method to create consistent detail rows

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

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 4),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: 'bold',
        color: ThemeProvider.blackColor,
        letterSpacing: 0.2,
      ),
    ),
  );
}

void _showServiceDetailsDialog(BuildContext context, ServicesModel service,
    SpecialistController servicesController) {
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
