import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/top_specialist_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopSpecialistScreen extends StatefulWidget {
  const TopSpecialistScreen({Key? key}) : super(key: key);

  @override
  State<TopSpecialistScreen> createState() => _TopSpecialistScreenState();
}

class _TopSpecialistScreenState extends State<TopSpecialistScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopSpecialistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Top Specialist'.tr,
              style: ThemeProvider.titleStyle,
            ),
          ),
          body: value.apiCalled == false
              ? SingleChildScrollView(
                  child: Column(
                    children: List.generate(
                      10,
                      (index) => Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ThemeProvider.whiteColor,
                          boxShadow: const [
                            BoxShadow(
                                color: ThemeProvider.greyColor,
                                blurRadius: 5.0,
                                offset: Offset(0.7, 2.0)),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: SkeletonLine(
                                    style: SkeletonLineStyle(
                                        height: 80,
                                        width: 80,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                              randomLength: true,
                                              height: 20,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              minLength: MediaQuery.of(context)
                                                  .size
                                                  .width),
                                        ),
                                      ),
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 10,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            minLength: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                7,
                                          ),
                                        ),
                                      ),
                                      SkeletonParagraph(
                                        style: SkeletonParagraphStyle(
                                          lines: 1,
                                          spacing: 2,
                                          lineStyle: SkeletonLineStyle(
                                            randomLength: true,
                                            height: 5,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            minLength: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SkeletonParagraph(
                                    style: SkeletonParagraphStyle(
                                      lines: 1,
                                      spacing: 2,
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
                )
              : value.topFreelancerList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      itemCount: value.topFreelancerList.length,
                      itemBuilder: (context, index) {
                        var item = value.topFreelancerList[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: ThemeProvider.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      ThemeProvider.greyColor.withOpacity(0.3),
                                  blurRadius: 8.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(45),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${Environments.imageURL}${item.userInfo?.cover.toString()}',
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Image(
                                            image: AssetImage(
                                                "assets/images/placeholder.jpeg"),
                                            fit: BoxFit.cover),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/images/notfound.png",
                                                fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item.userInfo!.firstName} ${item.userInfo!.lastName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontFamily: 'bold', fontSize: 14),
                                        ),
                                        item.categories!.length <= 2
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: List.generate(
                                                  item.categories!.length,
                                                  (subIndex) => Text(
                                                    item.categories![subIndex]
                                                        .name
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  for (var cate in item
                                                      .categories!
                                                      .take(2))
                                                    Text(cate.name.toString()),
                                                  Text('and more'.tr)
                                                ],
                                              ),
                                        const SizedBox(height: 3),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: item.rating! >= 1
                                                      ? ThemeProvider
                                                          .orangeColor
                                                      : ThemeProvider.greyColor,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: item.rating! >= 2
                                                      ? ThemeProvider
                                                          .orangeColor
                                                      : ThemeProvider.greyColor,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: item.rating! >= 3
                                                      ? ThemeProvider
                                                          .orangeColor
                                                      : ThemeProvider.greyColor,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: item.rating! >= 4
                                                      ? ThemeProvider
                                                          .orangeColor
                                                      : ThemeProvider.greyColor,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: Icon(
                                                  Icons.star,
                                                  size: 15,
                                                  color: item.rating! >= 5
                                                      ? ThemeProvider
                                                          .orangeColor
                                                      : ThemeProvider.greyColor,
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Fee start from '.tr,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: ThemeProvider.greyColor,
                                            ),
                                          ),
                                          TextSpan(
                                            // text: '  \$'.tr +
                                            //     item.feeStart.toString(),
                                            text: value.currencySide == 'left'
                                                ? value.currencySymbol +
                                                    item.feeStart.toString()
                                                : item.feeStart.toString() +
                                                    value.currencySymbol,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: ThemeProvider.appColor,
                                                fontFamily: 'bold'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.appColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        value.onSpecialist(
                                          item.uid as int,
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          'Continue'.tr,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'bold',
                                              color: ThemeProvider.whiteColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            style: const TextStyle(fontFamily: 'bold'),
                          ),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
