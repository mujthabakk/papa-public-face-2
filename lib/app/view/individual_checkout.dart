// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/individual_checkout_controller.dart';
// import 'package:salon_user/app/controller/service_cart_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';

// class IndividualCheckoutScreen extends StatefulWidget {
//   const IndividualCheckoutScreen({Key? key}) : super(key: key);

//   @override
//   State<IndividualCheckoutScreen> createState() =>
//       _IndividualCheckoutScreenState();
// }

// class _IndividualCheckoutScreenState extends State<IndividualCheckoutScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<IndividualCheckoutController>(
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
//               'Checkout'.tr,
//               style: ThemeProvider.titleStyle,
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Column(
//                 children: [
//                   value.savedInCart.services!.isNotEmpty
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total'.tr,
//                               style: const TextStyle(
//                                   fontFamily: 'bold', fontSize: 14),
//                             ),
//                             Text(
//                                 '${value.savedInCart.services!.length} ${'Services'.tr}',
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14))
//                           ],
//                         )
//                       : const SizedBox(),
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: value.savedInCart.services!.length,
//                     physics: const ScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, i) => Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: ThemeProvider.whiteColor,
//                             boxShadow: const [
//                               BoxShadow(
//                                   color: ThemeProvider.greyColor,
//                                   blurRadius: 5.0,
//                                   offset: Offset(0.7, 2.0)),
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: SizedBox.fromSize(
//                                   size: const Size.fromRadius(40),
//                                   child: FadeInImage(
//                                     image: NetworkImage(
//                                         '${Environments.imageURL}${value.savedInCart.services![i].cover}'),
//                                     placeholder: const AssetImage(
//                                         "assets/images/placeholder.jpeg"),
//                                     imageErrorBuilder:
//                                         (context, error, stackTrace) {
//                                       return Image.asset(
//                                           'assets/images/notfound.png',
//                                           fit: BoxFit.cover);
//                                     },
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Stack(
//                                   clipBehavior: Clip.none,
//                                   children: [
//                                     Positioned(
//                                       right: -15,
//                                       top: -15,
//                                       child: IconButton(
//                                           onPressed: () {
//                                             value.deleteServiceFromCart(i);
//                                           },
//                                           icon: const Icon(
//                                             Icons.delete,
//                                             color: ThemeProvider.redColor,
//                                           )),
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           value.savedInCart.services![i].name
//                                               .toString(),
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontFamily: 'bold', fontSize: 14),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         RichText(
//                                           text: TextSpan(
//                                             children: [
//                                               TextSpan(
//                                                 text: value.currencySide ==
//                                                         'right'
//                                                     ? '${value.currencySymbol} ${value.savedInCart.services![i].price}'
//                                                     : ' ${value.savedInCart.services![i].price}${value.currencySymbol}',
//                                                 style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color:
//                                                         ThemeProvider.greyColor,
//                                                     decoration: TextDecoration
//                                                         .lineThrough),
//                                               ),
//                                               TextSpan(text: ' '),
//                                               TextSpan(
//                                                 text: value.currencySide ==
//                                                         'right'
//                                                     ? '${value.currencySymbol} ${value.savedInCart.services![i].off}'
//                                                     : ' ${value.savedInCart.services![i].off}${value.currencySymbol}',
//                                                 style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color: ThemeProvider
//                                                         .greenColor,
//                                                     fontFamily: 'bold'),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Text(
//                                           value.savedInCart.services![i]
//                                                   .duration
//                                                   .toString() +
//                                               'min'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.greyColor,
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   value.savedInCart.packages!.isNotEmpty
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total'.tr,
//                               style: const TextStyle(
//                                   fontFamily: 'bold', fontSize: 14),
//                             ),
//                             Text(
//                                 '${value.savedInCart.packages!.length} ${'Packages'.tr}',
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14))
//                           ],
//                         )
//                       : const SizedBox(),
//                   ListView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: value.savedInCart.packages!.length,
//                     physics: const ScrollPhysics(),
//                     shrinkWrap: true,
//                     itemBuilder: (context, i) => Column(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(10),
//                           margin: const EdgeInsets.symmetric(vertical: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(5),
//                             color: ThemeProvider.whiteColor,
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: ThemeProvider.greyColor,
//                                 blurRadius: 5.0,
//                                 offset: Offset(0.7, 2.0),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(5),
//                                 child: SizedBox.fromSize(
//                                   size: const Size.fromRadius(40),
//                                   child: FadeInImage(
//                                     image: NetworkImage(
//                                         '${Environments.imageURL}${value.savedInCart.packages![i].cover}'),
//                                     placeholder: const AssetImage(
//                                         "assets/images/placeholder.jpeg"),
//                                     imageErrorBuilder:
//                                         (context, error, stackTrace) {
//                                       return Image.asset(
//                                           'assets/images/notfound.png',
//                                           fit: BoxFit.cover);
//                                     },
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Stack(
//                                   clipBehavior: Clip.none,
//                                   children: [
//                                     Positioned(
//                                       right: -15,
//                                       top: -15,
//                                       child: IconButton(
//                                           onPressed: () {
//                                             value.deletePackageFromCart(i);
//                                           },
//                                           icon: const Icon(
//                                             Icons.delete,
//                                             color: ThemeProvider.redColor,
//                                           )),
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           value.savedInCart.packages![i].name
//                                               .toString(),
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               fontFamily: 'bold', fontSize: 14),
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: List.generate(
//                                             value.savedInCart.packages![i]
//                                                 .services!.length,
//                                             (serviceIndex) => Text(
//                                               '* ${value.savedInCart.packages![i].services![serviceIndex].name}',
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 12),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(height: 2),
//                                         RichText(
//                                           text: TextSpan(
//                                             children: [
//                                               TextSpan(
//                                                 text: value.currencySide ==
//                                                         'right'
//                                                     ? '${value.currencySymbol} ${value.savedInCart.packages![i].price}'
//                                                     : ' ${value.savedInCart.packages![i].price}${value.currencySymbol}',
//                                                 style: const TextStyle(
//                                                     fontSize: 12,
//                                                     color:
//                                                         ThemeProvider.greyColor,
//                                                     decoration: TextDecoration
//                                                         .lineThrough),
//                                               ),
//                                               TextSpan(text: ' '),
//                                               TextSpan(
//                                                 text: value.currencySide ==
//                                                         'right'
//                                                     ? '${value.currencySymbol} ${value.savedInCart.packages![i].off}'
//                                                     : ' ${value.savedInCart.packages![i].off}${value.currencySymbol}',
//                                                 style: const TextStyle(
//                                                     fontSize: 12,
//                                                     fontFamily: 'bold',
//                                                     color: ThemeProvider
//                                                         .greenColor),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Text(
//                                           value.savedInCart.packages![i]
//                                                   .duration
//                                                   .toString() +
//                                               'min'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.greyColor,
//                                               fontSize: 12),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Bill Details'.tr,
//                         style:
//                             const TextStyle(fontFamily: 'bold', fontSize: 14),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 10, vertical: 10),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5),
//                       color: ThemeProvider.whiteColor,
//                       boxShadow: const [
//                         BoxShadow(
//                           color: ThemeProvider.greyColor,
//                           blurRadius: 5.0,
//                           offset: Offset(0.7, 2.0),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'item Total'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 value.currencySide == 'right'
//                                     ? '${value.currencySymbol} ${Get.find<ServiceCartController>().totalPrice}'
//                                     : ' ${Get.find<ServiceCartController>().totalPrice}${value.currencySymbol}',
//                               )
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Service Charge'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 value.currencySide == 'right'
//                                     ? '${value.currencySymbol} ${Get.find<ServiceCartController>().serviceCharge}'
//                                     : ' ${Get.find<ServiceCartController>().serviceCharge}${value.currencySymbol}',
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'Tax (GST 18%)'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Text(
//                                 value.currencySide == 'right'
//                                     ? '${value.currencySymbol} ${Get.find<ServiceCartController>().taxAmount}'
//                                     : ' ${Get.find<ServiceCartController>().taxAmount}${value.currencySymbol}',
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Divider(),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 5),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   'To Pay'.tr,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: const TextStyle(
//                                       color: ThemeProvider.appColor,
//                                       fontFamily: 'bold'),
//                                 ),
//                               ),
//                               Text(
//                                 value.currencySide == 'right'
//                                     ? '${value.currencySymbol} ${Get.find<ServiceCartController>().grandTotal}'
//                                     : ' ${Get.find<ServiceCartController>().grandTotal}${value.currencySymbol}',
//                                 style: const TextStyle(
//                                     color: ThemeProvider.appColor,
//                                     fontFamily: 'bold'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           bottomNavigationBar: SizedBox(
//             height: 60,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     value.onSlot();
//                   },
//                   child: Container(
//                     height: 60,
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 13.0),
//                     decoration: BoxDecoration(
//                       color: ThemeProvider.pink.withOpacity(0.8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Select Date & Time'.tr,
//                           style: const TextStyle(
//                               color: ThemeProvider.whiteColor, fontSize: 17),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/individual_checkout_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';

class IndividualCheckoutScreen extends StatefulWidget {
  const IndividualCheckoutScreen({Key? key}) : super(key: key);

  @override
  State<IndividualCheckoutScreen> createState() =>
      _IndividualCheckoutScreenState();
}

class _IndividualCheckoutScreenState extends State<IndividualCheckoutScreen> {
  // Modern Color Scheme
  static const Color primary = ThemeProvider.pink;
  static const Color primaryDark = ThemeProvider.pink;
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFCBD5E1);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualCheckoutController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            backgroundColor: cardBackground,
            elevation: 0,
            iconTheme: const IconThemeData(color: textPrimary),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Checkout'.tr,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [borderLight, borderMedium],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Services Section
                if (value.savedInCart.services!.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Services'.tr, value.savedInCart.services!.length),
                  const SizedBox(height: 12),
                  _buildServicesList(value),
                  const SizedBox(height: 24),
                ],

                // Packages Section
                if (value.savedInCart.packages!.isNotEmpty) ...[
                  _buildSectionHeader(
                      'Packages'.tr, value.savedInCart.packages!.length),
                  const SizedBox(height: 12),
                  _buildPackagesList(value),
                  const SizedBox(height: 24),
                ],

                // Bill Summary Section
                _buildSectionTitle('Bill Details'.tr, Icons.receipt_long),
                const SizedBox(height: 12),
                _buildBillDetailsCard(value),
                const SizedBox(height: 80), // Bottom padding for button
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomButton(value),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: textPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(IndividualCheckoutController value) {
    return Column(
      children: List.generate(
        value.savedInCart.services!.length,
        (i) => _buildServiceItem(value, i),
      ),
    );
  }

  Widget _buildServiceItem(IndividualCheckoutController value, int index) {
    final service = value.savedInCart.services![index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Service Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: surfaceBackground,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage(
                  image:
                      NetworkImage('${Environments.imageURL}${service.cover}'),
                  placeholder:
                      const AssetImage("assets/images/placeholder.jpeg"),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/notfound.png',
                        fit: BoxFit.cover);
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Service Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          service.name.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => value.deleteServiceFromCart(index),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.delete_outline,
                            color: error,
                            size: 18,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Duration
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${service.duration} ${'min'.tr}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: success,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Row(
                    children: [
                      Text(
                        value.currencySide == 'left'
                            ? '${value.currencySymbol}${service.price}'
                            : '${service.price}${value.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        value.currencySide == 'left'
                            ? '${value.currencySymbol}${service.off}'
                            : '${service.off}${value.currencySymbol}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: success,
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

  Widget _buildPackagesList(IndividualCheckoutController value) {
    return Column(
      children: List.generate(
        value.savedInCart.packages!.length,
        (i) => _buildPackageItem(value, i),
      ),
    );
  }

  Widget _buildPackageItem(IndividualCheckoutController value, int index) {
    final package = value.savedInCart.packages![index];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Image
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: surfaceBackground,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FadeInImage(
                      image: NetworkImage(
                          '${Environments.imageURL}${package.cover}'),
                      placeholder:
                          const AssetImage("assets/images/placeholder.jpeg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/notfound.png',
                            fit: BoxFit.cover);
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Package Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              package.name.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            onPressed: () => value.deletePackageFromCart(index),
                            icon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: error,
                                size: 18,
                              ),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),

                      // Duration
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${package.duration} ${'min'.tr}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: warning,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price
                      Row(
                        children: [
                          Text(
                            value.currencySide == 'left'
                                ? '${value.currencySymbol}${package.price}'
                                : '${package.price}${value.currencySymbol}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            value.currencySide == 'left'
                                ? '${value.currencySymbol}${package.off}'
                                : '${package.off}${value.currencySymbol}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: success,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Services in Package
            if (package.services != null && package.services!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: surfaceBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Included Services'.tr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      package.services!.length,
                      (serviceIndex) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                package.services![serviceIndex].name.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetailsCard(IndividualCheckoutController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBillRow(
              'Item Total'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().totalPrice.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().totalPrice.toStringAsFixed(2)}${value.currencySymbol}',
            ),
            const SizedBox(height: 12),
            _buildBillRow(
              'Service Charge'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().serviceCharge.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().serviceCharge.toStringAsFixed(2)}${value.currencySymbol}',
            ),
            const SizedBox(height: 12),
            _buildBillRow(
              'Tax (GST 18%)'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}${value.currencySymbol}',
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [borderLight, borderMedium],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildBillRow(
              'To Pay'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().grandTotal.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().grandTotal.toStringAsFixed(2)}${value.currencySymbol}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal ? primary : textSecondary,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isTotal ? primary : textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(IndividualCheckoutController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: const [
          BoxShadow(
            color: shadowLight,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => value.onSlot(),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, primaryDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.schedule,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Select Date & Time'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
