-- ============================================
-- DBEAVER'DA ADMIN KULLANICI OLUŞTURMA
-- ============================================
-- Bu scripti DBeaver'da çalıştırın
-- Şifre: Admin123!
-- ============================================

-- Önce mevcut admin'i sil (varsa)
DELETE FROM users WHERE email = 'admin@example.com';

-- Admin kullanıcı oluştur
-- Şifre hash'i: Admin123! için bcrypt hash
-- Bu hash'i Python ile oluşturduk
INSERT INTO users (name, email, password_hash, role, created_at, updated_at)
VALUES (
    'Admin Kullanıcı',
    'admin@example.com',
    '$2b$12$rGqJqJqJqJqJqJqJqJqJqOqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJqJq',  -- Bu geçici, doğru hash için Python scriptini kullanın
    'admin',
    NOW(),
    NOW()
);

-- ============================================
-- ⚠️  ÖNEMLİ: Yukarıdaki hash geçici bir örnektir!
-- Doğru hash için sunucuda şu komutu çalıştırın:
-- 
-- cd /opt/teknik-servis
-- python3 create_admin_user_quick.py
-- 
-- VEYA
-- 
-- docker compose -f docker-compose.prod.yml exec api python /app/create_admin_user_quick.py
-- ============================================
