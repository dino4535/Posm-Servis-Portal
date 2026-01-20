import { Request, Response, NextFunction } from 'express';
import { login, logout, logoutAllSessions, comparePassword, hashPassword } from '../services/authService';
import { getRealIpAddress } from '../utils/ip_helper';
import { AuthRequest } from '../middleware/auth';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';
import { getUserById, updateUser } from '../services/userService';
import { getTurkeyDateSQL } from '../utils/dateHelper';

export const loginController = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { email, password } = req.body;

    console.log('[LOGIN] Login denemesi:', { email, hasPassword: !!password });

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        error: 'E-posta ve şifre gereklidir',
      });
    }

    // IP adresi debug bilgileri
    console.log('[LOGIN] IP Debug:', {
      'x-forwarded-for': req.headers['x-forwarded-for'],
      'x-real-ip': req.headers['x-real-ip'],
      'cf-connecting-ip': req.headers['cf-connecting-ip'],
      'req.ip': req.ip,
      'req.socket.remoteAddress': req.socket?.remoteAddress,
    });
    
    const realIp = await getRealIpAddress(req);
    console.log('[LOGIN] Tespit edilen IP:', realIp);
    
    const result = await login(
      email,
      password,
      realIp,
      req.get('user-agent')
    );
    console.log('[LOGIN] Login başarılı:', { userId: result.user.id, email: result.user.email, ip: realIp });

    // Audit log (login başarılı olduktan sonra)
    try {
      await createAuditLog(
        {
          user_id: result.user.id,
          action: AUDIT_ACTIONS.LOGIN,
          ip_address: realIp,
          user_agent: req.get('user-agent'),
        },
        req as AuthRequest
      );
    } catch (auditError) {
      // Audit log hatası login'i engellememeli
      console.error('Audit log hatası:', auditError);
    }

    return res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};

export const logoutController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const token = req.headers.authorization?.substring(7);
    if (token) {
      await logout(token);
    }

    await createAuditLog(
      {
        user_id: req.user?.id,
        action: AUDIT_ACTIONS.LOGOUT,
      },
      req
    );

    return res.json({ success: true, message: 'Çıkış yapıldı' });
  } catch (error) {
    return next(error);
  }
};

export const logoutAllController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.user?.id) {
      return res.status(401).json({
        success: false,
        error: 'Kullanıcı bilgisi bulunamadı',
      });
    }

    await logoutAllSessions(req.user.id);

    await createAuditLog(
      {
        user_id: req.user.id,
        action: AUDIT_ACTIONS.LOGOUT,
        new_values: { all_sessions: true },
      },
      req
    );

    return res.json({ success: true, message: 'Tüm oturumlar kapatıldı' });
  } catch (error) {
    return next(error);
  }
};

export const meController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { query } = require('../config/database');
    const { id } = req.user!;

    const users = await query(
      `SELECT id, email, name, role, is_active, created_at 
       FROM Users 
       WHERE id = @id`,
      { id }
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Kullanıcı bulunamadı',
      });
    }

    const user = users[0];

    // Kullanıcının depolarını getir
    const depots = await query(
      `SELECT d.id, d.name, d.code 
       FROM Depots d
       INNER JOIN User_Depots ud ON d.id = ud.depot_id
       WHERE ud.user_id = @userId AND d.is_active = 1`,
      { userId: id }
    );

    return res.json({
      success: true,
      data: {
        ...user,
        depots,
      },
    });
  } catch (error) {
    return next(error);
  }
};

// Kullanıcının kendi profilini güncelleme
export const updateProfileController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.user!;
    const { name, email } = req.body;

    const oldUser = await getUserById(id);

    const updateData: any = {};
    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;

    const updatedUser = await updateUser(id, updateData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'User',
        entity_id: id,
        old_values: { name: oldUser.name, email: oldUser.email },
        new_values: { name: updatedUser.name, email: updatedUser.email },
      },
      req
    );

    return res.json({ success: true, data: updatedUser });
  } catch (error) {
    return next(error);
  }
};

// Şifre değiştirme
export const changePasswordController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.user!;
    const { currentPassword, newPassword } = req.body;

    if (!currentPassword || !newPassword) {
      return res.status(400).json({
        success: false,
        error: 'Mevcut şifre ve yeni şifre gereklidir',
      });
    }

    if (newPassword.length < 6) {
      return res.status(400).json({
        success: false,
        error: 'Yeni şifre en az 6 karakter olmalıdır',
      });
    }

    // Kullanıcıyı ve şifre hash'ini al
    const { query } = require('../config/database');
    const users = await query<any>(
      `SELECT id, password_hash FROM Users WHERE id = @id`,
      { id }
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Kullanıcı bulunamadı',
      });
    }

    const user = users[0];

    // Mevcut şifreyi kontrol et
    const isPasswordValid = await comparePassword(currentPassword, user.password_hash);
    if (!isPasswordValid) {
      return res.status(400).json({
        success: false,
        error: 'Mevcut şifre yanlış',
      });
    }

    // Yeni şifreyi hash'le ve güncelle
    const newPasswordHash = await hashPassword(newPassword);
    await query(
      `UPDATE Users SET password_hash = @passwordHash, updated_at = ${getTurkeyDateSQL()} WHERE id = @id`,
      { passwordHash: newPasswordHash, id }
    );

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'User',
        entity_id: id,
        new_values: { password_changed: true },
      },
      req
    );

    return res.json({ success: true, message: 'Şifre başarıyla değiştirildi' });
  } catch (error) {
    return next(error);
  }
};
