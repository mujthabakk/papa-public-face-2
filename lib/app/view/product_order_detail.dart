// /*
//   Authors : initappz (Rahul Jograna)
//   Website : https://initappz.com/
//   App Name : Ultimate Salon Full App Flutter V2
//   This App Template Source code is licensed as per the
//   terms found in the Website https://initappz.com/license
//   Copyright and Good Faith Purchasers © 2023-present initappz.
// */
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/product_order_detail_controller.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:salon_user/app/env.dart';

// class ProductOrderDetail extends StatefulWidget {
//   const ProductOrderDetail({Key? key}) : super(key: key);

//   @override
//   State<ProductOrderDetail> createState() => _ProductOrderDetailState();
// }

// class _ProductOrderDetailState extends State<ProductOrderDetail> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProductOrderDetailController>(
//       builder: (value) {
//         return Scaffold(
//             backgroundColor: ThemeProvider.whiteColor,
//             appBar: AppBar(
//               backgroundColor: ThemeProvider.appColor,
//               elevation: 0,
//               iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
//               titleSpacing: 0,
//               centerTitle: true,
//               title: Text(
//                 'Order Detail'.tr,
//                 style: ThemeProvider.titleStyle,
//               ),
//               actions: <Widget>[
//                 IconButton(
//                     onPressed: () {
//                       value.launchInBrowser();
//                     },
//                     icon: const Icon(Icons.print_outlined)),
//                 IconButton(
//                     onPressed: () {
//                       value.openHelpModal();
//                     },
//                     icon: const Icon(Icons.question_mark_outlined))
//               ],
//             ),
//             body: value.apiCalled != true
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: ThemeProvider.appColor,
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(10),
//                               margin: const EdgeInsets.symmetric(vertical: 10),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: ThemeProvider.whiteColor,
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: ThemeProvider.greyColor,
//                                     blurRadius: 5.0,
//                                   ),
//                                 ],
//                               ),
//                               child: Column(
//                                 children: [
//                                   value.salonOrderInfo.type == 'salon'
//                                       ? Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               child: SizedBox.fromSize(
//                                                 size: const Size.fromRadius(30),
//                                                 child: FadeInImage(
//                                                   image: NetworkImage(
//                                                       '${Environments.imageURL}${value.salonOrderInfo.salonInfo!.cover.toString()}'),
//                                                   placeholder: const AssetImage(
//                                                       "assets/images/placeholder.jpeg"),
//                                                   imageErrorBuilder: (context,
//                                                       error, stackTrace) {
//                                                     return Image.asset(
//                                                       'assets/images/notfound.png',
//                                                       fit: BoxFit.cover,
//                                                       height: 30,
//                                                       width: 30,
//                                                     );
//                                                   },
//                                                   fit: BoxFit.cover,
//                                                   height: 30,
//                                                   width: 30,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     '${value.salonOrderInfo.salonInfo!.name}',
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                         fontFamily: 'bold',
//                                                         fontSize: 14),
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       Expanded(
//                                                         child: Text(
//                                                           value.fullAddres
//                                                               .toString(),
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           maxLines: 2,
//                                                           style: const TextStyle(
//                                                               fontSize: 11,
//                                                               color: ThemeProvider
//                                                                   .blackColor),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 value.onContactInfo(
//                                                     value.salonOrderInfo
//                                                         .salonInfo!.name!,
//                                                     value.salonOrderInfo
//                                                         .ownerInfo!.mobile!,
//                                                     value.salonOrderInfo
//                                                         .ownerInfo!.email!,
//                                                     value.salonOrderInfo.salonId
//                                                         .toString());
//                                               },
//                                               icon: const Icon(Icons.info),
//                                               color: ThemeProvider.appColor,
//                                             )
//                                           ],
//                                         )
//                                       : Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                               child: SizedBox.fromSize(
//                                                 size: const Size.fromRadius(30),
//                                                 child: FadeInImage(
//                                                   image: NetworkImage(
//                                                       '${Environments.imageURL}${value.salonOrderInfo.ownerInfo!.cover.toString()}'),
//                                                   placeholder: const AssetImage(
//                                                       "assets/images/placeholder.jpeg"),
//                                                   imageErrorBuilder: (context,
//                                                       error, stackTrace) {
//                                                     return Image.asset(
//                                                       'assets/images/notfound.png',
//                                                       fit: BoxFit.cover,
//                                                       height: 30,
//                                                       width: 30,
//                                                     );
//                                                   },
//                                                   fit: BoxFit.cover,
//                                                   height: 30,
//                                                   width: 30,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             Expanded(
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                     '${value.salonOrderInfo.ownerInfo!.firstName} ${value.salonOrderInfo.ownerInfo!.lastName}',
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: const TextStyle(
//                                                         fontFamily: 'bold',
//                                                         fontSize: 14),
//                                                   ),
//                                                   Row(
//                                                     children: [
//                                                       Expanded(
//                                                         child: Text(
//                                                           value.fullAddres
//                                                               .toString(),
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           maxLines: 2,
//                                                           style: const TextStyle(
//                                                               fontSize: 11,
//                                                               color: ThemeProvider
//                                                                   .blackColor),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   )
//                                                 ],
//                                               ),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 value.onContactInfo(
//                                                     '${value.salonOrderInfo.ownerInfo!.firstName!} ${value.salonOrderInfo.ownerInfo!.lastName!}',
//                                                     value.salonOrderInfo
//                                                         .ownerInfo!.mobile!,
//                                                     value.salonOrderInfo
//                                                         .ownerInfo!.email!,
//                                                     value.salonOrderInfo
//                                                         .freelancerId
//                                                         .toString());
//                                               },
//                                               icon: const Icon(Icons.info),
//                                               color: ThemeProvider.appColor,
//                                             )
//                                           ],
//                                         ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'Order At'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.blackColor,
//                                               fontSize: 14,
//                                               fontFamily: 'bold'),
//                                         ),
//                                       ),
//                                       Expanded(
//                                         child: Text(
//                                           value.createdAt,
//                                           overflow: TextOverflow.ellipsis,
//                                           textAlign: TextAlign.end,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.blackColor,
//                                               fontSize: 14,
//                                               fontFamily: 'bold'),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Orders'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.appColor,
//                                               fontFamily: 'bold',
//                                               fontSize: 15),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: List.generate(
//                                       value.salonOrderInfo.orders!.length,
//                                       (subIndex) => Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           RichText(
//                                             text: TextSpan(children: [
//                                               TextSpan(
//                                                 text: value.salonOrderInfo
//                                                     .orders![subIndex].name
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                   fontSize: 10,
//                                                   color:
//                                                       ThemeProvider.blackColor,
//                                                   fontFamily: 'regular',
//                                                 ),
//                                               ),
//                                               const TextSpan(text: ' '),
//                                               TextSpan(
//                                                 text: 'X'.tr,
//                                                 style: const TextStyle(
//                                                   fontSize: 10,
//                                                   color:
//                                                       ThemeProvider.blackColor,
//                                                   fontFamily: 'regular',
//                                                 ),
//                                               ),
//                                               const TextSpan(text: ' '),
//                                               TextSpan(
//                                                 text: value.salonOrderInfo
//                                                     .orders![subIndex].quantity
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                   fontSize: 10,
//                                                   color:
//                                                       ThemeProvider.blackColor,
//                                                   fontFamily: 'regular',
//                                                 ),
//                                               ),
//                                             ]),
//                                           ),
//                                           RichText(
//                                             text: TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: value.currencySide ==
//                                                           'left'
//                                                       ? value.currencySymbol +
//                                                           value
//                                                               .salonOrderInfo
//                                                               .orders![subIndex]
//                                                               .originalPrice
//                                                               .toString()
//                                                       : value
//                                                               .salonOrderInfo
//                                                               .orders![subIndex]
//                                                               .originalPrice
//                                                               .toString() +
//                                                           value.currencySymbol,
//                                                   style: const TextStyle(
//                                                       fontSize: 10,
//                                                       color: ThemeProvider
//                                                           .blackColor,
//                                                       fontFamily: 'regular',
//                                                       decoration: TextDecoration
//                                                           .lineThrough),
//                                                 ),
//                                                 const TextSpan(text: ' '),
//                                                 TextSpan(
//                                                   text: value.currencySide ==
//                                                           'left'
//                                                       ? value.currencySymbol +
//                                                           value
//                                                               .salonOrderInfo
//                                                               .orders![subIndex]
//                                                               .sellPrice
//                                                               .toString()
//                                                       : value
//                                                               .salonOrderInfo
//                                                               .orders![subIndex]
//                                                               .sellPrice
//                                                               .toString() +
//                                                           value.currencySymbol,
//                                                   style: const TextStyle(
//                                                       fontSize: 10,
//                                                       color: ThemeProvider
//                                                           .blackColor,
//                                                       fontFamily: 'regular'),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Pricing'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.appColor,
//                                               fontFamily: 'bold',
//                                               fontSize: 15),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               'Discount'.tr,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               value.currencySide == 'left'
//                                                   ? value.currencySymbol +
//                                                       value.discount.toString()
//                                                   : value.discount.toString() +
//                                                       value.currencySymbol,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.end,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               'Wallet Discount'.tr,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               value.currencySide == 'left'
//                                                   ? value.currencySymbol +
//                                                       value.walletDiscount
//                                                           .toString()
//                                                   : value.walletDiscount
//                                                           .toString() +
//                                                       value.currencySymbol,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.end,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               'Distance Cost'.tr,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               value.currencySide == 'left'
//                                                   ? value.currencySymbol +
//                                                       value.distanceCost
//                                                           .toString()
//                                                   : value.distanceCost
//                                                           .toString() +
//                                                       value.currencySymbol,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.end,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               'Service Tax'.tr,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               value.currencySide == 'left'
//                                                   ? value.currencySymbol +
//                                                       value.serviceTax
//                                                           .toString()
//                                                   : value.serviceTax
//                                                           .toString() +
//                                                       value.currencySymbol,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.end,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Expanded(
//                                             child: Text(
//                                               'Total'.tr,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                           Expanded(
//                                             child: Text(
//                                               value.currencySide == 'left'
//                                                   ? value.currencySymbol +
//                                                       value.total.toString()
//                                                   : value.total.toString() +
//                                                       value.currencySymbol,
//                                               overflow: TextOverflow.ellipsis,
//                                               textAlign: TextAlign.end,
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.greyColor,
//                                                   fontSize: 15),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10.0),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Expanded(
//                                           child: Text(
//                                             'Total Amount'.tr,
//                                             overflow: TextOverflow.ellipsis,
//                                             style: const TextStyle(
//                                                 color: ThemeProvider.blackColor,
//                                                 fontSize: 15),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Text(
//                                             value.currencySide == 'left'
//                                                 ? value.currencySymbol +
//                                                     value.grandTotal.toString()
//                                                 : value.grandTotal.toString() +
//                                                     value.currencySymbol,
//                                             overflow: TextOverflow.ellipsis,
//                                             textAlign: TextAlign.end,
//                                             style: const TextStyle(
//                                                 color: ThemeProvider.appColor,
//                                                 fontFamily: 'bold',
//                                                 fontSize: 15),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         )),
//                   ),
//             bottomNavigationBar: value.apiCalled == false
//                 ? const SizedBox()
//                 : Container(
//                     padding: const EdgeInsets.all(16),
//                     child: value.salonOrderInfo.status == 1 ||
//                             value.salonOrderInfo.status == 2 ||
//                             value.salonOrderInfo.status == 3 ||
//                             value.salonOrderInfo.status == 7 ||
//                             value.salonOrderInfo.status == 8 ||
//                             value.salonOrderInfo.status == 5 ||
//                             value.salonOrderInfo.status == 6
//                         ? Text(
//                             '${'Your Order Status'.tr} : ${value.orderStatus}',
//                             textAlign: TextAlign.center,
//                           )
//                         : value.salonOrderInfo.status == 0
//                             ? SizedBox(
//                                 width: double.infinity,
//                                 height: 40,
//                                 child: ElevatedButton(
//                                     onPressed: () {
//                                       value.onUpdateAppointmentStatus(5);
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor: ThemeProvider.appColor,
//                                         shadowColor: ThemeProvider.blackColor,
//                                         foregroundColor:
//                                             ThemeProvider.whiteColor,
//                                         elevation: 3,
//                                         shape: (RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(6),
//                                         )),
//                                         padding: const EdgeInsets.all(0)),
//                                     child: Text(
//                                       'Cancel'.tr,
//                                       style: const TextStyle(
//                                           letterSpacing: 1,
//                                           fontSize: 16,
//                                           color: ThemeProvider.whiteColor,
//                                           fontFamily: 'bold'),
//                                     )),
//                               )
//                             : value.salonOrderInfo.status == 4
//                                 ? SizedBox(
//                                     height: 65,
//                                     child: Column(
//                                       children: [
//                                         SizedBox(
//                                           width: double.infinity,
//                                           height: 40,
//                                           child: ElevatedButton(
//                                               onPressed: () {
//                                                 value.onAddReview(value
//                                                     .salonOrderInfo
//                                                     .freelancerId as int);
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                   backgroundColor:
//                                                       ThemeProvider.appColor,
//                                                   shadowColor:
//                                                       ThemeProvider.blackColor,
//                                                   foregroundColor:
//                                                       ThemeProvider.whiteColor,
//                                                   elevation: 3,
//                                                   shape:
//                                                       (RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             6),
//                                                   )),
//                                                   padding:
//                                                       const EdgeInsets.all(0)),
//                                               child: Text(
//                                                 'Add Review'.tr,
//                                                 style: const TextStyle(
//                                                     letterSpacing: 1,
//                                                     fontSize: 16,
//                                                     color: ThemeProvider
//                                                         .whiteColor,
//                                                     fontFamily: 'bold'),
//                                               )),
//                                         )
//                                       ],
//                                     ),
//                                   )
//                                 : const SizedBox(),
//                   ));
//       },
//     );
//   }
// }

/*
  Authors : initappz (Rahul Jograna)
  Website : https://initappz.com/
  App Name : Ultimate Salon Full App Flutter V2
  This App Template Source code is licensed as per the
  terms found in the Website https://initappz.com/license
  Copyright and Good Faith Purchasers © 2023-present initappz.
*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_order_detail_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/env.dart';

class ProductOrderDetail extends StatefulWidget {
  const ProductOrderDetail({Key? key}) : super(key: key);

  @override
  State<ProductOrderDetail> createState() => _ProductOrderDetailState();
}

class _ProductOrderDetailState extends State<ProductOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductOrderDetailController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 225, 225, 225),
          appBar: AppBar(
            title: Text('Order Details'.tr,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ThemeProvider.appColor, ThemeProvider.appColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.print, size: 24),
                onPressed: controller.launchInBrowser,
              ),
              IconButton(
                icon: const Icon(Icons.help_outline, size: 24),
                onPressed: controller.openHelpModal,
              ),
            ],
          ),
          body: controller.apiCalled != true
              ? const Center(
                  child:
                      CircularProgressIndicator(color: ThemeProvider.appColor))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProviderCard(controller),
                      const SizedBox(height: 16),
                      _buildOrderTimeline(controller),
                      const SizedBox(height: 24),
                      _buildOrderItems(controller),
                      const SizedBox(height: 24),
                      _buildPricingSection(controller),
                      // const SizedBox(height: 24),
                      // _buildTotalAmount(controller),
                    ],
                  ),
                ),
          bottomNavigationBar: _buildActionButtons(controller),
        );
      },
    );
  }

  Widget _buildProviderCard(ProductOrderDetailController controller) {
    final provider = controller.salonOrderInfo;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _buildProviderImage(controller),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.type == 'salon'
                            ? provider.salonInfo!.name!
                            : '${provider.ownerInfo!.firstName} ${provider.ownerInfo!.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        controller.fullAddres,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: ThemeProvider.appColor,
                  onPressed: () => controller.onContactInfo(
                    provider.type == 'salon'
                        ? provider.salonInfo!.name!
                        : '${provider.ownerInfo!.firstName} ${provider.ownerInfo!.lastName}',
                    provider.ownerInfo!.mobile!,
                    provider.ownerInfo!.email!,
                    provider.type == 'salon'
                        ? provider.salonId.toString()
                        : provider.freelancerId.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusChip(controller.orderStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderImage(ProductOrderDetailController controller) {
    final provider = controller.salonOrderInfo;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: FadeInImage(
        image: NetworkImage(
          '${Environments.imageURL}${provider.type == 'salon' ? provider.salonInfo!.cover : provider.ownerInfo!.cover}',
        ),
        placeholder: const AssetImage("assets/images/placeholder.jpeg"),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        imageErrorBuilder: (_, __, ___) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Icon(Icons.storefront, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor = ThemeProvider.appColor;
    if (status.toLowerCase().contains('cancel')) statusColor = Colors.red;
    if (status.toLowerCase().contains('complete')) statusColor = Colors.green;

    return Chip(
      label: Text(status,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: statusColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildOrderTimeline(ProductOrderDetailController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Order Date:'.tr,
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            Text(controller.createdAt,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(ProductOrderDetailController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Items'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ThemeProvider.appColor,
                )),
            const SizedBox(height: 12),
            ...controller.salonOrderInfo.orders!.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '${item.name} '),
                              TextSpan(
                                text: '× ${item.quantity}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        controller.currencySide == 'left'
                            ? '${controller.currencySymbol}${item.sellPrice}'
                            : '${item.sellPrice}${controller.currencySymbol}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(ProductOrderDetailController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow(
              'Discount'.tr,
              double.tryParse(controller.discount) ?? 0.0,
              controller,
            ),
            _buildPriceRow(
              'Wallet Discount'.tr,
              double.tryParse(controller.walletDiscount) ?? 0.0,
              controller,
            ),
            _buildPriceRow(
              'Distance Cost'.tr,
              double.tryParse(controller.distanceCost) ?? 0.0,
              controller,
            ),
            _buildPriceRow(
              'Service Tax'.tr,
              double.tryParse(controller.serviceTax) ?? 0.0,
              controller,
            ),
            const Divider(height: 24),
            _buildPriceRow(
              'Subtotal'.tr,
              double.tryParse(controller.total) ?? 0.0,
              controller,
              isBold: true,
            ),
            const Divider(height: 24),
            _buildTotalAmount(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(
      String label, double value, ProductOrderDetailController controller,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              )),
          Text(
            controller.currencySide == 'left'
                ? '${controller.currencySymbol}$value'
                : '$value${controller.currencySymbol}',
            style: TextStyle(
              fontSize: 14,
              color: isBold ? ThemeProvider.appColor : Colors.grey[700],
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount(ProductOrderDetailController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total Amount:'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeProvider.appColor,
              )),
          Text(
            controller.currencySide == 'left'
                ? '${controller.currencySymbol}${controller.grandTotal}'
                : '${controller.grandTotal}${controller.currencySymbol}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeProvider.appColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ProductOrderDetailController controller) {
    final status = controller.salonOrderInfo.status;
    if (!controller.apiCalled) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: _handleStatusBasedUI(status, controller),
    );
  }

  Widget _handleStatusBasedUI(
      int? status, ProductOrderDetailController controller) {
    const buttonHeight = 48.0;

    if (status == 0) {
      return SizedBox(
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () => controller.onUpdateAppointmentStatus(5),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Cancel Order'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
        ),
      );
    }

    if (status == 4) {
      return SizedBox(
        height: buttonHeight,
        child: ElevatedButton(
          onPressed: () => controller
              .onAddReview(controller.salonOrderInfo.freelancerId as int),
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeProvider.appColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Add Review'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
        ),
      );
    }

    if ([1, 2, 3, 5, 6, 7, 8].contains(status)) {
      return Text(
        '${'Current Status'.tr}: ${controller.orderStatus}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
