import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/pricing_model.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/helper/tax_availability.dart';
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

  String _appCountry([String? country]) {
    final iso = (country ??
            sharedPreferencesManager.getString(LocaleHelper.prefCountry) ??
            'IN')
        .trim()
        .toUpperCase();
    return iso.isEmpty ? 'IN' : iso;
  }

  /// GET|POST /api/v1/pricing/getTaxAvailability — country-based GST/VAT check.
  Future<({bool success, String message, TaxAvailabilityData? data})>
      fetchTaxAvailability({int? uid, String? country}) async {
    final iso = _appCountry(country);
    final body = <String, dynamic>{
      'country': iso,
      'country_code': iso,
    };
    final rawUid = uid?.toString() ??
        sharedPreferencesManager.getString('uid') ??
        '';
    if (rawUid.isNotEmpty && rawUid != '0') {
      body['uid'] = int.tryParse(rawUid) ?? rawUid;
    }
    var response = await apiService.postPublic(
      AppConstants.pricingGetTaxAvailability,
      body,
    );
    var parsed = _parseTaxAvailability(response.body);
    if (!parsed.success) {
      final qs =
          '${AppConstants.pricingGetTaxAvailability}?country=$iso&country_code=$iso'
          '${body.containsKey('uid') ? '&uid=${body['uid']}' : ''}';
      response = await apiService.getPublic(qs);
      parsed = _parseTaxAvailability(response.body);
    }
    if (parsed.success && parsed.data != null) {
      TaxAvailability.apply(
        available: parsed.data!.taxAvailable,
        taxType: parsed.data!.taxType,
      );
    }
    return parsed;
  }

  ({bool success, String message, TaxAvailabilityData? data})
      _parseTaxAvailability(dynamic body) {
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
      data: TaxAvailabilityData.fromJson(Map<String, dynamic>.from(data)),
    );
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
