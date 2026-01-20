# Veritabanı Kurulum Talimatları

## Adım 1: Tabloları Sil (Eğer Varsa)

Eğer daha önce tablolar oluşturulmuşsa ve hata alıyorsanız, önce tüm tabloları silin:

```sql
-- backend/scripts/drop-all-tables.sql dosyasını çalıştırın
```

**DİKKAT:** Bu script tüm verileri silecektir!

## Adım 2: Tabloları Oluştur

```sql
-- backend/scripts/create-database.sql dosyasını çalıştırın
```

Veya daha güvenli versiyon:

```sql
-- backend/scripts/create-database-fixed.sql dosyasını çalıştırın
```

## Adım 3: Başlangıç Verilerini Ekle

```sql
-- backend/scripts/seed-data.sql dosyasını çalıştırın
```

Bu script:
- 3 depo oluşturur (DEPO1, DEPO2, DEPO3)
- Admin kullanıcı oluşturur (Email: admin@posm.com, Şifre: admin123)
- Admin kullanıcıya tüm depoları atar

## Sorun Giderme

### Foreign Key Hatası

Eğer "Foreign key references invalid table" hatası alıyorsanız:

1. Önce `drop-all-tables.sql` dosyasını çalıştırın
2. Sonra `create-database.sql` dosyasını çalıştırın

### İzin Hatası

Eğer `sys.tables` izin hatası alıyorsanız, script zaten `OBJECT_ID` kullanıyor, bu hatalar önemli değil. Tablolar oluşturulmuş olmalı.

### Tablolar Zaten Var Hatası

Script'ler `IF OBJECT_ID` kontrolü yapıyor, bu yüzden tablolar zaten varsa tekrar oluşturulmayacak. Eğer yeniden oluşturmak istiyorsanız, önce `drop-all-tables.sql` çalıştırın.
