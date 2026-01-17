# Backend Loglarını Görüntüleme Kılavuzu

## 📋 Genel Bakış

Backend logları Docker container'ında `stdout`'a yazılıyor. Logları görmek için Docker komutlarını kullanmanız gerekiyor.

---

## 🖥️ Yerel Ortam (Docker Desktop)

### 1. Canlı Log Takibi (Önerilen)

```bash
# Tüm logları canlı olarak takip et
docker logs -f teknik_servis_api

# Son 100 satırı göster ve takip et
docker logs -f --tail 100 teknik_servis_api
```

### 2. Son N Satırı Göster

```bash
# Son 50 satır
docker logs --tail 50 teknik_servis_api

# Son 200 satır
docker logs --tail 200 teknik_servis_api
```

### 3. Belirli Tarih Aralığı

```bash
# Belirli bir zamandan sonraki loglar
docker logs --since 2024-01-01T00:00:00 teknik_servis_api

# Son 1 saatteki loglar
docker logs --since 1h teknik_servis_api

# Son 30 dakikadaki loglar
docker logs --since 30m teknik_servis_api
```

### 4. Docker Compose ile

```bash
# Proje dizininde
cd C:\Users\Oguz\.cursor\Proje1

# API loglarını takip et
docker compose logs -f api

# Son 100 satır + takip
docker compose logs -f --tail 100 api

# Tüm servislerin logları
docker compose logs -f
```

---

## 🌐 Sunucu (Ubuntu Server)

### 1. SSH ile Bağlanın

```bash
ssh root@77.83.37.247
# veya
ssh root@teknik.dinogida.com.tr
```

### 2. Canlı Log Takibi

```bash
# Production container'ı için
docker logs -f teknik_servis_api_prod

# Son 100 satır + takip
docker logs -f --tail 100 teknik_servis_api_prod
```

### 3. Docker Compose ile (Production)

```bash
# Proje dizinine gidin
cd /opt/teknik-servis

# API loglarını takip et
docker compose -f docker-compose.production.yml logs -f api

# Son 100 satır + takip
docker compose -f docker-compose.production.yml logs -f --tail 100 api
```

### 4. Logları Dosyaya Kaydet

```bash
# Logları dosyaya kaydet
docker logs teknik_servis_api_prod > backend_logs_$(date +%Y%m%d_%H%M%S).txt

# Canlı logları dosyaya kaydet (Ctrl+C ile durdur)
docker logs -f teknik_servis_api_prod | tee backend_logs_$(date +%Y%m%d_%H%M%S).txt
```

---

## 🔍 Log Seviyeleri

Backend'de kullanılan log seviyeleri:

- **INFO**: Genel bilgilendirme mesajları
- **WARNING**: Uyarılar (ör: rate limit aşıldı)
- **ERROR**: Hatalar (ör: database bağlantı hatası)
- **DEBUG**: Detaylı debug bilgileri (production'da genelde kapalı)

### Log Formatı

```
2024-01-15 10:30:45 - app.main - INFO - ✅ Scheduled tasks başlatıldı
2024-01-15 10:30:46 - app.api.routes_auth - INFO - Kullanıcı giriş yaptı: user@example.com
2024-01-15 10:31:00 - app.middleware.rate_limiter - WARNING - Rate limit exceeded for IP: 192.168.1.100
```

---

## 🛠️ Yararlı Komutlar

### Logları Filtreleme

```bash
# Sadece ERROR loglarını göster
docker logs teknik_servis_api 2>&1 | grep ERROR

# WARNING ve ERROR loglarını göster
docker logs teknik_servis_api 2>&1 | grep -E "(WARNING|ERROR)"

# Belirli bir kelimeyi içeren loglar
docker logs teknik_servis_api 2>&1 | grep "database"
```

### Log Boyutunu Kontrol Et

```bash
# Container log dosyasının boyutu
docker inspect teknik_servis_api | grep -i log

# Tüm logların toplam boyutu
docker system df -v
```

### Logları Temizle

```bash
# ⚠️ DİKKAT: Bu işlem tüm logları siler!
docker logs --details teknik_servis_api > /dev/null 2>&1

# Container'ı yeniden başlat (loglar sıfırlanır)
docker restart teknik_servis_api
```

---

## 📊 Log Analizi

### En Çok Hata Veren Endpoint'leri Bul

```bash
docker logs teknik_servis_api 2>&1 | grep ERROR | awk '{print $NF}' | sort | uniq -c | sort -rn
```

### Son 1 Saatteki Hataları Say

```bash
docker logs --since 1h teknik_servis_api 2>&1 | grep -c ERROR
```

### Belirli Bir Kullanıcının İşlemlerini Takip Et

```bash
docker logs -f teknik_servis_api 2>&1 | grep "user@example.com"
```

---

## 🔧 Log Seviyesini Değiştirme

Log seviyesini değiştirmek için `.env` dosyasına ekleyin:

```env
LOG_LEVEL=DEBUG  # DEBUG, INFO, WARNING, ERROR
```

Sonra container'ı yeniden başlatın:

```bash
docker compose restart api
# veya production'da
docker compose -f docker-compose.production.yml restart api
```

---

## 💡 İpuçları

1. **Canlı Takip**: Sorun giderirken `-f` parametresi ile canlı takip yapın
2. **Log Dosyası**: Önemli durumlarda logları dosyaya kaydedin
3. **Filtreleme**: `grep` ile ilgili logları filtreleyin
4. **Zaman Aralığı**: `--since` ile belirli zaman aralığındaki logları görün
5. **Log Rotation**: Production'da log rotation yapılandırması yapın (Docker daemon ayarları)

---

## 🚨 Sorun Giderme

### Loglar Görünmüyor

```bash
# Container çalışıyor mu?
docker ps | grep api

# Container durumu
docker inspect teknik_servis_api | grep -i status
```

### Çok Fazla Log Var

```bash
# Sadece son 50 satırı göster
docker logs --tail 50 teknik_servis_api

# Sadece hataları göster
docker logs teknik_servis_api 2>&1 | grep ERROR
```

### Loglar Çok Yavaş

```bash
# Belirli bir zaman aralığındaki logları göster
docker logs --since 10m teknik_servis_api
```

---

## 📝 Örnek Kullanım Senaryoları

### Senaryo 1: Canlı Hata Takibi

```bash
# Terminal 1: Canlı log takibi
docker logs -f teknik_servis_api_prod

# Terminal 2: Sadece hataları filtrele
docker logs -f teknik_servis_api_prod 2>&1 | grep ERROR
```

### Senaryo 2: Günlük Log Raporu

```bash
# Bugünkü logları dosyaya kaydet
docker logs --since 24h teknik_servis_api_prod > daily_logs_$(date +%Y%m%d).txt
```

### Senaryo 3: Belirli Bir İşlemi Takip Et

```bash
# Request ID'si ile logları filtrele
docker logs -f teknik_servis_api_prod 2>&1 | grep "request_id:123"
```

---

## ✅ Hızlı Referans

| Komut | Açıklama |
|-------|----------|
| `docker logs -f container_name` | Canlı log takibi |
| `docker logs --tail 100 container_name` | Son 100 satır |
| `docker logs --since 1h container_name` | Son 1 saatteki loglar |
| `docker compose logs -f api` | Docker Compose ile canlı takip |
| `docker logs container_name \| grep ERROR` | Sadece hataları göster |
