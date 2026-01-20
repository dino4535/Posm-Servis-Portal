import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    host: '0.0.0.0', // Tüm network interface'lerden erişime izin ver
    port: 4005,
    strictPort: false,
    // Production'da HMR devre dışı (WebSocket hatası önlemek için)
    // Development'ta manuel olarak aktif edilebilir
    hmr: process.env.NODE_ENV === 'development' ? {
      host: 'posm.dinogida.com.tr',
      protocol: 'ws',
      port: 80,
      clientPort: 80,
    } : false,
    allowedHosts: [
      'posm.dinogida.com.tr',
      'localhost',
      '.dinogida.com.tr', // Tüm subdomain'ler
    ],
    proxy: {
      '/api': {
        target: 'http://localhost:3005',
        changeOrigin: true,
      },
    },
  },
});
