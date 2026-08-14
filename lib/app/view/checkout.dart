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
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (value) {
        final cart = Get.find<ServiceCartController>();
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'My Cart',
            onMore: () {},
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Text('Cart Selection',
                  style: ThemeProvider.serif(size: 28, weight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(
                'Review your premium wellness curated list.',
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
                    GestureDetector(
                      onTap: value.onCoupon,
                      child: Row(
                        children: [
                          Text(
                            'REDEEM COUPON',
                            style: ThemeProvider.sans(
                              size: 10,
                              color: ThemeProvider.gold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Text('APPLY',
                              style: ThemeProvider.sans(
                                  size: 12,
                                  weight: FontWeight.w700,
                                  color: ThemeProvider.gold)),
                        ],
                      ),
                    ),
                    const Divider(color: Color(0xFF2A2A2A), height: 24),
                    _bill('Subtotal',
                        elitePrice(value.currencySide, value.currencySymbol,
                            cart.totalPrice,
                            digits: 2)),
                    _bill(
                        'Service Tax (${cart.orderTax}%)',
                        elitePrice(value.currencySide, value.currencySymbol,
                            cart.taxAmount,
                            digits: 2)),
                    _bill(
                        'Service Charge (${cart.serviceCharge}%)',
                        elitePrice(value.currencySide, value.currencySymbol,
                            cart.serviceChargeAmount,
                            digits: 2)),
                    const SizedBox(height: 8),
                    Text('TOTAL AMOUNT',
                        style: ThemeProvider.sans(
                            size: 10,
                            color: ThemeProvider.greyColor,
                            letterSpacing: 1)),
                    Text(
                      elitePrice(value.currencySide, value.currencySymbol,
                          cart.grandTotal,
                          digits: 2),
                      style: ThemeProvider.serif(
                          size: 32, color: ThemeProvider.gold),
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
                label: 'Proceed to Checkout  ›',
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
                      style: ThemeProvider.serif(
                          size: 18, color: ThemeProvider.gold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bill(String label, String amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(label, style: ThemeProvider.sans(size: 13)),
          const Spacer(),
          Text(amount,
              style: ThemeProvider.sans(size: 13, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}
