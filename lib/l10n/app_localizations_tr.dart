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

  @override
  String get scopeTooth => 'Diş';

  @override
  String get scopeUpperJaw => 'Üst Çene';

  @override
  String get scopeLowerJaw => 'Alt Çene';

  @override
  String get scopeFullMouth => 'Tüm Ağız';

  @override
  String scopeToothWithNumber(String teeth) {
    return 'Diş: $teeth';
  }

  @override
  String get fieldScope => 'Kapsam';

  @override
  String get fieldTooth => 'Diş';

  @override
  String get fieldTitle => 'Başlık';

  @override
  String get fieldNote => 'Not';

  @override
  String get fieldCanalLength => 'Kanal boyu';

  @override
  String get fieldFile => 'Eğe';

  @override
  String get fieldMedicament => 'İlaç';

  @override
  String get fieldDate => 'Tarih';

  @override
  String photosAdded(int count) {
    return '$count fotoğraf eklendi';
  }

  @override
  String photosRemoved(int count) {
    return '$count fotoğraf kaldırıldı';
  }

  @override
  String get canalMain => 'Ana';

  @override
  String get handFile => 'El Eğesi';

  @override
  String get noMedicament => 'İlaçsız';

  @override
  String get errNoteConflict =>
      'Bu işlem bu arada başka biri tarafından düzenlendi. Listeyi yenileyip tekrar deneyin.';

  @override
  String get errNoClinicSelected => 'Klinik seçili değil — önce giriş yapın.';

  @override
  String get errNoPermissionDeletePatient => 'Bu hastayı silme yetkiniz yok';

  @override
  String get errNoPermissionDeleteNote => 'Bu işlemi silme yetkiniz yok';

  @override
  String labFollowUpTitle(String title) {
    return 'Lab: $title';
  }

  @override
  String labExpectedReturnOn(String date) {
    return 'Beklenen lab dönüşü: $date';
  }

  @override
  String labExpectedReturnFor(String date, String name) {
    return 'Beklenen lab dönüşü: $date · $name';
  }

  @override
  String get savingEllipsis => 'Kaydediliyor…';

  @override
  String get procedureDate => 'İşlem tarihi';

  @override
  String get select => 'Seç';

  @override
  String get expectedLabReturn => 'Beklenen lab dönüşü';

  @override
  String get followUpDate => 'Kontrol tarihi';

  @override
  String get errSelectOrTypeProcedure => 'İşlem seçin veya işlem başlığı yazın';

  @override
  String get errSelectScope => 'Kapsam seçin';

  @override
  String get errSelectTooth => 'En az bir diş seçin';

  @override
  String get errSelectLabDate => 'Lab beklenen dönüş tarihini seçin';

  @override
  String get errSelectFollowUpDate => 'Kontrol tarihini seçin';

  @override
  String get errFollowUpNoteRequired => 'Takip notunu yazın';

  @override
  String get uploadingPhotos => 'Fotoğraflar buluta yükleniyor…';

  @override
  String get savingProcedure => 'İşlem kaydediliyor…';

  @override
  String uploadingPhotoProgress(int current, int total) {
    return 'Fotoğraf yükleniyor ($current/$total)…';
  }

  @override
  String saveFailed(String error) {
    return 'Kayıt başarısız: $error';
  }

  @override
  String get creatingLabReminder => 'Lab hatırlatması oluşturuluyor…';

  @override
  String get creatingFollowUpReminder => 'Kontrol hatırlatması oluşturuluyor…';

  @override
  String followUpTitle(String title) {
    return 'Kontrol: $title';
  }

  @override
  String get reminderKindLab => 'lab';

  @override
  String get reminderKindFollowUp => 'kontrol';

  @override
  String reminderCreateFailed(String kinds) {
    return 'İşlem kaydedildi ancak şu hatırlatmalar oluşturulamadı: $kinds. Takipler ekranından ekleyin.';
  }

  @override
  String get planForNextSession => 'Sonraki seansa planla';

  @override
  String saveTeethCount(int count) {
    return '$count diş kaydet';
  }

  @override
  String get pastRecordHint => 'Geçmiş kayıt (defterden aktarım)';

  @override
  String get change => 'Değiştir';

  @override
  String get procedureSection => 'İşlem';

  @override
  String get procedureSectionHint => 'En az bir işlem seçin veya başlık yazın';

  @override
  String get procedureTitleLabel => 'İşlem Başlığı';

  @override
  String get noteOptionalLabel => 'Not (isteğe bağlı)';

  @override
  String get noteHint => 'Gerekirse buraya yazın…';

  @override
  String get addFollowUpSubtitle =>
      'İşlem sonrası kontrol tarihi ve hatırlatma';

  @override
  String get followUpNoteLabel => 'Takip notu';

  @override
  String get followUpNoteHint => 'örn. Perküsyon ve radyografik kontrol';

  @override
  String get presetOneWeek => '1 hafta';

  @override
  String get presetOneMonth => '1 ay';

  @override
  String get presetThreeMonths => '3 ay';

  @override
  String get presetSixMonths => '6 ay';

  @override
  String get pickDate => 'Tarih seç';

  @override
  String get remindWhenLabel => 'Ne zaman uyarılsın?';

  @override
  String get remindOnDay => 'Kontrol günü';

  @override
  String get remindOneDayBefore => '1 gün önce';

  @override
  String get remindThreeDaysBefore => '3 gün önce';

  @override
  String get remindOneWeekBefore => '1 hafta önce';

  @override
  String followUpSummary(String date, String reminder) {
    return 'Kontrol: $date · Uyarı: $reminder';
  }

  @override
  String get scopeToothRequired => 'Bu işlem için diş seçimi zorunlu';

  @override
  String get scopeRequired => 'Kapsam seçimi zorunlu';

  @override
  String get scopeSuitable => 'İşleme uygun kapsam';

  @override
  String get canalSelectToothFirst =>
      'Kanal parametreleri için önce diş seçin. Birden fazla dişte her diş ayrı kaydedilir.';

  @override
  String get canalPerToothTitle => 'Her diş için kanal bilgisi';

  @override
  String get canalPerToothHint =>
      'Dişe dokunun, parametreleri girin. Kayıtta her diş ayrı not olur.';

  @override
  String toothNumber(String tooth) {
    return 'Diş $tooth';
  }

  @override
  String get photoSection => 'Fotoğraf';

  @override
  String get photoPrivacyHint =>
      'Hasta yüzü görünmesin. Yalnızca işlem / ağız içi görüntü.';

  @override
  String get planningSection => 'Planlama';

  @override
  String get labCountsAsDone => 'Lab’a gittiyse işlem yapılmış sayılır';

  @override
  String get info => 'Bilgi';

  @override
  String get planInfoLabBlocked =>
      'Lab’a gitti işaretliyken bu seçenek kullanılamaz; işlem bu seans yapılmış kabul edilir.';

  @override
  String get planInfo =>
      'Bu işlem bugün yapılmadı kabul edilir. Hasta bir sonraki gelişinde üstte uyarılır; “Yapıldı” dendiğinde o günün işlem geçmişine eklenir.';

  @override
  String get sentToLab => 'Lab’a gitti';

  @override
  String get sentToLabInfo =>
      'İş laboratuvara gönderildiğinde işaretleyin. Beklenen dönüş tarihinden 1 gün önce takip listesi ve bildirim hatırlatır. Bu seçimde işlem yapılmış sayılır; “Sonraki seansa planla” kapanır.';

  @override
  String addExtraCanalForTooth(String tooth) {
    return 'Ekstra kanal ekle · Diş $tooth';
  }

  @override
  String get addExtraCanal => 'Ekstra kanal ekle';

  @override
  String get extraCanalHint =>
      'Tipik listede olmayan kanalı seçin veya özel ad yazın.';

  @override
  String get allStandardCanalsAdded =>
      'Standart kodların hepsi ekli. Özel ad kullanın.';

  @override
  String get customCanalName => 'Özel kanal adı';

  @override
  String get customCanalHint => 'örn. MB3, DB2…';

  @override
  String get editProcedureTitle => 'İşlemi düzenle';

  @override
  String editVersionHint(int version) {
    return 'v$version → yeni sürüm kaydedilir; eski korunur';
  }

  @override
  String get errTitleRequired => 'İşlem başlığı zorunludur';

  @override
  String get noChanges => 'Değişiklik yok';

  @override
  String get saveAsNewVersion => 'Yeni sürüm olarak kaydet';

  @override
  String get quadrantUpperRight => 'Üst sağ';

  @override
  String get quadrantUpperLeft => 'Üst sol';

  @override
  String get quadrantLowerRight => 'Alt sağ';

  @override
  String get quadrantLowerLeft => 'Alt sol';

  @override
  String get toothNumberSection => 'Diş Numarası';

  @override
  String get clearSelection => 'Seçimi temizle';

  @override
  String get typeToSelectLabel => 'Yazarak seç (FDI)';

  @override
  String get typeToSelectHint => 'örn. 15  veya  14-17  veya  36,37';

  @override
  String get apply => 'Uygula';

  @override
  String get toothSelectorHelp =>
      'Dokun: seç · Uzun bas: çeyreği büyüt · Aşağı kaydır veya Tamam: küçült';

  @override
  String get jawUpper => 'ÜST';

  @override
  String get jawLower => 'ALT';

  @override
  String get sideRight => 'Sağ';

  @override
  String get sideLeft => 'Sol';

  @override
  String get selectTeeth => 'Diş seçin';

  @override
  String selectedTeeth(String teeth) {
    return 'Seçili: $teeth';
  }

  @override
  String get swipeDownToClose => 'Aşağı kaydırarak da kapatabilirsiniz';

  @override
  String canalParamsForTooth(String tooth) {
    return 'Kanal parametreleri · Diş $tooth';
  }

  @override
  String get canalParamsTitle => 'Kanal Tedavisi Parametreleri';

  @override
  String get canalLengthMm => 'Kanal Boyu (mm)';

  @override
  String get extra => 'Ekstra';

  @override
  String get fileSystem => 'Eğe Sistemi';

  @override
  String get intracanalMedicament => 'Kanal İçi İlaç';

  @override
  String toothCanalHint(String tooth, String canals) {
    return 'Diş $tooth · tipik: $canals — gerekirse ekstra ekleyin';
  }

  @override
  String get newVersionSaved => 'Yeni sürüm kaydedildi';

  @override
  String get deleteProcedureTitle => 'İşlemi sil';

  @override
  String get deleteProcedureConfirm =>
      'Bu not ve varsa önceki sürümleri kalıcı olarak silinecek.';

  @override
  String get procedureDeleted => 'İşlem silindi';

  @override
  String procedureDeleteFailed(String error) {
    return 'İşlem silinemedi: $error';
  }

  @override
  String get labShort => 'Lab';

  @override
  String labReturnShort(String date) {
    return 'Lab → $date';
  }

  @override
  String get history => 'Geçmiş';

  @override
  String get share => 'Paylaş';

  @override
  String get versionHistory => 'Sürüm geçmişi';

  @override
  String historyLoadFailed(String error) {
    return 'Geçmiş yüklenemedi: $error';
  }

  @override
  String get noVersionsFound => 'Sürüm bulunamadı';

  @override
  String get currentVersion => 'Güncel';

  @override
  String get oldVersion => 'Eski sürüm';

  @override
  String get changesInVersion => 'Bu sürümde değişenler';

  @override
  String get firstRecord => 'İlk kayıt';

  @override
  String get micPermissionRequired => 'Mikrofon izni gerekli';

  @override
  String get micPermissionMissing => 'Mikrofon izni yok';

  @override
  String get recordingEmpty => 'Kayıt boş veya oluşturulamadı';

  @override
  String voiceUploadFailed(String error) {
    return 'Ses kaydı yüklenemedi: $error';
  }

  @override
  String get quickVoiceNote => 'Hızlı sesli not';

  @override
  String get voicePrivacyHint =>
      'Ses yalnızca doktor/asistanın işlem özeti içindir. Hasta konuşması kaydedilmez.';

  @override
  String get recordingInProgress => 'Kayıt sürüyor…';

  @override
  String get uploadingVoice => 'Ses buluta yükleniyor…';

  @override
  String get voiceStartHint =>
      'Mikrofona basıp konuşun, bitince Bitir & Kaydet’e basın';

  @override
  String get pleaseWait => 'Lütfen bekleyin…';

  @override
  String get finishAndSave => 'Bitir & Kaydet';

  @override
  String playFailed(String error) {
    return 'Çalınamadı: $error';
  }

  @override
  String get memoMarkedProcessed => 'Sesli not işlendi olarak işaretlendi';

  @override
  String markFailed(String error) {
    return 'İşaretlenemedi: $error';
  }

  @override
  String get deleteVoiceNoteTitle => 'Sesli notu sil';

  @override
  String get deleteVoiceNoteConfirm => 'Bu sesli not kalıcı olarak silinecek.';

  @override
  String deleteFailed(String error) {
    return 'Silinemedi: $error';
  }

  @override
  String get processedVoiceNote => 'İşlenmiş sesli not';

  @override
  String get pendingVoiceNote => 'Bekleyen sesli not';

  @override
  String durationLabel(String duration) {
    return 'Süre: $duration';
  }

  @override
  String get stop => 'Durdur';

  @override
  String get listen => 'Dinle';

  @override
  String get convertToNote => 'Nota dönüştür';

  @override
  String get audioFileEmpty => 'Ses dosyası boş';

  @override
  String photoOpenFailed(String error) {
    return 'Fotoğraf açılamadı: $error';
  }

  @override
  String photoCount(int count, int max) {
    return '$count / $max fotoğraf';
  }

  @override
  String get takePhoto => 'Fotoğraf Çek';

  @override
  String get fromGallery => 'Galeriden';

  @override
  String get shareThisPhoto => 'Bu fotoğrafı paylaş';

  @override
  String shareAllPhotos(int count) {
    return 'Tüm fotoğrafları paylaş ($count)';
  }

  @override
  String get procedurePhoto => 'İşlem Fotoğrafı';

  @override
  String procedurePhotoIndex(int index, int count) {
    return 'İşlem Fotoğrafı $index/$count';
  }

  @override
  String get shareTooltip => 'Paylaş (WhatsApp, e-posta…)';

  @override
  String get photoLoadFailed => 'Fotoğraf yüklenemedi';

  @override
  String preparingPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf hazırlanıyor…',
      one: 'Fotoğraf hazırlanıyor…',
    );
    return '$_temp0';
  }

  @override
  String shareFailed(String error) {
    return 'Paylaşılamadı: $error';
  }

  @override
  String completedItem(String title) {
    return 'Tamamlandı: $title';
  }

  @override
  String actionFailed(String error) {
    return 'İşlem başarısız: $error';
  }

  @override
  String deletedItem(String title) {
    return 'Silindi: $title';
  }

  @override
  String patientOpenFailed(String error) {
    return 'Hasta açılamadı: $error';
  }

  @override
  String get noOpenFollowUps => 'Açık takip yok.';

  @override
  String get sectionOverdue => 'Geciken';

  @override
  String get sectionReminderDue => 'Yaklaşan (uyarı zamanı geldi)';

  @override
  String get sectionUpcoming => 'Yaklaşan';

  @override
  String get patientFallback => 'Hasta';

  @override
  String reminderOn(String date) {
    return 'Hatırlatma: $date';
  }

  @override
  String get goToPatient => 'Hastaya git';

  @override
  String get errFollowUpTitleRequired => 'Takip başlığı yazın';

  @override
  String get followUpWhatLabel => 'Ne takip edilecek?';

  @override
  String get followUpWhatHint => 'örn. Kontrol, dikiş alma, ağrı kontrolü…';

  @override
  String get whenLabel => 'Ne zaman?';

  @override
  String notifFollowUpTitle(String name) {
    return 'Takip: $name';
  }

  @override
  String notifCheckupBody(String title, String date) {
    return '$title · Kontrol: $date';
  }

  @override
  String get notifChannelFollowUps => 'Takipler';

  @override
  String get notifChannelFollowUpsDesc => 'Kontrol ve takip hatırlatmaları';

  @override
  String get notifChannelClinic => 'Klinik bildirimleri';

  @override
  String get notifChannelClinicDesc =>
      'Katılım, takip ve yapılacak hatırlatmaları';

  @override
  String get todoAdded => 'Yapılacak eklendi';

  @override
  String get noOpenTodos =>
      'Açık yapılacak yok.\nEkle ile yazı veya sesli not ekleyin.';

  @override
  String get todosIntro => 'Klinik genel notlar — randevu, dönüş, hatırlatma…';

  @override
  String get sectionUndated => 'Tarihsiz';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterMine => 'Bana atanan';

  @override
  String get filterTodayOverdue => 'Bugün/geciken';

  @override
  String get filterCompleted => 'Tamamlanan';

  @override
  String commentAddFailed(String error) {
    return 'Yorum eklenemedi: $error';
  }

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get cameraPermissionRequired => 'Kamera izni gerekli';

  @override
  String cameraOpenFailed(String error) {
    return 'Kamera açılamadı: $error';
  }

  @override
  String galleryOpenFailed(String error) {
    return 'Galeri açılamadı: $error';
  }

  @override
  String imageAddFailed(String error) {
    return 'Görsel eklenemedi: $error';
  }

  @override
  String imageOpenFailed(String error) {
    return 'Görsel açılamadı: $error';
  }

  @override
  String get deleteImageTitle => 'Görseli sil';

  @override
  String get deleteImageConfirm => 'Bu görsel görevden kaldırılsın mı?';

  @override
  String imageDeleteFailed(String error) {
    return 'Görsel silinemedi: $error';
  }

  @override
  String get todoDetailTitle => 'Yapılacak ayrıntısı';

  @override
  String get refresh => 'Yenile';

  @override
  String get markAsCompleted => 'Tamamlandı olarak işaretle';

  @override
  String get wholeClinic => 'Tüm klinik';

  @override
  String get clinicMemberFallback => 'Klinik üyesi';

  @override
  String createdByOn(String name, String date) {
    return '$name tarafından $date tarihinde oluşturuldu';
  }

  @override
  String get images => 'Görseller';

  @override
  String get noImages => 'Görsel eklenmemiş';

  @override
  String commentsCount(int count) {
    return 'Yorumlar ($count)';
  }

  @override
  String get noCommentsYet => 'Henüz yorum yok';

  @override
  String get addCommentHint => 'Yorum ekle…';

  @override
  String get noHistory => 'Geçmiş kaydı yok';

  @override
  String get eventCreated => 'Görev oluşturuldu';

  @override
  String get eventCompleted => 'Görev tamamlandı';

  @override
  String get eventCommentAdded => 'Yorum eklendi';

  @override
  String get eventImageAdded => 'Görsel eklendi';

  @override
  String get eventImageDeleted => 'Görsel silindi';

  @override
  String get completedMessage => 'Tamamlandı';

  @override
  String get deleteTodoConfirm => 'Bu yapılacak silinsin mi?';

  @override
  String get priorityNormal => 'Normal';

  @override
  String get priorityImportant => 'Önemli';

  @override
  String get priorityUrgent => 'Acil';

  @override
  String get recurrenceNone => 'Tekrarlanmaz';

  @override
  String get recurrenceDaily => 'Her gün';

  @override
  String get recurrenceWeekly => 'Her hafta';

  @override
  String get recurrenceMonthly => 'Her ay';

  @override
  String get voiceTodo => 'Sesli yapılacak';

  @override
  String get todoFallback => 'Yapılacak';

  @override
  String previewPlayFailed(String error) {
    return 'Önizleme çalınamadı: $error';
  }

  @override
  String get taskTime => 'Görev saati';

  @override
  String get errTextOrVoiceRequired => 'Not yazın veya ses kaydedin';

  @override
  String get errFinishRecordingFirst => 'Önce ses kaydını bitirin';

  @override
  String get addTodo => 'Yapılacak ekle';

  @override
  String get todoNoteHint =>
      'örn. Yarın Fatih Bey’e randevu ver, hastaya dönüş yap…';

  @override
  String get voiceOptional => 'Ses (isteğe bağlı)';

  @override
  String get finish => 'Bitir';

  @override
  String voiceRecorded(String duration) {
    return 'Ses kaydedildi · $duration';
  }

  @override
  String get reRecord => 'Yeniden kaydet';

  @override
  String get recordVoice => 'Ses kaydet';

  @override
  String get tomorrow => 'Yarın';

  @override
  String targetDate(String date) {
    return 'Hedef: $date';
  }

  @override
  String get priority => 'Öncelik';

  @override
  String get addTime => 'Saat ekle';

  @override
  String get assignee => 'Sorumlu';

  @override
  String get patientLinkOptional => 'Hasta bağlantısı (isteğe bağlı)';

  @override
  String get noPatientSelected => 'Hasta seçilmedi';

  @override
  String get recurrence => 'Tekrar';

  @override
  String get reminder => 'Hatırlatma';

  @override
  String get remindOnTime => 'Zamanında';

  @override
  String get remindOneHourBefore => '1 saat önce';

  @override
  String get errCommentEmpty => 'Yorum boş olamaz';

  @override
  String get recurringTask => 'Tekrarlanan görev';

  @override
  String get errInvalidFilePath => 'Geçersiz dosya yolu';

  @override
  String get periodThisWeek => 'Bu hafta';

  @override
  String get periodLastWeek => 'Geçen hafta';

  @override
  String get periodThisMonth => 'Bu ay';

  @override
  String get periodLastMonth => 'Geçen ay';

  @override
  String get reportPeriod => 'Rapor dönemi';

  @override
  String comparedWith(String range) {
    return 'Karşılaştırma: $range';
  }

  @override
  String get topProcedures => 'En çok yapılan işlemler';

  @override
  String get noProceduresInPeriod => 'Bu dönemde yapılan işlem kaydı yok.';

  @override
  String get byCategory => 'Kategorilere göre';

  @override
  String get dailyActivity => 'Günlere göre yoğunluk';

  @override
  String get followUpStatus => 'Takip durumu';

  @override
  String get patientsToRecall => 'Geri çağrılacak hastalar';

  @override
  String daysPlus(int days) {
    return '$days+ gün';
  }

  @override
  String get noRecallsDue => 'Kontrol zamanı gelen hasta yok.';

  @override
  String recallsWaiting(int count) {
    return '$count hasta kontrol bekliyor';
  }

  @override
  String oldRecallsCount(int count) {
    return '+ $count eski hasta (kontrol tarihi 12 aydan önce geçmiş)';
  }

  @override
  String get openList => 'Listeyi aç';

  @override
  String get statProceduresDone => 'Yapılan işlem';

  @override
  String get statProceduresHint => 'Çok dişli işlemler diş başına sayılır';

  @override
  String get statPatientsTreated => 'Tedavi gören hasta';

  @override
  String get statVisits => 'Hasta ziyareti';

  @override
  String get statVisitsHint =>
      'Aynı hastanın farklı günlerdeki gelişleri ayrı sayılır';

  @override
  String get statNewPatients => 'Yeni hasta';

  @override
  String get statTotalPatients => 'Toplam hasta';

  @override
  String get statPendingPlanned => 'Bekleyen planlı işlem';

  @override
  String get sameAsPrevious => 'Önceki dönemle aynı';

  @override
  String weekOf(String label) {
    return '$label haftası';
  }

  @override
  String busiestDay(String day, String procedures) {
    return 'En yoğun gün: $day ($procedures)';
  }

  @override
  String overdueCount(int count) {
    return '$count gecikmiş';
  }

  @override
  String get labPending => 'Lab\'da bekleyen iş';

  @override
  String get controlPending => 'Bekleyen kontrol';

  @override
  String get openTasks => 'Açık görev';

  @override
  String completedInPeriod(int lab, int control, int task) {
    return 'Bu dönemde tamamlanan: $lab lab, $control kontrol, $task görev';
  }

  @override
  String stalledHint(int days) {
    return 'Planlanmış işlemi olup $days gündür gelmeyen ve ileri tarihli kontrolü olmayan hastalar.';
  }

  @override
  String get noPatientsToRecall => 'Geri çağrılacak hasta yok.';

  @override
  String lastProcedure(String date, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün önce',
      zero: 'bugün',
    );
    return 'Son işlem: $date ($_temp0)';
  }

  @override
  String plannedList(String items) {
    return 'Planlanan: $items';
  }

  @override
  String callPhone(String phone) {
    return 'Ara: $phone';
  }

  @override
  String firstNPatients(int count) {
    return 'İlk $count hasta gösteriliyor.';
  }

  @override
  String get moreAfterLogging => 'Arama sonucu kaydettikçe sıradakiler gelir.';

  @override
  String get call => 'Ara';

  @override
  String get recallResultAppointment => 'Randevu verildi';

  @override
  String get recallResultUnreachable => 'Ulaşılamadı';

  @override
  String get recallResultDeclined => 'İstemiyor';

  @override
  String get recallAppointmentHint => 'Kontrol tarihi seçilir, takip oluşur';

  @override
  String get recallUnreachableHint => '7 gün sonra listeye geri gelir';

  @override
  String get recallDeclinedHint =>
      'Yeni bir işlem yapılana kadar listede görünmez';

  @override
  String get openPatientCard => 'Hasta kartını aç';

  @override
  String recallLogged(String name, String result) {
    return '$name: \"$result\" olarak kaydedildi';
  }

  @override
  String get undo => 'Geri al';

  @override
  String undoFailed(String error) {
    return 'Geri alınamadı: $error';
  }

  @override
  String recallDateHelp(String name) {
    return '$name · kontrol tarihi';
  }

  @override
  String get periodicCheckup => 'Periyodik kontrol';

  @override
  String checkupReason(String procedure, String date) {
    return 'Kontrol nedeni: $procedure ($date)';
  }

  @override
  String checkupScheduled(String name, String date) {
    return '$name: kontrol $date tarihine planlandı';
  }

  @override
  String appointmentSaveFailed(String error) {
    return 'Randevu kaydedilemedi: $error';
  }

  @override
  String get recallCurrent => 'Güncel';

  @override
  String get recallOld => 'Eski hastalar';

  @override
  String get recallOldHint =>
      'Kontrol tarihi 12 aydan önce geçmiş hastalar. Uzun süredir gelmedikleri için ayrı tutulur.';

  @override
  String get recallCurrentHint =>
      'Periyodik kontrol süresi tanımlı bir işlemden sonra süresi dolan hastalar. Süreler İşlem şablonları ekranından ayarlanır. Randevusu, planlı işlemi veya ileri tarihli takibi olan hastalar listede görünmez.';

  @override
  String get noOldRecalls => 'Eski kontrol bekleyen hasta yok.';

  @override
  String checkupDue(String date) {
    return 'Kontrol: $date';
  }

  @override
  String checkupOverdue(String date, int months) {
    return 'Kontrol: $date ($months ay gecikti)';
  }

  @override
  String lastCall(String result) {
    return 'Son arama: $result';
  }

  @override
  String get noMissingDefaults => 'Eksik varsayılan yok';

  @override
  String defaultsAdded(int count) {
    return '$count varsayılan işlem eklendi';
  }

  @override
  String addFailed(String error) {
    return 'Eklenemedi: $error';
  }

  @override
  String updateFailed(String error) {
    return 'Güncellenemedi: $error';
  }

  @override
  String deleteTemplateConfirm(String name) {
    return '\"$name\" listeden silinsin mi?\nGeçmiş hasta kayıtları etkilenmez.';
  }

  @override
  String get seedMissingTooltip => 'Varsayılanlardan eksikleri getir';

  @override
  String get hideInactive => 'Pasifleri gizle';

  @override
  String get showInactive => 'Pasifleri göster';

  @override
  String get addProcedure => 'İşlem ekle';

  @override
  String get templatesIntro =>
      'Klinik işlem listesi. Yeni işlem formunda bunlar görünür. Geçmiş kayıtlar değişmez.';

  @override
  String get templatesEditRestricted =>
      'Düzenleme için doktor veya yönetici olun.';

  @override
  String get tagCanal => 'Kanal';

  @override
  String get tagToothRequired => 'Diş zorunlu';

  @override
  String get tagJawOk => 'Çene/ağız OK';

  @override
  String get tagLabTracking => 'Lab takibi';

  @override
  String tagCheckupMonths(int months) {
    return 'Kontrol: $months ay';
  }

  @override
  String get tagInactive => 'Pasif';

  @override
  String get deactivate => 'Pasifle';

  @override
  String get activate => 'Aktifleştir';

  @override
  String get noTemplatesYet => 'Henüz işlem yok.';

  @override
  String get category => 'Kategori';

  @override
  String get procedureName => 'İşlem adı';

  @override
  String get nameRequired => 'Ad gerekli';

  @override
  String get canalProcedure => 'Kanal işlemi';

  @override
  String get canalProcedureHint => 'Kanal boyu / eğe alanları açılır';

  @override
  String get toothRequired => 'Diş seçimi zorunlu';

  @override
  String get toothRequiredHint =>
      'Kapalıysa alt/üst çene / tüm ağız seçilebilir';

  @override
  String get labTracking => 'Lab takibi';

  @override
  String get labTrackingHint =>
      'Yeni işlemde “Lab’a gitti” ve dönüş tarihi görünür';

  @override
  String get periodicCheckupHelper =>
      'Bu işlemden sonra hasta kontrol çağrıları listesine düşer';

  @override
  String get none => 'Yok';

  @override
  String monthsAfter(int months) {
    return '$months ay sonra';
  }

  @override
  String get active => 'Aktif';

  @override
  String get catDiagnosis => 'Teşhis ve Planlama';

  @override
  String get catTreatment => 'Tedavi';

  @override
  String get catProsthetics => 'Protez';

  @override
  String get catGeneral => 'Genel';

  @override
  String pdfDocTitle(String name) {
    return 'Tedavi geçmişi - $name';
  }

  @override
  String pdfHeader(String name) {
    return '$name · Tedavi geçmişi';
  }

  @override
  String get pdfConfidential =>
      'Gizli: özel nitelikli kişisel veri içerir (KVKK md. 6).';

  @override
  String pdfPage(int page, int total) {
    return 'Sayfa $page / $total';
  }

  @override
  String get pdfSubtitle => 'Hasta tedavi geçmişi';

  @override
  String get pdfRegistered => 'Kayıt tarihi';

  @override
  String get pdfReportDate => 'Rapor tarihi';

  @override
  String pdfPreparedBy(String name) {
    return 'Hazırlayan: $name';
  }

  @override
  String pdfDoneProcedures(int count) {
    return 'Yapılan işlemler ($count)';
  }

  @override
  String get pdfNoProcedures => 'Kayıtlı işlem yok.';

  @override
  String pdfPlannedProcedures(int count) {
    return 'Planlanan işlemler ($count)';
  }

  @override
  String get pdfColAdded => 'Eklenme';

  @override
  String get pdfColDetails => 'Detay';

  @override
  String pdfLabReturn(String date) {
    return 'Lab · dönüş $date';
  }

  @override
  String photoCountShort(int count) {
    return '$count fotoğraf';
  }

  @override
  String get preparingPdf => 'PDF hazırlanıyor…';

  @override
  String get pdfFilePrefix => 'tedavi_gecmisi';

  @override
  String pdfCreateFailed(String error) {
    return 'PDF oluşturulamadı: $error';
  }

  @override
  String get pdfTreatmentHistory => 'Tedavi geçmişi';
}
