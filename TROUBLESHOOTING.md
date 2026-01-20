# Login Sorun Giderme

## Sorun: Login olamıyorum

### 1. Backend Çalışıyor mu?

Tarayıcıda veya Postman'de şu URL'yi test edin:
```
http://localhost:3002/health
```

**Beklenen Yanıt:**
```json
{
  "status": "ok",
  "timestamp": "2026-01-18T..."
}
```

Eğer hata alıyorsanız, backend çalışmıyor demektir.

### 2. Backend'i Başlatın

```powershell
cd c:\Users\Oguz\.cursor\Proje1\backend
npm run dev
```

**Beklenen Çıktı:**
```
MSSQL Server bağlantısı başarılı
[INFO] Server 3002 portunda çalışıyor
```

### 3. Login Endpoint'ini Test Edin

Tarayıcı Console'da (F12) şu komutu çalıştırın:

```javascript
fetch('http://localhost:3002/api/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    email: 'admin@posm.com',
    password: 'admin123'
  })
})
.then(r => r.json())
.then(console.log)
.catch(console.error);
```

### 4. CORS Sorunu

Eğer CORS hatası alıyorsanız, `backend/src/config/env.ts` dosyasında:
```typescript
cors: {
  origin: process.env.FRONTEND_URL || 'http://localhost:8001',
}
```

### 5. Şifre Kontrolü

Şifre doğru görünüyor (test edildi). Eğer hala login olamıyorsanız:

1. Backend loglarını kontrol edin
2. Browser Console'da hata mesajlarını kontrol edin
3. Network tab'ında login isteğini kontrol edin

### 6. Hızlı Test

Backend çalışıyorsa, şu komutu çalıştırın:
```powershell
cd c:\Users\Oguz\.cursor\Proje1\backend
npx tsx scripts/check-user-password.ts
```

Bu komut şifrenin doğru olup olmadığını kontrol eder.
