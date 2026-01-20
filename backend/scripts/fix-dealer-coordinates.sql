-- Bayi tablosundaki address JSON'ından latitude ve longitude değerlerini çıkarıp ilgili kolonlara yaz
-- Önce address kolonundaki JSON'ı parse edip latitude ve longitude'u güncelle

UPDATE Dealers
SET 
    latitude = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            CAST(JSON_VALUE(address, '$.latitude') AS FLOAT)
        ELSE NULL
    END,
    longitude = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            CAST(JSON_VALUE(address, '$.longitude') AS FLOAT)
        ELSE NULL
    END,
    address = CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN
            JSON_VALUE(address, '$.address')
        ELSE address
    END
WHERE address IS NOT NULL 
  AND address LIKE '{%'
  AND (latitude IS NULL OR longitude IS NULL);

-- Sonuçları kontrol et
SELECT 
    id,
    code,
    name,
    address,
    latitude,
    longitude,
    CASE 
        WHEN address IS NOT NULL AND address LIKE '{%' THEN 'Hala JSON formatında'
        ELSE 'Düzeltildi'
    END as durum
FROM Dealers
WHERE address IS NOT NULL
ORDER BY id;
