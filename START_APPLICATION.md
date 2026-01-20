# Uygulamayı Başlatma Talimatları

## Port Bilgileri
- **Backend**: http://localhost:3002
- **Frontend**: http://localhost:8001

## 1. Backend'i Başlat

Yeni bir terminal/PowerShell penceresi açın ve şu komutu çalıştırın:

```powershell
cd c:\Users\Oguz\.cursor\Proje1\backend
npm run dev
```

Backend başarıyla başladığında şu mesajı görmelisiniz:
```
MSSQL Server bağlantısı başarılı
[INFO] Server 3002 portunda çalışıyor
```

## 2. Frontend'i Başlat

Başka bir terminal/PowerShell penceresi açın ve şu komutu çalıştırın:

```powershell
cd c:\Users\Oguz\.cursor\Proje1\frontend
npm run dev
```

Frontend başarıyla başladığında şu mesajı görmelisiniz:
```
  VITE v5.x.x  ready in xxx ms

  ➜  Local:   http://localhost:8001/
```

## 3. Test Et

1. Tarayıcıda http://localhost:8001 adresine gidin
2. Login sayfasında şu bilgilerle giriş yapın:
   - **Email**: admin@posm.com
   - **Şifre**: admin123

## Sorun Giderme

### Backend başlamıyorsa:
- `cd backend` klasörüne gidin
- `npm install` çalıştırın (eğer node_modules yoksa)
- `npm run dev` komutunu tekrar deneyin
- Hata mesajlarını kontrol edin

### Frontend başlamıyorsa:
- `cd frontend` klasörüne gidin
- `npm install` çalıştırın (eğer node_modules yoksa)
- `npm run dev` komutunu tekrar deneyin

### Veritabanı bağlantı hatası:
- SQL Server'ın çalıştığından emin olun
- Firewall ayarlarını kontrol edin
- Veritabanı bilgilerini kontrol edin (backend/src/config/env.ts)
