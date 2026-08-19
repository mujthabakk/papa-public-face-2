import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            title: value.campaignName.isNotEmpty
                ? value.campaignName
                : (header?.name ?? 'Flash Offer'),
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : value.rows.isEmpty
                  ? const EliteApiUnavailable()
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      children: [
                        if ((header?.discountText ?? '').isNotEmpty)
                          Text(
                            header!.discountText!,
                            style: ThemeProvider.sans(
                              size: 22,
                              weight: FontWeight.w800,
                              color: ThemeProvider.gold,
                            ),
                          ),
                        if ((header?.description ??
                                header?.shortDescription ??
                                '')
                            .isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            header?.description ??
                                header?.shortDescription ??
                                '',
                            style: ThemeProvider.sans(
                                size: 13, color: Colors.white70),
                          ),
                        ],
                        if ((header?.scheduleHint ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            header!.scheduleHint,
                            style: ThemeProvider.sans(
                              size: 12,
                              color: header.isScheduleActive
                                  ? ThemeProvider.gold
                                  : ThemeProvider.greyColor,
                            ),
                          ),
                        ],
                        if ((header?.timeWindowText ?? '').isNotEmpty &&
                            header!.timeWindowText != header.scheduleHint) ...[
                          const SizedBox(height: 4),
                          Text(
                            header.timeWindowText,
                            style: ThemeProvider.sans(
                              size: 11,
                              color: ThemeProvider.greyColor,
                            ),
                          ),
                        ],
                        if (value.couponRow != null) ...[
                          const SizedBox(height: 16),
                          EliteCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        value.couponRow!.displayCode,
                                        style: ThemeProvider.serif(
                                            size: 20,
                                            color: ThemeProvider.gold),
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: value.couponRow!.isScheduleActive
                                      ? () =>
                                          value.copyCode(value.couponRow!)
                                      : null,
                                  icon: const Icon(Icons.copy, size: 14),
                                  label: Text(
                                    'Copy Code',
                                    style: ThemeProvider.sans(
                                        size: 11, weight: FontWeight.w600),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: ThemeProvider.gold,
                                    disabledForegroundColor:
                                        ThemeProvider.greyColor,
                                    side: BorderSide(
                                      color: value.couponRow!.isScheduleActive
                                          ? ThemeProvider.gold
                                          : ThemeProvider.greyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        ...value.bookableRows.map(
                          (row) => _bookableCard(value, row),
                        ),
                      ],
                    ),
        );
      },
    );
  }

  Widget _bookableCard(TimedOfferController value, TimedOfferRow row) {
    final partner = row.partner!;
    final cover = _imageUrl(partner.coverPath);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EliteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: cover.isEmpty
                      ? Container(
                          width: 56,
                          height: 56,
                          color: ThemeProvider.gold.withOpacity(0.2),
                          child: const Icon(Icons.storefront,
                              color: ThemeProvider.gold),
                        )
                      : EliteNetworkImage(url: cover, width: 56, height: 56),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.displayName,
                        style: ThemeProvider.serif(size: 16),
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
              ],
            ),
            if (row.services.isNotEmpty) ...[
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
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: row.services.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final service = row.services[i];
                    final img = _imageUrl(service.coverPath);
                    final price = service.price ?? service.amount ?? 0;
                    return SizedBox(
                      width: 130,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: img.isEmpty
                                ? Container(
                                    height: 84,
                                    width: 130,
                                    color: const Color(0xFF2A2A2A),
                                    child: const Icon(Icons.spa_outlined,
                                        color: ThemeProvider.gold),
                                  )
                                : EliteNetworkImage(
                                    url: img,
                                    width: 130,
                                    height: 84,
                                    radius: BorderRadius.circular(10),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            service.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.sans(
                                size: 12, weight: FontWeight.w600),
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
                  },
                ),
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
              label: 'BOOK NOW',
              enabled: row.isScheduleActive,
              onTap: () => value.bookRow(row),
            ),
          ],
        ),
      ),
    );
  }
}
