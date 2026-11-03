import 'package:salon_user/app/backend/models/google_places_model.dart';
import 'package:salon_user/app/helper/geo_result.dart';

class MapsJs {
  static Future<List<GooglePlacesModel>> autocomplete(String query) async =>
      const [];

  static Future<GeoResult?> details(String placeId) async => null;

  static Future<GeoResult?> reverse(double lat, double lng) async => null;
}
