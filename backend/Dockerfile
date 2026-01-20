# Backend Dockerfile - Development Mode
FROM node:20-alpine

WORKDIR /app

# Package dosyalarını kopyala
COPY package*.json ./

# Tüm bağımlılıkları yükle (dev dependencies dahil)
RUN npm install

# Kaynak kodları kopyala
COPY . .

# Uploads klasörü oluştur
RUN mkdir -p uploads && chmod 755 uploads

# Environment variables
ENV NODE_ENV=development
ENV PORT=3005

# Port expose et
EXPOSE 3005

# Development modunda çalıştır (hot reload ile)
CMD ["npm", "run", "dev"]
