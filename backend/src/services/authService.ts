import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { config } from '../config/env';
import { query } from '../config/database';
import { UnauthorizedError } from '../utils/errors';
import { createAndSaveToken, revokeAllUserTokens } from './tokenService';

export interface User {
  id: number;
  email: string;
  password_hash: string;
  name: string;
  role: string;
  is_active: boolean;
}

export const hashPassword = async (password: string): Promise<string> => {
  return bcrypt.hash(password, 10);
};

export const comparePassword = async (
  password: string,
  hash: string
): Promise<boolean> => {
  return bcrypt.compare(password, hash);
};

// Eski token oluşturma fonksiyonu (geriye dönük uyumluluk için)
export const generateToken = (user: { id: number; email: string; name: string; role: string }): string => {
  return jwt.sign(
    {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    },
    config.jwt.secret,
    {
      expiresIn: config.jwt.expiresIn,
    }
  );
};

export const login = async (
  email: string,
  password: string,
  ipAddress?: string,
  userAgent?: string
) => {
  const users = await query<User>(
    `SELECT id, email, password_hash, name, role, is_active 
     FROM Users 
     WHERE email = @email`,
    { email }
  );

  if (users.length === 0) {
    throw new UnauthorizedError('Geçersiz e-posta veya şifre');
  }

  const user = users[0];

  if (!user.is_active) {
    throw new UnauthorizedError('Hesabınız aktif değil');
  }

  const isPasswordValid = await comparePassword(password, user.password_hash);

  if (!isPasswordValid) {
    throw new UnauthorizedError('Geçersiz e-posta veya şifre');
  }

  // parseExpiresIn helper fonksiyonu
  const parseExpiresIn = (expiresIn: string): number => {
    const match = expiresIn.match(/^(\d+)([smhd])$/);
    if (!match) {
      return 2 * 24 * 60 * 60; // Default: 2 gün
    }
    const value = parseInt(match[1], 10);
    const unit = match[2];
    switch (unit) {
      case 's': return value;
      case 'm': return value * 60;
      case 'h': return value * 60 * 60;
      case 'd': return value * 24 * 60 * 60;
      default: return 2 * 24 * 60 * 60;
    }
  };

  // Token oluştur ve veritabanına kaydet
  // Eğer User_Tokens tablosu yoksa, sadece token oluştur (geriye dönük uyumluluk)
  let token: string;
  let expiresAt: Date | undefined;
  
  try {
    const tokenResult = await createAndSaveToken(
      {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
      },
      ipAddress,
      userAgent
    );
    token = tokenResult.token;
    expiresAt = tokenResult.expiresAt;
  } catch (error: any) {
    // User_Tokens tablosu yoksa, eski yöntemle token oluştur
    if (error.message && (error.message.includes('Invalid object name') || error.message.includes('User_Tokens'))) {
      console.warn('[AUTH] User_Tokens tablosu bulunamadı, eski yöntemle token oluşturuluyor');
      token = generateToken({
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
      });
      // expiresAt hesapla
      const expiresInSeconds = parseExpiresIn(config.jwt.expiresIn);
      expiresAt = new Date(Date.now() + expiresInSeconds * 1000);
    } else {
      throw error;
    }
  }

  return {
    token,
    expiresAt,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
    },
  };
};

// Logout - Token'ı iptal et
export const logout = async (token: string): Promise<void> => {
  const tokenService = await import('./tokenService');
  await tokenService.revokeToken(token);
};

// Kullanıcının tüm oturumlarını kapat
export const logoutAllSessions = async (userId: number): Promise<void> => {
  await revokeAllUserTokens(userId);
};
