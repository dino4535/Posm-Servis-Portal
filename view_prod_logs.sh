#!/bin/bash

# ============================================
# PRODUCTION BACKEND LOGLARINI GÖRÜNTÜLEME
# ============================================
# Bu script sunucuda production backend loglarını gösterir
# ============================================

echo "🔍 Production Backend Logları"
echo "================================"
echo ""

# Container adını kontrol et
CONTAINER_NAME="teknik_servis_api_prod"

# Container çalışıyor mu?
if ! docker ps | grep -q "$CONTAINER_NAME"; then
    echo "❌ Container çalışmıyor: $CONTAINER_NAME"
    echo ""
    echo "Çalışan container'ları görmek için:"
    echo "  docker ps"
    exit 1
fi

echo "✅ Container bulundu: $CONTAINER_NAME"
echo ""
echo "📋 Seçenekler:"
echo "  1) Canlı log takibi (önerilen)"
echo "  2) Son 100 satır"
echo "  3) Son 200 satır"
echo "  4) Son 1 saatteki loglar"
echo "  5) Sadece hatalar (ERROR)"
echo "  6) Hatalar ve uyarılar (ERROR, WARNING)"
echo "  7) Logları dosyaya kaydet"
echo "  8) Çıkış"
echo ""
read -p "Seçiminiz (1-8): " choice

case $choice in
    1)
        echo ""
        echo "🔄 Canlı log takibi başlatılıyor... (Ctrl+C ile çıkış)"
        echo ""
        docker logs -f "$CONTAINER_NAME"
        ;;
    2)
        echo ""
        echo "📄 Son 100 satır:"
        echo ""
        docker logs --tail 100 "$CONTAINER_NAME"
        ;;
    3)
        echo ""
        echo "📄 Son 200 satır:"
        echo ""
        docker logs --tail 200 "$CONTAINER_NAME"
        ;;
    4)
        echo ""
        echo "⏰ Son 1 saatteki loglar:"
        echo ""
        docker logs --since 1h "$CONTAINER_NAME"
        ;;
    5)
        echo ""
        echo "❌ Sadece hatalar:"
        echo ""
        docker logs "$CONTAINER_NAME" 2>&1 | grep ERROR
        ;;
    6)
        echo ""
        echo "⚠️ Hatalar ve uyarılar:"
        echo ""
        docker logs "$CONTAINER_NAME" 2>&1 | grep -E "(ERROR|WARNING)"
        ;;
    7)
        FILENAME="backend_logs_$(date +%Y%m%d_%H%M%S).txt"
        echo ""
        echo "💾 Loglar dosyaya kaydediliyor: $FILENAME"
        docker logs "$CONTAINER_NAME" > "$FILENAME" 2>&1
        echo "✅ Loglar kaydedildi: $FILENAME"
        echo "   Dosya boyutu: $(du -h "$FILENAME" | cut -f1)"
        ;;
    8)
        echo "👋 Çıkılıyor..."
        exit 0
        ;;
    *)
        echo "❌ Geçersiz seçim!"
        exit 1
        ;;
esac
