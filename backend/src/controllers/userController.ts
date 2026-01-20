import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  getUserDepots,
  assignDepotToUser,
  removeDepotFromUser,
} from '../services/userService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';
import { sendWelcomeEmail } from '../services/emailService';
import { getDepotById } from '../services/depotService';

export const getAllUsersController = async (
  _req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const users = await getAllUsers();
    res.json({ success: true, data: users });
  } catch (error) {
    next(error);
  }
};

export const getUserByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const user = await getUserById(parseInt(id, 10));
    res.json({ success: true, data: user });
  } catch (error) {
    next(error);
  }
};

export const createUserController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const userData = req.body;
    const { depot_ids, ...userCreateData } = userData;
    
    // Şifreyi email için sakla (hash'lenmeden önce)
    const plainPassword = userCreateData.password;
    
    const newUser = await createUser(userCreateData);

    // Depo atamaları ve depo adlarını topla
    const depotNames: string[] = [];
    if (depot_ids && Array.isArray(depot_ids)) {
      for (const depotId of depot_ids) {
        await assignDepotToUser(newUser.id, depotId);
        
        // Depo adını al
        try {
          const depot = await getDepotById(depotId);
          depotNames.push(depot.name);
        } catch (error) {
          // Depo bulunamazsa atla
          console.error(`[USER] Depo bulunamadı: ${depotId}`, error);
        }
      }
    }

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'User',
        entity_id: newUser.id,
        new_values: { email: newUser.email, name: newUser.name, role: newUser.role, depot_ids },
      },
      req
    );

    // Hoşgeldin emaili gönder (asenkron, hata vermemeli)
    try {
      await sendWelcomeEmail({
        userEmail: newUser.email,
        userName: newUser.name,
        password: plainPassword,
        role: newUser.role,
        depotNames: depotNames.length > 0 ? depotNames : [],
      });
    } catch (emailError: any) {
      // Email hatası kullanıcı oluşturmayı engellememeli
      console.error('[USER] Hoşgeldin emaili gönderme hatası:', {
        message: emailError?.message,
        code: emailError?.code,
        response: emailError?.response,
        stack: emailError?.stack,
      });
    }

    res.status(201).json({ success: true, data: newUser });
  } catch (error) {
    next(error);
  }
};

export const updateUserController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id, 10);

    // Eski değerleri al
    const oldUser = await getUserById(userId);

    const userData = req.body;
    const { depot_ids, ...userUpdateData } = userData;
    const updatedUser = await updateUser(userId, userUpdateData);

    // Depo atamalarını güncelle
    if (depot_ids !== undefined && Array.isArray(depot_ids)) {
      // Mevcut depo atamalarını al
      const currentDepots = await getUserDepots(userId);
      const currentDepotIds = currentDepots.map((d: any) => d.id);

      // Kaldırılacak depo atamaları
      for (const depotId of currentDepotIds) {
        if (!depot_ids.includes(depotId)) {
          await removeDepotFromUser(userId, depotId);
        }
      }

      // Yeni depo atamaları
      for (const depotId of depot_ids) {
        if (!currentDepotIds.includes(depotId)) {
          await assignDepotToUser(userId, depotId);
        }
      }
    }

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'User',
        entity_id: userId,
        old_values: oldUser,
        new_values: { ...updatedUser, depot_ids },
      },
      req
    );

    res.json({ success: true, data: updatedUser });
  } catch (error) {
    next(error);
  }
};

export const deleteUserController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const userId = parseInt(id, 10);

    const oldUser = await getUserById(userId);
    await deleteUser(userId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'User',
        entity_id: userId,
        old_values: oldUser,
      },
      req
    );

    res.json({ success: true, message: 'Kullanıcı silindi' });
  } catch (error) {
    next(error);
  }
};

export const getUserDepotsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const depots = await getUserDepots(parseInt(id, 10));
    res.json({ success: true, data: depots });
  } catch (error) {
    next(error);
  }
};

export const assignDepotController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const { depot_id } = req.body;
    await assignDepotToUser(parseInt(id, 10), depot_id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'User',
        entity_id: parseInt(id, 10),
        new_values: { depot_assigned: depot_id },
      },
      req
    );

    res.json({ success: true, message: 'Depo atandı' });
  } catch (error) {
    next(error);
  }
};

export const removeDepotController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id, depotId } = req.params;
    await removeDepotFromUser(parseInt(id, 10), parseInt(depotId, 10));

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'User',
        entity_id: parseInt(id, 10),
        new_values: { depot_removed: depotId },
      },
      req
    );

    res.json({ success: true, message: 'Depo kaldırıldı' });
  } catch (error) {
    next(error);
  }
};
