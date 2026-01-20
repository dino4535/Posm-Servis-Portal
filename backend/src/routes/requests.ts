import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin, isAdminOrTeknik } from '../middleware/authorize';
import {
  getAllRequestsController,
  getRequestByIdController,
  createRequestController,
  updateRequestController,
  planRequestController,
  completeRequestController,
  cancelRequestController,
  getDashboardCountsController,
  deleteRequestController,
} from '../controllers/requestController';

const router = Router();

router.use(authenticate);

router.get('/dashboard/counts', getDashboardCountsController);
router.get('/', getAllRequestsController);
router.get('/:id', getRequestByIdController);
router.post('/', createRequestController);
router.put('/:id', updateRequestController);
router.put('/:id/plan', isAdminOrTeknik, planRequestController);
router.put('/:id/complete', isAdminOrTeknik, completeRequestController);
router.put('/:id/cancel', cancelRequestController);
router.delete('/:id', isAdmin, deleteRequestController);

export default router;
