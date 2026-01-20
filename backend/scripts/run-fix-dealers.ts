// SQL script'ini çalıştır
import sql from 'mssql';
import { config } from '../src/config/env';
import * as fs from 'fs';
import * as path from 'path';

const runScript = async () => {
  let pool: sql.ConnectionPool | null = null;
  
  try {
    console.log('Veritabanına bağlanılıyor...');
    
    pool = await sql.connect({
      server: config.database.server,
      database: config.database.database,
      user: config.database.user,
      password: config.database.password,
      port: config.database.port,
      options: {
        encrypt: false,
        trustServerCertificate: true,
        enableArithAbort: true,
      },
    });

    console.log('✓ Veritabanı bağlantısı başarılı!\n');

    // SQL dosyasını oku
    const scriptPath = path.join(__dirname, 'fix-and-clear-dealers.sql');
    const sqlScript = fs.readFileSync(scriptPath, 'utf8');

    console.log('SQL script çalıştırılıyor...\n');

    // SQL script'ini adım adım çalıştır
    console.log('[1/6] Latitude ve Longitude kolonlarını kontrol ediliyor...');
    
    // 1. Latitude kolonu kontrolü ve ekleme
    try {
      const checkLat = await pool.request().query(`
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Dealers') AND name = 'latitude')
        BEGIN
          ALTER TABLE Dealers ADD latitude FLOAT;
        END
      `);
      console.log('✓ Latitude kolonu kontrol edildi/eklendi.');
    } catch (error: any) {
      if (error.message.includes('already exists') || error.message.includes('duplicate')) {
        console.log('✓ Latitude kolonu zaten mevcut.');
      } else {
        throw error;
      }
    }

    // 2. Longitude kolonu kontrolü ve ekleme
    try {
      const checkLon = await pool.request().query(`
        IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Dealers') AND name = 'longitude')
        BEGIN
          ALTER TABLE Dealers ADD longitude FLOAT;
        END
      `);
      console.log('✓ Longitude kolonu kontrol edildi/eklendi.');
    } catch (error: any) {
      if (error.message.includes('already exists') || error.message.includes('duplicate')) {
        console.log('✓ Longitude kolonu zaten mevcut.');
      } else {
        throw error;
      }
    }

    // 3. Koordinatları düzelt
    console.log('\n[2/6] Koordinatlar düzeltiliyor...');
    const updateResult = await pool.request().query(`
      UPDATE Dealers
      SET 
        latitude = CASE 
          WHEN address IS NOT NULL AND address LIKE '{%' THEN
            TRY_CAST(JSON_VALUE(address, '$.latitude') AS FLOAT)
          ELSE latitude
        END,
        longitude = CASE 
          WHEN address IS NOT NULL AND address LIKE '{%' THEN
            TRY_CAST(JSON_VALUE(address, '$.longitude') AS FLOAT)
          ELSE longitude
        END,
        address = CASE 
          WHEN address IS NOT NULL AND address LIKE '{%' THEN
            NULLIF(JSON_VALUE(address, '$.address'), '')
          ELSE address
        END
      WHERE address IS NOT NULL 
        AND address LIKE '{%'
        AND (latitude IS NULL OR longitude IS NULL OR address LIKE '{%')
    `);
    console.log(`✓ ${updateResult.rowsAffected[0]} kayıt güncellendi.`);

    // 4. Photos tablosunu sil (Requests'e bağlı)
    console.log('\n[3/8] Fotoğraflar siliniyor...');
    try {
      const deletePhotos = await pool.request().query(`DELETE FROM Photos`);
      console.log(`✓ ${deletePhotos.rowsAffected[0]} fotoğraf silindi.`);
    } catch (error: any) {
      console.log('⚠ Fotoğraflar silinirken hata (normal olabilir):', error.message);
    }

    // 5. Talepleri sil (önce foreign key constraint'leri için)
    console.log('\n[4/8] Talepler siliniyor...');
    try {
      const deleteRequests = await pool.request().query(`DELETE FROM Requests`);
      console.log(`✓ ${deleteRequests.rowsAffected[0]} talep silindi.`);
    } catch (error: any) {
      console.log('⚠ Talepler silinirken hata (normal olabilir):', error.message);
    }

    // 5. Bayileri sil
    console.log('\n[4/7] Bayiler siliniyor...');
    const deleteDealers = await pool.request().query(`DELETE FROM Dealers`);
    console.log(`✓ ${deleteDealers.rowsAffected[0]} bayi silindi.`);

    // 6. Territory'leri sil
    console.log('\n[5/7] Territory\'ler siliniyor...');
    const deleteTerritories = await pool.request().query(`DELETE FROM Territories`);
    console.log(`✓ ${deleteTerritories.rowsAffected[0]} territory silindi.`);

    // 7. ID'leri sıfırla
    console.log('\n[6/7] ID\'ler sıfırlanıyor...');
    try {
      await pool.request().query(`DBCC CHECKIDENT ('Requests', RESEED, 0)`);
      await pool.request().query(`DBCC CHECKIDENT ('Dealers', RESEED, 0)`);
      await pool.request().query(`DBCC CHECKIDENT ('Territories', RESEED, 0)`);
      console.log('✓ ID\'ler sıfırlandı.');
    } catch (error: any) {
      console.log('⚠ ID sıfırlama hatası (normal olabilir):', error.message);
    }

    console.log('\n✓ SQL script başarıyla çalıştırıldı!');
    
    // Son kontrol
    console.log('\n[8/8] Son kontrol yapılıyor...');
    const checkResult = await pool.request().query(`
      SELECT 
        (SELECT COUNT(*) FROM Requests) as remaining_requests,
        (SELECT COUNT(*) FROM Dealers) as remaining_dealers,
        (SELECT COUNT(*) FROM Territories) as remaining_territories
    `);
    
    console.log('\n=== SONUÇ ===');
    console.log(`Kalan Talepler: ${checkResult.recordset[0].remaining_requests}`);
    console.log(`Kalan Bayiler: ${checkResult.recordset[0].remaining_dealers}`);
    console.log(`Kalan Territory'ler: ${checkResult.recordset[0].remaining_territories}`);

  } catch (error: any) {
    console.error('Hata:', error.message);
    console.error('Detay:', error);
    process.exit(1);
  } finally {
    if (pool) {
      await pool.close();
      console.log('\nVeritabanı bağlantısı kapatıldı.');
    }
  }
};

runScript();
