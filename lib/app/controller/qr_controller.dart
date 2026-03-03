import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:salon_user/app/backend/api/handler.dart';
import 'package:salon_user/app/backend/parse/qr_parse.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';

class QRController extends GetxController implements GetxService {
  final QrParser parser;

  late MobileScannerController scannerController;

  var isPremium = false.obs;
  var isFlashOn = false.obs;
  bool isScanned = false;

  QRController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  void toggleFlash() async {
    await scannerController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  Future<void> checkPremium(String salonId) async {
    var response = await parser.getPremium({"uid": salonId});

    if (response.statusCode == 200) {
      isPremium.value = response.body['is_premium'] ?? false;
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void handleQRCodeScan(BarcodeCapture capture) async {
    if (isScanned) return;
    isScanned = true;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) {
      isScanned = false;
      return;
    }

    String? resultText = barcodes.first.rawValue;
    if (resultText == null || resultText.isEmpty) {
      isScanned = false;
      return;
    }

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

    Future.delayed(const Duration(seconds: 3), () {
      isScanned = false;
    });
  }
}
