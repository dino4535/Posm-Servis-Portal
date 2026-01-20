#!/bin/bash

# Nginx Reverse Proxy Kurulum Script'i
# Bu script Nginx'i POSM uygulaması için reverse proxy olarak yapılandırır

set -e

echo "=========================================="
echo "Nginx Reverse Proxy Kurulumu Başlatılıyor"
echo "=========================================="

# 1. Nginx kurulu mu kontrol et
echo ""
echo "1. Nginx kontrolü yapılıyor..."

if ! command -v nginx &> /dev/null; then
    echo "Nginx bulunamadı. Kurulum yapılıyor..."
    sudo apt update
    sudo apt install -y nginx
    echo "✓ Nginx kuruldu"
else
    echo "✓ Nginx zaten kurulu"
fi

# 2. Nginx konfigürasyon dosyasını kopyala
echo ""
echo "2. Nginx konfigürasyonu yapılıyor..."

# Konfigürasyon dosyasını sites-available'a kopyala
sudo cp nginx-posm.conf /etc/nginx/sites-available/posm

# Symlink oluştur (sites-enabled'e)
if [ -L /etc/nginx/sites-enabled/posm ]; then
    echo "✓ Eski symlink kaldırılıyor..."
    sudo rm /etc/nginx/sites-enabled/posm
fi

sudo ln -s /etc/nginx/sites-available/posm /etc/nginx/sites-enabled/posm

# Varsayılan Nginx sayfasını devre dışı bırak (opsiyonel)
if [ -L /etc/nginx/sites-enabled/default ]; then
    echo "Varsayılan Nginx sayfası devre dışı bırakılıyor..."
    sudo rm /etc/nginx/sites-enabled/default
fi

echo "✓ Nginx konfigürasyonu kopyalandı"

# 3. Nginx konfigürasyonunu test et
echo ""
echo "3. Nginx konfigürasyonu test ediliyor..."

if sudo nginx -t; then
    echo "✓ Nginx konfigürasyonu geçerli"
else
    echo "✗ Nginx konfigürasyonu hatalı!"
    exit 1
fi

# 4. Nginx'i yeniden başlat
echo ""
echo "4. Nginx yeniden başlatılıyor..."

sudo systemctl restart nginx
sudo systemctl enable nginx

echo "✓ Nginx yeniden başlatıldı"

# 5. Nginx durumunu kontrol et
echo ""
echo "5. Nginx durumu kontrol ediliyor..."

if sudo systemctl is-active --quiet nginx; then
    echo "✓ Nginx çalışıyor"
else
    echo "✗ Nginx çalışmıyor!"
    exit 1
fi

# 6. Port kontrolü
echo ""
echo "6. Port kontrolü yapılıyor..."

if sudo netstat -tuln | grep -q ':80 '; then
    echo "✓ Port 80 dinleniyor"
else
    echo "⚠ Port 80 dinlenmiyor olabilir"
fi

echo ""
echo "=========================================="
echo "Nginx Kurulumu Tamamlandı!"
echo "=========================================="
echo ""
echo "Artık şu adresten erişebilirsiniz:"
echo "  http://posm.dinogida.com.tr"
echo ""
echo "Nginx durumunu kontrol etmek için:"
echo "  sudo systemctl status nginx"
echo ""
echo "Nginx loglarını görüntülemek için:"
echo "  sudo tail -f /var/log/nginx/error.log"
echo "  sudo tail -f /var/log/nginx/access.log"
echo ""
echo "=========================================="
