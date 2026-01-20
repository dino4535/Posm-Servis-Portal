// Kullanıcı şifresini kontrol et
import sql from 'mssql';
import { config } from '../src/config/env';
import bcrypt from 'bcryptjs';

const checkPassword = async () => {
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

    // Admin kullanıcıyı bul
    const result = await pool.request()
      .input('email', sql.NVarChar, 'admin@posm.com')
      .query('SELECT id, email, password_hash, name, role, is_active FROM Users WHERE email = @email');

    if (result.recordset.length === 0) {
      console.log('✗ Admin kullanıcı bulunamadı!');
      await pool.close();
      return;
    }

    const user = result.recordset[0];
    console.log('=== KULLANICI BİLGİLERİ ===');
    console.log(`ID: ${user.id}`);
    console.log(`Email: ${user.email}`);
    console.log(`Name: ${user.name}`);
    console.log(`Role: ${user.role}`);
    console.log(`Is Active: ${user.is_active}`);
    console.log(`Password Hash: ${user.password_hash.substring(0, 30)}...`);

    // Şifre kontrolü
    console.log('\n=== ŞİFRE KONTROLÜ ===');
    const testPassword = 'admin123';
    const isValid = await bcrypt.compare(testPassword, user.password_hash);
    
    if (isValid) {
      console.log('✓ Şifre doğru! (admin123)');
    } else {
      console.log('✗ Şifre yanlış!');
      console.log('\nYeni şifre hash\'i oluşturuluyor...');
      const newHash = await bcrypt.hash(testPassword, 10);
      console.log('Yeni Hash:', newHash);
      
      // Şifreyi güncelle
      await pool.request()
        .input('id', sql.Int, user.id)
        .input('password_hash', sql.NVarChar, newHash)
        .query('UPDATE Users SET password_hash = @password_hash WHERE id = @id');
      
      console.log('✓ Şifre güncellendi!');
    }

    await pool.close();
  } catch (error: any) {
    console.error('✗ Hata:', error.message);
    process.exit(1);
  }
};

checkPassword();
