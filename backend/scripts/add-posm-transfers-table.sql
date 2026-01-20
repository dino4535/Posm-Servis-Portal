-- POSM_Transfers tablosu ekleme
IF OBJECT_ID('POSM_Transfers', 'U') IS NULL
BEGIN
    CREATE TABLE POSM_Transfers (
        id INT PRIMARY KEY IDENTITY(1,1),
        posm_id INT NOT NULL,
        from_depot_id INT NOT NULL,
        to_depot_id INT NOT NULL,
        quantity INT NOT NULL,
        transfer_type NVARCHAR(20) NOT NULL, -- 'Hazir', 'Tamir'
        status NVARCHAR(20) DEFAULT 'Beklemede', -- 'Beklemede', 'Onaylandi', 'Tamamlandi', 'Iptal'
        requested_by INT NOT NULL,
        approved_by INT,
        notes NVARCHAR(MAX),
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2,
        completed_at DATETIME2,
        FOREIGN KEY (posm_id) REFERENCES POSM(id),
        FOREIGN KEY (from_depot_id) REFERENCES Depots(id),
        FOREIGN KEY (to_depot_id) REFERENCES Depots(id),
        FOREIGN KEY (requested_by) REFERENCES Users(id),
        FOREIGN KEY (approved_by) REFERENCES Users(id),
        CHECK (from_depot_id != to_depot_id),
        CHECK (quantity > 0)
    );
    
    CREATE INDEX IX_POSM_Transfers_POSM ON POSM_Transfers(posm_id);
    CREATE INDEX IX_POSM_Transfers_FromDepot ON POSM_Transfers(from_depot_id);
    CREATE INDEX IX_POSM_Transfers_ToDepot ON POSM_Transfers(to_depot_id);
    CREATE INDEX IX_POSM_Transfers_Status ON POSM_Transfers(status);
    CREATE INDEX IX_POSM_Transfers_CreatedAt ON POSM_Transfers(created_at);
    
    PRINT 'POSM_Transfers tablosu oluşturuldu';
END
GO
