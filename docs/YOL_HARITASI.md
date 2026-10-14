# Klinik Asistan — Ticari Ürün Yol Haritası

> Taslak. Hukuki ve mali maddeler genel bilgi niteliğindedir; uygulamadan önce
> bir avukat (tercihen sağlık/KVKK alanında) ve mali müşavirle teyit edin.

## 1. Konumlandırma

**Ana klinik programının yerine değil, yanına.** Diş kliniklerinin çoğunda
randevu, cari hesap, fatura ve e-reçete için kullanılan bir ana program zaten
var. Onlarla randevu ve muhasebe üzerinden rekabet etmek uzun ve pahalı bir yol.
Her ülkede ana program da farklı; Klinik Asistan hiçbirine bağlı olmadığı için
her ülkede aynı şekilde kullanılabilir. Farkı başka yerde:

- Ayrıntılı klinik not (diş bazında işlem, kanal boyları, planlanan işlemler,
  sesli not, fotoğraf)
- Lab ve kontrol takipleri, periyodik kontrol çağrıları
- Ekip içi yapılacaklar ve bildirimler
- Telefondan hızlı kullanım

Satış cümlesi örneği: *"Ana programınızı bırakmadan, hekimin ve asistanın
klinik notlarını, takiplerini ve geri çağrılarını tek yerde toplayın."*

İleride talep gelirse randevu gibi modüller eklenebilir; ama ilk sürümde
odağı dağıtmamak önemli.

## 2. Bugünkü durum

**Hazır olanlar:** çok klinikli yapı ve klinik bazında veri ayrımı (RLS), roller
ve katılım onayı, işlem şablonları, seans notları ve not geçmişi, fotoğraf ve
ses, planlanan işlemler, lab/kontrol takipleri, push ve yerel bildirimler,
yapılacaklar, raporlar, kontrol çağrıları, hasta PDF çıktısı, şifre sıfırlama,
hesap silme, Crashlytics, KVKK onay kutusu ve hukuki metin taslakları,
uygulama ikonu.

**Çoklu dil (tamamlandı):** Türkçe, İngilizce, Almanca, Rusça, Fransızca,
İspanyolca. Uygulama telefonun dilini izler, Ayarlar'dan değiştirilebilir.
Push bildirimleri her cihaza kendi dilinde gider. Yeni klinik, kurucunun
dilinde varsayılan işlem şablonlarıyla açılır; mevcut klinikler Türkçe kalır.

**Satış için eksik olanlar:** aşağıdaki aşamalarda.

## 3. Aşamalar

### Aşama 0 — Doğrulama (0–2 ay)

Kod yazmadan önce "başka klinikler bunu ister mi, kaç para verir?" sorusunu
cevaplamak.

- [ ] Kendi kliniğinizdeki kullanımı ölçün: günde kaç not, kimler kullanıyor,
      en çok hangi ekran. (Bu, satışta en güçlü referansınız.)
- [ ] 10–15 diş hekimiyle kısa görüşme: hangi ana programı kullanıyorlar, not ve
      takip için ne yapıyorlar (kağıt, WhatsApp, Excel?), aylık ne öderler.
- [ ] 3–5 kliniğe ücretsiz pilot (2–3 ay). Karşılığında düzenli geri bildirim
      ve izin verirlerse referans.
- [ ] Pilotlarda en çok istenen 3 özelliği not edin; Aşama 3'ün sırasını buna
      göre belirleyin.

**Bu aşamanın sonunda karar:** devam / konum değiştir / dur.

### Aşama 1 — Hukuki ve şirket altyapısı (paralel, 1–2 ay)

- [ ] **Şirket:** fatura kesebilmek için şahıs şirketi veya limited şirket;
      e-fatura/e-arşiv. Mali müşavirle görüşün.
- [ ] **Fikri mülkiyet:** Kod sizin mi, kliniğin mi? Klinik ortaklarıyla yazılı
      olarak netleştirin.
- [ ] **Marka:** "Klinik Asistan" çok genel, tescil edilmesi zor olabilir. Ayırt
      edici bir isim bulup TÜRKPATENT'te araştırma ve başvuru yapın.
- [ ] **KVKK rolleri:** Klinik *veri sorumlusu*, siz *veri işleyen*siniz. Her
      müşteriyle **veri işleme sözleşmesi** imzalayın (`docs/hukuki/`
      taslaklarına eklenecek).
- [ ] **Yurt dışı aktarım:** Supabase sunucusu yurt dışındaysa (ör. Frankfurt),
      KVKK m.9 kapsamında standart sözleşme ve imzadan sonra 5 iş günü içinde
      Kurum'a bildirim gerekir. Alternatif: ileride Türkiye'de barındırma
      (satışta güven avantajı sağlar, maliyeti yüksek).
- [ ] **Sağlık mevzuatı:** "Kişisel Sağlık Verileri Hakkında Yönetmelik" ve
      Sağlık Bakanlığı'nın sağlık bilgi sistemleri kuralları bu ürüne nasıl
      uygulanır, avukata teyit ettirin.
- [ ] **Metinler:** gizlilik politikası, KVKK aydınlatma metni, kullanım
      koşulları, mesafeli satış sözleşmesi, hizmet seviyesi (SLA) taahhüdü.
      Yayınlayıp uygulamaya bağlantıları verin.
- [ ] **SMS/WhatsApp hatırlatma eklenecekse:** İYS ve ticari ileti kuralları.

### Aşama 2 — Teknik sağlamlaştırma (1–2 ay)

Başkasının hasta verisini taşımaya başlamadan önce:

- [ ] **Test ve canlı ortam ayrımı:** ayrı Supabase projeleri; SQL dosyaları
      önce testte denenip sonra canlıya uygulanır.
- [ ] **Yedekleme:** Supabase Pro günlük yedek; mümkünse belirli bir ana geri
      dönüş (PITR). Yılda en az bir kez geri yükleme denemesi.
- [ ] **İşlem kaydı (audit log):** kim, hangi hastada, neyi, ne zaman
      değiştirdi/sildi.
- [ ] **Uygulama kilidi:** PIN / parmak izi, belirli süre sonra otomatik kilit
      (klinikte telefonlar ortada kalıyor).
- [ ] **İki adımlı doğrulama** (en azından yöneticiler için).
- [ ] **Zorunlu güncelleme:** eski sürümleri "lütfen güncelleyin" ekranına
      yönlendiren asgari sürüm kontrolü.
- [ ] **Veri taşınabilirliği:** klinik ayrılırken tüm verisini (Excel + PDF +
      fotoğraflar) indirebilmeli; sözleşme bitince veri belirli sürede silinmeli.
- [ ] **Kota ve maliyet takibi:** klinik başına fotoğraf/ses depolama kullanımı.
- [ ] **Otomatik test/derleme (CI):** her gönderimde `flutter analyze` ve
      `flutter test`.
- [ ] **Güvenlik testi:** satıştan önce bağımsız bir sızma testi (pen test).
- [ ] **Mağaza hazırlığı:** release imza anahtarı, Android/iOS paket adlarının
      eşitlenmesi, mağaza görselleri ve açıklamaları.

### Aşama 3 — Satışa hazır ürün (pilot geri bildirimine göre sıralanır)

| Özellik | Neden |
|---|---|
| Masaüstü / web sürümü | Resepsiyon ve hekim odasında bilgisayar kullanılıyor |
| Diş haritası | Hekimlerin ilk baktığı yer; satış demosunda en etkili ekran |
| Excel'den hasta içe aktarma | Yeni klinik ilk gün boş liste görmesin |
| Abonelik ve deneme süresi | Deneme bitince salt-okunur mod, ödeme sonrası açılır |
| İlk kurulum rehberi + örnek veri | Klinik kendi kendine başlayabilsin |
| Uygulama içi destek / geri bildirim | WhatsApp destek hattı da olur |
| Onam formu + ekranda imza | Kliniklerin kağıtla yaptığı, değerli bir iş |
| SMS / WhatsApp kontrol hatırlatması | Kontrol çağrılarını otomatikleştirir (İYS'ye dikkat) |

**Ödeme notu:** Uygulama içinde fiyat gösterip satış yapmayın. Abonelik web
sitesinden (iyzico, PayTR vb.) alınsın; uygulama yalnızca giriş yapsın. Apple bu
modeli kurumlara satılan hizmetler için kabul ediyor (App Store kuralları
3.1.3(c)). Mağaza başvurusundan önce Apple ve Google'ın güncel kurallarını
kontrol edin.

### Aşama 3b — Yurt dışına açılma (ilk yabancı müşteriden önce)

Çeviri hazır; aşağıdakiler Türkiye dışındaki bir kliniğin sorunsuz
kullanabilmesi için gerekli.

- [ ] **Sunucu saat dilimi:** Raporlardaki gün sınırı, kontrol listesindeki
      "bugün" ve sabah 08:00 push'u İstanbul saatine sabit. Kliniğe saat dilimi
      eklenmeli; sabah push'u saatlik çalışıp her kliniğe kendi 08:00'inde
      gönderilmeli. (Ör. Almanya'daki klinik şu an bildirimi 06:00'da alır.)
- [ ] **Universal diş numarası (1–32):** Yalnızca ABD'ye açılırken. Kayıtlar
      FDI olarak kalır, diş seçici ve gösterim ayara göre çevrilir.
- [ ] **Çeviri kontrolü:** Her dil için ana dili o dil olan bir diş hekimi
      veya asistan terimleri gözden geçirsin (özellikle işlem şablonu adları).
- [ ] **Hukuki metinler her ülke için:** KVKK yerine AB'de GDPR (veri işleme
      sözleşmesi, gizlilik politikası, onay metni). Supabase'in Frankfurt'ta
      olması AB müşterileri için avantaj.
- [ ] **Mağaza sayfaları her dilde:** açıklama, ekran görüntüleri, anahtar
      kelimeler. Hangi ülkelerden indirildiği App Store Connect ve Google Play
      Console'daki ülke raporlarından izlenir.
- [ ] **Fiyat ve ödeme:** ülkeye göre para birimi; ödeme altyapısının
      yurt dışı kartları desteklemesi.
- [ ] **Destek dili:** en azından İngilizce destek e-postası.

### Aşama 4 — Satış ve pazarlama

- **Fiyat modeli:** klinik başına aylık abonelik; kullanıcı sayısı ve depolama
  alanına göre 2–3 paket; yıllık ödemede indirim; 30 gün ücretsiz deneme.
  Pilot kliniklere "kurucu müşteri" indirimi. Rakam, Aşama 0 görüşmelerinde
  duyulan ödeme isteğine göre belirlenir.
- **Kanallar:**
  - Kendi kliniğiniz ve pilotlar (referans, video yorum)
  - Diş hekimi meslektaş ağları, diş hekimleri odası etkinlikleri, kongreler
  - Dental depolar ve laboratuvarlar (her gün çok sayıda kliniği ziyaret ediyorlar)
  - Instagram / YouTube'da kısa kullanım videoları
  - "Diş kliniği hasta takip programı" gibi aramalar için Google reklamları
- **Tanıtım sitesi:** ne yaptığı, ekran görüntüleri, fiyatlar, KVKK sayfası,
  demo talep formu.
- **Destek:** ilk aylarda telefonla kurulum desteği. Bu, müşteriyi tutmanın
  en ucuz yolu.

### Aşama 5 — Büyüme (talep oldukça)

- Tedavi planı ve fiyat teklifi (hastaya PDF/WhatsApp)
- Lab ile ortak ekran (lab işlerin durumunu kendisi güncellesin)
- Basit randevu modülü (ana programı olmayan küçük klinikler için)
- Ana programlarla entegrasyon: ülkeden ülkeye farklı oldukları için öncelik
  değil; yalnızca çok talep gören ve API sunan bir program olursa
- Çok şubeli klinik zinciri raporları

## 4. Yaklaşık sabit giderler

| Kalem | Tutar |
|---|---|
| Supabase Pro | ~25 USD/ay + kullanım (depolama, trafik) |
| Apple Developer | 99 USD/yıl |
| Google Play | 25 USD tek seferlik |
| Alan adı + e-posta | düşük |
| Mali müşavir | aylık |
| Avukat (sözleşmeler, KVKK) | başlangıçta tek seferlik |
| Sızma testi | satıştan önce bir kez |

Firebase (bildirim, Crashlytics) bu ölçekte ücretsiz.

## 5. Riskler

- **Veri ihlali:** sağlık verisi en hassas veri türü; tek bir olay ürünü bitirir.
  Aşama 2 bu yüzden satıştan önce.
- **Destek yükü:** her yeni klinik soru demek; tek kişiyle sınırlı sayıda
  müşteriye hizmet verilebilir.
- **Ana programların aynı özelliği eklemesi:** hız ve hekim odaklı kullanım
  kolaylığı en iyi savunma.
- **Klinik içi iş yükü:** ürün sahibi aynı zamanda klinikte çalışıyorsa zaman
  planı gerçekçi tutulmalı.

## 6. Karar bekleyen sorular

1. Pilot olarak hangi klinikler? (Tanıdık hekimler, farklı büyüklükte)
2. Şirket türü ve kimin adına?
3. Sunucu yeri: Frankfurt'ta kalıp yurt dışı aktarım sözleşmesi mi, Türkiye'de
   barındırma mı?
4. Ürün adı? (Yurt dışı için Türkçe olmayan, her dilde okunabilen bir ad
   daha uygun.)
5. İlk sürümde masaüstü/web şart mı, yoksa mobil yeterli mi?
6. Türkiye'den sonra hangi ülkeler? Mağaza ülke raporları ve pilot talebine
   göre seçilir; Aşama 3b o ülkeler için yapılır.
