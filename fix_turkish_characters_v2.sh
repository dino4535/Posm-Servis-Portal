#!/bin/bash
# 🔧 Türkçe Karakter Sorununu Düzeltme Scripti v2
# Development makineden UTF-8 dump alıp restore eder
# Kullanım: bash fix_turkish_characters_v2.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔧 Türkçe Karakter Sorununu Düzeltme (v2)${NC}"
echo "=================================================="
echo ""
echo -e "${YELLOW}⚠️  ÖNEMLİ: Bu script development makineden yeni bir dump bekliyor!${NC}"
echo ""

cd /opt/teknik-servis

# .env dosyasından bilgileri oku
DB_USER=$(grep "^DB_USER=" .env | cut -d '=' -f2)
DB_PASSWORD=$(grep "^DB_PASSWORD=" .env | cut -d '=' -f2)
DB_NAME=$(grep "^DB_NAME=" .env | cut -d '=' -f2)

# Dump dosyalarını kontrol et
if [ ! -f "teknik_servis_full_dump.sql" ]; then
    echo -e "${RED}❌ teknik_servis_full_dump.sql bulunamadı!${NC}"
    echo -e "${YELLOW}Lütfen development makineden yeni bir dump alın:${NC}"
    echo "  Windows: .\migrate_db_export.ps1"
    echo "  Sonra dosyayı sunucuya kopyalayın: scp teknik_servis_full_dump.sql root@server:/opt/teknik-servis/"
    exit 1
fi

echo -e "${GREEN}✅ Dump dosyası bulundu${NC}"

# 1. Mevcut veritabanından yedek al (güvenlik için)
echo -e "${YELLOW}📥 Mevcut veritabanından yedek alınıyor...${NC}"
docker compose -f docker-compose.prod.yml exec -T db pg_dump -U $DB_USER -d $DB_NAME --encoding=UTF8 > backup_before_fix_v2.sql
echo -e "${GREEN}✅ Yedek oluşturuldu: backup_before_fix_v2.sql${NC}"

# 2. Container'ları durdur
echo -e "${YELLOW}🛑 Container'lar durduruluyor...${NC}"
docker compose -f docker-compose.prod.yml down

# 3. Database volume'u sil
echo -e "${YELLOW}🗑️  Database volume siliniyor...${NC}"
docker volume rm teknik-servis_db_data_prod 2>/dev/null || true

# 4. Container'ları yeniden başlat
echo -e "${YELLOW}🚀 Container'lar yeniden başlatılıyor...${NC}"
docker compose -f docker-compose.prod.yml up -d db

# 5. PostgreSQL'in hazır olmasını bekle
echo -e "${YELLOW}⏳ PostgreSQL'in hazır olması bekleniyor...${NC}"
sleep 15

# 6. UTF-8 encoding ile veritabanı oluştur
echo -e "${YELLOW}📝 UTF-8 encoding ile veritabanı oluşturuluyor...${NC}"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d postgres << EOF
-- Eski veritabanını sil (eğer varsa)
DROP DATABASE IF EXISTS ${DB_NAME};

-- UTF-8 encoding ile yeni veritabanı oluştur
CREATE DATABASE ${DB_NAME}
    OWNER ${DB_USER}
    ENCODING 'UTF8'
    LC_COLLATE='C.UTF-8'
    LC_CTYPE='C.UTF-8'
    TEMPLATE template0;

-- Yetkileri ver
GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} TO ${DB_USER};
EOF

echo -e "${GREEN}✅ UTF-8 veritabanı oluşturuldu${NC}"

# 7. Client encoding'i UTF-8 yap ve dump'ı restore et
echo -e "${YELLOW}📥 Development makineden alınan dump restore ediliyor (UTF-8 encoding ile)...${NC}"

# Önce client encoding'i ayarla
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME << EOF
SET client_encoding = 'UTF8';
EOF

# Dump'ı restore et (UTF-8 encoding ile)
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME --set client_encoding=UTF8 < teknik_servis_full_dump.sql

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Dump restore edildi${NC}"
else
    echo -e "${RED}❌ Restore hatası!${NC}"
    exit 1
fi

# 8. Encoding'i kontrol et
echo -e "${YELLOW}🔍 Encoding kontrol ediliyor...${NC}"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -c "SHOW server_encoding;"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -c "SHOW client_encoding;"

# 9. Türkçe karakter testi
echo -e "${YELLOW}🧪 Türkçe karakter testi...${NC}"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -c "SELECT 'Türkçe test: ğşçıüöĞŞÇİÜÖ' as test;"

# 10. Kullanıcı adlarını kontrol et
echo -e "${YELLOW}👤 Kullanıcı adları kontrol ediliyor...${NC}"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -c "SELECT id, name, email FROM users;"

# 11. Audit log açıklamalarını kontrol et
echo -e "${YELLOW}📋 Audit log açıklamaları kontrol ediliyor...${NC}"
docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -c "SELECT id, description FROM audit_logs ORDER BY id DESC LIMIT 5;"

# 12. Tüm container'ları başlat
echo -e "${YELLOW}🚀 Tüm container'lar başlatılıyor...${NC}"
docker compose -f docker-compose.prod.yml up -d

# 13. Migration'ları çalıştır
echo -e "${YELLOW}🔄 Migration'lar kontrol ediliyor...${NC}"
sleep 5
docker compose -f docker-compose.prod.yml exec api alembic upgrade head 2>/dev/null || echo "Migration'lar zaten güncel"

echo ""
echo -e "${BLUE}=================================================="
echo -e "${GREEN}🎉 Türkçe Karakter Sorunu Düzeltildi!${NC}"
echo -e "${BLUE}=================================================="
echo ""
echo -e "${GREEN}📋 Sonraki Adımlar:${NC}"
echo "   1. Frontend'de kullanıcı adlarını kontrol edin"
echo "   2. Audit log'da Türkçe karakterleri kontrol edin"
echo "   3. Yeni kayıtların doğru encoding ile saklandığını test edin"
echo ""
