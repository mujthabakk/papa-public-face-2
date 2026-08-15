import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
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
                    if (Get.isRegistered<WalletController>())
                      EliteCard(
                        child: Column(
                          children: [
                            Text(
                              'AVAILABLE BALANCE'.tr,
                              style: ThemeProvider.sans(
                                size: 11,
                                weight: FontWeight.w700,
                                color: ThemeProvider.greyColor,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              elitePrice(
                                Get.find<WalletController>().currencySide,
                                Get.find<WalletController>().currencySymbol,
                                Get.find<WalletController>().amount,
                              ),
                              style: ThemeProvider.serif(
                                  size: 36, color: ThemeProvider.gold),
                            ),
                            const SizedBox(height: 14),
                            OutlinedButton.icon(
                              onPressed: () {
                                Get.delete<WalletController>(force: true);
                                Get.toNamed(AppRouter.getWalletRoutes());
                              },
                              icon: const Icon(Icons.description_outlined,
                                  size: 16, color: Colors.white70),
                              label: Text(
                                'HISTORY'.tr,
                                style: ThemeProvider.sans(
                                  size: 11,
                                  weight: FontWeight.w700,
                                  color: ThemeProvider.gold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF3A3A3A)),
                                foregroundColor: ThemeProvider.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (Get.isRegistered<WalletController>())
                      const SizedBox(height: 16),
                    if (value.couponList.isEmpty)
                      const EliteApiUnavailable(minHeight: 180)
                    else
                      ...value.couponList.map((c) => _couponCard(value, c)),
                  ],
                ),
          bottomNavigationBar: value.action == 'browse'
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    child: EliteGoldButton(
                      label: 'APPLY COUPON',
                      onTap: value.onSaveCoupon,
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _couponCard(CouponController value, CouponsModel coupon) {
    final selected = value.selectedCouponCode == coupon.id.toString();
    final days = _daysLeft(coupon.expire);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coupon.name ?? 'Reward',
            style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              EliteCard(
                borderColor: selected
                    ? ThemeProvider.gold
                    : const Color(0xFF2C2C2C),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if ((coupon.shortDescriptions ?? '').isNotEmpty)
                      Text(
                        coupon.shortDescriptions ?? '',
                        style: ThemeProvider.sans(
                            size: 13, color: Colors.white70),
                      ),
                    if ((coupon.expire ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${'Valid until'.tr}: ${coupon.expire}'.toUpperCase(),
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.greyColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ThemeProvider.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'COUPON CODE',
                                  style: ThemeProvider.sans(
                                    size: 10,
                                    color: ThemeProvider.greyColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  coupon.code ?? '',
                                  style: ThemeProvider.serif(
                                      size: 18, color: ThemeProvider.gold),
                                ),
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: coupon.code ?? ''));
                              successToast('Code copied');
                              value.saveCoupon(coupon.id as int);
                            },
                            icon: const Icon(Icons.copy, size: 14),
                            label: Text(
                              'Copy Code',
                              style: ThemeProvider.sans(
                                  size: 11, weight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ThemeProvider.gold,
                              side: const BorderSide(color: ThemeProvider.gold),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (days != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ThemeProvider.gold,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$days DAYS LEFT',
                      style: ThemeProvider.sans(
                        size: 9,
                        weight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  int? _daysLeft(String? expire) {
    if (expire == null || expire.isEmpty) return null;
    try {
      final d = DateFormat('yyyy-MM-dd').parse(expire);
      final days = d.difference(DateTime.now()).inDays;
      return days < 0 ? 0 : days;
    } catch (_) {
      return null;
    }
  }
}
