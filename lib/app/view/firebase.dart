/*Papabear*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/controller/firebase_controller.dart';
import 'package:salon_user/app/util/constant.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FirebaseVerificationScreen extends StatefulWidget {
  const FirebaseVerificationScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseVerificationScreen> createState() =>
      _FirebaseVerificationScreenState();
}

class _FirebaseVerificationScreenState
    extends State<FirebaseVerificationScreen> {
  bool isLoading = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success_verified')) {
              Get.find<FirebaseController>().onLogin();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(
          '${Get.find<FirebaseController>().apiURL}${AppConstants.openFirebaseVerification}mobile=${Get.find<FirebaseController>().countryCode}${Get.find<FirebaseController>().phoneNumber}'));
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FirebaseController>(builder: (value) {
      return Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          centerTitle: false,
          title: Text('Verify your phone number'.tr,
              style: ThemeProvider.serif(size: 18, color: ThemeProvider.gold)),
        ),
        body: Stack(
          children: <Widget>[
            WebViewWidget(controller: _controller),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: ThemeProvider.whiteColor,
                    ),
                  )
                : const Stack(),
          ],
        ),
      );
    });
  }
}
