import * as XLSX from 'xlsx';
import { query } from '../config/database';
import { ValidationError } from '../utils/errors';
import { createDealer, CreateDealerData } from './dealerService';
import { createTerritory, CreateTerritoryData } from './territoryService';

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

  // Önce mevcut bayi kodlarını yükle
  const existingDealers = await query<{ code: string }>(
    `SELECT code FROM Dealers WHERE is_active = 1`
  );
  existingDealers.forEach((d) => existingDealerCodes.add(d.code));

  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const rowNum = i + 2; // Excel satır numarası (header + 1-based)

    try {
      // Veri doğrulama
      if (!row.depo || !row.territory_kodu || !row.territory_adi || !row.bayi_kodu || !row.bayi_adi) {
        result.errors.push(`Satır ${rowNum}: Eksik veri (Depo, Territory Kodu, Territory Adı, Bayi Kodu, Bayi Adı zorunludur)`);
        result.skipped++;
        continue;
      }

      const depoName = String(row.depo).trim();
      const territoryCode = String(row.territory_kodu).trim();
      const territoryName = String(row.territory_adi).trim();
      const dealerCode = String(row.bayi_kodu).trim();
      const dealerName = String(row.bayi_adi).trim();
      const address = row.adres ? String(row.adres).trim() : null;
      const phone = row.telefon ? String(row.telefon).trim() : null;
      const latitude = row.enlem ? parseFloat(String(row.enlem)) : null;
      const longitude = row.boylam ? parseFloat(String(row.boylam)) : null;

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

      const dealerResult = await query<{ id: number }>(
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
