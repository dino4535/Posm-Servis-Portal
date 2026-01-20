import { query } from '../config/database';
import { AuthRequest } from '../middleware/auth';
import { AUDIT_ACTIONS, AuditAction } from '../config/constants';
import { getRealIpAddress, getRealIpAddressSync } from '../utils/ip_helper';

export interface AuditLogData {
  user_id?: number;
  action: AuditAction;
  entity_type?: string;
  entity_id?: number;
  old_values?: any;
  new_values?: any;
  ip_address?: string;
  user_agent?: string;
}

export const createAuditLog = async (
  data: AuditLogData,
  req?: AuthRequest
) => {
  try {
    // Eğer data'da IP varsa onu kullan, yoksa req'den al
    let ipAddress = data.ip_address;
    if (!ipAddress && req) {
      // Async IP alma işlemi audit log'u yavaşlatmamalı, sync versiyonu kullan
      ipAddress = getRealIpAddressSync(req);
    }
    const userAgent = req?.get('user-agent') || data.user_agent;

    await query(
      `INSERT INTO Audit_Logs 
       (user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent)
       VALUES (@userId, @action, @entityType, @entityId, @oldValues, @newValues, @ipAddress, @userAgent)`,
      {
        userId: data.user_id || req?.user?.id || null,
        action: data.action,
        entityType: data.entity_type || null,
        entityId: data.entity_id || null,
        oldValues: data.old_values ? JSON.stringify(data.old_values) : null,
        newValues: data.new_values ? JSON.stringify(data.new_values) : null,
        ipAddress: ipAddress || null,
        userAgent: userAgent || null,
      }
    );
  } catch (error) {
    console.error('Audit log oluşturma hatası:', error);
    // Audit log hatası uygulamayı durdurmamalı
  }
};
