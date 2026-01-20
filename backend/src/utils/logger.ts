import { formatTurkeyDateTime } from './dateHelper';

export const logger = {
  info: (message: string, ...args: any[]) => {
    console.log(`[INFO] ${formatTurkeyDateTime()} - ${message}`, ...args);
  },
  error: (message: string, ...args: any[]) => {
    console.error(`[ERROR] ${formatTurkeyDateTime()} - ${message}`, ...args);
  },
  warn: (message: string, ...args: any[]) => {
    console.warn(`[WARN] ${formatTurkeyDateTime()} - ${message}`, ...args);
  },
  debug: (message: string, ...args: any[]) => {
    if (process.env.NODE_ENV === 'development') {
      console.log(`[DEBUG] ${formatTurkeyDateTime()} - ${message}`, ...args);
    }
  },
};
