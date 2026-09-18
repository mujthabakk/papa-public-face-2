import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewHandler {
  static bool isWebUrl(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || uri.scheme.isEmpty) return false;
    final scheme = uri.scheme.toLowerCase();
    return scheme == 'http' ||
        scheme == 'https' ||
        scheme == 'about' ||
        scheme == 'data' ||
        scheme == 'blob';
  }

  static bool isPaymentDeepLink(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url.toLowerCase().startsWith('intent://');
    const schemes = {
      'upi',
      'tez',
      'gpay',
      'phonepe',
      'paytmmp',
      'paytm',
      'bhim',
      'credpay',
      'amazonpay',
      'mobikwik',
      'freecharge',
      'whatsapp',
      'intent',
    };
    return schemes.contains(uri.scheme.toLowerCase()) ||
        url.toLowerCase().startsWith('intent://');
  }

  static bool isPaymentResultUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('payment_success') ||
        lower.contains('payment-success') ||
        lower.contains('status=success') ||
        lower.contains('status=paid') ||
        lower.contains('/success') ||
        lower.contains('razorpay_payment_id') ||
        lower.contains('payment_id=') ||
        (lower.contains('success') &&
            (lower.contains('razorpay') || lower.contains('payment'))) ||
        lower.contains('paid') ||
        lower.contains('callback');
  }

  static Future<bool> openExternalPayment(String url) async {
    try {
      if (url.toLowerCase().startsWith('intent://')) {
        final intentUri = _parseAndroidIntent(url);
        if (intentUri != null && await canLaunchUrl(intentUri)) {
          return launchUrl(intentUri, mode: LaunchMode.externalApplication);
        }
        final fallback = _intentFallbackUrl(url);
        if (fallback != null && await canLaunchUrl(fallback)) {
          return launchUrl(fallback, mode: LaunchMode.externalApplication);
        }
      }

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('openExternalPayment failed: $e');
    }
    return false;
  }

  static Uri? _parseAndroidIntent(String intentUrl) {
    try {
      final schemeMatch =
          RegExp(r'scheme=([^;]+)', caseSensitive: false).firstMatch(intentUrl);
      final scheme = schemeMatch?.group(1) ?? 'upi';
      final body = intentUrl
          .replaceFirst(RegExp(r'^intent://', caseSensitive: false), '')
          .split('#Intent')
          .first;
      final launch = '$scheme://$body';
      return Uri.tryParse(launch);
    } catch (_) {
      return null;
    }
  }

  static Uri? _intentFallbackUrl(String intentUrl) {
    final match = RegExp(r'S\.browser_fallback_url=([^;]+)', caseSensitive: false)
        .firstMatch(intentUrl);
    if (match == null) return null;
    return Uri.tryParse(Uri.decodeComponent(match.group(1)!));
  }

  static Future<NavigationDecision> handleNavigation(
    String url, {
    required VoidCallback onPaymentSuccessHint,
  }) async {
    if (isPaymentResultUrl(url)) {
      onPaymentSuccessHint();
      return NavigationDecision.navigate;
    }

    if (isWebUrl(url)) {
      return NavigationDecision.navigate;
    }

    if (isPaymentDeepLink(url)) {
      await openExternalPayment(url);
      return NavigationDecision.prevent;
    }

    return NavigationDecision.prevent;
  }

  /// Subresource ORB/CORS failures must not hide the Razorpay page.
  static bool shouldShowAsPageError(WebResourceError error) {
    if (error.isForMainFrame == false) return false;
    final text = '${error.description} ${error.url ?? ''}'.toUpperCase();
    const ignore = [
      'ERR_BLOCKED_BY_ORB',
      'ERR_BLOCKED_BY_RESPONSE',
      'ERR_BLOCKED_BY_CLIENT',
      'ERR_UNKNOWN_URL_SCHEME',
      'ERR_ABORTED',
    ];
    for (final token in ignore) {
      if (text.contains(token)) return false;
    }
    if (error.errorType == WebResourceErrorType.unsupportedScheme) {
      return false;
    }
    return true;
  }
}
