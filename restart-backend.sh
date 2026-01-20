#!/bin/bash

# Backend'i yeniden başlatma script'i

echo "=========================================="
echo "Backend Yeniden Başlatılıyor"
echo "=========================================="
echo ""

# 1. Backend container'ını durdur
echo "1. Backend container durduruluyor..."
docker-compose stop backend
echo ""

# 2. Backend container'ını sil
echo "2. Backend container siliniyor..."
docker-compose rm -f backend
echo ""

# 3. Backend'i yeniden build et ve başlat
echo "3. Backend yeniden build ediliyor ve başlatılıyor..."
docker-compose up -d --build --force-recreate backend
echo ""

# 4. 10 saniye bekle
echo "4. Backend'in başlaması bekleniyor (10 saniye)..."
sleep 10
echo ""

# 5. Container durumunu kontrol et
echo "5. Backend container durumu:"
docker-compose ps backend
echo ""

# 6. Logları göster
echo "6. Son 50 satır log:"
docker-compose logs --tail 50 backend
echo ""

# 7. Health check
echo "7. Health check:"
sleep 5
curl -s http://localhost:3005/health && echo "" || echo "Health check başarısız"
echo ""

echo "=========================================="
echo "İşlem Tamamlandı"
echo "=========================================="
