import 'dart:convert';
import 'dart:io';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:salon_user/app/backend/api/api_response.dart';
import 'package:salon_user/app/controller/languages_controller.dart';
import 'package:salon_user/app/helper/locale_helper.dart';
import 'package:salon_user/app/helper/shared_pref.dart';
import 'package:salon_user/app/util/constant.dart';

class ApiService extends GetxService {
  final String appBaseUrl;
  final SharedPreferencesManager sharedPreferencesManager;
  static const String connectionIssue = 'Connection failed!';
  final int timeoutInSeconds = 30;
  static const int _maxLogChars = 8000;
  HttpWithMiddleware httpp = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.NONE),
  ]);

  ApiService({
    required this.appBaseUrl,
    required this.sharedPreferencesManager,
  });

  String get _lang =>
      sharedPreferencesManager.getString(LocaleHelper.prefLanguage) ??
      AppConstants.defaultLanguageApp;

  Map<String, String> get _localeHeaders => {
        'X-App-Language': _lang,
        'Accept-Language': _lang,
      };

  String _withLangQuery(String uri) {
    if (uri.contains('lang=')) return uri;
    final separator = uri.contains('?') ? '&' : '?';
    return '$uri${separator}lang=$_lang';
  }

  /// Always set body lang to the same value as headers (never mix).
  dynamic _withLangBody(dynamic body) {
    if (body is Map) {
      final copy = Map<String, dynamic>.from(body);
      copy['lang'] = _lang;
      return copy;
    }
    return body;
  }

  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    return {
      ..._localeHeaders,
      if (headers != null) ...headers,
    };
  }

  Future<Response> getPublic(String uri) async {
    final path = _withLangQuery(uri);
    final url = appBaseUrl + path;
    _logRequest('GET PUBLIC', url, path,
        params: null, headers: _localeHeaders);
    try {
      http.Response response = await httpp
          .get(
            Uri.parse(url),
            headers: _localeHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, url);
    } catch (e) {
      _logError('GET PUBLIC', url, e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> getOther(String uri) async {
    _logRequest('GET OTHER', uri, uri, params: null);
    try {
      http.Response response = await httpp
          .get(
            Uri.parse(uri),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      _logError('GET OTHER', uri, e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getExternal(String uri) async {
    _logRequest('GET EXTERNAL', uri, uri, params: null);
    try {
      http.Response response = await httpp
          .get(
            Uri.parse(uri),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, uri);
    } catch (e) {
      _logError('GET EXTERNAL', uri, e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> getPrivate(String uri, String token) async {
    final path = _withLangQuery(uri);
    final url = appBaseUrl + path;
    final headers = _mergeHeaders({
      'Content-Type': 'application/json;',
      'Authorization': 'Bearer $token',
    });
    _logRequest('GET PRIVATE', url, path, params: null, headers: headers);
    try {
      http.Response response = await httpp
          .get(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, url);
    } catch (e) {
      _logError('GET PRIVATE', url, e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> uploadFiles(
    String uri,
    List<MultipartBody> multipartBody,
  ) async {
    final path = _withLangQuery(uri);
    final url = appBaseUrl + path;
    final files = multipartBody
        .map((e) => {'key': e.key, 'file': e.file.path})
        .toList();
    _logRequest('UPLOAD', url, path, params: {'files': files});
    try {
      http.MultipartRequest request =
          http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(_localeHeaders);
      for (MultipartBody multipart in multipartBody) {
        File file = File(multipart.file.path);
        request.files.add(http.MultipartFile(
          multipart.key,
          file.readAsBytes().asStream(),
          file.lengthSync(),
          filename: file.path.split('/').last,
        ));
      }
      http.Response response =
          await http.Response.fromStream(await request.send());
      return parseResponse(response, url);
    } catch (e) {
      _logError('UPLOAD', url, e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Future<Response> postPublic(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    final payload = _withLangBody(body);
    final url = appBaseUrl + uri;
    final mergedHeaders = _mergeHeaders({
      'Content-Type': 'application/json',
      if (headers != null) ...headers,
    });
    _logRequest('POST PUBLIC', url, uri, params: payload, headers: mergedHeaders);
    try {
      http.Response response = await httpp
          .post(
            Uri.parse(url),
            headers: mergedHeaders,
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, url);
    } catch (e) {
      _logError('POST PUBLIC', url, e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postPrivate(
    String uri,
    dynamic body,
    String token,
  ) async {
    final payload = _withLangBody(body);
    final url = appBaseUrl + uri;
    final headers = _mergeHeaders({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    _logRequest('POST PRIVATE', url, uri, params: payload, headers: headers);
    try {
      http.Response response = await httpp
          .post(Uri.parse(url), body: jsonEncode(payload), headers: headers)
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, url);
    } catch (e) {
      _logError('POST PRIVATE', url, e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> logout(
    String uri,
    String token,
  ) async {
    final path = _withLangQuery(uri);
    final url = appBaseUrl + path;
    final headers = _mergeHeaders({
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    _logRequest('POST LOGOUT', url, path, params: null, headers: headers);
    try {
      http.Response response = await httpp
          .post(Uri.parse(url), headers: headers)
          .timeout(Duration(seconds: timeoutInSeconds));
      return parseResponse(response, url);
    } catch (e) {
      _logError('POST LOGOUT', url, e);
      return const Response(statusCode: 1, statusText: connectionIssue);
    }
  }

  Response parseResponse(http.Response res, String uri) {
    dynamic body;
    try {
      body = jsonDecode(res.body);
    } catch (e) {
      body = res.body;
    }
    Response response = Response(
      body: body != '' ? body : res.body,
      bodyString: res.body.toString(),
      headers: res.headers,
      statusCode: res.statusCode,
      statusText: res.reasonPhrase,
    );
    if (response.statusCode != 200 &&
        response.body != null &&
        response.body is! String) {
      if (response.body.toString().startsWith('{errors: [{code:')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: 'error');
      } else if (response.body.toString().startsWith('{message')) {
        response = Response(
            statusCode: response.statusCode,
            body: response.body,
            statusText: response.body['message']);
      }
    } else if (response.statusCode != 200 && response.body == null) {
      response = const Response(statusCode: 0, statusText: connectionIssue);
    }
    _logResponse(uri, response);
    _syncLocaleFromResponse(response.body);
    return response;
  }

  void _syncLocaleFromResponse(dynamic body) {
    final meta = ApiBody.localeMeta(body);
    if (meta == null) return;
    if (!Get.isRegistered<LanguagesController>()) return;

    void sync() {
      if (!Get.isRegistered<LanguagesController>()) return;
      Get.find<LanguagesController>().applyResponseLocale(meta);
    }

    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      sync();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => sync());
    }
  }

  void _logRequest(
    String method,
    String url,
    String path, {
    dynamic params,
    Map<String, String>? headers,
  }) {
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌────────────── API REQUEST ──────────────')
      ..writeln('│ Method   : $method')
      ..writeln('│ Base URL : $appBaseUrl')
      ..writeln('│ Path     : $path')
      ..writeln('│ Full URL : $url')
      ..writeln('│ Params   : ${_pretty(params ?? {})}');
    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('│ Headers  : ${_pretty(_redactHeaders(headers))}');
    }
    buffer.writeln('└─────────────────────────────────────────');
    _print(buffer.toString());
  }

  void _logResponse(String url, Response response) {
    final model = response.body;
    final buffer = StringBuffer()
      ..writeln('')
      ..writeln('┌────────────── API RESPONSE ─────────────')
      ..writeln('│ URL      : $url')
      ..writeln('│ Status   : ${response.statusCode} ${response.statusText ?? ''}')
      ..writeln('│ Model    : ${_pretty(model)}')
      ..writeln('└─────────────────────────────────────────');
    _print(buffer.toString());
  }

  void _logError(String method, String url, Object error) {
    _print(
      '\n┌────────────── API ERROR ────────────────\n'
      '│ Method   : $method\n'
      '│ Base URL : $appBaseUrl\n'
      '│ Full URL : $url\n'
      '│ Error    : $error\n'
      '└─────────────────────────────────────────',
    );
  }

  void _print(String message) {
    const chunk = 800;
    for (var i = 0; i < message.length; i += chunk) {
      final end = i + chunk < message.length ? i + chunk : message.length;
      debugPrint(message.substring(i, end));
    }
  }

  Map<String, String> _redactHeaders(Map<String, String> headers) {
    final copy = Map<String, String>.from(headers);
    final auth = copy['Authorization'];
    if (auth != null && auth.length > 16) {
      copy['Authorization'] =
          '${auth.substring(0, 12)}...${auth.substring(auth.length - 6)}';
    }
    return copy;
  }

  String _pretty(dynamic value) {
    try {
      final encoded = const JsonEncoder.withIndent('  ').convert(value);
      if (encoded.length <= _maxLogChars) return encoded;
      return '${encoded.substring(0, _maxLogChars)}\n... truncated (${encoded.length} chars)';
    } catch (_) {
      final raw = value.toString();
      if (raw.length <= _maxLogChars) return raw;
      return '${raw.substring(0, _maxLogChars)}\n... truncated (${raw.length} chars)';
    }
  }
}

class MultipartBody {
  String key;
  XFile file;
  MultipartBody(this.key, this.file);
}
