import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin } from '../middleware/authorize';
import {
  getAllDepotsController,
  getDepotByIdController,
  createDepotController,
  updateDepotController,
  deleteDepotController,
} from '../controllers/depotController';

const router = Router();

// Tüm kullanıcılar kendi depolarını görebilir
router.get('/', authenticate, getAllDepotsController);
router.get('/:id', authenticate, getDepotByIdController);

// Admin only routes
router.post('/', authenticate, isAdmin, createDepotController);
router.put('/:id', authenticate, isAdmin, updateDepotController);
router.delete('/:id', authenticate, isAdmin, deleteDepotController);

export default router;
