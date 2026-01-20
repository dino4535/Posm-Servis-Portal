# Frontend Dockerfile - Production
FROM node:20-alpine AS builder

WORKDIR /app

# Build arg (API URL)
ARG VITE_API_URL=/api

# Package dosyalarını kopyala
COPY package*.json ./
RUN npm ci

# Kaynak kodları kopyala
COPY . .

# Environment variable'ı build sırasında kullan
ENV VITE_API_URL=${VITE_API_URL}

# Build
RUN npm run build

# Production image (Nginx ile serve et)
FROM nginx:alpine

# Build çıktısını nginx'e kopyala
COPY --from=builder /app/dist /usr/share/nginx/html

# Nginx konfigürasyonu
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Port expose et
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1

# Nginx'i başlat
CMD ["nginx", "-g", "daemon off;"]
