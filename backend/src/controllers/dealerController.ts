import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllDealers,
  searchDealers,
  getDealerById,
  createDealer,
  updateDealer,
  deleteDealer,
} from '../services/dealerService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const getAllDealersController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const territoryId = req.query.territory_id
      ? parseInt(req.query.territory_id as string, 10)
      : undefined;
    const depotId = req.query.depot_id
      ? parseInt(req.query.depot_id as string, 10)
      : undefined;
    const page = req.query.page ? parseInt(req.query.page as string, 10) : 1;
    const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : 50;
    const offset = (page - 1) * limit;
    
    const result = await getAllDealers(territoryId, depotId, limit, offset);
    res.json({ 
      success: true, 
      data: result.dealers,
      pagination: {
        page,
        limit,
        total: result.total,
        totalPages: Math.ceil(result.total / limit)
      }
    });
  } catch (error) {
    next(error);
  }
};

export const searchDealersController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { q, territory_id, depot_id, page, limit } = req.query;
    if (!q || typeof q !== 'string') {
      return res.status(400).json({
        success: false,
        error: 'Arama terimi gereklidir',
      });
    }
    const territoryId = territory_id
      ? parseInt(territory_id as string, 10)
      : undefined;
    const depotId = depot_id
      ? parseInt(depot_id as string, 10)
      : undefined;
    const pageNum = page ? parseInt(page as string, 10) : 1;
    const limitNum = limit ? parseInt(limit as string, 10) : 50;
    const offset = (pageNum - 1) * limitNum;
    
    const result = await searchDealers(q, territoryId, depotId, limitNum, offset);
    return res.json({ 
      success: true, 
      data: result.dealers,
      pagination: {
        page: pageNum,
        limit: limitNum,
        total: result.total,
        totalPages: Math.ceil(result.total / limitNum)
      }
    });
  } catch (error) {
    return next(error);
  }
};

export const getDealerByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const dealer = await getDealerById(parseInt(id, 10));
    res.json({ success: true, data: dealer });
  } catch (error) {
    next(error);
  }
};

export const createDealerController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const dealerData = req.body;
    const newDealer = await createDealer(dealerData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Dealer',
        entity_id: newDealer.id,
        new_values: { code: newDealer.code, name: newDealer.name },
      },
      req
    );

    res.status(201).json({ success: true, data: newDealer });
  } catch (error) {
    next(error);
  }
};

export const updateDealerController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const dealerId = parseInt(id, 10);

    const oldDealer = await getDealerById(dealerId);
    const dealerData = req.body;
    const updatedDealer = await updateDealer(dealerId, dealerData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Dealer',
        entity_id: dealerId,
        old_values: oldDealer,
        new_values: updatedDealer,
      },
      req
    );

    res.json({ success: true, data: updatedDealer });
  } catch (error) {
    next(error);
  }
};

export const deleteDealerController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const dealerId = parseInt(id, 10);

    const oldDealer = await getDealerById(dealerId);
    await deleteDealer(dealerId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'Dealer',
        entity_id: dealerId,
        old_values: oldDealer,
      },
      req
    );

    res.json({ success: true, message: 'Dealer silindi' });
  } catch (error) {
    next(error);
  }
};
