import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/spinner_model.dart';
import 'package:salon_user/app/backend/parse/spinner_parse.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

void showSpinWinDialog({SpinnerStatus? initialStatus}) {
  Get.dialog(
    SpinWinDialog(initialStatus: initialStatus),
    barrierDismissible: true,
    barrierColor: Colors.black54,
  );
}

Future<void> openSpinWinOrLogin() async {
  if (!Get.isRegistered<SpinnerParser>()) return;
  final parser = Get.find<SpinnerParser>();
  if (!parser.isLoggedIn()) {
    Get.toNamed(AppRouter.getLoginRoute());
    return;
  }
  showSpinWinDialog();
}

Future<void> checkAndShowSpinWinDialog() async {
  if (!Get.isRegistered<SpinnerParser>()) return;
  final parser = Get.find<SpinnerParser>();
  if (!parser.isLoggedIn()) return;
  final status = await parser.fetchStatus();
  if (status?.hasAccess != true) return;
  showSpinWinDialog(initialStatus: status);
}

class SpinWinDialog extends StatefulWidget {
  final SpinnerStatus? initialStatus;

  const SpinWinDialog({Key? key, this.initialStatus}) : super(key: key);

  @override
  State<SpinWinDialog> createState() => _SpinWinDialogState();
}

class _SpinWinDialogState extends State<SpinWinDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _turns;

  SpinnerParser get _parser => Get.find<SpinnerParser>();

  SpinnerStatus? _status;
  bool _loading = true;
  bool _spinning = false;
  bool _redeeming = false;
  String? _statusMessage;

  List<String> get _wheelLabels => _status?.wheelLabels ?? [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _turns = AlwaysStoppedAnimation(0);
    if (widget.initialStatus != null) {
      _applyStatus(widget.initialStatus!);
      _loading = false;
    } else {
      _loadStatus();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _applyStatus(SpinnerStatus status) {
    _status = status;
    _statusMessage = status.canSpin
        ? null
        : (status.reason ??
            (status.pendingAmount > 0
                ? 'Redeem your pending reward below.'
                : null));
  }

  Future<void> _loadStatus() async {
    if (!_parser.isLoggedIn()) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.toNamed(AppRouter.getLoginRoute());
      return;
    }
    setState(() => _loading = true);
    try {
      final status = await _parser.fetchStatus();
      if (!mounted) return;
      if (status == null) {
        setState(() {
          _statusMessage = 'Unable to load spinner. Please try again.';
        });
        return;
      }
      setState(() => _applyStatus(status));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _animateToSegment(int segmentIndex, int segmentCount) async {
    if (segmentCount <= 0) return;
    final slice = 1 / segmentCount;
    final target = 6 + (1 - (segmentIndex + 0.5) * slice);
    _turns = Tween<double>(begin: 0, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.reset();
    await _controller.forward();
  }

  Future<void> _spin() async {
    if (_spinning || _loading || _status == null || _status!.canSpin != true) {
      return;
    }
    setState(() {
      _spinning = true;
    });
    try {
      final result = await _parser.spin();
      if (!mounted) return;
      if (!result.success || result.data == null) {
        showToast(result.message.isNotEmpty
            ? result.message
            : 'Unable to spin. Please try again.');
        if (_status != null) {
          setState(() {
            _status = SpinnerStatus(
              hasAccess: _status!.hasAccess,
              canSpin: false,
              reason: result.message.isNotEmpty ? result.message : _status!.reason,
              spinsToday: _status!.spinsToday,
              spinsPerDay: _status!.spinsPerDay,
              pendingAmount: _status!.pendingAmount,
              lifetimeEarned: _status!.lifetimeEarned,
              lifetimeLimit: _status!.lifetimeLimit,
              remainingCap: _status!.remainingCap,
              wheelAmounts: _status!.wheelAmounts,
              minAmount: _status!.minAmount,
              maxAmount: _status!.maxAmount,
              walletBalance: _status!.walletBalance,
            );
            _statusMessage = _status!.reason;
          });
        }
        return;
      }

      final spinData = result.data!;
      final labels = spinData.wheelAmounts.map((a) => '₹$a').toList();
      final segmentCount = labels.length;
      final segmentIndex = spinData.segmentIndex.clamp(0, segmentCount - 1);

      await _animateToSegment(segmentIndex, segmentCount);

      if (!mounted) return;
      setState(() {
        _status = SpinnerStatus(
          hasAccess: true,
          canSpin: spinData.canSpin,
          reason: spinData.reason,
          spinsToday: _status?.spinsToday ?? 1,
          spinsPerDay: _status?.spinsPerDay ?? 1,
          pendingAmount: spinData.pendingAmount,
          lifetimeEarned: spinData.lifetimeEarned,
          lifetimeLimit: _status?.lifetimeLimit ?? 100,
          remainingCap: spinData.remainingCap,
          wheelAmounts: spinData.wheelAmounts,
          minAmount: _status?.minAmount ?? 1,
          maxAmount: _status?.maxAmount ?? 9,
          walletBalance: _status?.walletBalance ?? 0,
        );
        _statusMessage = spinData.canSpin
            ? null
            : (spinData.reason ?? result.message);
      });
      await _showRewardPopup(
        type: _SpinnerRewardType.won,
        amount: spinData.amount,
        subtitle: result.message.isNotEmpty
            ? result.message
            : 'Tap Redeem below to add it to your wallet.',
      );
    } finally {
      if (mounted) setState(() => _spinning = false);
    }
  }

  Future<void> _redeem() async {
    if (_redeeming || _loading || (_status?.pendingAmount ?? 0) <= 0) return;
    setState(() => _redeeming = true);
    try {
      final result = await _parser.redeem();
      if (!mounted) return;
      if (!result.success || result.data == null) {
        showToast(result.message.isNotEmpty
            ? result.message
            : 'Unable to redeem. Please try again.');
        return;
      }
      final redeemData = result.data!;
      setState(() {
        _status = SpinnerStatus(
          hasAccess: _status?.hasAccess ?? true,
          canSpin: _status?.canSpin ?? false,
          reason: _status?.reason,
          spinsToday: _status?.spinsToday ?? 0,
          spinsPerDay: _status?.spinsPerDay ?? 1,
          pendingAmount: redeemData.pendingAmount,
          lifetimeEarned: _status?.lifetimeEarned ?? 0,
          lifetimeLimit: _status?.lifetimeLimit ?? 100,
          remainingCap: _status?.remainingCap ?? 0,
          wheelAmounts: _status?.wheelAmounts ?? [1, 2, 3, 5, 8],
          minAmount: _status?.minAmount ?? 1,
          maxAmount: _status?.maxAmount ?? 9,
          walletBalance: redeemData.walletBalance,
        );
      });
      await _showRewardPopup(
        type: _SpinnerRewardType.redeemed,
        amount: redeemData.redeemedAmount,
        walletBalance: redeemData.walletBalance,
        subtitle: result.message.isNotEmpty
            ? result.message
            : 'Your wallet has been updated.',
      );
    } finally {
      if (mounted) setState(() => _redeeming = false);
    }
  }

  String _formatAmount(double amount) {
    if (amount == amount.roundToDouble()) {
      return amount.toStringAsFixed(0);
    }
    return amount.toStringAsFixed(2);
  }

  Future<void> _showRewardPopup({
    required _SpinnerRewardType type,
    required double amount,
    double? walletBalance,
    String? subtitle,
  }) {
    return Get.dialog(
      _SpinnerRewardPopup(
        type: type,
        amount: amount,
        walletBalance: walletBalance,
        subtitle: subtitle,
        formatAmount: _formatAmount,
      ),
      barrierDismissible: true,
      barrierColor: Colors.black87,
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final hasAccess = status?.hasAccess ?? false;
    final canSpin = status?.canSpin == true && !_spinning;
    final pendingAmount = status?.pendingAmount ?? 0;
    final showWheel = hasAccess && _wheelLabels.isNotEmpty;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: BoxDecoration(
            color: ThemeProvider.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: Colors.white70, size: 20),
                ),
              ),
              Text(
                'SPIN & WIN',
                style: ThemeProvider.serif(
                  size: 26,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Spin daily for cash rewards.',
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                  size: 12,
                  color: ThemeProvider.greyColor,
                ),
              ),
              if (status != null && status.walletBalance > 0) ...[
                const SizedBox(height: 6),
                Text(
                  'Wallet: ₹${_formatAmount(status.walletBalance)}',
                  style: ThemeProvider.sans(
                    size: 12,
                    weight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: CircularProgressIndicator(color: ThemeProvider.gold),
                )
              else if (!hasAccess)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    status?.reason?.isNotEmpty == true
                        ? status!.reason!
                        : 'Not eligible for Spin & Win.',
                    textAlign: TextAlign.center,
                    style: ThemeProvider.sans(
                      size: 13,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                )
              else if (!showWheel)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'Spinner is unavailable.',
                    style: ThemeProvider.sans(
                      size: 13,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 220,
                  width: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: (_turns.value) * 2 * pi,
                            child: child,
                          );
                        },
                        child: CustomPaint(
                          size: const Size(220, 220),
                          painter: _WheelPainter(labels: _wheelLabels),
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down,
                          color: ThemeProvider.gold, size: 36),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: ThemeProvider.gold,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: ThemeProvider.appColorShadow,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (_statusMessage != null && _statusMessage!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: ThemeProvider.sans(
                    size: 12,
                    color: ThemeProvider.greyColor,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (hasAccess && !_loading) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: canSpin ? _spin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeProvider.gold,
                      disabledBackgroundColor: const Color(0xFF3A3A3A),
                      foregroundColor: Colors.black,
                      disabledForegroundColor: Colors.white54,
                      elevation: 8,
                      shadowColor: ThemeProvider.appColorShadow,
                    ),
                    child: Text(
                      _spinning ? 'SPINNING...' : 'SPIN NOW',
                      style: ThemeProvider.sans(
                        size: 14,
                        weight: FontWeight.w800,
                        color: canSpin ? Colors.black : Colors.white54,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                if (pendingAmount > 0) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: _redeeming ? null : _redeem,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ThemeProvider.gold),
                        foregroundColor: ThemeProvider.gold,
                      ),
                      child: Text(
                        _redeeming
                            ? 'REDEEMING...'
                            : 'REDEEM ₹${_formatAmount(pendingAmount)}',
                        style: ThemeProvider.sans(
                          size: 13,
                          weight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> labels;

  _WheelPainter({required this.labels});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final n = labels.isEmpty ? 1 : labels.length;
    final sweep = 2 * pi / n;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (var i = 0; i < n; i++) {
      final paint = Paint()
        ..color = i.isEven ? const Color(0xFF2A2A2A) : const Color(0xFF111111);
      canvas.drawArc(rect, -pi / 2 + i * sweep, sweep, true, paint);
    }

    final ring = Paint()
      ..color = ThemeProvider.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius - 4, ring);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < n; i++) {
      final angle = -pi / 2 + i * sweep + sweep / 2;
      final offset = Offset(
        center.dx + cos(angle) * radius * 0.62,
        center.dy + sin(angle) * radius * 0.62,
      );
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(
          color: ThemeProvider.gold,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        offset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) =>
      oldDelegate.labels != labels;
}

enum _SpinnerRewardType { won, redeemed }

class _SpinnerRewardPopup extends StatefulWidget {
  final _SpinnerRewardType type;
  final double amount;
  final double? walletBalance;
  final String? subtitle;
  final String Function(double) formatAmount;

  const _SpinnerRewardPopup({
    required this.type,
    required this.amount,
    this.walletBalance,
    this.subtitle,
    required this.formatAmount,
  });

  @override
  State<_SpinnerRewardPopup> createState() => _SpinnerRewardPopupState();
}

class _SpinnerRewardPopupState extends State<_SpinnerRewardPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  bool get _isWin => widget.type == _SpinnerRewardType.won;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
    _scale = CurvedAnimation(parent: _anim, curve: Curves.elasticOut);
    _fade = CurvedAnimation(
      parent: _anim,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amountText = '₹${widget.formatAmount(widget.amount)}';

    return Center(
      child: FadeTransition(
        opacity: _fade,
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 300,
              margin: const EdgeInsets.symmetric(horizontal: 28),
              padding: const EdgeInsets.fromLTRB(22, 28, 22, 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1F1A10), Color(0xFF141414)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ThemeProvider.gold, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: ThemeProvider.appColorShadow,
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeProvider.gold.withValues(alpha: 0.12),
                      border: Border.all(
                        color: ThemeProvider.gold.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Icon(
                      _isWin ? Icons.emoji_events_rounded : Icons.account_balance_wallet_rounded,
                      color: ThemeProvider.gold,
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _isWin ? 'CONGRATULATIONS!' : 'REDEEMED!',
                    textAlign: TextAlign.center,
                    style: ThemeProvider.serif(
                      size: 22,
                      weight: FontWeight.w700,
                      color: ThemeProvider.gold,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isWin ? 'You won' : 'Added to wallet',
                    style: ThemeProvider.sans(
                      size: 13,
                      color: ThemeProvider.greyColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    amountText,
                    style: ThemeProvider.serif(
                      size: 44,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  if (!_isWin && (widget.walletBalance ?? 0) > 0) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2E2E2E)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wallet_rounded,
                            color: ThemeProvider.gold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Wallet balance: ₹${widget.formatAmount(widget.walletBalance!)}',
                            style: ThemeProvider.sans(
                              size: 12,
                              weight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (_isWin) ...[
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ThemeProvider.gold.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ThemeProvider.gold.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Text(
                        widget.subtitle ??
                            'Reward is pending. Tap Redeem to move it to your wallet.',
                        textAlign: TextAlign.center,
                        style: ThemeProvider.sans(
                          size: 11,
                          color: Colors.white70,
                        ).copyWith(height: 1.4),
                      ),
                    ),
                  ] else if ((widget.subtitle ?? '').isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.subtitle!,
                      textAlign: TextAlign.center,
                      style: ThemeProvider.sans(
                        size: 11,
                        color: ThemeProvider.greyColor,
                      ).copyWith(height: 1.35),
                    ),
                  ],
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeProvider.gold,
                        foregroundColor: Colors.black,
                        elevation: 10,
                        shadowColor: ThemeProvider.appColorShadow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isWin ? 'CONTINUE' : 'GOT IT',
                        style: ThemeProvider.sans(
                          size: 13,
                          weight: FontWeight.w800,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
