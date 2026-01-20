import { useState } from 'react';

interface ConfirmOptions {
  message: string;
  title?: string;
  confirmText?: string;
  cancelText?: string;
  type?: 'danger' | 'warning' | 'info';
}

interface ConfirmState {
  isOpen: boolean;
  message: string;
  title: string;
  confirmText: string;
  cancelText: string;
  type: 'danger' | 'warning' | 'info';
  onConfirm: (() => void) | null;
}

export const useConfirm = () => {
  const [confirmState, setConfirmState] = useState<ConfirmState>({
    isOpen: false,
    message: '',
    title: 'Onay',
    confirmText: 'Tamam',
    cancelText: 'İptal',
    type: 'warning',
    onConfirm: null,
  });

  const confirm = (options: ConfirmOptions): Promise<boolean> => {
    return new Promise((resolve) => {
      setConfirmState({
        isOpen: true,
        message: options.message,
        title: options.title || 'Onay',
        confirmText: options.confirmText || 'Tamam',
        cancelText: options.cancelText || 'İptal',
        type: options.type || 'warning',
        onConfirm: () => {
          setConfirmState((prev) => ({ ...prev, isOpen: false, onConfirm: null }));
          resolve(true);
        },
      });
    });
  };

  const closeConfirm = () => {
    setConfirmState((prev) => ({ ...prev, isOpen: false, onConfirm: null }));
  };

  return {
    confirmState,
    confirm,
    closeConfirm,
  };
};
