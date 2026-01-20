-- Tüm depolar için POSM'leri ekle
-- Her depo için aynı POSM listesi eklenecek

USE POSM;
GO

-- Önce mevcut depoları kontrol et
DECLARE @DepotCount INT;
SELECT @DepotCount = COUNT(*) FROM Depots WHERE is_active = 1;
PRINT 'Aktif depo sayısı: ' + CAST(@DepotCount AS NVARCHAR(10));
GO

-- POSM listesi
DECLARE @POSMList TABLE (
    name NVARCHAR(255)
);

INSERT INTO @POSMList (name) VALUES
('88X35 ATLAS'),
('100X35 ATLAS'),
('100X50 ATLAS'),
('130X35 ATLAS'),
('130X50 ATLAS'),
('Armada 90x35'),
('Armada 100x35'),
('Armada 100x50'),
('Armada 130x35'),
('Armada 130x50'),
('Armada 170x50'),
('Mini Atlas 88-100''lük'),
('Mini Atlas 130''luk'),
('AF 8''li'),
('Af 12''li'),
('INOVA 100x100/ 100x85'),
('Smart Unit'),
('Millenium'),
('MCOU'),
('LOCAL COU'),
('C4 COU'),
('PM Küçük'),
('PM Orta'),
('Pm Büyük'),
('Ezd Küçük'),
('Ezd Orta'),
('Ezd Büyük'),
('Arcadia'),
('Midway 12''li 100''lük'),
('Midway 130''luk'),
('Diğer');

-- Her depo için POSM'leri ekle
DECLARE @DepotId INT;
DECLARE @PosmName NVARCHAR(255);
DECLARE @InsertedCount INT = 0;
DECLARE @SkippedCount INT = 0;

DECLARE depot_cursor CURSOR FOR
SELECT id FROM Depots WHERE is_active = 1;

OPEN depot_cursor;
FETCH NEXT FROM depot_cursor INTO @DepotId;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE posm_cursor CURSOR FOR
    SELECT name FROM @POSMList;
    
    OPEN posm_cursor;
    FETCH NEXT FROM posm_cursor INTO @PosmName;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Bu depoda bu POSM zaten var mı kontrol et
        IF NOT EXISTS (
            SELECT 1 FROM POSM 
            WHERE name = @PosmName 
            AND depot_id = @DepotId
        )
        BEGIN
            INSERT INTO POSM (name, description, depot_id, hazir_adet, tamir_bekleyen, is_active)
            VALUES (@PosmName, NULL, @DepotId, 0, 0, 1);
            
            SET @InsertedCount = @InsertedCount + 1;
        END
        ELSE
        BEGIN
            SET @SkippedCount = @SkippedCount + 1;
        END
        
        FETCH NEXT FROM posm_cursor INTO @PosmName;
    END
    
    CLOSE posm_cursor;
    DEALLOCATE posm_cursor;
    
    FETCH NEXT FROM depot_cursor INTO @DepotId;
END

CLOSE depot_cursor;
DEALLOCATE depot_cursor;

PRINT 'İşlem tamamlandı!';
PRINT 'Eklenen POSM sayısı: ' + CAST(@InsertedCount AS NVARCHAR(10));
PRINT 'Atlanan POSM sayısı (zaten mevcut): ' + CAST(@SkippedCount AS NVARCHAR(10));
GO
