import { Request, Response, NextFunction } from 'express';
import { login, logout, logoutAllSessions } from '../services/authService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';
import { AuthRequest } from '../middleware/auth';
import { getRealIpAddress } from '../utils/ip_helper';

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
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      await logout(token);

      // Audit log
      try {
        const realIp = await getRealIpAddress(req);
        await createAuditLog(
          {
            user_id: req.user!.id,
            action: AUDIT_ACTIONS.LOGOUT,
            ip_address: realIp,
            user_agent: req.get('user-agent'),
          },
          req
        );
      } catch (auditError) {
        console.error('Audit log hatası:', auditError);
      }
    }

    res.json({
      success: true,
      message: 'Çıkış yapıldı',
    });
  } catch (error) {
    next(error);
  }
};

export const logoutAllController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    await logoutAllSessions(req.user!.id);

    // Audit log
    try {
      const realIp = await getRealIpAddress(req);
      await createAuditLog(
        {
          user_id: req.user!.id,
          action: AUDIT_ACTIONS.LOGOUT,
          ip_address: realIp,
          user_agent: req.get('user-agent'),
        },
        req
      );
    } catch (auditError) {
      console.error('Audit log hatası:', auditError);
    }

    res.json({
      success: true,
      message: 'Tüm oturumlar kapatıldı',
    });
  } catch (error) {
    next(error);
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
