/// Hukuki metin bağlantıları. Boş bırakılan bağlantı uygulamada gösterilmez.
///
/// Derlemede verilebilir:
/// `flutter build apk --dart-define=PRIVACY_POLICY_URL=https://...`
class LegalConfig {
  LegalConfig._();

  static const privacyPolicyUrl = String.fromEnvironment('PRIVACY_POLICY_URL');

  /// KVKK aydınlatma metni.
  static const kvkkNoticeUrl = String.fromEnvironment('KVKK_NOTICE_URL');

  static const termsUrl = String.fromEnvironment('TERMS_URL');

  static const supportEmail = String.fromEnvironment('SUPPORT_EMAIL');
}
