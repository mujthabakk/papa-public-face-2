import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:salon_user/app/controller/product_cart_controller.dart';
import 'package:salon_user/app/controller/product_payment_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/map_style.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class ProductPaymentScreen extends StatefulWidget {
  const ProductPaymentScreen({Key? key}) : super(key: key);

  @override
  State<ProductPaymentScreen> createState() => _ProductPaymentScreenState();
}

class _ProductPaymentScreenState extends State<ProductPaymentScreen> {
  String _addrTitle(int? t) {
    switch (t) {
      case 1:
        return 'Residence – Primary';
      case 2:
        return 'Office';
      case 3:
        return 'Other';
      default:
        return 'Address';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductPaymentController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Checkout',
            onMore: () {},
          ),
          body: value.paymentAPICalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _address(value),
                    const SizedBox(height: 16),
                    _payments(value),
                    const SizedBox(height: 16),
                    _wallet(value),
                    const SizedBox(height: 16),
                    EliteCard(
                      child: TextField(
                        controller: value.notesEditor,
                        maxLines: 3,
                        style: ThemeProvider.sans(size: 13),
                        decoration: InputDecoration(
                          hintText: 'Add delivery notes...',
                          hintStyle: ThemeProvider.sans(
                              size: 13, color: ThemeProvider.greyColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _summary(value),
                    const SizedBox(height: 12),
                    _promo(value),
                  ],
                ),
        );
      },
    );
  }

  Widget _header(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: ThemeProvider.gold, size: 18),
          const SizedBox(width: 8),
          Text(title,
              style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold)),
        ],
      ),
    );
  }

  Widget _address(ProductPaymentController value) {
    final lat = double.tryParse(value.addressInfo.lat ?? '') ?? 0;
    final lng = double.tryParse(value.addressInfo.lng ?? '') ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(Icons.location_on_outlined, 'Delivery Address'),
        EliteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.home_outlined,
                        color: ThemeProvider.gold, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      value.haveAddress
                          ? _addrTitle(value.addressInfo.title)
                          : 'Add address',
                      style: ThemeProvider.serif(size: 15),
                    ),
                  ),
                  GestureDetector(
                    onTap: value.onSelectAddress,
                    child: Text('Change',
                        style: ThemeProvider.sans(
                            size: 12, color: ThemeProvider.gold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value.haveAddress
                    ? '${value.addressInfo.house ?? ''} ${value.addressInfo.address ?? ''} ${value.addressInfo.landmark ?? ''} ${value.addressInfo.pincode ?? ''}'
                    : 'Please add your delivery address',
                style: ThemeProvider.sans(
                    size: 12, color: ThemeProvider.greyColor),
              ),
              if (value.haveAddress && lat != 0) ...[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 110,
                    child: GoogleMap(
                      style: Utils.mapStyles,
                      markers: {
                        Marker(
                          markerId: const MarkerId('addr'),
                          position: LatLng(lat, lng),
                        ),
                      },
                      initialCameraPosition:
                          CameraPosition(target: LatLng(lat, lng), zoom: 14),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      liteModeEnabled: true,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _payments(ProductPaymentController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(Icons.account_balance_wallet_outlined, 'Payment Method'),
        ...List.generate(value.paymentList.length, (i) {
          if (!value.checkPremium && i == 0) return const SizedBox.shrink();
          final p = value.paymentList[i];
          final selected = p.id == value.paymentId;
          return GestureDetector(
            onTap: () => value.selectPaymentMethod(p.id as int),
            child: EliteCard(
              borderColor: selected ? ThemeProvider.gold : null,
              child: Row(
                children: [
                  EliteNetworkImage(
                    url: '${Environments.imageURL}${p.cover}',
                    width: 40,
                    height: 40,
                    radius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name ?? '',
                            style: ThemeProvider.sans(
                                size: 14, weight: FontWeight.w600)),
                        if (selected)
                          Text('Default',
                              style: ThemeProvider.sans(
                                  size: 11, color: ThemeProvider.gold)),
                      ],
                    ),
                  ),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected
                        ? ThemeProvider.gold
                        : ThemeProvider.greyColor,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _wallet(ProductPaymentController value) {
    return EliteCard(
      borderColor: value.isWalletChecked ? ThemeProvider.gold : null,
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined,
              color: ThemeProvider.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Elite Rewards Points',
                    style: ThemeProvider.sans(
                        size: 14, weight: FontWeight.w600)),
                Text(
                  'Balance: ${elitePrice(value.currencySide, value.currencySymbol, value.balance, digits: 2)}',
                  style: ThemeProvider.sans(
                      size: 11, color: ThemeProvider.greyColor),
                ),
              ],
            ),
          ),
          Switch(
            value: value.isWalletChecked,
            activeThumbColor: ThemeProvider.gold,
            onChanged: value.balance <= 0 || value.offerName.isNotEmpty
                ? null
                : (v) => value.updateWalletChecked(v),
          ),
        ],
      ),
    );
  }

  Widget _summary(ProductPaymentController value) {
    final cart = Get.find<ProductCartController>();
    return EliteCard(
      borderColor: ThemeProvider.gold.withValues(alpha: 0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: ThemeProvider.serif(size: 22)),
          const Divider(color: Color(0xFF2A2A2A)),
          ...cart.savedInCart.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(p.name ?? '',
                          style: ThemeProvider.sans(size: 13)),
                    ),
                    Text(
                      elitePrice(value.currencySide, value.currencySymbol,
                          (p.discount ?? 0) > 0
                              ? (p.sellPrice ?? 0) * p.quantity
                              : (p.originalPrice ?? 0) * p.quantity,
                          digits: 2),
                      style: ThemeProvider.sans(
                          size: 13, weight: FontWeight.w600),
                    ),
                  ],
                ),
              )),
          const Divider(color: Color(0xFF2A2A2A)),
          _row(
              'Subtotal',
              elitePrice(value.currencySide, value.currencySymbol,
                  cart.totalPrice,
                  digits: 2)),
          if (value.discount > 0)
            _row(
                'Coupon',
                '-${elitePrice(value.currencySide, value.currencySymbol, value.discount, digits: 2)}'),
          if (value.isWalletChecked && value.walletDiscount > 0)
            _row(
                'Wallet',
                '-${elitePrice(value.currencySide, value.currencySymbol, value.walletDiscount, digits: 2)}'),
          _row(
              'Delivery',
              elitePrice(value.currencySide, value.currencySymbol,
                  value.deliveryPrice,
                  digits: 2)),
          _row(
              'Tax',
              elitePrice(value.currencySide, value.currencySymbol,
                  value.taxAmount,
                  digits: 2)),
          const Divider(color: Color(0xFF2A2A2A)),
          Text('TOTAL AMOUNT',
              style: ThemeProvider.sans(
                  size: 10, color: ThemeProvider.gold, letterSpacing: 1)),
          Row(
            children: [
              Text(
                elitePrice(value.currencySide, value.currencySymbol,
                    value.grandTotal,
                    digits: 2),
                style: ThemeProvider.serif(
                    size: 32, color: ThemeProvider.gold),
              ),
              const Spacer(),
              Text('Tax Included',
                  style: ThemeProvider.sans(
                      size: 11, color: ThemeProvider.greyColor)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: value.onPayment,
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
                  const Icon(Icons.lock_outline, size: 16),
                  const SizedBox(width: 8),
                  Text('Pay Now',
                      style:
                          ThemeProvider.serif(size: 18, color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String amount) {
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

  Widget _promo(ProductPaymentController value) {
    return GestureDetector(
      onTap: () {
        if (value.isWalletChecked == false) {
          value.onCoupon(
            value.offerId,
            value.offerName,
            Get.find<ProductCartController>().totalPrice.toStringAsFixed(2),
          );
        }
      },
      child: EliteCard(
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined, color: ThemeProvider.gold),
            const SizedBox(width: 10),
            Text(
              value.offerName.isEmpty ? 'PROMO CODE' : value.offerName,
              style: ThemeProvider.sans(size: 13, weight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              value.offerName.isEmpty ? 'Apply' : 'Change',
              style: ThemeProvider.sans(
                  size: 13,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold),
            ),
          ],
        ),
      ),
    );
  }
}
