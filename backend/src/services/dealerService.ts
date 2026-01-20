import { query } from '../config/database';
import { NotFoundError, ValidationError } from '../utils/errors';

export interface Dealer {
  id: number;
  code: string;
  name: string;
  territory_id?: number;
  address?: string;
  phone?: string;
  is_active: boolean;
  created_at: Date;
}

export interface CreateDealerData {
  code: string;
  name: string;
  territory_id?: number;
  address?: string;
  phone?: string;
}

export interface UpdateDealerData {
  code?: string;
  name?: string;
  territory_id?: number;
  address?: string;
  phone?: string;
  latitude?: number;
  longitude?: number;
  is_active?: boolean;
}

export const getAllDealers = async (
  territoryId?: number, 
  depotId?: number, 
  limit?: number, 
  offset?: number
): Promise<{ dealers: any[]; total: number }> => {
  const params: any = {};
  const whereConditions: string[] = ['d.is_active = 1'];
  
  if (territoryId) {
    whereConditions.push('d.territory_id = @territoryId');
    params.territoryId = territoryId;
  }
  
  if (depotId) {
    whereConditions.push('dep.id = @depotId');
    params.depotId = depotId;
  }

  // Toplam sayıyı al
  const totalResult = await query<{ count: number }>(
    `SELECT COUNT(*) as count
     FROM Dealers d
     LEFT JOIN Territories t ON d.territory_id = t.id
     LEFT JOIN Depots dep ON t.depot_id = dep.id
     WHERE ${whereConditions.join(' AND ')}`,
    params
  );
  const total = totalResult[0]?.count || 0;

  // Pagination parametreleri
  if (limit !== undefined) {
    params.limit = limit;
  }
  if (offset !== undefined) {
    params.offset = offset;
  }

  const dealers = await query<any>(
    `SELECT d.id, d.code, d.name, d.territory_id, d.address, d.phone, d.latitude, d.longitude, d.is_active, d.created_at,
            t.name as territory_name, t.code as territory_code,
            dep.id as depot_id, dep.name as depot_name, dep.code as depot_code
     FROM Dealers d
     LEFT JOIN Territories t ON d.territory_id = t.id
     LEFT JOIN Depots dep ON t.depot_id = dep.id
     WHERE ${whereConditions.join(' AND ')}
     ORDER BY d.name
     ${limit !== undefined ? 'OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY' : ''}`,
    params
  );

  return { dealers, total };
};

export const searchDealers = async (
  searchTerm: string, 
  territoryId?: number, 
  depotId?: number,
  limit?: number,
  offset?: number
): Promise<{ dealers: any[]; total: number }> => {
  const params: any = { search: `%${searchTerm}%` };
  const whereConditions: string[] = [`(d.code LIKE @search OR d.name LIKE @search)`, 'd.is_active = 1'];
  
  if (territoryId) {
    whereConditions.push('d.territory_id = @territoryId');
    params.territoryId = territoryId;
  }
  
  if (depotId) {
    whereConditions.push('dep.id = @depotId');
    params.depotId = depotId;
  }

  // Toplam sayıyı al
  const totalResult = await query<{ count: number }>(
    `SELECT COUNT(*) as count
     FROM Dealers d
     LEFT JOIN Territories t ON d.territory_id = t.id
     LEFT JOIN Depots dep ON t.depot_id = dep.id
     WHERE ${whereConditions.join(' AND ')}`,
    params
  );
  const total = totalResult[0]?.count || 0;

  // Pagination parametreleri
  if (limit !== undefined) {
    params.limit = limit;
  }
  if (offset !== undefined) {
    params.offset = offset;
  }
  
  const dealers = await query<any>(
    `SELECT d.id, d.code, d.name, d.territory_id, d.address, d.phone, d.latitude, d.longitude, d.is_active, d.created_at,
            t.name as territory_name, t.code as territory_code,
            dep.id as depot_id, dep.name as depot_name, dep.code as depot_code
     FROM Dealers d
     LEFT JOIN Territories t ON d.territory_id = t.id
     LEFT JOIN Depots dep ON t.depot_id = dep.id
     WHERE ${whereConditions.join(' AND ')}
     ORDER BY d.name
     ${limit !== undefined ? 'OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY' : ''}`,
    params
  );

  return { dealers, total };
};

export const getDealerById = async (id: number): Promise<Dealer> => {
  const dealers = await query<Dealer>(
    `SELECT id, code, name, territory_id, address, phone, latitude, longitude, is_active, created_at 
     FROM Dealers 
     WHERE id = @id`,
    { id }
  );

  if (dealers.length === 0) {
    throw new NotFoundError('Dealer');
  }

  return dealers[0];
};

export const createDealer = async (data: CreateDealerData): Promise<Dealer> => {
  // Territory var mı kontrol et
  if (data.territory_id) {
    const territories = await query(
      `SELECT id FROM Territories WHERE id = @territoryId`,
      { territoryId: data.territory_id }
    );
    if (territories.length === 0) {
      throw new NotFoundError('Territory');
    }
  }

  const result = await query<{ id: number }>(
    `INSERT INTO Dealers (code, name, territory_id, address, phone, latitude, longitude)
     OUTPUT INSERTED.id
     VALUES (@code, @name, @territoryId, @address, @phone, @latitude, @longitude)`,
    {
      code: data.code,
      name: data.name,
      territoryId: data.territory_id || null,
      address: data.address || null,
      phone: data.phone || null,
      latitude: (data as any).latitude || null,
      longitude: (data as any).longitude || null,
    }
  );

  return getDealerById(result[0].id);
};

export const updateDealer = async (
  id: number,
  data: UpdateDealerData
): Promise<Dealer> => {
  await getDealerById(id);

  const updates: string[] = [];
  const params: any = { id };

  if (data.code !== undefined) {
    updates.push('code = @code');
    params.code = data.code;
  }

  if (data.name !== undefined) {
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.territory_id !== undefined) {
    if (data.territory_id) {
      const territories = await query(
        `SELECT id FROM Territories WHERE id = @territoryId`,
        { territoryId: data.territory_id }
      );
      if (territories.length === 0) {
        throw new NotFoundError('Territory');
      }
    }
    updates.push('territory_id = @territoryId');
    params.territoryId = data.territory_id || null;
  }

  if (data.address !== undefined) {
    updates.push('address = @address');
    params.address = data.address;
  }

  if (data.phone !== undefined) {
    updates.push('phone = @phone');
    params.phone = data.phone;
  }

  if (data.latitude !== undefined) {
    updates.push('latitude = @latitude');
    params.latitude = data.latitude;
  }

  if (data.longitude !== undefined) {
    updates.push('longitude = @longitude');
    params.longitude = data.longitude;
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getDealerById(id);
  }

  await query(
    `UPDATE Dealers 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getDealerById(id);
};

export const deleteDealer = async (id: number): Promise<void> => {
  await getDealerById(id);
  await query(`DELETE FROM Dealers WHERE id = @id`, { id });
};
