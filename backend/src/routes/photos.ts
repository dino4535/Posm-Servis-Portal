import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { upload } from '../middleware/upload';
import {
  getPhotosByRequestController,
  uploadPhotoController,
  uploadPhotosController,
  getPhotoController,
  getPhotoBase64Controller,
  deletePhotoController,
} from '../controllers/photoController';

const router = Router();

router.use(authenticate);

router.get('/request/:requestId', getPhotosByRequestController);
router.post('/', upload.array('photo', 10), uploadPhotosController);
router.get('/:id/base64', getPhotoBase64Controller);
router.get('/:id', getPhotoController);
router.delete('/:id', deletePhotoController);

export default router;
