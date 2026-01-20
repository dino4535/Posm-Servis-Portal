-- Türkiye saati için SQL fonksiyonu
-- GETDATE() yerine GETTURKEYDATE() kullanılabilir

USE POSM;
GO

-- Eğer fonksiyon varsa sil
IF OBJECT_ID('dbo.GETTURKEYDATE', 'FN') IS NOT NULL
    DROP FUNCTION dbo.GETTURKEYDATE;
GO

-- Türkiye saati fonksiyonu (UTC+3)
CREATE FUNCTION dbo.GETTURKEYDATE()
RETURNS DATETIME2
AS
BEGIN
    -- UTC'ye 3 saat ekle (Türkiye saati)
    RETURN DATEADD(HOUR, 3, GETUTCDATE());
END;
GO

PRINT 'GETTURKEYDATE() fonksiyonu oluşturuldu';
GO
