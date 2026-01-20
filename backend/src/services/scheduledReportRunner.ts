import * as cron from 'node-cron';
import { getDueScheduledReports, executeScheduledReport } from './customReportService';
import { getTurkeyDateSQL } from '../utils/dateHelper';

let schedulerRunning = false;

// Her dakika çalışacak cron job
const schedulePattern = '* * * * *'; // Her dakika

export const startScheduledReportRunner = () => {
  if (schedulerRunning) {
    console.log('Scheduled Report Runner zaten çalışıyor');
    return;
  }

  console.log('Scheduled Report Runner başlatılıyor...');

  cron.schedule(schedulePattern, async () => {
    try {
      const dueReports = await getDueScheduledReports();
      
      if (dueReports.length === 0) {
        return; // Çalıştırılacak rapor yok
      }

      console.log(`${dueReports.length} zamanlanmış rapor bulundu, çalıştırılıyor...`);

      for (const report of dueReports) {
        try {
          console.log(`Rapor çalıştırılıyor: ${report.name} (ID: ${report.id})`);
          await executeScheduledReport(report.id);
          console.log(`Rapor başarıyla çalıştırıldı: ${report.name}`);
        } catch (error: any) {
          console.error(`Rapor çalıştırma hatası (${report.name}):`, error.message);
          // Hata durumunda execution kaydı oluştur
          const { query } = require('../config/database');
          await query(
            `INSERT INTO Report_Executions 
             (report_template_id, scheduled_report_id, execution_type, status, error_message, created_at)
             VALUES (@templateId, @scheduledId, 'SCHEDULED', 'FAILED', @error, ${getTurkeyDateSQL()})`,
            {
              templateId: report.report_template_id,
              scheduledId: report.id,
              error: error.message,
            }
          );
        }
      }
    } catch (error: any) {
      console.error('Scheduled Report Runner hatası:', error.message);
    }
  });

  schedulerRunning = true;
  console.log('Scheduled Report Runner başlatıldı');
};

export const stopScheduledReportRunner = () => {
  // Cron job'ı durdurma (node-cron otomatik olarak durdurulabilir)
  schedulerRunning = false;
  console.log('Scheduled Report Runner durduruldu');
};

export const isSchedulerRunning = () => schedulerRunning;
