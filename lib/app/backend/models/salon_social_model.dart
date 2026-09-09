import 'dart:convert';

/// Social + contact links for a shop/salon detail page.
/// Parses direct API fields, nested `social_links`, or JSON in `extra_field`.
class SalonSocialLinks {
  final String? website;
  final String? phone;
  final String? email;
  final String? instagram;
  final String? youtube;
  final String? facebook;
  final String? whatsapp;
  final String? twitter;
  final String? linkedin;
  final bool callEnabled;
  final bool chatEnabled;

  const SalonSocialLinks({
    this.website,
    this.phone,
    this.email,
    this.instagram,
    this.youtube,
    this.facebook,
    this.whatsapp,
    this.twitter,
    this.linkedin,
    this.callEnabled = true,
    this.chatEnabled = true,
  });

  bool get hasWebsite => _valid(website);
  bool get hasPhone => _valid(phone);
  bool get hasInstagram => _valid(instagram);
  bool get hasYoutube => _valid(youtube);
  bool get hasFacebook => _valid(facebook);
  bool get hasWhatsapp => _valid(whatsapp);
  bool get hasTwitter => _valid(twitter);
  bool get hasLinkedin => _valid(linkedin);

  bool get canCall => callEnabled && hasPhone;
  bool get canChat => chatEnabled;
  bool get canWebsite => hasWebsite;

  bool get hasAnySocial =>
      hasInstagram ||
      hasYoutube ||
      hasFacebook ||
      hasWhatsapp ||
      hasTwitter ||
      hasLinkedin;

  bool get hasConnectActions =>
      canCall || canChat || canWebsite || hasAnySocial;

  static SalonSocialLinks fromJson(Map<String, dynamic> json) =>
      fromSalonJson(json);

  static SalonSocialLinks fromSalonJson(Map<String, dynamic> json) {
    final merged = <String, dynamic>{...json};
    _mergeMap(merged, json['social_links']);
    _mergeMap(merged, json['social']);
    _mergeExtraField(merged, json['extra_field']);

    final callEnabled = _boolValue(
      merged['call_enabled'] ?? merged['enable_call'],
      fallback: true,
    );
    final chatEnabled = _boolValue(
      merged['chat_enabled'] ?? merged['enable_chat'],
      fallback: true,
    );

    return SalonSocialLinks(
      website: _text(merged['website']),
      phone: _text(merged['mobile'] ?? merged['phone']),
      email: _text(merged['email']),
      instagram: _text(merged['instagram'] ??
          merged['instagram_url'] ??
          merged['instagramUrl']),
      youtube: _text(merged['youtube'] ??
          merged['youtube_url'] ??
          merged['youtubeUrl']),
      facebook: _text(merged['facebook'] ??
          merged['facebook_url'] ??
          merged['facebookUrl']),
      whatsapp: _text(merged['whatsapp'] ??
          merged['whatsapp_url'] ??
          merged['whatsappUrl'] ??
          merged['whatsapp_number']),
      twitter: _text(merged['twitter'] ??
          merged['twitter_url'] ??
          merged['twitterUrl'] ??
          merged['x_url']),
      linkedin: _text(merged['linkedin'] ??
          merged['linkedin_url'] ??
          merged['linkedinUrl']),
      callEnabled: callEnabled,
      chatEnabled: chatEnabled,
    );
  }

  static void _mergeMap(
      Map<String, dynamic> target, dynamic source) {
    if (source is Map) {
      target.addAll(Map<String, dynamic>.from(source));
    }
  }

  static void _mergeExtraField(
      Map<String, dynamic> target, dynamic extraField) {
    if (extraField == null) return;
    if (extraField is Map) {
      _mergeMap(target, extraField);
      return;
    }
    final text = extraField.toString().trim();
    if (text.isEmpty || text == 'NA') return;
    try {
      final decoded = jsonDecode(text);
      if (decoded is Map) _mergeMap(target, decoded);
    } catch (_) {}
  }

  static String? _text(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    if (text.isEmpty || text == 'NA' || text == 'null') return null;
    return text;
  }

  static bool _valid(String? value) =>
      value != null && value.isNotEmpty && value != 'NA';

  static bool _boolValue(dynamic value, {required bool fallback}) {
    if (value == null) return fallback;
    if (value == true || value == 1 || value == '1') return true;
    if (value == false || value == 0 || value == '0') return false;
    return fallback;
  }
}
