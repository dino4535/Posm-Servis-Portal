// Seed data'yı programatik olarak ekle
import sql from 'mssql';
import { config } from '../src/config/env';
import bcrypt from 'bcryptjs';

const runSeed = async () => {
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

    // 1. Depoları oluştur
    console.log('=== DEPOLAR ===');
    const depots = [
      { name: 'Depo 1', code: 'DEPO1', address: 'İstanbul' },
      { name: 'Depo 2', code: 'DEPO2', address: 'Ankara' },
      { name: 'Depo 3', code: 'DEPO3', address: 'İzmir' },
    ];

    const depotIds: number[] = [];

    for (const depot of depots) {
      const checkResult = await pool.request()
        .input('code', sql.NVarChar, depot.code)
        .query('SELECT id FROM Depots WHERE code = @code');

      if (checkResult.recordset.length === 0) {
        const insertResult = await pool.request()
          .input('name', sql.NVarChar, depot.name)
          .input('code', sql.NVarChar, depot.code)
          .input('address', sql.NVarChar, depot.address)
          .query(`
            INSERT INTO Depots (name, code, address, is_active)
            OUTPUT INSERTED.id
            VALUES (@name, @code, @address, 1)
          `);
        const id = insertResult.recordset[0].id;
        depotIds.push(id);
        console.log(`✓ ${depot.name} oluşturuldu (ID: ${id})`);
      } else {
        const id = checkResult.recordset[0].id;
        depotIds.push(id);
        console.log(`✓ ${depot.name} zaten mevcut (ID: ${id})`);
      }
    }

    // 2. Admin kullanıcı oluştur
    console.log('\n=== ADMIN KULLANICI ===');
    const passwordHash = await bcrypt.hash('admin123', 10);
    
    const userCheck = await pool.request()
      .input('email', sql.NVarChar, 'admin@posm.com')
      .query('SELECT id FROM Users WHERE email = @email');

    let adminUserId: number;

    if (userCheck.recordset.length === 0) {
      const userResult = await pool.request()
        .input('email', sql.NVarChar, 'admin@posm.com')
        .input('password_hash', sql.NVarChar, passwordHash)
        .input('name', sql.NVarChar, 'Admin User')
        .input('role', sql.NVarChar, 'Admin')
        .query(`
          INSERT INTO Users (email, password_hash, name, role, is_active)
          OUTPUT INSERTED.id
          VALUES (@email, @password_hash, @name, @role, 1)
        `);
      adminUserId = userResult.recordset[0].id;
      console.log(`✓ Admin kullanıcı oluşturuldu (ID: ${adminUserId})`);
    } else {
      adminUserId = userCheck.recordset[0].id;
      console.log(`✓ Admin kullanıcı zaten mevcut (ID: ${adminUserId})`);
    }

    // 3. Admin kullanıcıya tüm depoları ata
    console.log('\n=== DEPO ATAMALARI ===');
    for (let i = 0; i < depotIds.length; i++) {
      const depotId = depotIds[i];
      const checkResult = await pool.request()
        .input('user_id', sql.Int, adminUserId)
        .input('depot_id', sql.Int, depotId)
        .query('SELECT id FROM User_Depots WHERE user_id = @user_id AND depot_id = @depot_id');

      if (checkResult.recordset.length === 0) {
        await pool.request()
          .input('user_id', sql.Int, adminUserId)
          .input('depot_id', sql.Int, depotId)
          .query('INSERT INTO User_Depots (user_id, depot_id) VALUES (@user_id, @depot_id)');
        console.log(`✓ Depo ${i + 1} admin kullanıcıya atandı`);
      } else {
        console.log(`✓ Depo ${i + 1} zaten atanmış`);
      }
    }

    await pool.close();
    console.log('\n✓ Başlangıç verileri başarıyla eklendi!');
    console.log('\n📋 GİRİŞ BİLGİLERİ:');
    console.log('Email: admin@posm.com');
    console.log('Şifre: admin123');
  } catch (error: any) {
    console.error('✗ Hata:', error.message);
    if (error.code) {
      console.error('Hata Kodu:', error.code);
    }
    process.exit(1);
  }
};

runSeed();
