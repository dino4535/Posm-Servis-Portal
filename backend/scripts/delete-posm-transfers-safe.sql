-- POSM Transfer İşlemlerini Güvenli Silme Script'i
-- Önce kayıtları gösterir, sonra onay ister

USE POSM;
GO

PRINT '==========================================';
PRINT 'POSM Transfer İşlemleri Kontrolü';
PRINT '==========================================';
PRINT '';

-- 1. Tablo var mı kontrol et
IF OBJECT_ID('POSM_Transfers', 'U') IS NOT NULL
BEGIN
    -- 2. Kayıt sayısını göster
    DECLARE @TransferCount INT;
    SELECT @TransferCount = COUNT(*) FROM POSM_Transfers;
    PRINT 'Mevcut transfer kayıt sayısı: ' + CAST(@TransferCount AS VARCHAR);
    PRINT '';
    
    IF @TransferCount > 0
    BEGIN
        -- 3. Kayıtları listele (ilk 10 kayıt)
        PRINT 'İlk 10 transfer kaydı:';
        SELECT TOP 10 
            id,
            posm_id,
            from_depot_id,
            to_depot_id,
            quantity,
            transfer_type,
            status,
            requested_by,
            created_at
        FROM POSM_Transfers
        ORDER BY created_at DESC;
        PRINT '';
        
        PRINT '==========================================';
        PRINT 'UYARI: Tüm transfer kayıtları silinecek!';
        PRINT '==========================================';
        PRINT '';
        PRINT 'Silmek için delete-posm-transfers.sql dosyasını çalıştırın.';
        PRINT 'VEYA aşağıdaki komutu manuel olarak çalıştırın:';
        PRINT '';
        PRINT 'DELETE FROM POSM_Transfers;';
        PRINT '';
    END
    ELSE
    BEGIN
        PRINT '✓ Zaten hiç transfer kaydı yok';
    END
END
ELSE
BEGIN
    PRINT '✗ POSM_Transfers tablosu bulunamadı';
END

PRINT '';
PRINT '==========================================';
PRINT 'Kontrol Tamamlandı';
PRINT '==========================================';
GO
