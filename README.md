# POSM Teknik Servis Portalı

Modern web teknolojileri ile geliştirilmiş Teknik Servis Portalı uygulaması.

## Teknoloji Stack

### Backend
- Node.js 20+ (LTS)
- Express.js 4.x
- TypeScript 5.x
- MSSQL Server
- JWT Authentication
- Multer (File Upload)

### Frontend
- React 18.x
- Vite 5.x
- TypeScript 5.x
- React Router 6.x
- FullCalendar
- Axios

## Kurulum

### Backend

```bash
cd backend
npm install
cp .env.example .env
# .env dosyasını düzenleyin
npm run dev
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## Veritabanı

MSSQL Server'da `backend/scripts/create-database.sql` dosyasını çalıştırarak veritabanı şemasını oluşturun.

## Özellikler

- ✅ Kullanıcı yönetimi (Admin, Teknik, User)
- ✅ Depo yönetimi (3 depo sistemi)
- ✅ Territory ve Bayi yönetimi
- ✅ POSM yönetimi ve stok takibi
- ✅ Talep yönetimi (CRUD, durum güncelleme)
- ✅ Fotoğraf yükleme
- ✅ Takvim görünümü
- ✅ Arama ve filtreleme
- ✅ Audit logging
- ✅ Responsive tasarım
- ✅ Modern UI (glass efektleri, animasyonlar)

## Lisans

ISC
