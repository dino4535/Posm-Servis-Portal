import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllRequests,
  getRequestById,
  createRequest,
  updateRequest,
  planRequest,
  completeRequest,
  cancelRequest,
  getDashboardCounts,
  deleteRequest,
} from '../services/requestService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const getAllRequestsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const filters: any = {};
    if (req.query.user_id) filters.user_id = parseInt(req.query.user_id as string, 10);
    if (req.query.depot_id) filters.depot_id = parseInt(req.query.depot_id as string, 10);
    if (req.query.territory_id) filters.territory_id = parseInt(req.query.territory_id as string, 10);
    if (req.query.dealer_id) filters.dealer_id = parseInt(req.query.dealer_id as string, 10);
    if (req.query.durum) filters.durum = req.query.durum as string;
    if (req.query.yapilacak_is) filters.yapilacak_is = req.query.yapilacak_is as string;
    if (req.query.start_date) filters.start_date = req.query.start_date as string;
    if (req.query.end_date) filters.end_date = req.query.end_date as string;
    if (req.query.priority) filters.priority = parseInt(req.query.priority as string, 10);

    const requests = await getAllRequests(
      Object.keys(filters).length > 0 ? filters : undefined,
      req.user?.id,
      req.user?.role
    );
    res.json({ success: true, data: requests });
  } catch (error) {
    next(error);
  }
};

export const getRequestByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const request = await getRequestById(
      parseInt(id, 10),
      req.user?.id,
      req.user?.role
    );
    res.json({ success: true, data: request });
  } catch (error) {
    next(error);
  }
};

export const createRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const requestData = {
      ...req.body,
      user_id: req.user!.id,
      depot_id: typeof req.body.depot_id === 'string' ? parseInt(req.body.depot_id, 10) : req.body.depot_id,
      territory_id: typeof req.body.territory_id === 'string' ? parseInt(req.body.territory_id, 10) : req.body.territory_id,
      dealer_id: typeof req.body.dealer_id === 'string' ? parseInt(req.body.dealer_id, 10) : req.body.dealer_id,
      posm_id: req.body.posm_id ? (typeof req.body.posm_id === 'string' ? parseInt(req.body.posm_id, 10) : req.body.posm_id) : null,
      priority: typeof req.body.priority === 'string' ? parseInt(req.body.priority, 10) : (req.body.priority || 0),
    };
    const newRequest = await createRequest(requestData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Request',
        entity_id: newRequest.id,
        new_values: { request_no: newRequest.request_no, durum: newRequest.durum },
      },
      req
    );

    res.status(201).json({ success: true, data: newRequest });
  } catch (error) {
    next(error);
  }
};

export const updateRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const requestId = parseInt(id, 10);

    // Yetkilendirme kontrolü için önce talebi kontrol et
    await getRequestById(requestId, req.user?.id, req.user?.role);
    
    const oldRequest = await getRequestById(requestId);
    const requestData = req.body;
    const updatedRequest = await updateRequest(requestId, requestData, req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Request',
        entity_id: requestId,
        old_values: oldRequest,
        new_values: updatedRequest,
      },
      req
    );

    res.json({ success: true, data: updatedRequest });
  } catch (error) {
    next(error);
  }
};

export const planRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const requestId = parseInt(id, 10);
    const { planlanan_tarih } = req.body;

    if (!planlanan_tarih) {
      return res.status(400).json({
        success: false,
        error: 'Planlanan tarih gereklidir',
      });
    }

    // Yetkilendirme kontrolü
    await getRequestById(requestId, req.user?.id, req.user?.role);

    const request = await planRequest(
      requestId,
      planlanan_tarih,
      req.user!.id
    );

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Request',
        entity_id: parseInt(id, 10),
        new_values: { durum: request.durum, planlanan_tarih: request.planlanan_tarih },
      },
      req
    );

    return res.json({ success: true, data: request });
  } catch (error) {
    return next(error);
  }
};

export const completeRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const requestId = parseInt(id, 10);
    const { notes } = req.body; // Notlar body'den alınıyor

    // Yetkilendirme kontrolü
    await getRequestById(requestId, req.user?.id, req.user?.role);

    const request = await completeRequest(requestId, req.user!.id, notes);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Request',
        entity_id: parseInt(id, 10),
        new_values: { 
          durum: request.durum, 
          tamamlanma_tarihi: request.tamamlanma_tarihi,
          notes: notes ? 'Not eklendi' : undefined,
        },
      },
      req
    );

    res.json({ success: true, data: request });
  } catch (error) {
    next(error);
  }
};

export const getDashboardCountsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const counts = await getDashboardCounts(req.user!.id, req.user!.role);
    res.json({ success: true, data: counts });
  } catch (error) {
    next(error);
  }
};

export const cancelRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const requestId = parseInt(id, 10);

    // Yetkilendirme kontrolü
    await getRequestById(requestId, req.user?.id, req.user?.role);

    const oldRequest = await getRequestById(requestId);
    const request = await cancelRequest(requestId, req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'Request',
        entity_id: requestId,
        old_values: { durum: oldRequest.durum },
        new_values: { durum: request.durum },
      },
      req
    );

    res.json({ success: true, data: request });
  } catch (error) {
    next(error);
  }
};

export const deleteRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const requestId = parseInt(id, 10);

    // Yetkilendirme kontrolü (Admin tüm talepleri silebilir)
    if (req.user?.role !== 'Admin') {
      await getRequestById(requestId, req.user?.id, req.user?.role);
    }

    const oldRequest = await getRequestById(requestId);
    await deleteRequest(requestId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'Request',
        entity_id: requestId,
        old_values: oldRequest,
      },
      req
    );

    res.json({ success: true, message: 'Talep silindi' });
  } catch (error) {
    next(error);
  }
};
