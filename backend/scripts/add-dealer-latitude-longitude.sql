-- Dealers tablosuna latitude ve longitude kolonlarını ekler.
-- Toplu bayi import ve tekil bayi create/update bu kolonları kullanır.
-- Eğer kolonlar zaten varsa çalıştırmak güvenlidir (hiçbir şey değişmez).

IF NOT EXISTS (
  SELECT 1 FROM sys.columns
  WHERE object_id = OBJECT_ID('Dealers') AND name = 'latitude'
)
BEGIN
  ALTER TABLE Dealers ADD latitude FLOAT NULL;
  PRINT 'Dealers.latitude eklendi';
END
ELSE
  PRINT 'Dealers.latitude zaten mevcut';
GO

IF NOT EXISTS (
  SELECT 1 FROM sys.columns
  WHERE object_id = OBJECT_ID('Dealers') AND name = 'longitude'
)
BEGIN
  ALTER TABLE Dealers ADD longitude FLOAT NULL;
  PRINT 'Dealers.longitude eklendi';
END
ELSE
  PRINT 'Dealers.longitude zaten mevcut';
GO
