import { Response, NextFunction } from 'express';
import { AuthRequest } from './auth';
import { ForbiddenError } from '../utils/errors';
import { query } from '../config/database';

export const checkDepotAccess = async (
  req: AuthRequest,
  _res: Response,
  next: NextFunction
) => {
  try {
    if (!req.user) {
      throw new ForbiddenError('Kullanıcı bilgisi bulunamadı');
    }

    // Admin tüm depoları görebilir
    if (req.user.role === 'Admin') {
      return next();
    }

    const depotId = req.params.depotId || req.body.depot_id || req.query.depot_id;

    if (!depotId) {
      return next();
    }

    // Kullanıcının bu depoya erişimi var mı kontrol et
    const userDepots = await query<{ depot_id: number }>(
      `SELECT depot_id FROM User_Depots WHERE user_id = @userId AND depot_id = @depotId`,
      {
        userId: req.user.id,
        depotId: parseInt(depotId as string, 10),
      }
    );

    if (userDepots.length === 0) {
      throw new ForbiddenError('Bu depoya erişim yetkiniz yok');
    }

    next();
  } catch (error) {
    next(error);
  }
};
