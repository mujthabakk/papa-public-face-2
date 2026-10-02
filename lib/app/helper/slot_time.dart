import 'package:intl/intl.dart';

/// Slot clocks from the API are mixed: `12:00 PM`, `13:00`, `13:00 PM`.
class SlotTime {
  static DateTime? parseClock(String? raw) {
    var text = (raw ?? '').trim();
    if (text.isEmpty) return null;
    text = text.replaceAll(RegExp(r'\s+'), ' ');

    const patterns = ['h:mm a', 'hh:mm a', 'H:mm', 'HH:mm', 'H:mm:ss', 'HH:mm:ss'];
    for (final pattern in patterns) {
      try {
        return DateFormat(pattern, 'en_US').parse(text);
      } catch (_) {}
    }

    final stripped = text.replaceAll(RegExp(r'\s*(AM|PM)$', caseSensitive: false), '').trim();
    for (final pattern in ['H:mm', 'HH:mm', 'H:mm:ss']) {
      try {
        return DateFormat(pattern).parse(stripped);
      } catch (_) {}
    }
    return null;
  }

  /// Today: hide slots that already started. Other days: keep every slot.
  static bool isAfterNow({String? start, String? date}) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final day = (date ?? '').trim();
    if (day.isNotEmpty && !day.startsWith(today)) return true;

    final clock = parseClock(start);
    if (clock == null) return false;
    final slot = DateTime(now.year, now.month, now.day, clock.hour, clock.minute);
    return !slot.isBefore(now);
  }
}
