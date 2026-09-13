import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/payment_socket_controller.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/view/widgets/elite_ui.dart';

class AfterPaymentScreen extends StatelessWidget {
  const AfterPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PaymentSocketController>()) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: EliteAppBar(showBack: true, title: 'After Payment'),
        body: Center(
          child: Text(
            'No pending payments'.tr,
            style: ThemeProvider.sans(color: ThemeProvider.greyColor),
          ),
        ),
      );
    }
    return GetBuilder<PaymentSocketController>(
      builder: (pay) {
        final items = pay.pendingPayOptions;
        return Scaffold(
          backgroundColor: ThemeProvider.backgroundColor,
          appBar: EliteAppBar(
            showBack: true,
            title: 'After Payment',
          ),
          body: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.payments_outlined,
                            size: 56, color: ThemeProvider.gold),
                        const SizedBox(height: 16),
                        Text(
                          'No pending payments'.tr,
                          textAlign: TextAlign.center,
                          style: ThemeProvider.serif(
                            size: 22,
                            color: ThemeProvider.gold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'When a service is completed, pay later from this list.'
                              .tr,
                          textAlign: TextAlign.center,
                          style: ThemeProvider.sans(
                            size: 13,
                            color: ThemeProvider.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final subtitle = item.amount.isNotEmpty
                        ? item.amount
                        : (item.message.isNotEmpty
                            ? item.message
                            : 'Service completed'.tr);
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3A3A3A)),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.fromLTRB(14, 8, 8, 8),
                        leading: const Icon(Icons.payments_outlined,
                            color: ThemeProvider.gold, size: 26),
                        title: Text(
                          item.label,
                          style: ThemeProvider.sans(
                            size: 15,
                            weight: FontWeight.w600,
                            color: ThemeProvider.gold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: ThemeProvider.sans(
                              size: 12,
                              color: ThemeProvider.greyColor,
                            ),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeProvider.gold,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(64, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => pay.openPendingPay(item),
                          child: Text(
                            'Pay'.tr,
                            style: ThemeProvider.sans(
                              size: 12,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
