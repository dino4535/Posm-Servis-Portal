import { query } from '../config/database';
import { NotFoundError, ValidationError } from '../utils/errors';

export interface Territory {
  id: number;
  name: string;
  code?: string;
  depot_id: number;
  is_active: boolean;
  created_at: Date;
}

export interface CreateTerritoryData {
  name: string;
  code?: string;
  depot_id: number;
}

export interface UpdateTerritoryData {
  name?: string;
  code?: string;
  depot_id?: number;
  is_active?: boolean;
}

export const getAllTerritories = async (depotId?: number): Promise<any[]> => {
  if (depotId) {
    return query<any>(
      `SELECT t.id, t.name, t.code, t.depot_id, t.is_active, t.created_at,
              d.name as depot_name, d.code as depot_code
       FROM Territories t
       LEFT JOIN Depots d ON t.depot_id = d.id
       WHERE t.depot_id = @depotId AND t.is_active = 1
       ORDER BY t.name`,
      { depotId }
    );
  }

  return query<any>(
    `SELECT t.id, t.name, t.code, t.depot_id, t.is_active, t.created_at,
            d.name as depot_name, d.code as depot_code
     FROM Territories t
     LEFT JOIN Depots d ON t.depot_id = d.id
     WHERE t.is_active = 1
     ORDER BY t.name`
  );
};

export const getTerritoryById = async (id: number): Promise<Territory> => {
  const territories = await query<Territory>(
    `SELECT id, name, code, depot_id, is_active, created_at 
     FROM Territories 
     WHERE id = @id`,
    { id }
  );

  if (territories.length === 0) {
    throw new NotFoundError('Territory');
  }

  return territories[0];
};

export const createTerritory = async (data: CreateTerritoryData): Promise<Territory> => {
  // Depo var mı kontrol et
  const depots = await query(`SELECT id FROM Depots WHERE id = @depotId`, {
    depotId: data.depot_id,
  });
  if (depots.length === 0) {
    throw new NotFoundError('Depo');
  }

  // Code unique kontrolü
  if (data.code) {
    const existing = await query(
      `SELECT id FROM Territories WHERE code = @code`,
      { code: data.code }
    );
    if (existing.length > 0) {
      throw new ValidationError('Bu territory kodu zaten kullanılıyor');
    }
  }

  const result = await query<{ id: number }>(
    `INSERT INTO Territories (name, code, depot_id)
     OUTPUT INSERTED.id
     VALUES (@name, @code, @depotId)`,
    {
      name: data.name,
      code: data.code || null,
      depotId: data.depot_id,
    }
  );

  return getTerritoryById(result[0].id);
};

export const updateTerritory = async (
  id: number,
  data: UpdateTerritoryData
): Promise<Territory> => {
  await getTerritoryById(id);

  const updates: string[] = [];
  const params: any = { id };

  if (data.name !== undefined) {
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.code !== undefined) {
    const existing = await query(
      `SELECT id FROM Territories WHERE code = @code AND id != @id`,
      { code: data.code, id }
    );
    if (existing.length > 0) {
      throw new ValidationError('Bu territory kodu zaten kullanılıyor');
    }
    updates.push('code = @code');
    params.code = data.code;
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

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getTerritoryById(id);
  }

  await query(
    `UPDATE Territories 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getTerritoryById(id);
};

export const deleteTerritory = async (id: number): Promise<void> => {
  await getTerritoryById(id);
  await query(`DELETE FROM Territories WHERE id = @id`, { id });
};
