-- ============================================
-- ADMIN KULLANICI OLUŞTURMA SCRIPTİ
-- ============================================
-- DBeaver'da bu scripti çalıştırarak admin kullanıcı oluşturun
-- ============================================

-- Önce mevcut admin kullanıcıyı kontrol et ve sil (varsa)
DELETE FROM users WHERE email = 'admin@example.com';

-- Admin kullanıcı oluştur
-- Şifre: Admin123!
-- Bu hash'i Python ile oluşturduk, bcrypt hash'i
INSERT INTO users (name, email, password_hash, role, created_at, updated_at)
VALUES (
    'Admin Kullanıcı',
    'admin@example.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5GyY5Y5Y5Y5Y5',  -- Bu geçici hash, aşağıdaki Python scripti ile doğru hash'i oluşturun
    'admin',
    NOW(),
    NOW()
);

-- ============================================
-- NOT: Yukarıdaki hash geçici bir örnektir!
-- Doğru hash için Python scriptini kullanın:
-- python backend/scripts/create_admin.py
-- ============================================
