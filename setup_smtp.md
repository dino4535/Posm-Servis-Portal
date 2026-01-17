# SMTP Mail Ayarları Kurulumu

## 📧 Sorun
Yeni talep oluşturulduğunda mail gitmiyor çünkü SMTP ayarları yapılandırılmamış.

## ✅ Çözüm

### 1. Sunucuda `.env` Dosyasını Düzenleyin

SSH ile sunucuya bağlanın:
```bash
ssh root@77.83.37.247
cd /opt/teknik-servis
nano .env
```

### 2. SMTP Ayarlarını Ekleyin

`.env` dosyasının sonuna şu satırları ekleyin:

```env
# SMTP Email Settings
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM=your_email@gmail.com
```

### 3. Gmail Kullanıyorsanız

Gmail için App Password oluşturmanız gerekir:

1. Google Hesabınıza giriş yapın
2. **Güvenlik** > **2 Adımlı Doğrulama** (açık olmalı)
3. **Uygulama şifreleri** > **Uygulama seçin** > **E-posta** > **Cihaz seçin** > **Oluştur**
4. Oluşturulan 16 haneli şifreyi kopyalayın
5. `.env` dosyasındaki `SMTP_PASSWORD` değerine yapıştırın

**Örnek:**
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=teknikservis@dinogida.com.tr
SMTP_PASSWORD=abcd efgh ijkl mnop
SMTP_FROM=teknikservis@dinogida.com.tr
```

### 4. Diğer SMTP Sağlayıcıları

#### Outlook/Hotmail
```env
SMTP_HOST=smtp-mail.outlook.com
SMTP_PORT=587
SMTP_USER=your_email@outlook.com
SMTP_PASSWORD=your_password
SMTP_FROM=your_email@outlook.com
```

#### Yandex
```env
SMTP_HOST=smtp.yandex.com
SMTP_PORT=465
SMTP_USER=your_email@yandex.com
SMTP_PASSWORD=your_password
SMTP_FROM=your_email@yandex.com
```

#### Özel SMTP Sunucusu
```env
SMTP_HOST=mail.yourdomain.com
SMTP_PORT=587
SMTP_USER=noreply@yourdomain.com
SMTP_PASSWORD=your_password
SMTP_FROM=noreply@yourdomain.com
```

### 5. API Container'ını Yeniden Başlatın

```bash
cd /opt/teknik-servis
docker compose -f docker-compose.prod.yml restart api
```

### 6. Logları Kontrol Edin

Mail gönderme durumunu kontrol etmek için:

```bash
docker logs -f teknik_servis_api
```

**Başarılı mail gönderimi:**
```
✅ Email başarıyla gönderildi: user@example.com
```

**SMTP ayarları yoksa:**
```
📧 [EMAIL - SMTP AYARLARI YOK] To: user@example.com, Subject: ...
SMTP ayarları .env dosyasında tanımlı değil. Mail gönderilmedi, sadece log'a yazıldı.
```

**Hata durumunda:**
```
❌ Email gönderme hatası: ...
```

## 🔍 Test Etme

1. Yeni bir talep oluşturun
2. Logları kontrol edin: `docker logs -f teknik_servis_api`
3. Mail kutusunu kontrol edin

## ⚠️ Önemli Notlar

- Gmail kullanıyorsanız **mutlaka App Password** kullanın, normal şifre çalışmaz
- SMTP ayarları yoksa mail gönderilmez, sadece log'a yazılır
- Port 587 (STARTTLS) veya 465 (SSL/TLS) kullanılabilir
- `.env` dosyasındaki değişiklikler için container'ı yeniden başlatmanız gerekir

## 🐛 Sorun Giderme

### Mail gitmiyor

1. `.env` dosyasında SMTP ayarlarının doğru olduğundan emin olun
2. Container'ı yeniden başlatın: `docker compose -f docker-compose.prod.yml restart api`
3. Logları kontrol edin: `docker logs -f teknik_servis_api`
4. Gmail kullanıyorsanız App Password kullandığınızdan emin olun

### "Authentication failed" hatası

- Gmail: App Password kullanın, normal şifre değil
- Şifre doğru mu kontrol edin
- 2 Adımlı Doğrulama açık mı kontrol edin (Gmail için)

### "Connection timeout" hatası

- SMTP_HOST doğru mu kontrol edin
- SMTP_PORT doğru mu kontrol edin
- Firewall SMTP portunu engelliyor mu kontrol edin
