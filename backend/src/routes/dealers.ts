import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdminOrTeknik, isAdmin } from '../middleware/authorize';
import { excelUpload } from '../middleware/excelUpload';
import {
  getAllDealersController,
  searchDealersController,
  getDealerByIdController,
  createDealerController,
  updateDealerController,
  deleteDealerController,
} from '../controllers/dealerController';
import { bulkImportDealersController } from '../controllers/bulkDealerImportController';

const router = Router();

router.use(authenticate);

router.get('/search', searchDealersController);
router.get('/', getAllDealersController);
router.get('/:id', getDealerByIdController);
router.post('/', isAdminOrTeknik, createDealerController);
router.post('/bulk-import', isAdmin, excelUpload.single('file'), bulkImportDealersController);
router.put('/:id', isAdminOrTeknik, updateDealerController);
router.delete('/:id', isAdminOrTeknik, deleteDealerController);

export default router;
