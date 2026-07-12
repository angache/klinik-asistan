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

1. SQL Editor’de migration'ları şu sırayla çalıştırın: `schema.sql`, `migration_storage_auth.sql`, `migration_member_admin.sql`, `migration_join_requests.sql`, `migration_followups.sql`.
2. Storage bucket'ı artık özeldir; erişim kimlik doğrulamalı Storage politikalarıyla sağlanır.
3. Key değişirse config dosyasını güncelleyin.

## Özellikler

- Supabase Auth ile oturum açma ve kullanıcıya özel veri erişimi
- Birden çok klinik, klinik değiştirme, katılım istekleri ve üye yönetimi
- Seans notuna bağlı takip/kontrol planlama ve yerel bildirimler

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
