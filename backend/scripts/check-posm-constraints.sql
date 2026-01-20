-- POSM tablosundaki tüm UNIQUE constraint'leri listele

USE POSM;
GO

PRINT '=== POSM Tablosundaki UNIQUE Constraint''ler ===';
GO

SELECT 
    kc.name AS ConstraintName,
    kc.type_desc AS ConstraintType,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS Columns
FROM sys.key_constraints kc
INNER JOIN sys.index_columns ic ON kc.parent_object_id = ic.object_id AND kc.unique_index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE kc.parent_object_id = OBJECT_ID('POSM')
  AND kc.type = 'UQ'
GROUP BY kc.name, kc.type_desc, kc.object_id
ORDER BY kc.name;
GO

PRINT '';
PRINT '=== POSM Tablosundaki Index''ler ===';
GO

SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique,
    STRING_AGG(c.name, ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS Columns
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('POSM')
  AND i.is_primary_key = 0
GROUP BY i.name, i.type_desc, i.is_unique
ORDER BY i.name;
GO
