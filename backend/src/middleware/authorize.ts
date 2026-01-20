import { Response, NextFunction } from 'express';
import { AuthRequest } from './auth';
import { ForbiddenError } from '../utils/errors';
import { ROLES } from '../config/constants';

export const authorize = (...allowedRoles: string[]) => {
  return (req: AuthRequest, _res: Response, next: NextFunction) => {
    if (!req.user) {
      throw new ForbiddenError('Kullanıcı bilgisi bulunamadı');
    }

    if (!allowedRoles.includes(req.user.role)) {
      throw new ForbiddenError('Bu işlem için yetkiniz yok');
    }

    next();
  };
};

export const isAdmin = authorize(ROLES.ADMIN);
export const isAdminOrTeknik = authorize(ROLES.ADMIN, ROLES.TEKNIK);
export const isAdminOrTeknikOrUser = authorize(ROLES.ADMIN, ROLES.TEKNIK, ROLES.USER);
