# Klinik Asistan

Diş hekimi asistanı için Flutter + Supabase uygulaması. Yoğun klinikte klavye kullanımını minimize eder: dokun-seç şablonlar, diş numarası chip'leri, kanal parametreleri ve seans fotoğrafı.

> Ortam kurulumu, derleme çıktıları ve cihaz kurulumu için: [`docs/ILERLEME.md`](docs/ILERLEME.md)

## Kurulum

### 1. Flutter

Bu makinede Flutter: `C:\src\flutter` (PATH’e ekli).

```bash
cd klinik_asistan
flutter pub get
```

İlk kurulumda platform dosyaları için (gerekirse):

```bash
flutter create . --project-name klinik_asistan --org com.klinik --platforms=android,windows,web
```

> Windows’ta plugin derlemesi için **Geliştirici Modu** açık olmalı.

### 2. Supabase

Aktif proje: **dentasist** (`hdgyzlrgcrrkoupgvfzd`). Bilgiler `lib/config/supabase_config.dart` içinde.

1. Şema `supabase/sql/` altında numaralı dosyalardır. **Yeni projede** SQL Editor'de `001`'den başlayıp sırayla hepsini çalıştırın. **Mevcut projede** yalnızca henüz çalıştırılmamış olanları çalıştırın. Dosyalar tekrar çalıştırılabilir (`if not exists` / `create or replace`) yazılmıştır.
   - `push_kurulum_notlari.sql` SQL değil; push, Edge Function, webhook ve cron kurulum kontrol listesidir.
   - Klasör bilerek `supabase/migrations/` değildir: Supabase CLI o klasörü `db push` ile otomatik uygulamaya çalışır.
2. Storage bucket'ı özeldir; erişim kimlik doğrulamalı Storage politikalarıyla sağlanır. Dosya silme / üzerine yazma yalnızca yükleyene veya admin/doktora açıktır.
3. Key değişirse config dosyasını güncelleyin.

### Edge Functions

| Fonksiyon | Deploy | Tetikleyen |
|---|---|---|
| `daily-reminders` | `--no-verify-jwt` | Cron, her gün 08:00 (`Authorization: Bearer <CRON_SECRET>`) |
| `notify-join-request` | `--no-verify-jwt` | DB webhook, `klinik_katilim_istekleri` INSERT (`Authorization: Bearer <CRON_SECRET>`) |
| `delete-account` | JWT doğrulaması açık | Uygulama → Ayarlar → Hesabımı sil |

`CRON_SECRET` tanımlı değilse cron/webhook fonksiyonları çalışmaz (bilerek kapalı başarısız olur).

### Yayın hazırlığı

- **Android imzalama:** `android/key.properties.example` dosyasını `android/key.properties` olarak kopyalayıp doldurun. Dosya yoksa release derleme debug anahtarıyla imzalanır ve mağazaya yüklenemez.
- **Uygulama ikonu:** Kaynaklar `assets/icon/` altında (1024×1024). Değiştirirseniz `dart run flutter_launcher_icons` çalıştırın.
- **Hukuki bağlantılar:** Metin taslakları `docs/hukuki/` altında; yayınlamadan önce yer tutucuları doldurup avukata kontrol ettirin. Derlemede `--dart-define=PRIVACY_POLICY_URL=... --dart-define=KVKK_NOTICE_URL=... --dart-define=TERMS_URL=... --dart-define=SUPPORT_EMAIL=...` verin (bkz. `lib/config/legal_config.dart`). Boş olanlar uygulamada gösterilmez.
- **Şifre sıfırlama:** Supabase → Authentication → Email Templates → Reset Password şablonuna `{{ .Token }}` ekleyin.

## Özellikler

- Supabase Auth ile oturum açma ve kullanıcıya özel veri erişimi
- Birden çok klinik, klinik değiştirme, katılım istekleri ve üye yönetimi
- Seans notuna bağlı takip/kontrol planlama, push (08:00) ve yerel bildirimler
- Seans başına 10 fotoğraf, WhatsApp / e-posta ile paylaşım
- Hasta tedavi geçmişini PDF olarak paylaşma
- Raporlar: dönem özeti ve önceki dönemle kıyas, en çok yapılan işlemler, günlük yoğunluk, takip durumu, geri çağrılacak hastalar (`026_raporlar.sql`)
- Kontrol çağrıları: işlem şablonundaki periyodik kontrol süresi dolan hastalar, arama sonucu kaydı (randevu / ulaşılamadı / istemiyor), 12 aydan eski hastalar ayrı sekmede, ana ekranda rozet (`027_kontrol_cagrilari.sql`)
- Şifremi unuttum (e-posta kodu), uygulama içi hesap silme
- Crashlytics (Android / iOS, yalnızca release)

### 3. Çalıştırma

```bash
# USB bağlı Android cihaz
flutter devices
flutter run --release

# veya hazır APK
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

## Android izinleri

`AndroidManifest.xml` içinde tanımlı:

| İzin | Amaç |
|------|------|
| `INTERNET` | Supabase API / Storage |
| `CAMERA` | Seans fotoğrafı çekme |
| `READ_EXTERNAL_STORAGE` (API ≤ 32) | Galeriden seçim |
| `POST_NOTIFICATIONS` (API ≥ 33) | Takip hatırlatmaları |
| `RECEIVE_BOOT_COMPLETED` | Yeniden başlatmada zamanlanmış bildirimleri geri kurma |
| `RECORD_AUDIO` | Sesli not |

Uygulama verisi bulut yedeğine ve cihaz aktarımına dahil edilmez (`allowBackup=false`, `data_extraction_rules.xml`).

`image_picker` FileProvider yolları: `res/xml/flutter_image_picker_file_paths.xml`

## Proje yapısı

```
lib/
  main.dart
  config/supabase_config.dart
  theme/app_theme.dart
  models/patient.dart
  models/treatment_note.dart
  data/treatment_templates.dart
  services/database_service.dart
  screens/dashboard_screen.dart
  widgets/
    patient_card.dart
    new_session_dialog.dart
    tooth_selector.dart
    kanal_params_section.dart
    treatment_note_tile.dart
    photo_preview.dart
    full_screen_image.dart
```

## Kullanıcı akışı

1. **Dashboard** — Sabit arama çubuğu ile anlık hasta filtresi.
2. Hasta kartı (`ExpansionTile`) → geçmiş seanslar (en yeni üstte), kapsam badge'i, fotoğraf thumbnail → tam ekran.
3. **Yeni Seans** — Kapsam (`SegmentedButton`) → diş no (tek diş) → şablon chip'leri → kanal alanları (dinamik) → fotoğraf → Kaydet.

## Tema

Material 3, Teal seed (`#00897B`).
