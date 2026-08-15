import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';

void showSpinWinDialog(List<CouponsModel> offers) {
  Get.dialog(
    SpinWinDialog(offers: offers),
    barrierDismissible: true,
    barrierColor: Colors.black54,
  );
}

class SpinWinDialog extends StatefulWidget {
  final List<CouponsModel> offers;

  const SpinWinDialog({Key? key, required this.offers}) : super(key: key);

  @override
  State<SpinWinDialog> createState() => _SpinWinDialogState();
}

class _SpinWinDialogState extends State<SpinWinDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _turns;
  bool _spinning = false;
  CouponsModel? _won;

  List<CouponsModel> get _prizes {
    final active = widget.offers.where((o) => o.status == 1).toList();
    if (active.isEmpty) return [];
    if (active.length >= 4) return active.take(8).toList();
    return List<CouponsModel>.generate(6, (i) => active[i % active.length]);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    );
    _turns = AlwaysStoppedAnimation(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _label(CouponsModel offer) {
    if ((offer.discount ?? 0) > 0) {
      return offer.type == 1
          ? '${offer.discount!.toStringAsFixed(0)}%'
          : '${offer.discount!.toStringAsFixed(0)}';
    }
    return offer.name ?? offer.code ?? '';
  }

  Future<void> _spin() async {
    if (_spinning || _prizes.isEmpty) return;
    setState(() {
      _spinning = true;
      _won = null;
    });
    final n = _prizes.length;
    final winner = Random().nextInt(n);
    final slice = 1 / n;
    final target = 6 + (1 - (winner + 0.5) * slice);
    _turns = Tween<double>(begin: 0, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.reset();
    await _controller.forward();
    setState(() {
      _spinning = false;
      _won = _prizes[winner];
    });
    if (_won?.code != null && _won!.code!.isNotEmpty) {
      showToast(_won!.code!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prizes = _prizes;
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
                'Unlock your exclusive elite reward.',
                textAlign: TextAlign.center,
                style: ThemeProvider.sans(
                  size: 12,
                  color: ThemeProvider.greyColor,
                ),
              ),
              const SizedBox(height: 16),
              if (prizes.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'API is not available',
                    style: TextStyle(color: ThemeProvider.greyColor),
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
                          painter: _WheelPainter(
                            labels: prizes.map(_label).toList(),
                          ),
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
              if (_won != null) ...[
                const SizedBox(height: 12),
                Text(
                  _won!.name ?? '',
                  textAlign: TextAlign.center,
                  style: ThemeProvider.serif(size: 16, color: ThemeProvider.gold),
                ),
                if ((_won!.code ?? '').isNotEmpty)
                  Text(
                    _won!.code!,
                    style: ThemeProvider.sans(
                      size: 13,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _spinning || prizes.isEmpty ? null : _spin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeProvider.gold,
                    disabledBackgroundColor: const Color(0xFF3A3A3A),
                    foregroundColor: Colors.black,
                    elevation: 8,
                    shadowColor: ThemeProvider.appColorShadow,
                  ),
                  child: Text(
                    _spinning ? 'SPINNING...' : 'SPIN NOW',
                    style: ThemeProvider.sans(
                      size: 14,
                      weight: FontWeight.w800,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
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
