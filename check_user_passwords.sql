-- ============================================
-- KULLANICI ŞİFRE HASH'LERİNİ KONTROL ET
-- ============================================
-- Bu script tüm kullanıcıların password_hash'lerini kontrol eder
-- ============================================

-- Tüm kullanıcıların hash durumunu göster
SELECT 
    id,
    name,
    email,
    role,
    LENGTH(password_hash) as hash_length,
    LEFT(password_hash, 10) as hash_prefix,
    CASE 
        WHEN LENGTH(password_hash) < 60 THEN '❌ Bozuk - Çok kısa'
        WHEN password_hash NOT LIKE '$2b$%' THEN '❌ Bozuk - Format hatası'
        WHEN password_hash NOT LIKE '$2b$12$%' THEN '⚠️ Farklı rounds (12 olmalı)'
        ELSE '✅ OK'
    END as durum,
    created_at
FROM users
ORDER BY 
    CASE 
        WHEN LENGTH(password_hash) < 60 THEN 1
        WHEN password_hash NOT LIKE '$2b$%' THEN 1
        ELSE 2
    END,
    id;

-- Bozuk hash'leri say
SELECT 
    COUNT(*) as toplam_kullanici,
    SUM(CASE WHEN LENGTH(password_hash) < 60 OR password_hash NOT LIKE '$2b$%' THEN 1 ELSE 0 END) as bozuk_hash_sayisi,
    SUM(CASE WHEN LENGTH(password_hash) >= 60 AND password_hash LIKE '$2b$%' THEN 1 ELSE 0 END) as saglam_hash_sayisi
FROM users;
