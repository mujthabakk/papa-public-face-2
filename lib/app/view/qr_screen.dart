import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:salon_user/app/controller/qr_controller.dart';
import 'package:salon_user/app/util/theme.dart';

class QRViewExample extends StatelessWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(QRController(parser: Get.find()));

    return GetBuilder<QRController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: controller.scannerController,
              onDetect: (capture) => controller.handleQRCodeScan(capture),
            ),
            const _GPayScanOverlay(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    ),
                    Expanded(
                      child: Text(
                        'Scan QR Code'.tr,
                        textAlign: TextAlign.center,
                        style: ThemeProvider.serif(
                          size: 20,
                          color: ThemeProvider.gold,
                        ),
                      ),
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: () => controller.toggleFlash(),
                        icon: Icon(
                          controller.isFlashOn.value
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: ThemeProvider.gold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scan QR Code For Shop Page'.tr,
                        textAlign: TextAlign.center,
                        style: ThemeProvider.sans(
                          size: 14,
                          weight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Align the QR code inside the frame'.tr,
                        textAlign: TextAlign.center,
                        style: ThemeProvider.sans(
                          size: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _GPayScanOverlay extends StatefulWidget {
  const _GPayScanOverlay();

  @override
  State<_GPayScanOverlay> createState() => _GPayScanOverlayState();
}

class _GPayScanOverlayState extends State<_GPayScanOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cut = (size.width * 0.72).clamp(220.0, 300.0);
    final top = (size.height - cut) / 2.2;
    final left = (size.width - cut) / 2;
    final hole = Rect.fromLTWH(left, top, cut, cut);

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return CustomPaint(
          size: size,
          painter: _GPayScanPainter(
            hole: hole,
            lineT: Curves.easeInOut.transform(_anim.value),
          ),
        );
      },
    );
  }
}

class _GPayScanPainter extends CustomPainter {
  final Rect hole;
  final double lineT;

  _GPayScanPainter({required this.hole, required this.lineT});

  @override
  void paint(Canvas canvas, Size size) {
    final overlay = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cut = Path()
      ..addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(22)));
    final dim = Path.combine(PathOperation.difference, overlay, cut);
    canvas.drawPath(dim, Paint()..color = Colors.black.withValues(alpha: 0.58));

    final gold = Paint()
      ..color = ThemeProvider.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const corner = 28.0;
    final r = hole;
    canvas.drawLine(r.topLeft, r.topLeft + const Offset(corner, 0), gold);
    canvas.drawLine(r.topLeft, r.topLeft + const Offset(0, corner), gold);
    canvas.drawLine(r.topRight, r.topRight + const Offset(-corner, 0), gold);
    canvas.drawLine(r.topRight, r.topRight + const Offset(0, corner), gold);
    canvas.drawLine(r.bottomLeft, r.bottomLeft + const Offset(corner, 0), gold);
    canvas.drawLine(r.bottomLeft, r.bottomLeft + const Offset(0, -corner), gold);
    canvas.drawLine(
        r.bottomRight, r.bottomRight + const Offset(-corner, 0), gold);
    canvas.drawLine(
        r.bottomRight, r.bottomRight + const Offset(0, -corner), gold);

    final y = r.top + 16 + (r.height - 32) * lineT;
    final line = Paint()
      ..shader = LinearGradient(
        colors: [
          ThemeProvider.gold.withValues(alpha: 0),
          ThemeProvider.gold,
          ThemeProvider.gold.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(r.left, y, r.width, 3));
    canvas.drawRRect(
      RRect.fromLTRBR(r.left + 18, y, r.right - 18, y + 3, const Radius.circular(4)),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant _GPayScanPainter oldDelegate) =>
      oldDelegate.lineT != lineT || oldDelegate.hole != hole;
}
