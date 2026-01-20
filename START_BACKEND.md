# Backend Başlatma Talimatları

## Sorun: ERR_CONNECTION_REFUSED

Backend sunucusu çalışmıyor. Aşağıdaki adımları izleyin:

## Adım 1: Backend Dizinine Gidin

```powershell
cd c:\Users\Oguz\.cursor\Proje1\backend
```

## Adım 2: Bağımlılıkları Kontrol Edin

```powershell
npm install
```

## Adım 3: Backend'i Başlatın

```powershell
npm run dev
```

## Beklenen Çıktı

Başarılı başlatma durumunda şunları görmelisiniz:

```
MSSQL Server bağlantısı başarılı
[INFO] Server 3002 portunda çalışıyor
```

## Hata Durumları ve Çözümler

### 1. Veritabanı Bağlantı Hatası

**Hata:** `MSSQL Server bağlantı hatası`

**Çözüm:**
- SQL Server'ın çalıştığından emin olun
- IP adresi: `77.83.37.248`
- Port: `1433`
- Veritabanı: `POSM`
- Kullanıcı: `POSM`
- Şifre: `@1B9j9K045`

### 2. Port Kullanımda Hatası

**Hata:** `EADDRINUSE: address already in use :::3002`

**Çözüm:**
```powershell
# Port'u kullanan process'i bulun
netstat -ano | findstr :3002

# Process'i sonlandırın (PID'yi yukarıdaki komuttan alın)
taskkill /PID <PID> /F
```

### 3. Modül Bulunamadı Hatası

**Hata:** `Cannot find module`

**Çözüm:**
```powershell
npm install
```

## Test

Backend başladıktan sonra tarayıcıda şu adresi açın:

```
http://localhost:3002/health
```

`{"status":"ok","timestamp":"..."}` yanıtı gelirse backend çalışıyordur.

## Frontend'i Başlatın

Backend çalıştıktan sonra, **ayrı bir terminalde** frontend'i başlatın:

```powershell
cd c:\Users\Oguz\.cursor\Proje1\frontend
npm run dev
```

Frontend: http://localhost:8001
