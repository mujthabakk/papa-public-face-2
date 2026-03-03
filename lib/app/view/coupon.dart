// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/coupon_controller.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class CouponScreen extends StatefulWidget {
//   const CouponScreen({Key? key}) : super(key: key);

//   @override
//   State<CouponScreen> createState() => _CouponScreenState();
// }

// class _CouponScreenState extends State<CouponScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<CouponController>(
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
//               'Select Coupon'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: value.apiCalled == false
//               ? SkeletonListView()
//               : SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     child: Column(
//                       children: List.generate(
//                           value.couponList.length,
//                           (index) => Container(
//                                 width: double.infinity,
//                                 margin:
//                                     const EdgeInsets.symmetric(vertical: 10),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 10),
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(5),
//                                   color: ThemeProvider.whiteColor,
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: ThemeProvider.greyColor,
//                                       blurRadius: 5.0,
//                                       offset: Offset(0.7, 2.0),
//                                     ),
//                                   ],
//                                 ),
//                                 child: InkWell(
//                                   onTap: () {
//                                     value.saveCoupon(
//                                         value.couponList[index].id as int);
//                                   },
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 10),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'Use coupon code '.tr +
//                                                     value.couponList[index].name
//                                                         .toString(),
//                                                 style: const TextStyle(
//                                                     fontFamily: 'bold',
//                                                     fontSize: 14),
//                                               ),
//                                               const SizedBox(height: 4),
//                                               Text(
//                                                   value.couponList[index]
//                                                           .shortDescriptions
//                                                           .toString() +
//                                                       ' - Valid until '.tr +
//                                                       value.couponList[index]
//                                                           .expire
//                                                           .toString(),
//                                                   style: const TextStyle(
//                                                       color: Colors.grey,
//                                                       fontSize: 12))
//                                             ],
//                                           ),
//                                         ),
//                                         value.selectedCouponCode ==
//                                                 value.couponList[index].id
//                                                     .toString()
//                                             ? const Icon(
//                                                 Icons.check_circle_outline)
//                                             : const Icon(Icons.circle_outlined)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               )),
//                     ),
//                   ),
//                 ),
//           bottomNavigationBar: InkWell(
//             onTap: () {
//               value.onSaveCoupon();
//             },
//             child: Container(
//               height: 50,
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 13.0),
//               decoration: const BoxDecoration(
//                 color: ThemeProvider.greenColor,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Save'.tr,
//                     style: const TextStyle(
//                         color: ThemeProvider.whiteColor, fontSize: 17),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Helper method to format discount display
  String _formatDiscount(dynamic coupon) {
    // Percentage discount
    return '${coupon.discount?.toStringAsFixed(0)}% OFF';
  }

  // Helper method to get discount color
  Color _getDiscountColor(dynamic coupon) {
    if (coupon.type == 1) {
      return Colors.green[600]!;
    } else {
      return Colors.blue[600]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              // Modern App Bar with gradient
              SliverAppBar(
                expandedHeight: 0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: ThemeProvider.appColor,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThemeProvider.appColor,
                        ThemeProvider.appColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    title: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40.0),
                            child: Text(
                              'Available Coupons'.tr,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 30.0),
                          //   child: Text(
                          //     'Save more on your bookings'.tr,
                          //     style: const TextStyle(
                          //       color: Colors.white70,
                          //       fontSize: 11,
                          //       fontWeight: FontWeight.normal,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: value.apiCalled == false
                    ? _buildSkeletonLoader()
                    : SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildCouponList(value),
                        ),
                      ),
              ),
            ],
          ),
          bottomNavigationBar: SlideTransition(
            position: _slideAnimation,
            child: _buildSaveButton(value),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: SkeletonItem(
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponList(CouponController value) {
    if (value.couponList.isEmpty) {
      return _buildEmptyState();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[100]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_offer, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  '${value.couponList.length} ${'Coupons Available'.tr}',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Coupon cards
          ...List.generate(
            value.couponList.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 100)),
              curve: Curves.easeOutBack,
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildCouponCard(value, index),
            ),
          ),

          const SizedBox(height: 80), // Space for bottom button
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponController value, int index) {
    final coupon = value.couponList[index];
    final isSelected = value.selectedCouponCode == coupon.id.toString();
    final isExpired = coupon.maxUsageExceeded == true;

    return GestureDetector(
      onTap: isExpired
          ? null
          : () {
              value.saveCoupon(coupon.id as int);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ThemeProvider.greenColor.withOpacity(0.1),
                    ThemeProvider.greenColor.withOpacity(0.05),
                  ],
                )
              : null,
          color:
              isSelected ? null : (isExpired ? Colors.grey[100] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpired
                ? Colors.grey[300]!
                : (isSelected ? ThemeProvider.greenColor : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isExpired
              ? []
              : [
                  BoxShadow(
                    color: isSelected
                        ? ThemeProvider.greenColor.withOpacity(0.3)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: isSelected ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Discount pattern background
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isExpired
                      ? Colors.grey.withOpacity(0.1)
                      : (isSelected
                          ? ThemeProvider.greenColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.05)),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Expired overlay
            if (isExpired)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Expired'.tr,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Discount badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isExpired
                              ? Colors.grey[300]
                              : _getDiscountColor(coupon).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isExpired
                                ? Colors.grey[400]!
                                : _getDiscountColor(coupon).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _formatDiscount(coupon),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isExpired
                                ? Colors.grey[600]
                                : _getDiscountColor(coupon),
                          ),
                        ),
                      ),

                      const Spacer(),

                      // Selection indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isExpired
                              ? Colors.grey[300]
                              : (isSelected
                                  ? ThemeProvider.greenColor
                                  : Colors.transparent),
                          border: Border.all(
                            color: isExpired
                                ? Colors.grey[400]!
                                : (isSelected
                                    ? ThemeProvider.greenColor
                                    : Colors.grey[400]!),
                            width: 2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: isSelected && !isExpired
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // name
                  Text(
                    coupon.name?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isExpired ? Colors.grey[600] : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Coupon code
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? Colors.grey[200]
                          : (isSelected
                              ? ThemeProvider.greenColor.withOpacity(0.1)
                              : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isExpired
                            ? Colors.grey[300]!
                            : (isSelected
                                ? ThemeProvider.greenColor.withOpacity(0.3)
                                : Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.confirmation_number,
                          size: 16,
                          color: isExpired
                              ? Colors.grey[500]
                              : (isSelected
                                  ? ThemeProvider.greenColor
                                  : Colors.grey[600]),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          coupon.code?.toString() ?? '',
                          style: TextStyle(
                            fontFamily: 'bold',
                            fontSize: 13,
                            color: isExpired
                                ? Colors.grey[600]
                                : (isSelected
                                    ? ThemeProvider.greenColor
                                    : Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    coupon.shortDescriptions?.toString() ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isExpired ? Colors.grey[600] : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Discount details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (coupon.upto != null && coupon.upto! > 0)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  'Discount Up to ₹${coupon.upto!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isExpired
                                        ? Colors.grey[500]
                                        : Colors.green[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            if (coupon.minCartValue != null &&
                                coupon.minCartValue! > 0)
                              Text(
                                'Minimum cart value ₹${coupon.minCartValue!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isExpired
                                      ? Colors.grey[500]
                                      : Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Expiry date
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isExpired ? Colors.red[600] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isExpired
                            ? 'Expired on ${coupon.expire}'
                            : 'Valid until ${coupon.expire}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isExpired ? Colors.red[600] : Colors.grey[600],
                          fontWeight:
                              isExpired ? FontWeight.w600 : FontWeight.normal,
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
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No coupons available'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for exciting offers'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(CouponController value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            value.onSaveCoupon();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThemeProvider.greenColor,
                  ThemeProvider.greenColor.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ThemeProvider.greenColor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Apply Coupon'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
