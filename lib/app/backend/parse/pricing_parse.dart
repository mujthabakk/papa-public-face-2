import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/pricing_model.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class PricingParser {
  final ApiService apiService;
  final SharedPreferencesManager sharedPreferencesManager;

  PricingParser({
    required this.apiService,
    required this.sharedPreferencesManager,
  });

  Future<({bool success, String message, TaxSettingsData? data})>
      getTaxSettings() async {
    final response =
        await apiService.postPublic(AppConstants.pricingGetTaxSettings, {});
    return _parseTaxSettings(response.body);
  }

  Future<({bool success, String message, TaxSettingsData? data})>
      fetchTaxSettings() async {
    final response =
        await apiService.getPublic(AppConstants.pricingGetTaxSettings);
    return _parseTaxSettings(response.body);
  }

  ({bool success, String message, TaxSettingsData? data}) _parseTaxSettings(
      dynamic body) {
    final map = ApiBody.asMap(body);
    if (map == null) {
      return (
        success: false,
        message: ApiService.connectionIssue,
        data: null,
      );
    }
    final message = map['message']?.toString() ?? '';
    if (map['success'] != true) {
      return (success: false, message: message, data: null);
    }
    final data = map['data'];
    if (data is! Map) {
      return (success: false, message: message, data: null);
    }
    return (
      success: true,
      message: message,
      data: TaxSettingsData.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Future<({bool success, String message, AppointmentPricingData? data})>
      calculateAppointment({
    required double servicesAmount,
    double discount = 0,
    double distanceCost = 0,
    double walletAmount = 0,
  }) async {
    final response = await apiService.postPublic(
      AppConstants.pricingCalculateAppointment,
      {
        'services_amount': servicesAmount,
        'discount': discount,
        'distance_cost': distanceCost,
        'wallet_amount': walletAmount,
      },
    );
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (
        success: false,
        message: ApiService.connectionIssue,
        data: null,
      );
    }
    final message = map['message']?.toString() ?? '';
    if (map['success'] != true) {
      return (success: false, message: message, data: null);
    }
    final data = map['data'];
    if (data is! Map) {
      return (success: false, message: message, data: null);
    }
    return (
      success: true,
      message: message,
      data: AppointmentPricingData.fromJson(Map<String, dynamic>.from(data)),
    );
  }

  Future<({bool success, String message, ProductPricingData? data})>
      calculateProductOrder({
    required double itemsAmount,
    double discount = 0,
    double deliveryCharge = 0,
    double walletAmount = 0,
  }) async {
    final response = await apiService.postPublic(
      AppConstants.pricingCalculateProductOrder,
      {
        'items_amount': itemsAmount,
        'discount': discount,
        'delivery_charge': deliveryCharge,
        'wallet_amount': walletAmount,
      },
    );
    final map = ApiBody.asMap(response.body);
    if (map == null) {
      return (
        success: false,
        message: ApiService.connectionIssue,
        data: null,
      );
    }
    final message = map['message']?.toString() ?? '';
    if (map['success'] != true) {
      return (success: false, message: message, data: null);
    }
    final data = map['data'];
    if (data is! Map) {
      return (success: false, message: message, data: null);
    }
    return (
      success: true,
      message: message,
      data: ProductPricingData.fromJson(Map<String, dynamic>.from(data)),
    );
  }
}
