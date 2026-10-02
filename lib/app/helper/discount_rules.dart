import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/util/theme.dart';

/// One discount at a time, and never more than half the amount.
class DiscountRules {
  static const maxPercent = 50.0;

  static double cap(double amount, double base) {
    if (amount <= 0 || base <= 0) return 0;
    final maxOff = base * (maxPercent / 100);
    final next = amount > maxOff ? maxOff : amount;
    return double.parse(next.toStringAsFixed(2));
  }

  static ({double amount, bool capped}) couponOff({
    required int type,
    required double value,
    required double upto,
    required double base,
  }) {
    if (value <= 0 || base <= 0) return (amount: 0, capped: false);
    var amount = type == 1 ? base * (value / 100) : value;
    if (type == 1 && upto > 0 && amount > upto) amount = upto;
    if (amount > base) amount = base;
    final capped = cap(amount, base);
    return (
      amount: capped,
      capped: amount - capped > 0.009,
    );
  }

  /// Asks before replacing the offer already in use. Returns true to switch.
  static Future<bool> confirmOnlyOne({required bool useRewards}) async {
    final next = useRewards ? 'Elite Rewards' : 'the coupon';
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Only one at a time'.tr,
          style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold),
        ),
        content: Text(
          'A coupon and Elite Rewards cannot be used together. Continue with $next?',
          style: ThemeProvider.sans(size: 14, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              'Cancel'.tr,
              style: ThemeProvider.sans(size: 14, color: ThemeProvider.greyColor),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Continue'.tr,
              style: ThemeProvider.sans(
                size: 14,
                weight: FontWeight.w700,
                color: ThemeProvider.gold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    return result == true;
  }
}
