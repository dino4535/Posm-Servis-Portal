import sql from 'mssql';
import { config } from './env';

let pool: sql.ConnectionPool | null = null;

export const getPool = async (): Promise<sql.ConnectionPool> => {
  if (pool) {
    return pool;
  }

  const sqlConfig: sql.config = {
    server: config.database.server,
    database: config.database.database,
    user: config.database.user,
    password: config.database.password,
    port: config.database.port,
    options: {
      ...config.database.options,
      encrypt: false,
      trustServerCertificate: true,
    },
    pool: config.database.pool,
  };

  try {
    pool = await sql.connect(sqlConfig);
    console.log('MSSQL Server bağlantısı başarılı');
    return pool;
  } catch (error) {
    console.error('MSSQL Server bağlantı hatası:', error);
    throw error;
  }
};

export const closePool = async (): Promise<void> => {
  if (pool) {
    await pool.close();
    pool = null;
    console.log('MSSQL Server bağlantısı kapatıldı');
  }
};

export const query = async <T = any>(
  queryString: string,
  params?: Record<string, any>
): Promise<T[]> => {
  const pool = await getPool();
  const request = pool.request();

  if (params) {
    Object.keys(params).forEach((key) => {
      request.input(key, params[key]);
    });
  }

  const result = await request.query(queryString);
  return result.recordset as T[];
};

export const execute = async <T = any>(
  procedureName: string,
  params?: Record<string, any>
): Promise<T[]> => {
  const pool = await getPool();
  const request = pool.request();

  if (params) {
    Object.keys(params).forEach((key) => {
      request.input(key, params[key]);
    });
  }

  const result = await request.execute(procedureName);
  return result.recordset as T[];
};
