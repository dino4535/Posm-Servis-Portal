import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin } from '../middleware/authorize';
import {
  getAllUsersController,
  getUserByIdController,
  createUserController,
  updateUserController,
  deleteUserController,
  getUserDepotsController,
  assignDepotController,
  removeDepotController,
} from '../controllers/userController';

const router = Router();

// Tüm route'lar authentication gerektirir
router.use(authenticate);

// Admin only routes
router.get('/', isAdmin, getAllUsersController);
router.post('/', isAdmin, createUserController);
router.get('/:id', isAdmin, getUserByIdController);
router.put('/:id', isAdmin, updateUserController);
router.delete('/:id', isAdmin, deleteUserController);

// Depo yönetimi
router.get('/:id/depots', isAdmin, getUserDepotsController);
router.post('/:id/depots', isAdmin, assignDepotController);
router.delete('/:id/depots/:depotId', isAdmin, removeDepotController);

export default router;
