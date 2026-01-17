-- ============================================
-- DEPO OLUŞTURMA SCRIPTİ
-- ============================================
-- DBeaver'da bu scripti çalıştırarak depoları oluşturun
-- 
-- Oluşturulacak Depolar:
-- 1. İzmir
-- 2. Manisa
-- 3. Salihli
-- ============================================

BEGIN;

-- Önce mevcut depoları kontrol et ve sil (varsa)
DELETE FROM depots WHERE code IN ('IZMIR', 'MANISA', 'SALIHLI');

-- İzmir Deposu
INSERT INTO depots (name, code)
VALUES ('İzmir', 'IZMIR')
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

-- Manisa Deposu
INSERT INTO depots (name, code)
VALUES ('Manisa', 'MANISA')
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

-- Salihli Deposu
INSERT INTO depots (name, code)
VALUES ('Salihli', 'SALIHLI')
ON CONFLICT (code) DO UPDATE SET name = EXCLUDED.name;

COMMIT;

-- ============================================
-- ✅ Depolar başarıyla oluşturuldu!
-- ============================================
-- Oluşturulan depoları kontrol etmek için:
-- SELECT * FROM depots ORDER BY id;
-- ============================================
