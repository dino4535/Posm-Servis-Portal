import { Request } from 'express';
import os from 'os';
import https from 'https';

/**
 * Localhost IP adreslerini kontrol eder
 */
const isLocalhost = (ip: string | undefined): boolean => {
  if (!ip) return false;
  const normalizedIp = ip.toLowerCase().trim();
  return (
    normalizedIp === '::1' ||
    normalizedIp === '127.0.0.1' ||
    normalizedIp === 'localhost' ||
    normalizedIp.startsWith('::ffff:127.0.0.1') ||
    normalizedIp.startsWith('::ffff:192.168.') ||
    normalizedIp.startsWith('::ffff:10.') ||
    normalizedIp.startsWith('::ffff:172.16.') ||
    normalizedIp.startsWith('::ffff:172.17.') ||
    normalizedIp.startsWith('::ffff:172.18.') ||
    normalizedIp.startsWith('::ffff:172.19.') ||
    normalizedIp.startsWith('::ffff:172.20.') ||
    normalizedIp.startsWith('::ffff:172.21.') ||
    normalizedIp.startsWith('::ffff:172.22.') ||
    normalizedIp.startsWith('::ffff:172.23.') ||
    normalizedIp.startsWith('::ffff:172.24.') ||
    normalizedIp.startsWith('::ffff:172.25.') ||
    normalizedIp.startsWith('::ffff:172.26.') ||
    normalizedIp.startsWith('::ffff:172.27.') ||
    normalizedIp.startsWith('::ffff:172.28.') ||
    normalizedIp.startsWith('::ffff:172.29.') ||
    normalizedIp.startsWith('::ffff:172.30.') ||
    normalizedIp.startsWith('::ffff:172.31.')
  );
};

/**
 * Sistemin gerçek IP adresini alır (localhost değilse)
 */
const getSystemIpAddress = (): string | undefined => {
  try {
    const interfaces = os.networkInterfaces();
    for (const name of Object.keys(interfaces)) {
      const iface = interfaces[name];
      if (!iface) continue;
      
      for (const addr of iface) {
        // IPv4 ve internal olmayan adresi tercih et
        if (addr.family === 'IPv4' && !addr.internal) {
          return addr.address;
        }
      }
    }
    
    // Eğer external IP yoksa, internal IPv4'ü al
    for (const name of Object.keys(interfaces)) {
      const iface = interfaces[name];
      if (!iface) continue;
      
      for (const addr of iface) {
        if (addr.family === 'IPv4') {
          return addr.address;
        }
      }
    }
  } catch (error) {
    console.error('[IP] Sistem IP adresi alınırken hata:', error);
  }
  return undefined;
};

/**
 * Public IP adresini harici API'den alır (cache'lenmiş)
 * Birden fazla API dener (fallback mekanizması)
 */
let cachedPublicIp: string | null = null;
let publicIpCacheTime: number = 0;
const PUBLIC_IP_CACHE_DURATION = 10 * 60 * 1000; // 10 dakika cache

const getPublicIpFromApi = (): Promise<string | undefined> => {
  return new Promise((resolve) => {
    // Cache kontrolü
    const now = Date.now();
    if (cachedPublicIp && (now - publicIpCacheTime) < PUBLIC_IP_CACHE_DURATION) {
      resolve(cachedPublicIp);
      return;
    }

    // İlk API: ipify.org (hızlı ve güvenilir)
    const tryIpify = (): Promise<string | undefined> => {
      return new Promise((resolveApi) => {
        const options = {
          hostname: 'api.ipify.org',
          path: '/?format=json',
          method: 'GET',
          timeout: 3000,
        };

        const req = https.request(options, (res) => {
          let data = '';
          res.on('data', (chunk) => {
            data += chunk;
          });
          res.on('end', () => {
            try {
              const result = JSON.parse(data);
              if (result.ip && /^\d+\.\d+\.\d+\.\d+$/.test(result.ip)) {
                cachedPublicIp = result.ip;
                publicIpCacheTime = now;
                resolveApi(result.ip);
              } else {
                resolveApi(undefined);
              }
            } catch (error) {
              resolveApi(undefined);
            }
          });
        });

        req.on('error', () => {
          resolveApi(undefined);
        });

        req.on('timeout', () => {
          req.destroy();
          resolveApi(undefined);
        });

        req.setTimeout(3000);
        req.end();
      });
    };

    // İkinci API: icanhazip.com (fallback)
    const tryIcanhazip = (): Promise<string | undefined> => {
      return new Promise((resolveApi) => {
        const options = {
          hostname: 'icanhazip.com',
          path: '/',
          method: 'GET',
          timeout: 3000,
        };

        const req = https.request(options, (res) => {
          let data = '';
          res.on('data', (chunk) => {
            data += chunk;
          });
          res.on('end', () => {
            const ip = data.trim();
            if (ip && /^\d+\.\d+\.\d+\.\d+$/.test(ip)) {
              cachedPublicIp = ip;
              publicIpCacheTime = now;
              resolveApi(ip);
            } else {
              resolveApi(undefined);
            }
          });
        });

        req.on('error', () => {
          resolveApi(undefined);
        });

        req.on('timeout', () => {
          req.destroy();
          resolveApi(undefined);
        });

        req.setTimeout(3000);
        req.end();
      });
    };

    // Önce ipify'ı dene, başarısız olursa icanhazip'i dene
    tryIpify()
      .then((ip) => {
        if (ip) {
          resolve(ip);
          return;
        }
        return tryIcanhazip();
      })
      .then((ip) => {
        if (ip) {
          resolve(ip);
        } else {
          console.warn('[IP] Public IP API\'lerinden IP alınamadı');
          resolve('127.0.0.1');
        }
      })
      .catch(() => {
        console.warn('[IP] Public IP API\'lerinden IP alınamadı');
        resolve('127.0.0.1');
      });
  });
};

/**
 * Gerçek IP adresini alır
 * Proxy veya load balancer arkasındaysa X-Forwarded-For header'ını kontrol eder
 * Localhost ise sistem IP'sini veya public IP'yi döndürür
 */
export const getRealIpAddress = async (req: Request): Promise<string | undefined> => {
  let clientIp: string | undefined;

  // 1. X-Forwarded-For header'ını kontrol et (proxy/load balancer arkasındaysa)
  const forwardedFor = req.headers['x-forwarded-for'];
  if (forwardedFor) {
    // X-Forwarded-For birden fazla IP içerebilir (virgülle ayrılmış)
    // İlk IP gerçek client IP'sidir
    const ips = Array.isArray(forwardedFor) 
      ? forwardedFor[0] 
      : forwardedFor;
    const firstIp = ips.split(',')[0].trim();
    if (firstIp && !isLocalhost(firstIp)) {
      return firstIp;
    }
    clientIp = firstIp;
  }

  // 2. X-Real-IP header'ını kontrol et (nginx gibi reverse proxy'ler için)
  const realIp = req.headers['x-real-ip'];
  if (realIp) {
    const ip = Array.isArray(realIp) ? realIp[0] : realIp;
    const trimmedIp = ip.trim();
    if (trimmedIp && !isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 3. CF-Connecting-IP header'ını kontrol et (Cloudflare için)
  const cfIp = req.headers['cf-connecting-ip'];
  if (cfIp) {
    const ip = Array.isArray(cfIp) ? cfIp[0] : cfIp;
    const trimmedIp = ip.trim();
    if (trimmedIp && !isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 4. req.ip kullan (Express trust proxy ayarı varsa)
  if (req.ip) {
    const trimmedIp = req.ip.trim();
    if (!isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 5. socket.remoteAddress kullan
  if (req.socket && req.socket.remoteAddress) {
    const trimmedIp = req.socket.remoteAddress.trim();
    if (!isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 6. Eğer localhost IP'si varsa veya IP yoksa, public IP'yi al (ISP IP'si)
  if (isLocalhost(clientIp) || !clientIp) {
    // Önce sistem IP'sini kontrol et (private network IP'si)
    const systemIp = getSystemIpAddress();
    if (systemIp && !isLocalhost(systemIp)) {
      // Sistem IP'si varsa ama private ise, public IP'yi de al
      try {
        const publicIp = await getPublicIpFromApi();
        if (publicIp) {
          // Public IP'yi öncelikli olarak döndür (ISP IP'si)
          return publicIp;
        }
      } catch (error) {
        console.error('[IP] Public IP alınırken hata:', error);
      }
      // Public IP alınamazsa sistem IP'sini döndür
      return systemIp;
    }
    
    // Sistem IP'si de yoksa veya localhost ise, public IP'yi al (ISP IP'si)
    try {
      const publicIp = await getPublicIpFromApi();
      if (publicIp) {
        return publicIp;
      }
    } catch (error) {
      console.error('[IP] Public IP alınırken hata:', error);
    }
    
    // Hiçbiri yoksa, localhost IP'sini döndür
    return clientIp || '127.0.0.1';
  }

  return clientIp;
};

/**
 * Senkron versiyon (geriye dönük uyumluluk için)
 * Eğer localhost IP'si varsa, sistem IP'sini döndürür (public IP için async versiyonu kullanın)
 */
export const getRealIpAddressSync = (req: Request): string | undefined => {
  let clientIp: string | undefined;

  // 1. X-Forwarded-For header'ını kontrol et
  const forwardedFor = req.headers['x-forwarded-for'];
  if (forwardedFor) {
    const ips = Array.isArray(forwardedFor) ? forwardedFor[0] : forwardedFor;
    const firstIp = ips.split(',')[0].trim();
    if (firstIp && !isLocalhost(firstIp)) {
      return firstIp;
    }
    clientIp = firstIp;
  }

  // 2. X-Real-IP header'ını kontrol et
  const realIp = req.headers['x-real-ip'];
  if (realIp) {
    const ip = Array.isArray(realIp) ? realIp[0] : realIp;
    const trimmedIp = ip.trim();
    if (trimmedIp && !isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 3. CF-Connecting-IP header'ını kontrol et
  const cfIp = req.headers['cf-connecting-ip'];
  if (cfIp) {
    const ip = Array.isArray(cfIp) ? cfIp[0] : cfIp;
    const trimmedIp = ip.trim();
    if (trimmedIp && !isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 4. req.ip kullan
  if (req.ip) {
    const trimmedIp = req.ip.trim();
    if (!isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 5. socket.remoteAddress kullan
  if (req.socket && req.socket.remoteAddress) {
    const trimmedIp = req.socket.remoteAddress.trim();
    if (!isLocalhost(trimmedIp)) {
      return trimmedIp;
    }
    if (!clientIp) clientIp = trimmedIp;
  }

  // 6. Localhost ise sistem IP'sini döndür
  if (isLocalhost(clientIp)) {
    const systemIp = getSystemIpAddress();
    if (systemIp && !isLocalhost(systemIp)) {
      return systemIp;
    }
    return clientIp || '127.0.0.1';
  }

  return clientIp;
};
