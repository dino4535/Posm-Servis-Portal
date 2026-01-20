import { Router } from 'express';
import { authenticate } from '../middleware/auth';
import { isAdmin } from '../middleware/authorize';
import { query } from '../config/database';

const router = Router();

router.use(authenticate);
router.use(isAdmin);

router.get('/', async (req, res, next) => {
  try {
    const { user_id, entity_type, start_date, end_date, limit = 100, offset = 0 } = req.query;

    let whereConditions: string[] = [];
    const params: any = { limit: parseInt(limit as string, 10), offset: parseInt(offset as string, 10) };

    if (user_id) {
      whereConditions.push('al.user_id = @userId');
      params.userId = parseInt(user_id as string, 10);
    }

    if (entity_type) {
      whereConditions.push('al.entity_type = @entityType');
      params.entityType = entity_type as string;
    }

    if (start_date) {
      whereConditions.push('al.created_at >= @startDate');
      params.startDate = start_date as string;
    }

    if (end_date) {
      whereConditions.push('al.created_at <= @endDate');
      params.endDate = end_date as string;
    }

    const whereClause = whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

    const logs = await query(
      `SELECT al.id, al.user_id, u.name as user_name, al.action, al.entity_type, al.entity_id, 
              al.old_values, al.new_values, al.ip_address, al.user_agent, al.created_at
       FROM Audit_Logs al
       LEFT JOIN Users u ON al.user_id = u.id
       ${whereClause}
       ORDER BY al.created_at DESC
       OFFSET @offset ROWS
       FETCH NEXT @limit ROWS ONLY`,
      params
    );

    const total = await query<{ count: number }>(
      `SELECT COUNT(*) as count
       FROM Audit_Logs al
       ${whereClause}`,
      params
    );

    res.json({
      success: true,
      data: logs,
      total: total[0]?.count || 0,
    });
  } catch (error) {
    next(error);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const { id } = req.params;
    const logs = await query(
      `SELECT id, user_id, action, entity_type, entity_id, old_values, new_values,
              ip_address, user_agent, created_at
       FROM Audit_Logs
       WHERE id = @id`,
      { id: parseInt(id, 10) }
    );

    if (logs.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Audit log bulunamadı',
      });
    }

    return res.json({ success: true, data: logs[0] });
  } catch (error) {
    return next(error);
  }
});

export default router;
