// Türkiye saatini ayarla (en üstte olmalı)
process.env.TZ = 'Europe/Istanbul';

import app from './app';
import { config } from './config/env';
import { getPool, closePool } from './config/database';
import { logger } from './utils/logger';
import { startScheduledReportRunner, stopScheduledReportRunner } from './services/scheduledReportRunner';
import { cleanExpiredTokens } from './services/tokenService';
import * as cron from 'node-cron';

const PORT = config.port;

// Graceful shutdown
process.on('SIGTERM', async () => {
  logger.info('SIGTERM sinyali alındı, sunucu kapatılıyor...');
  stopScheduledReportRunner();
  await closePool();
  process.exit(0);
});

process.on('SIGINT', async () => {
  logger.info('SIGINT sinyali alındı, sunucu kapatılıyor...');
  stopScheduledReportRunner();
  await closePool();
  process.exit(0);
});

// Start server
const startServer = async () => {
  try {
    // Veritabanı bağlantısını test et
    await getPool();
    
    app.listen(PORT, () => {
      logger.info(`Server ${PORT} portunda çalışıyor`);
      logger.info(`Environment: ${config.nodeEnv}`);
      
      // Scheduled report runner'ı başlat
      startScheduledReportRunner();
      
      // Token temizleme cron job'ı (her gün saat 02:00'de)
      cron.schedule('0 2 * * *', async () => {
        try {
          await cleanExpiredTokens();
          logger.info('Eski token\'lar temizlendi');
        } catch (error) {
          logger.error('Token temizleme hatası:', error);
        }
      });
      
      logger.info('Token temizleme cron job\'ı başlatıldı (Her gün 02:00)');
    });
  } catch (error) {
    logger.error('Server başlatılamadı:', error);
    process.exit(1);
  }
};

startServer();
