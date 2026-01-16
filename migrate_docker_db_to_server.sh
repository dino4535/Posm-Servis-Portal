#!/bin/bash
# 📥 Docker Desktop PostgreSQL'den Sunucu Docker PostgreSQL'e Veri Taşıma
# Kullanım: 
#   1. Development makinede: bash migrate_docker_db_to_server.sh export
#   2. Sunucuda: bash migrate_docker_db_to_server.sh import

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

MODE=$1

if [ "$MODE" = "export" ]; then
    # Development makinede çalıştırılacak
    echo -e "${BLUE}📤 Docker Desktop PostgreSQL'den Dump Alma${NC}"
    echo "=================================================="
    
    # Docker container adını bul
    DB_CONTAINER=$(docker ps --filter "name=teknik_servis_db" --format "{{.Names}}" | head -1)
    
    if [ -z "$DB_CONTAINER" ]; then
        echo -e "${RED}❌ teknik_servis_db container'ı bulunamadı!${NC}"
        echo "Docker Desktop'ta container'ın çalıştığından emin olun."
        exit 1
    fi
    
    echo -e "${GREEN}✅ Container bulundu: $DB_CONTAINER${NC}"
    
    # Full dump al (schema + data + users + privileges)
    echo -e "${YELLOW}📥 Tüm veritabanı dump'ı alınıyor (schema + data + users)...${NC}"
    
    # 1. Schema ve Data dump
    docker exec $DB_CONTAINER pg_dump -U app -d teknik_servis --clean --if-exists > teknik_servis_full_dump.sql
    
    # 2. Globals dump (users, roles, etc.)
    docker exec $DB_CONTAINER pg_dumpall -U app -g > teknik_servis_globals.sql
    
    echo -e "${GREEN}✅ Dump dosyaları oluşturuldu:${NC}"
    echo "   - teknik_servis_full_dump.sql (schema + data)"
    echo "   - teknik_servis_globals.sql (users + roles)"
    
    # Dosya boyutlarını göster
    if [ -f "teknik_servis_full_dump.sql" ]; then
        SIZE=$(du -h teknik_servis_full_dump.sql | cut -f1)
        echo -e "${BLUE}   Full dump boyutu: $SIZE${NC}"
    fi
    
    echo ""
    echo -e "${YELLOW}📤 Şimdi bu dosyaları sunucuya kopyalayın:${NC}"
    echo "   scp teknik_servis_full_dump.sql user@server:/opt/teknik-servis/"
    echo "   scp teknik_servis_globals.sql user@server:/opt/teknik-servis/"

elif [ "$MODE" = "import" ]; then
    # Sunucuda çalıştırılacak
    echo -e "${BLUE}📥 Sunucu Docker PostgreSQL'e Restore${NC}"
    echo "=================================================="
    
    cd /opt/teknik-servis
    
    # .env dosyasından DB_USER'ı oku
    if [ ! -f ".env" ]; then
        echo -e "${RED}❌ .env dosyası bulunamadı!${NC}"
        exit 1
    fi
    
    DB_USER=$(grep "^DB_USER=" .env | cut -d '=' -f2)
    DB_NAME=$(grep "^DB_NAME=" .env | cut -d '=' -f2)
    
    if [ -z "$DB_USER" ] || [ -z "$DB_NAME" ]; then
        echo -e "${RED}❌ .env dosyasında DB_USER veya DB_NAME bulunamadı!${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✅ DB User: $DB_USER${NC}"
    echo -e "${GREEN}✅ DB Name: $DB_NAME${NC}"
    
    # Docker container kontrolü
    if ! docker compose -f docker-compose.prod.yml ps | grep -q "teknik_servis_db.*Up"; then
        echo -e "${RED}❌ PostgreSQL container çalışmıyor!${NC}"
        echo "Container'ı başlatın: docker compose -f docker-compose.prod.yml up -d db"
        exit 1
    fi
    
    echo -e "${GREEN}✅ PostgreSQL container çalışıyor${NC}"
    
    # Globals restore (users, roles) - önce bunu yapmalıyız
    if [ -f "teknik_servis_globals.sql" ]; then
        echo -e "${YELLOW}👤 Kullanıcılar ve roller restore ediliyor...${NC}"
        
        # Globals dosyasını düzenle (app kullanıcısı zaten var, sadece diğerlerini ekle)
        # CREATE USER komutlarını ALTER USER veya CREATE USER IF NOT EXISTS yap
        sed -i 's/^CREATE ROLE app;/-- CREATE ROLE app; (already exists)/' teknik_servis_globals.sql 2>/dev/null || true
        sed -i 's/^ALTER ROLE app;/-- ALTER ROLE app; (already exists)/' teknik_servis_globals.sql 2>/dev/null || true
        
        docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d postgres < teknik_servis_globals.sql 2>/dev/null || {
            echo -e "${YELLOW}⚠️  Globals restore'da bazı hatalar olabilir (normal, app kullanıcısı zaten var)${NC}"
        }
        
        echo -e "${GREEN}✅ Kullanıcılar restore edildi${NC}"
    else
        echo -e "${YELLOW}⚠️  teknik_servis_globals.sql bulunamadı, kullanıcı restore atlanıyor${NC}"
    fi
    
    # Full dump restore
    if [ -f "teknik_servis_full_dump.sql" ]; then
        echo -e "${YELLOW}📥 Veritabanı restore ediliyor (bu biraz zaman alabilir)...${NC}"
        
        docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME < teknik_servis_full_dump.sql
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Veritabanı restore edildi!${NC}"
        else
            echo -e "${RED}❌ Restore hatası!${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ teknik_servis_full_dump.sql bulunamadı!${NC}"
        exit 1
    fi
    
    # Yetkileri kontrol et ve düzelt
    echo -e "${YELLOW}🔐 Veritabanı yetkileri kontrol ediliyor...${NC}"
    
    docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME << EOF
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO $DB_USER;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO $DB_USER;
EOF
    
    echo -e "${GREEN}✅ Yetkiler güncellendi${NC}"
    
    # Veri kontrolü
    echo -e "${YELLOW}🔍 Veri kontrol ediliyor...${NC}"
    
    TABLE_COUNT=$(docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>/dev/null || echo "0")
    USER_COUNT=$(docker compose -f docker-compose.prod.yml exec -T db psql -U $DB_USER -d $DB_NAME -tAc "SELECT COUNT(*) FROM users;" 2>/dev/null || echo "0")
    
    echo -e "${GREEN}✅ Tablo sayısı: $TABLE_COUNT${NC}"
    if [ "$USER_COUNT" != "0" ]; then
        echo -e "${GREEN}✅ Kullanıcı sayısı: $USER_COUNT${NC}"
    fi
    
    echo ""
    echo -e "${BLUE}=================================================="
    echo -e "${GREEN}🎉 Veri Taşıma Tamamlandı!${NC}"
    echo -e "${BLUE}=================================================="
    echo ""
    echo -e "${GREEN}📋 Sonraki Adımlar:${NC}"
    echo "   1. Migration'ları kontrol edin: docker compose -f docker-compose.prod.yml exec api alembic current"
    echo "   2. Migration'ları çalıştırın: docker compose -f docker-compose.prod.yml exec api alembic upgrade head"
    echo "   3. API'yi test edin: curl http://localhost:8001/health"
    echo ""

else
    echo -e "${RED}❌ Geçersiz mod!${NC}"
    echo ""
    echo "Kullanım:"
    echo "  Development makinede: bash migrate_docker_db_to_server.sh export"
    echo "  Sunucuda: bash migrate_docker_db_to_server.sh import"
    exit 1
fi
