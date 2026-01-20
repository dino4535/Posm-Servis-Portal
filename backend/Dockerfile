# Backend Dockerfile - Production
FROM node:20-alpine AS builder

WORKDIR /app

# Package dosyalarını kopyala
COPY package*.json ./
RUN npm ci

# Kaynak kodları kopyala
COPY . .

# TypeScript build
RUN npm run build

# Production image
FROM node:20-alpine

WORKDIR /app

# Sadece production dependencies
COPY package*.json ./
RUN npm ci --only=production

# Build çıktısını kopyala
COPY --from=builder /app/dist ./dist

# Uploads klasörü oluştur
RUN mkdir -p uploads && chmod 755 uploads

# Environment variables (production'da .env dosyası kullanılacak)
ENV NODE_ENV=production
ENV PORT=3005

# Port expose et
EXPOSE 3005

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3005/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Uygulamayı başlat
CMD ["node", "dist/server.js"]
