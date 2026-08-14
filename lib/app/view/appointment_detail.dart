import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/appointment_detail_controller.dart';
import 'package:salon_user/app/env.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppointmentDetailController>(
      builder: (value) {
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'Invoice',
            onMore: value.openHelpModal,
          ),
          body: value.apiCalled != true
              ? const Center(
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _successHeader(value),
                    const SizedBox(height: 22),
                    _transactionCard(value),
                    const SizedBox(height: 14),
                    _receiptCard(value),
                    const SizedBox(height: 14),
                    _providerCard(value),
                  ],
                ),
          bottomNavigationBar: value.apiCalled == false
              ? const SizedBox()
              : _bottomBar(value),
        );
      },
    );
  }

  Widget _successHeader(AppointmentDetailController value) {
    final paid = value.appointmentInfo.status != 5 &&
        value.appointmentInfo.status != 6;
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: ThemeProvider.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: ThemeProvider.gold.withValues(alpha: 0.28),
                blurRadius: 22,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: ThemeProvider.gold,
                shape: BoxShape.circle,
              ),
              child: Icon(
                paid ? Icons.check : Icons.close,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          paid ? 'PAYMENT SUCCESSFUL' : value.orderStatus.toUpperCase(),
          style: ThemeProvider.sans(
            size: 11,
            weight: FontWeight.w700,
            color: ThemeProvider.gold,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _money(value.grandTotal, value),
          style: ThemeProvider.serif(size: 36, color: ThemeProvider.gold),
        ),
      ],
    );
  }

  Widget _transactionCard(AppointmentDetailController value) {
    final methodIndex = value.appointmentInfo.payMethod ?? 0;
    final method = methodIndex >= 0 && methodIndex < value.paymentName.length
        ? value.paymentName[methodIndex]
        : 'NA';
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRANSACTION DETAILS',
            style: ThemeProvider.sans(
              size: 11,
              weight: FontWeight.w700,
              color: ThemeProvider.greyColor,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          _kv('Date', value.savedDate),
          _kv('Time', value.slot),
          _kv('Transaction ID', '#PB-${value.appointmentId}',
              valueColor: ThemeProvider.gold, valueWeight: FontWeight.w700),
          _kv('Payment Method', method),
          _kv('Status', value.orderStatus),
        ],
      ),
    );
  }

  Widget _receiptCard(AppointmentDetailController value) {
    final services = value.appointmentInfo.items?.services ?? [];
    final packages = value.appointmentInfo.items?.packages ?? [];
    return EliteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ITEMIZED RECEIPT',
            style: ThemeProvider.sans(
              size: 11,
              weight: FontWeight.w700,
              color: ThemeProvider.greyColor,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          ...services.map(
            (s) => _itemRow(
              s.name.toString(),
              _genderLabel(s.gender),
              _money(s.off ?? s.price, value),
            ),
          ),
          ...packages.map(
            (p) => _itemRow(
              p.name.toString(),
              'Package',
              _money(p.off ?? p.price, value),
            ),
          ),
          if (_positive(value.discount))
            _itemRow(
              'Discount'.tr,
              'Applied offer'.tr,
              _money(value.discount, value),
              muted: true,
            ),
          if (_positive(value.walletDiscount))
            _itemRow(
              'Wallet'.tr,
              '',
              _money(value.walletDiscount, value),
              muted: true,
            ),
          if (_positive(value.distanceCost))
            _itemRow(
              'Distance Cost'.tr,
              'Travel'.tr,
              _money(value.distanceCost, value),
              muted: true,
            ),
          if (_positive(value.serviceTax))
            _itemRow(
              'Taxes'.tr,
              'Service tax'.tr,
              _money(value.serviceTax, value),
              muted: true,
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: List.generate(
                24,
                (i) => Expanded(
                  child: Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    color: const Color(0xFF3A3A3A),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text('Total Paid', style: ThemeProvider.serif(size: 20)),
              const Spacer(),
              Text(
                _money(value.grandTotal, value),
                style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _providerCard(AppointmentDetailController value) {
    final isSalon = value.appointmentInfo.salonId != 0;
    final name = isSalon
        ? value.appointmentInfo.salonInfo!.name.toString()
        : '${value.appointmentInfo.ownerInfo!.firstName} ${value.appointmentInfo.ownerInfo!.lastName}';
    final address = isSalon
        ? value.appointmentInfo.salonInfo!.address.toString()
        : value.appointmentInfo.individualInfo!.address.toString();
    final image = isSalon
        ? '${Environments.imageURL}${value.appointmentInfo.salonInfo!.cover}'
        : '${Environments.imageURL}${value.appointmentInfo.ownerInfo!.cover}';
    final id = isSalon
        ? value.appointmentInfo.salonId.toString()
        : value.appointmentInfo.freelancerId.toString();
    return EliteCard(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 56,
              height: 56,
              child: EliteNetworkImage(url: image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: ThemeProvider.serif(size: 16)),
                const SizedBox(height: 4),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: ThemeProvider.sans(
                      size: 12, color: ThemeProvider.greyColor),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => value.onContactInfo(
              name,
              value.appointmentInfo.ownerInfo!.mobile!,
              value.appointmentInfo.ownerInfo!.email!,
              id,
            ),
            icon: const Icon(Icons.chat_bubble_outline,
                color: ThemeProvider.gold),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar(AppointmentDetailController value) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            EliteGoldButton(
              label: 'DOWNLOAD RECEIPT',
              icon: Icons.download,
              onTap: value.launchInBrowser,
            ),
            const SizedBox(height: 10),
            EliteGoldButton(
              label: 'BACK TO HOME',
              outlined: true,
              icon: Icons.home_outlined,
              onTap: () {
                Get.offAllNamed(AppRouter.getTabsBarRoute());
              },
            ),
            if (value.appointmentInfo.status == 0) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => value.onUpdateAppointmentStatus(5),
                child: Text(
                  'CANCEL APPOINTMENT',
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: ThemeProvider.logoutRose,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
            if (value.appointmentInfo.status == 4) ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => value
                    .onAddReview(value.appointmentInfo.freelancerId as int),
                child: Text(
                  'ADD REVIEW',
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w700,
                    color: ThemeProvider.gold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _kv(String label, String value,
      {Color? valueColor, FontWeight? valueWeight}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(label,
              style: ThemeProvider.sans(
                  size: 13, color: ThemeProvider.greyColor)),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: ThemeProvider.sans(
                size: 13,
                weight: valueWeight ?? FontWeight.w500,
                color: valueColor ?? ThemeProvider.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(String title, String subtitle, String price,
      {bool muted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: muted
                      ? ThemeProvider.sans(
                          size: 13, color: ThemeProvider.greyColor)
                      : ThemeProvider.sans(
                          size: 14, weight: FontWeight.w600),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: ThemeProvider.sans(
                        size: 11, color: ThemeProvider.greyColor),
                  ),
                ],
              ],
            ),
          ),
          Text(
            price,
            style: ThemeProvider.sans(
              size: 13,
              weight: FontWeight.w600,
              color: muted ? ThemeProvider.greyColor : ThemeProvider.gold,
            ),
          ),
        ],
      ),
    );
  }

  String _genderLabel(int? gender) {
    switch (gender) {
      case 0:
        return 'Kids';
      case 1:
        return 'Male';
      case 2:
        return 'Female';
      default:
        return 'Service';
    }
  }

  bool _positive(dynamic amount) {
    return (double.tryParse(amount.toString()) ?? 0) > 0;
  }

  String _money(dynamic amount, AppointmentDetailController value) {
    return elitePrice(
      value.currencySide,
      value.currencySymbol,
      double.tryParse(amount.toString()) ?? 0,
      digits: 2,
    );
  }
}
