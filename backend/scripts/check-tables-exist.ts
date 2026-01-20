// Sadece tablo varlığını kontrol et (SELECT izni gerektirmez)
import sql from 'mssql';
import { config } from '../src/config/env';

const checkTables = async () => {
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

    console.log('=== TABLO VARLIK KONTROLÜ ===');
    const results: any[] = [];

    for (const table of expectedTables) {
      try {
        // OBJECT_ID kullanarak tablo varlığını kontrol et (SELECT izni gerektirmez)
        const result = await pool.request().query(`
          SELECT CASE 
            WHEN OBJECT_ID('${table}', 'U') IS NOT NULL THEN 1 
            ELSE 0 
          END AS exists_flag
        `);
        const exists = result.recordset[0].exists_flag === 1;
        
        if (exists) {
          console.log(`✓ ${table}: Tablo mevcut`);
          results.push({ table, exists: true });
        } else {
          console.log(`✗ ${table}: Tablo bulunamadı`);
          results.push({ table, exists: false });
        }
      } catch (error: any) {
        console.log(`? ${table}: Hata - ${error.message}`);
        results.push({ table, exists: false, error: error.message });
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

    // Index kontrolü
    console.log('\n=== INDEX KONTROLÜ ===');
    for (const table of existingTables.map(t => t.table)) {
      try {
        const indexResult = await pool.request().query(`
          SELECT 
            i.name AS IndexName,
            i.type_desc AS IndexType,
            i.is_primary_key AS IsPrimaryKey,
            i.is_unique AS IsUnique
          FROM sys.indexes i
          WHERE i.object_id = OBJECT_ID('${table}', 'U')
          AND i.name IS NOT NULL
          ORDER BY i.is_primary_key DESC, i.name
        `);
        
        if (indexResult.recordset.length > 0) {
          console.log(`\n${table}:`);
          indexResult.recordset.forEach((idx: any) => {
            const type = idx.IsPrimaryKey ? 'PRIMARY KEY' : idx.IsUnique ? 'UNIQUE' : idx.IndexType;
            console.log(`  ✓ ${idx.IndexName} (${type})`);
          });
        } else {
          console.log(`\n${table}: Index bulunamadı`);
        }
      } catch (error: any) {
        console.log(`\n${table}: Index kontrolü yapılamadı - ${error.message}`);
      }
    }

    // Foreign key kontrolü (basit)
    console.log('\n=== FOREIGN KEY KONTROLÜ ===');
    for (const table of existingTables.map(t => t.table)) {
      try {
        const fkResult = await pool.request().query(`
          SELECT 
            fk.name AS ForeignKeyName,
            OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
          FROM sys.foreign_keys fk
          WHERE fk.parent_object_id = OBJECT_ID('${table}', 'U')
        `);
        
        if (fkResult.recordset.length > 0) {
          console.log(`\n${table}:`);
          fkResult.recordset.forEach((fk: any) => {
            console.log(`  ✓ ${fk.ForeignKeyName} -> ${fk.ReferencedTable}`);
          });
        }
      } catch (error: any) {
        // İzin hatası olabilir, sessizce geç
      }
    }

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

checkTables();
