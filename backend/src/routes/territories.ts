import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdminOrTeknik } from '../middleware/authorize';
import {
  getAllTerritoriesController,
  getTerritoryByIdController,
  createTerritoryController,
  updateTerritoryController,
  deleteTerritoryController,
} from '../controllers/territoryController';

const router = Router();

router.use(authenticate);

router.get('/', getAllTerritoriesController);
router.get('/:id', getTerritoryByIdController);
router.post('/', isAdminOrTeknik, createTerritoryController);
router.put('/:id', isAdminOrTeknik, updateTerritoryController);
router.delete('/:id', isAdminOrTeknik, deleteTerritoryController);

export default router;
