import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/backend/models/coupons_model.dart';
import 'package:salon_user/app/backend/models/timed_offer_model.dart';
import 'package:salon_user/app/backend/parse/home_parse.dart';
import 'package:salon_user/app/controller/services_controller.dart';
import 'package:salon_user/app/controller/specialist_controller.dart';
import 'package:salon_user/app/helper/router.dart';
import 'package:salon_user/app/util/toast.dart';

class TimedOfferController extends GetxController implements GetxService {
  final HomeParser parser;

  bool apiCalled = false;
  bool showAllCampaigns = false;
  int campaignId = 0;
  String campaignCode = '';
  String campaignName = '';
  String campaignImage = '';

  List<TimedOfferRow> _rows = [];
  List<TimedOfferRow> get rows => _rows;

  TimedOfferController({required this.parser});

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is List && args.isNotEmpty && '${args[0]}' == 'all') {
      showAllCampaigns = true;
    } else if (args is List && args.isNotEmpty) {
      campaignId = int.tryParse('${args[0]}') ?? 0;
      if (args.length > 1) campaignCode = args[1]?.toString() ?? '';
      if (args.length > 2) campaignName = args[2]?.toString() ?? '';
      if (args.length > 3) campaignImage = args[3]?.toString() ?? '';
    } else {
      showAllCampaigns = true;
    }
    loadCampaign();
  }

  Future<void> loadCampaign() async {
    apiCalled = false;
    update();
    _rows = [];
    try {
      if (showAllCampaigns) {
        var response = await parser.getTimedOffersAll();
        _rows = _parseRows(response.body);
        if (_rows.isEmpty) {
          response = await parser.postTimedOffersAll({});
          _rows = _parseRows(response.body);
        }
      } else {
        var response = await parser.getTimedOffersAll(
          id: campaignId > 0 ? campaignId : null,
          code: campaignCode.isNotEmpty ? campaignCode : null,
        );
        _rows = _parseRows(response.body);
        if (_rows.isEmpty) {
          response = await parser.postTimedOffersAll({
            if (campaignId > 0) 'id': campaignId,
            if (campaignCode.isNotEmpty) 'code': campaignCode,
          });
          _rows = _parseRows(response.body);
        }
        if (_rows.isEmpty) {
          response = await parser.getTimedOffersAll();
          _rows = _parseRows(response.body);
        }
        // Keep the API list as returned. Partner rows can share id=1
        // but use a different coupon (e.g. Style N Care / TEST123).
      }
    } catch (e) {
      debugPrint('timed offer getAll: $e');
    }
    apiCalled = true;
    update();
  }

  List<TimedOfferRow> _parseRows(dynamic body) {
    final list = <TimedOfferRow>[];
    final items = ApiBody.asList(
      body,
      keys: const [
        'data',
        'timed_offers',
        'campaigns',
        'offers',
        'items',
        'result',
        'list',
      ],
    );
    for (final item in items) {
      try {
        if (item is Map &&
            (item['rows'] is List ||
                item['partners'] is List ||
                item['items'] is List)) {
          final nested = item['rows'] ?? item['partners'] ?? item['items'];
          if (nested is List) {
            for (final child in nested) {
              if (child is! Map) continue;
              final merged = Map<String, dynamic>.from(item);
              merged.remove('rows');
              merged.remove('partners');
              merged.remove('items');
              if (child.containsKey('partner') || child.containsKey('services')) {
                merged.addAll(Map<String, dynamic>.from(child));
              } else {
                merged['partner'] = child;
              }
              list.add(TimedOfferRow.fromJson(merged));
            }
            continue;
          }
        }
        list.add(TimedOfferRow.fromJson(item));
      } catch (e) {
        debugPrint('Skip timed offer row: $e');
      }
    }
    return list;
  }

  List<List<TimedOfferRow>> get campaignGroups {
    final groups = <String, List<TimedOfferRow>>{};
    final order = <String>[];
    for (final row in _rows) {
      final key = [
        (row.name ?? '').trim().toLowerCase(),
        row.startTime ?? '',
        row.endTime ?? '',
      ].join('|');
      if (!groups.containsKey(key)) {
        groups[key] = [];
        order.add(key);
      }
      groups[key]!.add(row);
    }
    return [for (final key in order) groups[key]!];
  }

  TimedOfferRow? get header {
    if (_rows.isEmpty) return null;
    return _rows.firstWhere(
      (r) => r.isCouponOnly,
      orElse: () => _rows.first,
    );
  }

  List<TimedOfferRow> get bookableRows =>
      _rows.where((r) => r.hasPartner).toList();

  TimedOfferRow? get couponRow {
    for (final row in _rows) {
      if (row.isCouponOnly && row.displayCode.isNotEmpty) return row;
    }
    return null;
  }

  void copyCode(TimedOfferRow row) {
    if (!row.isScheduleActive) {
      showToast(row.scheduleHint.isNotEmpty
          ? row.scheduleHint
          : 'Offer is not live now');
      return;
    }
    if (row.displayCode.isEmpty) {
      showToast('Data is not available'.tr);
      return;
    }
    Clipboard.setData(ClipboardData(text: row.displayCode));
    successToast('Code copied');
  }

  void bookRow(TimedOfferRow row) {
    if (!row.isScheduleActive) {
      showToast(row.scheduleHint.isNotEmpty
          ? row.scheduleHint
          : 'Offer is not live now');
      return;
    }
    final partner = row.partner;
    if (partner == null || (partner.id ?? 0) <= 0) return;
    final serviceIds = <int>{};
    for (final service in row.services) {
      if ((service.id ?? 0) > 0) serviceIds.add(service.id!);
      if ((service.serviceId ?? 0) > 0) serviceIds.add(service.serviceId!);
    }
    final ids = serviceIds.toList();
    if ((partner.type ?? '').toLowerCase() == 'individual') {
      Get.delete<SpecialistController>(force: true);
      Get.toNamed(AppRouter.getSpecialistRoutes(),
          arguments: [partner.id, 0, ids]);
      return;
    }
    Get.delete<ServicesController>(force: true);
    Get.toNamed(AppRouter.getServicesRoutes(),
        arguments: [partner.id, 0, ids]);
  }
}
