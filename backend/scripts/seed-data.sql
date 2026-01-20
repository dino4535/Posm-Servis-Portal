-- POSM Teknik Servis Portalı - Başlangıç Verileri
-- MSSQL Server

USE POSM;
GO

-- 1. Depoları oluştur (eğer yoksa)
IF NOT EXISTS (SELECT 1 FROM Depots WHERE code = 'DEPO1')
BEGIN
    INSERT INTO Depots (name, code, address, is_active) VALUES
    ('Depo 1', 'DEPO1', 'İstanbul', 1);
    PRINT 'Depo 1 oluşturuldu';
END
GO

IF NOT EXISTS (SELECT 1 FROM Depots WHERE code = 'DEPO2')
BEGIN
    INSERT INTO Depots (name, code, address, is_active) VALUES
    ('Depo 2', 'DEPO2', 'Ankara', 1);
    PRINT 'Depo 2 oluşturuldu';
END
GO

IF NOT EXISTS (SELECT 1 FROM Depots WHERE code = 'DEPO3')
BEGIN
    INSERT INTO Depots (name, code, address, is_active) VALUES
    ('Depo 3', 'DEPO3', 'İzmir', 1);
    PRINT 'Depo 3 oluşturuldu';
END
GO

-- 2. Admin kullanıcı oluştur (eğer yoksa)
-- Şifre: admin123
IF NOT EXISTS (SELECT 1 FROM Users WHERE email = 'admin@posm.com')
BEGIN
    INSERT INTO Users (email, password_hash, name, role, is_active) VALUES
    ('admin@posm.com', '$2a$10$sdQ7LUYoQE5v/GDkUe44YugX65Cf/Xt.U5JyqXrciJIi2PhxA3fpO', 'Admin User', 'Admin', 1);
    PRINT 'Admin kullanıcı oluşturuldu (Email: admin@posm.com, Şifre: admin123)';
END
GO

-- 3. Admin kullanıcıya tüm depoları ata
DECLARE @AdminUserId INT;
DECLARE @Depot1Id INT;
DECLARE @Depot2Id INT;
DECLARE @Depot3Id INT;

SELECT @AdminUserId = id FROM Users WHERE email = 'admin@posm.com';
SELECT @Depot1Id = id FROM Depots WHERE code = 'DEPO1';
SELECT @Depot2Id = id FROM Depots WHERE code = 'DEPO2';
SELECT @Depot3Id = id FROM Depots WHERE code = 'DEPO3';

IF @AdminUserId IS NOT NULL
BEGIN
    -- Depo 1
    IF @Depot1Id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM User_Depots WHERE user_id = @AdminUserId AND depot_id = @Depot1Id)
    BEGIN
        INSERT INTO User_Depots (user_id, depot_id) VALUES (@AdminUserId, @Depot1Id);
        PRINT 'Admin kullanıcıya Depo 1 atandı';
    END
    
    -- Depo 2
    IF @Depot2Id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM User_Depots WHERE user_id = @AdminUserId AND depot_id = @Depot2Id)
    BEGIN
        INSERT INTO User_Depots (user_id, depot_id) VALUES (@AdminUserId, @Depot2Id);
        PRINT 'Admin kullanıcıya Depo 2 atandı';
    END
    
    -- Depo 3
    IF @Depot3Id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM User_Depots WHERE user_id = @AdminUserId AND depot_id = @Depot3Id)
    BEGIN
        INSERT INTO User_Depots (user_id, depot_id) VALUES (@AdminUserId, @Depot3Id);
        PRINT 'Admin kullanıcıya Depo 3 atandı';
    END
END
GO

PRINT 'Başlangıç verileri başarıyla eklendi!';
PRINT 'Admin Giriş Bilgileri:';
PRINT 'Email: admin@posm.com';
PRINT 'Şifre: admin123';
GO
