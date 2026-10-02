import 'package:get/get.dart';
import 'package:salon_user/app/helper/shared_pref.dart';

/// Country/user tax visibility from `pricing/getTaxAvailability`.
/// When [showTax] is false, hide GST/VAT/Taxable rows; pay amount stays unchanged.
class TaxAvailability {
  static const prefAvailable = 'tax_available';
  static const prefType = 'tax_type';

  static bool available = true;
  static String taxType = '';

  static bool get showTax => available;

  static String get taxTypeLabel {
    final t = taxType.trim();
    if (t.isEmpty) return 'Tax';
    return t.toUpperCase();
  }

  static void apply({bool? available, String? taxType}) {
    if (available != null) {
      TaxAvailability.available = available;
    }
    final next = (taxType ?? '').trim();
    if (next.isNotEmpty) {
      TaxAvailability.taxType = next.toUpperCase();
    }
    _persist();
  }

  static void loadFromPrefs(SharedPreferencesManager prefs) {
    if (prefs.isKeyExists(prefAvailable)) {
      available = prefs.getBool(prefAvailable);
    }
    final stored = prefs.getString(prefType) ?? '';
    if (stored.isNotEmpty) {
      taxType = stored.toUpperCase();
    }
  }

  static void _persist() {
    if (!Get.isRegistered<SharedPreferencesManager>()) return;
    final prefs = Get.find<SharedPreferencesManager>();
    prefs.putBool(prefAvailable, available);
    if (taxType.isNotEmpty) {
      prefs.putString(prefType, taxType);
    }
  }
}
