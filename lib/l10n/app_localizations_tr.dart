// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get emailLabel => 'E-posta';

  @override
  String get emailRequired => 'E-posta gerekli';

  @override
  String get emailInvalid => 'Geçerli e-posta girin';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordMinLength => 'En az 6 karakter';

  @override
  String get fullNameLabel => 'Ad Soyad';

  @override
  String get fullNameRequired => 'Ad soyad gerekli';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get signOut => 'Çıkış';

  @override
  String get ok => 'Tamam';

  @override
  String get cancel => 'İptal';

  @override
  String get settingsAndAccount => 'Ayarlar ve hesap';

  @override
  String linkOpenFailed(String url) {
    return 'Bağlantı açılamadı: $url';
  }

  @override
  String clinicCodeCopied(String code) {
    return 'Klinik kodu kopyalandı: $code';
  }

  @override
  String get userFallback => 'Kullanıcı';

  @override
  String get roleAdmin => 'Yönetici';

  @override
  String get roleDoctor => 'Doktor';

  @override
  String get roleAssistant => 'Asistan';

  @override
  String get joinStatusPending => 'Onay bekliyor';

  @override
  String get joinStatusApproved => 'Onaylandı';

  @override
  String get joinStatusRejected => 'Reddedildi';

  @override
  String get loginSubtitle => 'Giriş yapın';

  @override
  String get forgotPassword => 'Şifremi unuttum';

  @override
  String get loginButton => 'Giriş yap';

  @override
  String get loginCreateAccount => 'Hesap oluştur / Kliniğe katıl';

  @override
  String get loginFailed => 'Giriş başarısız';

  @override
  String get clinicRequiredTitle => 'Klinik gerekli';

  @override
  String get serverUnreachableTitle => 'Sunucuya bağlanılamadı';

  @override
  String get serverUnreachableBody =>
      'İnternet bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get signupTitle => 'Kayıt ol';

  @override
  String get createClinic => 'Klinik oluştur';

  @override
  String get joinClinic => 'Kliniğe katıl';

  @override
  String get signupCreateIntro =>
      'Yeni klinik açarsınız; siz yönetici + doktor olursunuz. Asistanları klinik kodu ile davet edersiniz.';

  @override
  String get clinicNameLabel => 'Klinik adı';

  @override
  String get clinicNameRequired => 'Klinik adı gerekli';

  @override
  String get alreadyHaveAccount => 'Zaten hesabım var';

  @override
  String get signupJoinIntro =>
      'Yöneticiden aldığınız klinik kodu ile katılım isteği gönderin. Yönetici onayladıktan sonra kliniğe erişirsiniz.';

  @override
  String get clinicCodeLabel => 'Klinik kodu';

  @override
  String get clinicCodeHint => 'örn. A3K9PX';

  @override
  String get clinicCodeRequired => 'Kod gerekli';

  @override
  String get myRole => 'Rolüm';

  @override
  String get joinButton => 'Katıl';

  @override
  String get resetCodeSent => 'Kayıtlıysa e-posta adresinize kod gönderildi';

  @override
  String get passwordUpdated => 'Şifreniz güncellendi';

  @override
  String get resetIntroEmail =>
      'Hesabınızın e-posta adresini girin; size bir sıfırlama kodu gönderelim.';

  @override
  String get resetIntroCode =>
      'E-postanıza gelen kodu ve yeni şifrenizi girin.';

  @override
  String get resetCodeLabel => 'Kod';

  @override
  String get resetCodeInvalid => 'E-postadaki kodu girin';

  @override
  String get newPasswordLabel => 'Yeni şifre';

  @override
  String get newPasswordRepeatLabel => 'Yeni şifre (tekrar)';

  @override
  String get passwordsDoNotMatch => 'Şifreler aynı değil';

  @override
  String get updatePasswordButton => 'Şifreyi güncelle';

  @override
  String get sendCodeButton => 'Kod gönder';

  @override
  String get resetRequestNewCode => 'Yeni kod iste / e-postayı değiştir';

  @override
  String get legalConsentText =>
      'KVKK aydınlatma metnini, gizlilik politikasını ve kullanım koşullarını okudum; hasta verilerini yalnızca teşhis ve tedavi hizmeti amacıyla, KVKK\'ya uygun şekilde işleyeceğimi kabul ediyorum.';

  @override
  String get legalConsentRequired => 'Devam etmek için onaylamanız gerekir';

  @override
  String get privacyNotice => 'KVKK aydınlatma metni';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get termsOfUse => 'Kullanım koşulları';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAccountSection => 'Hesap';

  @override
  String get settingsLegalSection => 'Yasal';

  @override
  String supportEmail(String email) {
    return 'Destek: $email';
  }

  @override
  String get languageLabel => 'Dil';

  @override
  String get languageSystem => 'Telefonun dili';

  @override
  String get settingsDangerZone => 'Tehlikeli bölge';

  @override
  String get deleteMyAccount => 'Hesabımı sil';

  @override
  String get deleteMyAccountSubtitle => 'Hesabınız kalıcı olarak silinir';

  @override
  String accountInfoFailed(String error) {
    return 'Hesap bilgisi alınamadı: $error';
  }

  @override
  String get transferAdminTitle => 'Önce yöneticiyi devredin';

  @override
  String transferAdminBody(String clinics) {
    return 'Şu kliniklerin tek yöneticisisiniz ve başka üyeleri var:\n\n$clinics\n\nÜyeler ekranından başka bir üyeyi yönetici yapın, sonra tekrar deneyin.';
  }

  @override
  String get accountDeleted => 'Hesabınız silindi';

  @override
  String accountDeleteFailed(String error) {
    return 'Hesap silinemedi: $error';
  }

  @override
  String serverError(int status) {
    return 'Sunucu hatası ($status)';
  }

  @override
  String get deleteAccountTitle => 'Hesabı kalıcı olarak sil';

  @override
  String get deleteAccountWarning =>
      'Hesabınız ve giriş bilgileriniz silinir. Bu işlem geri alınamaz.';

  @override
  String get deleteAccountClinicsWarning =>
      'Aşağıdaki kliniklerin tek üyesisiniz. Bu klinikler tüm hasta kayıtları, işlemler, fotoğraflar ve ses kayıtlarıyla birlikte silinecek:';

  @override
  String get deleteAccountMembershipOnly =>
      'Üyesi olduğunuz kliniklerdeki kayıtlar klinikte kalır; yalnızca üyeliğiniz sonlanır.';

  @override
  String deleteAccountTypeToConfirm(String word) {
    return 'Onaylamak için \"$word\" yazın:';
  }

  @override
  String get deleteAccountConfirmWord => 'SİL';

  @override
  String get deleteAccountButton => 'Hesabı sil';

  @override
  String get errInvalidCredentials => 'E-posta veya şifre hatalı';

  @override
  String get errAlreadyRegistered => 'Bu e-posta zaten kayıtlı. Giriş yapın.';

  @override
  String get errPasswordTooShort => 'Şifre en az 6 karakter olmalı';

  @override
  String get errTooManyAttempts =>
      'Çok sık deneme. Biraz bekleyip tekrar deneyin.';

  @override
  String get errAlreadyMember => 'Bu kliniğe zaten üyesiniz';

  @override
  String get errClinicCodeNotFound => 'Klinik kodu bulunamadı';

  @override
  String get errOnlyAdminCanApprove => 'Sadece klinik yöneticisi onaylayabilir';

  @override
  String get errResetCodeInvalid =>
      'Kod hatalı veya süresi dolmuş. Yeni kod isteyin.';

  @override
  String get errSamePassword => 'Yeni şifre eskisinden farklı olmalı';

  @override
  String get errSignupIncomplete =>
      'Kayıt tamamlanamadı. E-posta doğrulamasını kontrol edin.';

  @override
  String get errSessionRequired => 'Oturum gerekli';

  @override
  String get errClinicCreateFailed => 'Klinik oluşturulamadı';

  @override
  String get errRoleInvalid => 'Rol doktor veya asistan olmalı';

  @override
  String get errJoinRequestFailed => 'Katılım isteği oluşturulamadı';

  @override
  String get errNotMember => 'Bu kliniğe üye değilsiniz';

  @override
  String get add => 'Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get close => 'Kapat';

  @override
  String get view => 'Gör';

  @override
  String get copy => 'Kopyala';

  @override
  String get approve => 'Onayla';

  @override
  String get reject => 'Reddet';

  @override
  String get remove => 'Çıkar';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get phoneOptionalLabel => 'Telefon (opsiyonel)';

  @override
  String get noPhone => 'Telefon yok';

  @override
  String loadFailed(String error) {
    return 'Yüklenemedi: $error';
  }

  @override
  String get clinicFallback => 'Klinik';

  @override
  String get recalls => 'Kontrol çağrıları';

  @override
  String get todos => 'Yapılacaklar';

  @override
  String get followUps => 'Takipler';

  @override
  String get reports => 'Raporlar';

  @override
  String get clinics => 'Klinikler';

  @override
  String get newPatient => 'Yeni Hasta';

  @override
  String get addPatient => 'Hasta Ekle';

  @override
  String get patientAdded => 'Hasta eklendi';

  @override
  String patientAddFailed(String error) {
    return 'Hasta eklenemedi: $error';
  }

  @override
  String get signOutTitle => 'Çıkış yap';

  @override
  String get signOutConfirm => 'Hesabınızdan çıkmak istiyor musunuz?';

  @override
  String get myClinics => 'Kliniklerim';

  @override
  String get copyCode => 'Kodu kopyala';

  @override
  String get activeClinicCode => 'Aktif klinik kodu';

  @override
  String get clinicCodeShareHint =>
      'Kodu paylaşın; katılan kişi onayınızı bekler. Anında üye olmaz.';

  @override
  String get joinRequests => 'Katılım istekleri';

  @override
  String joinRequestsCount(int count) {
    return 'Katılım istekleri ($count)';
  }

  @override
  String get members => 'Üyeler';

  @override
  String get appearance => 'Görünüm';

  @override
  String get treatmentTemplates => 'İşlem şablonları';

  @override
  String get addOrJoinClinic => 'Başka klinik ekle / katıl';

  @override
  String followUpsDue(int count) {
    return '$count takip için uyarı zamanı geldi';
  }

  @override
  String get followUpsOffline =>
      'İnternet bağlantısı yok veya sunucuya ulaşılamıyor. Takip listesi yüklenemedi.';

  @override
  String followUpsLoadFailed(String error) {
    return 'Takipler yüklenemedi: $error';
  }

  @override
  String get searchPatientsHint => 'Hasta ara (ad veya telefon)…';

  @override
  String get sortByName => 'A–Z';

  @override
  String get sortByLastVisit => 'Son işlem';

  @override
  String get selectPatientHint => 'Detay için bir hasta seçin';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get colorPalette => 'Renk paleti';

  @override
  String get paletteClinic => 'Klinik mavi';

  @override
  String get paletteClinicDesc => 'Sakin, klinik slate-mavi';

  @override
  String get paletteOcean => 'Okyanus';

  @override
  String get paletteOceanDesc => 'Derin cyan, ferah klinik';

  @override
  String get paletteSage => 'Adaçayı';

  @override
  String get paletteSageDesc => 'Mat yeşil, yumuşak tıbbi';

  @override
  String get paletteGraphite => 'Grafit';

  @override
  String get paletteGraphiteDesc => 'Nötr grafit, buz mavisi vurgu';

  @override
  String get paletteClassic => 'Klasik yeşil';

  @override
  String get paletteClassicDesc => 'Canlı yeşil vurgu';

  @override
  String get patientsLoadFailed => 'Hastalar yüklenemedi.';

  @override
  String get noPatientsYet => 'Henüz hasta yok.\nSağ üstten ekleyin.';

  @override
  String get noPatientsMatch => 'Aramanızla eşleşen hasta bulunamadı.';

  @override
  String get newProcedure => 'Yeni işlem';

  @override
  String get procedureSaved => 'İşlem kaydedildi';

  @override
  String get plannedForNextSession => 'Sonraki seansa planlandı';

  @override
  String get voiceNoteSaved => 'Sesli not kaydedildi';

  @override
  String get editPatientTitle => 'Hastayı düzenle';

  @override
  String get deletePatientTitle => 'Hastayı sil';

  @override
  String deletePatientConfirm(String name) {
    return '$name ve ilişkili kayıtları silinsin mi?';
  }

  @override
  String patientDeleteFailed(String error) {
    return 'Hasta silinemedi: $error';
  }

  @override
  String get sharePdfTitle => 'Tedavi geçmişini paylaş';

  @override
  String get sharePdfWarning =>
      'PDF, hastanın sağlık verilerini içerir. Yalnızca hastanın kendisine veya onun onayıyla yetkili kişilere gönderin.';

  @override
  String get createPdf => 'PDF oluştur';

  @override
  String followUpAdded(String title) {
    return 'Takip eklendi: $title';
  }

  @override
  String get markedAsDone => 'İşlem yapıldı olarak kaydedildi';

  @override
  String completeFailed(String error) {
    return 'Tamamlanamadı: $error';
  }

  @override
  String followUpCompleteFailed(String error) {
    return 'Takip tamamlanamadı: $error';
  }

  @override
  String get deleteFollowUpTitle => 'Takibi sil';

  @override
  String deleteItemConfirm(String name) {
    return '$name silinsin mi?';
  }

  @override
  String followUpDeleteFailed(String error) {
    return 'Takip silinemedi: $error';
  }

  @override
  String get addFollowUp => 'Takip ekle';

  @override
  String get voiceNote => 'Sesli not';

  @override
  String get shareAsPdf => 'PDF olarak paylaş';

  @override
  String plannedProcedures(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Planlanan işlemler ($count)',
      one: 'Planlanan işlem',
    );
    return '$_temp0';
  }

  @override
  String get markDone => 'Yapıldı';

  @override
  String dataLoadFailed(String error) {
    return 'Veriler yüklenemedi: $error';
  }

  @override
  String get noRecordsYet => 'Henüz kayıt yok.\nSesli not veya işlem ekleyin.';

  @override
  String get openFollowUps => 'Açık takipler';

  @override
  String labReminderOn(String date) {
    return 'Lab hatırlatma: $date';
  }

  @override
  String get complete => 'Tamamla';

  @override
  String get pendingVoiceNotes => 'Bekleyen sesli notlar';

  @override
  String get procedureHistory => 'İşlem geçmişi';

  @override
  String get noProceduresYet => 'Henüz işlem yok.';

  @override
  String get processedVoiceNotes => 'İşlenmiş sesli notlar';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String procedureCount(int count) {
    return '$count işlem';
  }

  @override
  String get manageCreateIntro =>
      'Yeni bir klinik açarsınız; bu klinikte yönetici olursunuz. Diğer klinikleriniz silinmez — aralarında geçiş yapabilirsiniz.';

  @override
  String get manageJoinIntro =>
      'Klinik kodunu girin. Yönetici onayladıktan sonra kliniğe erişirsiniz.';

  @override
  String clinicCreated(String name, String code) {
    return '$name oluşturuldu. Kod: $code';
  }

  @override
  String get joinRequestSent =>
      'Katılım isteği gönderildi. Yönetici onayı bekleniyor.';

  @override
  String approvedName(String name) {
    return '$name onaylandı';
  }

  @override
  String approveFailed(String error) {
    return 'Onaylanamadı: $error';
  }

  @override
  String get rejectRequestTitle => 'İsteği reddet';

  @override
  String rejectRequestConfirm(String name) {
    return '$name isteğini reddetmek istiyor musunuz?';
  }

  @override
  String rejectedName(String name) {
    return '$name reddedildi';
  }

  @override
  String rejectFailed(String error) {
    return 'Reddedilemedi: $error';
  }

  @override
  String noPendingRequests(String clinic) {
    return '$clinic için bekleyen istek yok.';
  }

  @override
  String wantsToJoinAs(String role) {
    return '$role olarak katılmak istiyor';
  }

  @override
  String get awaitingApprovalTitle => 'Onay bekleniyor';

  @override
  String get awaitingApprovalBody =>
      'Katılım isteğiniz klinik yöneticisinin onayını bekliyor. Onaylanınca buradan otomatik geçebilirsiniz.';

  @override
  String get refreshStatus => 'Durumu yenile';

  @override
  String get createOrJoinOtherClinic => 'Başka klinik oluştur / katıl';

  @override
  String get cannotChangeOwnAdmin =>
      'Kendi yönetici rolünüzü değiştiremezsiniz';

  @override
  String roleFor(String name) {
    return 'Rol: $name';
  }

  @override
  String roleUpdateFailed(String error) {
    return 'Rol güncellenemedi: $error';
  }

  @override
  String get cannotRemoveOwnAdmin => 'Yönetici hesabınızı buradan silemezsiniz';

  @override
  String get removeMemberTitle => 'Üyeyi çıkar';

  @override
  String removeMemberConfirm(String name) {
    return '$name klinikten çıkarılsın mı?';
  }

  @override
  String removeFailed(String error) {
    return 'Çıkarılamadı: $error';
  }

  @override
  String get clinicMembersTitle => 'Klinik üyeleri';

  @override
  String memberYou(String name) {
    return '$name (siz)';
  }

  @override
  String get changeRole => 'Rol değiştir';
}
