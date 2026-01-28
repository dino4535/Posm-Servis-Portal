cd ~/posm
git pull origin main

# --- ONCELIK: "[vite] failed to connect to websocket" hatasi aliyorsaniz ---
# Asagidaki 3 satiri calistirin (production frontend = WebSocket yok, hata biter):
#   docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml build frontend
#   docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml up -d --force-recreate frontend
# Devaminda sadece frontend degisti. Backend ager guncellendiyse en alttaki backend komutlarini da calistirin.

# Bu guncelleme icin (vite/docker degisiklikleri, prod-frontend KULLANMIYORSANIZ):
docker-compose build frontend
docker-compose up -d --force-recreate frontend

# Sadece KOD degisikligi (package.json ayni, image degismedi):
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

# --- WebSocket / "[vite] failed to connect to websocket" hatasini KALDIRMAK icin ---
# Production frontend kullanin (Vite dev server yok, sadece build edilmis statik dosyalar).
# Asagidaki komutlari calistirin (proje dizininde: cd ~/posm):
#
#   git pull origin main
#   docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml build frontend
#   docker-compose -f docker-compose.yml -f docker-compose.prod-frontend.yml up -d --force-recreate frontend
#
# Bundan sonra posm.dinogida.com.tr sayfasi WebSocket hatasi vermeden acilir.
# Frontend kodu degistiginde yine ayni 3 komutu (pull + build frontend + up) calistirin.