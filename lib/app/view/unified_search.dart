import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/unified_search_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';

class UnifiedSearchScreen extends StatefulWidget {
  const UnifiedSearchScreen({Key? key}) : super(key: key);

  @override
  @override
  State<UnifiedSearchScreen> createState() => _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends State<UnifiedSearchScreen>
    with SingleTickerProviderStateMixin {
  final CarouselSliderController _controller = CarouselSliderController();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<UnifiedSearchController>();
      // if (controller.isGeneralMode) {
      controller.refreshLocationData();
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnifiedSearchController>(
      builder: (value) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
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
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 10.0),
                                  child: Image.asset(
                                    'assets/images/logo_horizontal.png',
                                    height: 40,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: SizedBox(
                                  height: 38,
                                  child: Stack(
                                    children: [
                                      Autocomplete<String>(
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) async {
                                          if (textEditingValue.text == '') {
                                            return const [];
                                          }

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
                                                color:
                                                    ThemeProvider.blackColor),
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Search For Services...'.tr,
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              hintStyle: const TextStyle(
                                                  fontSize: 13,
                                                  color:
                                                      ThemeProvider.greyColor),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                borderSide: BorderSide(
                                                    color: ThemeProvider
                                                        .whiteColor),
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
                                              fillColor:
                                                  ThemeProvider.whiteColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10,
                                                      right: 100,
                                                      top: 0,
                                                      bottom: 0),
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            adBanner(value),
                            value.isEmptySearchSalon
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.search_off,
                                          size: 48,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Result Not Found',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
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

                                                  if ((index + 1) % 4 == 0) {
                                                    columnChildren
                                                        .add(adBanner(value));
                                                  }

                                                  columnChildren.add(
                                                    GestureDetector(
                                                      onTap: () {
                                                        value.onServices(value
                                                            .salonList[index]
                                                            .uid as int);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3.0),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
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
                                                                            .circular(3),
                                                                    child:
                                                                        SizedBox(
                                                                      height:
                                                                          190,
                                                                      width:
                                                                          120,
                                                                      child:
                                                                          FittedBox(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        child:
                                                                            FadeInImage(
                                                                          image:
                                                                              NetworkImage('${Environments.imageURL}${value.salonList[index].cover.toString()}'),
                                                                          placeholder:
                                                                              const AssetImage("assets/images/placeholder.jpeg"),
                                                                          imageErrorBuilder: (context,
                                                                              error,
                                                                              stackTrace) {
                                                                            return Image.asset('assets/images/notfound.png',
                                                                                fit: BoxFit.cover);
                                                                          },
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
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
                                                                            .salonList[index]
                                                                            .serviceName!,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: const TextStyle(
                                                                            fontFamily:
                                                                                'bold',
                                                                            fontSize:
                                                                                16),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                120,
                                                                            child:
                                                                                Text(
                                                                              value.salonList[index].name!,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(fontFamily: 'bold', fontSize: 12),
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
                                                                        height:
                                                                            3,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                180,
                                                                            child:
                                                                                Text(
                                                                              value.salonList[index].address!,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
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
                                                                            Icons.timer,
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
                                                                            _getGenderText(value.salonList[index].gender),
                                                                            style:
                                                                                const TextStyle(fontSize: 12, color: ThemeProvider.greyColor),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 5),
                                                                          const Icon(
                                                                              Icons.person,
                                                                              size: 14,
                                                                              color: ThemeProvider.greyColor),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.star,
                                                                            color:
                                                                                ThemeProvider.orangeColor,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 5),
                                                                            child:
                                                                                Text(
                                                                              value.salonList[index].rating!.toStringAsFixed(1),
                                                                              style: const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 5),
                                                                            child:
                                                                                Text(
                                                                              '${value.salonList[index].reviewCount} Reviews',
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: const TextStyle(color: ThemeProvider.greyColor, fontWeight: FontWeight.w600, fontSize: 12),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            '₹ ${(value.salonList[index].price!).toStringAsFixed(2)}',
                                                                            style: const TextStyle(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                fontFamily: 'bold',
                                                                                color: Color.fromARGB(255, 244, 12, 117),
                                                                                fontSize: 14),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Text(
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
                                                                            Alignment.topRight,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Text(
                                                                              '₹ ${value.salonList[index].off!.toStringAsFixed(2)}',
                                                                              style: const TextStyle(fontFamily: 'bold', color: Color.fromARGB(255, 68, 68, 68), fontSize: 22),
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            const Text(
                                                                              'Free cancellation',
                                                                              textAlign: TextAlign.right,
                                                                              style: TextStyle(fontFamily: 'bold', color: Color.fromARGB(255, 21, 192, 8), fontSize: 10),
                                                                            ),
                                                                            Text(
                                                                              value.salonList[index].isPremium! ? 'No payment needed, Pay at shop' : 'Pay at shop not available',
                                                                              textAlign: TextAlign.right,
                                                                              style: TextStyle(fontFamily: 'bold', color: value.salonList[index].isPremium! ? Color.fromARGB(255, 21, 192, 8) : Color.fromARGB(255, 252, 6, 6), fontSize: 10),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      adBanner(value),
                      value.isEmptySearchFreelancer
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Result Not Found',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                          value.individualList.length,
                                          (index) {
                                            List<Widget> columnChildren = [];

                                            if ((index + 1) % 4 == 0) {
                                              columnChildren
                                                  .add(adBanner(value));
                                            }

                                            columnChildren.add(
                                              GestureDetector(
                                                onTap: () {
                                                  value.onSpecialist(value
                                                      .individualList[index]
                                                      .uid as int);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3.0),
                                                  child: Card(
                                                    elevation: 8,
                                                    child: Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
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
                                                                      imageErrorBuilder: (context,
                                                                          error,
                                                                          stackTrace) {
                                                                        return Image.asset(
                                                                            'assets/images/notfound.png',
                                                                            fit:
                                                                                BoxFit.cover);
                                                                      },
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
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
                                                                              fontFamily: 'bold',
                                                                              fontSize: 12),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.location_on,
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
                                                                            style:
                                                                                const TextStyle(color: ThemeProvider.greyColor, fontSize: 12),
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
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: const TextStyle(
                                                                              color: ThemeProvider.greyColor,
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
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                            color: ThemeProvider.greyColor,
                                                                            fontSize: 11),
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .timer,
                                                                        color: ThemeProvider
                                                                            .greyColor,
                                                                        size:
                                                                            20,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        _getGenderText(value
                                                                            .individualList[index]
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
                                                                        color: ThemeProvider
                                                                            .orangeColor,
                                                                        size:
                                                                            15,
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
                                                                          style: const TextStyle(
                                                                              color: ThemeProvider.greyColor,
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
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        '₹ ${(value.individualList[index].price!).toStringAsFixed(2)}',
                                                                        style: const TextStyle(
                                                                            decoration: TextDecoration
                                                                                .lineThrough,
                                                                            fontFamily:
                                                                                'bold',
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                244,
                                                                                12,
                                                                                117),
                                                                            fontSize:
                                                                                14),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
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
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          '₹ ${(value.individualList[index].off!).toStringAsFixed(2)}',
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
                                                                          'Free cancellation',
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style: TextStyle(
                                                                              fontFamily: 'bold',
                                                                              color: Color.fromARGB(255, 21, 192, 8),
                                                                              fontSize: 10),
                                                                        ),
                                                                        Text(
                                                                          value.individualList[index].isPremium!
                                                                              ? 'No payment needed, Pay at shop'
                                                                              : 'Pay at shop not available',
                                                                          textAlign:
                                                                              TextAlign.right,
                                                                          style: TextStyle(
                                                                              fontFamily: 'bold',
                                                                              color: value.individualList[index].isPremium! ? Color.fromARGB(255, 21, 192, 8) : Color.fromARGB(255, 252, 6, 6),
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
            ),
          ),
        );
      },
    );
  }

  String _getGenderText(int? gender) {
    switch (gender) {
      case 0:
        return 'Kid';
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

  Widget adBanner(UnifiedSearchController value) {
    value.getBannerData;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.width * 0.5,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 100),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ),
        carouselController: _controller,
        items: List.generate(
          value.bannerList.length,
          (index) => GestureDetector(
            onTap: () {
              value.onBanner(
                value.bannerList[index].value.toString(),
                value.bannerList[index].type.toString(),
              );
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
                          height: MediaQuery.of(context).size.width * 0.5,
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
                      ],
                    ),
                  ],
                ),
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
