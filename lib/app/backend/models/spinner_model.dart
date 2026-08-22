double _spinnerAmount(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _spinnerInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

List<int> _spinnerAmountList(dynamic raw) {
  if (raw is! List) return [1, 2, 3, 5, 8];
  final amounts = raw
      .map((e) => _spinnerInt(e))
      .where((e) => e > 0)
      .toList(growable: false);
  return amounts.isEmpty ? [1, 2, 3, 5, 8] : amounts;
}

class SpinnerStatus {
  final bool hasAccess;
  final bool canSpin;
  final String? reason;
  final int spinsToday;
  final int spinsPerDay;
  final double pendingAmount;
  final double lifetimeEarned;
  final double lifetimeLimit;
  final double remainingCap;
  final List<int> wheelAmounts;
  final double minAmount;
  final double maxAmount;
  final double walletBalance;

  SpinnerStatus({
    required this.hasAccess,
    required this.canSpin,
    this.reason,
    required this.spinsToday,
    required this.spinsPerDay,
    required this.pendingAmount,
    required this.lifetimeEarned,
    required this.lifetimeLimit,
    required this.remainingCap,
    required this.wheelAmounts,
    required this.minAmount,
    required this.maxAmount,
    required this.walletBalance,
  });

  factory SpinnerStatus.fromJson(Map<String, dynamic> json) {
    return SpinnerStatus(
      hasAccess: json['has_access'] == true,
      canSpin: json['can_spin'] == true,
      reason: json['reason']?.toString(),
      spinsToday: _spinnerInt(json['spins_today']),
      spinsPerDay: _spinnerInt(json['spins_per_day']),
      pendingAmount: _spinnerAmount(json['pending_amount']),
      lifetimeEarned: _spinnerAmount(json['lifetime_earned']),
      lifetimeLimit: _spinnerAmount(json['lifetime_limit']),
      remainingCap: _spinnerAmount(json['remaining_cap']),
      wheelAmounts: _spinnerAmountList(json['wheel_amounts']),
      minAmount: _spinnerAmount(json['min_amount']),
      maxAmount: _spinnerAmount(json['max_amount']),
      walletBalance: _spinnerAmount(json['wallet_balance']),
    );
  }

  List<String> get wheelLabels =>
      wheelAmounts.map((a) => '₹$a').toList(growable: false);
}

class SpinnerSpinResult {
  final int spinId;
  final double amount;
  final int segmentIndex;
  final List<int> wheelAmounts;
  final double pendingAmount;
  final double lifetimeEarned;
  final double remainingCap;
  final bool canSpin;
  final String? reason;

  SpinnerSpinResult({
    required this.spinId,
    required this.amount,
    required this.segmentIndex,
    required this.wheelAmounts,
    required this.pendingAmount,
    required this.lifetimeEarned,
    required this.remainingCap,
    required this.canSpin,
    this.reason,
  });

  factory SpinnerSpinResult.fromJson(Map<String, dynamic> json) {
    return SpinnerSpinResult(
      spinId: _spinnerInt(json['spin_id']),
      amount: _spinnerAmount(json['amount']),
      segmentIndex: _spinnerInt(json['segment_index']),
      wheelAmounts: _spinnerAmountList(json['wheel_amounts']),
      pendingAmount: _spinnerAmount(json['pending_amount']),
      lifetimeEarned: _spinnerAmount(json['lifetime_earned']),
      remainingCap: _spinnerAmount(json['remaining_cap']),
      canSpin: json['can_spin'] == true,
      reason: json['reason']?.toString(),
    );
  }
}

class SpinnerRedeemResult {
  final double redeemedAmount;
  final double pendingAmount;
  final double walletBalance;

  SpinnerRedeemResult({
    required this.redeemedAmount,
    required this.pendingAmount,
    required this.walletBalance,
  });

  factory SpinnerRedeemResult.fromJson(Map<String, dynamic> json) {
    return SpinnerRedeemResult(
      redeemedAmount: _spinnerAmount(json['redeemed_amount']),
      pendingAmount: _spinnerAmount(json['pending_amount']),
      walletBalance: _spinnerAmount(json['wallet_balance']),
    );
  }
}
