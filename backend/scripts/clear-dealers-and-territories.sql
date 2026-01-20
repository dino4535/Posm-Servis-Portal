-- Bayi, Territory ve Requests tablolarını temizle
-- ÖNEMLİ: Bu script tüm bayi, territory ve talep kayıtlarını siler!

-- Önce Requests tablosunu temizle (foreign key constraint'leri için)
-- Photos tablosunu da temizle (Requests'e bağlı)
DELETE FROM Photos;
DELETE FROM Requests;

-- Bayileri sil
DELETE FROM Dealers;

-- Territory'leri sil
DELETE FROM Territories;

-- ID'leri sıfırla (IDENTITY RESEED)
DBCC CHECKIDENT ('Photos', RESEED, 0);
DBCC CHECKIDENT ('Requests', RESEED, 0);
DBCC CHECKIDENT ('Dealers', RESEED, 0);
DBCC CHECKIDENT ('Territories', RESEED, 0);

-- Sonuçları kontrol et
SELECT 
    (SELECT COUNT(*) FROM Requests) as remaining_requests,
    (SELECT COUNT(*) FROM Dealers) as remaining_dealers,
    (SELECT COUNT(*) FROM Territories) as remaining_territories;

PRINT 'Requests, Bayi ve Territory tabloları temizlendi!';
