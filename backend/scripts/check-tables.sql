-- Tabloları ve yapılarını kontrol et
USE POSM;
GO

PRINT '=== TABLO LİSTESİ ===';
SELECT 
    t.name AS Tablo_Adi,
    COUNT(c.column_id) AS Kolon_Sayisi
FROM sys.tables t
LEFT JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.type = 'U' AND t.is_ms_shipped = 0
GROUP BY t.name
ORDER BY t.name;
GO

PRINT '';
PRINT '=== TABLO DETAYLARI ===';
GO

-- Depots
IF OBJECT_ID('Depots', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Depots tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Depots;
END
ELSE
    PRINT '✗ Depots tablosu bulunamadı';
GO

-- Users
IF OBJECT_ID('Users', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Users tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Users;
END
ELSE
    PRINT '✗ Users tablosu bulunamadı';
GO

-- User_Depots
IF OBJECT_ID('User_Depots', 'U') IS NOT NULL
BEGIN
    PRINT '✓ User_Depots tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM User_Depots;
END
ELSE
    PRINT '✗ User_Depots tablosu bulunamadı';
GO

-- Territories
IF OBJECT_ID('Territories', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Territories tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Territories;
END
ELSE
    PRINT '✗ Territories tablosu bulunamadı';
GO

-- Dealers
IF OBJECT_ID('Dealers', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Dealers tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Dealers;
END
ELSE
    PRINT '✗ Dealers tablosu bulunamadı';
GO

-- POSM
IF OBJECT_ID('POSM', 'U') IS NOT NULL
BEGIN
    PRINT '✓ POSM tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM POSM;
END
ELSE
    PRINT '✗ POSM tablosu bulunamadı';
GO

-- Requests
IF OBJECT_ID('Requests', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Requests tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Requests;
END
ELSE
    PRINT '✗ Requests tablosu bulunamadı';
GO

-- Photos
IF OBJECT_ID('Photos', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Photos tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Photos;
END
ELSE
    PRINT '✗ Photos tablosu bulunamadı';
GO

-- Audit_Logs
IF OBJECT_ID('Audit_Logs', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Audit_Logs tablosu mevcut';
    SELECT COUNT(*) AS Kayit_Sayisi FROM Audit_Logs;
END
ELSE
    PRINT '✗ Audit_Logs tablosu bulunamadı';
GO

PRINT '';
PRINT '=== FOREIGN KEY KONTROLÜ ===';
GO

SELECT 
    fk.name AS ForeignKey_Adi,
    OBJECT_NAME(fk.parent_object_id) AS Tablo_Adi,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS Kolon_Adi,
    OBJECT_NAME(fk.referenced_object_id) AS Referans_Tablo,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS Referans_Kolon
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fc ON fk.object_id = fc.constraint_object_id
ORDER BY OBJECT_NAME(fk.parent_object_id), fk.name;
GO

PRINT '';
PRINT '=== INDEX KONTROLÜ ===';
GO

SELECT 
    OBJECT_NAME(i.object_id) AS Tablo_Adi,
    i.name AS Index_Adi,
    i.type_desc AS Index_Tipi,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS Kolonlar
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id IN (
    OBJECT_ID('Depots'),
    OBJECT_ID('Users'),
    OBJECT_ID('User_Depots'),
    OBJECT_ID('Territories'),
    OBJECT_ID('Dealers'),
    OBJECT_ID('POSM'),
    OBJECT_ID('Requests'),
    OBJECT_ID('Photos'),
    OBJECT_ID('Audit_Logs')
)
AND i.is_primary_key = 0
AND i.is_unique_constraint = 0
GROUP BY OBJECT_NAME(i.object_id), i.name, i.type_desc
ORDER BY Tablo_Adi, Index_Adi;
GO

PRINT '';
PRINT '=== ÖZET ===';
GO

DECLARE @TabloSayisi INT;
DECLARE @ToplamKayit INT;

SELECT @TabloSayisi = COUNT(*) 
FROM sys.tables 
WHERE type = 'U' AND is_ms_shipped = 0
AND name IN ('Depots', 'Users', 'User_Depots', 'Territories', 'Dealers', 'POSM', 'Requests', 'Photos', 'Audit_Logs');

SELECT @ToplamKayit = 
    (SELECT COUNT(*) FROM Depots) +
    (SELECT COUNT(*) FROM Users) +
    (SELECT COUNT(*) FROM User_Depots) +
    (SELECT COUNT(*) FROM Territories) +
    (SELECT COUNT(*) FROM Dealers) +
    (SELECT COUNT(*) FROM POSM) +
    (SELECT COUNT(*) FROM Requests) +
    (SELECT COUNT(*) FROM Photos) +
    (SELECT COUNT(*) FROM Audit_Logs);

PRINT 'Toplam Tablo Sayısı: ' + CAST(@TabloSayisi AS VARCHAR);
PRINT 'Toplam Kayıt Sayısı: ' + CAST(@ToplamKayit AS VARCHAR);

IF @TabloSayisi = 9
    PRINT '✓ Tüm tablolar başarıyla oluşturulmuş!';
ELSE
    PRINT '✗ Eksik tablo var! Beklenen: 9, Bulunan: ' + CAST(@TabloSayisi AS VARCHAR);
GO
