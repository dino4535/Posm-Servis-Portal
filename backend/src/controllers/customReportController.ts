import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getAllReportTemplates,
  getReportTemplateById,
  createReportTemplate,
  updateReportTemplate,
  deleteReportTemplate,
  executeReport,
  getAllScheduledReports,
  getScheduledReportById,
  createScheduledReport,
  updateScheduledReport,
  deleteScheduledReport,
  getDueScheduledReports,
  executeScheduledReport,
} from '../services/customReportService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';

// Report Templates
export const getAllReportTemplatesController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const templates = await getAllReportTemplates(req.user?.id);
    res.json({ success: true, data: templates });
  } catch (error) {
    next(error);
  }
};

export const getReportTemplateByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const template = await getReportTemplateById(parseInt(id, 10));
    res.json({ success: true, data: template });
  } catch (error) {
    next(error);
  }
};

export const createReportTemplateController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const templateData = req.body;
    const newTemplate = await createReportTemplate(templateData, req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'ReportTemplate',
        entity_id: newTemplate.id,
        new_values: { name: newTemplate.name },
      },
      req
    );

    res.status(201).json({ success: true, data: newTemplate });
  } catch (error) {
    next(error);
  }
};

export const updateReportTemplateController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const templateId = parseInt(id, 10);

    const oldTemplate = await getReportTemplateById(templateId);
    const templateData = req.body;
    const updatedTemplate = await updateReportTemplate(templateId, templateData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'ReportTemplate',
        entity_id: templateId,
        old_values: oldTemplate,
        new_values: updatedTemplate,
      },
      req
    );

    res.json({ success: true, data: updatedTemplate });
  } catch (error) {
    next(error);
  }
};

export const deleteReportTemplateController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const templateId = parseInt(id, 10);

    const oldTemplate = await getReportTemplateById(templateId);
    await deleteReportTemplate(templateId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'ReportTemplate',
        entity_id: templateId,
        old_values: oldTemplate,
      },
      req
    );

    res.json({ success: true, message: 'Rapor şablonu silindi' });
  } catch (error) {
    next(error);
  }
};

export const executeReportController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    // Filtreleri hem query hem de body'den al (geriye uyumluluk için)
    const filters = req.body?.filters || req.query;
    const result = await executeReport(parseInt(id, 10), filters);
    res.json({ success: true, data: result });
  } catch (error: any) {
    console.error('Execute Report Controller Error:', error);
    console.error('Error Stack:', error.stack);
    next(error);
  }
};

// Scheduled Reports
export const getAllScheduledReportsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const reports = await getAllScheduledReports();
    res.json({ success: true, data: reports });
  } catch (error) {
    next(error);
  }
};

export const getScheduledReportByIdController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const report = await getScheduledReportById(parseInt(id, 10));
    res.json({ success: true, data: report });
  } catch (error) {
    next(error);
  }
};

export const createScheduledReportController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const reportData = req.body;
    const newReport = await createScheduledReport(reportData, req.user!.id);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'ScheduledReport',
        entity_id: newReport.id,
        new_values: { name: newReport.name },
      },
      req
    );

    res.status(201).json({ success: true, data: newReport });
  } catch (error) {
    next(error);
  }
};

export const updateScheduledReportController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const reportId = parseInt(id, 10);

    const oldReport = await getScheduledReportById(reportId);
    const reportData = req.body;
    const updatedReport = await updateScheduledReport(reportId, reportData);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.UPDATE,
        entity_type: 'ScheduledReport',
        entity_id: reportId,
        old_values: oldReport,
        new_values: updatedReport,
      },
      req
    );

    res.json({ success: true, data: updatedReport });
  } catch (error) {
    next(error);
  }
};

export const deleteScheduledReportController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const reportId = parseInt(id, 10);

    const oldReport = await getScheduledReportById(reportId);
    await deleteScheduledReport(reportId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'ScheduledReport',
        entity_id: reportId,
        old_values: oldReport,
      },
      req
    );

    res.json({ success: true, message: 'Zamanlanmış rapor silindi' });
  } catch (error) {
    next(error);
  }
};

// Scheduled report'ları çalıştır (cron job için)
export const runScheduledReportsController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const dueReports = await getDueScheduledReports();
    const results = [];

    for (const report of dueReports) {
      try {
        await executeScheduledReport(report.id);
        results.push({ id: report.id, name: report.name, status: 'success' });
      } catch (error: any) {
        results.push({ id: report.id, name: report.name, status: 'error', error: error.message });
      }
    }

    res.json({ success: true, data: results });
  } catch (error) {
    next(error);
  }
};
