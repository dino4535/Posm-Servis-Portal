import { query } from '../config/database';
import { REQUEST_STATUS } from '../config/constants';

export interface RequestStatistics {
  total: number;
  beklemede: number;
  planlandi: number;
  tamamlandi: number;
  iptal: number;
  by_type: { type: string; count: number }[];
  by_depot: { depot_name: string; count: number }[];
  by_month: { month: string; count: number }[];
}

export interface RequestReport {
  request_no: string;
  bayi_adi: string;
  bayi_kodu: string;
  territory_name?: string;
  territory_code?: string;
  posm_name?: string;
  yapilacak_is: string;
  durum: string;
  istenen_tarih: string;
  planlanan_tarih?: string;
  tamamlanma_tarihi?: string;
  user_name: string;
  depot_name: string;
  created_at: string;
}

export const getRequestStatistics = async (
  startDate?: string,
  endDate?: string,
  depotIds?: number[]
): Promise<RequestStatistics> => {
  let whereClause = '';
  const params: any = {};

  const conditions: string[] = [];
  if (startDate) {
    conditions.push('r.created_at >= @startDate');
    params.startDate = startDate;
  }
  if (endDate) {
    conditions.push('r.created_at <= @endDate');
    params.endDate = endDate;
  }
  if (depotIds && depotIds.length > 0) {
    conditions.push('r.depot_id IN (' + depotIds.map((_, i) => `@depotId${i}`).join(', ') + ')');
    depotIds.forEach((id, i) => {
      params[`depotId${i}`] = id;
    });
  }
  
  if (conditions.length > 0) {
    whereClause = `WHERE ${conditions.join(' AND ')}`;
  }

  // Genel istatistikler
  const statusCounts = await query<{ durum: string; count: number }>(
    `SELECT durum, COUNT(*) as count
     FROM Requests r
     ${whereClause}
     GROUP BY durum`,
    params
  );

  // Tip bazlı istatistikler
  const typeCounts = await query<{ type: string; count: number }>(
    `SELECT yapilacak_is as type, COUNT(*) as count
     FROM Requests r
     ${whereClause}
     GROUP BY yapilacak_is`,
    params
  );

  // Depo bazlı istatistikler
  const depotCounts = await query<{ depot_name: string; count: number }>(
    `SELECT d.name as depot_name, COUNT(*) as count
     FROM Requests r
     LEFT JOIN Depots d ON r.depot_id = d.id
     ${whereClause}
     GROUP BY d.name`,
    params
  );

  // Aylık istatistikler
  const monthCounts = await query<{ month: string; count: number }>(
    `SELECT FORMAT(r.created_at, 'yyyy-MM') as month, COUNT(*) as count
     FROM Requests r
     ${whereClause}
     GROUP BY FORMAT(r.created_at, 'yyyy-MM')
     ORDER BY month DESC`,
    params
  );

  const stats: RequestStatistics = {
    total: 0,
    beklemede: 0,
    planlandi: 0,
    tamamlandi: 0,
    iptal: 0,
    by_type: typeCounts,
    by_depot: depotCounts,
    by_month: monthCounts,
  };

  statusCounts.forEach((item) => {
    stats.total += item.count;
    if (item.durum === REQUEST_STATUS.BEKLEMEDE) stats.beklemede = item.count;
    else if (item.durum === REQUEST_STATUS.PLANLANDI) stats.planlandi = item.count;
    else if (item.durum === REQUEST_STATUS.TAMAMLANDI) stats.tamamlandi = item.count;
    else if (item.durum === REQUEST_STATUS.IPTAL) stats.iptal = item.count;
  });

  return stats;
};

export const getRequestReport = async (
  startDate?: string,
  endDate?: string,
  depotIds?: number[],
  statuses?: string[]
): Promise<RequestReport[]> => {
  const conditions: string[] = [];
  const params: any = {};

  if (startDate) {
    conditions.push('r.created_at >= @startDate');
    params.startDate = startDate;
  }
  if (endDate) {
    conditions.push('r.created_at <= @endDate');
    params.endDate = endDate;
  }
  if (depotIds && depotIds.length > 0) {
    conditions.push('r.depot_id IN (' + depotIds.map((_, i) => `@depotId${i}`).join(', ') + ')');
    depotIds.forEach((id, i) => {
      params[`depotId${i}`] = id;
    });
  }
  if (statuses && statuses.length > 0) {
    conditions.push('r.durum IN (' + statuses.map((_, i) => `@status${i}`).join(', ') + ')');
    statuses.forEach((status, i) => {
      params[`status${i}`] = status;
    });
  }

  const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

  return query<RequestReport>(
    `SELECT 
      r.request_no,
      ISNULL(d.name, '') as bayi_adi,
      ISNULL(d.code, '') as bayi_kodu,
      ISNULL(t.name, '') as territory_name,
      ISNULL(t.code, '') as territory_code,
      ISNULL(p.name, '') as posm_name,
      r.yapilacak_is,
      r.durum,
      FORMAT(r.istenen_tarih, 'dd.MM.yyyy') as istenen_tarih,
      CASE WHEN r.planlanan_tarih IS NOT NULL THEN FORMAT(r.planlanan_tarih, 'dd.MM.yyyy') ELSE NULL END as planlanan_tarih,
      CASE WHEN r.tamamlanma_tarihi IS NOT NULL THEN FORMAT(r.tamamlanma_tarihi, 'dd.MM.yyyy') ELSE NULL END as tamamlanma_tarihi,
      ISNULL(u.name, '') as user_name,
      ISNULL(dep.name, '') as depot_name,
      FORMAT(r.created_at, 'dd.MM.yyyy HH:mm') as created_at
    FROM Requests r
    LEFT JOIN Dealers d ON r.dealer_id = d.id
    LEFT JOIN Territories t ON r.territory_id = t.id
    LEFT JOIN POSM p ON r.posm_id = p.id
    LEFT JOIN Users u ON r.user_id = u.id
    LEFT JOIN Depots dep ON r.depot_id = dep.id
    ${whereClause}
    ORDER BY r.created_at DESC`,
    params
  );
};
