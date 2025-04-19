import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/parse/qr_parse.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';

class QRController extends GetxController implements GetxService {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final QrParser parser;
  QRViewController? controller;

  var result = Rxn<Barcode>();
  var isPremium = false.obs;
  var hasPermission = false.obs;
  var isFlashOn = false.obs;
  bool isScanned = false; // 👈 Prevent multiple detections

  QRController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

  @override
  void onClose() {
    controller?.dispose();
    super.onClose();
  }

  void toggleFlash() async {
    if (controller != null) {
      await controller!.toggleFlash();
      isFlashOn.value = await controller!.getFlashStatus() ?? false;
    }
  }

  Future<void> checkPermission() async {
    hasPermission.value =
        (await controller?.getSystemFeatures()) as bool? ?? false;
    update();
  }

  Future<void> checkPremium(String salonId) async {
    var response = await parser.getPremium({"uid": salonId});

    if (response.statusCode == 200) {
      isPremium.value = response.body['is_premium'] ?? false;
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void handleQRCodeScan(Barcode scanData) async {
    if (isScanned) return; // 👈 Ignore duplicate scans
    isScanned = true; // 👈 Block further scans

    result.value = scanData;
    String resultText = scanData.code ?? "";
    if (resultText.isEmpty) return;

    String remainingText = resultText.trimLeft().substring(1);

    if (resultText.startsWith('s')) {
      Get.delete<ServicesController>(force: true);
      Get.toNamed(AppRouter.getServicesRoutes(),
          arguments: [int.parse(remainingText), 1]);
    } else if (resultText.startsWith('f')) {
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(),
          arguments: [int.parse(remainingText), 1]);
    } else {
      Get.snackbar("Invalid QR Code", "Please try again with a valid QR Code",
          snackPosition: SnackPosition.TOP);
    }

    // 👇 Reset the flag after 3 seconds to allow new scans
    Future.delayed(const Duration(seconds: 3), () {
      isScanned = false;
    });
  }

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      handleQRCodeScan(scanData);
    });
  }

  void onPermissionSet(bool permissionGranted) {
    hasPermission.value = permissionGranted;
    if (!permissionGranted) {
      Get.snackbar(
          "Permission Denied", "Camera access is required to scan QR codes",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
