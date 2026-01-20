-- Eski POSM name UNIQUE constraint'ini kaldır
-- Constraint adı: UQ__POSM__72E12F1BB530CA3D

USE POSM;
GO

-- Constraint'i kaldır
IF EXISTS (
    SELECT 1 
    FROM sys.key_constraints 
    WHERE name = 'UQ__POSM__72E12F1BB530CA3D'
    AND parent_object_id = OBJECT_ID('POSM')
)
BEGIN
    ALTER TABLE POSM DROP CONSTRAINT UQ__POSM__72E12F1BB530CA3D;
    PRINT 'Eski UNIQUE constraint kaldırıldı: UQ__POSM__72E12F1BB530CA3D';
END
ELSE
BEGIN
    PRINT 'Constraint bulunamadı (zaten kaldırılmış olabilir)';
END
GO

-- Alternatif olarak, tüm name kolonundaki UNIQUE constraint'leri bul ve kaldır
DECLARE @ConstraintName NVARCHAR(200);
DECLARE @SQL NVARCHAR(MAX);

DECLARE constraint_cursor CURSOR FOR
SELECT DISTINCT kc.name
FROM sys.key_constraints kc
INNER JOIN sys.index_columns ic ON kc.parent_object_id = ic.object_id AND kc.unique_index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE kc.type = 'UQ'
  AND kc.parent_object_id = OBJECT_ID('POSM')
  AND c.name = 'name'
  AND (
    -- Sadece name kolonunda UNIQUE constraint olanları bul (depot_id içermeyen)
    SELECT COUNT(*)
    FROM sys.index_columns ic2
    WHERE ic2.object_id = kc.parent_object_id 
    AND ic2.index_id = kc.unique_index_id
  ) = 1;

OPEN constraint_cursor;
FETCH NEXT FROM constraint_cursor INTO @ConstraintName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'ALTER TABLE POSM DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    EXEC sp_executesql @SQL;
    PRINT 'UNIQUE constraint kaldırıldı: ' + @ConstraintName;
    
    FETCH NEXT FROM constraint_cursor INTO @ConstraintName;
END

CLOSE constraint_cursor;
DEALLOCATE constraint_cursor;
GO

PRINT 'Tüm eski UNIQUE constraint''ler kontrol edildi ve kaldırıldı!';
GO
