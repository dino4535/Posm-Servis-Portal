-- 1. ADIM: Önce latitude ve longitude kolonlarının var olup olmadığını kontrol et ve yoksa ekle
PRINT 'Latitude ve Longitude kolonlarını kontrol ediliyor...';

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Dealers') AND name = 'latitude')
BEGIN
    ALTER TABLE Dealers ADD latitude FLOAT;
    PRINT 'Latitude kolonu eklendi.';
END
ELSE
BEGIN
    PRINT 'Latitude kolonu zaten mevcut.';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Dealers') AND name = 'longitude')
BEGIN
    ALTER TABLE Dealers ADD longitude FLOAT;
    PRINT 'Longitude kolonu eklendi.';
END
ELSE
BEGIN
    PRINT 'Longitude kolonu zaten mevcut.';
END

-- 2. ADIM: Bayi tablosundaki address JSON'ından latitude ve longitude değerlerini çıkarıp ilgili kolonlara yaz
PRINT 'Koordinatları düzeltiliyor...';

UPDATE Dealers
SET 
    latitude = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            TRY_CAST(JSON_VALUE(address, '$.latitude') AS FLOAT)
        ELSE latitude
    END,
    longitude = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            TRY_CAST(JSON_VALUE(address, '$.longitude') AS FLOAT)
        ELSE longitude
    END,
    address = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            NULLIF(JSON_VALUE(address, '$.address'), '')
        ELSE address
    END
WHERE address IS NOT NULL 
  AND address LIKE '{%'
  AND (latitude IS NULL OR longitude IS NULL OR address LIKE '{%');

PRINT 'Koordinatlar düzeltildi.';

-- 2. ADIM: Bayi ve Territory tablolarını temizle
-- ÖNEMLİ: Bu işlem tüm bayi ve territory kayıtlarını siler!

PRINT 'Bayi ve Territory tabloları temizleniyor...';

-- Önce Requests tablosunda bu bayilere referans var mı kontrol et
-- Eğer varsa, bu referansları da temizlemek gerekebilir
-- (İsteğe bağlı - yorum satırını kaldırarak aktif edebilirsiniz)
-- DELETE FROM Requests WHERE dealer_id IN (SELECT id FROM Dealers);

-- Bayileri sil
DELETE FROM Dealers;

-- Territory'leri sil
DELETE FROM Territories;

-- ID'leri sıfırla (IDENTITY RESEED)
DBCC CHECKIDENT ('Dealers', RESEED, 0);
DBCC CHECKIDENT ('Territories', RESEED, 0);

PRINT 'Bayi ve Territory tabloları temizlendi!';

-- Sonuçları kontrol et
SELECT 
    (SELECT COUNT(*) FROM Dealers) as remaining_dealers,
    (SELECT COUNT(*) FROM Territories) as remaining_territories;

PRINT 'İşlem tamamlandı!';
