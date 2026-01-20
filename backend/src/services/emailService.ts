import nodemailer from 'nodemailer';
import { config } from '../config/env';

// Email transporter oluştur
const createTransporter = () => {
  const transporterConfig: any = {
    host: config.email.host,
    port: config.email.port,
    secure: config.email.secure,
    auth: {
      user: config.email.auth.user,
      pass: config.email.auth.pass,
    },
  };

  // TLS ayarları (gerekirse)
  if (!config.email.secure) {
    transporterConfig.tls = {
      rejectUnauthorized: false, // Self-signed sertifikalar için
    };
  }

  console.log('[EMAIL] SMTP ayarları:', {
    host: config.email.host,
    port: config.email.port,
    secure: config.email.secure,
    user: config.email.auth.user,
    from: config.email.from,
    hasPassword: !!config.email.auth.pass,
  });

  return nodemailer.createTransport(transporterConfig);
};

export interface EmailOptions {
  to: string | string[];
  subject: string;
  html: string;
  text?: string;
}

export const sendEmail = async (options: EmailOptions): Promise<void> => {
  try {
    // Email ayarları yapılmamışsa hata verme, sadece log
    if (!config.email.auth.user || !config.email.auth.pass) {
      console.warn('[EMAIL] SMTP ayarları yapılmamış, email gönderilmedi:', options.to);
      console.warn('[EMAIL] SMTP_USER:', config.email.auth.user ? 'VAR' : 'YOK');
      console.warn('[EMAIL] SMTP_PASS:', config.email.auth.pass ? 'VAR' : 'YOK');
      return;
    }

    console.log('[EMAIL] Email gönderiliyor...', {
      to: options.to,
      subject: options.subject,
      from: config.email.from,
    });

    const transporter = createTransporter();
    
    // Transporter'ı verify et (opsiyonel, hata ayıklama için)
    try {
      await transporter.verify();
      console.log('[EMAIL] SMTP bağlantısı doğrulandı');
    } catch (verifyError) {
      console.error('[EMAIL] SMTP bağlantı hatası:', verifyError);
      throw verifyError;
    }
    
    const recipients = Array.isArray(options.to) ? options.to : [options.to];
    
    const result = await transporter.sendMail({
      from: config.email.from,
      to: recipients.join(', '),
      subject: options.subject,
      text: options.text,
      html: options.html,
    });

    console.log('[EMAIL] Email başarıyla gönderildi:', {
      recipients,
      messageId: result.messageId,
    });
  } catch (error: any) {
    console.error('[EMAIL] Email gönderme hatası:', {
      message: error.message,
      code: error.code,
      response: error.response,
      command: error.command,
      stack: error.stack,
    });
    // Email hatası uygulamayı durdurmamalı
    throw error;
  }
};

// Talep oluşturulduğunda gönderilecek email
export const sendRequestCreatedEmail = async (
  data: {
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
    priority?: number;
    posmName?: string;
  }
): Promise<void> => {
  const { getRequestCreatedEmailTemplate } = await import('./emailTemplates');
  const html = getRequestCreatedEmailTemplate(data);

  await sendEmail({
    to: data.userEmail,
    subject: `Yeni Talep Oluşturuldu - ${data.requestNo}`,
    html,
  });
};

// Teknik kullanıcılara gönderilecek email (yeni talep)
export const sendRequestCreatedToTechniciansEmail = async (
  data: {
    requestNo: string;
    technicianEmails: string[];
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
    priority?: number;
    posmName?: string;
    userEmail?: string; // Optional for technicians email
  }
): Promise<void> => {
  if (data.technicianEmails.length === 0) return;

  const { getRequestCreatedToTechniciansEmailTemplate } = await import('./emailTemplates');
  const html = getRequestCreatedToTechniciansEmailTemplate(data as any);

  await sendEmail({
    to: data.technicianEmails,
    subject: `Yeni Talep - ${data.requestNo} - ${data.depotName || 'Depo'}`,
    html,
  });
};

// Talep durumu değiştiğinde gönderilecek email
export const sendRequestStatusChangedEmail = async (
  requestNo: string,
  userEmail: string,
  userName: string,
  oldStatus: string,
  newStatus: string,
  changedBy?: string
): Promise<void> => {
  const { getRequestStatusChangedEmailTemplate } = await import('./emailTemplates');
  const html = getRequestStatusChangedEmailTemplate(requestNo, userName, oldStatus, newStatus, changedBy);

  await sendEmail({
    to: userEmail,
    subject: `Talep Durumu Güncellendi - ${requestNo}`,
    html,
  });
};

// Talep planlandığında gönderilecek email
export const sendRequestPlannedEmail = async (
  data: {
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
    planlananTarih: string | Date;
    priority?: number;
    posmName?: string;
    plannedBy?: string;
  }
): Promise<void> => {
  const { getRequestPlannedEmailTemplate } = await import('./emailTemplates');
  const html = getRequestPlannedEmailTemplate(data);

  await sendEmail({
    to: data.userEmail,
    subject: `Talep Planlandı - ${data.requestNo}`,
    html,
  });
};

// Talep tamamlandığında gönderilecek email (detaylı)
export const sendRequestCompletedEmail = async (
  data: {
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
    completedBy?: string;
    completedDate?: string | Date;
  }
): Promise<void> => {
  const { getRequestCompletedEmailTemplate } = await import('./emailTemplates');
  const html = getRequestCompletedEmailTemplate(data);

  await sendEmail({
    to: data.userEmail,
    subject: `Talep Tamamlandı - ${data.requestNo}`,
    html,
  });
};

// Talep notu eklendiğinde gönderilecek email
export const sendRequestNoteAddedEmail = async (
  requestNo: string,
  userEmail: string,
  userName: string,
  note: string,
  addedBy: string
): Promise<void> => {
  const { getRequestNoteAddedEmailTemplate } = await import('./emailTemplates');
  const html = getRequestNoteAddedEmailTemplate(requestNo, userName, note, addedBy);

  await sendEmail({
    to: userEmail,
    subject: `Talep Notu Eklendi - ${requestNo}`,
    html,
  });
};

// POSM transfer oluşturulduğunda teknik kullanıcılara gönderilecek email
export const sendPosmTransferCreatedEmail = async (
  data: {
    transferId: number;
    technicianEmails: string[];
    posmName: string;
    fromDepotName: string;
    fromDepotCode?: string;
    toDepotName: string;
    toDepotCode?: string;
    quantity: number;
    requestNo?: string;
    notes?: string;
  }
): Promise<void> => {
  if (data.technicianEmails.length === 0) return;

  const { getPosmTransferCreatedEmailTemplate } = await import('./emailTemplates');
  const html = getPosmTransferCreatedEmailTemplate(data);

  await sendEmail({
    to: data.technicianEmails,
    subject: `POSM Transfer Talebi - ${data.posmName} (${data.fromDepotName} → ${data.toDepotName})`,
    html,
  });
};

// Yeni kullanıcı oluşturulduğunda gönderilecek hoşgeldin emaili
export const sendWelcomeEmail = async (
  data: {
    userEmail: string;
    userName: string;
    password: string;
    role: string;
    depotNames: string[];
  }
): Promise<void> => {
  const { getWelcomeEmailTemplate } = await import('./emailTemplates');
  const html = getWelcomeEmailTemplate(data);

  await sendEmail({
    to: data.userEmail,
    subject: 'POSM Teknik Servis Portalı - Hoş Geldiniz',
    html,
  });
};

// Sistem tanıtım e-postası gönderme
export const sendSystemIntroductionEmail = async (
  data: {
    to: string | string[];
    subject?: string;
  }
): Promise<void> => {
  const { getSystemIntroductionEmailTemplate } = await import('./emailTemplates');
  const html = getSystemIntroductionEmailTemplate();

  await sendEmail({
    to: data.to,
    subject: data.subject || 'POSM Teknik Servis Portalı - Sistem Tanıtımı',
    html,
  });
};
