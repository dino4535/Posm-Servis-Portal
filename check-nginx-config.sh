#!/bin/bash

# Nginx yapılandırmasını kontrol etme script'i

echo "=========================================="
echo "Nginx Yapılandırması Kontrolü"
echo "=========================================="
echo ""

# 1. Mevcut Nginx yapılandırmasını kontrol et
echo "1. Nginx yapılandırma dosyası:"
if [ -f /etc/nginx/sites-available/posm.dinogida.com.tr ]; then
    echo "✓ Yapılandırma dosyası mevcut"
    echo ""
    echo "client_max_body_size ayarları:"
    grep -n "client_max_body_size" /etc/nginx/sites-available/posm.dinogida.com.tr || echo "  Bulunamadı"
else
    echo "✗ Yapılandırma dosyası bulunamadı"
fi
echo ""

# 2. Nginx ana yapılandırmasını kontrol et
echo "2. Nginx ana yapılandırması (/etc/nginx/nginx.conf):"
if [ -f /etc/nginx/nginx.conf ]; then
    echo "client_max_body_size ayarları:"
    grep -n "client_max_body_size" /etc/nginx/nginx.conf || echo "  Global limit yok (varsayılan 1M)"
else
    echo "✗ Ana yapılandırma dosyası bulunamadı"
fi
echo ""

# 3. Nginx durumu
echo "3. Nginx durumu:"
sudo systemctl status nginx --no-pager | head -5
echo ""

# 4. Yapılandırma testi
echo "4. Nginx yapılandırma testi:"
sudo nginx -t
echo ""

echo "=========================================="
echo "Kontrol Tamamlandı"
echo "=========================================="
echo ""
echo "Eğer client_max_body_size 50M değilse, şu komutu çalıştırın:"
echo "  sudo cp nginx-posm.conf /etc/nginx/sites-available/posm.dinogida.com.tr"
echo "  sudo nginx -t"
echo "  sudo systemctl reload nginx"
echo ""
