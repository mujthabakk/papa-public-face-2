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
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.backgroundColor,
          title: Text('Scan QR Code',
              style: ThemeProvider.serif(size: 20, color: ThemeProvider.gold)),
          iconTheme: const IconThemeData(color: ThemeProvider.gold),
          actions: [
            Obx(
              () => IconButton(
                onPressed: () => controller.toggleFlash(),
                icon: Icon(
                  controller.isFlashOn.value ? Icons.flash_on : Icons.flash_off,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: MobileScanner(
                controller: controller.scannerController,
                onDetect: (capture) => controller.handleQRCodeScan(capture),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Scan QR Code For Shop Page',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      );
    });
  }
}
