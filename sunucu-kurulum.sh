#!/bin/bash

# POSM Teknik Servis Portalı - Sunucu Kurulum Script'i
# Bu script sunucuda ilk kurulum için kullanılır

set -e  # Hata durumunda dur

echo "=========================================="
echo "POSM Teknik Servis Portalı - Sunucu Kurulumu"
echo "=========================================="
echo ""

# 1. Sistem güncellemesi
echo "1. Sistem güncellemesi yapılıyor..."
sudo apt update
sudo apt upgrade -y
echo "✓ Sistem güncellendi"
echo ""

# 2. Gerekli paketlerin kurulumu
echo "2. Gerekli paketler kuruluyor..."
sudo apt install -y curl wget git
echo "✓ Paketler kuruldu"
echo ""

# 3. Docker kurulumu
echo "3. Docker kurulumu yapılıyor..."
if ! command -v docker &> /dev/null; then
    echo "Docker kuruluyor..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✓ Docker kuruldu"
else
    echo "✓ Docker zaten kurulu"
fi

# Docker Compose kurulumu
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose kuruluyor..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✓ Docker Compose kuruldu"
else
    echo "✓ Docker Compose zaten kurulu"
fi
echo ""

# 4. Proje klasörü oluştur
echo "4. Proje klasörü oluşturuluyor..."
PROJECT_DIR="$HOME/posm"
if [ ! -d "$PROJECT_DIR" ]; then
    mkdir -p "$PROJECT_DIR"
    echo "✓ Proje klasörü oluşturuldu: $PROJECT_DIR"
else
    echo "✓ Proje klasörü zaten var: $PROJECT_DIR"
fi
cd "$PROJECT_DIR"
echo ""

# 5. Git repository'yi klonla
echo "5. Git repository klonlanıyor..."
if [ ! -d ".git" ]; then
    git clone https://github.com/dino4535/Posm-Servis-Portal.git .
    git checkout project-docs
    echo "✓ Repository klonlandı"
else
    echo "✓ Repository zaten var, güncelleniyor..."
    git fetch origin
    git checkout project-docs
    git pull origin project-docs || true
fi
echo ""

# 6. .env dosyası oluştur
echo "6. .env dosyası oluşturuluyor..."
if [ ! -f ".env" ]; then
    cat > .env << 'EOF'
# Server Configuration
PORT=3005
NODE_ENV=development
FRONTEND_URL=http://localhost:4005,http://posm.dinogida.com.tr,https://posm.dinogida.com.tr

# Database Configuration
DB_SERVER=77.83.37.248
DB_DATABASE=POSM
DB_USER=POSM
DB_PASSWORD=@1B9j9K045
DB_PORT=1433
DB_ENCRYPT=false
DB_TRUST_SERVER_CERTIFICATE=false

# JWT Configuration
JWT_SECRET=z&P9#2kL!mQ5*vX8rT@uW4yB7nJ1^fG3hD6sK0pA9cE2iM5oZ8vR1xT4qU7
JWT_EXPIRES_IN=2d

# File Upload Configuration
MAX_FILE_SIZE=10485760
UPLOAD_PATH=./uploads

# Email Configuration (SMTP)
SMTP_HOST=mail.dinogida.com.tr
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=posm@dinogida.com.tr
SMTP_PASS=@DinO454535.
EMAIL_FROM=posm@dinogida.com.tr

# Frontend API URL
VITE_API_URL=/api
EOF
    echo "✓ .env dosyası oluşturuldu"
else
    echo "✓ .env dosyası zaten var"
fi
echo ""

# 7. Docker volume'ları kontrol et
echo "7. Docker volume'ları kontrol ediliyor..."
docker volume create posm_backend-node-modules 2>/dev/null || echo "Volume zaten var: posm_backend-node-modules"
docker volume create posm_frontend-node-modules 2>/dev/null || echo "Volume zaten var: posm_frontend-node-modules"

# posm_data volume'unun var olduğunu kontrol et
if docker volume inspect posm_data &>/dev/null; then
    echo "✓ posm_data volume bulundu"
else
    echo "⚠ UYARI: posm_data volume bulunamadı!"
    echo "Lütfen önce şu komutu çalıştırın:"
    echo "  docker volume create posm_data"
    exit 1
fi
echo "✓ Volume'lar hazır"
echo ""

# 8. Eski container'ları temizle
echo "8. Eski container'lar temizleniyor..."
docker-compose down 2>/dev/null || true
docker ps -a | grep posm | awk '{print $1}' | xargs -r docker rm -f 2>/dev/null || true
docker container prune -f 2>/dev/null || true
echo "✓ Temizlik tamamlandı"
echo ""

# 9. Container'ları build et ve başlat
echo "9. Container'lar build ediliyor ve başlatılıyor..."
docker-compose up -d --build
echo "✓ Container'lar başlatıldı"
echo ""

# 10. Container'ların başlamasını bekle
echo "10. Container'ların başlaması bekleniyor..."
sleep 15
echo ""

# 11. Durum kontrolü
echo "11. Container durumu kontrol ediliyor..."
docker-compose ps
echo ""

# 12. Health check
echo "12. Health check yapılıyor..."
sleep 5

BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3005/health || echo "000")
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4005 || echo "000")

echo ""
echo "=========================================="
echo "Kurulum Tamamlandı!"
echo "=========================================="
echo ""
echo "Container Durumu:"
docker-compose ps
echo ""
echo "Health Check Sonuçları:"
if [ "$BACKEND_HEALTH" = "200" ]; then
    echo "✓ Backend: http://localhost:3005/health - ÇALIŞIYOR"
else
    echo "✗ Backend: http://localhost:3005/health - HATA (HTTP: $BACKEND_HEALTH)"
fi

if [ "$FRONTEND_HEALTH" = "200" ] || [ "$FRONTEND_HEALTH" = "000" ]; then
    echo "✓ Frontend: http://localhost:4005 - ÇALIŞIYOR"
else
    echo "✗ Frontend: http://localhost:4005 - HATA (HTTP: $FRONTEND_HEALTH)"
fi

echo ""
echo "Docker Volume'ları:"
docker volume ls | grep posm
echo ""
echo "Logları görüntülemek için:"
echo "  docker-compose logs -f"
echo ""
echo "Nginx kurulumu için:"
echo "  chmod +x setup-nginx.sh"
echo "  ./setup-nginx.sh"
echo ""
echo "=========================================="
