import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/selected_services_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class SelectedServicesScreen extends StatefulWidget {
  const SelectedServicesScreen({Key? key}) : super(key: key);

  @override
  State<SelectedServicesScreen> createState() => _SelectedServicesScreenState();
}

class _SelectedServicesScreenState extends State<SelectedServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectedServicesController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Wellness Services'.tr,
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _hero(value),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            (value.selectedServiceName).toUpperCase(),
                            style: ThemeProvider.serif(
                                size: 14, color: ThemeProvider.gold),
                          ),
                        ),
                        Text(
                          '${value.servicesList.length.toString().padLeft(2, '0')} TREATMENTS',
                          style: ThemeProvider.sans(
                            size: 11,
                            color: ThemeProvider.gold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (value.servicesList.isEmpty)
                      const EliteApiUnavailable(
                        minHeight: 160,
                        title: 'No treatments available',
                        icon: Icons.spa_outlined,
                      )
                    else
                      ...value.servicesList.asMap().entries.map(
                            (e) => _card(value, e.value, e.key),
                          ),
                  ],
                ),
          bottomNavigationBar: GetBuilder<ServiceCartController>(
            builder: (cart) {
              if (cart.totalItemsInCart <= 0) return const SizedBox.shrink();
              return Container(
                color: ThemeProvider.backgroundColor,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SafeArea(
                  child: EliteGoldButton(
                    label: 'BOOK NOW'.tr,
                    onTap: value.onCheckout,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _hero(SelectedServicesController value) {
    final cover = value.servicesList.isNotEmpty
        ? value.servicesList.first.cover
        : '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          EliteNetworkImage(
            url: '${Environments.imageURL}$cover',
            height: 170,
            width: double.infinity,
          ),
          Container(
            height: 170,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE60D0D0D)],
              ),
            ),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Elevated Care'.tr,
                    style: ThemeProvider.serif(
                        size: 26, color: ThemeProvider.gold)),
                Text('Precision-engineered treatments for the modern elite.'.tr,
                  style: ThemeProvider.sans(size: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(SelectedServicesController value, dynamic s, int index) {
    final selected = s.isChecked == true;
    final hasOffer = (s.discount ?? 0) > 0;
    final offerPrice = hasOffer ? s.off : s.price;
    final rating = (s.rating ?? 0) as num;
    final reviews = ((s.reviewCount ?? 0) > 0)
        ? s.reviewCount
        : (s.totalRating ?? 0);
    return EliteCard(
      padding: EdgeInsets.zero,
      borderColor: selected ? ThemeProvider.gold : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              EliteNetworkImage(
                url: '${Environments.imageURL}${s.cover}',
                height: 150,
                width: double.infinity,
                radius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              if (hasOffer)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeProvider.gold,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(s.discount as num).toStringAsFixed(0)}% OFF',
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: ThemeProvider.backgroundColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(s.name ?? '',
                          style: ThemeProvider.serif(
                              size: 18, color: ThemeProvider.gold)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          elitePrice(value.currencySide, value.currencySymbol,
                              offerPrice),
                          style: ThemeProvider.price(
                            size: 16,
                            weight: FontWeight.w700,
                            color: ThemeProvider.gold,
                          ),
                        ),
                        if (hasOffer)
                          Text(
                            elitePrice(value.currencySide, value.currencySymbol,
                                s.price),
                            style: ThemeProvider.sans(
                              size: 11,
                              color: ThemeProvider.greyColor,
                            ).copyWith(
                                decoration: TextDecoration.lineThrough),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${rating.toStringAsFixed(1)} ($reviews Reviews)',
                  style: ThemeProvider.sans(
                      size: 12, color: ThemeProvider.gold),
                ),
                if ((s.descriptions ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.descriptions!,
                    style: ThemeProvider.sans(
                        size: 12, color: ThemeProvider.greyColor),
                  ),
                ],
                const SizedBox(height: 12),
                EliteGoldButton(
                  label: selected ? 'SELECTED' : 'Book Consultation',
                  outlined: !selected,
                  onTap: () =>
                      value.updateServiceStatusInCart(index, !selected),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
