import dotenv from 'dotenv';

dotenv.config();

// Environment değişkenlerini kontrol et
const requiredEnvVars = [
  'DB_SERVER',
  'DB_DATABASE',
  'DB_USER',
  'DB_PASSWORD',
  'JWT_SECRET',
];

const missingEnvVars = requiredEnvVars.filter((varName) => !process.env[varName]);

if (missingEnvVars.length > 0) {
  throw new Error(
    `Eksik environment değişkenleri: ${missingEnvVars.join(', ')}\n` +
    `Lütfen .env dosyasını oluşturun ve gerekli değerleri ekleyin.\n` +
    `Örnek için env.example dosyasına bakın.`
  );
}

export const config = {
  port: parseInt(process.env.PORT || '3005', 10),
  nodeEnv: process.env.NODE_ENV || 'development',
  
  database: {
    server: process.env.DB_SERVER!,
    database: process.env.DB_DATABASE!,
    user: process.env.DB_USER!,
    password: process.env.DB_PASSWORD!,
    port: parseInt(process.env.DB_PORT || '1433', 10),
    options: {
      encrypt: process.env.DB_ENCRYPT === 'true',
      trustServerCertificate: process.env.DB_TRUST_SERVER_CERTIFICATE === 'true',
      enableArithAbort: true,
    },
    pool: {
      max: 10,
      min: 0,
      idleTimeoutMillis: 30000,
    },
  },
  
  jwt: {
    secret: process.env.JWT_SECRET!,
    expiresIn: process.env.JWT_EXPIRES_IN || '2d',
  },
  
  cors: {
    origin: process.env.FRONTEND_URL 
      ? (process.env.FRONTEND_URL.includes(',') 
          ? process.env.FRONTEND_URL.split(',').map(url => url.trim())
          : process.env.FRONTEND_URL)
      : ['http://localhost:4005', 'http://posm.dinogida.com.tr', 'https://posm.dinogida.com.tr'],
  },
  
  upload: {
    maxFileSize: parseInt(process.env.MAX_FILE_SIZE || '10485760', 10), // 10MB
    uploadPath: process.env.UPLOAD_PATH || './uploads',
  },
  
  email: {
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587', 10),
    secure: process.env.SMTP_SECURE === 'true',
    auth: {
      user: process.env.SMTP_USER || '',
      pass: process.env.SMTP_PASS || '',
    },
    from: (process.env.EMAIL_FROM || 'noreply@posm.com').trim(),
  },
};
