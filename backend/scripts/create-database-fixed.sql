-- POSM Teknik Servis Portalı Veritabanı Şeması
-- MSSQL Server
-- Düzeltilmiş versiyon: Foreign key hatalarını önlemek için

USE POSM;
GO

-- Önce mevcut foreign key'leri ve tabloları temizle (opsiyonel - dikkatli kullanın!)
-- Bu kısım yorum satırına alındı, gerekirse açabilirsiniz
/*
-- Foreign key'leri sil
IF OBJECT_ID('FK__Photos__request_id', 'F') IS NOT NULL
    ALTER TABLE Photos DROP CONSTRAINT FK__Photos__request_id;
IF OBJECT_ID('FK__Photos__uploaded_by', 'F') IS NOT NULL
    ALTER TABLE Photos DROP CONSTRAINT FK__Photos__uploaded_by;
IF OBJECT_ID('FK__Requests__user_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__user_id;
IF OBJECT_ID('FK__Requests__depot_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__depot_id;
IF OBJECT_ID('FK__Requests__territory_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__territory_id;
IF OBJECT_ID('FK__Requests__dealer_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__dealer_id;
IF OBJECT_ID('FK__Requests__posm_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__posm_id;
IF OBJECT_ID('FK__Requests__tamamlayan_user_id', 'F') IS NOT NULL
    ALTER TABLE Requests DROP CONSTRAINT FK__Requests__tamamlayan_user_id;

-- Tabloları sil (sırayla)
IF OBJECT_ID('Photos', 'U') IS NOT NULL DROP TABLE Photos;
IF OBJECT_ID('Audit_Logs', 'U') IS NOT NULL DROP TABLE Audit_Logs;
IF OBJECT_ID('Requests', 'U') IS NOT NULL DROP TABLE Requests;
IF OBJECT_ID('POSM', 'U') IS NOT NULL DROP TABLE POSM;
IF OBJECT_ID('Dealers', 'U') IS NOT NULL DROP TABLE Dealers;
IF OBJECT_ID('Territories', 'U') IS NOT NULL DROP TABLE Territories;
IF OBJECT_ID('User_Depots', 'U') IS NOT NULL DROP TABLE User_Depots;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Depots', 'U') IS NOT NULL DROP TABLE Depots;
GO
*/

-- 1. Depots (Depolar)
IF OBJECT_ID('Depots', 'U') IS NULL
BEGIN
    CREATE TABLE Depots (
        id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        code NVARCHAR(50) UNIQUE NOT NULL,
        address NVARCHAR(500),
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2
    );
    PRINT 'Depots tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Depots tablosu zaten mevcut';
END
GO

-- 2. Users (Kullanıcılar)
IF OBJECT_ID('Users', 'U') IS NULL
BEGIN
    CREATE TABLE Users (
        id INT PRIMARY KEY IDENTITY(1,1),
        email NVARCHAR(255) UNIQUE NOT NULL,
        password_hash NVARCHAR(255) NOT NULL,
        name NVARCHAR(100) NOT NULL,
        role NVARCHAR(20) NOT NULL,
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2
    );
    
    CREATE INDEX IX_Users_Email ON Users(email);
    CREATE INDEX IX_Users_Role ON Users(role);
    PRINT 'Users tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Users tablosu zaten mevcut';
END
GO

-- 3. User_Depots (Kullanıcı-Depo İlişkisi)
IF OBJECT_ID('User_Depots', 'U') IS NULL
BEGIN
    CREATE TABLE User_Depots (
        id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        depot_id INT NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
        FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE,
        CONSTRAINT UQ_User_Depots UNIQUE(user_id, depot_id)
    );
    
    CREATE INDEX IX_User_Depots_User ON User_Depots(user_id);
    CREATE INDEX IX_User_Depots_Depot ON User_Depots(depot_id);
    PRINT 'User_Depots tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'User_Depots tablosu zaten mevcut';
END
GO

-- 4. Territories (Bölgeler)
IF OBJECT_ID('Territories', 'U') IS NULL
BEGIN
    CREATE TABLE Territories (
        id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) NOT NULL,
        code NVARCHAR(50) UNIQUE,
        depot_id INT NOT NULL,
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_Territories_Depot ON Territories(depot_id);
    PRINT 'Territories tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Territories tablosu zaten mevcut';
END
GO

-- 5. Dealers (Bayiler)
IF OBJECT_ID('Dealers', 'U') IS NULL
BEGIN
    CREATE TABLE Dealers (
        id INT PRIMARY KEY IDENTITY(1,1),
        code NVARCHAR(50) NOT NULL,
        name NVARCHAR(200) NOT NULL,
        territory_id INT,
        address NVARCHAR(500),
        phone NVARCHAR(50),
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (territory_id) REFERENCES Territories(id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Dealers_Territory ON Dealers(territory_id);
    CREATE INDEX IX_Dealers_Code ON Dealers(code);
    PRINT 'Dealers tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Dealers tablosu zaten mevcut';
END
GO

-- 6. POSM (Point of Sale Materials)
IF OBJECT_ID('POSM', 'U') IS NULL
BEGIN
    CREATE TABLE POSM (
        id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(100) UNIQUE NOT NULL,
        description NVARCHAR(500),
        depot_id INT NOT NULL,
        hazir_adet INT DEFAULT 0,
        tamir_bekleyen INT DEFAULT 0,
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2,
        FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_POSM_Depot ON POSM(depot_id);
    PRINT 'POSM tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'POSM tablosu zaten mevcut';
END
GO

-- 7. Requests (Talepler) - Dealers tablosundan sonra oluşturulmalı
IF OBJECT_ID('Requests', 'U') IS NULL
BEGIN
    CREATE TABLE Requests (
        id INT PRIMARY KEY IDENTITY(1,1),
        request_no NVARCHAR(50) UNIQUE NOT NULL,
        user_id INT NOT NULL,
        depot_id INT NOT NULL,
        territory_id INT NOT NULL,
        dealer_id INT NOT NULL,
        yapilacak_is NVARCHAR(50) NOT NULL,
        yapilacak_is_detay NVARCHAR(MAX),
        istenen_tarih DATE NOT NULL,
        planlanan_tarih DATE,
        tamamlanma_tarihi DATE,
        tamamlayan_user_id INT,
        posm_id INT,
        durum NVARCHAR(20) DEFAULT 'Beklemede',
        priority INT DEFAULT 0,
        notes NVARCHAR(MAX),
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2,
        FOREIGN KEY (user_id) REFERENCES Users(id),
        FOREIGN KEY (depot_id) REFERENCES Depots(id),
        FOREIGN KEY (territory_id) REFERENCES Territories(id),
        FOREIGN KEY (dealer_id) REFERENCES Dealers(id),
        FOREIGN KEY (posm_id) REFERENCES POSM(id),
        FOREIGN KEY (tamamlayan_user_id) REFERENCES Users(id)
    );
    
    CREATE INDEX IX_Requests_User ON Requests(user_id);
    CREATE INDEX IX_Requests_Depot ON Requests(depot_id);
    CREATE INDEX IX_Requests_Status ON Requests(durum);
    CREATE INDEX IX_Requests_PlannedDate ON Requests(planlanan_tarih);
    CREATE INDEX IX_Requests_RequestNo ON Requests(request_no);
    PRINT 'Requests tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Requests tablosu zaten mevcut';
END
GO

-- 8. Photos (Fotoğraflar) - Requests tablosundan sonra oluşturulmalı
IF OBJECT_ID('Photos', 'U') IS NULL
BEGIN
    CREATE TABLE Photos (
        id INT PRIMARY KEY IDENTITY(1,1),
        request_id INT NOT NULL,
        file_name NVARCHAR(255) NOT NULL,
        file_path NVARCHAR(500) NOT NULL,
        file_size BIGINT,
        mime_type NVARCHAR(100),
        uploaded_by INT,
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (request_id) REFERENCES Requests(id) ON DELETE CASCADE,
        FOREIGN KEY (uploaded_by) REFERENCES Users(id)
    );
    
    CREATE INDEX IX_Photos_Request ON Photos(request_id);
    PRINT 'Photos tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Photos tablosu zaten mevcut';
END
GO

-- 9. Audit_Logs (Denetim Kayıtları)
IF OBJECT_ID('Audit_Logs', 'U') IS NULL
BEGIN
    CREATE TABLE Audit_Logs (
        id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT,
        action NVARCHAR(50) NOT NULL,
        entity_type NVARCHAR(50),
        entity_id INT,
        old_values NVARCHAR(MAX),
        new_values NVARCHAR(MAX),
        ip_address NVARCHAR(50),
        user_agent NVARCHAR(500),
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES Users(id)
    );
    
    CREATE INDEX IX_Audit_Logs_User ON Audit_Logs(user_id);
    CREATE INDEX IX_Audit_Logs_CreatedAt ON Audit_Logs(created_at);
    CREATE INDEX IX_Audit_Logs_Entity ON Audit_Logs(entity_type, entity_id);
    PRINT 'Audit_Logs tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Audit_Logs tablosu zaten mevcut';
END
GO

PRINT 'Tüm tablolar başarıyla kontrol edildi/oluşturuldu!';
GO
