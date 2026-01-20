import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { NotFoundError, ValidationError } from '../utils/errors';

export interface POSM {
  id: number;
  name: string;
  description?: string;
  depot_id: number;
  hazir_adet: number;
  tamir_bekleyen: number;
  revize_adet: number;
  is_active: boolean;
  created_at: Date;
  updated_at?: Date;
}

export interface CreatePOSMData {
  name: string;
  description?: string;
  depot_id: number;
  hazir_adet?: number;
  tamir_bekleyen?: number;
  revize_adet?: number;
}

export interface UpdatePOSMData {
  name?: string;
  description?: string;
  depot_id?: number;
  hazir_adet?: number;
  tamir_bekleyen?: number;
  revize_adet?: number;
  is_active?: boolean;
}

export interface StockInfo {
  hazir_adet: number;
  tamir_bekleyen: number;
  revize_adet: number;
}

export const getAllPOSM = async (depotId?: number): Promise<any[]> => {
  if (depotId) {
    return query<any>(
      `SELECT p.id, p.name, p.description, p.depot_id, p.hazir_adet, p.tamir_bekleyen, p.revize_adet, p.is_active, p.created_at, p.updated_at,
              d.name as depot_name, d.code as depot_code
       FROM POSM p
       LEFT JOIN Depots d ON p.depot_id = d.id
       WHERE p.depot_id = @depotId AND p.is_active = 1
       ORDER BY p.name`,
      { depotId }
    );
  }

  return query<any>(
    `SELECT p.id, p.name, p.description, p.depot_id, p.hazir_adet, p.tamir_bekleyen, p.revize_adet, p.is_active, p.created_at, p.updated_at,
            d.name as depot_name, d.code as depot_code
     FROM POSM p
     LEFT JOIN Depots d ON p.depot_id = d.id
     WHERE p.is_active = 1
     ORDER BY p.name`
  );
};

export const getPOSMById = async (id: number): Promise<POSM> => {
  const posms = await query<POSM>(
    `SELECT id, name, description, depot_id, hazir_adet, tamir_bekleyen, revize_adet, is_active, created_at, updated_at 
     FROM POSM 
     WHERE id = @id`,
    { id }
  );

  if (posms.length === 0) {
    throw new NotFoundError('POSM');
  }

  return posms[0];
};

export const getPOSMStock = async (id: number): Promise<StockInfo> => {
  const posm = await getPOSMById(id);
  return {
    hazir_adet: posm.hazir_adet,
    tamir_bekleyen: posm.tamir_bekleyen,
    revize_adet: posm.revize_adet || 0,
  };
};

export const createPOSM = async (data: CreatePOSMData): Promise<POSM> => {
  // Depo var mı kontrol et
  const depots = await query(`SELECT id FROM Depots WHERE id = @depotId`, {
    depotId: data.depot_id,
  });
  if (depots.length === 0) {
    throw new NotFoundError('Depo');
  }

  // Name unique kontrolü (depo bazında - aynı depoda aynı isimde POSM olamaz)
  const existing = await query(
    `SELECT id FROM POSM WHERE name = @name AND depot_id = @depotId`,
    { name: data.name, depotId: data.depot_id }
  );
  if (existing.length > 0) {
    throw new ValidationError('Bu depoda bu POSM adı zaten kullanılıyor');
  }

  const result = await query<{ id: number }>(
    `INSERT INTO POSM (name, description, depot_id, hazir_adet, tamir_bekleyen, revize_adet)
     OUTPUT INSERTED.id
     VALUES (@name, @description, @depotId, @hazirAdet, @tamirBekleyen, @revizeAdet)`,
    {
      name: data.name,
      description: data.description || null,
      depotId: data.depot_id,
      hazirAdet: data.hazir_adet || 0,
      tamirBekleyen: data.tamir_bekleyen || 0,
      revizeAdet: data.revize_adet || 0,
    }
  );

  return getPOSMById(result[0].id);
};

export const updatePOSM = async (
  id: number,
  data: UpdatePOSMData
): Promise<POSM> => {
  await getPOSMById(id);

  const updates: string[] = [];
  const params: any = { id };

  if (data.name !== undefined) {
    // Depo ID'si değişiyorsa veya name değişiyorsa kontrol et
    const currentPosm = await getPOSMById(id);
    const checkDepotId = data.depot_id !== undefined ? data.depot_id : currentPosm.depot_id;
    
    const existing = await query(
      `SELECT id FROM POSM WHERE name = @name AND depot_id = @depotId AND id != @id`,
      { name: data.name, depotId: checkDepotId, id }
    );
    if (existing.length > 0) {
      throw new ValidationError('Bu depoda bu POSM adı zaten kullanılıyor');
    }
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.description !== undefined) {
    updates.push('description = @description');
    params.description = data.description;
  }

  if (data.depot_id !== undefined) {
    const depots = await query(`SELECT id FROM Depots WHERE id = @depotId`, {
      depotId: data.depot_id,
    });
    if (depots.length === 0) {
      throw new NotFoundError('Depo');
    }
    updates.push('depot_id = @depotId');
    params.depotId = data.depot_id;
  }

  if (data.hazir_adet !== undefined) {
    if (data.hazir_adet < 0) {
      throw new ValidationError('Hazır adet negatif olamaz');
    }
    updates.push('hazir_adet = @hazirAdet');
    params.hazirAdet = data.hazir_adet;
  }

  if (data.tamir_bekleyen !== undefined) {
    if (data.tamir_bekleyen < 0) {
      throw new ValidationError('Tamir bekleyen adet negatif olamaz');
    }
    updates.push('tamir_bekleyen = @tamirBekleyen');
    params.tamirBekleyen = data.tamir_bekleyen;
  }

  if (data.revize_adet !== undefined) {
    if (data.revize_adet < 0) {
      throw new ValidationError('Revize adet negatif olamaz');
    }
    updates.push('revize_adet = @revizeAdet');
    params.revizeAdet = data.revize_adet;
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getPOSMById(id);
  }

  updates.push(`updated_at = ${getTurkeyDateSQL()}`);

  await query(
    `UPDATE POSM 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getPOSMById(id);
};

export const updatePOSMStock = async (
  id: number,
  stockData: { hazir_adet?: number; tamir_bekleyen?: number; revize_adet?: number }
): Promise<POSM> => {
  const updates: string[] = [];
  const params: any = { id };

  if (stockData.hazir_adet !== undefined) {
    if (stockData.hazir_adet < 0) {
      throw new ValidationError('Hazır adet negatif olamaz');
    }
    updates.push('hazir_adet = @hazirAdet');
    params.hazirAdet = stockData.hazir_adet;
  }

  if (stockData.tamir_bekleyen !== undefined) {
    if (stockData.tamir_bekleyen < 0) {
      throw new ValidationError('Tamir bekleyen adet negatif olamaz');
    }
    updates.push('tamir_bekleyen = @tamirBekleyen');
    params.tamirBekleyen = stockData.tamir_bekleyen;
  }

  if (stockData.revize_adet !== undefined) {
    if (stockData.revize_adet < 0) {
      throw new ValidationError('Revize adet negatif olamaz');
    }
    updates.push('revize_adet = @revizeAdet');
    params.revizeAdet = stockData.revize_adet;
  }

  if (updates.length === 0) {
    return getPOSMById(id);
  }

  updates.push(`updated_at = ${getTurkeyDateSQL()}`);

  await query(
    `UPDATE POSM 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getPOSMById(id);
};

export const deletePOSM = async (id: number): Promise<void> => {
  await getPOSMById(id);
  await query(`DELETE FROM POSM WHERE id = @id`, { id });
};
