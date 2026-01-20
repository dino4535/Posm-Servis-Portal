import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import { bulkImportDealers } from '../services/bulkDealerImportService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

export const bulkImportDealersController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Excel dosyası yüklenmedi',
      });
    }

    const result = await bulkImportDealers(req.file.buffer);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Dealer',
        new_values: {
          bulk_import: true,
          total: result.total,
          created: result.created,
          skipped: result.skipped,
        },
      },
      req
    );

    return res.json({
      success: true,
      data: result,
    });
  } catch (error) {
    return next(error);
  }
};
