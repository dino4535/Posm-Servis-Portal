
export const generateRequestNo = (): string => {
  const timestamp = Date.now();
  const random = Math.floor(Math.random() * 1000);
  return `REQ-${timestamp}-${random}`;
};

export const formatDate = (date: Date | string): string => {
  const d = typeof date === 'string' ? new Date(date) : date;
  const day = String(d.getDate()).padStart(2, '0');
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const year = d.getFullYear();
  return `${day}.${month}.${year}`;
};

export const parseDate = (dateString: string): Date | null => {
  if (!dateString) return null;
  
  // GG.AA.YYYY formatını parse et
  if (dateString.includes('.')) {
    const parts = dateString.split('.');
    if (parts.length === 3) {
      const day = parseInt(parts[0], 10);
      const month = parseInt(parts[1], 10) - 1;
      const year = parseInt(parts[2], 10);
      return new Date(year, month, day);
    }
  }
  
  return new Date(dateString);
};

export const sanitizeFileName = (fileName: string): string => {
  return fileName.replace(/[^a-zA-Z0-9.-]/g, '_');
};
