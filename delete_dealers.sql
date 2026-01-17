-- ============================================
-- DEALERS TABLOSUNU TEMİZLEME SCRIPTİ
-- ============================================
-- DBeaver'da bu scripti çalıştırarak dealers tablosunu temizleyin
-- 
-- ⚠️  DİKKAT: Bu script dealers tablosundaki TÜM verileri siler!
-- 
-- ÖNEMLİ: Requests tablosunda dealer_id NOT NULL olduğu için,
-- önce requests tablosundaki verileri silmemiz gerekiyor.
-- ============================================

BEGIN;

-- 1. Önce requests tablosundaki verileri sil (dealer_id NOT NULL olduğu için)
-- Eğer requests verilerini korumak istiyorsanız, bu satırı yorum satırı yapın
DELETE FROM requests;

-- 2. Dealers tablosundaki tüm verileri sil
DELETE FROM dealers;

-- 3. Sequence'i sıfırla (ID'lerin 1'den başlaması için)
ALTER SEQUENCE IF EXISTS dealers_id_seq RESTART WITH 1;

COMMIT;

-- ============================================
-- ✅ Dealers tablosu başarıyla temizlendi!
-- ============================================
-- 
-- Kontrol sorguları:
-- SELECT COUNT(*) FROM dealers;  -- Sonuç: 0 olmalı
-- SELECT COUNT(*) FROM requests WHERE dealer_id IS NOT NULL;  -- Sonuç: 0 olmalı
-- ============================================
