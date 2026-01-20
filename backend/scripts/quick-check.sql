-- Hızlı Tablo Kontrolü
USE POSM;
GO

-- Tüm tabloları listele
SELECT 
    'Tablo: ' + t.name AS Bilgi,
    CASE 
        WHEN t.name IN ('Depots', 'Users', 'User_Depots', 'Territories', 'Dealers', 'POSM', 'Requests', 'Photos', 'Audit_Logs') 
        THEN '✓ VAR' 
        ELSE '? BİLİNMEYEN' 
    END AS Durum
FROM sys.tables t
WHERE t.type = 'U' AND t.is_ms_shipped = 0
ORDER BY t.name;
GO

-- Eksik tabloları kontrol et
PRINT '';
PRINT '=== EKSİK TABLOLAR ===';
IF OBJECT_ID('Depots', 'U') IS NULL PRINT '✗ Depots';
IF OBJECT_ID('Users', 'U') IS NULL PRINT '✗ Users';
IF OBJECT_ID('User_Depots', 'U') IS NULL PRINT '✗ User_Depots';
IF OBJECT_ID('Territories', 'U') IS NULL PRINT '✗ Territories';
IF OBJECT_ID('Dealers', 'U') IS NULL PRINT '✗ Dealers';
IF OBJECT_ID('POSM', 'U') IS NULL PRINT '✗ POSM';
IF OBJECT_ID('Requests', 'U') IS NULL PRINT '✗ Requests';
IF OBJECT_ID('Photos', 'U') IS NULL PRINT '✗ Photos';
IF OBJECT_ID('Audit_Logs', 'U') IS NULL PRINT '✗ Audit_Logs';
GO

-- Her tablonun kolon sayısını göster
PRINT '';
PRINT '=== TABLO YAPILARI ===';
SELECT 
    t.name AS Tablo,
    COUNT(c.column_id) AS Kolon_Sayisi,
    (SELECT COUNT(*) FROM sys.indexes WHERE object_id = t.object_id AND is_primary_key = 1) AS Primary_Key_Var,
    (SELECT COUNT(*) FROM sys.foreign_keys WHERE parent_object_id = t.object_id) AS Foreign_Key_Sayisi
FROM sys.tables t
LEFT JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.name IN ('Depots', 'Users', 'User_Depots', 'Territories', 'Dealers', 'POSM', 'Requests', 'Photos', 'Audit_Logs')
GROUP BY t.name, t.object_id
ORDER BY t.name;
GO
