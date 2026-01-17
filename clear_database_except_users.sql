-- ============================================
-- KULLANICILAR HARİÇ TÜM VERİLERİ SİLME SCRIPTİ
-- ============================================
-- Bu script, users tablosunu koruyarak diğer tüm tabloları temizler
-- Foreign key constraint'leri nedeniyle doğru sırayla silme yapılır
-- 
-- KULLANIM: DBeaver'da bu scripti açın ve çalıştırın (F5 veya Execute)
-- ============================================

BEGIN;

-- 1. Junction table'ları temizle (Many-to-many ilişkiler)
-- user_depots: users ve depots arasındaki many-to-many ilişki
TRUNCATE TABLE user_depots CASCADE;

-- 2. Child tabloları temizle (Foreign key ile bağlı tablolar)
-- Photos (requests'e bağlı, CASCADE ile otomatik silinir)
TRUNCATE TABLE photos CASCADE;

-- PosmTransfers (posm ve depots'a bağlı)
TRUNCATE TABLE posm_transfers CASCADE;

-- Requests (users, dealers, territories, depots, posm'a bağlı)
-- Bu tablo birçok tabloya bağlı, CASCADE ile tüm ilişkileri temizler
TRUNCATE TABLE requests CASCADE;

-- Audit Logs (users'a bağlı, nullable olduğu için sorun yok)
TRUNCATE TABLE audit_logs CASCADE;

-- Scheduled Reports (users'a bağlı)
TRUNCATE TABLE scheduled_reports CASCADE;

-- 3. Parent tabloları temizle
-- Dealers (territories ve depots'a bağlı)
TRUNCATE TABLE dealers CASCADE;

-- Territories
TRUNCATE TABLE territories CASCADE;

-- Posm (depots'a bağlı)
TRUNCATE TABLE posm CASCADE;

-- Depots (users'a bağlı ama user_depots zaten temizlendi)
-- Users tablosundaki depot_id'leri de temizleyeceğiz
TRUNCATE TABLE depots CASCADE;

-- 4. Users tablosundaki depot_id referanslarını temizle (backward compatibility için)
UPDATE users SET depot_id = NULL WHERE depot_id IS NOT NULL;

-- 5. Sequence'leri sıfırla (ID'lerin 1'den başlaması için)
-- Yeni veriler eklendiğinde ID'ler 1'den başlayacak
DO $$
DECLARE
    seq_name TEXT;
    seq_names TEXT[] := ARRAY[
        'photos_id_seq',
        'posm_transfers_id_seq',
        'requests_id_seq',
        'audit_logs_id_seq',
        'scheduled_reports_id_seq',
        'dealers_id_seq',
        'territories_id_seq',
        'posm_id_seq',
        'depots_id_seq'
    ];
BEGIN
    FOREACH seq_name IN ARRAY seq_names
    LOOP
        EXECUTE format('ALTER SEQUENCE IF EXISTS %I RESTART WITH 1', seq_name);
    END LOOP;
END $$;

COMMIT;

-- ============================================
-- SİLME İŞLEMİ TAMAMLANDI
-- ============================================
-- ✅ Users tablosu korundu
-- ✅ Diğer tüm tablolar temizlendi
-- ✅ Foreign key referansları temizlendi
-- ✅ Sequence'ler sıfırlandı (yeni ID'ler 1'den başlayacak)
-- ============================================

-- ============================================
-- SİLME İŞLEMİ TAMAMLANDI
-- ============================================
-- Users tablosu korundu, diğer tüm tablolar temizlendi
-- Yeni veriler eklerken ID'ler 1'den başlayacak
