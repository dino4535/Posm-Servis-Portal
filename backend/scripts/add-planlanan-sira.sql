-- Requests tablosuna planlanan_sira: Aynı gün içindeki taleplerin görüntülenme sırası
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Requests') AND name = 'planlanan_sira')
BEGIN
    ALTER TABLE Requests ADD planlanan_sira INT NULL;
    PRINT 'planlanan_sira sütunu eklendi';
END
ELSE
    PRINT 'planlanan_sira zaten mevcut';
