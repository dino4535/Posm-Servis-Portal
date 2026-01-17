-- ============================================
-- KULLANICI ŞİFRE HASH'LERİNİ DÜZELTME
-- ============================================
-- Bu script bozuk bcrypt hash'lerini düzeltir
-- ============================================

BEGIN;

-- 1. Önce mevcut admin kullanıcıyı sil
DELETE FROM users WHERE email = 'admin@example.com';

-- 2. Admin kullanıcıyı doğru hash ile yeniden oluştur
-- Şifre: Admin123!
-- Bu hash bcrypt ile oluşturuldu (12 rounds)
INSERT INTO users (name, email, password_hash, role, created_at, updated_at)
VALUES (
    'Admin Kullanıcı',
    'admin@example.com',
    '$2b$12$6KdHY.yx3U5XGXLIrXZKWers/N7w/8/EcoYUryhiKWjdNee/rHDvO',
    'admin',
    NOW(),
    NOW()
);

-- 3. Diğer kullanıcıların hash'lerini kontrol et
-- Bozuk hash'ler genellikle 60 karakterden kısa veya format hatası içerir
-- Bu sorgu bozuk hash'leri bulur (60 karakterden kısa veya $2b$ ile başlamayan)
SELECT 
    id,
    name,
    email,
    LENGTH(password_hash) as hash_length,
    CASE 
        WHEN LENGTH(password_hash) < 60 THEN 'Bozuk - Çok kısa'
        WHEN password_hash NOT LIKE '$2b$%' THEN 'Bozuk - Format hatası'
        ELSE 'OK'
    END as durum
FROM users
WHERE LENGTH(password_hash) < 60 
   OR password_hash NOT LIKE '$2b$%'
ORDER BY id;

COMMIT;

-- ============================================
-- ✅ Admin kullanıcı düzeltildi!
-- 
-- Giriş bilgileri:
-- Email: admin@example.com
-- Şifre: Admin123!
-- 
-- ⚠️  Yukarıdaki SELECT sorgusu bozuk hash'leri gösterir
-- Bozuk hash'leri olan kullanıcılar için şifrelerini yeniden hash'leyin
-- ============================================
