-- ============================================
-- KULLANICILAR HARİÇ TÜM VERİLERİ SİLME SCRIPTİ (DELETE VERSİYONU)
-- ============================================
-- TRUNCATE çalışmazsa bu scripti kullanın
-- DELETE kullanarak foreign key constraint'leri dikkate alarak siler
-- ============================================

BEGIN;

-- 1. Junction table'ları temizle
DELETE FROM user_depots;

-- 2. Child tabloları temizle (Foreign key ile bağlı tablolar)
DELETE FROM photos;
DELETE FROM posm_transfers;
DELETE FROM requests;
DELETE FROM audit_logs;
DELETE FROM scheduled_reports;

-- 3. Parent tabloları temizle
DELETE FROM dealers;
DELETE FROM territories;
DELETE FROM posm;
DELETE FROM depots;

-- 4. Users tablosundaki depot_id referanslarını temizle
UPDATE users SET depot_id = NULL WHERE depot_id IS NOT NULL;

-- 5. Sequence'leri sıfırla
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
