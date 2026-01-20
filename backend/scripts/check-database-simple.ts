// Veritabanı tablolarını kontrol et (basit versiyon)
import sql from 'mssql';
import { config } from '../src/config/env';

const checkDatabase = async () => {
  try {
    const pool = await sql.connect({
      server: config.database.server,
      database: config.database.database,
      user: config.database.user,
      password: config.database.password,
      options: {
        encrypt: false,
        trustServerCertificate: true,
      },
    });

    console.log('✓ Veritabanı bağlantısı başarılı!\n');

    const expectedTables = [
      'Depots',
      'Users',
      'User_Depots',
      'Territories',
      'Dealers',
      'POSM',
      'Requests',
      'Photos',
      'Audit_Logs',
    ];

    console.log('=== TABLO KONTROLÜ ===');
    const results: any[] = [];

    for (const table of expectedTables) {
      try {
        const result = await pool.request().query(`SELECT COUNT(*) as count FROM ${table}`);
        const count = result.recordset[0].count;
        console.log(`✓ ${table}: ${count} kayıt`);
        results.push({ table, exists: true, count });
      } catch (error: any) {
        if (error.message.includes('Invalid object name')) {
          console.log(`✗ ${table}: Tablo bulunamadı`);
          results.push({ table, exists: false, count: 0 });
        } else {
          console.log(`? ${table}: Hata - ${error.message}`);
          results.push({ table, exists: false, count: 0, error: error.message });
        }
      }
    }

    const existingTables = results.filter(r => r.exists);
    const missingTables = results.filter(r => !r.exists);

    console.log('\n=== ÖZET ===');
    console.log(`Toplam Tablo: ${expectedTables.length}`);
    console.log(`Mevcut Tablo: ${existingTables.length}`);
    console.log(`Eksik Tablo: ${missingTables.length}`);

    if (missingTables.length > 0) {
      console.log(`\n✗ Eksik tablolar: ${missingTables.map(t => t.table).join(', ')}`);
    } else {
      console.log('\n✓ Tüm tablolar mevcut!');
    }

    // Foreign key kontrolü (basit)
    console.log('\n=== FOREIGN KEY KONTROLÜ ===');
    try {
      const fkResult = await pool.request().query(`
        SELECT 
          OBJECT_NAME(fk.parent_object_id) AS TableName,
          OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
          COUNT(*) AS FK_Count
        FROM sys.foreign_keys fk
        WHERE OBJECT_NAME(fk.parent_object_id) IN ('Depots', 'Users', 'User_Depots', 'Territories', 'Dealers', 'POSM', 'Requests', 'Photos', 'Audit_Logs')
        GROUP BY OBJECT_NAME(fk.parent_object_id), OBJECT_NAME(fk.referenced_object_id)
        ORDER BY TableName
      `);

      if (fkResult.recordset.length > 0) {
        fkResult.recordset.forEach((fk: any) => {
          console.log(`✓ ${fk.TableName} -> ${fk.ReferencedTable} (${fk.FK_Count} FK)`);
        });
        const totalFK = fkResult.recordset.reduce((sum: number, fk: any) => sum + fk.FK_Count, 0);
        console.log(`\nToplam ${totalFK} foreign key bulundu.`);
      } else {
        console.log('⚠ Foreign key sorgusu çalıştırılamadı (izin hatası olabilir)');
      }
    } catch (error: any) {
      console.log('⚠ Foreign key kontrolü yapılamadı:', error.message);
    }

    // Toplam kayıt sayısı
    const totalRecords = existingTables.reduce((sum, t) => sum + t.count, 0);
    console.log(`\nToplam Kayıt Sayısı: ${totalRecords}`);

    await pool.close();
    console.log('\n✓ Kontrol tamamlandı!');
    
    return results;
  } catch (error: any) {
    console.error('✗ Hata:', error.message);
    if (error.code) {
      console.error('Hata Kodu:', error.code);
    }
    process.exit(1);
  }
};

checkDatabase();
