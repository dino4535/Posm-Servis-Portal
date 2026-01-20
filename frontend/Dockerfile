# Frontend Dockerfile - Development Mode
FROM node:20-alpine

WORKDIR /app

# Package dosyalarını kopyala
COPY package*.json ./

# Tüm bağımlılıkları yükle (dev dependencies dahil)
RUN npm install

# Kaynak kodları kopyala
COPY . .

# Environment variable
ENV VITE_API_URL=/api

# Port expose et (vite.config.ts'de 4005 olarak ayarlı)
EXPOSE 4005

# Development modunda çalıştır (hot reload ile)
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
