import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/products_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    final isLargeTablet = screenWidth > 900;

    // Dynamic scaling factors based on screen size
    final double scaleFactor = screenWidth / 360; // Base design width = 360
    final double fontScale = scaleFactor.clamp(0.8, 1.5);
    final double sizeScale = scaleFactor.clamp(0.9, 1.8);

    // Dynamic values
    final double appBarFontSize = 18 * fontScale;
    final double bottomNavHeight = (90 * sizeScale).clamp(80.0, 140.0);
    final double sortBarHeight = (40 * sizeScale).clamp(36.0, 60.0);
    final double iconSize = (20 * fontScale).clamp(18.0, 32.0);
    final double bodyFontSize = (14 * fontScale).clamp(12.0, 20.0);
    final double smallFontSize = (11 * fontScale).clamp(10.0, 18.0);
    final double titleFontSize = (11.5 * fontScale).clamp(11.0, 19.0);
    final double priceFontSize = (13 * fontScale).clamp(12.0, 20.0);
    final double buttonFontSize = (10.5 * fontScale).clamp(10.0, 16.0);
    final double gridPadding = (10 * sizeScale).clamp(8.0, 20.0);
    final double cardPadding = (8 * sizeScale).clamp(6.0, 16.0);
    final double borderRadius = (10 * sizeScale).clamp(8.0, 20.0);
    final double imageHeight = (screenHeight * 0.18).clamp(100.0, 200.0);
    final double buttonHeight = (30 * sizeScale).clamp(28.0, 48.0);
    final double quantityButtonSize = (26 * sizeScale).clamp(24.0, 44.0);
    final double noDataImageSize = (80 * sizeScale).clamp(60.0, 120.0);

    // Grid configuration
    final int crossAxisCount = isLargeTablet ? 4 : (isTablet ? 3 : 2);
    final double childAspectRatio =
        _calculateAspectRatio(screenWidth, screenHeight, crossAxisCount);

    return GetBuilder<ProductsController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.whiteColor,
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: ThemeProvider.whiteColor,
              size: 24 * fontScale,
            ),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Products'.tr,
              style:
                  ThemeProvider.titleStyle.copyWith(fontSize: appBarFontSize),
            ),
          ),
          bottomNavigationBar: SizedBox(
            height: bottomNavHeight,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    value.onSortBy();
                  },
                  child: Container(
                    height: sortBarHeight,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8 * sizeScale),
                    decoration: BoxDecoration(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sort,
                          color: ThemeProvider.whiteColor,
                          size: iconSize,
                        ),
                        SizedBox(width: 5 * sizeScale),
                        Text(
                          'Sort By'.tr,
                          style: TextStyle(
                              color: ThemeProvider.whiteColor,
                              fontSize: bodyFontSize),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      value.onCart();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20 * sizeScale),
                      decoration: const BoxDecoration(
                        color: ThemeProvider.pink,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              value.currencySide == 'left'
                                  ? '${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${value.currencySymbol} ${Get.find<ProductCartController>().totalPrice}'
                                  : ' ${Get.find<ProductCartController>().savedInCart.length} ${'Items'.tr} ${Get.find<ProductCartController>().totalPrice}${value.currencySymbol}',
                              style: TextStyle(
                                  color: ThemeProvider.whiteColor,
                                  fontSize: bodyFontSize),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            'Goto Cart'.tr,
                            style: TextStyle(
                                color: ThemeProvider.whiteColor,
                                fontSize: bodyFontSize),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: value.apiCalled == false
              ? SkeletonListView()
              : value.productsList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: gridPadding),
                        child: Column(
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.all(gridPadding),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: gridPadding,
                                mainAxisSpacing: gridPadding,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemCount: value.productsList.length,
                              itemBuilder: (context, index) {
                                return _buildProductCard(
                                  context: context,
                                  value: value,
                                  index: index,
                                  imageHeight: imageHeight,
                                  cardPadding: cardPadding,
                                  borderRadius: borderRadius,
                                  titleFontSize: titleFontSize,
                                  priceFontSize: priceFontSize,
                                  smallFontSize: smallFontSize,
                                  buttonFontSize: buttonFontSize,
                                  buttonHeight: buttonHeight,
                                  quantityButtonSize: quantityButtonSize,
                                  sizeScale: sizeScale,
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20 * sizeScale),
                          SizedBox(
                            height: noDataImageSize,
                            width: noDataImageSize,
                            child: Image.asset(
                              "assets/images/no-data.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 30 * sizeScale),
                          Text(
                            'No Data Found!'.tr,
                            style: TextStyle(
                              fontFamily: 'bold',
                              fontSize: bodyFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required ProductsController value,
    required int index,
    required double imageHeight,
    required double cardPadding,
    required double borderRadius,
    required double titleFontSize,
    required double priceFontSize,
    required double smallFontSize,
    required double buttonFontSize,
    required double buttonHeight,
    required double quantityButtonSize,
    required double sizeScale,
  }) {
    final bool isTablet = MediaQuery.of(context).size.width > 900;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: ThemeProvider.whiteColor,
        boxShadow: [
          BoxShadow(
            color: ThemeProvider.greyColor,
            blurRadius: 5.0 * sizeScale,
            offset: Offset(0.7 * sizeScale, 2.0 * sizeScale),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          value.onProductsDetails(value.productsList[index].id as int);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              child: SizedBox(
                height: isTablet ? imageHeight : imageHeight - 15,
                width: double.infinity,
                child: FadeInImage(
                  image: NetworkImage(
                    '${Environments.imageURL}${value.productsList[index].cover}',
                  ),
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
            // Product Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Product Name
                        Text(
                          value.productsList[index].name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontSize: titleFontSize,
                          ),
                        ),
                        SizedBox(height: 2 * sizeScale),
                        // Price Section - Flexible to handle overflow
                        Flexible(
                          flex: 0,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: Get.find<ProductsController>()
                                                .currencySide ==
                                            'left'
                                        ? '${Get.find<ProductsController>().currencySymbol}${value.productsList[index].sellPrice}'
                                        : '${value.productsList[index].sellPrice}${Get.find<ProductsController>().currencySymbol}',
                                    style: TextStyle(
                                      fontSize: priceFontSize,
                                      color: ThemeProvider.appColor,
                                      fontFamily: 'bold',
                                    ),
                                  ),
                                  TextSpan(
                                    text: Get.find<ProductsController>()
                                                .currencySide ==
                                            'left'
                                        ? ' ${Get.find<ProductsController>().currencySymbol}${value.productsList[index].originalPrice}'
                                        : ' ${value.productsList[index].originalPrice}${Get.find<ProductsController>().currencySymbol}',
                                    style: TextStyle(
                                      fontSize: smallFontSize,
                                      color: ThemeProvider.blackColor,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Discount Badge
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${value.productsList[index].discount}% OFF',
                            style: TextStyle(
                              fontSize: smallFontSize,
                              color: ThemeProvider.redColor,
                              fontFamily: 'bold',
                            ),
                          ),
                        ),
                        // Spacer to push cart controls to bottom
                        //  const Expanded(child: SizedBox()),
                        SizedBox(height: 4 * sizeScale),

                        // Add to Cart / Quantity Controls
                        _buildCartControls(
                          value: value,
                          index: index,
                          buttonHeight: buttonHeight,
                          buttonFontSize: buttonFontSize,
                          quantityButtonSize: quantityButtonSize,
                          sizeScale: sizeScale,
                          priceFontSize: priceFontSize,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartControls({
    required ProductsController value,
    required int index,
    required double buttonHeight,
    required double buttonFontSize,
    required double quantityButtonSize,
    required double sizeScale,
    required double priceFontSize,
  }) {
    if (value.productsList[index].quantity == 0) {
      return Center(
        child: SizedBox(
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: () {
              value.addToCart(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeProvider.appColor,
              padding: EdgeInsets.symmetric(
                horizontal: 12 * sizeScale,
                vertical: 4 * sizeScale,
              ),
              shape: const StadiumBorder(),
            ),
            child: Text(
              'Add to cart'.tr,
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Decrease Button
          SizedBox(
            height: quantityButtonSize,
            width: quantityButtonSize,
            child: CircleAvatar(
              backgroundColor: ThemeProvider.redColor,
              child: IconButton(
                onPressed: () {
                  value.updateProductQuantityRemove(index);
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.remove,
                  color: ThemeProvider.whiteColor,
                  size: quantityButtonSize * 0.5,
                ),
              ),
            ),
          ),
          // Quantity Display
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * sizeScale),
            child: Text(
              value.productsList[index].quantity.toString(),
              style: TextStyle(
                fontSize: priceFontSize,
                fontFamily: 'bold',
              ),
            ),
          ),
          // Increase Button
          SizedBox(
            height: quantityButtonSize,
            width: quantityButtonSize,
            child: CircleAvatar(
              backgroundColor: ThemeProvider.greenColor,
              child: IconButton(
                onPressed: () {
                  value.updateProductQuantity(index);
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.add,
                  color: ThemeProvider.whiteColor,
                  size: quantityButtonSize * 0.5,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  /// Calculate optimal aspect ratio based on screen dimensions and column count
  double _calculateAspectRatio(
      double screenWidth, double screenHeight, int columns) {
    // Calculate available width per card
    final double cardWidth = (screenWidth - (columns + 1) * 10) / columns;

    // Estimate card height based on content
    // Image takes ~40% of height, rest is content
    final double estimatedImageHeight = screenHeight * 0.18;
    final double estimatedContentHeight = screenHeight * 0.15;
    final double estimatedCardHeight =
        estimatedImageHeight + estimatedContentHeight;

    // Calculate and clamp aspect ratio
    double ratio = cardWidth / estimatedCardHeight;

    // Adjust based on screen type - lower values = taller cards (more space)
    if (screenWidth > 900) {
      return ratio.clamp(0.58, 0.74); // Large tablets
    } else if (screenWidth > 600) {
      return ratio.clamp(0.52, 0.67); // Tablets
    } else if (screenHeight > 800) {
      return ratio.clamp(0.50, 0.60); // Taller phones
    } else {
      return ratio.clamp(0.47, 0.57); // Regular phones - needs more height
    }
  }
}
