import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { NotFoundError, ValidationError } from '../utils/errors';

export interface Depot {
  id: number;
  name: string;
  code: string;
  address?: string;
  is_active: boolean;
  created_at: Date;
  updated_at?: Date;
}

export interface CreateDepotData {
  name: string;
  code: string;
  address?: string;
}

export interface UpdateDepotData {
  name?: string;
  code?: string;
  address?: string;
  is_active?: boolean;
}

export const getAllDepots = async (userId?: number, role?: string): Promise<Depot[]> => {
  // Admin tüm depoları görebilir
  if (role === 'Admin') {
    return query<Depot>(
      `SELECT id, name, code, address, is_active, created_at, updated_at 
       FROM Depots 
       ORDER BY name`
    );
  }

  // Diğer kullanıcılar sadece atandıkları depoları görebilir
  if (userId) {
    return query<Depot>(
      `SELECT d.id, d.name, d.code, d.address, d.is_active, d.created_at, d.updated_at
       FROM Depots d
       INNER JOIN User_Depots ud ON d.id = ud.depot_id
       WHERE ud.user_id = @userId AND d.is_active = 1
       ORDER BY d.name`,
      { userId }
    );
  }

  return [];
};

// Tüm aktif depoları getir (transfer hedef depo seçimi için)
export const getAllActiveDepots = async (): Promise<Depot[]> => {
  return query<Depot>(
    `SELECT id, name, code, address, is_active, created_at, updated_at 
     FROM Depots 
     WHERE is_active = 1
     ORDER BY name`
  );
};

export const getDepotById = async (id: number): Promise<Depot> => {
  const depots = await query<Depot>(
    `SELECT id, name, code, address, is_active, created_at, updated_at 
     FROM Depots 
     WHERE id = @id`,
    { id }
  );

  if (depots.length === 0) {
    throw new NotFoundError('Depo');
  }

  return depots[0];
};

export const createDepot = async (data: CreateDepotData): Promise<Depot> => {
  // Code kontrolü
  const existing = await query(
    `SELECT id FROM Depots WHERE code = @code`,
    { code: data.code }
  );

  if (existing.length > 0) {
    throw new ValidationError('Bu depo kodu zaten kullanılıyor');
  }

  const result = await query<{ id: number }>(
    `INSERT INTO Depots (name, code, address)
     OUTPUT INSERTED.id
     VALUES (@name, @code, @address)`,
    {
      name: data.name,
      code: data.code,
      address: data.address || null,
    }
  );

  return getDepotById(result[0].id);
};

export const updateDepot = async (
  id: number,
  data: UpdateDepotData
): Promise<Depot> => {
  await getDepotById(id); // Depo var mı kontrol et

  const updates: string[] = [];
  const params: any = { id };

  if (data.name !== undefined) {
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.code !== undefined) {
    // Code değişiyorsa kontrol et
    const existing = await query(
      `SELECT id FROM Depots WHERE code = @code AND id != @id`,
      { code: data.code, id }
    );
    if (existing.length > 0) {
      throw new ValidationError('Bu depo kodu zaten kullanılıyor');
    }
    updates.push('code = @code');
    params.code = data.code;
  }

  if (data.address !== undefined) {
    updates.push('address = @address');
    params.address = data.address;
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getDepotById(id);
  }

  updates.push(`updated_at = ${getTurkeyDateSQL()}`);

  await query(
    `UPDATE Depots 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getDepotById(id);
};

export const deleteDepot = async (id: number): Promise<void> => {
  await getDepotById(id); // Depo var mı kontrol et
  await query(`DELETE FROM Depots WHERE id = @id`, { id });
};
