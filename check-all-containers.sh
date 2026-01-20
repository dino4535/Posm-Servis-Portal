#!/bin/bash

# Tüm container'ları kontrol etme script'i

echo "=========================================="
echo "Container Durum Kontrolü"
echo "=========================================="
echo ""

# 1. Docker Compose durumu
echo "1. Docker Compose durumu:"
docker-compose ps
echo ""

# 2. Tüm container'ların durumu
echo "2. Tüm POSM container'ları:"
docker ps -a | grep posm
echo ""

# 3. Backend logları (son 50 satır)
echo "3. Backend logları (son 50 satır):"
if docker ps -a | grep -q posm-backend; then
    docker logs --tail 50 posm-backend 2>&1
else
    echo "Backend container bulunamadı"
fi
echo ""

# 4. Frontend logları (son 50 satır)
echo "4. Frontend logları (son 50 satır):"
if docker ps -a | grep -q posm-frontend; then
    docker logs --tail 50 posm-frontend 2>&1
else
    echo "Frontend container bulunamadı"
fi
echo ""

# 5. Port kontrolü
echo "5. Port kontrolü:"
echo "Port 3005 (Backend):"
netstat -tuln | grep 3005 || ss -tuln | grep 3005 || echo "Port 3005 kullanılmıyor"
echo ""
echo "Port 4005 (Frontend):"
netstat -tuln | grep 4005 || ss -tuln | grep 4005 || echo "Port 4005 kullanılmıyor"
echo ""

# 6. Docker network kontrolü
echo "6. Docker network kontrolü:"
docker network ls | grep posm || echo "POSM network bulunamadı"
echo ""

# 7. Volume kontrolü
echo "7. Volume kontrolü:"
docker volume ls | grep posm || echo "POSM volume bulunamadı"
echo ""

# 8. Backend container içi kontrol
echo "8. Backend container içi kontrol:"
if docker ps | grep -q posm-backend; then
    echo "Process'ler:"
    docker exec posm-backend ps aux 2>/dev/null || echo "Process kontrol edilemedi"
    echo ""
    echo "Port dinleme:"
    docker exec posm-backend netstat -tuln 2>/dev/null || docker exec posm-backend ss -tuln 2>/dev/null || echo "Port kontrol edilemedi"
else
    echo "Backend container çalışmıyor"
fi
echo ""

# 9. Frontend container içi kontrol
echo "9. Frontend container içi kontrol:"
if docker ps | grep -q posm-frontend; then
    echo "Process'ler:"
    docker exec posm-frontend ps aux 2>/dev/null || echo "Process kontrol edilemedi"
    echo ""
    echo "Port dinleme:"
    docker exec posm-frontend netstat -tuln 2>/dev/null || docker exec posm-frontend ss -tuln 2>/dev/null || echo "Port kontrol edilemedi"
else
    echo "Frontend container çalışmıyor"
fi
echo ""

echo "=========================================="
echo "Kontrol Tamamlandı"
echo "=========================================="
echo ""
echo "Container'ları yeniden başlatmak için:"
echo "  docker-compose down"
echo "  docker-compose up -d --build"
echo ""
