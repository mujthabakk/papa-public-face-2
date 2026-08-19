import 'dart:convert';
import 'package:get/get.dart';

class ApiBody {
  static bool isSuccess(Response response) {
    final code = response.statusCode ?? 0;
    if (code == 200 || code == 201) return true;
    final map = asMap(response.body);
    if (map == null) return false;
    return map['success'] == true || map['status'] == 200;
  }

  static Map<String, dynamic>? asMap(dynamic body) {
    if (body == null) return null;
    if (body is Map) {
      try {
        return Map<String, dynamic>.from(body);
      } catch (_) {
        return null;
      }
    }
    if (body is String) {
      final text = body.trim();
      if (text.isEmpty || text.startsWith('<')) return null;
      try {
        final decoded = jsonDecode(text);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        if (decoded is List) return {'data': decoded};
      } catch (_) {}
    }
    return null;
  }

  static List<dynamic> asList(dynamic body, {List<String>? keys}) {
    if (body is List) return body;
    final map = asMap(body);
    if (map == null) return [];
    final searchKeys = keys ??
        const [
          'data',
          'salon',
          'categories',
          'individual',
          'banners',
          'products',
          'offers',
          'coupons',
          'items',
          'result',
          'list',
        ];
    for (final key in searchKeys) {
      final value = map[key];
      if (value is List) return value;
      if (value is Map) {
        final nested = asList(value, keys: searchKeys);
        if (nested.isNotEmpty) return nested;
      }
    }
    return [];
  }

  static String? message(Response response) {
    final map = asMap(response.body) ?? asMap(response.bodyString);
    if (map != null) {
      final msg = map['message'] ?? map['error'] ?? map['msg'];
      if (msg != null) {
        final text = msg.toString().trim();
        if (text.isNotEmpty && !text.startsWith('<')) return text;
      }
    }
    final raw = (response.bodyString ?? '').trim();
    if (raw.startsWith('<')) return null;
    return null;
  }
}
