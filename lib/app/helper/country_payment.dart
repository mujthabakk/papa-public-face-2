import 'package:salon_user/app/backend/api/api.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/payment_models.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

/// Checkout methods from `payments/getByCountry`.
class CountryPaymentData {
  final String country;
  final bool codEnabled;
  final bool onlineEnabled;
  final int defaultPayMethod;
  final List<PaymentModel> methods;

  CountryPaymentData({
    required this.country,
    required this.codEnabled,
    required this.onlineEnabled,
    required this.defaultPayMethod,
    required this.methods,
  });

  factory CountryPaymentData.fromJson(Map<String, dynamic> json) {
    final methodsRaw = json['methods'] ?? json['data'];
    final methods = <PaymentModel>[];
    if (methodsRaw is List) {
      for (final item in methodsRaw) {
        if (item is! Map) continue;
        final model =
            PaymentModel.fromJson(Map<String, dynamic>.from(item));
        if ((model.status ?? 1) != 1) continue;
        if ((model.id ?? 0) <= 0) continue;
        methods.add(model);
      }
    }
    bool flag(dynamic v, {bool fallback = true}) {
      if (v == null) return fallback;
      return v == true || v.toString() == '1' || v.toString().toLowerCase() == 'true';
    }

    final defaultId = int.tryParse(
          json['default_pay_method']?.toString() ?? '',
        ) ??
        0;
    return CountryPaymentData(
      country: json['country']?.toString() ?? '',
      codEnabled: flag(json['cod_enabled'] ?? json['cod_available']),
      onlineEnabled: flag(json['online_enabled'] ?? json['online_available']),
      defaultPayMethod: defaultId,
      methods: methods,
    );
  }

  static CountryPaymentData? tryParse(dynamic body) {
    final map = ApiBody.asMap(body);
    if (map == null || map['success'] != true) return null;
    final data = map['data'];
    if (data is Map) {
      return CountryPaymentData.fromJson(Map<String, dynamic>.from(data));
    }
    if (map['methods'] is List || map['data'] is List) {
      return CountryPaymentData.fromJson(map);
    }
    return null;
  }
}

class CountryPaymentApi {
  static Future<CountryPaymentData?> fetch({
    required ApiService apiService,
    required SharedPreferencesManager prefs,
  }) async {
    final country = _countryValue(prefs);
    final uid = prefs.getString('uid') ?? '';
    final body = <String, dynamic>{
      if (country.isNotEmpty) 'country': country,
      if (country.isNotEmpty) 'preferred_country': country,
      if (country.isNotEmpty) 'selected_country': country,
      if (uid.isNotEmpty && uid != '0')
        'uid': int.tryParse(uid) ?? uid,
    };
    var response = await apiService.postPublic(
      AppConstants.paymentsGetByCountry,
      body,
    );
    var parsed = CountryPaymentData.tryParse(response.body);
    if (parsed == null) {
      final qs = country.isEmpty
          ? AppConstants.paymentsGetByCountry
          : '${AppConstants.paymentsGetByCountry}?country=${Uri.encodeQueryComponent(country)}';
      response = await apiService.getPublic(qs);
      parsed = CountryPaymentData.tryParse(response.body);
    }
    return parsed;
  }

  static String _countryValue(SharedPreferencesManager prefs) {
    final name = (prefs.getString(LocaleHelper.prefCountryName) ?? '').trim();
    if (name.isNotEmpty) return name;
    return (prefs.getString(LocaleHelper.prefCountry) ?? '').trim();
  }

  static int pickDefault({
    required List<PaymentModel> methods,
    required int preferred,
    bool cashBlocked = false,
  }) {
    bool allowed(PaymentModel m) {
      if (cashBlocked && m.isCod) return false;
      return true;
    }

    final preferredMatch = methods.where((m) => m.id == preferred && allowed(m));
    if (preferredMatch.isNotEmpty) return preferredMatch.first.id!;
    final first = methods.where(allowed);
    if (first.isNotEmpty) return first.first.id!;
    return methods.isNotEmpty ? methods.first.id ?? 0 : 0;
  }
}
