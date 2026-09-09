/*Papabear*/
class LanguageModel {
  String imageUrl;
  String languageName;
  String languageCode;
  String countryCode;
  String? nativeName;
  String? direction;
  bool isRtl;

  LanguageModel({
    required this.imageUrl,
    required this.languageName,
    required this.countryCode,
    required this.languageCode,
    this.nativeName,
    this.direction,
    this.isRtl = false,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? 'en';
    return LanguageModel(
      imageUrl: json['image']?.toString() ?? '',
      languageName: json['name']?.toString() ?? code,
      nativeName: json['native_name']?.toString(),
      languageCode: code,
      countryCode: _defaultCountryForCode(code),
      direction: json['direction']?.toString(),
      isRtl: json['is_rtl'] == true || json['is_rtl']?.toString() == '1',
    );
  }

  static String _defaultCountryForCode(String code) {
    switch (code) {
      case 'ar':
        return 'QA';
      case 'hi':
        return 'IN';
      case 'es':
        return 'ES';
      default:
        return 'US';
    }
  }

  String get displayName =>
      (nativeName != null && nativeName!.isNotEmpty) ? nativeName! : languageName;
}
