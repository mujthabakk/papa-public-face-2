import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class ProductsDetailsScreen extends StatefulWidget {
  const ProductsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsDetailsScreen> createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen> {
  var top = 0.0;

  final ScrollController _scrollController = ScrollController();

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsDetailsController>(builder: (value) {
      return value.apiCalled == false
          ? Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: ThemeProvider.appColor),
                    ],
                  ),
                ],
              ),
            )
          : NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  // SliverAppBar(
                  //   backgroundColor: ThemeProvider.backgroundColor,
                  //   pinned: false,
                  //   snap: false,
                  //   floating: false,
                  //   elevation: 0,
                  //   expandedHeight: 230.0,
                  //   iconTheme: const IconThemeData(color: Colors.black),
                  //   leading: IconButton(
                  //     icon: Icon(
                  //       Icons.arrow_back,
                  //       color: isShrink
                  //           ? ThemeProvider.blackColor
                  //           : ThemeProvider.whiteColor,
                  //     ),
                  //     onPressed: () {
                  //       Get.back();
                  //     },
                  //   ),
                  //   title: Text(
                  //     'Products Details'.tr,
                  //     style: TextStyle(
                  //         color: isShrink
                  //             ? ThemeProvider.blackColor
                  //             : ThemeProvider.whiteColor,
                  //         fontFamily: 'bold',
                  //         fontSize: 14),
                  //   ),
                  //   // flexibleSpace: LayoutBuilder(
                  //   //   builder: (ctx, cons) {
                  //   //     top = cons.biggest.height;
                  //   //     return FlexibleSpaceBar(
                  //   //       centerTitle: true,
                  //   //       title: AnimatedOpacity(
                  //   //         opacity: top <= 80 ? 1.0 : 0.0,
                  //   //         duration: const Duration(microseconds: 200),
                  //   //       ),
                  //   //       background: SizedBox(
                  //   //         height: 180,
                  //   //         width: double.infinity,
                  //   //         child: FadeInImage(
                  //   //           image: NetworkImage(
                  //   //               '${Environments.imageURL}${value.productsList.cover.toString()}'),
                  //   //           placeholder: const AssetImage(
                  //   //               "assets/images/placeholder.jpeg"),
                  //   //           imageErrorBuilder: (context, error, stackTrace) {
                  //   //             return Image.asset('assets/images/notfound.png',
                  //   //                 fit: BoxFit.cover);
                  //   //           },
                  //   //           fit: BoxFit.cover,
                  //   //         ),
                  //   //       ),
                  //   //     );
                  //   //   },
                  //   // ),
                  // ),
                ];
              },
              body: Scaffold(
                appBar: AppBar(
                  backgroundColor: ThemeProvider.blackColor,
                  title: Text(
                    'PapaBear ',
                    style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.white,
                        fontFamily: 'bold',
                        fontSize: 18),
                  ),
                  actions: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                backgroundColor: ThemeProvider.whiteColor,
                bottomNavigationBar: value.apiCalled == false
                    ? const SizedBox()
                    : SizedBox(
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            value.productsList.quantity == 0
                                ? const SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 17, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // Icon(
                                            //   Icons.attach_money,
                                            //   color: ThemeProvider.blackColor,
                                            // ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              child: Text(
                                                'Total Price'.tr,
                                                style: const TextStyle(
                                                  fontFamily: 'bold',
                                                  decoration:
                                                      TextDecoration.none,
                                                  color:
                                                      ThemeProvider.blackColor,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: Text(
                                            value.getTotal().toString(),
                                            style: const TextStyle(
                                              fontFamily: 'bold',
                                              decoration: TextDecoration.none,
                                              color: ThemeProvider.blackColor,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            value.productsList.quantity == 0
                                ? InkWell(
                                    onTap: () {
                                      value.addToCart();
                                    },
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13.0),
                                      decoration: BoxDecoration(
                                        color:
                                            ThemeProvider.pink.withOpacity(0.8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Add To Cart'.tr,
                                            style: const TextStyle(
                                                color: ThemeProvider.whiteColor,
                                                fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 50,
                                          color: ThemeProvider.blackColor
                                              .withOpacity(0.8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      ThemeProvider.redColor,
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        value
                                                            .updateProductQuantityRemove();
                                                      },
                                                      icon: const Icon(
                                                        Icons.remove,
                                                        color: ThemeProvider
                                                            .whiteColor,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                value.productsList.quantity
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: ThemeProvider
                                                        .whiteColor),
                                              ),
                                              SizedBox(
                                                height: 30,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      ThemeProvider.greenColor,
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        value
                                                            .updateProductQuantity();
                                                      },
                                                      icon: const Icon(
                                                        Icons.add,
                                                        color: ThemeProvider
                                                            .whiteColor,
                                                        size: 15,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              value.onCheckout();
                                            },
                                            child: Container(
                                              height: 50,
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13.0),
                                              decoration: BoxDecoration(
                                                color: ThemeProvider.appColor
                                                    .withOpacity(0.8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Checkout'.tr,
                                                    style: const TextStyle(
                                                        color: ThemeProvider
                                                            .whiteColor,
                                                        fontSize: 17),
                                                  ),
                                                ],
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
                body: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 520,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: PageView.builder(
                                  itemCount: value.productsList!.images!.length,
                                  itemBuilder: (context, index) {
                                    return FadeInImage(
                                      image: NetworkImage(
                                          '${Environments.imageURL}${value.productsList!.images![index]}'),
                                      placeholder: const AssetImage(
                                          "assets/images/placeholder.jpeg"),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                            'assets/images/notfound.png',
                                            fit: BoxFit.cover);
                                      },
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            value.productsList.name.toString(),
                            style: const TextStyle(
                              fontFamily: 'bold',
                              color: ThemeProvider.blackColor,
                              fontSize: 20,
                            ),
                          ),
                          _buildSectionTitleWithIcon(
                              'Special Price', Icons.local_offer,
                              color: ThemeProvider.greenColor),
                          _buildPriceInfo(value),
                          const SizedBox(
                            height: 12,
                          ),
                          _buildSectionTitleWithIcon(
                              'Hurry!  Only 5 Days Left', Icons.timer,
                              color: ThemeProvider.redColor),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(255, 221, 221,
                                    221), // Change the border color as needed
                                width: 3.5, // Adjust the width of the border
                              ),
                              borderRadius: BorderRadius.circular(
                                  12), // Optionally add border radius for rounded corners
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRichTextWithIcon('Sold By:', Icons.person,
                                    '${value.soldByInfo.firstName} ${value.soldByInfo.lastName}'),
                                _buildRichTextWithIcon(
                                    'Category:',
                                    Icons.category,
                                    value.cateInfo.name.toString()),
                                _buildRichTextWithIcon(
                                    'Sub Category: ',
                                    Icons.subdirectory_arrow_right,
                                    value.subCateInfo.name.toString()),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _buildSectionTitle('Descriptions'),
                          _buildDescriptionText(
                              value.productsList.descriptions.toString()),
                          _buildSectionTitle('Disclaimer'),
                          _buildDescriptionText(
                              value.productsList.disclaimer.toString()),
                          _buildSectionTitle('Related Products'),
                          _buildRelatedProducts(value.relatedList, value),
                        ],
                      )),
                ),
              ),
            );
    });
  }

  Widget _buildRichTextWithIcon(String label, IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ThemeProvider.blackColor),
          const SizedBox(width: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: const TextStyle(
                      fontSize: 12,
                      color: ThemeProvider.blackColor,
                      fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      fontSize: 13, color: ThemeProvider.greyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitleWithIcon(String title, IconData icon,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: color ?? ThemeProvider.blackColor, size: 16),
          const SizedBox(width: 5),
          Text(
            title.tr,
            style: TextStyle(
              color: color ?? ThemeProvider.blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
            fontSize: 14, color: ThemeProvider.greyColor, height: 1.5),
      ),
    );
  }

  Widget _buildPriceInfo(dynamic value) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: Get.find<ProductsDetailsController>().currencySide == 'left'
                  ? '${Get.find<ProductsDetailsController>().currencySymbol} ${value.productsList.sellPrice} '
                  : ' ${value.productsList.sellPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
              style: const TextStyle(
                  fontSize: 28,
                  color: ThemeProvider.appColor,
                  fontWeight: FontWeight.w900),
            ),
            TextSpan(
              text: Get.find<ProductsDetailsController>().currencySide == 'left'
                  ? '${Get.find<ProductsDetailsController>().currencySymbol} ${value.productsList.originalPrice} '
                  : ' ${value.productsList.originalPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
              style: const TextStyle(
                  fontSize: 16,
                  color: ThemeProvider.greyColor,
                  decoration: TextDecoration.lineThrough),
            ),
            TextSpan(
              text: '  ${value.productsList.discount}% OFF',
              style: const TextStyle(
                  fontSize: 18,
                  color: ThemeProvider.redColor,
                  fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPriceInfo(dynamic value) {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         TextSpan(
  //           text:
  //               '₹${value.getPrice().toString()}', // Assuming getPrice is a method
  //           style: const TextStyle(
  //             fontSize: 17,
  //             fontWeight: FontWeight.bold,
  //             color: ThemeProvider.blackColor,
  //           ),
  //         ),
  //         TextSpan(
  //           text:
  //               '  ₹${value.productsList.productPrice}', // Replace 'price' with 'productPrice'
  //           style: const TextStyle(
  //             fontSize: 12,
  //             color: ThemeProvider.greyColor,
  //             decoration: TextDecoration.lineThrough,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildRelatedProducts(List relatedList, dynamic value) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: relatedList.map((product) {
          return Container(
            height: 180,
            width: 110,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: ThemeProvider.greyColor, blurRadius: 4.0)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => value.getProducts(product.id as int),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      height: 140,
                      width: 100,
                      child: FadeInImage(
                        image: NetworkImage(
                            '${Environments.imageURL}${product.cover.toString()}'),
                        placeholder:
                            const AssetImage("assets/images/placeholder.jpeg"),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/notfound.png',
                                fit: BoxFit.cover),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 90,
                  child: Text(
                    product.name.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 13,
                        color: ThemeProvider.blackColor,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
