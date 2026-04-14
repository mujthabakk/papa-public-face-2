import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/top_products_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TopProductScreen extends StatefulWidget {
  const TopProductScreen({Key? key}) : super(key: key);

  @override
  State<TopProductScreen> createState() => _TopProductScreenState();
}

class _TopProductScreenState extends State<TopProductScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TopProductsControllrer>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.appColor,
          iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Top Products'.tr,
            style: ThemeProvider.titleStyle,
          ),
        ),
        bottomNavigationBar: Get.find<ProductCartController>()
                .savedInCart
                .isNotEmpty
            ? SizedBox(
                height: 50,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: InkWell(
                        onTap: () {
                          value.onCart();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: const BoxDecoration(
                            color: ThemeProvider.pink,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${'Total'.tr} ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${Get.find<ProductCartController>().totalPrice}',
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                              Text(
                                'Cart'.tr,
                                style: const TextStyle(
                                    color: ThemeProvider.whiteColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox(),
        body: value.apiCalled == false
            ? SkeletonListView()
            : GridView.builder(
                primary: false,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 57 / 100,
                ),
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                itemCount: value.productsList.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      value.onProduct(
                        value.productsList[i].id as int,
                      );
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: ThemeProvider.whiteColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: ThemeProvider.greyColor.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              spreadRadius: 1,
                              blurRadius: 8),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 120,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          '${Environments.imageURL}${value.productsList[i].cover.toString()}',
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
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  value.productsList[i].name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: ThemeProvider.blackColor,
                                      fontFamily: 'medium',
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star,
                                        color:
                                            value.productsList[i].rating! >= 1
                                                ? ThemeProvider.orangeColor
                                                : ThemeProvider.greyColor,
                                        size: 12),
                                    Icon(Icons.star,
                                        color:
                                            value.productsList[i].rating! >= 2
                                                ? ThemeProvider.orangeColor
                                                : ThemeProvider.greyColor,
                                        size: 12),
                                    Icon(Icons.star,
                                        color:
                                            value.productsList[i].rating! >= 3
                                                ? ThemeProvider.orangeColor
                                                : ThemeProvider.greyColor,
                                        size: 12),
                                    Icon(Icons.star,
                                        color:
                                            value.productsList[i].rating! >= 4
                                                ? ThemeProvider.orangeColor
                                                : ThemeProvider.greyColor,
                                        size: 12),
                                    Icon(Icons.star,
                                        color:
                                            value.productsList[i].rating! >= 5
                                                ? ThemeProvider.orangeColor
                                                : ThemeProvider.greyColor,
                                        size: 12),
                                    const SizedBox(width: 6),
                                    Text(
                                      value.productsList[i].totalRating
                                          .toString(),
                                      style: const TextStyle(
                                          color: ThemeProvider.blackColor,
                                          fontFamily: 'medium',
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      value.currencySide == 'left'
                                          ? '${value.currencySymbol}${value.productsList[i].originalPrice}/hr'
                                          : '${value.productsList[i].originalPrice}${value.currencySymbol}/hr',
                                      style: const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: ThemeProvider.greyColor,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      value.currencySide == 'left'
                                          ? '${value.currencySymbol}${value.productsList[i].sellPrice}/hr'
                                          : '${value.productsList[i].sellPrice}${value.currencySymbol}/hr',
                                      style: const TextStyle(
                                          color: ThemeProvider.appColor,
                                          fontFamily: 'bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                value.productsList[i].quantity == 0
                                    ? SizedBox(
                                        height: 28,
                                        width: 110,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              value.addToCart(i);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ThemeProvider.appColor,
                                                shadowColor:
                                                    ThemeProvider.greyColor,
                                                foregroundColor:
                                                    ThemeProvider.whiteColor,
                                                elevation: 1,
                                                shape: (RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                )),
                                                padding:
                                                    const EdgeInsets.all(0)),
                                            child: Text(
                                              'ADD'.tr,
                                              style: const TextStyle(
                                                  letterSpacing: 1,
                                                  fontSize: 12,
                                                  color:
                                                      ThemeProvider.whiteColor,
                                                  fontFamily: 'bold'),
                                            )),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 24,
                                                width: 24,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      value
                                                          .updateProductQuantityRemove(
                                                              i);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                ThemeProvider
                                                                    .secondaryAppColor,
                                                            shadowColor:
                                                                ThemeProvider
                                                                    .blackColor,
                                                            foregroundColor:
                                                                ThemeProvider
                                                                    .whiteColor,
                                                            elevation: 3,
                                                            shape:
                                                                (RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            )),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0)),
                                                    child: const Icon(
                                                        Icons.remove)),
                                              ),
                                              Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Text(
                                                    value.productsList[i]
                                                        .quantity
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'medium',
                                                        color: ThemeProvider
                                                            .blackColor),
                                                  )),
                                              SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      value
                                                          .updateProductQuantity(
                                                              i);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                ThemeProvider
                                                                    .secondaryAppColor,
                                                            shadowColor:
                                                                ThemeProvider
                                                                    .blackColor,
                                                            foregroundColor:
                                                                ThemeProvider
                                                                    .whiteColor,
                                                            elevation: 3,
                                                            shape:
                                                                (RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            )),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0)),
                                                    child:
                                                        const Icon(Icons.add)),
                                              )
                                            ],
                                          ),
                                        ],
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
      );
    });
  }
}
