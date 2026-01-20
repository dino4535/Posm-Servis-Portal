import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllTerritories,
  getTerritoryById,
  createTerritory,
  updateTerritory,
  deleteTerritory,
} from '../services/territoryService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const getAllTerritoriesController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const depotId = req.query.depot_id
      ? parseInt(req.query.depot_id as string, 10)
      : undefined;
    const territories = await getAllTerritories(depotId);
    res.json({ success: true, data: territories });
  } catch (error) {
    next(error);
  }
};

export const getTerritoryByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const territory = await getTerritoryById(parseInt(id, 10));
    res.json({ success: true, data: territory });
  } catch (error) {
    next(error);
  }
};

export const createTerritoryController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const territoryData = req.body;
    const newTerritory = await createTerritory(territoryData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Territory',
        entity_id: newTerritory.id,
        new_values: { name: newTerritory.name, code: newTerritory.code },
      },
      req
    );

    res.status(201).json({ success: true, data: newTerritory });
  } catch (error) {
    next(error);
  }
};

export const updateTerritoryController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const territoryId = parseInt(id, 10);

    const oldTerritory = await getTerritoryById(territoryId);
    const territoryData = req.body;
    const updatedTerritory = await updateTerritory(territoryId, territoryData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Territory',
        entity_id: territoryId,
        old_values: oldTerritory,
        new_values: updatedTerritory,
      },
      req
    );

    res.json({ success: true, data: updatedTerritory });
  } catch (error) {
    next(error);
  }
};

export const deleteTerritoryController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const territoryId = parseInt(id, 10);

    const oldTerritory = await getTerritoryById(territoryId);
    await deleteTerritory(territoryId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'Territory',
        entity_id: territoryId,
        old_values: oldTerritory,
      },
      req
    );

    res.json({ success: true, message: 'Territory silindi' });
  } catch (error) {
    next(error);
  }
};
