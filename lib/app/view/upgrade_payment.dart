import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/parse/payment_parse.dart';
import 'package:salon_user/app/backend/parse/upgrade_parse.dart';
import 'package:salon_user/app/helper/payment_webview_handler.dart';
import 'package:salon_user/app/util/theme.dart';
import 'package:salon_user/app/util/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class UpgradePaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final int orderId;
  final int appointmentId;
  final String paymentLinkId;
  final VoidCallback? onPaid;

  const UpgradePaymentScreen({
    Key? key,
    required this.paymentUrl,
    this.orderId = 0,
    this.appointmentId = 0,
    this.paymentLinkId = '',
    this.onPaid,
  }) : super(key: key);

  @override
  State<UpgradePaymentScreen> createState() => _UpgradePaymentScreenState();
}

class _UpgradePaymentScreenState extends State<UpgradePaymentScreen>
    with WidgetsBindingObserver {
  late final WebViewController _controller;
  bool _loading = true;
  bool _verifying = false;
  int _progress = 0;
  String? _error;
  bool _openedExternalApp = false;
  Timer? _resumeVerifyTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _resumeVerifyTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _openedExternalApp) {
      _openedExternalApp = false;
      _resumeVerifyTimer?.cancel();
      _resumeVerifyTimer = Timer(const Duration(milliseconds: 900), () {
        if (mounted) _verifyAndClose(silent: true);
      });
    }
  }

  Future<void> _initWebView() async {
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ThemeProvider.backgroundColor)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _loading = true;
                _error = null;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (mounted && _error == null) {
              setState(() {
                _loading = false;
                _error = error.description;
              });
            }
          },
          onNavigationRequest: (request) async {
            final url = request.url;
            if (PaymentWebViewHandler.isPaymentDeepLink(url)) {
              _openedExternalApp = true;
              await PaymentWebViewHandler.openExternalPayment(url);
              return NavigationDecision.prevent;
            }
            return PaymentWebViewHandler.handleNavigation(
              url,
              onPaymentSuccessHint: () => _verifyAndClose(silent: true),
            );
          },
        ),
      );

    if (controller.platform is AndroidWebViewController) {
      final android = controller.platform as AndroidWebViewController;
      if (kDebugMode) {
        AndroidWebViewController.enableDebugging(true);
      }
      await android.setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
    await _loadPaymentUrl();
    if (mounted) setState(() {});
  }

  Future<void> _loadPaymentUrl() async {
    final url = widget.paymentUrl.trim();
    if (url.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'Payment URL is missing.';
      });
      return;
    }
    try {
      await _controller.loadRequest(
        Uri.parse(url),
        headers: const {
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        },
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Could not open payment page.';
      });
    }
  }

  Future<void> _verifyAndClose({bool silent = false}) async {
    if (_verifying) return;
    setState(() => _verifying = true);

    final isCheckout = widget.appointmentId > 0;
    bool paid = false;
    String message = '';

    if (isCheckout) {
      if (!Get.isRegistered<PaymentParser>()) {
        if (mounted) setState(() => _verifying = false);
        if (!silent) showToast('Payment service unavailable.');
        return;
      }
      final parser = Get.find<PaymentParser>();
      final result = await parser.verifyCheckoutPayment(
        appointmentId: widget.appointmentId,
        paymentLinkId: widget.paymentLinkId,
      );
      if (!mounted) return;
      setState(() => _verifying = false);
      if (!result.success || result.data == null) {
        if (!silent) {
          showToast(result.message.isNotEmpty
              ? result.message
              : 'Unable to verify payment.');
        }
        return;
      }
      paid = result.data!.isPaid;
      message = result.message;
      if (paid) {
        widget.onPaid?.call();
        Get.back(result: result.data);
        return;
      }
    } else {
      if (!Get.isRegistered<UpgradeParser>()) {
        if (mounted) setState(() => _verifying = false);
        if (!silent) showToast('Payment service unavailable.');
        return;
      }
      final parser = Get.find<UpgradeParser>();
      final result = await parser.verifyPayment(
        orderId: widget.orderId,
        paymentLinkId: widget.paymentLinkId,
      );
      if (!mounted) return;
      setState(() => _verifying = false);
      if (!result.success || result.data == null) {
        if (!silent) {
          showToast(result.message.isNotEmpty
              ? result.message
              : 'Unable to verify payment.');
        }
        return;
      }
      paid = result.data!.isPaid;
      message = result.message;
      if (paid) {
        widget.onPaid?.call();
        Get.back(result: result.data);
        return;
      }
    }

    if (!silent) {
      showToast(message.isNotEmpty
          ? message
          : 'Payment is still pending. Complete payment in GPay/UPI app.');
    }
  }

  Future<bool> _onWillPop() async {
    final leave = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: ThemeProvider.surface,
        title: Text('Cancel payment?'.tr,
            style: ThemeProvider.serif(color: ThemeProvider.gold)),
        content: Text('If you already paid, tap "I have paid" to verify.'.tr,
          style: ThemeProvider.sans(color: Colors.white70, size: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Continue'.tr,
                style: ThemeProvider.sans(color: ThemeProvider.gold)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Leave'.tr,
                style: ThemeProvider.sans(color: ThemeProvider.greyColor)),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: ThemeProvider.backgroundColor,
        appBar: AppBar(
          backgroundColor: ThemeProvider.backgroundColor,
          foregroundColor: ThemeProvider.gold,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text('Secure Payment'.tr, style: ThemeProvider.serif(size: 18)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: _loading
                ? LinearProgressIndicator(
                    value: _progress > 0 ? _progress / 100 : null,
                    backgroundColor: const Color(0xFF2A2A2A),
                    color: ThemeProvider.gold,
                    minHeight: 3,
                  )
                : const SizedBox(height: 3),
          ),
          actions: [
            TextButton(
              onPressed: _verifying ? null : () => _verifyAndClose(),
              child: Text(
                _verifying ? '...' : 'I have paid',
                style: ThemeProvider.sans(
                  size: 12,
                  weight: FontWeight.w700,
                  color: ThemeProvider.gold,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF1A1A1A),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline,
                      size: 16, color: ThemeProvider.gold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Pay with GPay, PhonePe, Paytm, UPI & cards'.tr,
                      style: ThemeProvider.sans(
                        size: 11,
                        color: ThemeProvider.greyColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  if (_error == null) WebViewWidget(controller: _controller),
                  if (_error != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off,
                                color: ThemeProvider.gold, size: 40),
                            const SizedBox(height: 12),
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: ThemeProvider.sans(color: Colors.white70),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _error = null;
                                  _loading = true;
                                });
                                _loadPaymentUrl();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeProvider.gold,
                                foregroundColor: Colors.black,
                              ),
                              child: Text('Retry'.tr),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (_loading && _error == null)
                    const Align(
                      alignment: Alignment.topCenter,
                      child: LinearProgressIndicator(
                        color: ThemeProvider.gold,
                        backgroundColor: Colors.transparent,
                        minHeight: 2,
                      ),
                    ),
                  if (_verifying)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                                color: ThemeProvider.gold),
                            const SizedBox(height: 12),
                            Text('Verifying payment...'.tr,
                              style:
                                  ThemeProvider.sans(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> openUpgradePaymentWebView({
  required String paymentUrl,
  int orderId = 0,
  int appointmentId = 0,
  String paymentLinkId = '',
  VoidCallback? onPaid,
}) async {
  return Get.to(
    () => UpgradePaymentScreen(
      paymentUrl: paymentUrl,
      orderId: orderId,
      appointmentId: appointmentId,
      paymentLinkId: paymentLinkId,
      onPaid: onPaid,
    ),
    fullscreenDialog: true,
  );
}
