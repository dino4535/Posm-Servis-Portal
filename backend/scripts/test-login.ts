// Login endpoint'ini test et
import axios from 'axios';

const testLogin = async () => {
  try {
    console.log('=== LOGIN TEST ===\n');
    
    const response = await axios.post('http://localhost:3002/api/auth/login', {
      email: 'admin@posm.com',
      password: 'admin123',
    });

    console.log('✓ Login başarılı!');
    console.log('Response:', JSON.stringify(response.data, null, 2));
    
    if (response.data.success && response.data.data.token) {
      console.log('\n✓ Token alındı');
      console.log('Token (ilk 50 karakter):', response.data.data.token.substring(0, 50) + '...');
      console.log('User:', response.data.data.user);
    }
  } catch (error: any) {
    if (error.response) {
      console.error('✗ Login hatası:', error.response.status, error.response.data);
    } else if (error.request) {
      console.error('✗ Backend\'e bağlanılamadı. Backend çalışıyor mu?');
      console.error('Hata:', error.message);
    } else {
      console.error('✗ Hata:', error.message);
    }
  }
};

testLogin();
