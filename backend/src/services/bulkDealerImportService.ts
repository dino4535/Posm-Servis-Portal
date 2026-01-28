import * as XLSX from 'xlsx';
import { query } from '../config/database';

export interface BulkImportRow {
  depo: string;
  territory_kodu: string;
  territory_adi: string;
  bayi_kodu: string;
  bayi_adi: string;
  adres?: string;
  telefon?: string;
  enlem?: number;
  boylam?: number;
}

export interface ImportResult {
  total: number;
  created: number;
  skipped: number;
  errors: string[];
}

/** Excel başlıklarını normalize eder: "Bayi Kodu" -> "bayi_kodu", "depo" -> "depo" */
const normalizeHeader = (key: string): string =>
  String(key || '')
    .trim()
    .toLowerCase()
    .replace(/\s+/g, '_')
    .replace(/[^a-z0-9_]/g, '');

/** Bir satırdan normalize key ile değer döner; key yoksa diğer olası yazımlara bakar */
const getCell = (row: Record<string, unknown>, ...keys: string[]): unknown => {
  for (const k of keys) {
    const n = normalizeHeader(k);
    for (const [h, v] of Object.entries(row)) {
      if (normalizeHeader(h) === n && v !== undefined && v !== null && v !== '') return v;
    }
  }
  return undefined;
};

export const bulkImportDealers = async (
  fileBuffer: Buffer
): Promise<ImportResult> => {
  const workbook = XLSX.read(fileBuffer, { type: 'buffer' });
  const sheetName = workbook.SheetNames[0];
  const worksheet = workbook.Sheets[sheetName];
  const rows: any[] = XLSX.utils.sheet_to_json(worksheet);

  const result: ImportResult = {
    total: rows.length,
    created: 0,
    skipped: 0,
    errors: [],
  };

  // Depo cache (name veya code ile)
  const depotCache = new Map<string, number>();
  // Territory cache (depot_id + code ile)
  const territoryCache = new Map<string, number>();
  // Mevcut bayi kodları cache
  const existingDealerCodes = new Set<string>();

  // Önce mevcut bayi kodlarını yükle (is_active kolonu yoksa tüm bayileri al)
  try {
    const existingDealers = await query<{ code: string }>(
      `SELECT code FROM Dealers WHERE (is_active = 1 OR is_active IS NULL)`
    );
    existingDealers.forEach((d) => existingDealerCodes.add(String(d.code).trim()));
  } catch {
    const existingDealers = await query<{ code: string }>(`SELECT code FROM Dealers`);
    existingDealers.forEach((d) => existingDealerCodes.add(String(d.code).trim()));
  }

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i] as Record<string, unknown>;
    const rowNum = i + 2; // Excel satır numarası (header + 1-based)

    try {
      const depoVal = getCell(row, 'depo', 'depo adı');
      const territoryCodeVal = getCell(row, 'territory_kodu', 'territory kodu', 'territorykodu');
      const territoryAdiVal = getCell(row, 'territory_adi', 'territory adı', 'territoryadi');
      const bayiKoduVal = getCell(row, 'bayi_kodu', 'bayi kodu', 'bayikodu');
      const bayiAdiVal = getCell(row, 'bayi_adi', 'bayi adı', 'bayiadi');

      if (!depoVal || !territoryCodeVal || !territoryAdiVal || !bayiKoduVal || !bayiAdiVal) {
        result.errors.push(`Satır ${rowNum}: Eksik veri (Depo, Territory Kodu, Territory Adı, Bayi Kodu, Bayi Adı zorunludur)`);
        result.skipped++;
        continue;
      }

      const depoName = String(depoVal).trim();
      const territoryCode = String(territoryCodeVal).trim();
      const territoryName = String(territoryAdiVal).trim();
      const dealerCode = String(bayiKoduVal).trim();
      const dealerName = String(bayiAdiVal).trim();
      const address = getCell(row, 'adres') != null ? String(getCell(row, 'adres')).trim() : null;
      const phone = getCell(row, 'telefon') != null ? String(getCell(row, 'telefon')).trim() : null;
      const enlemVal = getCell(row, 'enlem');
      const boylamVal = getCell(row, 'boylam');
      const latitude = enlemVal != null && enlemVal !== '' ? parseFloat(String(enlemVal)) : null;
      const longitude = boylamVal != null && boylamVal !== '' ? parseFloat(String(boylamVal)) : null;

      // Bayi kodu zaten varsa atla
      if (existingDealerCodes.has(dealerCode)) {
        result.skipped++;
        continue;
      }

      // Depo bul veya oluştur
      let depotId = depotCache.get(depoName);
      if (!depotId) {
        // Önce name ile ara
        let depots = await query<{ id: number }>(
          `SELECT id FROM Depots WHERE name = @name OR code = @name`,
          { name: depoName }
        );

        if (depots.length === 0) {
          // Depo yoksa oluştur
          const newDepot = await query<{ id: number }>(
            `INSERT INTO Depots (name, code, is_active)
             OUTPUT INSERTED.id
             VALUES (@name, @code, 1)`,
            {
              name: depoName,
              code: depoName.substring(0, 10).toUpperCase().replace(/\s+/g, '_'),
            }
          );
          depotId = newDepot[0].id;
        } else {
          depotId = depots[0].id;
        }
        depotCache.set(depoName, depotId);
      }

      // Territory bul veya oluştur
      const territoryKey = `${depotId}_${territoryCode}`;
      let territoryId = territoryCache.get(territoryKey);
      if (!territoryId) {
        // Territory code ile ara
        let territories = await query<{ id: number }>(
          `SELECT id FROM Territories WHERE code = @code AND depot_id = @depotId`,
          { code: territoryCode, depotId }
        );

        if (territories.length === 0) {
          // Territory yoksa oluştur
          const newTerritory = await query<{ id: number }>(
            `INSERT INTO Territories (name, code, depot_id)
             OUTPUT INSERTED.id
             VALUES (@name, @code, @depotId)`,
            {
              name: territoryName,
              code: territoryCode,
              depotId,
            }
          );
          territoryId = newTerritory[0].id;
        } else {
          territoryId = territories[0].id;
        }
        territoryCache.set(territoryKey, territoryId);
      }

      // Bayi oluştur
      // Address: eğer hem address hem lat/lng varsa JSON, sadece address varsa string, sadece lat/lng varsa JSON
      let finalAddress: string | null = null;
      // Artık address, latitude ve longitude'u ayrı kolonlarda saklıyoruz
      if (address) {
        finalAddress = address;
      }

      await query<{ id: number }>(
        `INSERT INTO Dealers (code, name, territory_id, address, phone, latitude, longitude)
         OUTPUT INSERTED.id
         VALUES (@code, @name, @territoryId, @address, @phone, @latitude, @longitude)`,
        {
          code: dealerCode,
          name: dealerName,
          territoryId,
          address: finalAddress,
          phone: phone || null,
          latitude: latitude ? parseFloat(latitude.toString()) : null,
          longitude: longitude ? parseFloat(longitude.toString()) : null,
        }
      );

      existingDealerCodes.add(dealerCode);
      result.created++;
    } catch (error: any) {
      result.errors.push(`Satır ${rowNum}: ${error.message || 'Bilinmeyen hata'}`);
      result.skipped++;
    }
  }

  return result;
};
