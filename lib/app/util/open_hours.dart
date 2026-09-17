import 'dart:convert';

import 'package:salon_user/app/backend/models/timing_model.dart';

class OpenHours {
  static List<TimingModel> parse(dynamic raw) {
    if (raw == null || raw == 'NA' || raw == '') return [];
    try {
      final items = raw is String ? jsonDecode(raw) : raw;
      if (items is! List) return [];
      return items
          .whereType<Map>()
          .map((v) => TimingModel.fromJson(Map<String, dynamic>.from(v)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static TimingModel? today(List<TimingModel>? timings) {
    if (timings == null || timings.isEmpty) return null;
    final day = DateTime.now().weekday % 7;
    for (final timing in timings) {
      if (timing.day == day) return timing;
    }
    return null;
  }

  static int? _minutes(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) return null;
    return hours * 60 + minutes;
  }

  static bool isOpen(List<TimingModel>? timings) {
    final timing = today(timings);
    if (timing == null) return false;
    var open = _minutes(timing.openTime);
    var close = _minutes(timing.closeTime);
    if (open == null || close == null) return false;
    final now = DateTime.now();
    var current = now.hour * 60 + now.minute;
    if (close <= open) {
      close += 24 * 60;
      if (current < open) current += 24 * 60;
    }
    return current >= open && current <= close;
  }

  static String to12(String? time) {
    if (time == null || time.isEmpty) return '';
    try {
      final parts = time.split(':');
      var hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      hour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour:${minute.toString().padLeft(2, '0')} $period';
    } catch (_) {
      return time;
    }
  }

  static String label(List<TimingModel>? timings) {
    final timing = today(timings);
    if (timing == null) return '';
    if (isOpen(timings)) {
      final until = to12(timing.closeTime);
      return until.isEmpty ? 'Open Now' : 'Open until $until';
    }
    final opens = to12(timing.openTime);
    return opens.isEmpty ? 'Closed' : 'Closed · Opens at $opens';
  }
}
