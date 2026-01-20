import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllDepots,
  getDepotById,
  createDepot,
  updateDepot,
  deleteDepot,
} from '../services/depotService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const getAllDepotsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const depots = await getAllDepots(req.user?.id, req.user?.role);
    res.json({ success: true, data: depots });
  } catch (error) {
    next(error);
  }
};

export const getDepotByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const depot = await getDepotById(parseInt(id, 10));
    res.json({ success: true, data: depot });
  } catch (error) {
    next(error);
  }
};

export const createDepotController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const depotData = req.body;
    const newDepot = await createDepot(depotData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Depot',
        entity_id: newDepot.id,
        new_values: { name: newDepot.name, code: newDepot.code },
      },
      req
    );

    res.status(201).json({ success: true, data: newDepot });
  } catch (error) {
    next(error);
  }
};

export const updateDepotController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const depotId = parseInt(id, 10);

    const oldDepot = await getDepotById(depotId);
    const depotData = req.body;
    const updatedDepot = await updateDepot(depotId, depotData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Depot',
        entity_id: depotId,
        old_values: oldDepot,
        new_values: updatedDepot,
      },
      req
    );

    res.json({ success: true, data: updatedDepot });
  } catch (error) {
    next(error);
  }
};

export const deleteDepotController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const depotId = parseInt(id, 10);

    const oldDepot = await getDepotById(depotId);
    await deleteDepot(depotId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'Depot',
        entity_id: depotId,
        old_values: oldDepot,
      },
      req
    );

    res.json({ success: true, message: 'Depo silindi' });
  } catch (error) {
    next(error);
  }
};
