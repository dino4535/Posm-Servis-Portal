/**
 * Tüm depolar için POSM'leri ekle - Çalıştırma script'i
 * 
 * Kullanım: 
 *   npx ts-node backend/scripts/run-insert-posm.ts
 *   veya
 *   py backend/scripts/run-insert-posm.ts
 */

import { getPool, closePool } from '../src/config/database';
import { insertPosmToAllDepots } from './insertPosmToAllDepots';

// dotenv yükle
import * as dotenv from 'dotenv';
dotenv.config();

const run = async () => {
  try {
    console.log('POSM ekleme script\'i başlatılıyor...');
    
    // Veritabanı bağlantısını test et
    await getPool();
    console.log('Veritabanı bağlantısı başarılı');
    
    // POSM'leri ekle
    await insertPosmToAllDepots();
    
    console.log('\n✅ İşlem başarıyla tamamlandı!');
  } catch (error: any) {
    console.error('❌ Hata:', error.message);
    console.error(error.stack);
    process.exit(1);
  } finally {
    await closePool();
    process.exit(0);
  }
};

run();
