class GeoResult {
  final double? lat;
  final double? lng;
  final String address;
  final String iso;
  final String country;

  const GeoResult({
    this.lat,
    this.lng,
    this.address = '',
    this.iso = '',
    this.country = '',
  });
}
