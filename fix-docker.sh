#!/bin/bash

# Docker Compose Hatası Düzeltme Script'i
# KeyError: 'ContainerConfig' hatası için çözüm

set -e

echo "=========================================="
echo "Docker Compose Hatası Düzeltiliyor"
echo "=========================================="

# 1. Çalışan container'ları durdur
echo ""
echo "1. Çalışan container'lar durduruluyor..."
docker-compose down 2>/dev/null || true

# 2. Eski container'ları temizle
echo ""
echo "2. Eski container'lar temizleniyor..."
docker ps -a --filter "name=posm" --format "{{.ID}}" | xargs -r docker rm -f 2>/dev/null || true

# 3. Eski image'ları temizle (opsiyonel - dikkatli kullanın)
echo ""
echo "3. Eski image'lar kontrol ediliyor..."
# docker images --filter "reference=posm*" --format "{{.ID}}" | xargs -r docker rmi -f 2>/dev/null || true

# 4. Docker system prune (opsiyonel - dikkatli kullanın)
# echo ""
# echo "4. Docker system temizleniyor..."
# docker system prune -f

# 5. Volume'leri kontrol et ve gerekirse temizle
echo ""
echo "4. Volume'ler kontrol ediliyor..."
docker volume ls | grep posm || echo "Volume bulunamadı"

# 6. Docker Compose'u yeniden başlat
echo ""
echo "5. Container'lar yeniden build ediliyor ve başlatılıyor..."
docker-compose up -d --build --force-recreate

echo ""
echo "6. Container durumu kontrol ediliyor..."
sleep 5
docker-compose ps

echo ""
echo "=========================================="
echo "Düzeltme Tamamlandı!"
echo "=========================================="
echo ""
echo "Logları görüntülemek için:"
echo "  docker-compose logs -f"
echo ""
