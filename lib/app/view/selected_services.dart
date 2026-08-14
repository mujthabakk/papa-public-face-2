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
            title: 'Wellness Services',
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
                    label: 'BOOK NOW',
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
                Text('Elevated Care',
                    style: ThemeProvider.serif(
                        size: 26, color: ThemeProvider.gold)),
                Text(
                  'Precision-engineered treatments for the modern elite.',
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
    return EliteCard(
      padding: EdgeInsets.zero,
      borderColor: selected ? ThemeProvider.gold : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EliteNetworkImage(
            url: '${Environments.imageURL}${s.cover}',
            height: 150,
            width: double.infinity,
            radius: const BorderRadius.vertical(top: Radius.circular(14)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(s.name ?? '',
                          style: ThemeProvider.serif(
                              size: 18, color: ThemeProvider.gold)),
                    ),
                    Text(
                      '${elitePrice(value.currencySide, value.currencySymbol, (s.discount ?? 0) > 0 ? s.off : s.price)} / session',
                      style: ThemeProvider.sans(
                          size: 12, color: Colors.white70),
                    ),
                  ],
                ),
                if ((s.descriptions ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.descriptions!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
