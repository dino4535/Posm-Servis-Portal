import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config/env';
import { UnauthorizedError } from '../utils/errors';
import { isTokenValid } from '../services/tokenService';

export interface AuthRequest extends Request {
  user?: {
    id: number;
    email: string;
    name: string;
    role: string;
  };
}

export const authenticate = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // OPTIONS isteklerini (CORS preflight) atla
    if (req.method === 'OPTIONS') {
      return next();
    }

    // Authorization header'ını farklı yerlerden kontrol et
    const authHeader = req.headers.authorization || 
                       req.headers['Authorization'] || 
                       req.headers['authorization'] ||
                       (req.headers as any)['Authorization'];

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.error('[AUTH] Token bulunamadı - Header:', authHeader);
      throw new UnauthorizedError('Token bulunamadı');
    }

    const token = authHeader.substring(7);
    
    // Önce JWT imzasını doğrula
    const decoded = jwt.verify(token, config.jwt.secret) as any;

    // Token'ın veritabanında geçerli olup olmadığını kontrol et
    // Eğer User_Tokens tablosu yoksa veya hata oluşursa, sadece JWT doğrulaması yeterli
    try {
      const isValid = await isTokenValid(token);
      if (!isValid) {
        console.error('[AUTH] Token veritabanında geçersiz veya iptal edilmiş');
        throw new UnauthorizedError('Token geçersiz veya iptal edilmiş');
      }
    } catch (tokenError: any) {
      // User_Tokens tablosu yoksa veya başka bir DB hatası varsa, sadece uyarı ver
      // Bu, geriye dönük uyumluluk için önemli (tablo henüz oluşturulmamış olabilir)
      if (tokenError.message && tokenError.message.includes('Invalid object name')) {
        console.warn('[AUTH] User_Tokens tablosu bulunamadı, sadece JWT doğrulaması yapılıyor');
      } else {
        console.error('[AUTH] Token doğrulama hatası:', tokenError);
        throw new UnauthorizedError('Token doğrulanamadı');
      }
    }

    req.user = {
      id: decoded.id,
      email: decoded.email,
      name: decoded.name,
      role: decoded.role,
    };

    console.log('[AUTH] Token doğrulandı - User:', req.user.email);
    next();
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      console.error('[AUTH] JWT hatası:', error.message);
      throw new UnauthorizedError('Geçersiz token');
    }
    console.error('[AUTH] Genel hata:', error);
    throw error;
  }
};
