/**
 * Kurumsal ve modern email template'leri
 */

export interface RequestEmailData {
  requestNo: string;
  userEmail: string;
  userName: string;
  dealerCode?: string;
  dealerName?: string;
  dealerAddress?: string;
  dealerPhone?: string;
  depotName?: string;
  depotCode?: string;
  territoryName?: string;
  territoryCode?: string;
  yapilacakIs: string;
  yapilacakIsDetay?: string;
  istenenTarih: string | Date;
  planlananTarih?: string | Date;
  priority?: number;
  posmName?: string;
  status?: string;
}

/**
 * Öncelik etiketlerini döndürür
 */
const getPriorityLabel = (priority: number): { label: string; color: string; bgColor: string } => {
  if (priority >= 3) {
    return { label: 'Yüksek Öncelik', color: '#fff', bgColor: '#e74c3c' };
  } else if (priority === 2) {
    return { label: 'Orta Öncelik', color: '#fff', bgColor: '#f39c12' };
  } else if (priority === 1) {
    return { label: 'Düşük Öncelik', color: '#333', bgColor: '#ecf0f1' };
  }
  return { label: 'Normal', color: '#333', bgColor: '#ecf0f1' };
};

/**
 * HTML escape (güvenlik için)
 */
const escapeHtml = (text: string | undefined | null): string => {
  if (!text) return '';
  const map: { [key: string]: string } = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;',
  };
  return text.replace(/[&<>"']/g, (m) => map[m]);
};

import { formatTurkeyDateLong } from '../utils/dateHelper';

/**
 * Tarih formatla (Türkiye saati)
 */
const formatDate = (date: string | Date | undefined): string => {
  return formatTurkeyDateLong(date);
};

/**
 * Kurumsal email template base HTML
 */
const getEmailBaseTemplate = (
  title: string,
  content: string,
  headerColor: string = '#3498db'
): string => {
  return `
    <!DOCTYPE html>
    <html lang="tr">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <title>${title}</title>
      <style>
        * {
          margin: 0;
          padding: 0;
          box-sizing: border-box;
        }
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #2c3e50;
          background-color: #f4f6f8;
          padding: 20px;
        }
        .email-container {
          max-width: 650px;
          margin: 0 auto;
          background: #ffffff;
          border-radius: 12px;
          overflow: hidden;
          box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .email-header {
          background: linear-gradient(135deg, ${headerColor} 0%, ${headerColor}dd 100%);
          color: #ffffff;
          padding: 30px 40px;
          text-align: center;
        }
        .email-header h1 {
          font-size: 24px;
          font-weight: 700;
          margin: 0;
          letter-spacing: -0.5px;
        }
        .email-header .subtitle {
          font-size: 14px;
          margin-top: 8px;
          opacity: 0.95;
        }
        .email-body {
          padding: 40px;
        }
        .greeting {
          font-size: 16px;
          color: #2c3e50;
          margin-bottom: 24px;
        }
        .greeting strong {
          color: #1a1a1a;
          font-weight: 600;
        }
        .info-section {
          background: #f8f9fa;
          border-radius: 8px;
          padding: 24px;
          margin: 24px 0;
          border-left: 4px solid ${headerColor};
        }
        .info-row {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          padding: 12px 0;
          border-bottom: 1px solid #e9ecef;
        }
        .info-row:last-child {
          border-bottom: none;
        }
        .info-label {
          font-weight: 600;
          color: #495057;
          font-size: 14px;
          min-width: 140px;
          flex-shrink: 0;
        }
        .info-value {
          color: #212529;
          font-size: 14px;
          text-align: right;
          flex: 1;
          word-break: break-word;
        }
        .priority-badge {
          display: inline-block;
          padding: 6px 14px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }
        .status-badge {
          display: inline-block;
          padding: 6px 14px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }
        .detail-box {
          background: #ffffff;
          border: 1px solid #dee2e6;
          border-radius: 6px;
          padding: 16px;
          margin: 16px 0;
        }
        .detail-box-title {
          font-weight: 600;
          color: #495057;
          font-size: 13px;
          margin-bottom: 8px;
          text-transform: uppercase;
          letter-spacing: 0.5px;
        }
        .detail-box-content {
          color: #212529;
          font-size: 14px;
          line-height: 1.7;
          white-space: pre-wrap;
        }
        .divider {
          height: 1px;
          background: #e9ecef;
          margin: 24px 0;
        }
        .footer {
          background: #f8f9fa;
          padding: 24px 40px;
          text-align: center;
          border-top: 1px solid #e9ecef;
        }
        .footer-text {
          font-size: 12px;
          color: #6c757d;
          line-height: 1.6;
        }
        .footer-brand {
          font-weight: 600;
          color: #495057;
          margin-top: 8px;
        }
        @media only screen and (max-width: 600px) {
          .email-container {
            width: 100% !important;
            border-radius: 0;
          }
          .email-header,
          .email-body,
          .footer {
            padding: 24px 20px !important;
          }
          .info-row {
            flex-direction: column;
            gap: 4px;
          }
          .info-value {
            text-align: left;
          }
        }
      </style>
    </head>
    <body>
      <div class="email-container">
        <div class="email-header">
          <h1>${title}</h1>
          <div class="subtitle">POSM Teknik Servis Portalı</div>
        </div>
        <div class="email-body">
          ${content}
        </div>
        <div class="footer">
          <div class="footer-text">
            Bu e-posta otomatik olarak POSM Teknik Servis Portalı tarafından gönderilmiştir.<br>
            <div class="footer-brand">© ${new Date().getFullYear()} Dino Gıda - Tüm hakları saklıdır.</div>
          </div>
        </div>
      </div>
    </body>
    </html>
  `;
};

/**
 * Yeni talep oluşturuldu email template (Kullanıcıya)
 */
export const getRequestCreatedEmailTemplate = (data: RequestEmailData): string => {
  const priorityInfo = getPriorityLabel(data.priority || 0);
  
  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(data.userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Yeni bir talep başarıyla oluşturulmuştur. Talebiniz ilgili teknik ekibe iletilmiştir.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(data.requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #6c757d; color: #fff;">Beklemede</span>
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Öncelik:</span>
        <span class="info-value">
          <span class="priority-badge" style="background: ${priorityInfo.bgColor}; color: ${priorityInfo.color};">
            ${priorityInfo.label}
          </span>
        </span>
      </div>
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Bayi Bilgileri
      </div>
      ${data.dealerCode ? `
      <div class="info-row">
        <span class="info-label">Bayi Kodu:</span>
        <span class="info-value">${escapeHtml(data.dealerCode)}</span>
      </div>
      ` : ''}
      ${data.dealerName ? `
      <div class="info-row">
        <span class="info-label">Bayi Adı:</span>
        <span class="info-value">${escapeHtml(data.dealerName)}</span>
      </div>
      ` : ''}
      ${data.dealerAddress ? `
      <div class="info-row">
        <span class="info-label">Adres:</span>
        <span class="info-value">${escapeHtml(data.dealerAddress)}</span>
      </div>
      ` : ''}
      ${data.dealerPhone ? `
      <div class="info-row">
        <span class="info-label">Telefon:</span>
        <span class="info-value">${escapeHtml(data.dealerPhone)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Lokasyon Bilgileri
      </div>
      ${data.depotName ? `
      <div class="info-row">
        <span class="info-label">Depo:</span>
        <span class="info-value">${data.depotCode ? `[${escapeHtml(data.depotCode)}] ` : ''}${escapeHtml(data.depotName)}</span>
      </div>
      ` : ''}
      ${data.territoryName ? `
      <div class="info-row">
        <span class="info-label">Territory:</span>
        <span class="info-value">${data.territoryCode ? `[${escapeHtml(data.territoryCode)}] ` : ''}${escapeHtml(data.territoryName)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Talep Detayları
      </div>
      <div class="info-row">
        <span class="info-label">Yapılacak İş:</span>
        <span class="info-value"><strong>${escapeHtml(data.yapilacakIs)}</strong></span>
      </div>
      ${data.yapilacakIsDetay ? `
      <div class="detail-box">
        <div class="detail-box-title">Yapılacak İşler Detayı</div>
        <div class="detail-box-content">${escapeHtml(data.yapilacakIsDetay)}</div>
      </div>
      ` : ''}
      ${data.posmName ? `
      <div class="info-row">
        <span class="info-label">POSM:</span>
        <span class="info-value">${escapeHtml(data.posmName)}</span>
      </div>
      ` : ''}
      <div class="info-row">
        <span class="info-label">İstenen Tarih:</span>
        <span class="info-value"><strong>${formatDate(data.istenenTarih)}</strong></span>
      </div>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Talebinizin durumunu ve detaylarını sistem üzerinden takip edebilirsiniz.
    </p>
  `;

  return getEmailBaseTemplate('Yeni Talep Oluşturuldu', content, '#3498db');
};

/**
 * Yeni talep oluşturuldu email template (Teknik kullanıcılara)
 */
export const getRequestCreatedToTechniciansEmailTemplate = (data: Omit<RequestEmailData, 'userEmail'> & { technicianEmails?: string[] }): string => {
  const priorityInfo = getPriorityLabel(data.priority || 0);
  
  const content = `
    <div class="greeting">
      Değerli Teknik Ekip,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Yeni bir talep oluşturulmuştur ve <strong>${escapeHtml(data.depotName || 'deponuz')}</strong> için atanmıştır. 
      Lütfen talebi inceleyin ve gerekli işlemleri yapın.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong style="font-size: 16px;">${escapeHtml(data.requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #6c757d; color: #fff;">Beklemede</span>
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Öncelik:</span>
        <span class="info-value">
          <span class="priority-badge" style="background: ${priorityInfo.bgColor}; color: ${priorityInfo.color};">
            ${priorityInfo.label}
          </span>
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Talep Eden:</span>
        <span class="info-value"><strong>${escapeHtml(data.userName)}</strong></span>
      </div>
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #e74c3c;">
        Bayi Bilgileri
      </div>
      ${data.dealerCode ? `
      <div class="info-row">
        <span class="info-label">Bayi Kodu:</span>
        <span class="info-value">${escapeHtml(data.dealerCode)}</span>
      </div>
      ` : ''}
      ${data.dealerName ? `
      <div class="info-row">
        <span class="info-label">Bayi Adı:</span>
        <span class="info-value"><strong>${escapeHtml(data.dealerName)}</strong></span>
      </div>
      ` : ''}
      ${data.dealerAddress ? `
      <div class="info-row">
        <span class="info-label">Adres:</span>
        <span class="info-value">${escapeHtml(data.dealerAddress)}</span>
      </div>
      ` : ''}
      ${data.dealerPhone ? `
      <div class="info-row">
        <span class="info-label">Telefon:</span>
        <span class="info-value">${escapeHtml(data.dealerPhone)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #e74c3c;">
        Lokasyon Bilgileri
      </div>
      ${data.depotName ? `
      <div class="info-row">
        <span class="info-label">Depo:</span>
        <span class="info-value"><strong>${data.depotCode ? `[${escapeHtml(data.depotCode)}] ` : ''}${escapeHtml(data.depotName)}</strong></span>
      </div>
      ` : ''}
      ${data.territoryName ? `
      <div class="info-row">
        <span class="info-label">Territory:</span>
        <span class="info-value">${data.territoryCode ? `[${escapeHtml(data.territoryCode)}] ` : ''}${escapeHtml(data.territoryName)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #e74c3c;">
        Talep Detayları
      </div>
      <div class="info-row">
        <span class="info-label">Yapılacak İş:</span>
        <span class="info-value"><strong style="font-size: 15px;">${escapeHtml(data.yapilacakIs)}</strong></span>
      </div>
      ${data.yapilacakIsDetay ? `
      <div class="detail-box">
        <div class="detail-box-title">Yapılacak İşler Detayı</div>
        <div class="detail-box-content">${escapeHtml(data.yapilacakIsDetay)}</div>
      </div>
      ` : ''}
      ${data.posmName ? `
      <div class="info-row">
        <span class="info-label">POSM:</span>
        <span class="info-value"><strong>${escapeHtml(data.posmName)}</strong></span>
      </div>
      ` : ''}
      <div class="info-row">
        <span class="info-label">İstenen Tarih:</span>
        <span class="info-value"><strong style="color: #e74c3c; font-size: 15px;">${formatDate(data.istenenTarih)}</strong></span>
      </div>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Lütfen talebi en kısa sürede inceleyin ve gerekli işlemleri yapın.
    </p>
  `;

  return getEmailBaseTemplate('Yeni Talep Bildirimi', content, '#e74c3c');
};

/**
 * Talep planlandı email template
 */
export const getRequestPlannedEmailTemplate = (data: RequestEmailData & { plannedBy?: string }): string => {
  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(data.userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Talebiniz planlanmıştır. Planlanan tarih ve detaylar aşağıda yer almaktadır.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(data.requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #3498db; color: #fff;">Planlandı</span>
        </span>
      </div>
      ${data.planlananTarih ? `
      <div class="info-row">
        <span class="info-label">Planlanan Tarih:</span>
        <span class="info-value"><strong style="color: #3498db; font-size: 15px;">${formatDate(data.planlananTarih)}</strong></span>
      </div>
      ` : ''}
      ${data.plannedBy ? `
      <div class="info-row">
        <span class="info-label">Planlayan:</span>
        <span class="info-value"><strong>${escapeHtml(data.plannedBy)}</strong></span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Bayi Bilgileri
      </div>
      ${data.dealerCode ? `
      <div class="info-row">
        <span class="info-label">Bayi Kodu:</span>
        <span class="info-value">${escapeHtml(data.dealerCode)}</span>
      </div>
      ` : ''}
      ${data.dealerName ? `
      <div class="info-row">
        <span class="info-label">Bayi Adı:</span>
        <span class="info-value">${escapeHtml(data.dealerName)}</span>
      </div>
      ` : ''}
      ${data.dealerAddress ? `
      <div class="info-row">
        <span class="info-label">Adres:</span>
        <span class="info-value">${escapeHtml(data.dealerAddress)}</span>
      </div>
      ` : ''}
      ${data.dealerPhone ? `
      <div class="info-row">
        <span class="info-label">Telefon:</span>
        <span class="info-value">${escapeHtml(data.dealerPhone)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Talep Detayları
      </div>
      <div class="info-row">
        <span class="info-label">Yapılacak İş:</span>
        <span class="info-value"><strong>${escapeHtml(data.yapilacakIs)}</strong></span>
      </div>
      ${data.yapilacakIsDetay ? `
      <div class="detail-box">
        <div class="detail-box-title">Yapılacak İşler Detayı</div>
        <div class="detail-box-content">${escapeHtml(data.yapilacakIsDetay)}</div>
      </div>
      ` : ''}
      ${data.posmName ? `
      <div class="info-row">
        <span class="info-label">POSM:</span>
        <span class="info-value">${escapeHtml(data.posmName)}</span>
      </div>
      ` : ''}
      <div class="info-row">
        <span class="info-label">İstenen Tarih:</span>
        <span class="info-value">${formatDate(data.istenenTarih)}</span>
      </div>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Talebiniz planlanmıştır. Planlanan tarihte işlem gerçekleştirilecektir.
    </p>
  `;

  return getEmailBaseTemplate('Talep Planlandı', content, '#3498db');
};

/**
 * Talep durumu değişti email template
 */
export const getRequestStatusChangedEmailTemplate = (
  requestNo: string,
  userName: string,
  oldStatus: string,
  newStatus: string,
  changedBy?: string
): string => {
  const statusLabels: { [key: string]: string } = {
    'Beklemede': 'Beklemede',
    'Planlandı': 'Planlandı',
    'Tamamlandı': 'Tamamlandı',
  };

  const statusColors: { [key: string]: string } = {
    'Beklemede': '#6c757d',
    'Planlandı': '#3498db',
    'Tamamlandı': '#27ae60',
  };

  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Talebinizin durumu güncellenmiştir.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Eski Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: ${statusColors[oldStatus] || '#6c757d'}; color: #fff;">
            ${escapeHtml(statusLabels[oldStatus] || oldStatus)}
          </span>
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Yeni Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: ${statusColors[newStatus] || '#3498db'}; color: #fff; font-size: 14px;">
            ${escapeHtml(statusLabels[newStatus] || newStatus)}
          </span>
        </span>
      </div>
      ${changedBy ? `
      <div class="info-row">
        <span class="info-label">Güncelleyen:</span>
        <span class="info-value">${escapeHtml(changedBy)}</span>
      </div>
      ` : ''}
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Talebinizin detaylarını sistem üzerinden takip edebilirsiniz.
    </p>
  `;

  return getEmailBaseTemplate('Talep Durumu Güncellendi', content, '#f39c12');
};

/**
 * Talep tamamlandı email template (detaylı)
 */
export const getRequestCompletedEmailTemplate = (data: RequestEmailData & { completedBy?: string; completedDate?: string | Date }): string => {
  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(data.userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Talebiniz başarıyla tamamlanmıştır. İşlem detayları aşağıda yer almaktadır.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(data.requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Durum:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #27ae60; color: #fff; font-size: 14px;">Tamamlandı</span>
        </span>
      </div>
      ${data.completedBy ? `
      <div class="info-row">
        <span class="info-label">Tamamlayan:</span>
        <span class="info-value"><strong>${escapeHtml(data.completedBy)}</strong></span>
      </div>
      ` : ''}
      ${data.completedDate ? `
      <div class="info-row">
        <span class="info-label">Tamamlanma Tarihi:</span>
        <span class="info-value"><strong>${formatDate(data.completedDate)}</strong></span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #27ae60;">
        Bayi Bilgileri
      </div>
      ${data.dealerCode ? `
      <div class="info-row">
        <span class="info-label">Bayi Kodu:</span>
        <span class="info-value">${escapeHtml(data.dealerCode)}</span>
      </div>
      ` : ''}
      ${data.dealerName ? `
      <div class="info-row">
        <span class="info-label">Bayi Adı:</span>
        <span class="info-value">${escapeHtml(data.dealerName)}</span>
      </div>
      ` : ''}
      ${data.dealerAddress ? `
      <div class="info-row">
        <span class="info-label">Adres:</span>
        <span class="info-value">${escapeHtml(data.dealerAddress)}</span>
      </div>
      ` : ''}
      ${data.dealerPhone ? `
      <div class="info-row">
        <span class="info-label">Telefon:</span>
        <span class="info-value">${escapeHtml(data.dealerPhone)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #27ae60;">
        Lokasyon Bilgileri
      </div>
      ${data.depotName ? `
      <div class="info-row">
        <span class="info-label">Depo:</span>
        <span class="info-value">${data.depotCode ? `[${escapeHtml(data.depotCode)}] ` : ''}${escapeHtml(data.depotName)}</span>
      </div>
      ` : ''}
      ${data.territoryName ? `
      <div class="info-row">
        <span class="info-label">Territory:</span>
        <span class="info-value">${data.territoryCode ? `[${escapeHtml(data.territoryCode)}] ` : ''}${escapeHtml(data.territoryName)}</span>
      </div>
      ` : ''}
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #27ae60;">
        Talep Detayları
      </div>
      <div class="info-row">
        <span class="info-label">Yapılacak İş:</span>
        <span class="info-value"><strong>${escapeHtml(data.yapilacakIs)}</strong></span>
      </div>
      ${data.yapilacakIsDetay ? `
      <div class="detail-box">
        <div class="detail-box-title">Yapılacak İşler Detayı</div>
        <div class="detail-box-content">${escapeHtml(data.yapilacakIsDetay)}</div>
      </div>
      ` : ''}
      ${data.posmName ? `
      <div class="info-row">
        <span class="info-label">POSM:</span>
        <span class="info-value"><strong>${escapeHtml(data.posmName)}</strong></span>
      </div>
      ` : ''}
      ${data.planlananTarih ? `
      <div class="info-row">
        <span class="info-label">Planlanan Tarih:</span>
        <span class="info-value">${formatDate(data.planlananTarih)}</span>
      </div>
      ` : ''}
      <div class="info-row">
        <span class="info-label">İstenen Tarih:</span>
        <span class="info-value">${formatDate(data.istenenTarih)}</span>
      </div>
    </div>

    <div style="text-align: center; margin: 32px 0;">
      <span class="status-badge" style="background: #27ae60; color: #fff; font-size: 14px; padding: 10px 24px;">
        ✓ TAMAMLANDI
      </span>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Talebinizin detaylarını ve fotoğraflarını sistem üzerinden görüntüleyebilirsiniz.
    </p>
  `;

  return getEmailBaseTemplate('Talep Tamamlandı', content, '#27ae60');
};

/**
 * Talep notu eklendi email template
 */
export const getRequestNoteAddedEmailTemplate = (
  requestNo: string,
  userName: string,
  note: string,
  addedBy: string
): string => {
  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Talebinize yeni bir not eklenmiştir.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(requestNo)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Not Ekleyen:</span>
        <span class="info-value"><strong>${escapeHtml(addedBy)}</strong></span>
      </div>
    </div>

    <div class="detail-box" style="border-left: 4px solid #9b59b6;">
      <div class="detail-box-title">Eklenen Not</div>
      <div class="detail-box-content">${escapeHtml(note)}</div>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Talebinizin detaylarını sistem üzerinden görüntüleyebilirsiniz.
    </p>
  `;

  return getEmailBaseTemplate('Talep Notu Eklendi', content, '#9b59b6');
};

/**
 * POSM transfer oluşturuldu email template (Teknik kullanıcılara)
 */
export const getPosmTransferCreatedEmailTemplate = (data: {
  transferId: number;
  posmName: string;
  fromDepotName: string;
  fromDepotCode?: string;
  toDepotName: string;
  toDepotCode?: string;
  quantity: number;
  requestNo?: string;
  notes?: string;
}): string => {
  const content = `
    <div class="greeting">
      Değerli Teknik Ekip,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      Yeni bir POSM transfer talebi oluşturulmuştur. Lütfen transferi onaylayın ve tamamlayın.
    </p>

    <div class="info-section">
      <div class="info-row">
        <span class="info-label">Transfer ID:</span>
        <span class="info-value"><strong>#${data.transferId}</strong></span>
      </div>
      ${data.requestNo ? `
      <div class="info-row">
        <span class="info-label">İlgili Talep No:</span>
        <span class="info-value"><strong>${escapeHtml(data.requestNo)}</strong></span>
      </div>
      ` : ''}
      <div class="info-row">
        <span class="info-label">POSM:</span>
        <span class="info-value"><strong>${escapeHtml(data.posmName)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Miktar:</span>
        <span class="info-value"><strong>${data.quantity} adet</strong></span>
      </div>
    </div>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Transfer Detayları
      </div>
      <div class="info-row">
        <span class="info-label">Kaynak Depo:</span>
        <span class="info-value">
          <strong>${escapeHtml(data.fromDepotName)}</strong>
          ${data.fromDepotCode ? ` <span style="color: #6c757d;">(${escapeHtml(data.fromDepotCode)})</span>` : ''}
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Hedef Depo:</span>
        <span class="info-value">
          <strong>${escapeHtml(data.toDepotName)}</strong>
          ${data.toDepotCode ? ` <span style="color: #6c757d;">(${escapeHtml(data.toDepotCode)})</span>` : ''}
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Transfer Tipi:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #3498db; color: #fff;">Hazır Stok</span>
        </span>
      </div>
      ${data.notes ? `
      <div class="detail-box" style="border-left: 4px solid #3498db; margin-top: 16px;">
        <div class="detail-box-title">Notlar</div>
        <div class="detail-box-content">${escapeHtml(data.notes)}</div>
      </div>
      ` : ''}
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Transfer detaylarını ve durumunu sistem üzerinden görüntüleyebilirsiniz.
    </p>
  `;

  return getEmailBaseTemplate('POSM Transfer Talebi', content, '#3498db');
};

/**
 * Yeni kullanıcı hoşgeldin email template
 */
export const getWelcomeEmailTemplate = (data: {
  userEmail: string;
  userName: string;
  password: string;
  role: string;
  depotNames: string[];
}): string => {
  const roleLabels: { [key: string]: string } = {
    'Admin': 'Yönetici',
    'Teknik': 'Teknik Personel',
    'User': 'Kullanıcı',
  };

  const roleLabel = roleLabels[data.role] || data.role;

  const content = `
    <div class="greeting">
      Sayın <strong>${escapeHtml(data.userName)}</strong>,
    </div>
    
    <p style="color: #495057; font-size: 15px; margin-bottom: 24px;">
      <strong>POSM Teknik Servis Portalı</strong>'na hoş geldiniz! Hesabınız başarıyla oluşturulmuştur.
    </p>

    <div class="info-section">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #3498db;">
        Sistem Giriş Bilgileriniz
      </div>
      <div class="info-row">
        <span class="info-label">E-posta Adresi (Kullanıcı Adı):</span>
        <span class="info-value"><strong>${escapeHtml(data.userEmail)}</strong></span>
      </div>
      <div class="info-row">
        <span class="info-label">Şifre:</span>
        <span class="info-value">
          <strong style="font-size: 16px; color: #e74c3c; letter-spacing: 2px;">${escapeHtml(data.password)}</strong>
        </span>
      </div>
      <div class="info-row">
        <span class="info-label">Rol:</span>
        <span class="info-value">
          <span class="status-badge" style="background: #3498db; color: #fff;">${escapeHtml(roleLabel)}</span>
        </span>
      </div>
    </div>

    ${data.depotNames.length > 0 ? `
    <div class="info-section" style="margin-top: 24px;">
      <div style="font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 16px; padding-bottom: 8px; border-bottom: 2px solid #27ae60;">
        Sorumlu Olduğunuz Depolar
      </div>
      <div style="padding: 16px; background: #f8f9fa; border-radius: 8px;">
        ${data.depotNames.map((depotName, index) => `
          <div style="padding: 8px 0; ${index < data.depotNames.length - 1 ? 'border-bottom: 1px solid #dee2e6;' : ''}">
            <span style="color: #495057; font-size: 15px;">${index + 1}. ${escapeHtml(depotName)}</span>
          </div>
        `).join('')}
      </div>
    </div>
    ` : `
    <div class="info-section" style="margin-top: 24px;">
      <div style="padding: 16px; background: #fff3cd; border-left: 4px solid #ffc107; border-radius: 4px;">
        <p style="margin: 0; color: #856404; font-size: 14px;">
          <strong>Not:</strong> Henüz size atanmış bir depo bulunmamaktadır. Sistem yöneticinizle iletişime geçerek depo ataması yapılmasını talep edebilirsiniz.
        </p>
      </div>
    </div>
    `}

    <div class="divider"></div>

    <div style="background: #e8f5e9; border-left: 4px solid #27ae60; padding: 16px; border-radius: 4px; margin-top: 24px;">
      <p style="margin: 0 0 12px 0; color: #2e7d32; font-weight: 600; font-size: 15px;">
        🔐 Güvenlik Uyarısı
      </p>
      <p style="margin: 0; color: #2e7d32; font-size: 14px; line-height: 1.6;">
        Güvenliğiniz için lütfen ilk girişinizde şifrenizi değiştirmenizi öneririz. Bu bilgileri kimseyle paylaşmayın.
      </p>
    </div>

    <div class="divider"></div>

    <p style="color: #6c757d; font-size: 14px; margin-top: 24px;">
      Sistem hakkında sorularınız veya destek ihtiyacınız için sistem yöneticinizle iletişime geçebilirsiniz.
    </p>

    <p style="color: #6c757d; font-size: 14px; margin-top: 16px;">
      Tekrar hoş geldiniz!
    </p>
  `;

  return getEmailBaseTemplate('Hoş Geldiniz', content, '#27ae60');
};
