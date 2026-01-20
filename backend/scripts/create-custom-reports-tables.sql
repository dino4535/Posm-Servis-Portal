-- Custom Reports ve Scheduled Reports Tabloları
-- MSSQL Server

USE POSM;
GO

-- 1. Report_Templates (Rapor Şablonları)
IF OBJECT_ID('Report_Templates', 'U') IS NULL
BEGIN
    CREATE TABLE Report_Templates (
        id INT PRIMARY KEY IDENTITY(1,1),
        name NVARCHAR(200) NOT NULL,
        description NVARCHAR(500),
        created_by INT NOT NULL,
        -- Rapor yapılandırması (JSON formatında)
        config NVARCHAR(MAX) NOT NULL, -- Pivot table config, columns, filters, vb.
        -- SQL sorgusu veya sorgu yapılandırması
        query_config NVARCHAR(MAX) NOT NULL, -- Tablo seçimi, join'ler, where conditions
        is_active BIT DEFAULT 1,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2,
        FOREIGN KEY (created_by) REFERENCES Users(id)
    );
    
    CREATE INDEX IX_Report_Templates_CreatedBy ON Report_Templates(created_by);
    CREATE INDEX IX_Report_Templates_IsActive ON Report_Templates(is_active);
    PRINT 'Report_Templates tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Report_Templates tablosu zaten mevcut';
END
GO

-- 2. Scheduled_Reports (Zamanlanmış Raporlar)
IF OBJECT_ID('Scheduled_Reports', 'U') IS NULL
BEGIN
    CREATE TABLE Scheduled_Reports (
        id INT PRIMARY KEY IDENTITY(1,1),
        report_template_id INT NOT NULL,
        name NVARCHAR(200) NOT NULL,
        description NVARCHAR(500),
        -- Zamanlama ayarları (JSON formatında)
        schedule_config NVARCHAR(MAX) NOT NULL, -- Gün, saat, tekrar tipi
        -- Alıcılar (JSON formatında - email listesi)
        recipients NVARCHAR(MAX) NOT NULL, -- Email adresleri
        -- Depo filtreleri (JSON formatında - hangi depolara gönderilecek)
        depot_filters NVARCHAR(MAX), -- Depo ID listesi
        is_active BIT DEFAULT 1,
        last_run_at DATETIME2,
        next_run_at DATETIME2,
        created_by INT NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2,
        FOREIGN KEY (report_template_id) REFERENCES Report_Templates(id) ON DELETE CASCADE,
        FOREIGN KEY (created_by) REFERENCES Users(id)
    );
    
    CREATE INDEX IX_Scheduled_Reports_Template ON Scheduled_Reports(report_template_id);
    CREATE INDEX IX_Scheduled_Reports_IsActive ON Scheduled_Reports(is_active);
    CREATE INDEX IX_Scheduled_Reports_NextRun ON Scheduled_Reports(next_run_at);
    PRINT 'Scheduled_Reports tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Scheduled_Reports tablosu zaten mevcut';
END
GO

-- 3. Report_Executions (Rapor Çalıştırma Geçmişi)
IF OBJECT_ID('Report_Executions', 'U') IS NULL
BEGIN
    CREATE TABLE Report_Executions (
        id INT PRIMARY KEY IDENTITY(1,1),
        report_template_id INT,
        scheduled_report_id INT,
        executed_by INT,
        execution_type NVARCHAR(20) NOT NULL, -- 'MANUAL', 'SCHEDULED'
        status NVARCHAR(20) NOT NULL, -- 'SUCCESS', 'FAILED', 'RUNNING'
        result_data NVARCHAR(MAX), -- Sonuç verisi (JSON veya CSV)
        error_message NVARCHAR(MAX),
        execution_time_ms INT,
        row_count INT,
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (report_template_id) REFERENCES Report_Templates(id) ON DELETE SET NULL,
        FOREIGN KEY (scheduled_report_id) REFERENCES Scheduled_Reports(id) ON DELETE SET NULL,
        FOREIGN KEY (executed_by) REFERENCES Users(id) ON DELETE SET NULL
    );
    
    CREATE INDEX IX_Report_Executions_Template ON Report_Executions(report_template_id);
    CREATE INDEX IX_Report_Executions_Scheduled ON Report_Executions(scheduled_report_id);
    CREATE INDEX IX_Report_Executions_CreatedAt ON Report_Executions(created_at);
    PRINT 'Report_Executions tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'Report_Executions tablosu zaten mevcut';
END
GO

PRINT 'Tüm custom report tabloları başarıyla oluşturuldu!';
GO
