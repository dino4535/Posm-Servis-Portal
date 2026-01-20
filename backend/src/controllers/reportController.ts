import { Request, Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import { getRequestStatistics, getRequestReport } from '../services/reportService';

export const getStatisticsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const startDate = req.query.start_date as string | undefined;
    const endDate = req.query.end_date as string | undefined;
    // Çoklu depot_id desteği
    const depotIds = req.query.depot_id
      ? (Array.isArray(req.query.depot_id)
          ? (req.query.depot_id as string[]).map((id) => parseInt(id, 10))
          : [parseInt(req.query.depot_id as string, 10)])
      : undefined;

    const statistics = await getRequestStatistics(startDate, endDate, depotIds);
    res.json({ success: true, data: statistics });
  } catch (error) {
    next(error);
  }
};

export const getReportController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const startDate = req.query.start_date as string | undefined;
    const endDate = req.query.end_date as string | undefined;
    // Çoklu depot_id desteği
    const depotIds = req.query.depot_id
      ? (Array.isArray(req.query.depot_id)
          ? (req.query.depot_id as string[]).map((id) => parseInt(id, 10))
          : [parseInt(req.query.depot_id as string, 10)])
      : undefined;
    // Çoklu status desteği
    const statuses = req.query.status
      ? (Array.isArray(req.query.status)
          ? (req.query.status as string[])
          : [req.query.status as string])
      : undefined;

    const report = await getRequestReport(startDate, endDate, depotIds, statuses);
    res.json({ success: true, data: report });
  } catch (error) {
    next(error);
  }
};
