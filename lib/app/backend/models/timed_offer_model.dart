import 'package:salon_user/app/backend/models/coupons_model.dart';

class TimedOfferIcon {
  int? id;
  String? name;
  String? code;
  String? image;
  String? description;

  TimedOfferIcon({
    this.id,
    this.name,
    this.code,
    this.image,
    this.description,
  });

  factory TimedOfferIcon.fromJson(dynamic json) {
    final map =
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    return TimedOfferIcon(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString(),
      code: map['code']?.toString(),
      image: map['image']?.toString() ?? map['cover']?.toString(),
      description:
          map['description']?.toString() ?? map['short_description']?.toString(),
    );
  }
}

class TimedOfferRow {
  int? id;
  String? name;
  String? code;
  String? shortDescription;
  String? description;
  String? image;
  String? discountText;
  String? discountType;
  double? discountValue;
  String? couponCode;
  String? couponScope;
  int? statusValue;
  bool isLive = false;
  bool hasEnded = false;
  String? statusText;
  String? nextStartText;
  String? scheduleType;
  String? startTime;
  String? endTime;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? expireDate;
  String? createdByType;
  int? createdById;
  String? createdByName;
  OfferPartnerModel? partner;
  List<OfferServiceModel> services = [];

  TimedOfferRow();

  factory TimedOfferRow.fromJson(dynamic json) {
    final map =
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    final row = TimedOfferRow();
    row.id = int.tryParse(map['id']?.toString() ?? '');
    row.name = map['name']?.toString();
    row.code = map['code']?.toString();
    row.shortDescription = map['short_description']?.toString();
    row.description = map['description']?.toString();
    row.image = map['image']?.toString() ?? map['cover']?.toString();
    row.discountText = map['discount_text']?.toString();
    row.discountType = map['discount_type']?.toString();
    row.discountValue =
        double.tryParse(map['discount_value']?.toString() ?? '');

    if (map['coupon'] is Map) {
      final coupon = Map<String, dynamic>.from(map['coupon']);
      row.couponCode = coupon['code']?.toString() ?? row.code;
      row.couponScope = coupon['scope']?.toString();
    } else {
      row.couponCode = row.code;
    }

    if (map['status'] is Map) {
      final status = Map<String, dynamic>.from(map['status']);
      row.statusValue = int.tryParse(status['value']?.toString() ?? '');
      row.isLive = status['is_live'] == true;
      row.hasEnded = status['has_ended'] == true;
      row.statusText = status['text']?.toString();
      row.nextStartText = status['next_start_text']?.toString();
    } else {
      row.statusValue = int.tryParse(map['status']?.toString() ?? '') ?? 1;
    }

    if (map['schedule'] is Map) {
      final schedule = Map<String, dynamic>.from(map['schedule']);
      row.scheduleType = schedule['type']?.toString();
      row.startTime = schedule['start_time']?.toString();
      row.endTime = schedule['end_time']?.toString();
      row.startDate = _parseDay(schedule['start_date']);
      row.endDate = _parseDay(schedule['end_date']);
      row.expireDate = _parseDay(schedule['expire_date']);
    }

    if (map['created_by'] is Map) {
      final created = Map<String, dynamic>.from(map['created_by']);
      row.createdByType = created['type']?.toString();
      row.createdById = int.tryParse(created['id']?.toString() ?? '');
      row.createdByName = created['name']?.toString();
    }

    if (map['partner'] is Map) {
      row.partner = OfferPartnerModel.fromJson(map['partner']);
    }

    if (map['services'] is List) {
      row.services = (map['services'] as List)
          .map((e) => OfferServiceModel.fromJson(e))
          .where((s) => (s.name ?? '').isNotEmpty)
          .toList();
    }
    return row;
  }

  bool get hasServices => services.isNotEmpty && (partner?.id ?? 0) > 0;

  bool get isCouponOnly => !hasServices;

  String get displayCode =>
      (couponCode ?? code ?? '').trim();

  bool get isScheduleActive {
    if (hasEnded || statusValue == 0) return false;
    final now = DateTime.now();
    final start = startDate;
    final last = expireDate ?? endDate;
    if (start != null && now.isBefore(start)) return false;
    if (last != null && now.isAfter(_endOfDay(last))) return false;

    final startMins = _toMinutes(startTime);
    final endMins = _toMinutes(endTime);
    if (startMins == null || endMins == null) return true;

    final nowMins = now.hour * 60 + now.minute;
    if (endMins <= startMins) {
      return nowMins >= startMins || nowMins < endMins;
    }
    return nowMins >= startMins && nowMins < endMins;
  }

  String get scheduleHint {
    if ((statusText ?? '').trim().isNotEmpty) return statusText!.trim();
    if ((nextStartText ?? '').trim().isNotEmpty) return nextStartText!.trim();
    final time = timeWindowText;
    final dates = _dateWindowText;
    if (time.isNotEmpty && dates.isNotEmpty) return '$time · $dates';
    if (time.isNotEmpty) return time;
    return dates;
  }

  String get timeWindowText {
    final start = _formatClock(startTime);
    final end = _formatClock(endTime);
    if (start == null || end == null) return '';
    return '$start – $end';
  }

  String get _dateWindowText {
    final start = _formatDay(startDate);
    final last = _formatDay(expireDate ?? endDate);
    if (start == null && last == null) return '';
    if (start != null && last != null && start != last) return '$start – $last';
    return start ?? last ?? '';
  }
}

DateTime? _parseDay(dynamic value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty || text == 'null') return null;
  final parsed = DateTime.tryParse(text);
  if (parsed == null) return null;
  return DateTime(parsed.year, parsed.month, parsed.day);
}

DateTime _endOfDay(DateTime day) {
  return DateTime(day.year, day.month, day.day, 23, 59, 59);
}

int? _toMinutes(String? time) {
  if (time == null || time.trim().isEmpty || time == 'null') return null;
  final parts = time.trim().split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return hour * 60 + minute;
}

String? _formatClock(String? time) {
  final mins = _toMinutes(time);
  if (mins == null) return null;
  final hour = mins ~/ 60;
  final minute = mins % 60;
  final suffix = hour >= 12 ? 'PM' : 'AM';
  final h12 = hour % 12 == 0 ? 12 : hour % 12;
  final mm = minute.toString().padLeft(2, '0');
  return '$h12:$mm $suffix';
}

String? _formatDay(DateTime? day) {
  if (day == null) return null;
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return '${day.day} ${months[day.month - 1]} ${day.year}';
}
