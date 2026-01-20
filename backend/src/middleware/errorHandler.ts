import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors';
import { logger } from '../utils/logger';

export const errorHandler = (
  err: Error | AppError,
  _req: Request,
  res: Response,
  _next: NextFunction
) => {
  if (err instanceof AppError) {
    logger.error(`AppError: ${err.message}`, {
      statusCode: err.statusCode,
      path: _req.path,
      method: _req.method,
    });
    
    return res.status(err.statusCode).json({
      success: false,
      error: err.message,
    });
  }

  logger.error(`Unexpected error: ${err.message}`, {
    stack: err.stack,
    path: _req.path,
    method: _req.method,
  });

  return res.status(500).json({
    success: false,
    error: err.message || 'Sunucu hatası',
    ...(process.env.NODE_ENV === 'development' && { 
      details: err.message,
      stack: err.stack 
    }),
  });
};
