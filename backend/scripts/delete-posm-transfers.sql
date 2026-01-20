-- POSM Transfer İşlemlerini Silme Script'i
-- DİKKAT: Bu script tüm POSM transfer kayıtlarını silecektir!

USE POSM;
GO

PRINT '==========================================';
PRINT 'POSM Transfer İşlemleri Siliniyor';
PRINT '==========================================';
PRINT '';

-- 1. Önce kayıt sayısını göster
IF OBJECT_ID('POSM_Transfers', 'U') IS NOT NULL
BEGIN
    DECLARE @TransferCount INT;
    SELECT @TransferCount = COUNT(*) FROM POSM_Transfers;
    PRINT 'Silinecek transfer kayıt sayısı: ' + CAST(@TransferCount AS VARCHAR);
    PRINT '';
    
    IF @TransferCount > 0
    BEGIN
        -- 2. Tüm POSM transfer kayıtlarını sil
        PRINT 'POSM transfer kayıtları siliniyor...';
        DELETE FROM POSM_Transfers;
        
        DECLARE @DeletedCount INT = @@ROWCOUNT;
        PRINT '✓ ' + CAST(@DeletedCount AS VARCHAR) + ' transfer kaydı silindi';
        PRINT '';
        
        -- 3. Sonuç kontrolü
        SELECT @TransferCount = COUNT(*) FROM POSM_Transfers;
        IF @TransferCount = 0
        BEGIN
            PRINT '✓ Tüm POSM transfer kayıtları başarıyla silindi';
        END
        ELSE
        BEGIN
            PRINT '✗ HATA: Hala ' + CAST(@TransferCount AS VARCHAR) + ' kayıt var!';
        END
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
PRINT 'İşlem Tamamlandı';
PRINT '==========================================';
GO
