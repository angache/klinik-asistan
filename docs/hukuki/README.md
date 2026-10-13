# Hukuki metin taslakları

> **Önemli:** Bu metinler uygulamanın gerçekte işlediği verilere göre hazırlanmış
> **taslaklardır**, hukuki danışmanlık değildir. Yayından önce bir avukata
> (tercihen KVKK ve sağlık hukuku alanında) kontrol ettirin.

| Dosya | Kimin için | Uygulamadaki ayar |
|-------|------------|-------------------|
| `gizlilik-politikasi.md` | Herkes (mağaza sayfası da bunu ister) | `PRIVACY_POLICY_URL` |
| `kvkk-aydinlatma-metni.md` | Uygulamayı kullanan klinik personeli | `KVKK_NOTICE_URL` |
| `kullanim-kosullari.md` | Uygulamayı kullanan klinikler | `TERMS_URL` |
| `hasta-aydinlatma-metni-sablonu.md` | Kliniklerin kendi hastalarına vereceği metin (uygulamada link yok) | — |

## Doldurulacak yer tutucular

Metinlerde köşeli parantez içindeki alanları kendi bilgilerinizle değiştirin:

- `[HİZMET SAĞLAYICI]`: Şirket unvanı veya şahıs şirketiyse ad soyad
- `[ADRES]`, `[MERSİS / VERGİ NO]`, `[KEP ADRESİ]` (varsa)
- `[DESTEK E-POSTASI]`: Uygulamadaki `SUPPORT_EMAIL` ile aynı olmalı
- `[SUNUCU BÖLGESİ]`: Supabase Dashboard → Project Settings → General → Region
  (ör. "AB – Frankfurt")
- `[YEDEK SAKLAMA SÜRESİ]`: Supabase planınızdaki yedek süresi (ör. 7 gün)
- `[YÜRÜRLÜK TARİHİ]`

## Yayınlama

Mağazalar ve uygulama bu metinlere **herkese açık bir web adresi** üzerinden
bağlanır. Basit seçenekler: Google Sites, Notion (Share → Publish) veya
GitHub Pages. Adresler hazır olunca derlemede verin:

```
flutter build appbundle --release \
  --dart-define=PRIVACY_POLICY_URL=https://... \
  --dart-define=KVKK_NOTICE_URL=https://... \
  --dart-define=TERMS_URL=https://... \
  --dart-define=SUPPORT_EMAIL=destek@...
```

## Yurt dışına aktarım hakkında not

Veriler Supabase (veritabanı ve dosyalar) ve Google Firebase (bildirim ve çökme
raporu) sunucularında tutulur; bu hizmetler yurt dışındadır. 2024 KVKK
değişikliğinden sonra yurt dışı aktarım için genellikle Kurul'un ilan ettiği
**standart sözleşmenin** imzalanması ve imzadan sonra **5 iş günü içinde
Kurul'a bildirilmesi** gerekir. Bu adımı avukatınızla birlikte planlayın.
