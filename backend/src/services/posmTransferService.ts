import { query } from '../config/database';
import { getTurkeyDateSQL } from '../utils/dateHelper';
import { NotFoundError, ValidationError } from '../utils/errors';
import { getPOSMById, updatePOSMStock } from './posmService';

export interface POSMTransfer {
  id: number;
  posm_id: number;
  from_depot_id: number;
  to_depot_id: number;
  quantity: number;
  transfer_type: 'Hazir' | 'Tamir';
  status: 'Beklemede' | 'Onaylandi' | 'Tamamlandi' | 'Iptal';
  requested_by: number;
  approved_by?: number;
  notes?: string;
  created_at: Date;
  updated_at?: Date;
  completed_at?: Date;
  posm_name?: string;
  from_depot_name?: string;
  to_depot_name?: string;
  requested_by_name?: string;
  approved_by_name?: string;
}

export interface CreateTransferData {
  posm_id: number;
  from_depot_id: number;
  to_depot_id: number;
  quantity: number;
  transfer_type: 'Hazir' | 'Tamir';
  notes?: string;
}

export const getAllTransfers = async (
  depotId?: number,
  status?: string
): Promise<POSMTransfer[]> => {
  let sql = `
    SELECT 
      t.id, t.posm_id, t.from_depot_id, t.to_depot_id, t.quantity,
      t.transfer_type, t.status, t.requested_by, t.approved_by, t.notes,
      t.created_at, t.updated_at, t.completed_at,
      p.name as posm_name,
      d1.name as from_depot_name,
      d2.name as to_depot_name,
      u1.name as requested_by_name,
      u2.name as approved_by_name
    FROM POSM_Transfers t
    LEFT JOIN POSM p ON t.posm_id = p.id
    LEFT JOIN Depots d1 ON t.from_depot_id = d1.id
    LEFT JOIN Depots d2 ON t.to_depot_id = d2.id
    LEFT JOIN Users u1 ON t.requested_by = u1.id
    LEFT JOIN Users u2 ON t.approved_by = u2.id
    WHERE 1=1
  `;
  const params: any = {};

  if (depotId) {
    sql += ' AND (t.from_depot_id = @depotId OR t.to_depot_id = @depotId)';
    params.depotId = depotId;
  }

  if (status) {
    sql += ' AND t.status = @status';
    params.status = status;
  }

  sql += ' ORDER BY t.created_at DESC';

  return query<POSMTransfer>(sql, params);
};

export const getTransferById = async (id: number): Promise<POSMTransfer> => {
  const transfers = await query<POSMTransfer>(
    `SELECT 
      t.id, t.posm_id, t.from_depot_id, t.to_depot_id, t.quantity,
      t.transfer_type, t.status, t.requested_by, t.approved_by, t.notes,
      t.created_at, t.updated_at, t.completed_at,
      p.name as posm_name,
      d1.name as from_depot_name,
      d2.name as to_depot_name,
      u1.name as requested_by_name,
      u2.name as approved_by_name
    FROM POSM_Transfers t
    LEFT JOIN POSM p ON t.posm_id = p.id
    LEFT JOIN Depots d1 ON t.from_depot_id = d1.id
    LEFT JOIN Depots d2 ON t.to_depot_id = d2.id
    LEFT JOIN Users u1 ON t.requested_by = u1.id
    LEFT JOIN Users u2 ON t.approved_by = u2.id
    WHERE t.id = @id`,
    { id }
  );

  if (transfers.length === 0) {
    throw new NotFoundError('POSM Transfer');
  }

  return transfers[0];
};

export const createTransfer = async (
  data: CreateTransferData,
  userId: number
): Promise<POSMTransfer> => {
  // Validasyonlar
  if (data.from_depot_id === data.to_depot_id) {
    throw new ValidationError('Kaynak ve hedef depo aynı olamaz');
  }

  if (data.quantity <= 0) {
    throw new ValidationError('Transfer miktarı 0\'dan büyük olmalıdır');
  }

  // POSM var mı kontrol et
  const posm = await getPOSMById(data.posm_id);

  // POSM kaynak depoda mı kontrol et (tip güvenliği için parseInt)
  const posmDepotId = parseInt(posm.depot_id?.toString() || '0', 10);
  const fromDepotId = parseInt(data.from_depot_id?.toString() || '0', 10);
  
  if (posmDepotId !== fromDepotId) {
    throw new ValidationError(
      `POSM kaynak depoda bulunmuyor. Seçilen POSM "${posm.name}" deposunda bulunuyor, ancak kaynak depo olarak farklı bir depo seçilmiş.`
    );
  }

  // Stok kontrolü
  const currentStock =
    data.transfer_type === 'Hazir' ? posm.hazir_adet : posm.tamir_bekleyen;

  if (currentStock < data.quantity) {
    throw new ValidationError(
      `Yetersiz stok. Mevcut: ${currentStock}, İstenen: ${data.quantity}`
    );
  }

  // Depolar var mı kontrol et
  const depots = await query(
    `SELECT id FROM Depots WHERE id IN (@fromDepotId, @toDepotId)`,
    { fromDepotId: data.from_depot_id, toDepotId: data.to_depot_id }
  );
  if (depots.length !== 2) {
    throw new NotFoundError('Depo');
  }

  // Transfer kaydı oluştur
  const result = await query<{ id: number }>(
    `INSERT INTO POSM_Transfers 
     (posm_id, from_depot_id, to_depot_id, quantity, transfer_type, requested_by, notes)
     OUTPUT INSERTED.id
     VALUES (@posmId, @fromDepotId, @toDepotId, @quantity, @transferType, @requestedBy, @notes)`,
    {
      posmId: data.posm_id,
      fromDepotId: data.from_depot_id,
      toDepotId: data.to_depot_id,
      quantity: data.quantity,
      transferType: data.transfer_type,
      requestedBy: userId,
      notes: data.notes || null,
    }
  );

  return getTransferById(result[0].id);
};

export const approveTransfer = async (
  id: number,
  userId: number
): Promise<POSMTransfer> => {
  const transfer = await getTransferById(id);

  if (transfer.status !== 'Beklemede') {
    throw new ValidationError('Sadece beklemede olan transferler onaylanabilir');
  }

  await query(
    `UPDATE POSM_Transfers 
     SET status = 'Onaylandi', approved_by = @approvedBy, updated_at = GETDATE()
     WHERE id = @id`,
    { id, approvedBy: userId }
  );

  return getTransferById(id);
};

export const completeTransfer = async (
  id: number,
  _userId: number
): Promise<POSMTransfer> => {
  const transfer = await getTransferById(id);

  if (transfer.status !== 'Onaylandi') {
    throw new ValidationError('Sadece onaylanmış transferler tamamlanabilir');
  }

  // POSM'i kontrol et
  const posm = await getPOSMById(transfer.posm_id);

  // POSM hala kaynak depoda mı kontrol et
  if (posm.depot_id !== transfer.from_depot_id) {
    throw new ValidationError('POSM artık kaynak depoda bulunmuyor');
  }

  // Stok kontrolü
  const currentStock =
    transfer.transfer_type === 'Hazir'
      ? posm.hazir_adet
      : posm.tamir_bekleyen;

  if (currentStock < transfer.quantity) {
    throw new ValidationError('Yetersiz stok');
  }

  // Transaction başlat (stok güncellemeleri)
  try {
    // Kaynak depodan düş
    const newFromStock =
      transfer.transfer_type === 'Hazir'
        ? posm.hazir_adet - transfer.quantity
        : posm.tamir_bekleyen - transfer.quantity;

    await updatePOSMStock(transfer.posm_id, {
      [transfer.transfer_type === 'Hazir' ? 'hazir_adet' : 'tamir_bekleyen']:
        newFromStock,
    });

    // Hedef depoda POSM var mı kontrol et
    const targetPOSM = await query(
      `SELECT id FROM POSM WHERE name = @name AND depot_id = @depotId`,
      { name: posm.name, depotId: transfer.to_depot_id }
    );

    if (targetPOSM.length > 0) {
      // Hedef depoda POSM var, stok ekle
      const targetPosmId = targetPOSM[0].id;
      const targetPosm = await getPOSMById(targetPosmId);
      const newToStock =
        transfer.transfer_type === 'Hazir'
          ? targetPosm.hazir_adet + transfer.quantity
          : targetPosm.tamir_bekleyen + transfer.quantity;

      await updatePOSMStock(targetPosmId, {
        [transfer.transfer_type === 'Hazir' ? 'hazir_adet' : 'tamir_bekleyen']:
          newToStock,
      });
    } else {
      // Hedef depoda POSM yok, yeni oluştur
      await query(
        `INSERT INTO POSM (name, description, depot_id, hazir_adet, tamir_bekleyen)
         VALUES (@name, @description, @depotId, @hazirAdet, @tamirBekleyen)`,
        {
          name: posm.name,
          description: posm.description || null,
          depotId: transfer.to_depot_id,
          hazirAdet: transfer.transfer_type === 'Hazir' ? transfer.quantity : 0,
          tamirBekleyen:
            transfer.transfer_type === 'Tamir' ? transfer.quantity : 0,
        }
      );
    }

    // Transfer durumunu güncelle
    await query(
      `UPDATE POSM_Transfers 
       SET status = 'Tamamlandi', completed_at = ${getTurkeyDateSQL()}, updated_at = ${getTurkeyDateSQL()}
       WHERE id = @id`,
      { id }
    );

    return getTransferById(id);
  } catch (error) {
    throw new ValidationError('Transfer tamamlanırken hata oluştu');
  }
};

export const cancelTransfer = async (
  id: number,
  _userId: number
): Promise<POSMTransfer> => {
  const transfer = await getTransferById(id);

  if (transfer.status === 'Tamamlandi') {
    throw new ValidationError('Tamamlanmış transferler iptal edilemez');
  }

  await query(
    `UPDATE POSM_Transfers 
     SET status = 'Iptal', updated_at = ${getTurkeyDateSQL()}
     WHERE id = @id`,
    { id }
  );

  return getTransferById(id);
};
