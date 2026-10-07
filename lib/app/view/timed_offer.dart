import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/timed_offer_model.dart';
import 'package:salon_user/app/controller/timed_offer_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class TimedOfferScreen extends StatelessWidget {
  const TimedOfferScreen({Key? key}) : super(key: key);

  String _imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return '${Environments.imageURL}$path';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TimedOfferController>(
      builder: (value) {
        final header = value.header;
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: value.showAllCampaigns
                ? 'Shop Discounts'.tr
                : (value.campaignName.isNotEmpty
                    ? value.campaignName
                    : (header?.name ?? 'Flash Offer')),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.rows.isEmpty
                  ? const EliteApiUnavailable(
                      title: 'No timed offers right now',
                      subtitle: 'Check back soon for new deals.',
                      icon: Icons.timer_outlined,
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: value.showAllCampaigns
                          ? [
                              for (final group in value.campaignGroups) ...[
                                ..._campaignBlock(value, group),
                                const SizedBox(height: 12),
                              ],
                            ]
                          : _campaignBlock(value, value.rows),
                    ),
        );
      },
    );
  }

  List<Widget> _campaignBlock(
    TimedOfferController value,
    List<TimedOfferRow> rows,
  ) {
    if (rows.isEmpty) return [];
    final header = rows.firstWhere(
      (r) => r.isCouponOnly,
      orElse: () => rows.first,
    );
    TimedOfferRow? coupon;
    for (final row in rows) {
      if (row.isCouponOnly && row.displayCode.isNotEmpty) {
        coupon = row;
        break;
      }
    }
    final couponRow = coupon;
    final bookable = rows.where((r) => r.hasPartner).toList();
    return [
      if (value.showAllCampaigns && (header.name ?? '').isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            header.name!,
            style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
          ),
        ),
      if (_imageUrl(header.image ?? header.cover ?? value.campaignImage)
          .isNotEmpty) ...[
        const SizedBox(height: 8),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: EliteNetworkImage(
            url: _imageUrl(
                header.image ?? header.cover ?? value.campaignImage),
            height: 150,
            radius: BorderRadius.circular(12),
          ),
        ),
      ],
      if ((header.discountText ?? '').isNotEmpty)
        Text(
          header.discountText!,
          style: ThemeProvider.sans(
            size: 22,
            weight: FontWeight.w800,
            color: ThemeProvider.gold,
          ),
        ),
      if ((header.description ?? header.shortDescription ?? '').isNotEmpty) ...[
        const SizedBox(height: 6),
        Text(
          header.description ?? header.shortDescription ?? '',
          style: ThemeProvider.sans(size: 13, color: Colors.white70),
        ),
      ],
      if (header.scheduleHint.isNotEmpty) ...[
        const SizedBox(height: 8),
        Text(
          header.scheduleHint,
          style: ThemeProvider.sans(
            size: 12,
            color: header.isScheduleActive
                ? ThemeProvider.gold
                : ThemeProvider.greyColor,
          ),
        ),
      ],
      if (header.timeWindowText.isNotEmpty &&
          header.timeWindowText != header.scheduleHint) ...[
        const SizedBox(height: 4),
        Text(
          header.timeWindowText,
          style: ThemeProvider.sans(size: 11, color: ThemeProvider.greyColor),
        ),
      ],
      if (couponRow != null) ...[
        const SizedBox(height: 16),
        EliteCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COUPON CODE'.tr,
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.greyColor,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      couponRow.displayCode,
                      style: ThemeProvider.serif(
                          size: 20, color: ThemeProvider.gold),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => value.copyCode(couponRow),
                icon: const Icon(Icons.copy, size: 14),
                label: Text(
                  'Copy Code'.tr,
                  style: ThemeProvider.sans(size: 11, weight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeProvider.gold,
                  disabledForegroundColor: ThemeProvider.greyColor,
                  side: BorderSide(
                    color: couponRow.isScheduleActive
                        ? ThemeProvider.gold
                        : ThemeProvider.greyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      ...bookable.expand((row) {
        if (row.services.isEmpty) {
          return [_salonBookCard(value, row)];
        }
        return row.services.map((service) => _serviceCard(value, row, service));
      }),
    ];
  }

  Widget _salonBookCard(TimedOfferController value, TimedOfferRow row) {
    final partner = row.partner!;
    final cover = _imageUrl(
      partner.coverPath.isNotEmpty ? partner.coverPath : row.displayImage,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EliteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _partnerHeader(partner, cover, row),
            const SizedBox(height: 12),
            if (!row.isScheduleActive && row.scheduleHint.isNotEmpty) ...[
              Text(
                row.scheduleHint,
                style: ThemeProvider.sans(
                  size: 11,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
            EliteGoldButton(
              label: 'BOOK NOW'.tr,
              enabled: row.isScheduleActive,
              onTap: () => value.bookRow(row),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(
    TimedOfferController value,
    TimedOfferRow row,
    OfferServiceModel service,
  ) {
    final partner = row.partner!;
    final cover = _imageUrl(
      partner.coverPath.isNotEmpty ? partner.coverPath : row.displayImage,
    );
    final img = _imageUrl(
      service.coverPath.isNotEmpty ? service.coverPath : row.displayImage,
    );
    final original = service.originalPrice ?? service.price ?? 0;
    final offer = service.offerPrice ?? service.amount ?? 0;
    final price = offer > 0 ? offer : original;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EliteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _partnerHeader(partner, cover, row),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: img.isEmpty
                  ? Container(
                      height: 140,
                      width: double.infinity,
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(Icons.spa_outlined,
                          color: ThemeProvider.gold, size: 36),
                    )
                  : SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: EliteNetworkImage(
                        url: img,
                        height: 140,
                        radius: BorderRadius.circular(12),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              service.name ?? '',
              style: ThemeProvider.serif(size: 18),
            ),
            if ((row.discountText ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                row.discountText!,
                style: ThemeProvider.sans(
                  size: 12,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
            ],
            if (price > 0) ...[
              const SizedBox(height: 4),
              Text(
                elitePrice('', '', price),
                style: ThemeProvider.price(
                  size: 16,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
              if (original > 0 && offer > 0 && original > offer)
                Text(
                  elitePrice('', '', original),
                  style: ThemeProvider.sans(
                    size: 12,
                    color: ThemeProvider.greyColor,
                  ).copyWith(decoration: TextDecoration.lineThrough),
                ),
            ],
            const SizedBox(height: 12),
            if (!row.isScheduleActive && row.scheduleHint.isNotEmpty) ...[
              Text(
                row.scheduleHint,
                style: ThemeProvider.sans(
                  size: 11,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
            EliteGoldButton(
              label: 'BOOK NOW'.tr,
              enabled: row.isScheduleActive,
              onTap: () => value.bookRow(row, service: service),
            ),
          ],
        ),
      ),
    );
  }

  Widget _partnerHeader(OfferPartnerModel partner, String cover, TimedOfferRow row) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: cover.isEmpty
              ? Container(
                  width: 48,
                  height: 48,
                  color: ThemeProvider.gold.withOpacity(0.2),
                  child: const Icon(Icons.storefront, color: ThemeProvider.gold),
                )
              : EliteNetworkImage(url: cover, width: 48, height: 48),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                partner.displayName,
                style: ThemeProvider.serif(size: 15),
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
              if (row.displayCode.isNotEmpty)
                Text(
                  row.displayCode,
                  style: ThemeProvider.sans(
                    size: 11,
                    weight: FontWeight.w700,
                    color: ThemeProvider.gold,
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
      ],
    );
  }
}
