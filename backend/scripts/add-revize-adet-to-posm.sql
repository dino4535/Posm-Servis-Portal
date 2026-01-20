-- POSM tablosuna revize_adet kolonu ekle

USE POSM;
GO

-- revize_adet kolonu yoksa ekle
IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('POSM') 
    AND name = 'revize_adet'
)
BEGIN
    ALTER TABLE POSM 
    ADD revize_adet INT DEFAULT 0 NOT NULL;
    
    PRINT 'revize_adet kolonu eklendi';
END
ELSE
BEGIN
    PRINT 'revize_adet kolonu zaten mevcut';
END
GO

-- Mevcut kayıtlar için revize_adet değerini 0 yap
UPDATE POSM 
SET revize_adet = 0 
WHERE revize_adet IS NULL;
GO

PRINT 'POSM tablosu revize_adet kolonu ile güncellendi!';
GO
