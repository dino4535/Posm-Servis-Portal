import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

// posm.dinogida.com.tr üzerinden erişimde WebSocket hatasını önlemek:
// - Sunucuda VITE_HMR_HOST=posm.dinogida.com.tr vererek HMR'ı bu host üzerinden deneyecek şekilde ayarlayabilirsiniz (nginx'te WebSocket upgrade gerekir).
// - Veya production build kullanın: npm run build && dist'i nginx ile statik servis edin (tercih edilen yol).
const hmrHost = process.env.VITE_HMR_HOST;
const hmrConfig = hmrHost
  ? { host: hmrHost, protocol: 'wss' as const, port: 443 }
  : false;

export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  define: {
    // HMR client'ın bağlanmaya çalışmasını azaltmak için (sunucuda tam kapanma için production build kullanın)
    'import.meta.hot': 'undefined',
  },
  server: {
    host: '0.0.0.0',
    port: 4005,
    strictPort: false,
    hmr: hmrConfig,
    ...(hmrConfig === false && { ws: false }),
    allowedHosts: [
      'posm.dinogida.com.tr',
      'localhost',
      '.dinogida.com.tr',
    ],
    proxy: {
      '/api': {
        target: process.env.VITE_API_PROXY_TARGET || 'http://localhost:3005',
        changeOrigin: true,
      },
    },
  },
});
