import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/backend/models/slot_time_model.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class SpecialistScreen extends StatefulWidget {
  const SpecialistScreen({Key? key}) : super(key: key);

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  String _price(SpecialistController value, double? amount) {
    final p = (amount ?? 0).toStringAsFixed(0);
    return value.currencySide == 'left'
        ? '${value.currencySymbol}$p'
        : '$p${value.currencySymbol}';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SpecialistController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Expert Profile',
            onMore: () {},
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _header(value),
                    const SizedBox(height: 20),
                    _backgroundCard(value),
                    const SizedBox(height: 22),
                    if (value.servicesList.isNotEmpty)
                      _services(value)
                    else
                      const EliteApiUnavailable(),
                    const SizedBox(height: 22),
                    if (value.gallery.isNotEmpty)
                      _gallery(value)
                    else
                      const EliteApiUnavailable(),
                  ],
                ),
          bottomNavigationBar: value.servicesList.isEmpty &&
                  value.apiCalled == true
              ? null
              : _bottomBar(value),
        );
      },
    );
  }

  Widget _header(SpecialistController value) {
    final name =
        '${value.userInfo.firstName ?? ''} ${value.userInfo.lastName ?? ''}'
            .trim();
    final cate = value.categoriesList.isNotEmpty
        ? (value.categoriesList.first.name ?? '')
        : '';
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: ThemeProvider.gold, width: 2),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: ThemeProvider.appColorShadow,
                    blurRadius: 18,
                  ),
                ],
              ),
              child: EliteNetworkImage(
                url: '${Environments.imageURL}${value.userInfo.cover}',
                radius: BorderRadius.circular(14),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ThemeProvider.gold,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 12, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      (value.individualDetails.rating ?? 0).toStringAsFixed(1),
                      style: ThemeProvider.sans(
                        size: 11,
                        weight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (cate.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: ThemeProvider.gold),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              cate.toUpperCase(),
              style: ThemeProvider.sans(
                size: 10,
                color: ThemeProvider.gold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        if (cate.isNotEmpty) const SizedBox(height: 10),
        Text(name, style: ThemeProvider.serif(size: 28, weight: FontWeight.w700)),
        if ((value.individualDetails.about ?? '').isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            value.individualDetails.about!,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: ThemeProvider.sans(size: 13, color: Colors.white70),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined,
                color: ThemeProvider.gold, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                value.individualDetails.address ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: ThemeProvider.sans(
                    size: 12, color: ThemeProvider.greyColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _backgroundCard(SpecialistController value) {
    final about = value.individualDetails.about ?? '';
    if (about.isEmpty && value.categoriesList.isEmpty) {
      return const EliteApiUnavailable();
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeProvider.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expert Background'.tr,
            style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold),
          ),
          if (about.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              about,
              style: ThemeProvider.sans(size: 13, color: Colors.white70),
            ),
          ],
          if (value.categoriesList.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
            spacing: 8,
            runSpacing: 8,
            children: value.categoriesList.take(3).map((c) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  c.name ?? '',
                  style: ThemeProvider.sans(
                    size: 11,
                    color: ThemeProvider.gold,
                  ),
                ),
              );
            }).toList(),
          ),
          ],
        ],
      ),
    );
  }

  Widget _services(SpecialistController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (value.categoriesList.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: value.categoriesList.map((c) {
                return Container(
                  margin: const EdgeInsets.only(right: 8, bottom: 14),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF3A3A3A)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    c.name ?? '',
                    style: ThemeProvider.sans(
                      size: 11,
                      color: ThemeProvider.goldDeep,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        Row(
          children: [
            Text('Curated Services', style: ThemeProvider.serif(size: 22)),
            const Spacer(),
            Text(
              '${value.servicesList.length} AVAILABLE',
              style: ThemeProvider.sans(
                size: 11,
                color: ThemeProvider.gold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(value.servicesList.length, (index) {
          final item = value.servicesList[index];
          final selected = item.isChecked == true;
          return GestureDetector(
            onTap: () =>
                value.updateServiceStatusInCart(index, !(item.isChecked ?? false)),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ThemeProvider.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? ThemeProvider.gold : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: ThemeProvider.serif(size: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.descriptions ?? ''} ${(item.duration ?? 0).toStringAsFixed(0)} mins.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ThemeProvider.sans(
                            size: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _price(value, item.price),
                        style: ThemeProvider.serif(
                          size: 20,
                          color: ThemeProvider.gold,
                          weight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        selected ? 'SELECTED' : 'SELECT',
                        style: ThemeProvider.sans(
                          size: 10,
                          color: ThemeProvider.gold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _gallery(SpecialistController value) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: value.gallery.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return EliteNetworkImage(
            url: '${Environments.imageURL}${value.gallery[i]}',
            width: 96,
            height: 72,
            radius: BorderRadius.circular(8),
          );
        },
      ),
    );
  }

  bool _isMorningSlot(String? startTime) {
    try {
      return DateFormat('hh:mm a').parse(startTime ?? '').hour < 12;
    } catch (_) {
      return (startTime ?? '').toUpperCase().contains('AM');
    }
  }

  String _slotHour(String? startTime) {
    final raw = startTime ?? '';
    return raw.replaceAll(RegExp(r'\s*(AM|PM)$', caseSensitive: false), '').trim();
  }

  String _slotPeriod(String? startTime) {
    final raw = (startTime ?? '').toUpperCase();
    return raw.contains('PM') ? 'PM' : 'AM';
  }

  void _openAvailabilitySheet() {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: GetBuilder<SpecialistController>(
        builder: (value) {
          final days = value.availabilityDays();
          final morning = value.slotTimes
              .where((s) => _isMorningSlot(s.startTime))
              .toList();
          final afternoon = value.slotTimes
              .where((s) => !_isMorningSlot(s.startTime))
              .toList();
          return Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            decoration: const BoxDecoration(
              color: ThemeProvider.backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        'Choose Availability'.tr,
                        style: ThemeProvider.serif(size: 22),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: value.availabilityWeekOffset == 0
                            ? null
                            : () => value.shiftAvailabilityWeek(-1),
                        icon: Icon(
                          Icons.chevron_left,
                          color: value.availabilityWeekOffset == 0
                              ? Colors.white24
                              : Colors.white,
                        ),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () => value.shiftAvailabilityWeek(1),
                        icon: const Icon(Icons.chevron_right,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.48),
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: ThemeProvider.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 78,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: days.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, i) {
                                  final day = days[i];
                                  final selected =
                                      value.selectedDay.year == day.year &&
                                          value.selectedDay.month ==
                                              day.month &&
                                          value.selectedDay.day == day.day;
                                  return GestureDetector(
                                    onTap: () => value.onSelectDay(day),
                                    child: Container(
                                      width: 58,
                                      decoration: BoxDecoration(
                                        color: ThemeProvider.backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selected
                                              ? ThemeProvider.gold
                                              : const Color(0xFF2A2A2A),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('MMM')
                                                .format(day)
                                                .toUpperCase(),
                                            style: ThemeProvider.sans(
                                              size: 9,
                                              weight: FontWeight.w600,
                                              color: selected
                                                  ? ThemeProvider.gold
                                                  : ThemeProvider.greyColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${day.day}',
                                            style: ThemeProvider.serif(
                                              size: 20,
                                              weight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('E')
                                                .format(day)
                                                .toUpperCase(),
                                            style: ThemeProvider.sans(
                                              size: 9,
                                              color: selected
                                                  ? ThemeProvider.gold
                                                  : ThemeProvider.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (value.slotsLoading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: ThemeProvider.gold),
                                ),
                              )
                            else if (value.slotTimes.isEmpty)
                              const EliteApiUnavailable()
                            else ...[
                              if (morning.isNotEmpty) ...[
                                _slotSectionLabel('MORNING SLOTS'),
                                const SizedBox(height: 10),
                                _slotGrid(value, morning),
                              ],
                              if (afternoon.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                _slotSectionLabel('AFTERNOON SLOTS'),
                                const SizedBox(height: 10),
                                _slotGrid(value, afternoon),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (value.selectedSlotIndex.isEmpty) {
                          showToast('Please select Slots'.tr);
                          return;
                        }
                        Get.back();
                        value.onCheckout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        'CONTINUE'.tr,
                        style: ThemeProvider.sans(
                          size: 14,
                          weight: FontWeight.w700,
                          color: Colors.black,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _slotSectionLabel(String label) {
    return Text(
      label.tr,
      style: ThemeProvider.sans(
        size: 10,
        weight: FontWeight.w600,
        color: ThemeProvider.goldDeep,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget _slotGrid(SpecialistController value, List<SlotTimeModel> slots) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, i) {
        final slot = slots[i];
        final key = '${slot.startTime}-${slot.endTime}';
        final booked = value.isSlotBooked(key);
        final selected = value.selectedSlotIndex == key;
        return GestureDetector(
          onTap: booked ? null : () => value.onSelectSlot(key),
          child: Container(
            decoration: BoxDecoration(
              color: selected ? ThemeProvider.gold : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: booked
                    ? const Color(0xFF4A4A4A)
                    : selected
                        ? ThemeProvider.gold
                        : ThemeProvider.gold.withValues(alpha: 0.55),
              ),
            ),
            child: booked
                ? Center(
                    child: Text(
                      'Booked'.tr,
                      style: ThemeProvider.sans(
                        size: 11,
                        color: ThemeProvider.greyColor,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _slotHour(slot.startTime),
                        style: ThemeProvider.sans(
                          size: 14,
                          weight: FontWeight.w600,
                          color: selected ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _slotPeriod(slot.startTime),
                        style: ThemeProvider.sans(
                          size: 10,
                          weight: FontWeight.w500,
                          color: selected ? Colors.black : ThemeProvider.gold,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _bottomBar(SpecialistController value) {
    return Container(
      color: ThemeProvider.backgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final hasSelected =
                      value.servicesList.any((s) => s.isChecked == true);
                  if (!hasSelected && value.servicesList.isNotEmpty) {
                    value.updateServiceStatusInCart(0, true);
                  }
                  showToast('Added to cart'.tr);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ThemeProvider.gold),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: ThemeProvider.gold, size: 16),
                    Text(
                      'ADD TO CART',
                      style: ThemeProvider.sans(
                        size: 10,
                        color: ThemeProvider.gold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  final hasSelected =
                      value.servicesList.any((s) => s.isChecked == true);
                  if (!hasSelected && value.servicesList.isNotEmpty) {
                    value.updateServiceStatusInCart(0, true);
                  }
                  if (Get.find<ServiceCartController>().totalItemsInCart > 0) {
                    _openAvailabilitySheet();
                  } else {
                    showToast('Please select a service'.tr);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeProvider.gold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                  shadowColor: ThemeProvider.appColorShadow,
                ),
                child: Text(
                  'BOOK NOW',
                  style: ThemeProvider.serif(
                    size: 18,
                    weight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
