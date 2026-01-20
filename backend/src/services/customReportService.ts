import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { NotFoundError, ValidationError } from '../utils/errors';

export interface ReportTemplate {
  id: number;
  name: string;
  description?: string;
  created_by: number;
  config: string; // JSON string - pivot table config
  query_config: string; // JSON string - SQL query config
  is_active: boolean;
  created_at: Date;
  updated_at?: Date;
}

export interface CreateReportTemplateData {
  name: string;
  description?: string;
  config: any; // Pivot table config object
  query_config: any; // Query config object
}

export interface UpdateReportTemplateData {
  name?: string;
  description?: string;
  config?: any;
  query_config?: any;
  is_active?: boolean;
}

export interface ScheduledReport {
  id: number;
  report_template_id: number;
  name: string;
  description?: string;
  schedule_config: string; // JSON string
  recipients: string; // JSON string - email array
  depot_filters?: string; // JSON string - depot ID array
  start_date?: string; // Date filter
  end_date?: string; // Date filter
  status?: string; // Status filter
  is_active: boolean;
  last_run_at?: Date;
  next_run_at?: Date;
  created_by: number;
  created_at: Date;
  updated_at?: Date;
}

export interface CreateScheduledReportData {
  report_template_id: number;
  name: string;
  description?: string;
  schedule_config: any; // { day: number[], hour: number, minute: number, repeat_type: 'daily'|'weekly'|'monthly' }
  recipients: string[]; // Email addresses
  depot_filters?: number[]; // Depot IDs
  start_date?: string; // Date filter
  end_date?: string; // Date filter
  status?: string; // Status filter
}

export interface ScheduleConfig {
  day?: number[]; // 0-6 (Sunday-Saturday) for weekly, 1-31 for monthly
  hour: number; // 0-23
  minute: number; // 0-59
  repeat_type: 'daily' | 'weekly' | 'monthly';
}

// Report Templates
export const getAllReportTemplates = async (userId?: number): Promise<any[]> => {
  let whereClause = 'WHERE rt.is_active = 1';
  const params: any = {};

  if (userId) {
    whereClause += ' AND rt.created_by = @userId';
    params.userId = userId;
  }

  return query<any>(
    `SELECT rt.id, rt.name, rt.description, rt.created_by, rt.config, rt.query_config,
            rt.is_active, rt.created_at, rt.updated_at,
            u.name as created_by_name, u.email as created_by_email
     FROM Report_Templates rt
     LEFT JOIN Users u ON rt.created_by = u.id
     ${whereClause}
     ORDER BY rt.created_at DESC`,
    params
  );
};

export const getReportTemplateById = async (id: number): Promise<ReportTemplate> => {
  const templates = await query<ReportTemplate>(
    `SELECT id, name, description, created_by, config, query_config, is_active, created_at, updated_at
     FROM Report_Templates
     WHERE id = @id`,
    { id }
  );

  if (templates.length === 0) {
    throw new NotFoundError('Report Template');
  }

  return templates[0];
};

export const createReportTemplate = async (
  data: CreateReportTemplateData,
  userId: number
): Promise<ReportTemplate> => {
  // Name unique kontrolü
  const existing = await query(
    `SELECT id FROM Report_Templates WHERE name = @name`,
    { name: data.name }
  );
  if (existing.length > 0) {
    throw new ValidationError('Bu rapor adı zaten kullanılıyor');
  }

  // config ve query_config zaten object olarak geliyorsa stringify et, string ise olduğu gibi kullan
  const configStr = typeof data.config === 'string' ? data.config : JSON.stringify(data.config);
  const queryConfigStr = typeof data.query_config === 'string' ? data.query_config : JSON.stringify(data.query_config);

  const result = await query<{ id: number }>(
    `INSERT INTO Report_Templates (name, description, created_by, config, query_config)
     OUTPUT INSERTED.id
     VALUES (@name, @description, @createdBy, @config, @queryConfig)`,
    {
      name: data.name,
      description: data.description || null,
      createdBy: userId,
      config: configStr,
      queryConfig: queryConfigStr,
    }
  );

  return getReportTemplateById(result[0].id);
};

export const updateReportTemplate = async (
  id: number,
  data: UpdateReportTemplateData
): Promise<ReportTemplate> => {
  await getReportTemplateById(id);

  const updates: string[] = [];
  const params: any = { id };

  if (data.name !== undefined) {
    const existing = await query(
      `SELECT id FROM Report_Templates WHERE name = @name AND id != @id`,
      { name: data.name, id }
    );
    if (existing.length > 0) {
      throw new ValidationError('Bu rapor adı zaten kullanılıyor');
    }
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.description !== undefined) {
    updates.push('description = @description');
    params.description = data.description;
  }

  if (data.config !== undefined) {
    updates.push('config = @config');
    params.config = typeof data.config === 'string' ? data.config : JSON.stringify(data.config);
  }

  if (data.query_config !== undefined) {
    updates.push('query_config = @queryConfig');
    params.queryConfig = typeof data.query_config === 'string' ? data.query_config : JSON.stringify(data.query_config);
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getReportTemplateById(id);
  }

  updates.push('updated_at = GETDATE()');

  await query(
    `UPDATE Report_Templates 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getReportTemplateById(id);
};

export const deleteReportTemplate = async (id: number): Promise<void> => {
  await getReportTemplateById(id);
  await query(`DELETE FROM Report_Templates WHERE id = @id`, { id });
};

// Execute Report - Query config'e göre SQL sorgusu oluşturup çalıştırır
export const executeReport = async (
  templateId: number,
  filters?: any
): Promise<any[]> => {
  const template = await getReportTemplateById(templateId);
  let queryConfig: any;
  
  try {
    queryConfig = typeof template.query_config === 'string' 
      ? JSON.parse(template.query_config) 
      : template.query_config;
  } catch (error) {
    throw new Error(`Query config parse edilemedi: ${error}`);
  }

  console.log('Parsed Query Config:', JSON.stringify(queryConfig, null, 2));
  console.log('Tables:', queryConfig.tables);
  console.log('Tables type:', typeof queryConfig.tables);
  console.log('Tables is array:', Array.isArray(queryConfig.tables));

  // Query config'den SQL sorgusu oluştur
  const sql = buildQueryFromConfig(queryConfig, filters);

  console.log('Executing SQL:', sql.query);
  console.log('With params:', sql.params);

  // Sorguyu çalıştır
  let results: any[];
  try {
    results = await query<any>(sql.query, sql.params);
  } catch (error: any) {
    console.error('SQL Query Error:', error);
    console.error('Failed Query:', sql.query);
    console.error('Error Details:', {
      message: error.message,
      code: error.code,
      number: error.number,
      state: error.state,
      class: error.class,
      serverName: error.serverName,
      procName: error.procName,
      lineNumber: error.lineNumber,
    });
    const errorMessage = error.message || 'Bilinmeyen SQL hatası';
    const errorDetails = error.number ? ` (Hata Kodu: ${error.number})` : '';
    throw new Error(`SQL sorgusu çalıştırılamadı: ${errorMessage}${errorDetails}`);
  }
  
  // Execution kaydı oluştur
  try {
    await query(
      `INSERT INTO Report_Executions 
       (report_template_id, execution_type, status, row_count, created_at)
       VALUES (@templateId, 'MANUAL', 'SUCCESS', @rowCount, ${getTurkeyDateSQL()})`,
      {
        templateId: templateId,
        rowCount: results.length,
      }
    );
  } catch (error) {
    // Execution kaydı hatası raporu engellememeli
    console.error('Execution kaydı oluşturulamadı:', error);
  }

  return results;
};

// Query config'den SQL sorgusu oluştur
function buildQueryFromConfig(queryConfig: any, filters?: any): { query: string; params: any } {
  const { tables, joins, columns, where_conditions, group_by, order_by } = queryConfig;
  const params: any = {};

  // Validasyon
  console.log('buildQueryFromConfig - tables:', tables);
  console.log('buildQueryFromConfig - tables type:', typeof tables);
  console.log('buildQueryFromConfig - is array:', Array.isArray(tables));
  
  if (!tables) {
    throw new Error('Tablo bilgisi bulunamadı');
  }
  if (!Array.isArray(tables)) {
    throw new Error(`Tablo bilgisi array değil: ${typeof tables}`);
  }
  if (tables.length === 0) {
    throw new Error('En az bir tablo seçilmelidir');
  }
  if (!columns || !Array.isArray(columns) || columns.length === 0) {
    throw new Error('En az bir sütun seçilmelidir');
  }

  // FROM kısmı ve JOIN'ler - Önce tablo alias'larını belirle
  const fromTable = tables[0]?.name || 'Requests';
  const tableAliases: { [key: string]: string } = {};
  tableAliases[fromTable] = fromTable; // Ana tablo için alias
  
  let fromClause = `FROM ${fromTable}`;

  // JOIN'ler - Aynı tablo birden fazla kez kullanılıyorsa alias ekle
  if (joins && joins.length > 0) {
    const usedTables = new Set<string>();
    usedTables.add(fromTable);
    
    joins.forEach((join: any, index: number) => {
      let joinTable = join.table;
      
      // Eğer bu tablo daha önce kullanıldıysa alias ekle
      if (usedTables.has(joinTable)) {
        const alias = `${joinTable}_${index}`;
        tableAliases[joinTable] = alias;
        joinTable = `${join.table} AS ${alias}`;
      } else {
        tableAliases[joinTable] = joinTable;
        usedTables.add(joinTable);
      }
      
      // ON clause'daki tablo adlarını da alias ile değiştir
      let onClause = join.on;
      Object.keys(tableAliases).forEach((tableName) => {
        const alias = tableAliases[tableName];
        if (alias !== tableName) {
          // ON clause'da tablo adını alias ile değiştir
          onClause = onClause.replace(new RegExp(`\\b${tableName}\\.`, 'g'), `${alias}.`);
        }
      });
      
      fromClause += ` ${join.type || 'LEFT'} JOIN ${joinTable} ON ${onClause}`;
    });
  }

  // SELECT kısmı - Tablo alias'larını kullan ve SELECT alias'larını benzersiz yap
  const usedSelectAliases = new Set<string>();
  const columnAliasMap = new Map<string, string>(); // Orijinal alias -> benzersiz alias mapping
  
  const selectColumns = columns.map((col: any, index: number) => {
    if (!col.column) {
      throw new Error(`Sütun adı belirtilmemiş: ${JSON.stringify(col)}`);
    }
    
    const requestedAlias = col.alias || col.column;
    let finalAlias = requestedAlias;
    
    // Eğer aynı alias daha önce kullanıldıysa, benzersiz hale getir
    if (usedSelectAliases.has(finalAlias)) {
      let tableAlias = '';
      if (col.table) {
        tableAlias = tableAliases[col.table] || col.table;
      }
      finalAlias = tableAlias ? `${tableAlias}_${col.column}` : `${col.column}_${index}`;
    }
    
    usedSelectAliases.add(finalAlias);
    // columnAliasMap'e hem table.column hem de sadece column olarak ekle
    const tableColumnKey = `${col.table || ''}.${col.column}`;
    columnAliasMap.set(tableColumnKey, finalAlias);
    // Ayrıca sadece column adı ile de ekle (hem table var hem yok durumlar için)
    columnAliasMap.set(col.column, finalAlias);
    // Eğer table varsa, table alias ile de ekle (GROUP BY'da table alias kullanılabilir)
    if (col.table) {
      const tableAlias = tableAliases[col.table] || col.table;
      if (tableAlias !== col.table) {
        const tableAliasColumnKey = `${tableAlias}.${col.column}`;
        columnAliasMap.set(tableAliasColumnKey, finalAlias);
      }
    }
    
    if (col.type === 'aggregate') {
      if (!col.function) {
        throw new Error(`Toplam fonksiyonu belirtilmemiş: ${JSON.stringify(col)}`);
      }
      const tableAlias = col.table ? (tableAliases[col.table] || col.table) : '';
      const tablePrefix = tableAlias ? `${tableAlias}.` : '';
      return `${col.function}(${tablePrefix}${col.column}) as [${finalAlias}]`;
    }
    // Tablo alias'ını kullan - eğer alias yoksa orijinal tablo adını kullan
    let tableAlias = '';
    if (col.table) {
      // Önce tableAliases map'inden bak
      tableAlias = tableAliases[col.table];
      // Eğer map'te yoksa, orijinal tablo adını kullan
      if (!tableAlias) {
        tableAlias = col.table;
      }
    }
    const tablePrefix = tableAlias ? `${tableAlias}.` : '';
    return `${tablePrefix}${col.column} as [${finalAlias}]`;
  }).join(', ');

  // WHERE kısmı
  let whereClause = '';
  if (where_conditions && where_conditions.length > 0) {
    const conditions = where_conditions.map((cond: any, index: number) => {
      const paramName = `param${index}`;
      params[paramName] = cond.value;
      return `${cond.column} ${cond.operator || '='} @${paramName}`;
    });
    whereClause = `WHERE ${conditions.join(' AND ')}`;
  }

  // Filtreler ekle - Tablo alias'ını kullan
  if (filters) {
    const filterConditions: string[] = [];
    const mainTableAlias = tableAliases[fromTable] || fromTable;
    if (filters.start_date) {
      filterConditions.push(`${mainTableAlias}.created_at >= @startDate`);
      params.startDate = filters.start_date;
    }
    if (filters.end_date) {
      filterConditions.push(`${mainTableAlias}.created_at <= @endDate`);
      params.endDate = filters.end_date;
    }
    if (filters.depot_id) {
      filterConditions.push(`${mainTableAlias}.depot_id = @depotId`);
      params.depotId = filters.depot_id;
    }
    if (filters.depot_ids && Array.isArray(filters.depot_ids) && filters.depot_ids.length > 0) {
      const depotPlaceholders = filters.depot_ids.map((_id: number, i: number) => `@depotId${i}`).join(', ');
      filterConditions.push(`${mainTableAlias}.depot_id IN (${depotPlaceholders})`);
      filters.depot_ids.forEach((id: number, i: number) => {
        params[`depotId${i}`] = id;
      });
    }
    if (filters.status) {
      filterConditions.push(`${mainTableAlias}.durum = @status`);
      params.status = filters.status;
    }
    if (filters.statuses && Array.isArray(filters.statuses) && filters.statuses.length > 0) {
      const statusPlaceholders = filters.statuses.map((_status: string, i: number) => `@status${i}`).join(', ');
      filterConditions.push(`${mainTableAlias}.durum IN (${statusPlaceholders})`);
      filters.statuses.forEach((status: string, i: number) => {
        params[`status${i}`] = status;
      });
    }
    if (filterConditions.length > 0) {
      whereClause += whereClause ? ` AND ${filterConditions.join(' AND ')}` : `WHERE ${filterConditions.join(' AND ')}`;
    }
  }

  // GROUP BY - Aggregate olmayan sütunları kullan
  // SQL Server'da GROUP BY kullanıldığında, SELECT'teki tüm non-aggregate sütunlar GROUP BY'da olmalı
  let groupByClause = '';
  const nonAggregateColumns = columns.filter((col: any) => col.type !== 'aggregate');
  const hasAggregate = columns.some((col: any) => col.type === 'aggregate');
  
  // Eğer aggregate sütun varsa, SELECT'teki TÜM non-aggregate sütunları GROUP BY'a ekle (SQL Server kuralı)
  if (hasAggregate && nonAggregateColumns.length > 0) {
    const usedGroupByAliases = new Set<string>();
    const groupByAliases = nonAggregateColumns.map((col: any) => {
      // Önce table.column formatını dene
      const colKey = `${col.table || ''}.${col.column}`;
      let alias = columnAliasMap.get(colKey);
      
      // Eğer bulunamazsa, table alias ile dene
      if (!alias && col.table) {
        const tableAlias = tableAliases[col.table] || col.table;
        if (tableAlias !== col.table) {
          const tableAliasKey = `${tableAlias}.${col.column}`;
          alias = columnAliasMap.get(tableAliasKey);
        }
      }
      
      // Eğer hala bulunamazsa, sadece column adı ile dene
      if (!alias) {
        alias = columnAliasMap.get(col.column);
      }
      
      if (alias) {
        if (usedGroupByAliases.has(alias)) {
          return null; // Bu sütunu atla
        }
        usedGroupByAliases.add(alias);
        return `[${alias}]`;
      }
      
      console.warn(`GROUP BY (aggregate): Alias bulunamadı - colKey=${colKey}, columnAliasMap keys:`, Array.from(columnAliasMap.keys()));
      return null;
    }).filter((alias: string | null) => alias !== null && alias.trim().length > 0);
    
    if (groupByAliases.length > 0) {
      groupByClause = `GROUP BY ${groupByAliases.join(', ')}`;
    } else {
      console.warn('GROUP BY (aggregate): Hiçbir geçerli alias bulunamadı. GROUP BY kullanılmayacak.');
    }
  } else if (group_by && Array.isArray(group_by) && group_by.length > 0) {
    // Eğer aggregate yoksa ama GROUP BY belirtilmişse, sadece belirtilen sütunları kullan
    // GROUP BY'da SELECT'teki benzersiz alias'ları kullan
    const usedGroupByAliases = new Set<string>();
    const groupByAliases = group_by.map((colName: string) => {
      // Önce tam sütun adını (table.column) dene
      let uniqueAlias = columnAliasMap.get(colName);
      
      // Eğer bulunamazsa, columns'dan bul ve colKey oluştur
      if (!uniqueAlias) {
        const col = nonAggregateColumns.find((c: any) => {
          const tableAlias = c.table ? (tableAliases[c.table] || c.table) : '';
          const fullName = tableAlias ? `${tableAlias}.${c.column}` : c.column;
          const originalFullName = c.table ? `${c.table}.${c.column}` : c.column;
          return fullName === colName || originalFullName === colName || c.column === colName;
        });
        
        if (col) {
          // Önce table.column formatını dene
          const colKey = `${col.table || ''}.${col.column}`;
          uniqueAlias = columnAliasMap.get(colKey);
          
          // Eğer hala bulunamazsa, table alias ile dene
          if (!uniqueAlias && col.table) {
            const tableAlias = tableAliases[col.table] || col.table;
            if (tableAlias !== col.table) {
              const tableAliasKey = `${tableAlias}.${col.column}`;
              uniqueAlias = columnAliasMap.get(tableAliasKey);
            }
          }
          
          // Eğer hala bulunamazsa, sadece column adı ile dene
          if (!uniqueAlias) {
            uniqueAlias = columnAliasMap.get(col.column);
          }
        }
      }
      
      if (uniqueAlias) {
        // Eğer aynı alias GROUP BY'da daha önce kullanıldıysa, atla
        if (usedGroupByAliases.has(uniqueAlias)) {
          return null; // Bu sütunu atla
        }
        usedGroupByAliases.add(uniqueAlias);
        return `[${uniqueAlias}]`;
      }
      
      // Debug: Bulunamadıysa log ekle
      console.log(`GROUP BY: Alias bulunamadı - colName=${colName}, columnAliasMap keys:`, Array.from(columnAliasMap.keys()));
      console.log(`GROUP BY: Available columns:`, nonAggregateColumns.map((c: any) => `${c.table || ''}.${c.column}`));
      return null; // Bulunamadıysa atla
    }).filter((alias: string | null) => alias !== null && alias.trim().length > 0);
    
    if (groupByAliases.length > 0) {
      groupByClause = `GROUP BY ${groupByAliases.join(', ')}`;
    } else {
      console.warn('GROUP BY: Hiçbir geçerli alias bulunamadı. GROUP BY kullanılmayacak.');
    }
  }

  // ORDER BY - SELECT'teki benzersiz alias'ları kullan
  let orderByClause = '';
  if (order_by && Array.isArray(order_by) && order_by.length > 0) {
    const usedOrderByAliases = new Set<string>();
    const validOrderBy = order_by.map((colName: string) => {
      // Eğer "table.column ASC/DESC" formatındaysa parse et
      const parts = colName.trim().split(/\s+/);
      const colPart = parts[0];
      const direction = parts[1] || 'ASC';
      
      // Önce doğrudan colPart ile dene
      let uniqueAlias = columnAliasMap.get(colPart);
      
      // Eğer bulunamazsa, columns'dan bul ve colKey oluştur
      if (!uniqueAlias) {
        const col = columns.find((c: any) => {
          const tableAlias = c.table ? (tableAliases[c.table] || c.table) : '';
          const fullName = tableAlias ? `${tableAlias}.${c.column}` : c.column;
          const originalFullName = c.table ? `${c.table}.${c.column}` : c.column;
          return fullName === colPart || originalFullName === colPart;
        });
        
        if (col) {
          const colKey = `${col.table || ''}.${col.column}`;
          uniqueAlias = columnAliasMap.get(colKey);
          
          // Debug: Eğer hala bulunamazsa log ekle
          if (!uniqueAlias) {
            console.log(`ORDER BY: colPart=${colPart}, colKey=${colKey}, columnAliasMap keys:`, Array.from(columnAliasMap.keys()));
          }
        }
      }
      
      if (uniqueAlias) {
        // Eğer aynı alias ORDER BY'da daha önce kullanıldıysa, atla
        if (usedOrderByAliases.has(uniqueAlias)) {
          return null; // Bu sütunu atla
        }
        usedOrderByAliases.add(uniqueAlias);
        // SQL Server'da ORDER BY'da alias kullanırken köşeli parantez kullanabiliriz
        // SELECT'te `as [alias]` kullandığımız için ORDER BY'da da `[alias]` kullanmalıyız
        return `[${uniqueAlias}] ${direction}`;
      }
      
      // Debug: Bulunamadıysa log ekle
      console.log(`ORDER BY: Alias bulunamadı - colPart=${colPart}, columnAliasMap keys:`, Array.from(columnAliasMap.keys()));
      return null; // Bulunamadıysa atla
    }).filter((col: string | null) => col !== null && col.trim().length > 0);
    
    if (validOrderBy.length > 0) {
      orderByClause = `ORDER BY ${validOrderBy.join(', ')}`;
    }
  }

  // SQL sorgusunu oluştur (boşlukları düzgün ekle)
  const queryParts = [
    `SELECT ${selectColumns}`,
    fromClause,
    whereClause,
    groupByClause,
    orderByClause
  ].filter(part => part && part.trim().length > 0);
  
  const fullQuery = queryParts.join(' ');

  console.log('Generated SQL Query:', fullQuery);
  console.log('Table Aliases:', JSON.stringify(tableAliases, null, 2));
  console.log('Column Alias Map:', JSON.stringify(Object.fromEntries(columnAliasMap), null, 2));
  console.log('SELECT Columns:', selectColumns);
  console.log('FROM Clause:', fromClause);
  console.log('GROUP BY Clause:', groupByClause);
  console.log('ORDER BY Clause:', orderByClause);
  console.log('Query Params:', params);
  console.log('Query Config:', JSON.stringify(queryConfig, null, 2));

  return { query: fullQuery, params };
}

// Scheduled Reports
export const getAllScheduledReports = async (): Promise<any[]> => {
  return query<any>(
    `SELECT sr.id, sr.report_template_id, sr.name, sr.description, sr.schedule_config,
            sr.recipients, sr.depot_filters, sr.start_date, sr.end_date, sr.status,
            sr.is_active, sr.last_run_at, sr.next_run_at,
            sr.created_by, sr.created_at, sr.updated_at,
            rt.name as template_name,
            u.name as created_by_name
     FROM Scheduled_Reports sr
     LEFT JOIN Report_Templates rt ON sr.report_template_id = rt.id
     LEFT JOIN Users u ON sr.created_by = u.id
     ORDER BY sr.next_run_at ASC`
  );
};

export const getScheduledReportById = async (id: number): Promise<ScheduledReport> => {
  const reports = await query<ScheduledReport>(
    `SELECT id, report_template_id, name, description, schedule_config, recipients,
            depot_filters, start_date, end_date, status,
            is_active, last_run_at, next_run_at, created_by, created_at, updated_at
     FROM Scheduled_Reports
     WHERE id = @id`,
    { id }
  );

  if (reports.length === 0) {
    throw new NotFoundError('Scheduled Report');
  }

  return reports[0];
};

export const createScheduledReport = async (
  data: CreateScheduledReportData,
  userId: number
): Promise<ScheduledReport> => {
  // Template kontrolü
  await getReportTemplateById(data.report_template_id);

  // Next run time hesapla
  const nextRunAt = calculateNextRunTime(data.schedule_config);

  const result = await query<{ id: number }>(
    `INSERT INTO Scheduled_Reports 
     (report_template_id, name, description, schedule_config, recipients, depot_filters, start_date, end_date, status, created_by, next_run_at)
     OUTPUT INSERTED.id
     VALUES (@templateId, @name, @description, @scheduleConfig, @recipients, @depotFilters, @startDate, @endDate, @status, @createdBy, @nextRunAt)`,
    {
      templateId: data.report_template_id,
      name: data.name,
      description: data.description || null,
      scheduleConfig: JSON.stringify(data.schedule_config),
      recipients: JSON.stringify(data.recipients),
      depotFilters: data.depot_filters ? JSON.stringify(data.depot_filters) : null,
      startDate: data.start_date || null,
      endDate: data.end_date || null,
      status: data.status || null,
      createdBy: userId,
      nextRunAt: nextRunAt,
    }
  );

  return getScheduledReportById(result[0].id);
};

export const updateScheduledReport = async (
  id: number,
  data: Partial<CreateScheduledReportData> & { is_active?: boolean }
): Promise<ScheduledReport> => {
  await getScheduledReportById(id);

  const updates: string[] = [];
  const params: any = { id };

  if (data.report_template_id !== undefined) {
    await getReportTemplateById(data.report_template_id);
    updates.push('report_template_id = @templateId');
    params.templateId = data.report_template_id;
  }

  if (data.name !== undefined) {
    updates.push('name = @name');
    params.name = data.name;
  }

  if (data.description !== undefined) {
    updates.push('description = @description');
    params.description = data.description;
  }

  if (data.schedule_config !== undefined) {
    updates.push('schedule_config = @scheduleConfig');
    params.scheduleConfig = JSON.stringify(data.schedule_config);
    // Next run time'i yeniden hesapla
    const nextRunAt = calculateNextRunTime(data.schedule_config);
    updates.push('next_run_at = @nextRunAt');
    params.nextRunAt = nextRunAt;
  }

  if (data.recipients !== undefined) {
    updates.push('recipients = @recipients');
    params.recipients = JSON.stringify(data.recipients);
  }

  if (data.depot_filters !== undefined) {
    updates.push('depot_filters = @depotFilters');
    params.depotFilters = data.depot_filters ? JSON.stringify(data.depot_filters) : null;
  }

  if (data.start_date !== undefined) {
    updates.push('start_date = @startDate');
    params.startDate = data.start_date || null;
  }

  if (data.end_date !== undefined) {
    updates.push('end_date = @endDate');
    params.endDate = data.end_date || null;
  }

  if (data.status !== undefined) {
    updates.push('status = @status');
    params.status = data.status || null;
  }

  if (data.is_active !== undefined) {
    updates.push('is_active = @isActive');
    params.isActive = data.is_active;
  }

  if (updates.length === 0) {
    return getScheduledReportById(id);
  }

  updates.push('updated_at = GETDATE()');

  await query(
    `UPDATE Scheduled_Reports 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  return getScheduledReportById(id);
};

export const deleteScheduledReport = async (id: number): Promise<void> => {
  await getScheduledReportById(id);
  await query(`DELETE FROM Scheduled_Reports WHERE id = @id`, { id });
};

import { getTurkeyDate } from '../utils/dateHelper';

// Next run time hesapla
function calculateNextRunTime(scheduleConfig: ScheduleConfig): Date {
  const now = getTurkeyDate();
  const nextRun = new Date(now);

  // Saat ve dakikayı ayarla
  nextRun.setHours(scheduleConfig.hour, scheduleConfig.minute, 0, 0);

  if (scheduleConfig.repeat_type === 'daily') {
    // Günlük: Eğer bugünün saati geçtiyse yarın
    if (nextRun <= now) {
      nextRun.setDate(nextRun.getDate() + 1);
    }
  } else if (scheduleConfig.repeat_type === 'weekly') {
    // Haftalık: Belirtilen günlerden birine ayarla
    if (scheduleConfig.day && scheduleConfig.day.length > 0) {
      const currentDay = now.getDay();
      const targetDays = scheduleConfig.day.sort((a, b) => a - b);
      
      // Bu hafta içinde bir gün var mı?
      const thisWeekDay = targetDays.find((day) => day > currentDay);
      if (thisWeekDay !== undefined) {
        const daysToAdd = thisWeekDay - currentDay;
        nextRun.setDate(nextRun.getDate() + daysToAdd);
      } else {
        // Gelecek hafta ilk gün
        const daysToAdd = 7 - currentDay + targetDays[0];
        nextRun.setDate(nextRun.getDate() + daysToAdd);
      }
    }
  } else if (scheduleConfig.repeat_type === 'monthly') {
    // Aylık: Belirtilen günlerden birine ayarla
    if (scheduleConfig.day && scheduleConfig.day.length > 0) {
      const currentDay = now.getDate();
      const targetDays = scheduleConfig.day.sort((a, b) => a - b);
      
      // Bu ay içinde bir gün var mı?
      const thisMonthDay = targetDays.find((day) => day >= currentDay);
      if (thisMonthDay !== undefined) {
        nextRun.setDate(thisMonthDay);
      } else {
        // Gelecek ay ilk gün
        nextRun.setMonth(nextRun.getMonth() + 1);
        nextRun.setDate(targetDays[0]);
      }
    }
  }

  return nextRun;
}

// Çalıştırılması gereken scheduled report'ları getir
export const getDueScheduledReports = async (): Promise<ScheduledReport[]> => {
  const now = getTurkeyDate();
  return query<ScheduledReport>(
    `SELECT id, report_template_id, name, description, schedule_config, recipients,
            depot_filters, start_date, end_date, status,
            is_active, last_run_at, next_run_at, created_by, created_at, updated_at
     FROM Scheduled_Reports
     WHERE is_active = 1 AND next_run_at <= @now
     ORDER BY next_run_at ASC`,
    { now: now.toISOString() }
  );
};

// Scheduled report'ı çalıştır ve next_run_at'i güncelle
export const executeScheduledReport = async (scheduledReportId: number): Promise<void> => {
  const scheduledReport = await getScheduledReportById(scheduledReportId);
  const scheduleConfig = JSON.parse(scheduledReport.schedule_config) as ScheduleConfig;

  // Raporu çalıştır - Filtreleri topla
  const filters: any = {};
  if (scheduledReport.depot_filters) {
    const depotIds = JSON.parse(scheduledReport.depot_filters);
    // Her depo için ayrı rapor gönderilebilir veya tek rapor gönderilebilir
    if (depotIds.length === 1) {
      filters.depot_id = depotIds[0];
    } else if (depotIds.length > 1) {
      filters.depot_ids = depotIds;
    }
  }
  if (scheduledReport.start_date) {
    filters.start_date = scheduledReport.start_date;
  }
  if (scheduledReport.end_date) {
    filters.end_date = scheduledReport.end_date;
  }
  if (scheduledReport.status) {
    // Status virgülle ayrılmış string olabilir (çoklu durum)
    const statusArray = scheduledReport.status.split(',').map((s: string) => s.trim()).filter((s: string) => s);
    if (statusArray.length === 1) {
      filters.status = statusArray[0];
    } else if (statusArray.length > 1) {
      filters.statuses = statusArray;
    }
  }

  // Raporu çalıştır ve sonucu kaydet
  const result = await executeReport(scheduledReport.report_template_id, filters);

  // Execution kaydı oluştur
  await query(
    `INSERT INTO Report_Executions 
     (report_template_id, scheduled_report_id, execution_type, status, row_count, created_at)
     VALUES (@templateId, @scheduledId, 'SCHEDULED', 'SUCCESS', @rowCount, ${getTurkeyDateSQL()})`,
    {
      templateId: scheduledReport.report_template_id,
      scheduledId: scheduledReportId,
      rowCount: result.length,
    }
  );

  // Next run time'i güncelle
  const nextRunAt = calculateNextRunTime(scheduleConfig);
  await query(
    `UPDATE Scheduled_Reports 
     SET last_run_at = ${getTurkeyDateSQL()}, next_run_at = @nextRunAt
     WHERE id = @id`,
    {
      id: scheduledReportId,
      nextRunAt: nextRunAt,
    }
  );
};
