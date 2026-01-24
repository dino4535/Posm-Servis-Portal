import { query } from '../config/database';
import { NotFoundError, ValidationError } from '../utils/errors';
import { generateRequestNo } from '../utils/helpers';
import { getTurkeyDateString, getTurkeyDateSQL } from '../utils/dateHelper';
import { REQUEST_STATUS, REQUEST_TYPES } from '../config/constants';
import {
  sendRequestCreatedEmail,
  sendRequestCreatedToTechniciansEmail,
  sendRequestCompletedEmail,
  sendRequestNoteAddedEmail,
  sendRequestPlannedEmail,
  sendRequestStatusChangedEmail,
  sendPosmTransferCreatedEmail,
} from './emailService';
import { getPhotosByRequestId } from './photoService';
import { getTechniciansByDepot } from './userService';
import { createTransfer } from './posmTransferService';

export interface Request {
  id: number;
  request_no: string;
  user_id: number;
  depot_id: number;
  territory_id: number;
  dealer_id: number;
  yapilacak_is: string;
  yapilacak_is_detay?: string;
  istenen_tarih: Date;
  planlanan_tarih?: Date;
  tamamlanma_tarihi?: Date;
  tamamlayan_user_id?: number;
  posm_id?: number;
  durum: string;
  priority: number;
  notes?: string;
  created_at: Date;
  updated_at?: Date;
}

export interface CreateRequestData {
  user_id: number;
  depot_id: number;
  territory_id: number;
  dealer_id: number;
  yapilacak_is: string;
  yapilacak_is_detay?: string;
  istenen_tarih: string;
  posm_id?: number;
  priority?: number;
  quantity?: number; // PUSHER için adet
}

export interface UpdateRequestData {
  territory_id?: number;
  dealer_id?: number;
  yapilacak_is?: string;
  yapilacak_is_detay?: string;
  istenen_tarih?: string;
  planlanan_tarih?: string;
  posm_id?: number;
  durum?: string;
  priority?: number;
  notes?: string;
}

export interface RequestFilters {
  user_id?: number;
  depot_id?: number;
  territory_id?: number;
  dealer_id?: number;
  durum?: string;
  durum_in?: string; // virgülle ayrılmış: 'Beklemede,Planlandı'
  my_only?: boolean; // Taleplerim: sadece kullanıcının kendi talepleri (Admin/Teknik için)
  yapilacak_is?: string;
  start_date?: string;
  end_date?: string;
  priority?: number;
}

export const getAllRequests = async (
  filters?: RequestFilters,
  userId?: number,
  role?: string
): Promise<Request[]> => {
  let whereConditions: string[] = [];
  const params: any = {};

  // Kullanıcı yetkisi kontrolü
  if (role === 'Admin') {
    // Admin tüm talepleri görebilir
  } else if (role === 'Teknik') {
    // Teknik kullanıcılar sadece tanımlı oldukları depo/depoların taleplerini görebilir
    if (userId) {
      whereConditions.push(`r.depot_id IN (
        SELECT depot_id 
        FROM User_Depots 
        WHERE user_id = @userId
      )`);
      params.userId = userId;
    }
  } else {
    // User rolü: Sadece kendi taleplerini görebilir
    if (userId) {
      whereConditions.push('r.user_id = @userId');
      params.userId = userId;
    }
  }

  // Taleplerim: Sadece Admin için "kendi açtığım" (user_id). Teknik için depolarındaki Beklemede/Planlandı yeterli (user_id ekleme).
  if (filters?.my_only && userId && role === 'Admin') {
    whereConditions.push('r.user_id = @userId');
    params.userId = userId;
  }

  // Filtreler
  if (filters?.user_id) {
    whereConditions.push('r.user_id = @filterUserId');
    params.filterUserId = filters.user_id;
  }

  if (filters?.depot_id) {
    whereConditions.push('r.depot_id = @depotId');
    params.depotId = filters.depot_id;
  }

  if (filters?.territory_id) {
    whereConditions.push('r.territory_id = @territoryId');
    params.territoryId = filters.territory_id;
  }

  if (filters?.dealer_id) {
    whereConditions.push('r.dealer_id = @dealerId');
    params.dealerId = filters.dealer_id;
  }

  // Taleplerim (my_only): Beklemede ve Planlandı - N'' ile NVARCHAR (mssql parametre Unicode sorunları önlenir)
  if (filters?.my_only) {
    const d0 = REQUEST_STATUS.BEKLEMEDE.replace(/'/g, "''");
    const d1 = REQUEST_STATUS.PLANLANDI.replace(/'/g, "''");
    whereConditions.push(`r.durum IN (N'${d0}', N'${d1}')`);
  } else if (filters?.durum_in) {
    const durumList = filters.durum_in.split(',').map((s: string) => s.trim()).filter(Boolean);
    if (durumList.length > 0) {
      const placeholders = durumList.map((_: string, i: number) => `@durumIn${i}`).join(', ');
      whereConditions.push(`r.durum IN (${placeholders})`);
      durumList.forEach((v: string, i: number) => { params[`durumIn${i}`] = v; });
    }
  } else if (filters?.durum) {
    whereConditions.push('r.durum = @durum');
    params.durum = filters.durum;
  }

  if (filters?.yapilacak_is) {
    whereConditions.push('r.yapilacak_is = @yapilacakIs');
    params.yapilacakIs = filters.yapilacak_is;
  }

  if (filters?.start_date) {
    whereConditions.push('r.istenen_tarih >= @startDate');
    params.startDate = filters.start_date;
  }

  if (filters?.end_date) {
    whereConditions.push('r.istenen_tarih <= @endDate');
    params.endDate = filters.end_date;
  }

  if (filters?.priority !== undefined) {
    whereConditions.push('r.priority = @priority');
    params.priority = filters.priority;
  }

  const whereClause =
    whereConditions.length > 0 ? `WHERE ${whereConditions.join(' AND ')}` : '';

  const requests = await query<any>(
    `SELECT r.id, r.request_no, r.user_id, r.depot_id, r.territory_id, r.dealer_id,
            r.yapilacak_is, r.yapilacak_is_detay, r.istenen_tarih, r.planlanan_tarih,
            r.tamamlanma_tarihi, r.tamamlayan_user_id, r.posm_id, r.durum, r.priority,
            r.notes, r.created_at, r.updated_at,
            d.name as bayi_adi, d.code as bayi_kodu, d.latitude as bayi_latitude, d.longitude as bayi_longitude,
            t.name as territory_name, t.code as territory_code,
            dep.name as depot_name, dep.code as depot_code,
            p.name as posm_name,
            u.name as user_name, u.email as user_email
     FROM Requests r
     LEFT JOIN Dealers d ON r.dealer_id = d.id
     LEFT JOIN Territories t ON r.territory_id = t.id
     LEFT JOIN Depots dep ON r.depot_id = dep.id
     LEFT JOIN POSM p ON r.posm_id = p.id
     LEFT JOIN Users u ON r.user_id = u.id
     ${whereClause}
     ORDER BY r.created_at DESC`,
    params
  );

  return requests as Request[];
};

export const getRequestById = async (
  id: number,
  userId?: number,
  role?: string
): Promise<Request> => {
  let whereConditions = 'r.id = @id';
  const params: any = { id };

  // Kullanıcı yetkisi kontrolü (sadece userId ve role verilmişse)
  if (userId !== undefined && role !== undefined) {
    if (role === 'Admin') {
      // Admin tüm talepleri görebilir
    } else if (role === 'Teknik') {
      // Teknik kullanıcılar sadece tanımlı oldukları depo/depoların taleplerini görebilir
      whereConditions += ` AND r.depot_id IN (
        SELECT depot_id 
        FROM User_Depots 
        WHERE user_id = @userId
      )`;
      params.userId = userId;
    } else {
      // User rolü: Sadece kendi taleplerini görebilir
      whereConditions += ' AND r.user_id = @userId';
      params.userId = userId;
    }
  }

  const requests = await query<any>(
    `SELECT r.id, r.request_no, r.user_id, r.depot_id, r.territory_id, r.dealer_id,
            r.yapilacak_is, r.yapilacak_is_detay, r.istenen_tarih, r.planlanan_tarih,
            r.tamamlanma_tarihi, r.tamamlayan_user_id, r.posm_id, r.durum, r.priority,
            r.notes, r.created_at, r.updated_at,
            d.name as bayi_adi, d.code as bayi_kodu, d.latitude as bayi_latitude, d.longitude as bayi_longitude,
            t.name as territory_name, t.code as territory_code,
            dep.name as depot_name, dep.code as depot_code,
            p.name as posm_name,
            u.name as user_name, u.email as user_email
     FROM Requests r
     LEFT JOIN Dealers d ON r.dealer_id = d.id
     LEFT JOIN Territories t ON r.territory_id = t.id
     LEFT JOIN Depots dep ON r.depot_id = dep.id
     LEFT JOIN POSM p ON r.posm_id = p.id
     LEFT JOIN Users u ON r.user_id = u.id
     WHERE ${whereConditions}`,
    params
  );

  if (requests.length === 0) {
    throw new NotFoundError('Request');
  }

  return requests[0] as Request;
};

export const createRequest = async (data: CreateRequestData): Promise<Request> => {
  // Validasyonlar
  if (!Object.values(REQUEST_TYPES).includes(data.yapilacak_is as any)) {
    throw new ValidationError('Geçersiz yapılacak iş tipi');
  }

  // Territory kontrolü
  const territories = await query(
    `SELECT id FROM Territories WHERE id = @territoryId`,
    { territoryId: data.territory_id }
  );
  if (territories.length === 0) {
    throw new NotFoundError('Territory');
  }

  // Dealer kontrolü
  const dealers = await query(`SELECT id FROM Dealers WHERE id = @dealerId`, {
    dealerId: data.dealer_id,
  });
  if (dealers.length === 0) {
    throw new NotFoundError('Dealer');
  }

  // POSM kontrolü (Tüm iş tipleri için zorunlu - stok takibi için)
  if (!data.posm_id) {
    throw new ValidationError('POSM seçimi zorunludur');
  }

  if (data.posm_id) {
    // POSM kontrolü ve hazır adet kontrolü
    const posms = await query<any>(
      `SELECT id, name, depot_id, hazir_adet 
       FROM POSM 
       WHERE id = @posmId AND is_active = 1`,
      { posmId: data.posm_id }
    );
    if (posms.length === 0) {
      throw new NotFoundError('POSM');
    }

    const posm = posms[0];
    
    // PUSHER için quantity kontrolü
    const isPusher = posm.name && posm.name.toUpperCase().includes('PUSHER');
    if (isPusher && (data.yapilacak_is === REQUEST_TYPES.MONTAJ || data.yapilacak_is === REQUEST_TYPES.DEMONTAJ)) {
      if (!data.quantity || data.quantity <= 0) {
        throw new ValidationError('Pusher için kullanılacak adet miktarı zorunludur');
      }
    }
    
    // POSM'in seçilen depoda olup olmadığını kontrol et
    // Tip dönüşümü yaparak karşılaştır (string vs number sorununu önlemek için)
    const posmDepotId = typeof posm.depot_id === 'string' ? parseInt(posm.depot_id, 10) : posm.depot_id;
    const requestDepotId = typeof data.depot_id === 'string' ? parseInt(data.depot_id, 10) : data.depot_id;
    
    if (posmDepotId !== requestDepotId) {
      throw new ValidationError('Seçilen POSM bu depoda bulunmamaktadır');
    }

    // Hazır adet kontrolü - Sadece Montaj için hazır adet > 0 olmalı
    // Demontaj için hazır adet kontrolü yapılmaz (mevcut POSM sökülüyor, hazır stoktan alınmıyor)
    if (
      data.yapilacak_is === REQUEST_TYPES.MONTAJ &&
      posm.hazir_adet <= 0
    ) {
      // Seçilen depoda stok yok, diğer depoların stoklarını kontrol et
      const otherDepotStocks = await query<any>(
        `SELECT p.id, p.name, p.depot_id, p.hazir_adet, d.name as depot_name, d.code as depot_code
         FROM POSM p
         LEFT JOIN Depots d ON p.depot_id = d.id
         WHERE p.name = @posmName 
           AND p.depot_id != @currentDepotId 
           AND p.hazir_adet > 0 
           AND p.is_active = 1
         ORDER BY p.hazir_adet DESC`,
        { posmName: posm.name, currentDepotId: requestDepotId }
      );

      if (otherDepotStocks.length === 0) {
        // Hiçbir depoda stok yok
        throw new ValidationError(
          `Seçilen POSM için hazır adet bulunmamaktadır (Hazır Adet: ${posm.hazir_adet}). ` +
          `Diğer depolar da kontrol edildi ancak stok bulunamadı. ` +
          `Lütfen başka bir POSM seçin veya POSM envanterini güncelleyin.`
        );
      }

      // Başka depolarda stok var, otomatik transfer oluşturulacak
      // En fazla stok olan depodan transfer yap (veya ilk bulunan depodan)
      const sourceDepot = otherDepotStocks[0];
      
      // Not: Talep oluşturulacak ama stok güncellemesi yapılmayacak (transfer tamamlanana kadar)
      // Transfer kaydı oluşturulacak ve email gönderilecek
      // Bu işlemler talep oluşturulduktan sonra yapılacak
      // Şimdilik sadece bilgiyi sakla (posm transfer için)
      (data as any).autoTransferNeeded = true;
      (data as any).sourceDepotId = sourceDepot.depot_id;
      (data as any).sourcePosmId = sourceDepot.id;
      (data as any).sourceDepotName = sourceDepot.depot_name;
      (data as any).sourceDepotCode = sourceDepot.depot_code;
    }
  }

  const requestNo = generateRequestNo();

  const result = await query<{ id: number }>(
    `INSERT INTO Requests 
     (request_no, user_id, depot_id, territory_id, dealer_id, yapilacak_is, 
      yapilacak_is_detay, istenen_tarih, posm_id, durum, priority)
     OUTPUT INSERTED.id
     VALUES (@requestNo, @userId, @depotId, @territoryId, @dealerId, @yapilacakIs,
             @yapilacakIsDetay, @istenenTarih, @posmId, @durum, @priority)`,
    {
      requestNo,
      userId: data.user_id,
      depotId: data.depot_id,
      territoryId: data.territory_id,
      dealerId: data.dealer_id,
      yapilacakIs: data.yapilacak_is,
      yapilacakIsDetay: data.yapilacak_is_detay || null,
      istenenTarih: data.istenen_tarih,
      posmId: data.posm_id || null,
      durum: REQUEST_STATUS.BEKLEMEDE,
      priority: data.priority || 0,
    }
  );

  // POSM stok güncellemesi: Talep oluşturulduğunda
  // Montaj: hazir_adet düş, revize_adet artır
  // Demontaj: sadece revize_adet artır (hazir_adet düşmez)
  // Bakım: Stok güncellemesi yapılmaz
  // NOT: Eğer otomatik transfer gerekiyorsa stok güncellemesi yapılmaz (transfer tamamlanana kadar)
  const autoTransferNeeded = (data as any).autoTransferNeeded;
  
  if (data.posm_id && !autoTransferNeeded && data.yapilacak_is !== REQUEST_TYPES.BAKIM) {
    const posmInfo = await query<any>(
      `SELECT name FROM POSM WHERE id = @posmId`,
      { posmId: data.posm_id }
    );
    const isPusher = posmInfo.length > 0 && posmInfo[0].name && posmInfo[0].name.toUpperCase().includes('PUSHER');
    const quantity = isPusher && data.quantity ? data.quantity : 1;
    
    if (data.yapilacak_is === REQUEST_TYPES.MONTAJ) {
      // Montaj: hazır stoktan alınıyor
      // PUSHER için quantity kadar düş, diğerleri için 1
      await query(
        `UPDATE POSM 
         SET hazir_adet = hazir_adet - @quantity,
             revize_adet = revize_adet + @quantity,
             updated_at = ${getTurkeyDateSQL()}
         WHERE id = @posmId AND hazir_adet >= @quantity`,
        { posmId: data.posm_id, quantity }
      );
    } else if (data.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
      // Demontaj: mevcut POSM sökülüyor, direkt tamir_bekleyen'e ekleniyor (revize_adet artmaz)
      // Not: Tamamlandığında zaten tamir_bekleyen artacak, burada bir değişiklik yapmıyoruz
      // Sadece updated_at güncelleniyor
      await query(
        `UPDATE POSM 
         SET updated_at = ${getTurkeyDateSQL()}
         WHERE id = @posmId`,
        { posmId: data.posm_id }
      );
    }
  }

  const newRequest = await getRequestById(result[0].id);

  // Email gönderme (asenkron, hata vermemeli)
  try {
    // Tüm talep detaylarını al
    const requestDetails = await query<any>(
      `SELECT 
        r.request_no, r.yapilacak_is, r.yapilacak_is_detay, r.istenen_tarih, r.priority,
        d.name as dealer_name, d.code as dealer_code, d.address as dealer_address, d.phone as dealer_phone,
        t.name as territory_name, t.code as territory_code,
        dep.name as depot_name, dep.code as depot_code,
        p.name as posm_name,
        u.name as user_name, u.email as user_email
       FROM Requests r
       LEFT JOIN Dealers d ON r.dealer_id = d.id
       LEFT JOIN Territories t ON r.territory_id = t.id
       LEFT JOIN Depots dep ON r.depot_id = dep.id
       LEFT JOIN POSM p ON r.posm_id = p.id
       LEFT JOIN Users u ON r.user_id = u.id
       WHERE r.id = @requestId`,
      { requestId: result[0].id }
    );

    if (requestDetails.length > 0 && requestDetails[0].user_email) {
      const details = requestDetails[0];

      // Talep açan kullanıcıya email gönder
      await sendRequestCreatedEmail({
        requestNo: details.request_no,
        userEmail: details.user_email,
        userName: details.user_name || '',
        dealerCode: details.dealer_code || '',
        dealerName: details.dealer_name || '',
        dealerAddress: details.dealer_address || '',
        dealerPhone: details.dealer_phone || '',
        depotName: details.depot_name || '',
        depotCode: details.depot_code || '',
        territoryName: details.territory_name || '',
        territoryCode: details.territory_code || '',
        yapilacakIs: details.yapilacak_is || '',
        yapilacakIsDetay: details.yapilacak_is_detay || '',
        istenenTarih: details.istenen_tarih,
        priority: details.priority || 0,
        posmName: details.posm_name || '',
      });

      // Depodaki teknik kullanıcılara email gönder
      const technicians = await getTechniciansByDepot(data.depot_id);
      if (technicians.length > 0) {
        const technicianEmails = technicians.map(t => t.email).filter(Boolean);
        if (technicianEmails.length > 0) {
          await sendRequestCreatedToTechniciansEmail({
            requestNo: details.request_no,
            technicianEmails,
            userName: details.user_name || '',
            dealerCode: details.dealer_code || '',
            dealerName: details.dealer_name || '',
            dealerAddress: details.dealer_address || '',
            dealerPhone: details.dealer_phone || '',
            depotName: details.depot_name || '',
            depotCode: details.depot_code || '',
            territoryName: details.territory_name || '',
            territoryCode: details.territory_code || '',
            yapilacakIs: details.yapilacak_is || '',
            yapilacakIsDetay: details.yapilacak_is_detay || '',
            istenenTarih: details.istenen_tarih,
            priority: details.priority || 0,
            posmName: details.posm_name || '',
          });
        }
      }
    }
  } catch (emailError: any) {
    // Email hatası talebi engellememeli
    console.error('[REQUEST] Email gönderme hatası:', {
      message: emailError?.message,
      code: emailError?.code,
      response: emailError?.response,
      stack: emailError?.stack,
    });
    // Hata detaylarını logla ama talebi engelleme
  }

  // Otomatik POSM transfer oluştur (eğer gerekiyorsa)
  if (autoTransferNeeded && data.posm_id) {
    try {
      const sourceDepotId = (data as any).sourceDepotId;
      const sourcePosmId = (data as any).sourcePosmId;
      const sourceDepotName = (data as any).sourceDepotName || '';
      const sourceDepotCode = (data as any).sourceDepotCode || '';
      
      // POSM adını al
      const posmInfo = await query<any>(
        `SELECT name FROM POSM WHERE id = @posmId`,
        { posmId: data.posm_id }
      );
      const posmName = posmInfo.length > 0 ? posmInfo[0].name : '';

      // Hedef depo bilgilerini al
      const targetDepotInfo = await query<any>(
        `SELECT name, code FROM Depots WHERE id = @depotId`,
        { depotId: data.depot_id }
      );
      const targetDepotName = targetDepotInfo.length > 0 ? targetDepotInfo[0].name : '';
      const targetDepotCode = targetDepotInfo.length > 0 ? targetDepotInfo[0].code || '' : '';

      // Otomatik transfer kaydı oluştur
      const transfer = await createTransfer(
        {
          posm_id: sourcePosmId,
          from_depot_id: sourceDepotId,
          to_depot_id: data.depot_id,
          quantity: 1,
          transfer_type: 'Hazir',
          notes: `Otomatik oluşturuldu - Talep No: ${requestNo}`,
        },
        data.user_id
      );

      // Kaynak ve hedef depoların teknik kullanıcılarına email gönder
      const sourceTechnicians = await getTechniciansByDepot(sourceDepotId);
      const targetTechnicians = await getTechniciansByDepot(data.depot_id);
      
      // Tüm teknik kullanıcıları birleştir (tekrar eden email'leri kaldır)
      const allTechnicians = [...sourceTechnicians, ...targetTechnicians];
      const uniqueTechnicians = Array.from(
        new Map(allTechnicians.map(t => [t.email, t])).values()
      );
      const technicianEmails = uniqueTechnicians.map(t => t.email).filter(Boolean);

      if (technicianEmails.length > 0) {
        await sendPosmTransferCreatedEmail({
          transferId: transfer.id,
          technicianEmails,
          posmName,
          fromDepotName: sourceDepotName,
          fromDepotCode: sourceDepotCode,
          toDepotName: targetDepotName,
          toDepotCode: targetDepotCode,
          quantity: 1,
          requestNo,
          notes: `Otomatik oluşturuldu - Talep No: ${requestNo}`,
        });
      }
    } catch (transferError: any) {
      // Transfer oluşturma hatası talebi engellememeli, sadece log
      console.error('[REQUEST] Otomatik transfer oluşturma hatası:', {
        message: transferError?.message,
        code: transferError?.code,
        stack: transferError?.stack,
      });
    }
  }

  return newRequest;
};

export const updateRequest = async (
  id: number,
  data: UpdateRequestData,
  updatedByUserId?: number
): Promise<Request> => {
  const oldRequest = await getRequestById(id);
  const oldNotes = oldRequest.notes;

  const updates: string[] = [];
  const params: any = { id };

  if (data.territory_id !== undefined) {
    const territories = await query(
      `SELECT id FROM Territories WHERE id = @territoryId`,
      { territoryId: data.territory_id }
    );
    if (territories.length === 0) {
      throw new NotFoundError('Territory');
    }
    updates.push('territory_id = @territoryId');
    params.territoryId = data.territory_id;
  }

  if (data.dealer_id !== undefined) {
    const dealers = await query(`SELECT id FROM Dealers WHERE id = @dealerId`, {
      dealerId: data.dealer_id,
    });
    if (dealers.length === 0) {
      throw new NotFoundError('Dealer');
    }
    updates.push('dealer_id = @dealerId');
    params.dealerId = data.dealer_id;
  }

  if (data.yapilacak_is !== undefined) {
    if (!Object.values(REQUEST_TYPES).includes(data.yapilacak_is as any)) {
      throw new ValidationError('Geçersiz yapılacak iş tipi');
    }
    updates.push('yapilacak_is = @yapilacakIs');
    params.yapilacakIs = data.yapilacak_is;
  }

  if (data.yapilacak_is_detay !== undefined) {
    updates.push('yapilacak_is_detay = @yapilacakIsDetay');
    params.yapilacakIsDetay = data.yapilacak_is_detay;
  }

  if (data.istenen_tarih !== undefined) {
    updates.push('istenen_tarih = @istenenTarih');
    params.istenenTarih = data.istenen_tarih;
  }

  if (data.planlanan_tarih !== undefined) {
    updates.push('planlanan_tarih = @planlananTarih');
    params.planlananTarih = data.planlanan_tarih || null;
  }

  if (data.posm_id !== undefined) {
    if (data.posm_id) {
      const posms = await query(`SELECT id FROM POSM WHERE id = @posmId`, {
        posmId: data.posm_id,
      });
      if (posms.length === 0) {
        throw new NotFoundError('POSM');
      }
    }
    updates.push('posm_id = @posmId');
    params.posmId = data.posm_id || null;
  }

  if (data.durum !== undefined) {
    if (!Object.values(REQUEST_STATUS).includes(data.durum as any)) {
      throw new ValidationError('Geçersiz durum');
    }
    
    // Durum "Tamamlandı" olarak değiştiriliyorsa fotoğraf kontrolü yap
    if (data.durum === REQUEST_STATUS.TAMAMLANDI && oldRequest.durum !== REQUEST_STATUS.TAMAMLANDI) {
      // Fotoğraf kontrolü - Talep kapatılırken fotoğraf zorunlu
      // ÖNEMLİ: Talep tamamlanmadan önce mutlaka fotoğraf yüklenmelidir
      const photos = await getPhotosByRequestId(id);
      if (photos.length === 0) {
        throw new ValidationError(
          'Talep tamamlanamaz! Lütfen önce yapılan işlerin veya takılan POSM\'in fotoğrafını yükleyin. ' +
          'Fotoğraf yüklendikten sonra talebi tamamlayabilirsiniz.'
        );
      }
      
      // Tamamlanma tarihi ve tamamlayan kullanıcı ID'sini güncelle
      const today = getTurkeyDateString();
      updates.push('tamamlanma_tarihi = @tamamlanmaTarihi');
      params.tamamlanmaTarihi = today;
      
      if (updatedByUserId) {
        updates.push('tamamlayan_user_id = @tamamlayanUserId');
        params.tamamlayanUserId = updatedByUserId;
      }

      // POSM stok güncellemesi: Talep tamamlandığında
      if (oldRequest.posm_id) {
        if (oldRequest.yapilacak_is === REQUEST_TYPES.MONTAJ) {
          // Montaj: Sadece revize_adet düş (hazir_adet oluşturulduğunda düşmüştü, tamir_bekleyen artmaz)
          await query(
            `UPDATE POSM 
             SET revize_adet = CASE WHEN revize_adet > 0 THEN revize_adet - 1 ELSE 0 END,
                 updated_at = ${getTurkeyDateSQL()}
             WHERE id = @posmId`,
            { posmId: oldRequest.posm_id }
          );
        } else if (oldRequest.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
          // Demontaj: sadece tamir_bekleyen artır (revize_adet değişmez, çünkü oluşturulduğunda artmamıştı)
          await query(
            `UPDATE POSM 
             SET tamir_bekleyen = tamir_bekleyen + 1,
                 updated_at = ${getTurkeyDateSQL()}
             WHERE id = @posmId`,
            { posmId: oldRequest.posm_id }
          );
        } else {
          // Diğer işler (Bakım): sadece revize_adet düş (eğer varsa)
          await query(
            `UPDATE POSM 
             SET revize_adet = CASE WHEN revize_adet > 0 THEN revize_adet - 1 ELSE 0 END,
                 updated_at = ${getTurkeyDateSQL()}
             WHERE id = @posmId`,
            { posmId: oldRequest.posm_id }
          );
        }
      }
    }
    
    updates.push('durum = @durum');
    params.durum = data.durum;
  }

  if (data.priority !== undefined) {
    updates.push('priority = @priority');
    params.priority = data.priority;
  }

  if (data.notes !== undefined) {
    updates.push('notes = @notes');
    params.notes = data.notes;
  }

  if (updates.length === 0) {
    return getRequestById(id);
  }

  updates.push(`updated_at = ${getTurkeyDateSQL()}`);

  await query(
    `UPDATE Requests 
     SET ${updates.join(', ')}
     WHERE id = @id`,
    params
  );

  const updatedRequest = await getRequestById(id);

  // Email gönderme (asenkron, hata vermemeli)
  try {
    // Not değişikliği kontrolü
    if (data.notes !== undefined && data.notes !== oldNotes && data.notes) {
      const requestDetails = await query<any>(
        `SELECT 
          r.request_no,
          u.name as user_name, u.email as user_email,
          updater.name as updated_by_name
         FROM Requests r
         LEFT JOIN Users u ON r.user_id = u.id
         LEFT JOIN Users updater ON @updatedByUserId = updater.id
         WHERE r.id = @id`,
        { id, updatedByUserId: updatedByUserId || null }
      );

      if (requestDetails.length > 0 && requestDetails[0].user_email) {
        const details = requestDetails[0];
        await sendRequestNoteAddedEmail(
          details.request_no,
          details.user_email,
          details.user_name || '',
          data.notes,
          details.updated_by_name || 'Sistem'
        );
      }
    }
  } catch (emailError: any) {
    console.error('[REQUEST] Not email gönderme hatası:', {
      message: emailError?.message,
      code: emailError?.code,
      response: emailError?.response,
      stack: emailError?.stack,
    });
  }

  return updatedRequest;
};

export const planRequest = async (
  id: number,
  planlananTarih: string,
  userId: number
): Promise<Request> => {
  const request = await getRequestById(id);

  if (request.durum !== REQUEST_STATUS.BEKLEMEDE) {
    throw new ValidationError('Sadece beklemede olan talepler planlanabilir');
  }

  const updatedRequest = await updateRequest(id, {
    planlanan_tarih: planlananTarih,
    durum: REQUEST_STATUS.PLANLANDI,
  }, userId);

  // Email gönderme (asenkron, hata vermemeli)
  try {
    // Tüm talep detaylarını al
    const requestDetails = await query<any>(
      `SELECT 
        r.request_no, r.yapilacak_is, r.yapilacak_is_detay, r.istenen_tarih, r.planlanan_tarih, r.priority,
        d.name as dealer_name, d.code as dealer_code, d.address as dealer_address, d.phone as dealer_phone,
        t.name as territory_name, t.code as territory_code,
        dep.name as depot_name, dep.code as depot_code,
        p.name as posm_name,
        u.name as user_name, u.email as user_email,
        planner.name as planned_by_name
       FROM Requests r
       LEFT JOIN Dealers d ON r.dealer_id = d.id
       LEFT JOIN Territories t ON r.territory_id = t.id
       LEFT JOIN Depots dep ON r.depot_id = dep.id
       LEFT JOIN POSM p ON r.posm_id = p.id
       LEFT JOIN Users u ON r.user_id = u.id
       LEFT JOIN Users planner ON @userId = planner.id
       WHERE r.id = @id`,
      { id, userId }
    );

    if (requestDetails.length > 0 && requestDetails[0].user_email) {
      const details = requestDetails[0];
      await sendRequestPlannedEmail({
        requestNo: details.request_no,
        userEmail: details.user_email,
        userName: details.user_name || '',
        dealerCode: details.dealer_code || '',
        dealerName: details.dealer_name || '',
        dealerAddress: details.dealer_address || '',
        dealerPhone: details.dealer_phone || '',
        depotName: details.depot_name || '',
        depotCode: details.depot_code || '',
        territoryName: details.territory_name || '',
        territoryCode: details.territory_code || '',
        yapilacakIs: details.yapilacak_is || '',
        yapilacakIsDetay: details.yapilacak_is_detay || '',
        istenenTarih: details.istenen_tarih,
        planlananTarih: details.planlanan_tarih || planlananTarih,
        priority: details.priority || 0,
        posmName: details.posm_name || '',
        plannedBy: details.planned_by_name || '',
      });
    }
  } catch (emailError: any) {
    console.error('[REQUEST] Planlama email gönderme hatası:', {
      message: emailError?.message,
      code: emailError?.code,
      response: emailError?.response,
      stack: emailError?.stack,
    });
  }

  return updatedRequest;
};

export const completeRequest = async (
  id: number,
  userId: number,
  notes?: string,
  wasUsed?: boolean,
  usedQuantity?: number
): Promise<Request> => {
  const request = await getRequestById(id);

  if (request.durum !== REQUEST_STATUS.PLANLANDI) {
    throw new ValidationError('Sadece planlanmış talepler tamamlanabilir');
  }

  // Fotoğraf kontrolü - Talep kapatılırken fotoğraf zorunlu
  // ÖNEMLİ: Talep tamamlanmadan önce mutlaka fotoğraf yüklenmelidir
  const photos = await getPhotosByRequestId(id);
  if (photos.length === 0) {
    throw new ValidationError(
      'Talep tamamlanamaz! Lütfen önce yapılan işlerin veya takılan POSM\'in fotoğrafını yükleyin. ' +
      'Fotoğraf yüklendikten sonra talebi tamamlayabilirsiniz.'
    );
  }

  const today = getTurkeyDateString();

  // Notlar varsa ekle/güncelle
  let notesValue = request.notes || '';
  if (notes !== undefined && notes.trim()) {
    const timestamp = new Date().toLocaleString('tr-TR');
    notesValue = notesValue 
      ? `${notesValue}\n\n[${timestamp}] ${notes.trim()}`
      : `[${timestamp}] ${notes.trim()}`;
  }

  const updateParams: any = {
    id,
    durum: REQUEST_STATUS.TAMAMLANDI,
    tamamlanmaTarihi: today,
    tamamlayanUserId: userId,
  };

  if (notes !== undefined) {
    updateParams.notes = notesValue;
  }

  await query(
    `UPDATE Requests 
     SET durum = @durum, tamamlanma_tarihi = @tamamlanmaTarihi, 
         tamamlayan_user_id = @tamamlayanUserId${notes !== undefined ? ', notes = @notes' : ''}, updated_at = ${getTurkeyDateSQL()}
     WHERE id = @id`,
    updateParams
  );

  // POSM stok güncellemesi: Talep tamamlandığında
  if (request.posm_id) {
    // POSM bilgisini al (PUSHER kontrolü için)
    const posmInfo = await query<any>(
      `SELECT name FROM POSM WHERE id = @posmId`,
      { posmId: request.posm_id }
    );
    const isPusher = posmInfo.length > 0 && posmInfo[0].name && posmInfo[0].name.toUpperCase().includes('PUSHER');
    
    if (request.yapilacak_is === REQUEST_TYPES.MONTAJ) {
      // Montaj: Sadece revize_adet düş (hazir_adet zaten oluşturulduğunda düşmüştü)
      // POSM bayide takıldı, tamir_bekleyen ARTMAZ (tamir bekleyen = sökülmüş, tamir edilecek)
      // PUSHER için quantity kullan, değilse 1
      const quantity = isPusher && usedQuantity ? usedQuantity : 1;
      await query(
        `UPDATE POSM 
         SET revize_adet = CASE WHEN revize_adet >= @quantity THEN revize_adet - @quantity ELSE 0 END,
             updated_at = ${getTurkeyDateSQL()}
         WHERE id = @posmId`,
        { posmId: request.posm_id, quantity }
      );
      
      // Eğer kullanıldıysa ve PUSHER ise, kullanılan miktarı hazır envanterden düş
      if (wasUsed && isPusher && usedQuantity && usedQuantity > 0) {
        await query(
          `UPDATE POSM 
           SET hazir_adet = CASE WHEN hazir_adet >= @usedQuantity THEN hazir_adet - @usedQuantity ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id, usedQuantity }
        );
      }
    } else if (request.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
      // Demontaj: sadece tamir_bekleyen artır (revize_adet değişmez, çünkü oluşturulduğunda artmamıştı)
      // PUSHER için quantity kullan, değilse 1
      const quantity = isPusher && usedQuantity ? usedQuantity : 1;
      await query(
        `UPDATE POSM 
         SET tamir_bekleyen = tamir_bekleyen + @quantity,
             updated_at = ${getTurkeyDateSQL()}
         WHERE id = @posmId`,
        { posmId: request.posm_id, quantity }
      );
      
      // Eğer kullanıldıysa ve PUSHER ise, kullanılan miktarı hazır envanterden düş
      if (wasUsed && isPusher && usedQuantity && usedQuantity > 0) {
        await query(
          `UPDATE POSM 
           SET hazir_adet = CASE WHEN hazir_adet >= @usedQuantity THEN hazir_adet - @usedQuantity ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id, usedQuantity }
        );
      }
    } else {
      // Diğer işler (Bakım): sadece revize_adet düş (eğer varsa)
      await query(
        `UPDATE POSM 
         SET revize_adet = CASE WHEN revize_adet > 0 THEN revize_adet - 1 ELSE 0 END,
             updated_at = ${getTurkeyDateSQL()}
         WHERE id = @posmId`,
        { posmId: request.posm_id }
      );
    }
  }

  const completedRequest = await getRequestById(id);

  // Email gönderme (asenkron, hata vermemeli)
  try {
    // Tüm talep detaylarını al
    const requestDetails = await query<any>(
      `SELECT 
        r.request_no, r.yapilacak_is, r.yapilacak_is_detay, r.istenen_tarih, r.planlanan_tarih, r.priority,
        r.tamamlanma_tarihi,
        d.name as dealer_name, d.code as dealer_code, d.address as dealer_address, d.phone as dealer_phone,
        t.name as territory_name, t.code as territory_code,
        dep.name as depot_name, dep.code as depot_code,
        p.name as posm_name,
        u.name as user_name, u.email as user_email,
        completer.name as completed_by_name
       FROM Requests r
       LEFT JOIN Dealers d ON r.dealer_id = d.id
       LEFT JOIN Territories t ON r.territory_id = t.id
       LEFT JOIN Depots dep ON r.depot_id = dep.id
       LEFT JOIN POSM p ON r.posm_id = p.id
       LEFT JOIN Users u ON r.user_id = u.id
       LEFT JOIN Users completer ON @userId = completer.id
       WHERE r.id = @id`,
      { id, userId }
    );

    if (requestDetails.length > 0 && requestDetails[0].user_email) {
      const details = requestDetails[0];
      await sendRequestCompletedEmail({
        requestNo: details.request_no,
        userEmail: details.user_email,
        userName: details.user_name || '',
        dealerCode: details.dealer_code || '',
        dealerName: details.dealer_name || '',
        dealerAddress: details.dealer_address || '',
        dealerPhone: details.dealer_phone || '',
        depotName: details.depot_name || '',
        depotCode: details.depot_code || '',
        territoryName: details.territory_name || '',
        territoryCode: details.territory_code || '',
        yapilacakIs: details.yapilacak_is || '',
        yapilacakIsDetay: details.yapilacak_is_detay || '',
        istenenTarih: details.istenen_tarih,
        planlananTarih: details.planlanan_tarih,
        priority: details.priority || 0,
        posmName: details.posm_name || '',
        completedBy: details.completed_by_name || '',
        completedDate: details.tamamlanma_tarihi || today,
      });
    }
  } catch (emailError: any) {
    console.error('[REQUEST] Tamamlanma email gönderme hatası:', {
      message: emailError?.message,
      code: emailError?.code,
      response: emailError?.response,
      stack: emailError?.stack,
    });
  }

  return completedRequest;
};

export const cancelRequest = async (
  id: number,
  userId: number
): Promise<Request> => {
  const request = await getRequestById(id);

  // Tamamlanmış talepler iptal edilebilir (stok geri alma ile)

  if (request.durum === REQUEST_STATUS.IPTAL) {
    throw new ValidationError('Talep zaten iptal edilmiş');
  }

  const oldStatus = request.durum;

  // POSM stok geri alma: Eğer talep iptal ediliyorsa ve POSM varsa, stokları geri al
  if (request.posm_id) {
    if (oldStatus === REQUEST_STATUS.TAMAMLANDI) {
      // Tamamlanmış talep iptal ediliyor - tamamlanma işleminde yapılan güncellemeleri geri al
      if (request.yapilacak_is === REQUEST_TYPES.MONTAJ) {
        // Montaj tamamlanma işleminde: sadece revize_adet - 1 (tamir_bekleyen artmaz)
        // Geri al: revize_adet + 1
        await query(
          `UPDATE POSM 
           SET revize_adet = revize_adet + 1,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
        // Ayrıca oluşturulduğunda: hazir_adet - 1, revize_adet + 1
        // Tamamlanma işleminde: revize_adet - 1 (yukarıda + 1 yaptık, net: 0)
        // Geri al: hazir_adet + 1
        await query(
          `UPDATE POSM 
           SET hazir_adet = hazir_adet + 1,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else if (request.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
        // Demontaj tamamlanma işleminde: sadece tamir_bekleyen + 1
        // Geri al: tamir_bekleyen - 1
        // Oluşturulduğunda stok değişikliği yok, sadece tamamlanma işlemini geri al
        await query(
          `UPDATE POSM 
           SET tamir_bekleyen = CASE WHEN tamir_bekleyen > 0 THEN tamir_bekleyen - 1 ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else {
        // Diğer işler (Bakım): tamamlanma işleminde sadece revize_adet - 1
        // Geri al: revize_adet + 1
        await query(
          `UPDATE POSM 
           SET revize_adet = revize_adet + 1,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      }
    } else if (oldStatus === REQUEST_STATUS.BEKLEMEDE || oldStatus === REQUEST_STATUS.PLANLANDI) {
      // Beklemede veya Planlandı durumundaki talep iptal ediliyor - oluşturulduğunda yapılan güncellemeleri geri al
      if (request.yapilacak_is === REQUEST_TYPES.MONTAJ) {
        // Oluşturulduğunda: hazir_adet - 1, revize_adet + 1
        // Geri al: hazir_adet + 1, revize_adet - 1
        await query(
          `UPDATE POSM 
           SET hazir_adet = hazir_adet + 1,
               revize_adet = CASE WHEN revize_adet > 0 THEN revize_adet - 1 ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else if (request.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
        // Demontaj için oluşturulduğunda stok değişikliği yok, geri alma gerekmez
      }
    }
  }

  const updatedRequest = await updateRequest(id, {
    durum: REQUEST_STATUS.IPTAL,
  }, userId);

  // Email gönderme (asenkron, hata vermemeli)
  try {
    const requestDetails = await query<any>(
      `SELECT 
        r.request_no,
        u.name as user_name, u.email as user_email,
        canceler.name as canceled_by_name
       FROM Requests r
       LEFT JOIN Users u ON r.user_id = u.id
       LEFT JOIN Users canceler ON @userId = canceler.id
       WHERE r.id = @id`,
      { id, userId }
    );

    if (requestDetails.length > 0 && requestDetails[0].user_email) {
      const details = requestDetails[0];
      await sendRequestStatusChangedEmail(
        details.request_no,
        details.user_email,
        details.user_name || '',
        oldStatus,
        REQUEST_STATUS.IPTAL,
        details.canceled_by_name || 'Sistem'
      );
    }
  } catch (emailError: any) {
    console.error('[REQUEST] İptal email gönderme hatası:', {
      message: emailError?.message,
      code: emailError?.code,
      response: emailError?.response,
      stack: emailError?.stack,
    });
  }

  return updatedRequest;
};

export const getDashboardCounts = async (
  userId: number,
  role: string
): Promise<{ open: number; completed: number; pending: number }> => {
  let whereClause = '';
  const params: any = {};

  // Kullanıcı yetkisi kontrolü
  if (role === 'Admin') {
    // Admin tüm talepleri görebilir
  } else if (role === 'Teknik') {
    // Teknik kullanıcılar sadece tanımlı oldukları depo/depoların taleplerini görebilir
    whereClause = `WHERE depot_id IN (
      SELECT depot_id 
      FROM User_Depots 
      WHERE user_id = @userId
    )`;
    params.userId = userId;
  } else {
    // User rolü: Sadece kendi taleplerini görebilir
    whereClause = 'WHERE user_id = @userId';
    params.userId = userId;
  }

  const counts = await query<{
    durum: string;
    count: number;
  }>(
    `SELECT durum, COUNT(*) as count
     FROM Requests
     ${whereClause}
     GROUP BY durum`,
    params
  );

  const result = {
    open: 0,
    completed: 0,
    pending: 0,
  };

  counts.forEach((item) => {
    if (item.durum === REQUEST_STATUS.TAMAMLANDI) {
      result.completed = item.count;
    } else if (item.durum === REQUEST_STATUS.BEKLEMEDE) {
      result.pending = item.count;
    } else {
      result.open += item.count;
    }
  });

  return result;
};

export const deleteRequest = async (id: number): Promise<void> => {
  const request = await getRequestById(id);

  // POSM stok geri alma: Talep silinirken POSM stoklarını geri al
  if (request.posm_id) {
    if (request.durum === REQUEST_STATUS.TAMAMLANDI) {
      // Tamamlanmış talep siliniyor
      // Oluşturulduğunda ve tamamlanma işleminde yapılan tüm güncellemeleri geri al
      
      if (request.yapilacak_is === REQUEST_TYPES.MONTAJ) {
        // Oluşturulduğunda: hazir_adet - 1, revize_adet + 1
        // Tamamlanma işleminde: sadece revize_adet - 1 (tamir_bekleyen artmaz)
        // Geri al: hazir_adet + 1, revize_adet + 1
        await query(
          `UPDATE POSM 
           SET hazir_adet = hazir_adet + 1,
               revize_adet = revize_adet + 1,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else if (request.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
        // Oluşturulduğunda: stok değişikliği yok
        // Tamamlanma işleminde: tamir_bekleyen + 1
        // Geri al: tamir_bekleyen - 1
        await query(
          `UPDATE POSM 
           SET tamir_bekleyen = CASE WHEN tamir_bekleyen > 0 THEN tamir_bekleyen - 1 ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else {
        // Diğer işler: Oluşturulduğunda revize_adet değişmedi
        // Tamamlanma işleminde: revize_adet - 1
        // Geri al: revize_adet + 1
        await query(
          `UPDATE POSM 
           SET revize_adet = revize_adet + 1,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      }
    } else if (request.durum === REQUEST_STATUS.BEKLEMEDE || request.durum === REQUEST_STATUS.PLANLANDI) {
      // Beklemede veya Planlandı durumundaki talep siliniyor - oluşturulduğunda yapılan güncellemeleri geri al
      if (request.yapilacak_is === REQUEST_TYPES.MONTAJ) {
        // Oluşturulduğunda: hazir_adet - 1, revize_adet + 1
        // Geri al: hazir_adet + 1, revize_adet - 1
        await query(
          `UPDATE POSM 
           SET hazir_adet = hazir_adet + 1,
               revize_adet = CASE WHEN revize_adet > 0 THEN revize_adet - 1 ELSE 0 END,
               updated_at = ${getTurkeyDateSQL()}
           WHERE id = @posmId`,
          { posmId: request.posm_id }
        );
      } else if (request.yapilacak_is === REQUEST_TYPES.DEMONTAJ) {
        // Demontaj için oluşturulduğunda stok değişikliği yok, geri alma gerekmez
      }
    }
    // İPTAL durumunda zaten stoklar geri alınmış olmalı, tekrar geri alma gerekmez
  }

  await query(`DELETE FROM Requests WHERE id = @id`, { id });
};
