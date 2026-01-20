export const ROLES = {
  ADMIN: 'Admin',
  TEKNIK: 'Teknik',
  USER: 'User',
} as const;

export const REQUEST_STATUS = {
  BEKLEMEDE: 'Beklemede',
  PLANLANDI: 'Planlandı',
  TAMAMLANDI: 'Tamamlandı',
  IPTAL: 'İptal',
} as const;

export const REQUEST_TYPES = {
  MONTAJ: 'Montaj',
  DEMONTAJ: 'Demontaj',
  BAKIM: 'Bakım',
} as const;

export const PRIORITY = {
  NORMAL: 0,
  HIGH: 1,
  URGENT: 2,
} as const;
