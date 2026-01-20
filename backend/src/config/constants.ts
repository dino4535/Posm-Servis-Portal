export const ROLES = {
  ADMIN: 'Admin',
  TEKNIK: 'Teknik',
  USER: 'User',
} as const;

export type Role = typeof ROLES[keyof typeof ROLES];

export const REQUEST_STATUS = {
  BEKLEMEDE: 'Beklemede',
  PLANLANDI: 'Planlandı',
  TAMAMLANDI: 'Tamamlandı',
  IPTAL: 'İptal',
} as const;

export type RequestStatus = typeof REQUEST_STATUS[keyof typeof REQUEST_STATUS];

export const REQUEST_TYPES = {
  MONTAJ: 'Montaj',
  DEMONTAJ: 'Demontaj',
  BAKIM: 'Bakım',
} as const;

export type RequestType = typeof REQUEST_TYPES[keyof typeof REQUEST_TYPES];

export const PRIORITY = {
  NORMAL: 0,
  HIGH: 1,
  URGENT: 2,
} as const;

export type Priority = typeof PRIORITY[keyof typeof PRIORITY];

export const AUDIT_ACTIONS = {
  CREATE: 'CREATE',
  UPDATE: 'UPDATE',
  DELETE: 'DELETE',
  LOGIN: 'LOGIN',
  LOGOUT: 'LOGOUT',
} as const;

export type AuditAction = typeof AUDIT_ACTIONS[keyof typeof AUDIT_ACTIONS];
