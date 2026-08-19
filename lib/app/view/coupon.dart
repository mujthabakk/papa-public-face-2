import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/controller/coupon_controller.dart';
import 'package:salon_user/app/controller/wallet_controller.dart';
import 'package:salon_user/app/env.dart';
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
            title: value.action == 'browse'
                ? 'Exclusive Offers'
                : 'Redeem Rewards',
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
    final scopeLabel = coupon.isPublicScope ? 'PUBLIC' : 'PARTNER';
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coupon.name ?? 'Reward',
                  style:
                      ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeProvider.gold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: ThemeProvider.gold),
                ),
                child: Text(
                  coupon.discountLabel,
                  style: ThemeProvider.sans(
                    size: 10,
                    weight: FontWeight.w800,
                    color: ThemeProvider.gold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          EliteCard(
            borderColor: selected
                ? ThemeProvider.gold
                : const Color(0xFF2C2C2C),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _chip(scopeLabel),
                        if ((coupon.upto ?? 0) > 0)
                          _chip('UP TO ₹${coupon.upto!.toStringAsFixed(0)}'),
                        if (days != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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
                      ],
                    ),
                    if ((coupon.shortDescriptions ?? '').isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        coupon.shortDescriptions ?? '',
                        style: ThemeProvider.sans(
                            size: 13, color: Colors.white70),
                      ),
                    ],
                    if (coupon.partners.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'VALID AT',
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.greyColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...coupon.partners
                          .map((p) => _partnerCard(value, p)),
                    ],
                    if (coupon.services.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'SERVICES',
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.greyColor,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 158,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: coupon.services.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) =>
                              _serviceCard(coupon.services[i]),
                        ),
                      ),
                    ],
                    if (coupon.canBook) ...[
                      const SizedBox(height: 14),
                      EliteGoldButton(
                        label: 'BOOK NOW',
                        onTap: () => value.bookOffer(coupon),
                      ),
                    ],
                    if ((coupon.minCartValue ?? 0) > 0 ||
                        (coupon.startDate ?? '').isNotEmpty ||
                        (coupon.expire ?? '').isNotEmpty) ...[
                      const SizedBox(height: 10),
                      if ((coupon.minCartValue ?? 0) > 0)
                        Text(
                          'Min cart: ₹${coupon.minCartValue!.toStringAsFixed(0)}',
                          style: ThemeProvider.sans(
                            size: 11,
                            color: ThemeProvider.greyColor,
                          ),
                        ),
                      if ((coupon.startDate ?? '').isNotEmpty)
                        Text(
                          'Starts: ${coupon.startDate}',
                          style: ThemeProvider.sans(
                            size: 10,
                            color: ThemeProvider.greyColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      if ((coupon.expire ?? '').isNotEmpty)
                        Text(
                          '${'Valid until'.tr}: ${coupon.expire}'
                              .toUpperCase(),
                          style: ThemeProvider.sans(
                            size: 10,
                            color: ThemeProvider.greyColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                    ],
                    if (!coupon.canBook || value.action != 'browse') ...[
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
                                if (value.action != 'browse' &&
                                    coupon.id != null) {
                                  value.saveCoupon(coupon.id!);
                                }
                              },
                              icon: const Icon(Icons.copy, size: 14),
                              label: Text(
                                'Copy Code',
                                style: ThemeProvider.sans(
                                    size: 11, weight: FontWeight.w600),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ThemeProvider.gold,
                                side: const BorderSide(
                                    color: ThemeProvider.gold),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: ThemeProvider.sans(
          size: 10,
          weight: FontWeight.w700,
          color: Colors.white70,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _partnerCard(CouponController value, OfferPartnerModel partner) {
    final cover = _imageUrl(partner.coverPath);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => value.openPartner(partner),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: cover.isEmpty
                    ? Container(
                        width: 56,
                        height: 56,
                        color: ThemeProvider.gold.withOpacity(0.2),
                        child: const Icon(Icons.storefront,
                            size: 22, color: ThemeProvider.gold),
                      )
                    : EliteNetworkImage(url: cover, width: 56, height: 56),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.displayName.isEmpty
                          ? 'Partner'
                          : partner.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeProvider.sans(
                        size: 13,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    if ((partner.type ?? '').isNotEmpty)
                      Text(
                        partner.type!.toUpperCase(),
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.gold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    if ((partner.address ?? '').isNotEmpty)
                      Text(
                        partner.address!.replaceAll('\n', ', '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: ThemeProvider.sans(
                          size: 11,
                          color: ThemeProvider.greyColor,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ThemeProvider.gold),
            ],
          ),
        ),
      ),
    );
  }

  Widget _serviceCard(OfferServiceModel service) {
    final cover = _imageUrl(service.coverPath);
    final price = service.price ?? service.amount ?? 0;
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: cover.isEmpty
                ? Container(
                    height: 90,
                    width: 140,
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(Icons.spa_outlined,
                        color: ThemeProvider.gold),
                  )
                : EliteNetworkImage(
                    url: cover,
                    width: 140,
                    height: 90,
                    radius: BorderRadius.circular(10),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            service.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: ThemeProvider.sans(
              size: 12,
              weight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          if (price > 0)
            Text(
              '₹${price.toStringAsFixed(0)}',
              style: ThemeProvider.sans(
                size: 12,
                weight: FontWeight.w700,
                color: ThemeProvider.gold,
              ),
            ),
        ],
      ),
    );
  }

  String _imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    return '${Environments.imageURL}$path';
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
