import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/product_payment_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:skeletons/skeletons.dart';

class ProductPaymentScreen extends StatefulWidget {
  const ProductPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ProductPaymentScreen> createState() => _ProductPaymentScreenState();
}

class _ProductPaymentScreenState extends State<ProductPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductPaymentController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF2C3E50)),
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Payment'.tr,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey.shade200,
                      Colors.grey.shade100,
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: value.paymentAPICalled == false
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF6C63FF),
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

                      // Notes Section
                      _buildSectionTitle('Add Notes'.tr, Icons.note_add),
                      const SizedBox(height: 12),
                      _buildNotesCard(value),
                      const SizedBox(height: 24),

                      // Bill Details Section
                      _buildSectionTitle('Bill Summary'.tr, Icons.receipt_long),
                      const SizedBox(height: 12),
                      _buildBillDetailsCard(value),
                      const SizedBox(height: 24),

                      // Payment Methods Section
                      _buildSectionTitle('Payment Methods'.tr, Icons.payment),
                      const SizedBox(height: 12),
                      _buildPaymentMethodsSection(value),
                      const SizedBox(height: 100), // Bottom padding for FAB
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
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(ProductPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  Get.find<ProductCartController>()
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
                        ? const Color(0xFF10B981).withOpacity(0.1)
                        : const Color(0xFF059669).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    value.offerName.isEmpty
                        ? Icons.add_circle_outline
                        : Icons.check_circle,
                    color: value.offerName.isEmpty
                        ? const Color(0xFF10B981)
                        : const Color(0xFF059669),
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
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      if (value.offerName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          value.offerName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard(ProductPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: value.isWalletChecked
            ? Border.all(color: const Color(0xFF6C63FF), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Color(0xFFF59E0B),
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
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.currencySide == 'left'
                        ? '${value.currencySymbol}${value.balance.toStringAsFixed(2)}'
                        : '${value.balance.toStringAsFixed(2)}${value.currencySymbol}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
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
                activeColor: const Color(0xFF6C63FF),
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

  Widget _buildNotesCard(ProductPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: value.notesEditor,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Add special instructions or notes...'.tr,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF2C3E50),
          ),
        ),
      ),
    );
  }

  Widget _buildBillDetailsCard(ProductPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 2),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade200, Colors.grey.shade300],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildBillRow(
              'Item Total'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${Get.find<ProductCartController>().totalPrice.toStringAsFixed(2)}'
                  : '${Get.find<ProductCartController>().totalPrice.toStringAsFixed(2)}${value.currencySymbol}',
              false,
            ),
            const SizedBox(height: 12),
            if (value.discount > 0) ...[
              _buildBillRow(
                'item Discount'.tr,
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
              'Tax (GST 18%)'.tr,
              value.currencySide == 'left'
                  ? '${value.currencySymbol}${value.taxAmount.toStringAsFixed(2)}'
                  : '${value.taxAmount.toStringAsFixed(2)}${value.currencySymbol}',
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
                ? const Color(0xFFEF4444)
                : isTotal
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF64748B),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: isDiscount
                ? const Color(0xFFEF4444)
                : isTotal
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF2C3E50),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection(ProductPaymentController value) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: ThemeProvider.pink, width: 2)
                  : Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? ThemeProvider.pink.withOpacity(0.1)
                      : Colors.grey.shade100,
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
                          color: Colors.grey.shade50,
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
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeProvider.pink
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
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

  Widget _buildBottomSection(ProductPaymentController value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value.apiCalled == false)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF),
                        strokeWidth: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading address...'.tr,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            else
              _buildAddressSection(value),
            if (value.haveFairDeliveryRadius == true) _buildPayButton(value),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(ProductPaymentController value) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            value.onSelectAddress();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: value.haveAddress == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Address'.tr,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${value.addressInfo.address} ${value.addressInfo.landmark}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2C3E50),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Distance: ${value.distance.toStringAsFixed(1)} KM',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No Address Selected'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                            Text(
                              'Please add your delivery address'.tr,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton(ProductPaymentController value) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Material(
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
                colors: [ThemeProvider.pink, ThemeProvider.pink],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ThemeProvider.pink.withOpacity(0.3),
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
      ),
    );
  }
}
