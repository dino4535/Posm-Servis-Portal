#!/bin/bash

# Backend'i zorla yeniden başlatma script'i (ContainerConfig hatası için)

set -e

echo "=========================================="
echo "Backend Zorla Yeniden Başlatılıyor"
echo "=========================================="

# 1. Backend container'ını durdur ve sil
echo ""
echo "1. Backend container durduruluyor ve siliniyor..."
docker-compose stop backend 2>/dev/null || true
docker-compose rm -f backend 2>/dev/null || true

# 2. Eski backend container'larını bul ve sil
echo ""
echo "2. Eski backend container'ları temizleniyor..."
docker ps -a | grep posm-backend | awk '{print $1}' | while read id; do
  if [ ! -z "$id" ]; then
    echo "  Container siliniyor: $id"
    docker rm -f "$id" 2>/dev/null || true
  fi
done

# 3. Bozuk container referanslarını temizle
echo ""
echo "3. Bozuk container referansları temizleniyor..."
docker container prune -f 2>/dev/null || true

# 4. Backend'i yeniden build et ve başlat
echo ""
echo "4. Backend yeniden build ediliyor ve başlatılıyor..."
docker-compose build --no-cache backend
docker-compose up -d --force-recreate --no-deps backend

# 5. Bekle ve kontrol et
echo ""
echo "5. Backend'in başlaması bekleniyor (10 saniye)..."
sleep 10

# 6. Container durumunu kontrol et
echo ""
echo "6. Backend container durumu:"
docker-compose ps backend

# 7. Logları göster
echo ""
echo "7. Son 50 satır log:"
docker-compose logs --tail 50 backend

# 8. Health check
echo ""
echo "8. Health check:"
sleep 5
curl -s http://localhost:3005/health && echo "" || echo "Health check başarısız (henüz başlamamış olabilir)"

echo ""
echo "=========================================="
echo "İşlem Tamamlandı"
echo "=========================================="
