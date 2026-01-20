-- POSM tablosundaki name UNIQUE constraint'ini kaldır
-- ve (name, depot_id) kombinasyonu için UNIQUE constraint ekle

USE POSM;
GO

-- Önce mevcut UNIQUE constraint'i bul ve kaldır
DECLARE @ConstraintName NVARCHAR(200);

SELECT @ConstraintName = kc.name
FROM sys.key_constraints kc
INNER JOIN sys.key_constraint_columns kcc ON kc.object_id = kcc.constraint_object_id
INNER JOIN sys.columns c ON kcc.parent_object_id = c.object_id AND kcc.parent_column_id = c.column_id
WHERE kc.type = 'UQ'
  AND kc.parent_object_id = OBJECT_ID('POSM')
  AND c.name = 'name'
  AND (
    -- Sadece name kolonunda UNIQUE constraint olanları bul (depot_id içermeyen)
    SELECT COUNT(*)
    FROM sys.key_constraint_columns kcc2
    WHERE kcc2.constraint_object_id = kc.object_id
  ) = 1;

IF @ConstraintName IS NOT NULL
BEGIN
    EXEC('ALTER TABLE POSM DROP CONSTRAINT ' + @ConstraintName);
    PRINT 'Mevcut name UNIQUE constraint kaldırıldı: ' + @ConstraintName;
END
ELSE
BEGIN
    PRINT 'name UNIQUE constraint bulunamadı (zaten kaldırılmış olabilir veya (name, depot_id) kombinasyonu olarak tanımlı)';
END
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

PRINT 'POSM tablosu constraint güncellemesi tamamlandı!';
GO
