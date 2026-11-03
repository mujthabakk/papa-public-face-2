import 'dart:js_interop';

import 'package:salon_user/app/backend/models/google_places_model.dart';
import 'package:salon_user/app/helper/geo_result.dart';

@JS('papaMapsAutocomplete')
external JSPromise<JSAny?> _autocomplete(JSString input);

@JS('papaMapsDetails')
external JSPromise<JSAny?> _details(JSString placeId);

@JS('papaMapsGeocode')
external JSPromise<JSAny?> _geocode(JSNumber lat, JSNumber lng);

class MapsJs {
  static Future<List<GooglePlacesModel>> autocomplete(String query) async {
    if (query.trim().isEmpty) return const [];
    try {
      final raw = await _autocomplete(query.toJS).toDart;
      final dart = raw?.dartify();
      if (dart is! List) return const [];
      return dart
          .whereType<Map>()
          .map((m) => GooglePlacesModel(
                description: m['description']?.toString(),
                placeId: m['place_id']?.toString(),
              ))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  static Future<GeoResult?> details(String placeId) async {
    if (placeId.isEmpty) return null;
    try {
      final raw = await _details(placeId.toJS).toDart;
      return _geo(raw?.dartify());
    } catch (_) {
      return null;
    }
  }

  static Future<GeoResult?> reverse(double lat, double lng) async {
    try {
      final raw = await _geocode(lat.toJS, lng.toJS).toDart;
      return _geo(raw?.dartify());
    } catch (_) {
      return null;
    }
  }

  static GeoResult? _geo(Object? dart) {
    if (dart is! Map) return null;
    return GeoResult(
      lat: double.tryParse('${dart['lat'] ?? ''}'),
      lng: double.tryParse('${dart['lng'] ?? ''}'),
      address: dart['address']?.toString() ?? '',
      iso: (dart['iso']?.toString() ?? '').toUpperCase(),
      country: dart['country']?.toString() ?? '',
    );
  }
}
