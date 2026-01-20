# POSM Teknik Servis Portalı

## Hızlı Başlangıç

### Yerel Geliştirme

#### Backend
```bash
cd backend
npm install
npm run dev
```

Backend: http://localhost:3005

#### Frontend
```bash
cd frontend
npm install
npm run dev
```

Frontend: http://localhost:4005

---

## Sunucuya Deploy

### Otomatik Deploy (Önerilen)

Sunucuda proje klasöründe:

```bash
# Script'i çalıştırılabilir yap
chmod +x deploy.sh

# Deploy script'ini çalıştır
./deploy.sh
```

Bu script otomatik olarak:
- `.env` dosyasını oluşturur
- Docker ve Docker Compose'u kurar (yoksa)
- Container'ları build eder ve başlatır
- Health check yapar

### Manuel Deploy

Detaylı bilgi için `DEPLOY.md` dosyasına bakın.

---

## Docker ile Çalıştırma

### Gereksinimler
- Docker
- Docker Compose

### Adımlar

1. **Environment dosyası oluştur**
   
   Proje root klasöründe `.env` dosyası oluşturun veya `deploy.sh` script'ini çalıştırın.

2. **Docker Compose ile başlat**
   
   ```bash
   docker-compose up -d --build
   ```

3. **Logları görüntüle**
   
   ```bash
   docker-compose logs -f
   ```

4. **Container'ları durdur**
   
   ```bash
   docker-compose down
   ```

### Portlar
- Backend: http://localhost:3005
- Frontend: http://localhost:4005

---

## Özellikler

- ✅ Kullanıcı yönetimi ve yetkilendirme
- ✅ Bayi (Dealer) yönetimi
- ✅ Bölge (Territory) yönetimi
- ✅ Depo (Depot) yönetimi
- ✅ Teknik servis talepleri
- ✅ POSM yönetimi ve transferleri
- ✅ Fotoğraf yükleme ve görüntüleme
- ✅ Raporlama ve özel rapor tasarımı
- ✅ Zamanlanmış raporlar
- ✅ Audit log

---

## Teknolojiler

### Backend
- Node.js + Express
- TypeScript
- SQL Server (MSSQL)
- JWT Authentication
- Multer (File Upload)

### Frontend
- React + TypeScript
- Vite
- React Router
- Axios

---

## Lisans

ISC
