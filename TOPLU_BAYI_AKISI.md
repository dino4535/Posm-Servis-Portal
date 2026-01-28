# Toplu Bayi İçe Aktarma – Nasıl Çalışır?

## 1. Akış özeti

1. **Frontend** (`BulkDealerImportPage.tsx`)
   - Kullanıcı Excel dosyası seçer → "İçe Aktar" ile `POST /api/dealers/bulk-import` (FormData, `file` alanı).
   - Sadece **Admin** bu sayfaya erişebilir (menü ve route `isAdmin` ile korunuyor).

2. **Backend**
   - **Route:** `backend/src/routes/dealers.ts` → `POST /bulk-import`  
     `isAdmin`, `excelUpload.single('file')`, `bulkImportDealersController`
   - **Controller:** `bulkDealerImportController.ts`  
     `req.file` yoksa 400. Varsa `bulkImportDealers(req.file.buffer)` çağrılır, sonuç ve audit log dönülür.
   - **Servis:** `bulkDealerImportService.ts`  
     Excel buffer’dan ilk sayfayı okur, satır satır işler.

3. **Servis mantığı (satır bazlı)**
   - **Zorunlu alanlar:** `depo`, `territory_kodu`, `territory_adi`, `bayi_kodu`, `bayi_adi`.  
     Eksikse → "Eksik veri" hatası, satır atlanır.
   - **Mevcut bayi:** `bayi_kodu` daha önce (aynı import veya DB’de) varsa satır atlanır (tekrar eklenmez).
   - **Depo:** `depo` (ad veya kod) ile Depots’ta aranır; yoksa otomatik oluşturulur (`name`, `code` = ilk 10 karakter).
   - **Territory:** Aynı depo + `territory_kodu` ile Territories’te aranır; yoksa yeni Territory oluşturulur.
   - **Bayi:** `Dealers` tablosuna `code, name, territory_id, address, phone, latitude, longitude` ile INSERT.

4. **Dönen sonuç**
   - `{ total, created, skipped, errors[] }`  
   - Hatalar `errors` içinde "Satır X: …" biçimindedir.

---

## 2. Excel formatı (beklenen sütun adları)

Sütun adları **tam ve küçük harfle** aşağıdaki gibi olmalı (ilk satır başlık):

| Sütun adı        | Zorunlu | Açıklama                              |
|------------------|--------|---------------------------------------|
| `depo`           | Evet   | Depo adı veya kodu                    |
| `territory_kodu` | Evet   | Territory kodu                        |
| `territory_adi`  | Evet   | Territory adı                         |
| `bayi_kodu`      | Evet   | Bayi kodu (sistemde tekil kabul edilir) |
| `bayi_adi`       | Evet   | Bayi adı                              |
| `adres`          | Hayır  | Adres                                 |
| `telefon`        | Hayır  | Telefon                               |
| `enlem`          | Hayır  | Enlem (sayı)                          |
| `boylam`         | Hayır  | Boylam (sayı)                         |

- Sayfadaki **"Şablon İndir"** ile gelen dosya bu formattadır; mümkünse hep bu şablonu kullanın.
- Başlıklarda farklı yazım (örn. "Depo", "Bayi Kodu", boşluk) kullanılırsa sistem bu sütunları görmez ve "Eksik veri" hatası verir.

---

## 3. Bilinen sorunlar ve dikkat edilecekler

### 3.1 Dealers tablosunda `latitude` / `longitude` yoksa

- Kod, bayiyi eklerken `latitude` ve `longitude` kolonlarına yazıyor.
- Eski şemada bu kolonlar yoksa **"Invalid column name 'latitude'/'longitude'"** hatası alırsınız.
- **Çözüm:** `backend/scripts/add-dealer-latitude-longitude.sql` script’ini veritabanında çalıştırın (aşağıda kısaca anlatıldı).

### 3.2 Territories.code UNIQUE kısıtı

- Script’lerde `Territories.code` **UNIQUE** tanımlı; yani tüm sistemde bir territory kodu yalnızca bir kez kullanılabiliyor.
- Toplu import ise “aynı territory kodu farklı depolarda” olabilir diye `(code, depot_id)` ile arıyor/eklemeye çalışıyor.
- Farklı iki depoda aynı `territory_kodu` (örn. "TER001") kullanılırsa, ikinci depot için Territory INSERT’te **UNIQUE ihlali** oluşur.
- **Pratik çözüm:** Excel’de her depot için **farklı** territory kodları kullanın (örn. DEPO1_TER001, DEPO2_TER001).  
  Kalıcı çözüm için şema değişikliği (ör. `UNIQUE(code, depot_id)`) ve migration gerekir.

### 3.3 Bayi kodu tekil mi?

- Servis, “bu bayi kodu daha önce eklendi mi?” diye **tüm Dealers** içinde `code`’a bakıyor.
- Aynı `bayi_kodu` Excel’de birden fazla satırda veya önceki import’ta varsa, yalnızca ilk satır eklenir, diğerleri atlanır (skipped).

### 3.4 Dosya tipi ve boyut

- **İzin verilen:** `.xlsx`, `.xls` (ve ilgili MIME tipleri).
- **Maksimum boyut:** 10 MB (`excelUpload` middleware).
- Bunun dışındaki dosyalar 400/500 ile reddedilir; hata mesajı `error.response?.data?.error` üzerinden gösterilir.

### 3.5 yetki

- Sadece **Admin** (`isAdmin`) toplu import yapabilir. Değilse 403 benzeri yetki hatası alınır.

---

## 4. Hata ayıklama

- **"Excel dosyası yüklenmedi"**  
  İstekte `file` alanı yok veya form `multipart/form-data` değil. Frontend’in `FormData` ve `file` key’i ile gönderdiğinden emin olun.

- **"Eksik veri (Depo, Territory Kodu, ...)"**  
  İlgili satırda zorunlu sütunlar boş veya **sütun adları** yukarıdaki tabloyla birebir değil. Şablonu kullanın veya başlıkları küçük harf/alt çizgiyle yazın.

- **"Invalid column name 'latitude'"**  
  Dealers tablosunda `latitude`/`longitude` yok. `add-dealer-latitude-longitude.sql` çalıştırın.

- **UNIQUE / duplicate territory code**  
  Farklı depolarda aynı `territory_kodu` kullanıyorsunuz. Territory kodlarını depoya göre ayırın veya şemayı değiştirin.

- **Çok fazla "atlandı"**  
  Birçoğu zaten DB’de olan `bayi_kodu` veya aynı Excel içinde tekrarlayan bayi kodları olabilir. `errors` listesinde satır bazlı sebep yazıyor; inceleyin.

---

## 5. İlgili dosyalar

| Ne | Dosya |
|----|--------|
| Sayfa | `frontend/src/pages/BulkDealerImportPage.tsx` |
| API route | `backend/src/routes/dealers.ts` (POST /bulk-import) |
| Controller | `backend/src/controllers/bulkDealerImportController.ts` |
| Servis | `backend/src/services/bulkDealerImportService.ts` |
| Excel middleware | `backend/src/middleware/excelUpload.ts` |
| Dealers latitude/longitude ALTER | `backend/scripts/add-dealer-latitude-longitude.sql` |

---

## 6. Excel sütun adı esnekliği

Servis artık aşağıdaki yazımları da kabul eder (küçük harf, boşluk/alt çizgi normalize edilir):

- **depo:** `depo`, `depo adı`
- **territory_kodu:** `territory_kodu`, `territory kodu`, `territorykodu`
- **territory_adi:** `territory_adi`, `territory adı`, `territoryadi`
- **bayi_kodu:** `bayi_kodu`, `bayi kodu`, `bayikodu`
- **bayi_adi:** `bayi_adi`, `bayi adı`, `bayiadi`
- **adres, telefon, enlem, boylam:** aynı mantıkla diğer olası yazımlar okunur.
