import crypto from 'crypto';
import jwt, { SignOptions } from 'jsonwebtoken';
import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { config } from '../config/env';

export interface TokenData {
  id: number;
  user_id: number;
  token_hash: string;
  token_jti: string;
  expires_at: Date;
  is_revoked: boolean;
  created_at: Date;
}

// Token hash'ini oluştur
const hashToken = (token: string): string => {
  return crypto.createHash('sha256').update(token).digest('hex');
};

// JWT ID (jti) oluştur
const generateJTI = (): string => {
  return crypto.randomBytes(16).toString('hex');
};

// Token'ı veritabanına kaydet
export const saveToken = async (
  userId: number,
  token: string,
  jti: string,
  expiresAt: Date,
  ipAddress?: string,
  userAgent?: string
): Promise<void> => {
  const tokenHash = hashToken(token);

  await query(
    `INSERT INTO User_Tokens (user_id, token_hash, token_jti, expires_at, ip_address, user_agent)
     VALUES (@userId, @tokenHash, @jti, @expiresAt, @ipAddress, @userAgent)`,
    {
      userId,
      tokenHash,
      jti,
      expiresAt,
      ipAddress: ipAddress || null,
      userAgent: userAgent || null,
    }
  );
};

// Token'ın geçerli olup olmadığını kontrol et
export const isTokenValid = async (token: string): Promise<boolean> => {
  try {
    const tokenHash = hashToken(token);
    
    const tokens = await query<TokenData>(
      `SELECT id, user_id, token_hash, token_jti, expires_at, is_revoked
       FROM User_Tokens
       WHERE token_hash = @tokenHash`,
      { tokenHash }
    );

    if (tokens.length === 0) {
      // Token veritabanında yok - bu yeni token sistemi için normal olabilir
      // Eski token'lar için false döndür, yeni token'lar için true
      // Şimdilik eski token'ları da kabul edelim (geriye dönük uyumluluk)
      return true;
    }

    const tokenData = tokens[0];

    // Token iptal edilmiş mi?
    if (tokenData.is_revoked) {
      return false;
    }

    // Token süresi dolmuş mu?
    if (new Date(tokenData.expires_at) < new Date()) {
      return false;
    }

    return true;
  } catch (error: any) {
    // User_Tokens tablosu yoksa veya başka bir hata varsa, hatayı yukarı fırlat
    // Bu şekilde middleware'de handle edebiliriz
    if (error.message && error.message.includes('Invalid object name')) {
      throw error; // Tablo yoksa hatayı fırlat
    }
    console.error('[TOKEN] Token doğrulama hatası:', error);
    throw error; // Diğer hataları da fırlat
  }
};

// Token'ı iptal et (revoke)
export const revokeToken = async (token: string): Promise<void> => {
  const tokenHash = hashToken(token);

  await query(
    `UPDATE User_Tokens
     SET is_revoked = 1, revoked_at = ${getTurkeyDateSQL()}
     WHERE token_hash = @tokenHash AND is_revoked = 0`,
    { tokenHash }
  );
};

// Kullanıcının tüm token'larını iptal et
export const revokeAllUserTokens = async (userId: number): Promise<void> => {
  await query(
    `UPDATE User_Tokens
     SET is_revoked = 1, revoked_at = ${getTurkeyDateSQL()}
     WHERE user_id = @userId AND is_revoked = 0`,
    { userId }
  );
};

// JTI ile token'ı iptal et
export const revokeTokenByJTI = async (jti: string): Promise<void> => {
  await query(
    `UPDATE User_Tokens
     SET is_revoked = 1, revoked_at = ${getTurkeyDateSQL()}
     WHERE token_jti = @jti AND is_revoked = 0`,
    { jti }
  );
};

// Süresi dolmuş token'ları temizle
export const cleanExpiredTokens = async (): Promise<void> => {
  try {
    await query(
      `DELETE FROM User_Tokens 
       WHERE (expires_at < ${getTurkeyDateSQL()} AND is_revoked = 1)
          OR (expires_at < DATEADD(DAY, -30, ${getTurkeyDateSQL()}))`
    );
    console.log(`[TOKEN] Eski tokenlar temizlendi`);
  } catch (error) {
    console.error('[TOKEN] Token temizleme hatasi:', error);
  }
};

// Token oluştur ve kaydet
export const createAndSaveToken = async (
  user: { id: number; email: string; name: string; role: string },
  ipAddress?: string,
  userAgent?: string
): Promise<{ token: string; jti: string; expiresAt: Date }> => {
  const jti = generateJTI();
  
  // JWT token oluştur (jti claim'i ile)
  const token = jwt.sign(
    {
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      jti: jti, // JWT ID - token'ı benzersiz olarak tanımlamak için
    },
    config.jwt.secret,
    {
      expiresIn: config.jwt.expiresIn as string | number,
    } as SignOptions
  );

  // Token süresini hesapla
  const expiresInSeconds = parseExpiresIn(config.jwt.expiresIn);
  const expiresAt = new Date(Date.now() + expiresInSeconds * 1000);

  // Token'ı veritabanına kaydet
  await saveToken(user.id, token, jti, expiresAt, ipAddress, userAgent);

  return { token, jti, expiresAt };
};

// expiresIn string'ini saniyeye çevir (örn: "2d" -> 172800)
const parseExpiresIn = (expiresIn: string): number => {
  const match = expiresIn.match(/^(\d+)([smhd])$/);
  if (!match) {
    return 2 * 24 * 60 * 60; // Default: 2 gün
  }

  const value = parseInt(match[1], 10);
  const unit = match[2];

  switch (unit) {
    case 's':
      return value;
    case 'm':
      return value * 60;
    case 'h':
      return value * 60 * 60;
    case 'd':
      return value * 24 * 60 * 60;
    default:
      return 2 * 24 * 60 * 60;
  }
};

// Token'dan JTI'yi çıkar
export const getJTIFromToken = (token: string): string | null => {
  try {
    const decoded = jwt.decode(token) as any;
    return decoded?.jti || null;
  } catch (error) {
    return null;
  }
};
