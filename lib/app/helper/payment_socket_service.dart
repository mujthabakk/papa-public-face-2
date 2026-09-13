import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:salon_user/app/backend/models/payment_options_model.dart';
import 'package:salon_user/app/util/constant.dart';

typedef PaymentPopupCallback = void Function(Map<String, dynamic> payload);
typedef PaymentCompletedCallback = void Function(Map<String, dynamic> payload);

/// Public customer listener (never partner).
/// Handshake: POST socketConfig `{ uid }` → `data.channel` is
/// `payment-status-<uid>` (e.g. payment-status-1617). Events are also
/// published on shared `payment-status`, so both are subscribed.
///
/// Binds:
///   pay-now-popup     → owner completed service → Pay Now modal
///   payment-completed → pay/cash cleared → mark paid only if is_paid == true
class PaymentSocketService {
  PusherChannelsFlutter? _pusher;
  final Set<String> _channels = {};
  String _payNowEvent = AppConstants.paymentPusherPayNowEvent;
  String _completedEvent = AppConstants.paymentPusherEvent;
  int _uid = 0;
  PaymentPopupCallback? _onPayNowPopup;
  PaymentCompletedCallback? _onCompleted;
  bool _listening = false;

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
        // Must be (dynamic) — plugin type is ((dynamic) => dynamic)?
        onEvent: (dynamic event) => _onRawEvent(event),
      );
    } catch (e) {
      debugPrint('PaymentSocket init reuse: $e');
    }

    await _unsubscribeAll();

    final uidChannel = _sanitizeChannel(cfg.channel, uid: _uid);
    final shared = AppConstants.paymentPusherChannel;
    _channels.add(uidChannel);
    _channels.add(shared);

    for (final channel in _channels) {
      try {
        await _pusher!.subscribe(
          channelName: channel,
          onEvent: (dynamic event) => _onRawEvent(event),
        );
      } catch (e) {
        debugPrint('PaymentSocket subscribe failed ($channel): $e');
      }
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
      'channels=${_channels.join(',')} '
      'events=$_payNowEvent,$_completedEvent',
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
        channelName: _channels.isNotEmpty
            ? _channels.first
            : AppConstants.paymentPusherChannel,
      ));
    } catch (e) {
      debugPrint('PaymentSocket raw event error: $e');
    }
  }

  void _dispatch(PusherEvent event) {
    final rawName = event.eventName;
    if (rawName.startsWith('pusher:')) return;

    final name = _strip(rawName);
    final isPayNow = name == _strip(_payNowEvent);
    final isCompleted = name == _strip(_completedEvent);

    debugPrint('PaymentSocket event: $rawName data=${event.data}');

    if (!isPayNow && !isCompleted) return;
    if (event.data == null) return;

    try {
      final Map<String, dynamic> data = _parsePayload(event.data!);
      final eventUid = data['uid']?.toString() ?? '';

      if (_uid != 0 && eventUid.isNotEmpty && eventUid != _uid.toString()) {
        debugPrint(
            'PaymentSocket ignore: uid mismatch event=$eventUid me=$_uid');
        return;
      }

      if (isPayNow) {
        debugPrint('PaymentSocket: pay-now-popup accepted uid=$eventUid');
        _onPayNowPopup?.call(data);
        return;
      }

      final paid = data['is_paid'] == true ||
          data['is_paid']?.toString() == '1' ||
          data['is_paid']?.toString().toLowerCase() == 'true';
      debugPrint(
          'PaymentSocket: payment-completed uid=$eventUid is_paid=$paid');
      if (!paid) return;
      _onCompleted?.call(data);
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

  /// Trust `payment-status-1617`. Only rewrite unresolved `{uid}` templates.
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
      payNowEvent:
          input.payNowEvent.isNotEmpty ? input.payNowEvent : d.payNowEvent,
      driver: input.driver,
      wsUrl: input.wsUrl.isNotEmpty ? input.wsUrl : d.wsUrl,
      wsHost: input.wsHost.isNotEmpty ? input.wsHost : d.wsHost,
      wssPort: input.wssPort > 0 ? input.wssPort : d.wssPort,
      forceTls: input.forceTls,
      authRequired: input.authRequired,
    );
  }

  Future<void> _unsubscribeAll() async {
    for (final channel in _channels) {
      try {
        await _pusher?.unsubscribe(channelName: channel);
      } catch (_) {}
    }
    _channels.clear();
  }

  Future<void> stop() async {
    await _unsubscribeAll();
    _listening = false;
    _onCompleted = null;
    _onPayNowPopup = null;
  }
}
