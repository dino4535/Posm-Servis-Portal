# Docker Deployment Rehberi

## Sunucuda Docker Kurulumu

### Ön Gereksinimler

- Docker kurulu olmalı
- Docker Compose kurulu olmalı (veya `docker compose` komutu)

### Adım 1: Projeyi Sunucuya Yükleme

```bash
# Git ile clone edin veya dosyaları sunucuya kopyalayın
cd /var/www/posm  # veya istediğiniz klasör
```

### Adım 2: Environment Variables Dosyası Oluşturma

Proje root klasöründe `.env` dosyası oluşturun:

```env
# Server Configuration
PORT=3005
NODE_ENV=production
FRONTEND_URL=http://posm.dinogida.com.tr,https://posm.dinogida.com.tr

# Database Configuration
DB_SERVER=77.83.37.248
DB_DATABASE=POSM
DB_USER=POSM
DB_PASSWORD=@1B9j9K045
DB_PORT=1433
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=false

# JWT Configuration
JWT_SECRET=your-secret-key-here
JWT_EXPIRES_IN=2d

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads

# Email Configuration
SMTP_HOST=mail.dinogida.com.tr
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=posm@dinogida.com.tr
SMTP_PASS=@DinO454535.
EMAIL_FROM=posm@dinogida.com.tr

# Frontend API URL
VITE_API_URL=/api
```

### Adım 3: Docker Compose ile Deploy

```bash
# Proje root klasöründe
docker-compose up -d --build

# Logları görüntüle
docker-compose logs -f

# Container durumunu kontrol et
docker-compose ps
```

### Adım 4: Container'ları Kontrol Etme

```bash
# Container'ların çalıştığını kontrol et
docker ps

# Backend logları
docker logs posm-backend -f

# Frontend logları
docker logs posm-frontend -f
```

### Adım 5: Port Kontrolü

```bash
# Portların açık olduğunu kontrol et
netstat -tulpn | grep -E '3005|4005'

# veya
ss -tulpn | grep -E '3005|4005'
```

## Container Yönetimi

### Container'ları Durdurma

```bash
docker-compose down
```

### Container'ları Yeniden Başlatma

```bash
docker-compose restart
```

### Container'ları Güncelleme (Yeni Build)

```bash
docker-compose up -d --build
```

### Logları Görüntüleme

```bash
# Tüm loglar
docker-compose logs -f

# Sadece backend
docker-compose logs -f backend

# Sadece frontend
docker-compose logs -f frontend
```

### Volume Kontrolü

```bash
# Volume'leri listele
docker volume ls

# Volume içeriğini kontrol et
docker volume inspect posm_posm-backend-uploads
```

## Production Domain Yapılandırması

Container'lar çalıştıktan sonra, sunucuda Nginx reverse proxy kurulumu yapın:

```nginx
# /etc/nginx/sites-available/posm.dinogida.com.tr

server {
    listen 80;
    server_name posm.dinogida.com.tr;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name posm.dinogida.com.tr;

    ssl_certificate /etc/ssl/certs/posm.dinogida.com.tr.crt;
    ssl_certificate_key /etc/ssl/private/posm.dinogida.com.tr.key;

    location / {
        proxy_pass http://localhost:4005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /api {
        proxy_pass http://localhost:3005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Sorun Giderme

### Container Başlamıyor

```bash
# Logları kontrol et
docker-compose logs

# Container'ı manuel başlat
docker-compose up backend
```

### Port Çakışması

Eğer portlar kullanılıyorsa, `docker-compose.yml` dosyasındaki port mapping'leri değiştirin:

```yaml
ports:
  - "3006:3005"  # Backend için farklı port
  - "4006:80"    # Frontend için farklı port
```

### Database Bağlantı Hatası

- `.env` dosyasındaki database bilgilerini kontrol edin
- Container'ın database'e erişebildiğinden emin olun
- Firewall kurallarını kontrol edin

### CORS Hatası

- Backend `.env` dosyasında `FRONTEND_URL` değerini kontrol edin
- Production domain'lerinin eklendiğinden emin olun

## Otomatik Başlatma

Container'ların sistem başlangıcında otomatik başlaması için:

```bash
# Docker Compose servisini systemd'ye ekle (opsiyonel)
sudo systemctl enable docker
```

Docker Compose `restart: unless-stopped` ayarı ile container'lar otomatik olarak yeniden başlayacaktır.
