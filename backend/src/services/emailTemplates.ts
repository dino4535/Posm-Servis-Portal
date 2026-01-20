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

/**
 * Sistem tanıtım e-postası şablonu
 */
export const getSystemIntroductionEmailTemplate = (): string => {
  // HTML dosyasının içeriğini buraya ekliyoruz
  return `<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>POSM Teknik Servis Portalı - Sistem Tanıtımı</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .email-container {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            border-bottom: 3px solid #2c3e50;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .header h1 {
            color: #2c3e50;
            margin: 0;
            font-size: 28px;
        }
        .header p {
            color: #7f8c8d;
            margin: 10px 0 0 0;
            font-size: 16px;
        }
        .section {
            margin: 30px 0;
        }
        .section-title {
            color: #2c3e50;
            font-size: 22px;
            font-weight: bold;
            margin-bottom: 15px;
            border-left: 4px solid #3498db;
            padding-left: 15px;
        }
        .feature-box {
            background-color: #f8f9fa;
            border-left: 4px solid #3498db;
            padding: 15px;
            margin: 15px 0;
            border-radius: 5px;
        }
        .feature-title {
            font-weight: bold;
            color: #2c3e50;
            font-size: 16px;
            margin-bottom: 8px;
        }
        .feature-description {
            color: #555;
            font-size: 14px;
        }
        .image-placeholder {
            background-color: #ecf0f1;
            border: 2px dashed #bdc3c7;
            padding: 40px;
            text-align: center;
            margin: 20px 0;
            border-radius: 5px;
            color: #7f8c8d;
            font-style: italic;
        }
        .highlight-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            border-radius: 8px;
            margin: 25px 0;
            text-align: center;
        }
        .highlight-box h2 {
            margin: 0 0 10px 0;
            font-size: 24px;
        }
        .highlight-box p {
            margin: 0;
            font-size: 16px;
            opacity: 0.95;
        }
        .benefits-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin: 20px 0;
        }
        .benefit-item {
            background-color: #e8f5e9;
            padding: 15px;
            border-radius: 5px;
            border-left: 3px solid #4caf50;
        }
        .benefit-item strong {
            color: #2e7d32;
            display: block;
            margin-bottom: 5px;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 2px solid #ecf0f1;
            color: #7f8c8d;
            font-size: 14px;
        }
        .cta-button {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            margin: 20px 0;
            font-weight: bold;
        }
        ul {
            padding-left: 20px;
        }
        li {
            margin: 8px 0;
        }
    </style>
</head>
<body>
    <div class="email-container">
        <div class="header">
            <h1>POSM Teknik Servis Portalı</h1>
            <p>Dijital Dönüşüm ile Verimliliği Artırın</p>
        </div>

        <div class="highlight-box">
            <h2>🎯 Sistem Amacı</h2>
            <p>POSM Teknik Servis Portalı, teknik servis taleplerinizin dijital ortamda yönetilmesini sağlayan, 
            stok takibinden raporlamaya kadar tüm süreçleri tek bir platformda birleştiren kapsamlı bir yönetim sistemidir.</p>
        </div>

        <div class="image-placeholder">
            [GÖRSELLERİNİZİ BURAYA EKLEYİN]<br>
            <strong>Görsel 1:</strong> Dashboard Ana Ekran - Tüm taleplerinizi tek bakışta görüntüleyin
        </div>

        <div class="section">
            <div class="section-title">📊 Ana Özellikler</div>
            
            <div class="feature-box">
                <div class="feature-title">1. Teknik Servis Talep Yönetimi</div>
                <div class="feature-description">
                    • Yeni talep oluşturma ve takip sistemi<br>
                    • Talep durumu yönetimi (Beklemede, Planlandı, Tamamlandı, İptal)<br>
                    • Öncelik seviyesi belirleme<br>
                    • Fotoğraf ekleme ve görüntüleme (Talep oluşturduktan sonra kolay yükleme)<br>
                    • Talep detayları ve geçmiş takibi<br>
                    • POSM bilgilerinin taleplerde görüntülenmesi<br>
                    • Takvim görünümü ile planlama<br>
                    • Otomatik stok güncelleme (Talep iptal/silme durumunda)
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-title">2. POSM (Point of Sale Material) Yönetimi</div>
                <div class="feature-description">
                    • POSM stok takibi (Hazır, Tamir Bekleyen, Revize)<br>
                    • Depo bazlı stok yönetimi<br>
                    • <strong>YENİ:</strong> Depolarımdaki POSM'ler - Kullanıcıların tanımlı oldukları depolardaki POSM'leri görüntüleme<br>
                    • <strong>YENİ:</strong> Depo bazlı filtreleme ve arama özellikleri<br>
                    • <strong>YENİ:</strong> Özet istatistikler (Toplam Depo, Benzersiz POSM sayısı, Stok durumları)<br>
                    • POSM transfer işlemleri (Depo arası transfer)<br>
                    • Otomatik stok güncelleme (Montaj/Demontaj işlemlerinde)<br>
                    • Toplu POSM ekleme özelliği<br>
                    • Stok seviyesi uyarıları
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-title">3. Kapsamlı Yönetim Modülleri</div>
                <div class="feature-description">
                    • <strong>Bayi Yönetimi:</strong> Bayi bilgileri, konum takibi, toplu içe aktarma<br>
                    • <strong>Bölge Yönetimi:</strong> Bölge tanımlama ve atama<br>
                    • <strong>Depo Yönetimi:</strong> Depo bilgileri ve stok merkezleri<br>
                    • <strong>Kullanıcı Yönetimi:</strong> Rol bazlı yetkilendirme sistemi
                </div>
            </div>

            <div class="image-placeholder">
                [GÖRSELLERİNİZİ BURAYA EKLEYİN]<br>
                <strong>Görsel 2:</strong> Yeni Talep Oluşturma - Kolay ve hızlı talep girişi
            </div>

            <div class="feature-box">
                <div class="feature-title">4. Gelişmiş Raporlama Sistemi</div>
                <div class="feature-description">
                    • İstatistiksel raporlar (Talep dağılımı, tamamlanma oranları)<br>
                    • Özel rapor tasarımı (Sürükle-bırak arayüzü)<br>
                    • Zamanlanmış raporlar (Otomatik e-posta gönderimi)<br>
                    • Excel export özelliği<br>
                    • Filtreleme ve arama seçenekleri
                </div>
            </div>

            <div class="feature-box">
                <div class="feature-title">5. Güvenlik ve İzleme</div>
                <div class="feature-description">
                    • JWT tabanlı güvenli kimlik doğrulama<br>
                    • Rol bazlı erişim kontrolü (Admin, Teknik, Kullanıcı)<br>
                    • Audit log (Tüm işlemlerin kaydı)<br>
                    • IP adresi takibi<br>
                    • Şifre değiştirme ve profil yönetimi
                </div>
            </div>

            <div class="image-placeholder">
                [GÖRSELLERİNİZİ BURAYA EKLEYİN]<br>
                <strong>Görsel 3:</strong> POSM Yönetimi - Stok takibi ve transfer işlemleri
            </div>

            <div class="feature-box" style="border-left-color: #e74c3c; background-color: #fff5f5;">
                <div class="feature-title" style="color: #e74c3c;">🆕 Yeni Özellikler (2026 Güncellemesi)</div>
                <div class="feature-description">
                    • <strong>Depolarımdaki POSM'ler Sayfası:</strong> Kullanıcılar artık tanımlı oldukları depolardaki tüm POSM'leri tek ekranda görüntüleyebilir<br>
                    • <strong>Gelişmiş Filtreleme:</strong> Depo bazlı filtreleme ve arama ile hızlı erişim<br>
                    • <strong>Özet İstatistikler:</strong> Toplam depo sayısı, benzersiz POSM sayısı ve stok durumları<br>
                    • <strong>Akıllı Stok Yönetimi:</strong> Talep iptal/silme durumunda otomatik stok geri alma<br>
                    • <strong>İyileştirilmiş Fotoğraf Yükleme:</strong> Talep oluşturduktan sonra kolay ve hızlı fotoğraf ekleme<br>
                    • <strong>POSM Bilgisi Görüntüleme:</strong> Taleplerde POSM adı ve detaylarının görüntülenmesi
                </div>
            </div>
        </div>

        <div class="section">
            <div class="section-title">👥 Kullanıcı Rolleri ve Yetkileri</div>
            
            <div class="benefits-grid">
                <div class="benefit-item">
                    <strong>🔐 Admin</strong>
                    Tüm modüllere erişim, kullanıcı yönetimi, sistem ayarları
                </div>
                <div class="benefit-item">
                    <strong>🔧 Teknik</strong>
                    POSM yönetimi, talep onaylama, transfer işlemleri
                </div>
                <div class="benefit-item">
                    <strong>👤 Kullanıcı</strong>
                    Talep oluşturma, kendi taleplerini görüntüleme, depolardaki POSM'leri görüntüleme
                </div>
                <div class="benefit-item">
                    <strong>📱 Çoklu Depo</strong>
                    Kullanıcılar birden fazla depo ile çalışabilir
                </div>
            </div>
        </div>

        <div class="section">
            <div class="section-title">✨ Sistem Avantajları</div>
            
            <ul style="color: #555; font-size: 15px;">
                <li><strong>⏱️ Zaman Tasarrufu:</strong> Manuel süreçlerin dijitalleştirilmesi ile %60'a varan zaman tasarrufu</li>
                <li><strong>📈 Verimlilik Artışı:</strong> Merkezi yönetim ile operasyonel verimlilikte artış</li>
                <li><strong>📊 Veri Analizi:</strong> Detaylı raporlama ile karar verme süreçlerini destekleme</li>
                <li><strong>🔒 Güvenlik:</strong> Güvenli veri saklama ve erişim kontrolü</li>
                <li><strong>📱 Erişilebilirlik:</strong> Web tabanlı platform, her yerden erişim imkanı</li>
                <li><strong>🔄 Otomasyon:</strong> Otomatik bildirimler ve stok güncellemeleri</li>
                <li><strong>📸 Dokümantasyon:</strong> Fotoğraf ekleme ile görsel kanıt saklama</li>
                <li><strong>📧 Bildirimler:</strong> E-posta ile otomatik bildirim sistemi</li>
            </ul>
        </div>

        <div class="highlight-box">
            <h2>🚀 Hemen Başlayın</h2>
            <p>Sisteme erişim için: <strong>http://posm.dinogida.com.tr</strong></p>
            <p style="margin-top: 15px;">
                <a href="http://posm.dinogida.com.tr" class="cta-button" style="color: white;">Sisteme Giriş Yap</a>
            </p>
        </div>

        <div class="footer">
            <p><strong>POSM Teknik Servis Portalı</strong></p>
            <p>Dino Gıda - Dijital Dönüşüm Projesi</p>
            <p style="margin-top: 10px; font-size: 12px;">
                Bu e-posta otomatik olarak oluşturulmuştur. | © 2026 Oğuz EMÜL. Tüm hakları saklıdır.
            </p>
        </div>
    </div>
</body>
</html>`;
};
