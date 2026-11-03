import 'package:get/get.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

/// Country home visibility from `pricing/getHomeSections` (and home JSON flags).
/// Admin can hide partners / freelancers / products per country — do not hardcode.
class HomeSections {
  static const prefPartners = 'show_partners';
  static const prefFreelancers = 'show_freelancers';
  static const prefProducts = 'show_products';

  static bool showPartners = true;
  static bool showFreelancers = true;
  static bool showProducts = true;

  static bool? _parseFlag(Map src, List<String> keys) {
    for (final key in keys) {
      if (!src.containsKey(key)) continue;
      final raw = src[key];
      if (raw == true || raw == 1) return true;
      if (raw == false || raw == 0) return false;
      final text = raw?.toString().trim().toLowerCase() ?? '';
      if (text == 'true' || text == '1' || text == 'yes') return true;
      if (text == 'false' || text == '0' || text == 'no') return false;
    }
    return null;
  }

  static void apply({
    bool? showPartners,
    bool? showFreelancers,
    bool? showProducts,
  }) {
    if (showPartners != null) HomeSections.showPartners = showPartners;
    if (showFreelancers != null) HomeSections.showFreelancers = showFreelancers;
    if (showProducts != null) HomeSections.showProducts = showProducts;
    _persist();
  }

  static void applyFromJson(Map json) {
    Map<String, dynamic> map;
    try {
      map = Map<String, dynamic>.from(json);
    } catch (_) {
      return;
    }
    Map<String, dynamic>? nested;
    if (map['data'] is Map) {
      nested = Map<String, dynamic>.from(map['data']);
    }
    apply(
      showPartners: _parseFlag(map, const [
            'show_partners',
            'home_partners_enabled',
          ]) ??
          (nested == null
              ? null
              : _parseFlag(nested, const [
                  'show_partners',
                  'home_partners_enabled',
                ])),
      showFreelancers: _parseFlag(map, const [
            'show_freelancers',
            'home_freelancers_enabled',
          ]) ??
          (nested == null
              ? null
              : _parseFlag(nested, const [
                  'show_freelancers',
                  'home_freelancers_enabled',
                ])),
      showProducts: _parseFlag(map, const [
            'show_products',
            'home_products_enabled',
          ]) ??
          (nested == null
              ? null
              : _parseFlag(nested, const [
                  'show_products',
                  'home_products_enabled',
                ])),
    );
  }

  static void loadFromPrefs(SharedPreferencesManager prefs) {
    if (prefs.isKeyExists(prefPartners)) {
      showPartners = prefs.getBool(prefPartners);
    }
    if (prefs.isKeyExists(prefFreelancers)) {
      showFreelancers = prefs.getBool(prefFreelancers);
    }
    if (prefs.isKeyExists(prefProducts)) {
      showProducts = prefs.getBool(prefProducts);
    }
  }

  static void _persist() {
    if (!Get.isRegistered<SharedPreferencesManager>()) return;
    final prefs = Get.find<SharedPreferencesManager>();
    prefs.putBool(prefPartners, showPartners);
    prefs.putBool(prefFreelancers, showFreelancers);
    prefs.putBool(prefProducts, showProducts);
  }
}
