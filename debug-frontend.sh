#!/bin/bash

# Frontend container debug script'i

echo "=========================================="
echo "Frontend Container Debug"
echo "=========================================="
echo ""

# 1. Container durumu
echo "1. Container durumu:"
docker ps -a | grep posm-frontend
echo ""

# 2. Container logları (son 100 satır)
echo "2. Container logları (son 100 satır):"
docker logs --tail 100 posm-frontend 2>&1
echo ""

# 3. Container içinde process kontrolü
echo "3. Container içindeki process'ler:"
if docker ps | grep -q posm-frontend; then
    docker exec posm-frontend ps aux 2>/dev/null || echo "Process kontrol edilemedi"
else
    echo "Container çalışmıyor"
fi
echo ""

# 4. Port kontrolü (host'tan)
echo "4. Port 4005 kontrolü (host):"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:4005 || echo "Port erişilemiyor"
echo ""

# 5. Container içinden port kontrolü
echo "5. Container içinden port kontrolü:"
if docker ps | grep -q posm-frontend; then
    docker exec posm-frontend wget -q -O- http://localhost:4005 2>&1 | head -20 || \
    docker exec posm-frontend curl -s http://localhost:4005 2>&1 | head -20 || \
    docker exec posm-frontend node -e "require('http').get('http://localhost:4005', (r) => {console.log('Status:', r.statusCode); r.on('data', () => {}); r.on('end', () => process.exit(0))}).on('error', (e) => {console.error('Error:', e.message); process.exit(1)})" 2>&1 || \
    echo "Port kontrol edilemedi"
else
    echo "Container çalışmıyor"
fi
echo ""

# 6. Healthcheck durumu
echo "6. Healthcheck durumu:"
docker inspect posm-frontend --format='{{json .State.Health}}' 2>/dev/null | python3 -m json.tool 2>/dev/null || \
docker inspect posm-frontend --format='Health: {{.State.Health.Status}}' 2>/dev/null || \
echo "Healthcheck bilgisi alınamadı"
echo ""

# 7. Environment variables
echo "7. Environment variables:"
docker inspect posm-frontend --format='{{range .Config.Env}}{{println .}}{{end}}' 2>/dev/null | grep -E "VITE|NODE|PORT" || echo "Environment variables alınamadı"
echo ""

# 8. Volume mounts
echo "8. Volume mounts:"
docker inspect posm-frontend --format='{{json .Mounts}}' 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "Volume bilgisi alınamadı"
echo ""

echo "=========================================="
echo "Debug Tamamlandı"
echo "=========================================="
echo ""
echo "Container'ı yeniden başlatmak için:"
echo "  docker-compose restart frontend"
echo ""
echo "Container'ı yeniden build etmek için:"
echo "  docker-compose up -d --build --force-recreate frontend"
echo ""
