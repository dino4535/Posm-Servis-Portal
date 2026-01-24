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