// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:salon_user/app/controller/individual_payment_controller.dart';
// import 'package:salon_user/app/controller/individual_slot_controller.dart';
// import 'package:salon_user/app/controller/service_cart_controller.dart';
// import 'package:salon_user/app/env.dart';
// import 'package:salon_user/app/util/theme.dart';
// import 'package:skeletons/skeletons.dart';

// class IndividualPaymentScreen extends StatefulWidget {
//   const IndividualPaymentScreen({Key? key}) : super(key: key);

//   @override
//   State<IndividualPaymentScreen> createState() =>
//       _IndividualPaymentScreenState();
// }

// class _IndividualPaymentScreenState extends State<IndividualPaymentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<IndividualPaymentController>(
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
//                 'Payment'.tr,
//                 style: ThemeProvider.titleStyle,
//               ),
//             ),
//             body: value.apiCalled == false
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       color: ThemeProvider.appColor,
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Offers & Benefits'.tr,
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             height: 50,
//                             width: double.infinity,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: ThemeProvider.whiteColor,
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: ThemeProvider.greyColor,
//                                   blurRadius: 5.0,
//                                   offset: Offset(0.7, 2.0),
//                                 ),
//                               ],
//                             ),
//                             child: InkWell(
//                               onTap: () {
//                                 if (value.isWalletChecked == false) {
//                                   value.onCoupon(
//                                       value.offerId, value.offerName);
//                                 }
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: value.offerName.isEmpty
//                                         ? Text('Apply Coupon Code'.tr,
//                                             overflow: TextOverflow.ellipsis)
//                                         : Text(
//                                             'Coupon Applied :'.tr +
//                                                 value.offerName,
//                                             overflow: TextOverflow.ellipsis),
//                                   ),
//                                   const Icon(
//                                     Icons.chevron_right,
//                                     color: ThemeProvider.greyColor,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: 50,
//                             width: double.infinity,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: ThemeProvider.whiteColor,
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: ThemeProvider.greyColor,
//                                   blurRadius: 5.0,
//                                   offset: Offset(0.7, 2.0),
//                                 ),
//                               ],
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Checkbox(
//                                   checkColor: Colors.white,
//                                   activeColor: ThemeProvider.appColor,
//                                   value: value.isWalletChecked,
//                                   onChanged: value.balance <= 0 ||
//                                           value.offerName.isNotEmpty
//                                       ? null
//                                       : (bool? status) {
//                                           value.updateWalletChecked(status!);
//                                         },
//                                 ),
//                                 Expanded(
//                                   child: value.currencySide == 'left'
//                                       ? Text(
//                                           '${'Available Balance'.tr + value.currencySymbol}${value.balance}')
//                                       : Text(
//                                           '${'Available Balance'.tr + value.balance.toString()}${value.currencySymbol}'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Notes For Service'.tr,
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14),
//                               ),
//                             ],
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 10),
//                             child: Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(5),
//                                 color: ThemeProvider.whiteColor,
//                                 boxShadow: const [
//                                   BoxShadow(
//                                     color: ThemeProvider.greyColor,
//                                     blurRadius: 5.0,
//                                     offset: Offset(0.7, 2.0),
//                                   ),
//                                 ],
//                               ),
//                               child: TextField(
//                                 controller: value.notesEditor,
//                                 maxLines: 5,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: ThemeProvider.whiteColor,
//                                   hintText: 'Appoinments notes'.tr,
//                                   contentPadding: const EdgeInsets.only(
//                                       bottom: 8.0, top: 14.0, left: 10),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         color: ThemeProvider.appColor),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           color: ThemeProvider.transparent)),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Bill Details'.tr,
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14),
//                               ),
//                             ],
//                           ),
//                           Container(
//                             width: double.infinity,
//                             margin: const EdgeInsets.symmetric(vertical: 10),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: ThemeProvider.whiteColor,
//                               boxShadow: const [
//                                 BoxShadow(
//                                   color: ThemeProvider.greyColor,
//                                   blurRadius: 5.0,
//                                   offset: Offset(0.7, 2.0),
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               children: [
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'item Total'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       Text(
//                                         value.currencySide == 'left'
//                                             ? '${value.currencySymbol}${Get.find<ServiceCartController>().totalPrice.toString()}'
//                                             : '${Get.find<ServiceCartController>().totalPrice.toString()}${value.currencySymbol}',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'item Discount'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.redColor),
//                                         ),
//                                       ),
//                                       Text(
//                                         value.currencySide == 'left'
//                                             ? '-${value.currencySymbol}${value.discount.toString()}'
//                                             : '-${value.discount.toString()}${value.currencySymbol}',
//                                         style: const TextStyle(
//                                             color: ThemeProvider.redColor),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 value.isWalletChecked == true
//                                     ? Padding(
//                                         padding: const EdgeInsets.symmetric(
//                                             vertical: 5),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 'Wallet Discount'.tr,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: const TextStyle(
//                                                     color:
//                                                         ThemeProvider.redColor),
//                                               ),
//                                             ),
//                                             Text(
//                                               value.currencySide == 'left'
//                                                   ? '-${value.currencySymbol}${value.walletDiscount.toString()}'
//                                                   : '-${value.walletDiscount.toString()}${value.currencySymbol}',
//                                               style: const TextStyle(
//                                                   color:
//                                                       ThemeProvider.redColor),
//                                             ),
//                                           ],
//                                         ),
//                                       )
//                                     : const SizedBox(),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'Distance Charge'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       Text(
//                                         value.currencySide == 'left'
//                                             ? '${value.currencySymbol} ${value.deliveryPrice}'
//                                             : ' ${value.deliveryPrice}${value.currencySymbol}',
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'Tax (GST 18%)'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                       Text(
//                                         value.currencySide == 'right'
//                                             ? '${value.currencySymbol} ${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}'
//                                             : ' ${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}${value.currencySymbol}',
//                                       ),
//                                       // Text(
//                                       //   value.currencySide == 'left'
//                                       //       ? '${value.currencySymbol}${Get.find<ServiceCartController>().orderTax.toString()}'
//                                       //       : '${Get.find<ServiceCartController>().orderTax.toString()}${value.currencySymbol}',
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Divider(),
//                                 Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Expanded(
//                                         child: Text(
//                                           'To Pay'.tr,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: const TextStyle(
//                                               color: ThemeProvider.appColor,
//                                               fontFamily: 'bold'),
//                                         ),
//                                       ),
//                                       Text(
//                                         value.currencySide == 'left'
//                                             ? '${value.currencySymbol} ${value.grandTotal}'
//                                             : ' ${value.grandTotal}${value.currencySymbol}',
//                                         style: const TextStyle(
//                                             color: ThemeProvider.appColor,
//                                             fontFamily: 'bold'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Payment Method'.tr,
//                                 style: const TextStyle(
//                                     fontFamily: 'bold', fontSize: 14),
//                               ),
//                             ],
//                           ),
//                           value.paymentAPICalled == false
//                               ? SizedBox(
//                                   height: 300,
//                                   child: SkeletonListView(
//                                     itemCount: 5,
//                                   ),
//                                 )
//                               : const SizedBox(),
//                           Column(
//                             children: List.generate(
//                               value.paymentList.length,
//                               (index) {
//                                 // Hide the first item if premium is false
//                                 if (!value.checkPremium && index == 0) {
//                                   return const SizedBox.shrink();
//                                 }

//                                 return InkWell(
//                                   onTap: () {
//                                     value.selectPaymentMethod(
//                                         value.paymentList[index].id as int);
//                                   },
//                                   child: Container(
//                                     width: double.infinity,
//                                     margin:
//                                         const EdgeInsets.symmetric(vertical: 5),
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: ThemeProvider.whiteColor,
//                                       boxShadow: const [
//                                         BoxShadow(
//                                           color: ThemeProvider.greyColor,
//                                           blurRadius: 5.0,
//                                           offset: Offset(0.7, 2.0),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         CircleAvatar(
//                                           backgroundColor:
//                                               ThemeProvider.transparent,
//                                           child: ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(5),
//                                             child: SizedBox.fromSize(
//                                               size: const Size.fromRadius(20),
//                                               child: FadeInImage(
//                                                 image: NetworkImage(
//                                                     '${Environments.imageURL}${value.paymentList[index].cover}'),
//                                                 placeholder: const AssetImage(
//                                                     "assets/images/placeholder.jpeg"),
//                                                 imageErrorBuilder: (context,
//                                                     error, stackTrace) {
//                                                   return Image.asset(
//                                                       'assets/images/notfound.png',
//                                                       fit: BoxFit.cover);
//                                                 },
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           child: Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 20),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text(
//                                                   value.paymentList[index].name
//                                                       .toString(),
//                                                   style: const TextStyle(
//                                                       fontSize: 14),
//                                                 ),
//                                                 Icon(value.paymentList[index]
//                                                             .id ==
//                                                         value.paymentId
//                                                     ? Icons.check_circle
//                                                     : Icons.circle_outlined)
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//             bottomNavigationBar: Container(
//               color: Colors.white,
//               height: 136,
//               child: Column(
//                 children: [
//                   ListTile(
//                     onTap: () {
//                       value.onSelectAddress();
//                     },
//                     visualDensity:
//                         const VisualDensity(horizontal: 0, vertical: -4),
//                     leading: const Icon(Icons.location_on, size: 14),
//                     minLeadingWidth: 0,
//                     title: value.haveAddress == true
//                         ? Text(
//                             '${value.addressInfo.address} ${value.addressInfo.landmark}',
//                             style: const TextStyle(fontSize: 14),
//                           )
//                         : Text('Please Add Your Address'.tr),
//                     trailing: const Icon(Icons.edit_outlined, size: 14),
//                   ),
//                   ListTile(
//                     visualDensity:
//                         const VisualDensity(horizontal: 0, vertical: -4),
//                     leading: const Icon(Icons.access_time_sharp, size: 14),
//                     minLeadingWidth: 0,
//                     title: Text(
//                       '${Get.find<IndividualSlotController>().savedDate} ${Get.find<IndividualSlotController>().selectedSlotIndex}',
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                     trailing: const Icon(Icons.edit_outlined, size: 14),
//                     onTap: () {
//                       value.onBack();
//                     },
//                   ),
//                   value.haveFairDeliveryRadius == true
//                       ? Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           margin: const EdgeInsets.only(bottom: 8),
//                           child: SizedBox(
//                             width: double.infinity,
//                             height: 42,
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   value.onPayment();
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: ThemeProvider.pink,
//                                     shadowColor: ThemeProvider.blackColor,
//                                     foregroundColor: ThemeProvider.whiteColor,
//                                     elevation: 3,
//                                     shape: (RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(6),
//                                     )),
//                                     padding: const EdgeInsets.all(0)),
//                                 child: Text(
//                                   value.currencySide == 'left'
//                                       ? '${'Pay'} ${value.currencySymbol}${value.grandTotal}'
//                                       : '${'Pay'} ${value.grandTotal}${value.currencySymbol}',
//                                   style: const TextStyle(
//                                       letterSpacing: 1,
//                                       fontSize: 16,
//                                       color: ThemeProvider.whiteColor,
//                                       fontFamily: 'bold'),
//                                 )),
//                           ))
//                       : const SizedBox(),
//                 ],
//               ),
//             ));
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/individual_payment_controller.dart';
import 'package:salon_user/app/controller/individual_slot_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class IndividualPaymentScreen extends StatefulWidget {
  const IndividualPaymentScreen({Key? key}) : super(key: key);

  @override
  State<IndividualPaymentScreen> createState() =>
      _IndividualPaymentScreenState();
}

class _IndividualPaymentScreenState extends State<IndividualPaymentScreen> {
  // App Colors
  static const Color primary = ThemeProvider.gold;
  static const Color primaryDark = ThemeProvider.gold;
  static const Color success = Color(0xFF2E7D32);
  static const Color successDark = Color(0xFF1B5E20);
  static const Color warning = Color(0xFFF2D338);
  static const Color error = Color(0xFFE53935);
  static const Color background = ThemeProvider.backgroundColor;
  static const Color cardBackground = ThemeProvider.surface;
  static const Color textPrimary = ThemeProvider.whiteColor;
  static const Color textSecondary = ThemeProvider.greyColor;
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textHint = Color(0xFFCBD5E1);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);
  static const Color shadowLight = Color(0x0F000000);
  static const Color surfaceBackground = Color(0xFFF1F5F9);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IndividualPaymentController>(
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
              'Service Payment'.tr,
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
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: primary,
                    strokeWidth: 3,
                  ),
                )
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Offers & Benefits Section
                      _buildSectionTitle(
                          'Offers & Benefits'.tr, Icons.local_offer),
                      const SizedBox(height: 12),
                      _buildOfferCard(value),
                      const SizedBox(height: 8),
                      _buildWalletCard(value),
                      const SizedBox(height: 24),

                      // Service Notes Section
                      _buildSectionTitle('Service Notes'.tr, Icons.note_add),
                      const SizedBox(height: 12),
                      _buildNotesCard(value),
                      const SizedBox(height: 24),

                      // Bill Summary Section
                      _buildSectionTitle('Bill Summary'.tr, Icons.receipt_long),
                      const SizedBox(height: 12),
                      _buildBillDetailsCard(value),
                      const SizedBox(height: 24),

                      // Payment Methods Section
                      _buildSectionTitle('Payment Methods'.tr, Icons.payment),
                      const SizedBox(height: 12),
                      _buildPaymentMethodsSection(value),
                      const SizedBox(
                          height:
                              120), // Bottom padding for fixed bottom section
                    ],
                  ),
                ),
          bottomNavigationBar: _buildBottomSection(value),
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

  Widget _buildOfferCard(IndividualPaymentController value) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (value.isWalletChecked == false) {
              value.onCoupon(
                  value.offerId,
                  value.offerName,
                  Get.find<ServiceCartController>()
                      .totalPrice
                      .toStringAsFixed(2));
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: value.offerName.isEmpty
                        ? success.withOpacity(0.1)
                        : successDark.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    value.offerName.isEmpty
                        ? Icons.add_circle_outline
                        : Icons.check_circle,
                    color: value.offerName.isEmpty ? success : successDark,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.offerName.isEmpty
                            ? 'Apply Coupon Code'.tr
                            : 'Coupon Applied'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      if (value.offerName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          value.offerName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard(IndividualPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border:
            value.isWalletChecked ? Border.all(color: primary, width: 2) : null,
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: warning,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.currencySide == 'left'
                        ? '${value.currencySymbol}${value.balance.toStringAsFixed(2)}'
                        : '${value.balance.toStringAsFixed(2)}${value.currencySymbol}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                value: value.isWalletChecked,
                onChanged: value.balance <= 0 || value.offerName.isNotEmpty
                    ? null
                    : (bool? status) {
                        value.updateWalletChecked(status!);
                      },
                activeColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesCard(IndividualPaymentController value) {
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
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: value.notesEditor,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Add special service instructions...'.tr,
            hintStyle: const TextStyle(
              color: textHint,
              fontSize: 14,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBillDetailsCard(IndividualPaymentController value) {
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          title: _buildBillRow(
            'Total Amount'.tr,
            value.currencySide == 'left'
                ? '${value.currencySymbol}${value.grandTotal.toStringAsFixed(2)}'
                : '${value.grandTotal.toStringAsFixed(2)}${value.currencySymbol}',
            false,
            isTotal: true,
          ),
          children: [
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
              'Service Total'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().totalPrice.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().totalPrice.toStringAsFixed(2)}${value.currencySymbol}',
              false,
            ),
            const SizedBox(height: 12),
            if (value.discount > 0) ...[
              _buildBillRow(
                'Service Discount'.tr,
                value.currencySide == 'left'
                    ? '-${value.currencySymbol}${value.discount.toStringAsFixed(2)}'
                    : '-${value.discount.toStringAsFixed(2)}${value.currencySymbol}',
                true,
                isDiscount: true,
              ),
              const SizedBox(height: 12),
            ],
            if (value.isWalletChecked && value.walletDiscount > 0) ...[
              _buildBillRow(
                'Wallet Discount'.tr,
                value.currencySide == 'left'
                    ? '-${value.currencySymbol}${value.walletDiscount.toStringAsFixed(2)}'
                    : '-${value.walletDiscount.toStringAsFixed(2)}${value.currencySymbol}',
                true,
                isDiscount: true,
              ),
              const SizedBox(height: 12),
            ],
            _buildBillRow(
              'Distance Charge'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${value.deliveryPrice.toStringAsFixed(2)}'
                  : '${value.deliveryPrice.toStringAsFixed(2)}${value.currencySymbol}',
              false,
            ),
            const SizedBox(height: 12),
            _buildBillRow(
              'Tax (GST ${Get.find<ServiceCartController>().orderTax}%)'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}'
                  : '${Get.find<ServiceCartController>().taxAmount.toStringAsFixed(2)}${value.currencySymbol}',
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillRow(String label, String amount, bool isNegative,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isDiscount
                ? error
                : isTotal
                    ? primary
                    : textSecondary,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isDiscount
                ? error
                : isTotal
                    ? primary
                    : textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(IndividualPaymentController value) {
    if (value.paymentAPICalled == false) {
      return SizedBox(
        height: 300,
        child: SkeletonListView(itemCount: 5),
      );
    }

    return Column(
      children: List.generate(
        value.paymentList.length,
        (index) {
          if (!value.checkPremium && index == 0) {
            return const SizedBox.shrink();
          }

          final isSelected = value.paymentList[index].id == value.paymentId;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: primary, width: 2)
                  : Border.all(color: borderLight),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? primary.withOpacity(0.1) : shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  value.selectPaymentMethod(value.paymentList[index].id as int);
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: surfaceBackground,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FadeInImage(
                            image: NetworkImage(
                                '${Environments.imageURL}${value.paymentList[index].cover}'),
                            placeholder: const AssetImage(
                                "assets/images/placeholder.jpeg"),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          value.paymentList[index].name.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected ? primary : borderMedium,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
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

  Widget _buildBottomSection(IndividualPaymentController value) {
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
          child: _buildPayButton(value),
        ),
      ),
    );
  }

  Widget _buildPayButton(IndividualPaymentController value) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          value.onPayment();
        },
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
            child: Text(
              value.currencySide == 'left'
                  ? 'Pay ${value.currencySymbol}${value.grandTotal.toStringAsFixed(2)}'
                  : 'Pay ${value.grandTotal.toStringAsFixed(2)}${value.currencySymbol}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
