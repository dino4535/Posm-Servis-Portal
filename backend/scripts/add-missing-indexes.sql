-- Eksik Index'leri Ekle
-- JOIN'lerde kullanılan foreign key'ler için performans iyileştirmesi

USE POSM;
GO

PRINT '=== EKSİK INDEX''LER EKLENİYOR ===';
GO

-- Requests tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_Territory' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_Territory ON Requests(territory_id);
    PRINT '✓ IX_Requests_Territory eklendi';
END
ELSE
    PRINT '✗ IX_Requests_Territory zaten mevcut';
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_Dealer' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_Dealer ON Requests(dealer_id);
    PRINT '✓ IX_Requests_Dealer eklendi';
END
ELSE
    PRINT '✗ IX_Requests_Dealer zaten mevcut';
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_CompletedBy' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_CompletedBy ON Requests(tamamlayan_user_id);
    PRINT '✓ IX_Requests_CompletedBy eklendi';
END
ELSE
    PRINT '✗ IX_Requests_CompletedBy zaten mevcut';
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_POSM' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_POSM ON Requests(posm_id);
    PRINT '✓ IX_Requests_POSM eklendi';
END
ELSE
    PRINT '✗ IX_Requests_POSM zaten mevcut';
GO

-- Composite index'ler (JOIN + WHERE kombinasyonları için)
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_Depot_Status' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_Depot_Status ON Requests(depot_id, durum);
    PRINT '✓ IX_Requests_Depot_Status eklendi';
END
ELSE
    PRINT '✗ IX_Requests_Depot_Status zaten mevcut';
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Requests_Territory_Dealer' AND object_id = OBJECT_ID('Requests'))
BEGIN
    CREATE INDEX IX_Requests_Territory_Dealer ON Requests(territory_id, dealer_id);
    PRINT '✓ IX_Requests_Territory_Dealer eklendi';
END
ELSE
    PRINT '✗ IX_Requests_Territory_Dealer zaten mevcut';
GO

-- Dealers tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Dealers_Name' AND object_id = OBJECT_ID('Dealers'))
BEGIN
    CREATE INDEX IX_Dealers_Name ON Dealers(name);
    PRINT '✓ IX_Dealers_Name eklendi';
END
ELSE
    PRINT '✗ IX_Dealers_Name zaten mevcut';
GO

-- Territories tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Territories_Name' AND object_id = OBJECT_ID('Territories'))
BEGIN
    CREATE INDEX IX_Territories_Name ON Territories(name);
    PRINT '✓ IX_Territories_Name eklendi';
END
ELSE
    PRINT '✗ IX_Territories_Name zaten mevcut';
GO

-- Depots tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Depots_Name' AND object_id = OBJECT_ID('Depots'))
BEGIN
    CREATE INDEX IX_Depots_Name ON Depots(name);
    PRINT '✓ IX_Depots_Name eklendi';
END
ELSE
    PRINT '✗ IX_Depots_Name zaten mevcut';
GO

-- Users tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Users_Name' AND object_id = OBJECT_ID('Users'))
BEGIN
    CREATE INDEX IX_Users_Name ON Users(name);
    PRINT '✓ IX_Users_Name eklendi';
END
ELSE
    PRINT '✗ IX_Users_Name zaten mevcut';
GO

-- POSM tablosu için eksik index'ler
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_POSM_Name' AND object_id = OBJECT_ID('POSM'))
BEGIN
    CREATE INDEX IX_POSM_Name ON POSM(name);
    PRINT '✓ IX_POSM_Name eklendi';
END
ELSE
    PRINT '✗ IX_POSM_Name zaten mevcut';
GO

PRINT '';
PRINT '=== MEVCUT INDEX''LER LİSTELENİYOR ===';
GO

SELECT 
    OBJECT_NAME(i.object_id) AS Tablo_Adi,
    i.name AS Index_Adi,
    i.type_desc AS Index_Tipi,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS Kolonlar,
    i.is_unique AS Benzersiz,
    i.fill_factor AS Doluluk_Orani
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
GROUP BY OBJECT_NAME(i.object_id), i.name, i.type_desc, i.is_unique, i.fill_factor
ORDER BY Tablo_Adi, Index_Adi;
GO

PRINT '';
PRINT '✓ Index ekleme işlemi tamamlandı!';
GO
