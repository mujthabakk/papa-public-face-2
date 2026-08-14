import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon_user/app/controller/checkout_controller.dart';
import 'package:salon_user/app/controller/service_cart_controller.dart';
import 'package:salon_user/app/controller/slot_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class SlotScreen extends StatefulWidget {
  const SlotScreen({Key? key}) : super(key: key);

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  int _weekOffset = 0;
  bool _anyAvailable = false;

  List<DateTime> _days() {
    final start = DateTime.now().add(Duration(days: _weekOffset * 7));
    return List.generate(7, (i) => start.add(Duration(days: i)));
  }

  bool _isMorning(String? t) {
    try {
      final dt = DateFormat('hh:mm a').parse(t ?? '12:00 PM');
      return dt.hour < 12;
    } catch (_) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlotController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: const EliteAppBar(
            showBack: true,
            leadingLabel: 'CANCEL',
            title: 'Service Booking',
          ),
          body: value.apiCalled == false
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _featured(),
                    _practitioners(value),
                    const SizedBox(height: 18),
                    _availability(value),
                    _serviceDetails(),
                    const SizedBox(height: 18),
                    _summary(value),
                  ],
                ),
          bottomNavigationBar: _bottom(value),
        );
      },
    );
  }

  Widget _featured() {
    final cart = Get.find<ServiceCartController>().savedInCart;
    final hasService = cart.services?.isNotEmpty == true;
    final hasPackage = cart.packages?.isNotEmpty == true;
    if (!hasService && !hasPackage) return const SizedBox.shrink();
    final name = hasService
        ? cart.services!.first.name
        : cart.packages!.first.name;
    final cover = hasService
        ? cart.services!.first.cover
        : cart.packages!.first.cover;
    final desc = hasService
        ? cart.services!.first.descriptions
        : cart.packages!.first.descriptions;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: ClipRRect(
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xE60D0D0D)],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name ?? '',
                    style: ThemeProvider.serif(
                        size: 22, color: ThemeProvider.gold)),
                if ((desc ?? '').isNotEmpty)
                  Text(
                    desc!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: ThemeProvider.sans(size: 12, color: Colors.white70),
                  ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _practitioners(SlotController value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Text('Select Practitioner'.tr,
            style: ThemeProvider.serif(
                size: 18, color: ThemeProvider.gold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.specialistList.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.95,
          ),
          itemBuilder: (_, i) {
            if (i == value.specialistList.length) {
              final selected = _anyAvailable;
              return GestureDetector(
                onTap: () {
                  if (value.specialistList.isNotEmpty) {
                    value.saveSpecialist(value.specialistList.first.id as int);
                  }
                  setState(() => _anyAvailable = true);
                },
                child: EliteCard(
                  margin: EdgeInsets.zero,
                  borderColor: selected ? ThemeProvider.gold : null,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.groups_outlined,
                          color: ThemeProvider.gold, size: 36),
                      const SizedBox(height: 8),
                      Text('Any Available',
                          style: ThemeProvider.serif(
                              size: 14, color: ThemeProvider.gold)),
                      Text('Best Efficiency',
                          style: ThemeProvider.sans(
                              size: 11, color: ThemeProvider.greyColor)),
                    ],
                  ),
                ),
              );
            }
            final s = value.specialistList[i];
            final selected =
                !_anyAvailable && value.selectedSpecialist == s.id.toString();
            return GestureDetector(
              onTap: () {
                setState(() => _anyAvailable = false);
                value.saveSpecialist(s.id as int);
              },
              child: EliteCard(
                margin: EdgeInsets.zero,
                borderColor: selected ? ThemeProvider.gold : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EliteNetworkImage(
                      url: '${Environments.imageURL}${s.cover}',
                      width: 64,
                      height: 64,
                      radius: BorderRadius.circular(12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${s.firstName ?? ''} ${(s.lastName ?? '').isNotEmpty ? '${s.lastName![0]}.' : ''}',
                      style: ThemeProvider.serif(
                          size: 14, color: ThemeProvider.gold),
                    ),
                    Text(
                      'Specialist',
                      style: ThemeProvider.sans(
                          size: 11, color: ThemeProvider.greyColor),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _availability(SlotController value) {
    final days = _days();
    DateTime? selected;
    try {
      selected = DateTime.parse(value.savedDate);
    } catch (_) {}
    final slots = value.haveData ? (value.slotList.slots ?? []) : [];
    final morning = slots.where((s) => _isMorning(s.startTime)).toList();
    final afternoon = slots.where((s) => !_isMorning(s.startTime)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text('Choose Availability',
                  style: ThemeProvider.serif(
                      size: 18, color: ThemeProvider.gold)),
            ),
            IconButton(
              onPressed: _weekOffset == 0
                  ? null
                  : () => setState(() => _weekOffset--),
              icon: const Icon(Icons.chevron_left, color: ThemeProvider.gold),
            ),
            IconButton(
              onPressed: () => setState(() => _weekOffset++),
              icon: const Icon(Icons.chevron_right, color: ThemeProvider.gold),
            ),
          ],
        ),
        SizedBox(
          height: 92,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final d = days[i];
              final isSel = selected != null &&
                  d.year == selected.year &&
                  d.month == selected.month &&
                  d.day == selected.day;
              return GestureDetector(
                onTap: () => value.onDateChange(d),
                child: Container(
                  width: 62,
                  decoration: BoxDecoration(
                    color: ThemeProvider.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSel
                          ? ThemeProvider.gold
                          : const Color(0xFF2A2A2A),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(d).toUpperCase(),
                        style: ThemeProvider.sans(
                          size: 10,
                          color: isSel
                              ? ThemeProvider.gold
                              : ThemeProvider.greyColor,
                        ),
                      ),
                      Text(
                        '${d.day}',
                        style: ThemeProvider.serif(
                          size: 20,
                          color: isSel ? ThemeProvider.gold : Colors.white,
                        ),
                      ),
                      Text(
                        DateFormat('E').format(d).toUpperCase(),
                        style: ThemeProvider.sans(
                          size: 10,
                          color: isSel
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
        if (!value.haveData)
          Text('No slots available for this date',
              style: ThemeProvider.sans(size: 13, color: Colors.white70))
        else ...[
          _slotGroup('MORNING SLOTS', morning, value),
          const SizedBox(height: 12),
          _slotGroup('AFTERNOON SLOTS', afternoon, value),
        ],
      ],
    );
  }

  Widget _slotGroup(String label, List slots, SlotController value) {
    if (slots.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: ThemeProvider.sans(
            size: 10,
            color: ThemeProvider.greyColor,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: slots.map((slot) {
            final key = '${slot.startTime}-${slot.endTime}';
            final booked = value.isBooked(key);
            final selected = value.selectedSlotIndex == key;
            return GestureDetector(
              onTap: booked ? null : () => value.onSelectSlot(key),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? ThemeProvider.gold : ThemeProvider.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: booked
                        ? const Color(0xFF2A2A2A)
                        : selected
                            ? ThemeProvider.gold
                            : const Color(0xFF3A3A3A),
                  ),
                ),
                child: Text(
                  booked ? 'Booked' : (slot.startTime ?? ''),
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w600,
                    color: booked
                        ? ThemeProvider.greyColor
                        : selected
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _serviceDetails() {
    final cart = Get.find<ServiceCartController>().savedInCart;
    final services = cart.services ?? [];
    final packages = cart.packages ?? [];
    if (services.isEmpty && packages.isEmpty) {
      return const SizedBox.shrink();
    }
    final desc = services.isNotEmpty
        ? services.first.descriptions
        : packages.first.descriptions;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: EliteCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Details'.tr,
                style:
                    ThemeProvider.serif(size: 18, color: ThemeProvider.gold)),
            if ((desc ?? '').isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                desc!,
                style: ThemeProvider.sans(size: 13, color: Colors.white70)
                    .copyWith(height: 1.5),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              "WHAT'S INCLUDED".tr,
              style: ThemeProvider.sans(
                size: 10,
                color: ThemeProvider.gold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...services.map((s) => _check(s.name ?? '')),
            ...packages.map((p) => _check(p.name ?? '')),
          ],
        ),
      ),
    );
  }

  Widget _check(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: ThemeProvider.gold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: ThemeProvider.sans(size: 13)),
          ),
        ],
      ),
    );
  }

  Widget _summary(SlotController value) {
    final cart = Get.find<ServiceCartController>();
    final checkout = Get.find<CheckoutController>();
    String specialistName = 'Any Available';
    if (!_anyAvailable && value.selectedSpecialist.isNotEmpty) {
      final match = value.specialistList
          .where((s) => s.id.toString() == value.selectedSpecialist);
      if (match.isNotEmpty) {
        specialistName =
            '${match.first.firstName ?? ''} ${match.first.lastName ?? ''}'
                .trim();
      }
    }
    String dateLabel = value.savedDate;
    try {
      dateLabel = DateFormat('MMM d, yyyy').format(DateTime.parse(value.savedDate));
    } catch (_) {}
    final first = (checkout.savedInCart.services?.isNotEmpty == true)
        ? checkout.savedInCart.services!.first.name
        : (checkout.savedInCart.packages?.isNotEmpty == true
            ? checkout.savedInCart.packages!.first.name
            : '');
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary',
              style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold)),
          const SizedBox(height: 12),
          _row('SERVICE', first ?? '',
              elitePrice(checkout.currencySide, checkout.currencySymbol,
                  cart.totalPrice, digits: 2)),
          _row('PRACTITIONER', specialistName, ''),
          _row(
              'DATE & TIME',
              '$dateLabel${value.selectedSlotIndex.isNotEmpty ? ' at ${value.selectedSlotIndex.split('-').first}' : ''}',
              ''),
          const Divider(color: Color(0xFF2A2A2A)),
          _row('Subtotal', '',
              elitePrice(checkout.currencySide, checkout.currencySymbol,
                  cart.totalPrice, digits: 2)),
          _row('Service Fee', '',
              elitePrice(checkout.currencySide, checkout.currencySymbol,
                  cart.serviceChargeAmount, digits: 2)),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Total',
                  style: ThemeProvider.serif(
                      size: 18, color: ThemeProvider.gold)),
              const Spacer(),
              Text(
                elitePrice(checkout.currencySide, checkout.currencySymbol,
                    cart.grandTotal, digits: 2),
                style: ThemeProvider.serif(
                    size: 22, color: ThemeProvider.gold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Free cancellation up to 24 hours before your session.',
            style: ThemeProvider.sans(size: 11, color: ThemeProvider.greyColor),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: ThemeProvider.sans(
                    size: 10,
                    color: ThemeProvider.gold,
                    letterSpacing: 1,
                  ),
                ),
                if (value.isNotEmpty)
                  Text(value, style: ThemeProvider.sans(size: 14)),
              ],
            ),
          ),
          if (price.isNotEmpty)
            Text(price, style: ThemeProvider.serif(size: 16)),
        ],
      ),
    );
  }

  Widget _bottom(SlotController value) {
    return Container(
      color: ThemeProvider.backgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    Text('Confirm Booking',
                        style: ThemeProvider.serif(size: 18, color: Colors.black)),
                    const SizedBox(width: 8),
                    const Icon(Icons.auto_awesome, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  showToast('Saved to cart');
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: ThemeProvider.gold,
                  side: const BorderSide(color: ThemeProvider.gold),
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Add to Cart',
                        style: ThemeProvider.serif(
                            size: 16, color: ThemeProvider.gold)),
                    const SizedBox(width: 8),
                    const Icon(Icons.shopping_cart_outlined, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
