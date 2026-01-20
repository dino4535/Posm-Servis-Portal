import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import {
  loginController,
  logoutController,
  logoutAllController,
  meController,
  updateProfileController,
  changePasswordController,
  sendSystemIntroductionEmailController,
} from '../controllers/authController';
import { authenticate } from '../middleware/auth';

const router = Router();

// Login için özel rate limiter (daha esnek)
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 dakika
  max: 50, // Login için 15 dakikada 50 deneme
  message: 'Çok fazla login denemesi yapıldı, lütfen 15 dakika sonra tekrar deneyin.',
  standardHeaders: true,
  legacyHeaders: false,
  skipSuccessfulRequests: true, // Başarılı login'leri sayma
});

router.post('/login', loginLimiter, loginController);
router.post('/logout', authenticate, logoutController);
router.post('/logout-all', authenticate, logoutAllController);
router.get('/me', authenticate, meController);
router.put('/profile', authenticate, updateProfileController);
router.post('/change-password', authenticate, changePasswordController);
router.post('/send-system-introduction', authenticate, isAdminOrTeknik, sendSystemIntroductionEmailController);

export default router;
