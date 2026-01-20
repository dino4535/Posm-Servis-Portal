import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:3005/api';

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - Token ekle
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      // Tüm istekler için (blob dahil) token gönder
      // Authorization header'ını her zaman ekle (blob istekleri dahil)
      if (!config.headers) {
        config.headers = {};
      }
      config.headers.Authorization = `Bearer ${token}`;
      
      // FormData istekleri için Content-Type header'ını kaldır (browser otomatik ekler boundary ile)
      if (config.data instanceof FormData) {
        delete config.headers['Content-Type'];
      }
      
      // Blob istekleri için Content-Type header'ını kaldır (browser otomatik ayarlar)
      if (config.responseType === 'blob') {
        delete config.headers['Content-Type'];
        // Debug: Blob isteği için token gönderildiğini logla
        console.log('[API] Blob isteği - Token gönderiliyor:', config.url, 'Token var:', !!token, 'Headers:', config.headers);
      }
    } else {
      console.warn('[API] Token bulunamadı, istek:', config.url);
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor - Hata yönetimi
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token geçersiz veya süresi dolmuş
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default api;
