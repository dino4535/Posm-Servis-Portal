cd ~/posm
git pull origin main

# Sadece KOD değişikliği (package.json aynı):
# docker-compose restart frontend
# docker-compose restart backend

# FRONTEND'DE YENİ PAKET (package.json değişti, örn. @fullcalendar/interaction):
docker-compose build frontend
docker-compose run --rm --no-deps frontend npm install
docker-compose up -d --force-recreate frontend

# Backend’i de yeniden başlat (isteğe bağlı, backend değişmediyse gerek yok):
# docker-compose restart backend

docker-compose build backend
docker-compose run --rm --no-deps backend npm install
docker-compose up -d --force-recreate backend

# --- WebSocket / "[vite] failed to connect to websocket" hatası (posm.dinogida.com.tr girişte) ---
# Sebep: Tarayıcı posm.dinogida.com.tr'den açılıyor, Vite HMR localhost:4005 veya yanlış adrese bağlanmaya çalışıyor.
#
# Çözüm 1 (önerilen): Production build ile sun. WebSocket yok, hata olmaz.
#   Frontend'te: npm run build -> dist/ çıkar. Nginx'te root veya alias ile dist'i verin.
#   Veya ayrı bir "frontend-static" servisi ile dist'i serve edin; canlıda Vite dev container'ı kullanmayın.
#
# Çözüm 2: Nginx'te WebSocket proxy ekleyin, frontend container'a HMR host verin.
#   docker-compose'da frontend environment'a ekleyin: VITE_HMR_HOST=posm.dinogida.com.tr
#   Nginx'te / konumunda:
#     proxy_http_version 1.1;
#     proxy_set_header Upgrade $http_upgrade;
#     proxy_set_header Connection "upgrade";
#     proxy_set_header Host $host;
#     proxy_cache_bypass $http_upgrade;