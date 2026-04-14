import 'package:facebook_app_events/facebook_app_events.dart';

class FacebookService {
  static final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();

  static Future<void> init() async {
    // Basic initialization if needed
    await _facebookAppEvents.setAdvertiserTracking(enabled: true);
  }

  /// Logs a standard event when a user completes registration.
  static Future<void> logCompletedRegistration({String registrationMethod = 'email'}) async {
    await _facebookAppEvents.logCompletedRegistration(registrationMethod: registrationMethod);
  }

  /// Logs a standard event when a user adds an item to the cart.
  static Future<void> logAddToCart({
    required String id,
    required String type,
    required double price,
    required String currency,
  }) async {
    await _facebookAppEvents.logAddToCart(
      id: id,
      type: type,
      price: price,
      currency: currency,
    );
  }

  /// Logs a standard event when a user initiates checkout.
  static Future<void> logInitiatedCheckout({
    double? totalPrice,
    String? currency,
    String? contentType,
    String? contentId,
    int? numItems,
  }) async {
    await _facebookAppEvents.logInitiatedCheckout(
      totalPrice: totalPrice,
      currency: currency,
      contentType: contentType,
      contentId: contentId,
      numItems: numItems,
    );
  }

  /// Logs a standard event when a user completes a purchase.
  static Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    await _facebookAppEvents.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );
  }

  /// Logs a custom event.
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    await _facebookAppEvents.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  /// Sets user data for better matching (optional but recommended for targeted ads).
  static Future<void> setUserData({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    await _facebookAppEvents.setUserData(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }
}
