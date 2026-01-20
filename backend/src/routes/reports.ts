import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin } from '../middleware/authorize';
import {
  getStatisticsController,
  getReportController,
} from '../controllers/reportController';

const router = Router();

router.use(authenticate);
router.use(isAdmin);

router.get('/statistics', getStatisticsController);
router.get('/requests', getReportController);

export default router;
