// Şifre hash'i oluşturma script'i
const bcrypt = require('bcryptjs');

const password = process.argv[2] || 'admin123';

bcrypt.hash(password, 10, (err, hash) => {
  if (err) {
    console.error('Hata:', err);
    return;
  }
  console.log(`Şifre: ${password}`);
  console.log(`Hash: ${hash}`);
  console.log('\nSQL INSERT komutu:');
  console.log(`INSERT INTO Users (email, password_hash, name, role, is_active) VALUES`);
  console.log(`('admin@posm.com', '${hash}', 'Admin User', 'Admin', 1);`);
});
