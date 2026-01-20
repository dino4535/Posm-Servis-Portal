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

# 2. Eski container'ları temizle (daha agresif)
echo ""
echo "2. Eski container'lar temizleniyor..."
docker ps -a --filter "name=posm" --format "{{.ID}}" | while read id; do
  if [ ! -z "$id" ]; then
    echo "  Container siliniyor: $id"
    docker rm -f "$id" 2>/dev/null || true
  fi
done

# Tüm posm container'larını bul ve sil
docker ps -a | grep posm | awk '{print $1}' | xargs -r docker rm -f 2>/dev/null || true

# 3. Bozuk container referanslarını temizle
echo ""
echo "3. Bozuk container referansları temizleniyor..."
docker container prune -f 2>/dev/null || true

# 4. Volume'leri kontrol et
echo ""
echo "4. Volume'ler kontrol ediliyor..."
docker volume ls | grep posm || echo "Volume bulunamadı"

# 5. Docker Compose'u yeniden başlat (no-deps ile)
echo ""
echo "5. Container'lar yeniden build ediliyor ve başlatılıyor..."
docker-compose up -d --build --force-recreate --no-deps

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
