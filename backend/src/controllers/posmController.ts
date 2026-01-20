import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllPOSM,
  getPOSMById,
  getPOSMStock,
  createPOSM,
  updatePOSM,
  updatePOSMStock,
  deletePOSM,
} from '../services/posmService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';
import { query } from '../config/database';

export const getAllPOSMController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const depotId = req.query.depot_id
      ? parseInt(req.query.depot_id as string, 10)
      : undefined;
    const posms = await getAllPOSM(depotId);
    res.json({ success: true, data: posms });
  } catch (error) {
    next(error);
  }
};

export const getPOSMByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const posm = await getPOSMById(parseInt(id, 10));
    res.json({ success: true, data: posm });
  } catch (error) {
    next(error);
  }
};

export const getPOSMStockController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const stock = await getPOSMStock(parseInt(id, 10));
    res.json({ success: true, data: stock });
  } catch (error) {
    next(error);
  }
};

export const createPOSMController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const posmData = req.body;
    const newPOSM = await createPOSM(posmData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'POSM',
        entity_id: newPOSM.id,
        new_values: { name: newPOSM.name, depot_id: newPOSM.depot_id },
      },
      req
    );

    res.status(201).json({ success: true, data: newPOSM });
  } catch (error) {
    next(error);
  }
};

export const updatePOSMController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const posmId = parseInt(id, 10);

    const oldPOSM = await getPOSMById(posmId);
    const posmData = req.body;
    const updatedPOSM = await updatePOSM(posmId, posmData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'POSM',
        entity_id: posmId,
        old_values: oldPOSM,
        new_values: updatedPOSM,
      },
      req
    );

    res.json({ success: true, data: updatedPOSM });
  } catch (error) {
    next(error);
  }
};

export const updatePOSMStockController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const posmId = parseInt(id, 10);

    const oldPOSM = await getPOSMById(posmId);
    const stockData = req.body;
    const updatedPOSM = await updatePOSMStock(posmId, stockData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'POSM',
        entity_id: posmId,
        old_values: { hazir_adet: oldPOSM.hazir_adet, tamir_bekleyen: oldPOSM.tamir_bekleyen },
        new_values: { hazir_adet: updatedPOSM.hazir_adet, tamir_bekleyen: updatedPOSM.tamir_bekleyen },
      },
      req
    );

    res.json({ success: true, data: updatedPOSM });
  } catch (error) {
    next(error);
  }
};

export const bulkInsertPosmToAllDepotsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    // POSM listesi
    const POSM_LIST = [
      '88X35 ATLAS',
      '100X35 ATLAS',
      '100X50 ATLAS',
      '130X35 ATLAS',
      '130X50 ATLAS',
      'Armada 90x35',
      'Armada 100x35',
      'Armada 100x50',
      'Armada 130x35',
      'Armada 130x50',
      'Armada 170x50',
      'Mini Atlas 88-100\'lük',
      'Mini Atlas 130\'luk',
      'AF 8\'li',
      'Af 12\'li',
      'INOVA 100x100/ 100x85',
      'Smart Unit',
      'Millenium',
      'MCOU',
      'LOCAL COU',
      'C4 COU',
      'PM Küçük',
      'PM Orta',
      'Pm Büyük',
      'Ezd Küçük',
      'Ezd Orta',
      'Ezd Büyük',
      'Arcadia',
      'Midway 12\'li 100\'lük',
      'Midway 130\'luk',
      'Diğer',
    ];


    // Tüm aktif depoları getir
    const depots = await query<any>(
      `SELECT id, name, code 
       FROM Depots 
       WHERE is_active = 1 
       ORDER BY name`
    );

    if (depots.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Aktif depo bulunamadı',
      });
    }

    let totalInserted = 0;
    let totalSkipped = 0;
    let totalErrors = 0;
    const errors: string[] = [];
    const depotResults: Array<{ depot_id: number; depot_name: string; inserted: number; skipped: number; errors: number }> = [];

    // Her depo için POSM'leri ekle
    for (const depot of depots) {
      let depotInserted = 0;
      let depotSkipped = 0;
      let depotErrors = 0;

      for (const posmName of POSM_LIST) {
        try {
          // Bu depoda bu POSM zaten var mı kontrol et
          const existing = await query(
            `SELECT id FROM POSM 
             WHERE name = @name AND depot_id = @depotId`,
            { name: posmName, depotId: depot.id }
          );

          if (existing.length > 0) {
            totalSkipped++;
            depotSkipped++;
            continue;
          }

          // POSM'i ekle
          await query(
            `INSERT INTO POSM (name, description, depot_id, hazir_adet, tamir_bekleyen, revize_adet, is_active)
             VALUES (@name, @description, @depotId, @hazirAdet, @tamirBekleyen, @revizeAdet, 1)`,
            {
              name: posmName,
              description: null,
              depotId: depot.id,
              hazirAdet: 0,
              tamirBekleyen: 0,
              revizeAdet: 0,
            }
          );

          totalInserted++;
          depotInserted++;
        } catch (error: any) {
          // Detaylı hata mesajı oluştur
          let errorMsg = `${depot.name} (${depot.code}) - ${posmName}: `;
          
          if (error.message) {
            errorMsg += error.message;
          } else if (error.originalError?.message) {
            errorMsg += error.originalError.message;
          } else {
            errorMsg += JSON.stringify(error);
          }
          
          // SQL hatası detayları varsa ekle
          if (error.originalError?.info) {
            errorMsg += ` (SQL Info: ${error.originalError.info.message || ''})`;
          }
          
          console.error(`[POSM Bulk Insert] ${errorMsg}`);
          console.error(`[POSM Bulk Insert] Full Error:`, error);
          
          errors.push(errorMsg);
          totalErrors++;
          depotErrors++;
        }
      }

      depotResults.push({
        depot_id: depot.id,
        depot_name: depot.name,
        inserted: depotInserted,
        skipped: depotSkipped,
        errors: depotErrors,
      });
    }

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'POSM',
        new_values: { 
          bulk_insert: true, 
          action: 'Tüm depolar için POSM eklendi',
          total_inserted: totalInserted,
          total_skipped: totalSkipped,
          total_depots: depots.length,
        },
      },
      req
    );

    return res.json({
      success: true,
      message: totalErrors === 0 
        ? 'Tüm depolar için POSM\'ler başarıyla eklendi'
        : `POSM'ler eklendi, ancak ${totalErrors} hata oluştu`,
      data: {
        total_inserted: totalInserted,
        total_skipped: totalSkipped,
        total_errors: totalErrors,
        total_depots: depots.length,
        depot_results: depotResults,
        errors: errors.length > 0 ? errors.slice(0, 50) : [], // İlk 50 hatayı göster
      },
    });
  } catch (error) {
    return next(error);
  }
};

export const deletePOSMController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const posmId = parseInt(id, 10);

    const oldPOSM = await getPOSMById(posmId);
    await deletePOSM(posmId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'POSM',
        entity_id: posmId,
        old_values: oldPOSM,
      },
      req
    );

    res.json({ success: true, message: 'POSM silindi' });
  } catch (error) {
    next(error);
  }
};
