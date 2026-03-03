import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/products_details_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'dart:ui';

class ProductsDetailsScreen extends StatefulWidget {
  const ProductsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsDetailsScreen> createState() => _ProductsDetailsScreenState();
}

class _ProductsDetailsScreenState extends State<ProductsDetailsScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0;
  bool lastStatus = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

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
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsDetailsController>(builder: (value) {
      return value.apiCalled == false
          ? Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeProvider.appColor.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ThemeProvider.appColor,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading Product...',
                        style: TextStyle(
                          color: ThemeProvider.greyColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Color(0xFFF8F9FA),
              extendBodyBehindAppBar: true,
              appBar: _buildAppBar(),
              bottomNavigationBar: value.apiCalled == false
                  ? null
                  : _buildBottomNavigationBar(value),
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageCarousel(value),
                    Transform.translate(
                      offset: Offset(0, -30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildProductHeader(value),
                                SizedBox(height: 14),
                                _buildPriceSection(value),
                                SizedBox(height: 20),
                                _buildUrgencyBanner(),
                                SizedBox(height: 24),
                                _buildProductInfoCard(value),
                                SizedBox(height: 24),
                                _buildDescriptionSection(value),
                                SizedBox(height: 24),
                                _buildDisclaimerSection(value),
                                SizedBox(height: 32),
                                _buildRelatedProductsSection(value),
                                SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:
          isShrink ? Colors.white.withOpacity(0.95) : Colors.transparent,
      elevation: 0,
      flexibleSpace: isShrink
          ? ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            )
          : null,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 4),
              spreadRadius: -5,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: ThemeProvider.blackColor,
              size: 18,
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 12, top: 8, bottom: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 4),
                spreadRadius: -5,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: ThemeProvider.appColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(ProductsDetailsController value) {
    return Container(
      height: 450,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: PageController(),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemCount: value.productsList!.images!.length,
            itemBuilder: (context, index) {
              return Hero(
                tag: 'product_${value.productsList.id}',
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF8F9FA),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      FadeInImage(
                        image: NetworkImage(
                            '${Environments.imageURL}${value.productsList!.images![index]}'),
                        placeholder:
                            AssetImage("assets/images/placeholder.jpeg"),
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.grey[100]!, Colors.grey[200]!],
                            ),
                          ),
                          child: Icon(
                            Icons.image_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      // Positioned(
                      //   top: 80,
                      //   right: 20,
                      //   child: Container(
                      //     padding:
                      //         EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         colors: [
                      //           Color(0xFF2ECC71),
                      //           Color(0xFF27AE60),
                      //         ],
                      //       ),
                      //       borderRadius: BorderRadius.circular(20),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Color(0xFF2ECC71).withOpacity(0.4),
                      //           blurRadius: 15,
                      //           offset: Offset(0, 5),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Icon(Icons.local_offer,
                      //             color: Colors.white, size: 16),
                      //         SizedBox(width: 6),
                      //         Text(
                      //           '${value.productsList.discount}% OFF',
                      //           style: TextStyle(
                      //             fontSize: 13,
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.w800,
                      //             letterSpacing: 0.5,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (value.productsList!.images!.length > 1)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 140),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                  // backdropFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    value.productsList!.images!.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 6,
                      width: currentIndex == index ? 20 : 6,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3),
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

  Widget _buildProductHeader(ProductsDetailsController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeProvider.appColor,
                    ThemeProvider.appColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: ThemeProvider.appColor.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.white, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'PapaBear',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2ECC71),
                    Color(0xFF27AE60),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2ECC71).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_offer, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${value.productsList.discount}% OFF',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          value.productsList.name.toString(),
          style: const TextStyle(
            fontFamily: 'bold',
            color: ThemeProvider.blackColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(ProductsDetailsController value) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeProvider.appColor.withOpacity(0.08),
            blurRadius: 30,
            offset: Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeProvider.appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'BEST PRICE',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: ThemeProvider.appColor,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                Get.find<ProductsDetailsController>().currencySide == 'left'
                    ? '${Get.find<ProductsDetailsController>().currencySymbol}${value.productsList.sellPrice}'
                    : '${value.productsList.sellPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
                style: TextStyle(
                  fontSize: 22,
                  color: ThemeProvider.blackColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                ),
              ),
              SizedBox(width: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Get.find<ProductsDetailsController>().currencySide == 'left'
                        ? '${Get.find<ProductsDetailsController>().currencySymbol}${value.productsList.originalPrice}'
                        : '${value.productsList.originalPrice}${Get.find<ProductsDetailsController>().currencySymbol}',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey[500],
                      decoration: TextDecoration.lineThrough,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5252).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Save ${value.productsList.discount}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFFFF5252),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF1F8F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF2ECC71).withOpacity(0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: Color(0xFF2ECC71),
                  size: 18,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Faster shipping • Quality products • Secure payment',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF2ECC71),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgencyBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6B6B),
            Color(0xFFFF5252),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF5252).withOpacity(0.4),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '⚡ Flash Sale Ending Soon!',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Grab this deal before it expires in 5 days',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfoCard(ProductsDetailsController value) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeProvider.appColor.withOpacity(0.2),
                      ThemeProvider.appColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: ThemeProvider.appColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Product Details',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: ThemeProvider.blackColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          _buildInfoRow(
            Icons.storefront_rounded,
            'Sold By',
            '${value.soldByInfo.firstName} ${value.soldByInfo.lastName}',
            Color(0xFF7C4DFF),
          ),
          _buildDivider(),
          _buildInfoRow(
            Icons.category_rounded,
            'Category',
            value.cateInfo.name.toString(),
            Color(0xFF26C6DA),
          ),
          _buildDivider(),
          _buildInfoRow(
            Icons.label_rounded,
            'Sub Category',
            value.subCateInfo.name.toString(),
            Color(0xFFFF7043),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.grey[300]!,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.2),
                color.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: ThemeProvider.blackColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(ProductsDetailsController value) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeProvider.appColor.withOpacity(0.2),
                      ThemeProvider.appColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.description_rounded,
                  color: ThemeProvider.appColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: ThemeProvider.blackColor,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            value.productsList.descriptions.toString(),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerSection(ProductsDetailsController value) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF8E1),
            Color(0xFFFFECB3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFFFA726).withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFA726).withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFA726).withOpacity(0.3),
                  Color(0xFFFFA726).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF57C00),
              size: 22,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Important Notice',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFF57C00),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value.productsList.disclaimer.toString(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFFE65100),
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedProductsSection(ProductsDetailsController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ThemeProvider.appColor.withOpacity(0.2),
                    ThemeProvider.appColor.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.recommend_rounded,
                color: ThemeProvider.appColor,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Text(
              'You May Also Like',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: ThemeProvider.blackColor,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        SizedBox(height: 18),
        _buildRelatedProducts(value.relatedList, value),
      ],
    );
  }

  Widget _buildRelatedProducts(
      List relatedList, ProductsDetailsController value) {
    return Container(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(vertical: 4),
        itemCount: relatedList.length,
        itemBuilder: (context, index) {
          final product = relatedList[index];
          return Container(
            width: 170,
            margin: EdgeInsets.only(right: 16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  value.getProducts(product.id as int);
                  if (_scrollController.hasClients) {
                    await _scrollController.animateTo(
                      0.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Color(0xFFFAFAFA),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey[200]!,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 170,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                              child: FadeInImage(
                                image: NetworkImage(
                                  '${Environments.imageURL}${product.cover.toString()}',
                                ),
                                placeholder: AssetImage(
                                  "assets/images/placeholder.jpeg",
                                ),
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey[100]!,
                                        Colors.grey[200]!
                                      ],
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: Colors.grey[400],
                                    size: 40,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_border_rounded,
                                color: ThemeProvider.appColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ThemeProvider.blackColor,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: -0.2,
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
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(ProductsDetailsController value) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Color(0xFFFAFAFA),
          ],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, -10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (value.productsList.quantity > 0)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Color(0xFFFAFAFA),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => value.updateProductQuantityRemove(),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.remove_rounded,
                            color: ThemeProvider.blackColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        value.productsList.quantity.toString(),
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontSize: 18,
                          color: ThemeProvider.blackColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => value.updateProductQuantity(),
                        child: Container(
                          padding: EdgeInsets.all(14),
                          child: Icon(
                            Icons.add_rounded,
                            color: ThemeProvider.appColor,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(),
            SizedBox(width: value.productsList.quantity > 0 ? 14 : 0),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ThemeProvider.pink,
                      ThemeProvider.pink.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: ThemeProvider.pink.withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => value.productsList.quantity == 0
                      ? value.addToCart()
                      : value.onCheckout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        value.productsList.quantity == 0
                            ? Icons.shopping_cart_rounded
                            : Icons.arrow_forward_rounded,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        value.productsList.quantity == 0
                            ? 'Add To Cart'.tr
                            : 'Checkout'.tr,
                        style: TextStyle(
                          fontFamily: 'bold',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
