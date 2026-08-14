import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/cart_controller.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _coupon = TextEditingController();

  @override
  void dispose() {
    _coupon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(
            showBack: true,
            title: 'My Cart',
            onMore: _noop,
          ),
          body: value.savedInCart.isEmpty
              ? _empty()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    Text('Cart Selection',
                        style: ThemeProvider.serif(
                            size: 28, weight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      'Review your premium wellness curated list.',
                      style: ThemeProvider.sans(
                          size: 13, color: ThemeProvider.greyColor),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      value.savedInCart.length,
                      (i) => _item(value, i),
                    ),
                    _summary(value),
                  ],
                ),
          bottomNavigationBar:
              value.savedInCart.isEmpty ? null : _bottom(value),
        );
      },
    );
  }

  static void _noop() {}

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined,
              size: 56, color: ThemeProvider.gold),
          const SizedBox(height: 16),
          Text('Your cart is empty', style: ThemeProvider.serif(size: 22)),
          const SizedBox(height: 20),
          EliteGoldButton(label: 'Continue Shopping', onTap: () => Get.back()),
        ],
      ),
    );
  }

  Widget _item(CartController value, int index) {
    final item = value.savedInCart[index];
    return EliteCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}${item.cover}',
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
                  color: const Color(0xFF2A2A2A),
                  child: Text(
                    'PRODUCT',
                    style: ThemeProvider.sans(size: 8, letterSpacing: 0.6),
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
                      child: Text(item.name ?? '',
                          style: ThemeProvider.serif(size: 16)),
                    ),
                    GestureDetector(
                      onTap: () => value.deleteProductFromCart(index),
                      child: const Icon(Icons.delete_outline,
                          size: 18, color: ThemeProvider.greyColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.descriptions ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.sans(
                      size: 11, color: ThemeProvider.greyColor),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    EliteQtyStepper(
                      quantity: item.quantity,
                      onMinus: () => value.updateProductQuantityRemove(index),
                      onPlus: () => value.updateProductQuantity(index),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          elitePrice(value.currencySide, value.currencySymbol,
                              value.getFinalTotal(index),
                              digits: 2),
                          style: ThemeProvider.serif(
                              size: 18, color: ThemeProvider.gold),
                        ),
                        Text(
                          '${elitePrice(value.currencySide, value.currencySymbol, item.sellPrice, digits: 2)} each',
                          style: ThemeProvider.sans(
                              size: 10, color: ThemeProvider.greyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(CartController value) {
    final productCart = Get.find<ProductCartController>();
    final remaining = (120 - productCart.totalPrice).clamp(0, 120);
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REDEEM COUPON',
            style: ThemeProvider.sans(
              size: 10,
              color: ThemeProvider.gold,
              letterSpacing: 1.2,
            ),
          ),
          TextField(
            controller: _coupon,
            style: ThemeProvider.sans(size: 14),
            decoration: InputDecoration(
              hintText: 'Enter code',
              hintStyle:
                  ThemeProvider.sans(size: 13, color: ThemeProvider.greyColor),
              suffixIcon: TextButton(
                onPressed: () {},
                child: Text('APPLY',
                    style: ThemeProvider.sans(
                        size: 12,
                        weight: FontWeight.w700,
                        color: ThemeProvider.gold)),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF2A2A2A)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ThemeProvider.gold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _bill('Subtotal',
              elitePrice(value.currencySide, value.currencySymbol,
                  productCart.totalPrice,
                  digits: 2)),
          _bill(
              'Product Tax (${productCart.orderTax}%)',
              elitePrice(value.currencySide, value.currencySymbol,
                  productCart.taxAmount,
                  digits: 2)),
          const SizedBox(height: 10),
          Text('TOTAL AMOUNT',
              style: ThemeProvider.sans(
                  size: 10, color: ThemeProvider.greyColor, letterSpacing: 1)),
          Row(
            children: [
              Text(
                elitePrice(value.currencySide, value.currencySymbol,
                    productCart.grandTotal,
                    digits: 2),
                style: ThemeProvider.serif(
                    size: 32, color: ThemeProvider.gold),
              ),
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 10,
                backgroundColor: ThemeProvider.gold,
                child: Icon(Icons.check, size: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2A2A2A)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: ThemeProvider.gold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: ThemeProvider.sans(size: 12, color: Colors.white70),
                      children: [
                        const TextSpan(text: 'Add '),
                        TextSpan(
                          text: elitePrice(value.currencySide,
                              value.currencySymbol, remaining,
                              digits: 2),
                          style: const TextStyle(color: ThemeProvider.gold),
                        ),
                        const TextSpan(
                            text: ' more to unlock Elite Concierge delivery.'),
                      ],
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

  Widget _bottom(CartController value) {
    return Container(
      color: ThemeProvider.backgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: value.onCheckout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.gold,
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Proceed to Checkout',
                        style: ThemeProvider.serif(size: 18, color: Colors.black)),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, size: 16, color: ThemeProvider.greyColor),
                SizedBox(width: 16),
                Icon(Icons.payments_outlined,
                    size: 16, color: ThemeProvider.greyColor),
                SizedBox(width: 16),
                Icon(Icons.account_balance_wallet_outlined,
                    size: 16, color: ThemeProvider.greyColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
