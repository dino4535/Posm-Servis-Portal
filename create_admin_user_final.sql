-- ============================================
-- ADMIN KULLANICI OLUŞTURMA SCRIPTİ
-- ============================================
-- DBeaver'da bu scripti çalıştırarak admin kullanıcı oluşturun
-- 
-- GİRİŞ BİLGİLERİ:
-- Email: admin@example.com
-- Şifre: Admin123!
-- ============================================

BEGIN;

-- Önce mevcut admin kullanıcıyı sil (varsa)
DELETE FROM users WHERE email = 'admin@example.com';

-- Admin kullanıcı oluştur
-- Şifre: Admin123! (bcrypt hash ile)
INSERT INTO users (name, email, password_hash, role, created_at, updated_at)
VALUES (
    'Admin Kullanıcı',
    'admin@example.com',
    '$2b$12$6KdHY.yx3U5XGXLIrXZKWers/N7w/8/EcoYUryhiKWjdNee/rHDvO',
    'admin',
    NOW(),
    NOW()
);

COMMIT;

-- ============================================
-- ✅ Admin kullanıcı başarıyla oluşturuldu!
-- 
-- Giriş bilgileri:
-- Email: admin@example.com
-- Şifre: Admin123!
-- 
-- ⚠️  İlk girişten sonra şifreyi değiştirmeyi unutmayın!
-- ============================================
