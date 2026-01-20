#!/bin/bash

# Frontend container loglarını kontrol etme script'i

echo "=========================================="
echo "Frontend Container Logları"
echo "=========================================="
echo ""

# Frontend container'ının durumunu kontrol et
echo "1. Container durumu:"
docker ps -a | grep posm-frontend
echo ""

# Frontend loglarını göster
echo "2. Son 50 satır log:"
docker logs --tail 50 posm-frontend 2>&1
echo ""

# Container içinde process'leri kontrol et
echo "3. Container içindeki process'ler:"
docker exec posm-frontend ps aux 2>/dev/null || echo "Container çalışmıyor veya erişilemiyor"
echo ""

# Port kontrolü
echo "4. Port 4005 kontrolü:"
netstat -tuln | grep 4005 || ss -tuln | grep 4005 || echo "Port kontrol edilemedi"
echo ""

# Healthcheck durumu
echo "5. Healthcheck durumu:"
docker inspect posm-frontend --format='{{json .State.Health}}' 2>/dev/null | python3 -m json.tool 2>/dev/null || docker inspect posm-frontend --format='{{json .State.Health}}' 2>/dev/null
echo ""

echo "=========================================="
echo "Kontrol Tamamlandı"
echo "=========================================="
