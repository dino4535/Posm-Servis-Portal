// Veritabanı tablolarını kontrol et
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

    // Tüm tabloları listele
    const tablesResult = await pool.request().query(`
      SELECT name 
      FROM sys.tables 
      WHERE type = 'U' AND is_ms_shipped = 0
      ORDER BY name
    `);

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

    const existingTables = tablesResult.recordset.map((r: any) => r.name);
    const missingTables = expectedTables.filter((t) => !existingTables.includes(t));

    console.log('=== TABLO KONTROLÜ ===');
    expectedTables.forEach((table) => {
      const exists = existingTables.includes(table);
      console.log(`${exists ? '✓' : '✗'} ${table}`);
    });

    if (missingTables.length > 0) {
      console.log(`\n✗ Eksik tablolar: ${missingTables.join(', ')}`);
    } else {
      console.log('\n✓ Tüm tablolar mevcut!');
    }

    // Her tablonun kayıt sayısını kontrol et
    console.log('\n=== KAYIT SAYILARI ===');
    for (const table of expectedTables) {
      if (existingTables.includes(table)) {
        try {
          const countResult = await pool.request().query(`SELECT COUNT(*) as count FROM ${table}`);
          const count = countResult.recordset[0].count;
          console.log(`${table}: ${count} kayıt`);
        } catch (error: any) {
          console.log(`${table}: Hata - ${error.message}`);
        }
      }
    }

    // Foreign key kontrolü
    console.log('\n=== FOREIGN KEY KONTROLÜ ===');
    const fkResult = await pool.request().query(`
      SELECT 
        fk.name AS ForeignKeyName,
        OBJECT_NAME(fk.parent_object_id) AS TableName,
        OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable
      FROM sys.foreign_keys fk
      ORDER BY OBJECT_NAME(fk.parent_object_id)
    `);

    if (fkResult.recordset.length > 0) {
      fkResult.recordset.forEach((fk: any) => {
        console.log(`✓ ${fk.ForeignKeyName}: ${fk.TableName} -> ${fk.ReferencedTable}`);
      });
      console.log(`\nToplam ${fkResult.recordset.length} foreign key bulundu.`);
    } else {
      console.log('✗ Foreign key bulunamadı!');
    }

    await pool.close();
    console.log('\n✓ Kontrol tamamlandı!');
  } catch (error: any) {
    console.error('✗ Hata:', error.message);
    process.exit(1);
  }
};

checkDatabase();
