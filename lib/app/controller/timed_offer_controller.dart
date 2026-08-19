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
    if (args is List && args.isNotEmpty) {
      campaignId = int.tryParse('${args[0]}') ?? 0;
      if (args.length > 1) campaignCode = args[1]?.toString() ?? '';
      if (args.length > 2) campaignName = args[2]?.toString() ?? '';
      if (args.length > 3) campaignImage = args[3]?.toString() ?? '';
    }
    loadCampaign();
  }

  Future<void> loadCampaign() async {
    apiCalled = false;
    update();
    _rows = [];
    try {
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
      if (campaignId > 0 || campaignCode.isNotEmpty) {
        final filtered = _rows.where((row) {
          final idMatch = campaignId <= 0 || row.id == campaignId;
          final codeMatch = campaignCode.isEmpty ||
              (row.code ?? '').toLowerCase() == campaignCode.toLowerCase();
          return idMatch && codeMatch;
        }).toList();
        if (filtered.isNotEmpty) _rows = filtered;
      }
    } catch (e) {
      debugPrint('timed offer getAll: $e');
    }
    apiCalled = true;
    update();
  }

  List<TimedOfferRow> _parseRows(dynamic body) {
    final list = <TimedOfferRow>[];
    for (final item in ApiBody.asList(body)) {
      try {
        list.add(TimedOfferRow.fromJson(item));
      } catch (e) {
        debugPrint('Skip timed offer row: $e');
      }
    }
    return list;
  }

  TimedOfferRow? get header {
    if (_rows.isEmpty) return null;
    return _rows.firstWhere(
      (r) => r.isCouponOnly,
      orElse: () => _rows.first,
    );
  }

  List<TimedOfferRow> get bookableRows =>
      _rows.where((r) => r.hasServices).toList();

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
      showToast('API is not available'.tr);
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
