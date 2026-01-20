#!/bin/bash

# POSM Teknik Servis Portalı - Otomatik Deploy Script
# Bu script sunucuda çalıştırıldığında projeyi ayağa kaldırır

set -e  # Hata durumunda dur

echo "=========================================="
echo "POSM Teknik Servis Portalı Deploy Başlatılıyor"
echo "=========================================="

# 1. .env dosyası oluştur
echo ""
echo "1. .env dosyası oluşturuluyor..."
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

# 2. Docker ve Docker Compose kontrolü
echo ""
echo "2. Docker kontrolü yapılıyor..."

if ! command -v docker &> /dev/null; then
    echo "Docker bulunamadı. Kurulum yapılıyor..."
    sudo apt update
    sudo apt install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "✓ Docker kuruldu"
else
    echo "✓ Docker zaten kurulu"
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose bulunamadı. Kurulum yapılıyor..."
    sudo apt install -y docker-compose
    echo "✓ Docker Compose kuruldu"
else
    echo "✓ Docker Compose zaten kurulu"
fi

# 3. Eski container'ları durdur (varsa)
echo ""
echo "3. Eski container'lar kontrol ediliyor..."
if [ "$(docker ps -aq -f name=posm-backend)" ] || [ "$(docker ps -aq -f name=posm-frontend)" ]; then
    echo "Eski container'lar durduruluyor..."
    docker-compose down 2>/dev/null || true
    echo "✓ Eski container'lar durduruldu"
else
    echo "✓ Eski container bulunamadı"
fi

# 4. Docker Compose ile build ve başlat
echo ""
echo "4. Container'lar build ediliyor ve başlatılıyor..."
docker-compose up -d --build

echo ""
echo "5. Container'ların başlaması bekleniyor..."
sleep 10

# 5. Container durumunu kontrol et
echo ""
echo "6. Container durumu kontrol ediliyor..."
docker-compose ps

# 6. Health check
echo ""
echo "7. Health check yapılıyor..."
sleep 5

BACKEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3005/health || echo "000")
FRONTEND_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:4005 || echo "000")

# 8. Nginx kurulumu (opsiyonel)
echo ""
echo "8. Nginx kurulumu kontrol ediliyor..."
if [ -f "setup-nginx.sh" ]; then
    echo "Nginx kurulum script'i bulundu."
    echo "Nginx'i yapılandırmak için şu komutu çalıştırın:"
    echo "  chmod +x setup-nginx.sh"
    echo "  ./setup-nginx.sh"
else
    echo "Nginx kurulum script'i bulunamadı."
fi

echo ""
echo "=========================================="
echo "Deploy Tamamlandı!"
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
echo "Logları görüntülemek için:"
echo "  docker-compose logs -f"
echo ""
echo "Container'ları durdurmak için:"
echo "  docker-compose down"
echo ""
echo "=========================================="
