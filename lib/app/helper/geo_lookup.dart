import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:salon_user/app/helper/geo_result.dart';
import 'package:salon_user/app/helper/maps_js.dart';

Future<GeoResult?> reverseGeocode(double lat, double lng) async {
  if (kIsWeb) {
    final js = await MapsJs.reverse(lat, lng);
    if (js != null && js.address.isNotEmpty) return js;
  }
  try {
    final marks = await placemarkFromCoordinates(lat, lng);
    if (marks.isEmpty) return null;
    final p = marks.first;
    final parts = [
      p.name,
      p.subLocality,
      p.locality,
      p.administrativeArea,
      p.postalCode,
      p.country,
    ].where((s) => (s ?? '').trim().isNotEmpty).join(', ');
    return GeoResult(
      lat: lat,
      lng: lng,
      address: parts,
      iso: (p.isoCountryCode ?? '').toUpperCase(),
      country: (p.country ?? '').trim(),
    );
  } catch (_) {
    return GeoResult(
      lat: lat,
      lng: lng,
      address: '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}',
    );
  }
}
