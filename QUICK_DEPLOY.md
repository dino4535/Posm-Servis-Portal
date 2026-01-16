# 🚀 Hızlı Deployment Rehberi

## Sunucuda Çalıştırılacak Komutlar

### 1. Script'i Çalıştırılabilir Yapın

```bash
cd /opt/teknik-servis
chmod +x deploy_ubuntu_server.sh
```

### 2. Deployment Script'ini Çalıştırın

```bash
bash deploy_ubuntu_server.sh
```

Script otomatik olarak:
- ✅ Sistem güncellemesi yapar
- ✅ Docker kurar
- ✅ PostgreSQL 16 kurar ve yapılandırır
- ✅ Projeyi clone eder (zaten var, günceller)
- ✅ .env dosyası oluşturur
- ✅ PostgreSQL kullanıcı ve veritabanı oluşturur
- ✅ Backup restore eder (varsa)
- ✅ Docker Compose production dosyası oluşturur
- ✅ API ve Frontend container'larını başlatır
- ✅ Migration'ları çalıştırır
- ✅ Admin kullanıcı oluşturur

### 3. Servis Durumunu Kontrol Edin

```bash
# PostgreSQL durumu
sudo systemctl status postgresql

# Docker servisleri
docker compose -f docker-compose.prod.yml ps

# API logları
docker compose -f docker-compose.prod.yml logs -f api

# Frontend logları
docker compose -f docker-compose.prod.yml logs -f frontend
```

### 4. Test Edin

```bash
# API health check
curl http://localhost:8000/health

# Frontend
curl http://localhost
```

---

## 🔧 Sorun Giderme

### PostgreSQL Bağlantı Hatası

```bash
# PostgreSQL çalışıyor mu?
sudo systemctl status postgresql

# Kullanıcı yetkileri
sudo -u postgres psql -d teknik_servis -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO app;"
```

### Docker Container'ları Çalışmıyor

```bash
# Logları kontrol edin
docker compose -f docker-compose.prod.yml logs api

# Yeniden başlatın
docker compose -f docker-compose.prod.yml restart api
```

### Migration Hataları

```bash
# Migration durumu
docker compose -f docker-compose.prod.yml exec api alembic current

# Migration'ları çalıştırın
docker compose -f docker-compose.prod.yml exec api alembic upgrade head
```

---

## 📝 Önemli Notlar

1. **.env Dosyası**: Script çalıştıktan sonra şifreleri not edin!
2. **Backup**: Eğer backup dosyası varsa otomatik restore edilir
3. **Portlar**: 
   - Frontend: 80
   - API: 8000 (sadece localhost)
4. **PostgreSQL**: Sunucuda direkt kurulu, Docker'da değil
