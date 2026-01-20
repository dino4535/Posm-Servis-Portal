import { query } from '../config/database';
import { NotFoundError } from '../utils/errors';
import fs from 'fs';
import path from 'path';
import { config } from '../config/env';

export interface Photo {
  id: number;
  request_id: number;
  file_name: string;
  file_path: string;
  file_size?: number;
  mime_type?: string;
  uploaded_by?: number;
  created_at: Date;
}

export const getPhotosByRequestId = async (requestId: number): Promise<Photo[]> => {
  // Request var mı kontrol et
  const requests = await query(`SELECT id FROM Requests WHERE id = @requestId`, {
    requestId,
  });
  if (requests.length === 0) {
    throw new NotFoundError('Request');
  }

  return query<Photo>(
    `SELECT id, request_id, file_name, file_path, file_size, mime_type, uploaded_by, created_at
     FROM Photos
     WHERE request_id = @requestId
     ORDER BY created_at DESC`,
    { requestId }
  );
};

export const getPhotoById = async (id: number): Promise<Photo> => {
  const photos = await query<Photo>(
    `SELECT id, request_id, file_name, file_path, file_size, mime_type, uploaded_by, created_at
     FROM Photos
     WHERE id = @id`,
    { id }
  );

  if (photos.length === 0) {
    throw new NotFoundError('Photo');
  }

  return photos[0];
};

export const createPhoto = async (
  requestId: number,
  fileName: string,
  filePath: string,
  fileSize: number,
  mimeType: string,
  uploadedBy: number
): Promise<Photo> => {
  // Request var mı kontrol et
  const requests = await query(`SELECT id FROM Requests WHERE id = @requestId`, {
    requestId,
  });
  if (requests.length === 0) {
    throw new NotFoundError('Request');
  }

  const result = await query<{ id: number }>(
    `INSERT INTO Photos (request_id, file_name, file_path, file_size, mime_type, uploaded_by)
     OUTPUT INSERTED.id
     VALUES (@requestId, @fileName, @filePath, @fileSize, @mimeType, @uploadedBy)`,
    {
      requestId,
      fileName,
      filePath,
      fileSize,
      mimeType,
      uploadedBy,
    }
  );

  return getPhotoById(result[0].id);
};

export const deletePhoto = async (id: number): Promise<void> => {
  const photo = await getPhotoById(id);

  // Dosyayı sil
  const fullPath = path.join(config.upload.uploadPath, photo.file_path);
  if (fs.existsSync(fullPath)) {
    fs.unlinkSync(fullPath);
  }

  // Veritabanından sil
  await query(`DELETE FROM Photos WHERE id = @id`, { id });
};

export const getPhotoFilePath = async (id: number): Promise<string> => {
  const photo = await getPhotoById(id);
  return path.join(config.upload.uploadPath, photo.file_path);
};
