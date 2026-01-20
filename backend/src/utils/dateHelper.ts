/**
 * Türkiye saati (UTC+3) için tarih/saat yardımcı fonksiyonları
 */

/**
 * Türkiye saatine göre şu anki tarih/saat
 */
export const getTurkeyDate = (): Date => {
  const now = new Date();
  // UTC+3 offset (Türkiye saati)
  const turkeyOffset = 3 * 60; // 3 saat = 180 dakika
  const utc = now.getTime() + (now.getTimezoneOffset() * 60000);
  const turkeyTime = new Date(utc + (turkeyOffset * 60000));
  return turkeyTime;
};

/**
 * Türkiye saatine göre şu anki tarih (YYYY-MM-DD formatında)
 */
export const getTurkeyDateString = (): string => {
  const turkeyDate = getTurkeyDate();
  const year = turkeyDate.getFullYear();
  const month = String(turkeyDate.getMonth() + 1).padStart(2, '0');
  const day = String(turkeyDate.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

/**
 * Türkiye saatine göre şu anki tarih/saat (ISO formatında)
 */
export const getTurkeyDateTimeISO = (): string => {
  return getTurkeyDate().toISOString();
};

/**
 * Türkiye saatine göre formatlanmış tarih/saat
 */
export const formatTurkeyDateTime = (date?: Date): string => {
  const d = date || getTurkeyDate();
  return d.toLocaleString('tr-TR', {
    timeZone: 'Europe/Istanbul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
  });
};

/**
 * Türkiye saatine göre formatlanmış tarih
 */
export const formatTurkeyDate = (date?: Date | string): string => {
  if (!date) {
    const d = getTurkeyDate();
    return d.toLocaleDateString('tr-TR', {
      timeZone: 'Europe/Istanbul',
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
    });
  }
  
  const d = typeof date === 'string' ? new Date(date) : date;
  return d.toLocaleDateString('tr-TR', {
    timeZone: 'Europe/Istanbul',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  });
};

/**
 * Türkiye saatine göre formatlanmış uzun tarih (email'ler için)
 */
export const formatTurkeyDateLong = (date?: Date | string): string => {
  if (!date) return '-';
  try {
    const d = typeof date === 'string' ? new Date(date) : date;
    return d.toLocaleDateString('tr-TR', {
      timeZone: 'Europe/Istanbul',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  } catch {
    return '-';
  }
};

/**
 * SQL'de kullanılacak Türkiye saati fonksiyonu
 * GETDATE() yerine kullanılır
 * 
 * Not: Veritabanında GETTURKEYDATE() fonksiyonu oluşturulmalı
 * Eğer oluşturulmadıysa DATEADD(HOUR, 3, GETUTCDATE()) kullanılır
 */
export const getTurkeyDateSQL = (): string => {
  // Önce GETTURKEYDATE() fonksiyonunu dene, yoksa DATEADD kullan
  // Not: SQL Server'da fonksiyon kontrolü yapmak zor olduğu için
  // direkt DATEADD kullanıyoruz (daha güvenli)
  return 'DATEADD(HOUR, 3, GETUTCDATE())';
  
  // Alternatif: Eğer GETTURKEYDATE() fonksiyonu oluşturulduysa:
  // return 'GETTURKEYDATE()';
};
