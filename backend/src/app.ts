import express, { Application } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import rateLimit from 'express-rate-limit';
import { config } from './config/env';
import { errorHandler } from './middleware/errorHandler';
import authRoutes from './routes/auth';
import userRoutes from './routes/users';
import depotRoutes from './routes/depots';
import territoryRoutes from './routes/territories';
import dealerRoutes from './routes/dealers';
import posmRoutes from './routes/posm';
import posmTransferRoutes from './routes/posmTransfers';
import requestRoutes from './routes/requests';
import photoRoutes from './routes/photos';
import auditRoutes from './routes/audit';
import reportRoutes from './routes/reports';
import customReportRoutes from './routes/customReports';

const app: Application = express();

// CORS - Önce CORS'u ayarla (helmet'ten önce)
app.use(
  cors({
    origin: config.cors.origin,
    credentials: true,
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    exposedHeaders: ['Content-Type', 'Authorization'],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS', 'PATCH'],
  })
);

// Trust proxy - Gerçek IP adresini almak için
app.set('trust proxy', true);

// Security middleware
app.use(helmet({
  crossOriginResourcePolicy: { policy: "cross-origin" },
  crossOriginEmbedderPolicy: false,
}));

// Body parser
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Genel rate limiting - Login ve fotoğraf endpoint'lerini skip et
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 dakika
  max: config.nodeEnv === 'development' ? 1000 : 200, // Development'ta daha esnek
  message: 'Çok fazla istek gönderildi, lütfen daha sonra tekrar deneyin.',
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => {
    // Login endpoint'ini genel limiter'dan muaf tut (login kendi limiter'ını kullanıyor)
    if (req.path === '/api/auth/login' || req.path.startsWith('/api/auth/login')) {
      return true;
    }
    // Fotoğraf endpoint'lerini de muaf tut (blob istekleri için)
    if (req.path.startsWith('/api/photos/')) {
      return true;
    }
    return false;
  },
});

// Static file serving - Uploads klasörünü serve et (sadece authenticated istekler için)
// Bu route'u authenticate middleware'den önce tanımla ama kendi authentication'ını ekle
app.use('/uploads', express.static(config.upload.uploadPath));

// Routes - Auth route'larını rate limiter'dan önce tanımla
app.use('/api/auth', authRoutes);

// Fotoğraf route'larını rate limiter'dan önce tanımla (blob istekleri için)
app.use('/api/photos', photoRoutes);

// Diğer endpoint'ler için genel rate limiter
app.use('/api/', limiter);
app.use('/api/users', userRoutes);
app.use('/api/depots', depotRoutes);
app.use('/api/territories', territoryRoutes);
app.use('/api/dealers', dealerRoutes);
app.use('/api/posm', posmRoutes);
app.use('/api/posm-transfers', posmTransferRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/audit', auditRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/custom-reports', customReportRoutes);

import { getTurkeyDateTimeISO } from './utils/dateHelper';

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: getTurkeyDateTimeISO() });
});

// Error handler
app.use(errorHandler);

export default app;
