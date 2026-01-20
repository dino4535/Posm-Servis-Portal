# Docker ile Uygulamayı Başlatma

## Hızlı Başlangıç

### 1. Environment Dosyası Oluştur

Proje root klasöründe `.env` dosyası oluşturun:

```bash
nano .env
```

İçeriği:

```env
# Database
DB_SERVER=77.83.37.248
DB_DATABASE=POSM
DB_USER=POSM
DB_PASSWORD=@1B9j9K045
DB_PORT=1433
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=false

# JWT
JWT_SECRET=your-secret-key-here-change-this
JWT_EXPIRES_IN=2d

# Frontend
FRONTEND_URL=http://localhost:4005,http://posm.dinogida.com.tr
VITE_API_URL=/api

# Email (opsiyonel)
SMTP_HOST=mail.dinogida.com.tr
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=posm@dinogida.com.tr
SMTP_PASS=@DinO454535.
EMAIL_FROM=posm@dinogida.com.tr
```

### 2. Docker Compose ile Başlat

```bash
# Container'ları build et ve başlat
docker-compose up -d --build

# Logları görüntüle
docker-compose logs -f

# Sadece backend logları
docker-compose logs -f backend

# Sadece frontend logları
docker-compose logs -f frontend
```

### 3. Kontrol

- Backend: http://localhost:3005/health
- Frontend: http://localhost:4005

### 4. Durdurma

```bash
# Container'ları durdur
docker-compose down

# Container'ları durdur ve volume'leri sil
docker-compose down -v
```

## Önemli Notlar

- **Development Modu**: Container'lar `npm run dev` ile çalışır (hot reload aktif)
- **Volume Mounting**: Kaynak kodlar volume olarak mount edilir, değişiklikler anında yansır
- **Portlar**: Backend 3005, Frontend 4005
- **Environment**: `.env` dosyasındaki değişkenler container'lara aktarılır

## Sorun Giderme

### Container Başlamıyor

```bash
# Logları kontrol et
docker-compose logs

# Container'ı yeniden build et
docker-compose up -d --build --force-recreate
```

### Port Kullanımda

```bash
# Port'u kullanan process'i bul
sudo lsof -i :3005
sudo lsof -i :4005

# Process'i sonlandır
sudo kill -9 <PID>
```

### Veritabanı Bağlantı Hatası

- `.env` dosyasındaki database bilgilerini kontrol edin
- SQL Server'ın çalıştığından emin olun
- Firewall kurallarını kontrol edin
