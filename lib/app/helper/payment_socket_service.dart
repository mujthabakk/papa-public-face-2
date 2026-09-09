import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:salon_user/app/backend/models/payment_options_model.dart';
import 'package:salon_user/app/util/constant.dart';

typedef PaymentPopupCallback = void Function(Map<String, dynamic> payload);
typedef PaymentCompletedCallback = void Function(Map<String, dynamic> payload);

/// Public-app listener on the per-customer channel `payment-status-<uid>`.
/// Cluster ap2 → ws-ap2.pusher.com (never api-ap2.pusher.com). Binds two
/// events: `pay-now-popup` (owner marked the service completed — show the
/// Pay Now modal) and `payment-completed` (customer actually paid).
class PaymentSocketService {
  PusherChannelsFlutter? _pusher;
  String? _channel;
  String _payNowEvent = AppConstants.paymentPusherPayNowEvent;
  String _completedEvent = AppConstants.paymentPusherEvent;
  int _uid = 0;
  PaymentPopupCallback? _onPayNowPopup;
  PaymentCompletedCallback? _onCompleted;
  bool _listening = false;
  bool _handling = false;

  bool get isListening => _listening;

  Future<void> start({
    PaymentSocketConfig? config,
    required PaymentPopupCallback onPayNowPopup,
    required PaymentCompletedCallback onCompleted,
    required int uid,
    int bookId = 0,
  }) async {
    final cfg = _normalize(config ?? PaymentSocketConfig.defaults(uid: uid));
    if (cfg.key.isEmpty) {
      debugPrint('PaymentSocket: missing key');
      return;
    }

    _onPayNowPopup = onPayNowPopup;
    _onCompleted = onCompleted;
    _uid = uid;
    // NOTE: cfg.event is the payment-completed event; the backend's generic
    // `event` field is the pay-now-popup event, not this one — see
    // PaymentSocketConfig.fromJson.
    _payNowEvent = cfg.payNowEvent.isNotEmpty
        ? cfg.payNowEvent
        : AppConstants.paymentPusherPayNowEvent;
    _completedEvent = cfg.event.isNotEmpty
        ? cfg.event
        : AppConstants.paymentPusherEvent;

    _pusher = PusherChannelsFlutter.getInstance();

    try {
      await _pusher!.init(
        apiKey: cfg.key,
        cluster: cfg.cluster,
        useTLS: cfg.forceTls,
        onConnectionStateChange: (current, previous) {
          debugPrint('PaymentSocket connection: $previous → $current');
        },
        onError: (message, code, exception) {
          debugPrint('PaymentSocket error: $message code=$code $exception');
        },
        onSubscriptionSucceeded: (channelName, data) {
          debugPrint('PaymentSocket subscribed OK: $channelName');
        },
        onSubscriptionError: (message, error) {
          debugPrint('PaymentSocket subscribe error: $message $error');
        },
        // Must be dynamic — PusherChannelsFlutter expects ((dynamic) => dynamic)?
        onEvent: (dynamic event) => _onRawEvent(event),
      );
    } catch (e) {
      debugPrint('PaymentSocket init reuse: $e');
    }

    if (_channel != null && _channel!.isNotEmpty) {
      try {
        await _pusher!.unsubscribe(channelName: _channel!);
      } catch (_) {}
    }

    // Trust the real per-customer channel from the backend, e.g.
    // `payment-status-1617`. Only fall back if it's an unresolved template.
    _channel = _sanitizeChannel(cfg.channel, uid: _uid);

    try {
      await _pusher!.subscribe(
        channelName: _channel!,
        onEvent: (dynamic event) => _onRawEvent(event),
      );
    } catch (e) {
      debugPrint('PaymentSocket subscribe failed: $e');
    }

    try {
      final state = _pusher!.connectionState.toString().toUpperCase();
      if (!state.contains('CONNECTED')) {
        await _pusher!.connect();
      }
    } catch (e) {
      debugPrint('PaymentSocket connect failed: $e');
      try {
        await _pusher!.connect();
      } catch (e2) {
        debugPrint('PaymentSocket connect retry failed: $e2');
        _listening = false;
        return;
      }
    }

    _listening = true;
    debugPrint(
      'PaymentSocket: listening uid=$_uid cluster=${cfg.cluster} '
      'channel=$_channel events=$_payNowEvent,$_completedEvent',
    );
  }

  void _onRawEvent(dynamic raw) {
    try {
      if (raw is PusherEvent) {
        _dispatch(raw);
        return;
      }
      final name = raw?.eventName?.toString() ?? '';
      final data = raw?.data;
      if (name.isEmpty) return;
      _dispatch(PusherEvent(
        eventName: name,
        data: data,
        channelName: _channel ?? AppConstants.paymentPusherChannel,
      ));
    } catch (e) {
      debugPrint('PaymentSocket raw event error: $e');
    }
  }

  void _dispatch(PusherEvent event) {
    final rawName = event.eventName;
    if (rawName.startsWith('pusher:')) return;

    final name = rawName.startsWith('.') ? rawName.substring(1) : rawName;
    final isPayNow = name == _strip(_payNowEvent);
    final isCompleted = name == _strip(_completedEvent);

    debugPrint('PaymentSocket event: $rawName data=${event.data}');

    if (!isPayNow && !isCompleted) return;
    if (event.data == null) return;

    try {
      // Backend: data is a JSON String → jsonDecode(event.data)
      final Map<String, dynamic> data = _parsePayload(event.data!);
      final eventUid = data['uid']?.toString() ?? '';

      // Public app: only own uid
      if (_uid != 0 &&
          eventUid.isNotEmpty &&
          eventUid != _uid.toString()) {
        debugPrint(
            'PaymentSocket ignore: uid mismatch event=$eventUid me=$_uid');
        return;
      }

      if (_handling) return;
      _handling = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _handling = false;
      });

      if (isPayNow) {
        debugPrint('PaymentSocket: pay-now-popup accepted uid=$eventUid');
        _onPayNowPopup?.call(data);
      } else {
        debugPrint('PaymentSocket: payment-completed accepted uid=$eventUid '
            'is_paid=${data['is_paid']}');
        _onCompleted?.call(data);
      }
    } catch (e) {
      debugPrint('PaymentSocket parse error: $e');
    }
  }

  static String _strip(String event) =>
      event.startsWith('.') ? event.substring(1) : event;

  Map<String, dynamic> _parsePayload(dynamic raw) {
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    if (raw is String) {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        final nested = map['data'] ?? map['payload'];
        if (nested is Map) {
          return Map<String, dynamic>.from(nested);
        }
        if (nested is String) {
          try {
            final inner = jsonDecode(nested);
            if (inner is Map) return Map<String, dynamic>.from(inner);
          } catch (_) {}
        }
        return map;
      }
    }
    return <String, dynamic>{};
  }

  /// The real channel is per-customer, e.g. `payment-status-1617` — only
  /// reject it when it's an unresolved template like `payment-status-{uid}`.
  static String _sanitizeChannel(String channel, {required int uid}) {
    final c = channel.trim();
    if (c.isEmpty || c.contains('{')) {
      return uid != 0
          ? '${AppConstants.paymentPusherChannel}-$uid'
          : AppConstants.paymentPusherChannel;
    }
    return c;
  }

  PaymentSocketConfig _normalize(PaymentSocketConfig input) {
    final d = PaymentSocketConfig.defaults(uid: _uid != 0 ? _uid : null);
    return PaymentSocketConfig(
      key: input.key.isNotEmpty ? input.key : d.key,
      cluster: input.cluster.isNotEmpty ? input.cluster : d.cluster,
      channel: _sanitizeChannel(
          input.channel.isNotEmpty ? input.channel : d.channel,
          uid: _uid),
      event: input.event.isNotEmpty ? input.event : d.event,
      payNowEvent: input.payNowEvent.isNotEmpty ? input.payNowEvent : d.payNowEvent,
      driver: input.driver,
      wsUrl: input.wsUrl.isNotEmpty ? input.wsUrl : d.wsUrl,
      wsHost: input.wsHost.isNotEmpty ? input.wsHost : d.wsHost,
      wssPort: input.wssPort > 0 ? input.wssPort : d.wssPort,
      forceTls: input.forceTls,
      authRequired: input.authRequired,
    );
  }

  Future<void> stop() async {
    try {
      if (_pusher != null && _channel != null) {
        await _pusher!.unsubscribe(channelName: _channel!);
      }
    } catch (_) {}
    _listening = false;
    _channel = null;
    _onCompleted = null;
  }
}
