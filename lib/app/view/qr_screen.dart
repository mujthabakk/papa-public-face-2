// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:salon_user/app/backend/api/handler.dart';
// import 'package:salon_user/app/backend/parse/qr_parse.dart';
// import 'package:salon_user/app/controller/services_controller.dart';
// import 'package:salon_user/app/controller/specialist_controller.dart';
// import 'package:salon_user/app/helper/router.dart';
// import 'package:salon_user/app/util/theme.dart';

// class LiveDecodeBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(LiveDecodeController());
//   }
// }

// class LiveDecodeController extends GetxController implements GetxService {
//   final Rxn<Result> _currentResult = Rxn<Result>();
//   bool _isPremium = false;
//   bool get isPremium => _isPremium;
//   late QrParser parser;

//   void onServices(int uid) {
//     Get.delete<ServicesController>(force: true);
//     Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
//   }

//   void onSpecialist(int uid) {
//     Get.delete<SpecialistController>(force: true);
//     Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
//   }

//   getPremium(String salonId) async {
//     var response = await parser.getPremium({"id": salonId});

//     if (response.statusCode == 200) {
//       Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

//       bool isPremium =
//           myMap['is_premium'] ?? false; // Extracting `is_premium` value

//       _isPremium = isPremium; // Assuming `_isPremium` is a controller variable

//       //update();
//     } else {
//       ApiChecker.checkApi(response);
//     }
//     return _isPremium;
//   }

//   Result? get currentResult => _currentResult.value;

//   Future<void> updateResult(Result result) async {
//     _currentResult.value = result;
//     String remainingText = result.text.trimLeft().substring(1);

//     bool premium = await getPremium(remainingText); // Await the result

//     if (premium) {
//       Get.dialog(
//         Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(Radius.circular(20)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Material(
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 10),
//                         const Text(
//                           "Not Available",
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 15),
//                         const Text(
//                           "Feature Not Available For This Business",
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 child: const Text('OK'),
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: const Size(0, 45),
//                                   backgroundColor: Colors.amber,
//                                   foregroundColor: const Color(0xFFFFFFFF),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: () => Get.back(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     } else {
//       print('qrcodew' + result.text);
//       if (result.text.startsWith('s')) {
//         onServices(int.parse(remainingText));
//       } else if (result.text.startsWith('f')) {
//         onSpecialist(int.parse(remainingText));
//       } else {
//         Get.snackbar(
//           'Invalid QR Code',
//           'Please try again with a valid QR Code',
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     }
//   }
// }

// ////////////////////
// class QRViewExample extends StatefulWidget {
//   const QRViewExample({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _QRViewExampleState();
// }

// getPremium<bool>(String salonId) async {
//   QrParser parser = Get.find();

//   var response = await parser.getPremium({"id": salonId});
//   var isPremium = false;
//   if (response.statusCode == 200) {
//     Map<String, dynamic> myMap = Map<String, dynamic>.from(response.body);

//     isPremium = myMap['is_premium'] ?? false; // Extracting `is_premium` value

//     //_isPremium = isPremium; // Assuming `_isPremium` is a controller variable

//     //update();
//   } else {
//     ApiChecker.checkApi(response);
//   }
//   return isPremium;
// }

// Future<void> checkPremium(int remainingText) async {
//   bool premium = await getPremium(remainingText.toString()); // Await the result

//   if (premium) {
//     Get.dialog(
//       Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(20)),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Material(
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 10),
//                       const Text(
//                         "Not Available",
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 15),
//                       const Text(
//                         "Feature Not Available For This Business",
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 20),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               child: const Text('OK'),
//                               style: ElevatedButton.styleFrom(
//                                 minimumSize: const Size(0, 45),
//                                 backgroundColor: Colors.amber,
//                                 foregroundColor: const Color(0xFFFFFFFF),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onPressed: () => Get.back(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     return;
//   }
// }

// void onServices(int uid) {
//   Get.delete<ServicesController>(force: true);
//   Get.toNamed(AppRouter.getServicesRoutes(), arguments: [uid]);
// }

// void onSpecialist(int uid) {
//   Get.delete<SpecialistController>(force: true);
//   Get.toNamed(AppRouter.getSpecialistRoutes(), arguments: [uid]);
// }

// class _QRViewExampleState extends State<QRViewExample> {
//   Barcode? result;
//   QRViewController? controller;

//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     }
//     controller!.resumeCamera();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: <Widget>[
//           Expanded(flex: 4, child: _buildQrView(context)),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (result != null)
//                     Text(
//                         'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
//                   else
//                     const Text('Scan QR Code For Shop Page'),
//                 ],
//               ),
//             ),
//           ),
//           FutureBuilder(
//               future: controller?.getFlashStatus(),
//               builder: (context, snapshot) {
//                 return IconButton(
//                     onPressed: () async {
//                       await controller?.toggleFlash();
//                       setState(() {});
//                     },
//                     icon: const Icon(Icons.flash_on));
//               }),
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400 ||
//             MediaQuery.of(context).size.height < 400)
//         ? 200.0
//         : 350.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.red,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() async {
//         result = scanData;
//         String resultT = result!.code!;
//         String remainingText = resultT.trimLeft().substring(1);
//         print('qrcodew$remainingText');
//         if (resultT.startsWith('s')) {
//           onServices(int.parse(remainingText));
//         } else if (resultT.startsWith('f')) {
//           onSpecialist(int.parse(remainingText));
//         } else {
//           Get.snackbar(
//               'Invalid QR Code', 'Please try again with a valid QR Code',
//               snackPosition: SnackPosition.BOTTOM);
//         }
//       });
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('no Permission')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:salon_user/app/controller/qr_controller.dart';

class QRViewExample extends StatelessWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final QRController qrController = Get.put(QRController(parser: Get.find()));

    return GetBuilder<QRController>(builder: (qrController) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context, qrController)),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text('Scan QR Code For Shop Page'),
              ),
            ),
            Obx(
              () => IconButton(
                onPressed: () => qrController.toggleFlash(),
                icon: Icon(
                  qrController.isFlashOn.value
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color:
                      qrController.isFlashOn.value ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildQrView(BuildContext context, QRController qrController) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 350.0;
    return QRView(
      key: qrController.qrKey,
      onQRViewCreated: qrController.onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => qrController.onPermissionSet(p),
    );
  }
}
