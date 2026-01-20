-- POSM tablosundaki tüm UNIQUE constraint'leri kaldır ve (name, depot_id) için yeni constraint ekle

USE POSM;
GO

PRINT '=== Mevcut UNIQUE Constraint''leri Kaldırma ===';
GO

-- Tüm UNIQUE constraint'leri bul ve kaldır
DECLARE @ConstraintName NVARCHAR(200);
DECLARE @SQL NVARCHAR(MAX);

DECLARE constraint_cursor CURSOR FOR
SELECT DISTINCT kc.name
FROM sys.key_constraints kc
WHERE kc.parent_object_id = OBJECT_ID('POSM')
  AND kc.type = 'UQ'
  AND kc.name != 'UQ_POSM_Name_Depot'; -- Yeni constraint'i koru

OPEN constraint_cursor;
FETCH NEXT FROM constraint_cursor INTO @ConstraintName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER TABLE POSM DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    BEGIN TRY
        EXEC sp_executesql @SQL;
        PRINT 'UNIQUE constraint kaldırıldı: ' + @ConstraintName;
    END TRY
    BEGIN CATCH
        PRINT 'Constraint kaldırılamadı (hata): ' + @ConstraintName + ' - ' + ERROR_MESSAGE();
    END CATCH
    
    FETCH NEXT FROM constraint_cursor INTO @ConstraintName;
END

CLOSE constraint_cursor;
DEALLOCATE constraint_cursor;
GO

PRINT '';
PRINT '=== (name, depot_id) UNIQUE Constraint Ekleme ===';
GO

-- Şimdi (name, depot_id) kombinasyonu için UNIQUE constraint ekle
IF NOT EXISTS (
    SELECT 1 
    FROM sys.indexes 
    WHERE name = 'UQ_POSM_Name_Depot' 
    AND object_id = OBJECT_ID('POSM')
)
BEGIN
    CREATE UNIQUE INDEX UQ_POSM_Name_Depot 
    ON POSM(name, depot_id);
    PRINT 'UQ_POSM_Name_Depot UNIQUE constraint eklendi';
END
ELSE
BEGIN
    PRINT 'UQ_POSM_Name_Depot constraint zaten mevcut';
END
GO

PRINT '';
PRINT 'POSM tablosu constraint güncellemesi tamamlandı!';
GO
