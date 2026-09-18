import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _couponCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<CheckoutController>();
      final coupon = Get.find<ServiceCartController>().selectedCoupon;
      if ((coupon.code ?? '').isNotEmpty) {
        _couponCode.text = coupon.code!;
      }
      controller.syncCouponLabel();
      controller.refreshPricingFromApi();
      controller.update();
    });
  }

  @override
  void dispose() {
    _couponCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (value) {
        final cart = Get.find<ServiceCartController>();
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'My Cart'.tr,
            onMore: () {},
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text('Cart Selection'.tr,
                  style: ThemeProvider.serif(size: 28, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Review your premium wellness curated list.'.tr,
                style: ThemeProvider.sans(
                    size: 13, color: ThemeProvider.greyColor),
              ),
              const SizedBox(height: 16),
              ...(value.savedInCart.services ?? []).asMap().entries.map(
                    (e) => _line(
                      cover: e.value.cover,
                      title: e.value.name,
                      subtitle:
                          '${e.value.duration?.toInt() ?? 0} Minutes • Service',
                      price: elitePrice(
                        value.currencySide,
                        value.currencySymbol,
                        (e.value.discount ?? 0) > 0 ? e.value.off : e.value.price,
                        digits: 2,
                      ),
                      badge: 'SERVICE',
                      goldBadge: true,
                      onDelete: () => value.deleteServiceFromCart(e.key),
                    ),
                  ),
              ...(value.savedInCart.packages ?? []).asMap().entries.map(
                    (e) => _line(
                      cover: e.value.cover,
                      title: e.value.name,
                      subtitle: e.value.services
                              ?.map((s) => s.name)
                              .whereType<String>()
                              .join(' • ') ??
                          'Package',
                      price: elitePrice(
                        value.currencySide,
                        value.currencySymbol,
                        (e.value.discount ?? 0) > 0 ? e.value.off : e.value.price,
                        digits: 2,
                      ),
                      badge: 'PACKAGE',
                      goldBadge: true,
                      onDelete: () => value.deletePackageFromCart(e.key),
                    ),
                  ),
              EliteCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REDEEM COUPON'.tr,
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.gold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _couponCode,
                      style: ThemeProvider.sans(size: 14),
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: ThemeProvider.sans(
                            size: 13, color: ThemeProvider.greyColor),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: ThemeProvider.gold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: value.onCoupon,
                          child: Text('SELECT COUPON'.tr,
                            style: ThemeProvider.sans(
                              size: 11,
                              weight: FontWeight.w700,
                              color: ThemeProvider.gold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              value.applyCouponByCode(_couponCode.text),
                          child: Text('APPLY'.tr,
                            style: ThemeProvider.sans(
                              size: 12,
                              weight: FontWeight.w700,
                              color: ThemeProvider.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (value.appliedCouponLabel.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  value.appliedCouponName.isNotEmpty
                                      ? value.appliedCouponName
                                      : value.appliedCouponLabel,
                                  style: ThemeProvider.serif(
                                    size: 16,
                                    color: ThemeProvider.gold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  [
                                    if (value.appliedCouponCode.isNotEmpty)
                                      '${'Code'.tr}: ${value.appliedCouponCode}',
                                    if (value.appliedCouponDeal.isNotEmpty)
                                      value.appliedCouponDeal,
                                  ].join('  •  '),
                                  style: ThemeProvider.sans(
                                    size: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: value.removeCoupon,
                            child: Text('REMOVE'.tr,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w700,
                                color: ThemeProvider.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(color: Color(0xFF2A2A2A), height: 24),
                    _bill(
                        'Original Amount'.tr,
                        elitePrice(value.currencySide, value.currencySymbol,
                            value.originalAmount,
                            digits: 2)),
                    _bill(
                        'Service Charge (${cart.serviceCharge}%)',
                        elitePrice(value.currencySide, value.currencySymbol,
                            cart.serviceChargeAmount,
                            digits: 2)),
                    _bill(
                      '${cart.taxTypeLabel} (${cart.orderTax}%)',
                      elitePrice(
                        value.currencySide,
                        value.currencySymbol,
                        value.taxAmount > 0 ? value.taxAmount : cart.taxAmount,
                        digits: 2,
                      ),
                    ),
                    if (value.couponDiscount > 0)
                      _bill(
                        value.appliedCouponName.isNotEmpty
                            ? value.appliedCouponName
                            : 'Discount Amount'.tr,
                        '-${elitePrice(value.currencySide, value.currencySymbol, value.couponDiscount, digits: 2)}',
                        amountColor: ThemeProvider.gold,
                      ),
                    if (value.taxAmount > 0 ||
                        Get.find<ServiceCartController>().taxAmount > 0) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Taxable: ${elitePrice(value.currencySide, value.currencySymbol, value.taxableValue > 0 ? value.taxableValue : Get.find<ServiceCartController>().taxableValue, digits: 2)} | ${Get.find<ServiceCartController>().taxTypeLabel}: ${elitePrice(value.currencySide, value.currencySymbol, value.taxAmount > 0 ? value.taxAmount : Get.find<ServiceCartController>().taxAmount, digits: 2)}',
                        style: ThemeProvider.sans(
                          size: 11,
                          color: ThemeProvider.greyColor,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text('Pay Amount'.tr,
                        style: ThemeProvider.sans(
                            size: 10,
                            color: ThemeProvider.greyColor,
                            letterSpacing: 1)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (value.couponDiscount > 0) ...[
                          Text(
                            elitePrice(
                              value.currencySide,
                              value.currencySymbol,
                              value.originalAmount,
                              digits: 2,
                            ),
                            style: ThemeProvider.sans(
                              size: 14,
                              color: ThemeProvider.greyColor,
                            ).copyWith(
                                decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          elitePrice(
                            value.currencySide,
                            value.currencySymbol,
                            value.payAmount,
                            digits: 2,
                          ),
                          style: ThemeProvider.price(
                              size: 28,
                              weight: FontWeight.w700,
                              color: ThemeProvider.gold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            color: ThemeProvider.backgroundColor,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SafeArea(
              child: EliteGoldButton(
                label: 'Proceed to Checkout  ›'.tr,
                onTap: value.onSlot,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _line({
    required String? cover,
    required String? title,
    required String subtitle,
    required String price,
    required String badge,
    required bool goldBadge,
    required VoidCallback onDelete,
  }) {
    return EliteCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}$cover',
                width: 78,
                height: 78,
                radius: BorderRadius.circular(10),
              ),
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: goldBadge ? ThemeProvider.gold : const Color(0xFF2A2A2A),
                  child: Text(
                    badge,
                    style: ThemeProvider.sans(
                      size: 8,
                      weight: FontWeight.w700,
                      color: goldBadge ? Colors.black : Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title ?? '',
                          style: ThemeProvider.serif(size: 16)),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Icon(Icons.delete_outline,
                          size: 18, color: ThemeProvider.greyColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.sans(
                        size: 11, color: ThemeProvider.greyColor)),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(price,
                      style: ThemeProvider.price(
                          size: 16,
                          weight: FontWeight.w700,
                          color: ThemeProvider.gold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bill(String label, String amount, {Color? amountColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: ThemeProvider.sans(size: 13)),
          const Spacer(),
          Text(
            amount,
            style: ThemeProvider.sans(
              size: 13,
              weight: FontWeight.w600,
              color: amountColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
