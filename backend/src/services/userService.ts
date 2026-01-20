import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { hashPassword } from './authService';
import { NotFoundError, ValidationError } from '../utils/errors';
import { ROLES } from '../config/constants';

export interface User {
  id: number;
  email: string;
  name: string;
  role: string;
  is_active: boolean;
  created_at: Date;
  updated_at?: Date;
}

export interface CreateUserData {
  email: string;
  password: string;
  name: string;
  role: string;
}

export interface UpdateUserData {
  email?: string;
  password?: string;
  name?: string;
  role?: string;
  is_active?: boolean;
}

export const getAllUsers = async (): Promise<any[]> => {
  // Önce tüm kullanıcıları getir
  const users = await query<any>(
    `SELECT id, email, name, role, is_active, created_at, updated_at 
     FROM Users 
     ORDER BY created_at DESC`
  );

  // Her kullanıcı için depo bilgilerini getir
  const usersWithDepots = await Promise.all(
    users.map(async (user) => {
      const userDepots = await query<any>(
        `SELECT d.id, d.name
         FROM Depots d
         INNER JOIN User_Depots ud ON d.id = ud.depot_id
         WHERE ud.user_id = @userId AND d.is_active = 1
         ORDER BY d.name`,
        { userId: user.id }
      );

      return {
        ...user,
        depot_names: userDepots.map((d: any) => d.name),
        depot_ids: userDepots.map((d: any) => d.id),
      };
    })
  );

  return usersWithDepots;
};

// Depo bazında teknik kullanıcıları getir
export const getTechniciansByDepot = async (depotId: number): Promise<Array<{ id: number; email: string; name: string }>> => {
  return query<{ id: number; email: string; name: string }>(
    `SELECT u.id, u.email, u.name
     FROM Users u
     INNER JOIN User_Depots ud ON u.id = ud.user_id
     WHERE ud.depot_id = @depotId 
       AND u.role = 'Teknik' 
       AND u.is_active = 1`,
    { depotId }
  );
};

// Kullanıcı bilgilerini ID ile getir
export const getUserById = async (id: number): Promise<User> => {
  const users = await query<User>(
    `SELECT id, email, name, role, is_active, created_at, updated_at 
     FROM Users 
     WHERE id = @id`,
    { id }
  );

  if (users.length === 0) {
    throw new NotFoundError('Kullanıcı');
  }

  return users[0];
};

export const getUserByEmail = async (email: string): Promise<User | null> => {
  const users = await query<User>(
    `SELECT id, email, name, role, is_active, created_at, updated_at 
     FROM Users 
     WHERE email = @email`,
    { email }
  );

  return users.length > 0 ? users[0] : null;
};

export const createUser = async (data: CreateUserData): Promise<User> => {
  // Email kontrolü
  const existingUser = await getUserByEmail(data.email);
  if (existingUser) {
    throw new ValidationError('Bu e-posta adresi zaten kullanılıyor');
  }

  // Rol kontrolü
  if (!Object.values(ROLES).includes(data.role as any)) {
    throw new ValidationError('Geçersiz rol');
  }

  const passwordHash = await hashPassword(data.password);

  const result = await query<{ id: number }>(
    `INSERT INTO Users (email, password_hash, name, role)
     OUTPUT INSERTED.id
     VALUES (@email, @passwordHash, @name, @role)`,
    {
      email: data.email,
      passwordHash,
      name: data.name,
      role: data.role,
    }
  );

  return getUserById(result[0].id);
};

export const updateUser = async (
  id: number,
  data: UpdateUserData
): Promise<User> => {
  await getUserById(id); // Kullanıcı var mı kontrol et

  const updates: string[] = [];
  const params: any = { id };

  if (data.email !== undefined) {
    // Email değişiyorsa kontrol et
    const existingUser = await getUserByEmail(data.email);
    if (existingUser && existingUser.id !== id) {
      throw new ValidationError('Bu e-posta adresi zaten kullanılıyor');
    }
    updates.push('email = @email');
    params.email = data.email;
  }

  if (data.password !== undefined) {
    updates.push('password_hash = @passwordHash');
    params.passwordHash = await hashPassword(data.password);
  }

  if (data.name !== undefined) {
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.role !== undefined) {
    if (!Object.values(ROLES).includes(data.role as any)) {
      throw new ValidationError('Geçersiz rol');
    }
    updates.push('role = @role');
    params.role = data.role;
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getUserById(id);
  }

  updates.push(`updated_at = ${getTurkeyDateSQL()}`);

  await query(
    `UPDATE Users 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getUserById(id);
};

export const deleteUser = async (id: number): Promise<void> => {
  await getUserById(id); // Kullanıcı var mı kontrol et
  await query(`DELETE FROM Users WHERE id = @id`, { id });
};

export const getUserDepots = async (userId: number) => {
  return query(
    `SELECT d.id, d.name, d.code, d.address, d.is_active, ud.created_at
     FROM Depots d
     INNER JOIN User_Depots ud ON d.id = ud.depot_id
     WHERE ud.user_id = @userId AND d.is_active = 1
     ORDER BY d.name`,
    { userId }
  );
};

export const assignDepotToUser = async (
  userId: number,
  depotId: number
): Promise<void> => {
  // Kullanıcı ve depo var mı kontrol et
  await getUserById(userId);
  const depots = await query(`SELECT id FROM Depots WHERE id = @depotId`, {
    depotId,
  });
  if (depots.length === 0) {
    throw new NotFoundError('Depo');
  }

  // Zaten atanmış mı kontrol et
  const existing = await query(
    `SELECT id FROM User_Depots WHERE user_id = @userId AND depot_id = @depotId`,
    { userId, depotId }
  );

  if (existing.length === 0) {
    await query(
      `INSERT INTO User_Depots (user_id, depot_id) VALUES (@userId, @depotId)`,
      { userId, depotId }
    );
  }
};

export const removeDepotFromUser = async (
  userId: number,
  depotId: number
): Promise<void> => {
  await query(
    `DELETE FROM User_Depots WHERE user_id = @userId AND depot_id = @depotId`,
    { userId, depotId }
  );
};
