#!/bin/bash

# Docker Compose ContainerConfig hatası için temizleme script'i

echo "=========================================="
echo "Docker ContainerConfig Hatası Düzeltiliyor"
echo "=========================================="
echo ""

# 1. Tüm container'ları durdur
echo "1. Tüm container'lar durduruluyor..."
docker-compose down 2>/dev/null || true
docker stop $(docker ps -aq) 2>/dev/null || true
echo "✓ Container'lar durduruldu"
echo ""

# 2. Tüm posm container'larını sil
echo "2. Posm container'ları siliniyor..."
docker ps -a | grep posm | awk '{print $1}' | xargs -r docker rm -f 2>/dev/null || true
docker container prune -f
echo "✓ Container'lar silindi"
echo ""

# 3. Bozuk image metadata'sını temizle
echo "3. Bozuk image metadata temizleniyor..."
docker image prune -f
echo "✓ Image metadata temizlendi"
echo ""

# 4. Docker system temizliği (opsiyonel ama önerilir)
echo "4. Docker system temizliği yapılıyor..."
docker system prune -f --volumes
echo "✓ System temizliği tamamlandı"
echo ""

# 5. Yeniden build ve başlat
echo "5. Container'lar yeniden build ediliyor ve başlatılıyor..."
docker-compose up -d --build --force-recreate
echo "✓ Container'lar başlatıldı"
echo ""

# 6. Durum kontrolü
echo "6. Container durumu kontrol ediliyor..."
sleep 5
docker-compose ps
echo ""

echo "=========================================="
echo "İşlem Tamamlandı"
echo "=========================================="
echo ""
echo "Logları görüntülemek için:"
echo "  docker-compose logs -f"
echo ""
