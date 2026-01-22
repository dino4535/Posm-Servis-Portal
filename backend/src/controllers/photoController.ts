import { Response, NextFunction } from 'express';
import { AuthRequest } from '../middleware/auth';
import {
  getPhotosByRequestId,
  getPhotoById,
  createPhoto,
  deletePhoto,
} from '../services/photoService';
import { createAuditLog } from '../services/auditService';
import { AUDIT_ACTIONS } from '../config/constants';
import fs from 'fs';
import path from 'path';
import { config } from '../config/env';
import { query } from '../config/database';

export const getPhotosByRequestController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { requestId } = req.params;
    const photos = await getPhotosByRequestId(parseInt(requestId, 10));
    res.json({ success: true, data: photos });
  } catch (error) {
    next(error);
  }
};

export const uploadPhotoController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        error: 'Fotoğraf dosyası gereklidir',
      });
    }

    const { request_id } = req.body;
    if (!request_id) {
      return res.status(400).json({
        success: false,
        error: 'Request ID gereklidir',
      });
    }

    // Talep numarasını al
    const requests = await query<any>(
      `SELECT request_no FROM Requests WHERE id = @requestId`,
      { requestId: parseInt(request_id, 10) }
    );
    
    if (requests.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Talep bulunamadı',
      });
    }
    
    const requestNo = requests[0].request_no;
    
    // Bu talebe ait mevcut fotoğraf sayısını al
    const existingPhotos = await query<any>(
      `SELECT COUNT(*) as count FROM Photos WHERE request_id = @requestId`,
      { requestId: parseInt(request_id, 10) }
    );
    
    const photoCount = existingPhotos.length > 0 ? (existingPhotos[0].count || 0) : 0;
    const nextPhotoNumber = photoCount + 1;
    
    // Dosya uzantısını al
    const ext = path.extname(req.file.originalname) || path.extname(req.file.filename) || '.jpg';
    
    // Yeni dosya adı: talepnumarası-fotoğraf numarası.uzantı
    const newFileName = `${requestNo}-${nextPhotoNumber}${ext}`;
    const oldFilePath = path.join(config.upload.uploadPath, req.file.filename);
    const newFilePath = path.join(config.upload.uploadPath, newFileName);
    
    // Dosya ismini değiştir
    if (fs.existsSync(oldFilePath)) {
      fs.renameSync(oldFilePath, newFilePath);
    }

    const photo = await createPhoto(
      parseInt(request_id, 10),
      req.file.originalname,
      newFileName,
      req.file.size,
      req.file.mimetype,
      req.user!.id
    );

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.CREATE,
        entity_type: 'Photo',
        entity_id: photo.id,
        new_values: { request_id: photo.request_id, file_name: photo.file_name },
      },
      req
    );

    return res.status(201).json({ success: true, data: photo });
  } catch (error) {
    return next(error);
  }
};

export const uploadPhotosController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const files = req.files as Express.Multer.File[];
    
    if (!files || files.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'En az bir fotoğraf dosyası gereklidir',
      });
    }

    const { request_id } = req.body;
    if (!request_id) {
      return res.status(400).json({
        success: false,
        error: 'Request ID gereklidir',
      });
    }

    // Talep numarasını al
    const requests = await query<any>(
      `SELECT request_no FROM Requests WHERE id = @requestId`,
      { requestId: parseInt(request_id, 10) }
    );
    
    if (requests.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Talep bulunamadı',
      });
    }
    
    const requestNo = requests[0].request_no;
    
    const uploadedPhotos = [];
    
    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      
      // Bu talebe ait mevcut fotoğraf sayısını al (bu dosya dahil)
      const existingPhotos = await query<any>(
        `SELECT COUNT(*) as count FROM Photos WHERE request_id = @requestId`,
        { requestId: parseInt(request_id, 10) }
      );
      
      const photoCount = existingPhotos.length > 0 ? (existingPhotos[0].count || 0) : 0;
      const nextPhotoNumber = photoCount + i + 1;
      
      // Dosya uzantısını al
      const ext = path.extname(file.originalname) || path.extname(file.filename) || '.jpg';
      
      // Yeni dosya adı: talepnumarası-fotoğraf numarası.uzantı
      const newFileName = `${requestNo}-${nextPhotoNumber}${ext}`;
      const oldFilePath = path.join(config.upload.uploadPath, file.filename);
      const newFilePath = path.join(config.upload.uploadPath, newFileName);
      
      // Dosya ismini değiştir
      if (fs.existsSync(oldFilePath)) {
        fs.renameSync(oldFilePath, newFilePath);
      }
      
      const photo = await createPhoto(
        parseInt(request_id, 10),
        file.originalname,
        newFileName,
        file.size,
        file.mimetype,
        req.user!.id
      );

      await createAuditLog(
        {
          action: AUDIT_ACTIONS.CREATE,
          entity_type: 'Photo',
          entity_id: photo.id,
          new_values: { request_id: photo.request_id, file_name: photo.file_name },
        },
        req
      );

      uploadedPhotos.push(photo);
    }

    return res.status(201).json({ success: true, data: uploadedPhotos });
  } catch (error) {
    return next(error);
  }
};

export const getPhotoController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const photo = await getPhotoById(parseInt(id, 10));
    const filePath = path.join(config.upload.uploadPath, photo.file_path);

    console.log('[PHOTO] Fotoğraf isteniyor - ID:', id, 'Path:', filePath);
    console.log('[PHOTO] User:', req.user?.email);

    if (!fs.existsSync(filePath)) {
      console.error('[PHOTO] Dosya bulunamadı:', filePath);
      return res.status(404).json({
        success: false,
        error: 'Fotoğraf dosyası bulunamadı',
      });
    }

    // Content-Type header'ını ayarla
    const mimeType = photo.mime_type || 'image/jpeg';
    res.setHeader('Content-Type', mimeType);
    res.setHeader('Content-Disposition', `inline; filename="${photo.file_name}"`);
    res.setHeader('Cache-Control', 'public, max-age=31536000'); // 1 yıl cache
    res.setHeader('Access-Control-Allow-Origin', config.cors.origin);
    res.setHeader('Access-Control-Allow-Credentials', 'true');

    // Dosyayı stream olarak gönder
    const fileStream = fs.createReadStream(filePath);
    fileStream.pipe(res);
    
    fileStream.on('error', (error) => {
      console.error('[PHOTO] Dosya okuma hatası:', error);
      if (!res.headersSent) {
        res.status(500).json({
          success: false,
          error: 'Fotoğraf okunurken hata oluştu',
        });
      }
    });
    // Stream kullanıldığı için return gerekli değil
    return;
  } catch (error) {
    console.error('[PHOTO] Controller hatası:', error);
    return next(error);
  }
};

export const getPhotoBase64Controller = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const photo = await getPhotoById(parseInt(id, 10));
    const filePath = path.join(config.upload.uploadPath, photo.file_path);

    console.log('[PHOTO BASE64] Fotoğraf isteniyor - ID:', id, 'Path:', filePath);
    console.log('[PHOTO BASE64] User:', req.user?.email);

    if (!fs.existsSync(filePath)) {
      console.error('[PHOTO BASE64] Dosya bulunamadı:', filePath);
      return res.status(404).json({
        success: false,
        error: 'Fotoğraf dosyası bulunamadı',
      });
    }

    // Dosyayı base64 olarak oku
    const fileBuffer = fs.readFileSync(filePath);
    const base64 = fileBuffer.toString('base64');
    const mimeType = photo.mime_type || 'image/jpeg';
    const dataUrl = `data:${mimeType};base64,${base64}`;

    return res.json({
      success: true,
      data: {
        id: photo.id,
        file_name: photo.file_name,
        dataUrl,
        mimeType,
      },
    });
  } catch (error) {
    console.error('[PHOTO BASE64] Controller hatası:', error);
    return next(error);
  }
};

export const deletePhotoController = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const photoId = parseInt(id, 10);

    const oldPhoto = await getPhotoById(photoId);
    await deletePhoto(photoId);

    await createAuditLog(
      {
        action: AUDIT_ACTIONS.DELETE,
        entity_type: 'Photo',
        entity_id: photoId,
        old_values: oldPhoto,
      },
      req
    );

    res.json({ success: true, message: 'Fotoğraf silindi' });
  } catch (error) {
    next(error);
  }
};
