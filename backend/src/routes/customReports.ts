import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin } from '../middleware/authorize';
import {
  getAllReportTemplatesController,
  getReportTemplateByIdController,
  createReportTemplateController,
  updateReportTemplateController,
  deleteReportTemplateController,
  executeReportController,
  getAllScheduledReportsController,
  getScheduledReportByIdController,
  createScheduledReportController,
  updateScheduledReportController,
  deleteScheduledReportController,
  runScheduledReportsController,
} from '../controllers/customReportController';

const router = Router();

router.use(authenticate);
router.use(isAdmin); // Sadece Admin erişebilir

// Report Templates
router.get('/templates', getAllReportTemplatesController);
router.get('/templates/:id', getReportTemplateByIdController);
router.post('/templates', createReportTemplateController);
router.put('/templates/:id', updateReportTemplateController);
router.delete('/templates/:id', deleteReportTemplateController);
router.post('/templates/:id/execute', executeReportController);

// Scheduled Reports
router.get('/scheduled', getAllScheduledReportsController);
router.get('/scheduled/:id', getScheduledReportByIdController);
router.post('/scheduled', createScheduledReportController);
router.put('/scheduled/:id', updateScheduledReportController);
router.delete('/scheduled/:id', deleteScheduledReportController);
router.post('/scheduled/run', runScheduledReportsController); // Cron job için

export default router;
