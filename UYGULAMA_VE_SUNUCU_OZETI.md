# POSM Uygulaması ve Sunucu Yapısı – Özet

Bu dosya, uygulama mimarisi, sunucudaki kurulum (nginx dahil) ve geçmişte yapılan başlıca işlemleri tek yerde toplar.

---

## 1. Sunucu mimarisi (nginx nerede?)

**Evet, nginx sunucuya direkt kuruluyor** — Docker içinde değil, host üzerinde.

| Bileşen | Nerede çalışıyor | Port / Adres |
|--------|-------------------|---------------|
| **Nginx** | Sunucu (host), `systemctl` ile | 80 (ve istenirse 443) |
| **Frontend** | Docker container | Host’tan `localhost:4005` |
| **Backend** | Docker container | Host’tan `localhost:3005` |

Akış:

1. İstek **posm.dinogida.com.tr** (port 80) → **Nginx** (host) alır.
2. Nginx:
   - `location /` → **http://localhost:4005** (frontend container)
   - `location /api` → **http://localhost:3005** (backend container)
   - `location /health` → **http://localhost:3005/health**

Yani nginx, host’ta kurulu reverse proxy; uygulama ise Docker’da (frontend 4005, backend 3005) çalışıyor.

---

## 2. Nginx ile ilgili dosyalar

| Dosya | Açıklama |
|-------|----------|
| **nginx-posm.conf** | Nginx site konfigürasyonu (proxy, WebSocket header’ları, limitler). Bu dosya sunucuya kopyalanıp kullanılıyor. |
| **setup-nginx.sh** | İlk kurulum: nginx yoksa `apt install nginx`, config’i `/etc/nginx/sites-available/posm` olarak kopyalar, `sites-enabled`’a symlink, `systemctl restart nginx`. |
| **update-nginx-config.sh** | Güncelleme: `nginx-posm.conf` → `/etc/nginx/sites-available/posm.dinogida.com.tr`, `nginx -t`, `systemctl reload nginx`. |
| **check-nginx-config.sh** | Mevcut nginx konfigürasyonunu ve durumunu kontrol eder. |
| **frontend/nginx.conf** | Farklı bir senaryo içindir (container içinde nginx + statik build). Şu an sunucuda kullanılan “host nginx + Docker” yapısı bu dosyayı kullanmıyor. |

Dikkat: `setup-nginx.sh` config’i **posm** adıyla, `update-nginx-config.sh` **posm.dinogida.com.tr** adıyla kopyalar. İkisi de aynı `nginx-posm.conf` içeriğini kullanır; sadece sites-available’daki dosya adı farklıdır. Sunucuda hangi isimle kurulduysa güncelleme ve kontrollerde o isim kullanılmalı.

---

## 3. Sunucuda tipik kurulum sırası (ilk kez)

1. **sunucu-kurulum.sh**  
   Sistem güncellemesi, Docker + docker-compose, proje `~/posm`, `.env`, `docker-compose up` vb.  
   Sonda “Nginx kurulumu için: ./setup-nginx.sh” denir.

2. **setup-nginx.sh**  
   Host’a nginx kurulur, `nginx-posm.conf` ilgili site dosyasına kopyalanır, nginx yeniden başlatılır.  
   Sonuç: `http://posm.dinogida.com.tr` → nginx → 4005 / 3005.

3. Config güncellemek için (projede `nginx-posm.conf` değiştiyse):  
   `./update-nginx-config.sh`  
   (Sunucudaki sites-available dosya adı `posm.dinogida.com.tr` ise; `posm` ise script’teki hedefe göre elle kopyalayıp `nginx -t` ve `systemctl reload nginx` de kullanılabilir.)

---

## 4. Proje yapısı (kısa)

- **backend/**  
  Node/TypeScript API, port 3005, MSSQL, JWT, depot/territory/dealer/request/POSM vb.  
  Sunucuda Docker ile çalışıyor.

- **frontend/**  
  React + Vite, port 4005.  
  - Geliştirme: Vite dev server → WebSocket/HMR kullanıyor, sunucuda bu yüzden konsol hataları çıkabiliyor.  
  - Canlı için: **Production frontend** (build + statik servis) kullanılıyor; WebSocket yok, hata da olmuyor.

- **docker-compose.yml**  
  Backend + frontend servisleri, portlar 3005 / 4005.

- **docker-compose.prod-frontend.yml**  
  Sadece frontend’i production image ile çalıştıran override.  
  WebSocket hatalarını kaldırmak için sunucuda bu override ile frontend açılır.

---

## 5. Geçmişte yapılan başlıca işlemler

- **Depot bazlı filtreleme**  
  Kullanıcılar sadece kendi depolarına göre talep ve veri görüyor; dashboard ve liste filtreleri depo bazlı.

- **Bayiler tablosu sıfırlama**  
  İstenen bir noktada bayiler (ve ilişkili) tablolar sıfırlandı.

- **Bcrypt / passlib uyumu**  
  Log hataları için bcrypt sürümü uyumlu hale getirildi.

- **Toplu bayi import**  
  - Duplicate (UniqueViolation) önlemleri, Excel ve batch seviyesinde.  
  - Path traversal ve yetki iyileştirmeleri.  
  - Excel sütun adında esneklik (örn. “Bayi Kodu” / “bayi_kodu”).  
  - `backend/scripts/add-dealer-latitude-longitude.sql` (Dealers’a latitude/longitude).  
  - Akış ve kurallar için **TOPLU_BAYI_AKISI.md**.

- **WebSocket / “[vite] failed to connect to websocket”**  
  - Nginx’te WebSocket header’ları zaten vardı; sorun Vite HMR client’ın yanlış/hessiz adrese bağlanmasıydı.  
  - Çözüm: Canlıda **production frontend** kullanımı.  
  - Eklenenler: `frontend/Dockerfile.prod`, `docker-compose.prod-frontend.yml`, **SunucuUpdate.md** içinde ilgili komutlar.

- **Güvenlik / yetki**  
  Path traversal (filename validation), depot bazlı erişim (fotoğraf, POSM vb.), admin/tech ayrımı.

- **Git**  
  Değişiklikler **main** ve **server-update** branch’lerine push edildi (repo: dino4535/Posm-Servis-Portal).

---

## 6. Sunucuda sık kullanılan komutlar

Proje dizini: `~/posm` (veya sunucudaki gerçek yol).

**Kod güncellemesi (pull + production frontend):**
```bash
cd ~/posm
git pull origin main   # veya hangi branch kullanılıyorsa
docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml build frontend
docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml up -d --force-recreate frontend
```

**Nginx config’i güncelleme (projede nginx-posm.conf değiştiyse):**
```bash
cd ~/posm
./update-nginx-config.sh
# veya setup-nginx.sh kullanıldıysa ve site adı "posm" ise:
# sudo cp nginx-posm.conf /etc/nginx/sites-available/posm
# sudo nginx -t && sudo systemctl reload nginx
```

**Nginx durumu / test:**
```bash
sudo systemctl status nginx
sudo nginx -t
```

**Backend / frontend sadece restart (kod/build değişmediyse):**
```bash
docker-compose restart backend
docker-compose restart frontend
```

Detaylı adımlar ve “hangi durumda ne yapılır” için **SunucuUpdate.md** kullanılır.

---

## 7. Özet cevap: “Nginx sunucuya direkt mi kuruldu?”

Evet. Nginx, sunucuda **apt ile kurulmuş**, **systemd** ile yönetilen bir servis. Docker’ın dışında, host üzerinde çalışıyor ve 80 (ve gerekiyorsa 443) portunu dinleyip isteği `localhost:4005` (frontend) ve `localhost:3005` (backend) container’larına yönlendiriyor.
