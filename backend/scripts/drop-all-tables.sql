-- Tüm tabloları ve foreign key'leri sil
-- DİKKAT: Bu script tüm verileri silecektir!

USE POSM;
GO

-- Foreign key'leri sil
DECLARE @sql NVARCHAR(MAX) = '';

SELECT @sql += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
               ' DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE OBJECT_SCHEMA_NAME(parent_object_id) = 'dbo';

EXEC sp_executesql @sql;
PRINT 'Tüm foreign key''ler silindi';
GO

-- Tabloları sil (sırayla - bağımlılıklara göre)
IF OBJECT_ID('Photos', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Photos;
    PRINT 'Photos tablosu silindi';
END
GO

IF OBJECT_ID('Audit_Logs', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Audit_Logs;
    PRINT 'Audit_Logs tablosu silindi';
END
GO

IF OBJECT_ID('Requests', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Requests;
    PRINT 'Requests tablosu silindi';
END
GO

IF OBJECT_ID('POSM', 'U') IS NOT NULL 
BEGIN
    DROP TABLE POSM;
    PRINT 'POSM tablosu silindi';
END
GO

IF OBJECT_ID('Dealers', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Dealers;
    PRINT 'Dealers tablosu silindi';
END
GO

IF OBJECT_ID('Territories', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Territories;
    PRINT 'Territories tablosu silindi';
END
GO

IF OBJECT_ID('User_Depots', 'U') IS NOT NULL 
BEGIN
    DROP TABLE User_Depots;
    PRINT 'User_Depots tablosu silindi';
END
GO

IF OBJECT_ID('Users', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Users;
    PRINT 'Users tablosu silindi';
END
GO

IF OBJECT_ID('Depots', 'U') IS NOT NULL 
BEGIN
    DROP TABLE Depots;
    PRINT 'Depots tablosu silindi';
END
GO

PRINT 'Tüm tablolar başarıyla silindi!';
GO
