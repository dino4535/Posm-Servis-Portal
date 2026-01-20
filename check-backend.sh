#!/bin/bash

# Backend container durumunu ve loglarını kontrol etme script'i

echo "=========================================="
echo "Backend Container Kontrolü"
echo "=========================================="
echo ""

# 1. Container durumu
echo "1. Backend container durumu:"
docker ps -a | grep posm-backend
echo ""

# 2. Backend logları (son 100 satır)
echo "2. Backend logları (son 100 satır):"
if docker ps -a | grep -q posm-backend; then
    docker logs --tail 100 posm-backend 2>&1
else
    echo "Backend container bulunamadı"
fi
echo ""

# 3. Port kontrolü
echo "3. Port 3005 kontrolü:"
echo "Host'tan:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:3005/health || echo "Port erişilemiyor"
echo ""

# 4. Container içi kontrol
echo "4. Container içi kontrol:"
if docker ps | grep -q posm-backend; then
    echo "Process'ler:"
    docker exec posm-backend ps aux 2>/dev/null || echo "Process kontrol edilemedi"
    echo ""
    echo "Port dinleme:"
    docker exec posm-backend netstat -tuln 2>/dev/null | grep 3005 || \
    docker exec posm-backend ss -tuln 2>/dev/null | grep 3005 || \
    echo "Port 3005 dinlenmiyor"
    echo ""
    echo "Node process:"
    docker exec posm-backend ps aux | grep node || echo "Node process bulunamadı"
else
    echo "Backend container çalışmıyor"
fi
echo ""

# 5. Healthcheck durumu
echo "5. Healthcheck durumu:"
docker inspect posm-backend --format='Health: {{.State.Health.Status}}' 2>/dev/null || echo "Healthcheck bilgisi alınamadı"
echo ""

# 6. Environment variables kontrolü
echo "6. Önemli environment variables:"
docker inspect posm-backend --format='{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null | grep -E "DB_|PORT|NODE" || echo "Environment variables alınamadı"
echo ""

# 7. Volume mounts kontrolü
echo "7. Volume mounts:"
docker inspect posm-backend --format='{{json .Mounts}}' 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "Volume bilgisi alınamadı"
echo ""

# 8. Network kontrolü
echo "8. Network bağlantısı:"
docker inspect posm-backend --format='Networks: {{range $k, $v := .NetworkSettings.Networks}}{{$k}} {{end}}' 2>/dev/null || echo "Network bilgisi alınamadı"
echo ""

echo "=========================================="
echo "Kontrol Tamamlandı"
echo "=========================================="
echo ""
echo "Backend'i yeniden başlatmak için:"
echo "  docker-compose restart backend"
echo ""
echo "Backend loglarını takip etmek için:"
echo "  docker-compose logs -f backend"
echo ""
