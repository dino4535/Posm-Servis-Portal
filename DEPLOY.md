# Sunucuya Deploy Rehberi

## 1. Git'e Push Etme

### Yerel Makinede

```bash
# Git durumunu kontrol et
git status

# Değişiklikleri ekle
git add .

# Commit yap
git commit -m "Docker development modu için güncellemeler"

# Git'e push et
git push origin main
# veya
git push origin master
```

## 2. Sunucuda Projeyi Çekme

### Sunucuya SSH ile Bağlan

```bash
ssh kullanici@sunucu-ip
```

### Projeyi Clone/Update Et

**İlk kez kurulum:**
```bash
# Proje klasörüne git
cd /var/www  # veya istediğiniz klasör

# Projeyi clone et
git clone <repository-url> posm
cd posm
```

**Güncelleme:**
```bash
cd /var/www/posm  # veya proje klasörü
git pull origin main
```

## 3. Environment Dosyası Oluştur

```bash
# .env dosyası oluştur
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
JWT_SECRET=your-very-secret-key-change-this-in-production
JWT_EXPIRES_IN=2d

# Frontend
FRONTEND_URL=http://localhost:4005,http://posm.dinogida.com.tr,https://posm.dinogida.com.tr
VITE_API_URL=/api

# Email
SMTP_HOST=mail.dinogida.com.tr
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=posm@dinogida.com.tr
SMTP_PASS=@DinO454535.
EMAIL_FROM=posm@dinogida.com.tr

# File Upload
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads
```

## 4. Docker ile Başlatma

```bash
# Docker ve Docker Compose kurulu mu kontrol et
docker --version
docker-compose --version

# Kurulu değilse kur (Ubuntu/Debian)
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl enable docker
sudo systemctl start docker

# Docker Compose ile başlat
docker-compose up -d --build

# Logları görüntüle
docker-compose logs -f
```

## 5. Kontrol

```bash
# Container'ların çalıştığını kontrol et
docker-compose ps

# Backend sağlık kontrolü
curl http://localhost:3005/health

# Frontend kontrolü
curl http://localhost:4005
```

## 6. Nginx Reverse Proxy Kurulumu

### Otomatik Kurulum (Önerilen)

```bash
# Script'i çalıştırılabilir yap
chmod +x setup-nginx.sh

# Nginx'i yapılandır
./setup-nginx.sh
```

Bu script otomatik olarak:
- Nginx'i kurar (yoksa)
- Konfigürasyon dosyasını kopyalar
- Varsayılan Nginx sayfasını devre dışı bırakır
- Nginx'i yeniden başlatır

### Manuel Kurulum

Eğer manuel olarak yapılandırmak istiyorsanız:

```bash
sudo nano /etc/nginx/sites-available/posm
```

İçeriği:

```nginx
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

```bash
# Nginx konfigürasyonunu aktif et
sudo ln -s /etc/nginx/sites-available/posm /etc/nginx/sites-enabled/

# Nginx'i test et
sudo nginx -t

# Nginx'i yeniden başlat
sudo systemctl restart nginx
```

## 7. Güncelleme İşlemi

Kod güncellemesi yapıldığında:

```bash
# Sunucuda proje klasörüne git
cd /var/www/posm

# Git'ten güncellemeleri çek
git pull origin main

# Container'ları yeniden build et ve başlat
docker-compose up -d --build

# Logları kontrol et
docker-compose logs -f
```

## 8. Sorun Giderme

### Container Başlamıyor

```bash
# Logları kontrol et
docker-compose logs

# Container'ı yeniden build et
docker-compose down
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
- Container'ın network'ten database'e erişebildiğinden emin olun

### Git Pull Hatası

```bash
# Değişiklikleri zorla çek
git fetch origin
git reset --hard origin/main

# Veya stash yap
git stash
git pull origin main
git stash pop
```

## 9. Otomatik Güncelleme (Opsiyonel)

Git hook ile otomatik güncelleme için:

```bash
# Sunucuda .git/hooks/post-receive oluştur
nano /var/www/posm/.git/hooks/post-receive
```

İçeriği:

```bash
#!/bin/bash
cd /var/www/posm
git pull origin main
docker-compose up -d --build
```

```bash
# Çalıştırılabilir yap
chmod +x /var/www/posm/.git/hooks/post-receive
```
