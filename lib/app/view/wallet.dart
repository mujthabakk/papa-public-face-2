import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Redeem Rewards',
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    EliteCard(
                      child: Column(
                        children: [
                          Text(
                            'AVAILABLE BALANCE',
                            style: ThemeProvider.sans(
                              size: 11,
                              weight: FontWeight.w700,
                              color: ThemeProvider.greyColor,
                              letterSpacing: 1.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                NumberFormat('#,###').format(value.amount.round()),
                                style: ThemeProvider.serif(
                                    size: 36, color: ThemeProvider.gold),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  'Wallet'.tr,
                                  style: ThemeProvider.sans(
                                      size: 13, color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            elitePrice(value.currencySide, value.currencySymbol,
                                value.amount,
                                digits: 2),
                            style: ThemeProvider.sans(
                                size: 12, color: ThemeProvider.gold),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'HISTORY',
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: ThemeProvider.greyColor,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (value.walletList.isEmpty)
                      const EliteApiUnavailable()
                    else
                      ...value.walletList.map((tx) {
                        final credit =
                            (tx.type ?? '').toLowerCase().contains('credit') ||
                                (tx.type ?? '').toLowerCase().contains('add');
                        return EliteCard(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: ThemeProvider.backgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  credit
                                      ? Icons.star
                                      : Icons.lock_outline,
                                  color: credit
                                      ? ThemeProvider.gold
                                      : ThemeProvider.greyColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (tx.type ?? 'Transaction').toUpperCase(),
                                      style: ThemeProvider.serif(size: 16),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      tx.createdAt ?? '',
                                      style: ThemeProvider.sans(
                                          size: 12,
                                          color: ThemeProvider.greyColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                elitePrice(
                                  value.currencySide,
                                  value.currencySymbol,
                                  double.tryParse(tx.amount ?? '0') ?? 0,
                                  digits: 2,
                                ),
                                style: ThemeProvider.sans(
                                  size: 13,
                                  weight: FontWeight.w700,
                                  color: credit
                                      ? ThemeProvider.gold
                                      : ThemeProvider.greyColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
        );
      },
    );
  }
}
