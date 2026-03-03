import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';
import 'package:salon_user/app/util/theme.dart';

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
          appBar: AppBar(
            backgroundColor: ThemeProvider.appColor,
            iconTheme: const IconThemeData(color: ThemeProvider.whiteColor),
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Wallet'.tr,
              style: ThemeProvider.titleStyle,
            ),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: ThemeProvider.appColor,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading wallet data...',
                        style: TextStyle(
                          color: ThemeProvider.greyColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Balance Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            ThemeProvider.appColor,
                            ThemeProvider.appColor.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ThemeProvider.appColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Available Balance'.tr,
                            style: TextStyle(
                              color: ThemeProvider.whiteColor.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          value.currencySide == 'left'
                              ? Text(
                                  '${value.currencySymbol}${value.amount}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeProvider.whiteColor,
                                  ),
                                )
                              : Text(
                                  '${value.amount}${value.currencySymbol}',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: ThemeProvider.whiteColor,
                                  ),
                                ),
                        ],
                      ),
                    ),

                    // Transaction History Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: ThemeProvider.greyColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Transaction History'.tr,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ThemeProvider.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Transaction List or No Data
                    Expanded(
                      child: value.walletList.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: ThemeProvider.appColor
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 64,
                                      color: ThemeProvider.appColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'No Transactions Yet'.tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeProvider.blackColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Your wallet transactions will appear here\nonce you make your first transaction.'
                                        .tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: ThemeProvider.greyColor,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: ThemeProvider.whiteColor,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                padding: const EdgeInsets.all(8),
                                itemCount: value.walletList.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 1,
                                  color: ThemeProvider.greyColor,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Transaction Icon
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: ThemeProvider.appColor
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.account_balance_wallet,
                                            color: ThemeProvider.appColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Transaction Details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                value.walletList[index].type
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      ThemeProvider.blackColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Text(
                                              //   value.walletList[index].uuid
                                              //       .toString(),
                                              //   style: TextStyle(
                                              //     fontSize: 12,
                                              //     color:
                                              //         ThemeProvider.greyColor,
                                              //   ),
                                              // ),
                                              // const SizedBox(height: 4),
                                              Text(
                                                value
                                                    .walletList[index].createdAt
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      ThemeProvider.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Amount
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            value.currencySide == 'left'
                                                ? Text(
                                                    '${value.currencySymbol}${value.walletList[index].amount}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ThemeProvider
                                                          .appColor,
                                                    ),
                                                  )
                                                : Text(
                                                    '${value.walletList[index].amount}${value.currencySymbol}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ThemeProvider
                                                          .appColor,
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
