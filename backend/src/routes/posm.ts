import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdminOrTeknik } from '../middleware/authorize';
import {
  getAllPOSMController,
  getPOSMByIdController,
  getPOSMStockController,
  createPOSMController,
  updatePOSMController,
  updatePOSMStockController,
  deletePOSMController,
  bulkInsertPosmToAllDepotsController,
} from '../controllers/posmController';
import { isAdmin } from '../middleware/authorize';

const router = Router();

router.use(authenticate);

router.get('/', getAllPOSMController);
router.get('/:id', getPOSMByIdController);
router.get('/:id/stock', getPOSMStockController);
router.post('/', isAdminOrTeknik, createPOSMController);
router.post('/bulk-insert-all-depots', isAdmin, bulkInsertPosmToAllDepotsController);
router.put('/:id', isAdminOrTeknik, updatePOSMController);
router.put('/:id/stock', isAdminOrTeknik, updatePOSMStockController);
router.delete('/:id', isAdminOrTeknik, deletePOSMController);

export default router;
