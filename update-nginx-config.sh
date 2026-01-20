#!/bin/bash

# Nginx yapılandırmasını güncelleme script'i

set -e

echo "=========================================="
echo "Nginx Yapılandırması Güncelleniyor"
echo "=========================================="
echo ""

# 1. Nginx yapılandırmasını kopyala
echo "1. Nginx yapılandırması kopyalanıyor..."
sudo cp nginx-posm.conf /etc/nginx/sites-available/posm.dinogida.com.tr

# 2. Symlink oluştur (yoksa)
echo ""
echo "2. Symlink kontrol ediliyor..."
if [ ! -L /etc/nginx/sites-enabled/posm.dinogida.com.tr ]; then
    sudo ln -s /etc/nginx/sites-available/posm.dinogida.com.tr /etc/nginx/sites-enabled/posm.dinogida.com.tr
    echo "✓ Symlink oluşturuldu"
else
    echo "✓ Symlink zaten mevcut"
fi

# 3. Default site'ı devre dışı bırak (varsa)
echo ""
echo "3. Default site kontrol ediliyor..."
if [ -L /etc/nginx/sites-enabled/default ]; then
    sudo rm /etc/nginx/sites-enabled/default
    echo "✓ Default site devre dışı bırakıldı"
else
    echo "✓ Default site zaten devre dışı"
fi

# 4. Nginx yapılandırmasını test et
echo ""
echo "4. Nginx yapılandırması test ediliyor..."
if sudo nginx -t; then
    echo "✓ Yapılandırma geçerli"
else
    echo "✗ Yapılandırma hatası!"
    exit 1
fi

# 5. Nginx'i yeniden yükle
echo ""
echo "5. Nginx yeniden yükleniyor..."
sudo systemctl reload nginx

# 6. Nginx durumunu kontrol et
echo ""
echo "6. Nginx durumu:"
sudo systemctl status nginx --no-pager | head -10

echo ""
echo "=========================================="
echo "Nginx Güncelleme Tamamlandı!"
echo "=========================================="
echo ""
echo "Yapılan değişiklikler:"
echo "  • client_max_body_size: 20M (dosya yükleme limiti)"
echo "  • client_body_buffer_size: 256k"
echo "  • Timeout değerleri: 300 saniye"
echo ""
echo "Test için:"
echo "  curl -I http://posm.dinogida.com.tr"
echo ""
