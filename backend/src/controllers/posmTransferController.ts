import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllTransfers,
  getTransferById,
  createTransfer,
  approveTransfer,
  completeTransfer,
  cancelTransfer,
} from '../services/posmTransferService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const getAllTransfersController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const depotId = req.query.depot_id
      ? parseInt(req.query.depot_id as string, 10)
      : undefined;
    const status = req.query.status as string | undefined;

    const transfers = await getAllTransfers(depotId, status);

    res.json({ success: true, data: transfers });
  } catch (error) {
    next(error);
  }
};

export const getTransferByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const transfer = await getTransferById(parseInt(id, 10));

    res.json({ success: true, data: transfer });
  } catch (error) {
    next(error);
  }
};

export const createTransferController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // Tip dönüşümleri - güvenlik için
    const transferData = {
      posm_id: parseInt(req.body.posm_id, 10),
      from_depot_id: parseInt(req.body.from_depot_id, 10),
      to_depot_id: parseInt(req.body.to_depot_id, 10),
      quantity: parseInt(req.body.quantity, 10),
      transfer_type: req.body.transfer_type,
      notes: req.body.notes || null,
    };
    
    const transfer = await createTransfer(transferData, req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'POSMTransfer',
        entity_id: transfer.id,
        new_values: {
          posm_id: transfer.posm_id,
          from_depot_id: transfer.from_depot_id,
          to_depot_id: transfer.to_depot_id,
          quantity: transfer.quantity,
        },
      },
      req
    );

    res.status(201).json({ success: true, data: transfer });
  } catch (error) {
    next(error);
  }
};

export const approveTransferController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const transfer = await approveTransfer(parseInt(id, 10), req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'POSMTransfer',
        entity_id: parseInt(id, 10),
        new_values: { status: transfer.status, approved_by: transfer.approved_by },
      },
      req
    );

    res.json({ success: true, data: transfer });
  } catch (error) {
    next(error);
  }
};

export const completeTransferController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const transfer = await completeTransfer(parseInt(id, 10), req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'POSMTransfer',
        entity_id: parseInt(id, 10),
        new_values: { status: transfer.status, completed_at: transfer.completed_at },
      },
      req
    );

    res.json({ success: true, data: transfer });
  } catch (error) {
    next(error);
  }
};

export const cancelTransferController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const transfer = await cancelTransfer(parseInt(id, 10), req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'POSMTransfer',
        entity_id: parseInt(id, 10),
        new_values: { status: transfer.status },
      },
      req
    );

    res.json({ success: true, data: transfer });
  } catch (error) {
    next(error);
  }
};
