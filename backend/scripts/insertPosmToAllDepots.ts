/**
 * Tüm depolar için POSM'leri ekle
 * Her depo için aynı POSM listesi eklenecek
 */

import { query } from '../src/config/database';

const POSM_LIST = [
  '88X35 ATLAS',
  '100X35 ATLAS',
  '100X50 ATLAS',
  '130X35 ATLAS',
  '130X50 ATLAS',
  'Armada 90x35',
  'Armada 100x35',
  'Armada 100x50',
  'Armada 130x35',
  'Armada 130x50',
  'Armada 170x50',
  'Mini Atlas 88-100\'lük',
  'Mini Atlas 130\'luk',
  'AF 8\'li',
  'Af 12\'li',
  'INOVA 100x100/ 100x85',
  'Smart Unit',
  'Millenium',
  'MCOU',
  'LOCAL COU',
  'C4 COU',
  'PM Küçük',
  'PM Orta',
  'Pm Büyük',
  'Ezd Küçük',
  'Ezd Orta',
  'Ezd Büyük',
  'Arcadia',
  'Midway 12\'li 100\'lük',
  'Midway 130\'luk',
  'Diğer',
];

export const insertPosmToAllDepots = async (): Promise<void> => {
  try {
    console.log('[POSM] Tüm depolar için POSM ekleme işlemi başlatılıyor...');

    // Tüm aktif depoları getir
    const depots = await query<any>(
      `SELECT id, name, code 
       FROM Depots 
       WHERE is_active = 1 
       ORDER BY name`
    );

    console.log(`[POSM] ${depots.length} aktif depo bulundu`);

    if (depots.length === 0) {
      console.log('[POSM] Aktif depo bulunamadı!');
      return;
    }

    let totalInserted = 0;
    let totalSkipped = 0;

    // Her depo için POSM'leri ekle
    for (const depot of depots) {
      console.log(`[POSM] ${depot.name} (ID: ${depot.id}) için POSM'ler ekleniyor...`);

      let depotInserted = 0;
      let depotSkipped = 0;

      for (const posmName of POSM_LIST) {
        try {
          // Bu depoda bu POSM zaten var mı kontrol et
          const existing = await query(
            `SELECT id FROM POSM 
             WHERE name = @name AND depot_id = @depotId`,
            { name: posmName, depotId: depot.id }
          );

          if (existing.length > 0) {
            console.log(`  [SKIP] ${posmName} - Zaten mevcut`);
            depotSkipped++;
            totalSkipped++;
            continue;
          }

          // POSM'i ekle (direkt SQL ile - is_active default 1)
          await query(
            `INSERT INTO POSM (name, description, depot_id, hazir_adet, tamir_bekleyen, is_active)
             VALUES (@name, @description, @depotId, @hazirAdet, @tamirBekleyen, 1)`,
            {
              name: posmName,
              description: null,
              depotId: depot.id,
              hazirAdet: 0,
              tamirBekleyen: 0,
            }
          );

          console.log(`  [OK] ${posmName} - Eklendi`);
          depotInserted++;
          totalInserted++;
        } catch (error: any) {
          console.error(`  [ERROR] ${posmName} - Hata: ${error.message}`);
        }
      }

      console.log(
        `[POSM] ${depot.name} tamamlandı - Eklenen: ${depotInserted}, Atlanan: ${depotSkipped}`
      );
    }

    console.log('\n[POSM] İşlem tamamlandı!');
    console.log(`[POSM] Toplam eklenen: ${totalInserted}`);
    console.log(`[POSM] Toplam atlanan: ${totalSkipped}`);
    console.log(`[POSM] Toplam depo: ${depots.length}`);
  } catch (error: any) {
    console.error('[POSM] Hata:', error);
    throw error;
  }
};
