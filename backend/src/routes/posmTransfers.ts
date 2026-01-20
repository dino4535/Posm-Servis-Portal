import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin, isAdminOrTeknik } from '../middleware/authorize';
import {
  getAllTransfersController,
  getTransferByIdController,
  createTransferController,
  approveTransferController,
  completeTransferController,
  cancelTransferController,
} from '../controllers/posmTransferController';

const router = Router();

router.use(authenticate);

router.get('/', getAllTransfersController);
router.get('/:id', getTransferByIdController);
router.post('/', isAdminOrTeknik, createTransferController);
router.put('/:id/approve', isAdmin, approveTransferController);
router.put('/:id/complete', isAdminOrTeknik, completeTransferController);
router.put('/:id/cancel', isAdminOrTeknik, cancelTransferController);

export default router;
