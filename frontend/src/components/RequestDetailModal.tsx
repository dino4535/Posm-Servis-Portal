import { useEffect, useState } from 'react';
import { formatDate } from '../utils/helpers';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from './ConfirmModal';
import { REQUEST_TYPES, REQUEST_STATUS, PRIORITY } from '../utils/constants';
import PhotoViewer from './PhotoViewer';
import '../styles/RequestDetailModal.css';

interface Request {
  id: number;
  request_no: string;
  dealer_id: number;
  bayi_adi?: string;
  bayi_kodu?: string;
  bayi_latitude?: number;
  bayi_longitude?: number;
  yapilacak_is: string;
  istenen_tarih: string;
  planlanan_tarih?: string;
  durum: string;
  territory_id?: number;
  territory_name?: string;
  territory_code?: string;
  depot_id?: number;
  depot_name?: string;
  posm_id?: number;
  posm_name?: string;
  yapilacak_is_detay?: string;
  created_at?: string;
  user_name?: string;
  priority?: number;
  notes?: string;
}

interface RequestDetailModalProps {
  request: Request;
  onClose: () => void;
  onUpdate?: () => void;
}

const RequestDetailModal: React.FC<RequestDetailModalProps> = ({ request, onClose, onUpdate }) => {
  const { isAdmin, isTeknik } = useAuth();
  const { showSuccess, showError, showWarning } = useToast();
  const [isEditing, setIsEditing] = useState(false);
  const [loading, setLoading] = useState(false);
  const [planDate, setPlanDate] = useState('');
  const [showPlanForm, setShowPlanForm] = useState(false);
  const [showPhotoViewer, setShowPhotoViewer] = useState(false);
  const [showCompleteModal, setShowCompleteModal] = useState(false);
  const [completeNotes, setCompleteNotes] = useState('');
  const [wasUsed, setWasUsed] = useState(false);
  const [usedQuantity, setUsedQuantity] = useState('');
  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    message: string;
    onConfirm: () => void;
    type?: 'danger' | 'warning' | 'info';
  }>({
    isOpen: false,
    message: '',
    onConfirm: () => {},
    type: 'danger',
  });
  const [completePhotos, setCompletePhotos] = useState<File[]>([]);
  const [photoPreviews, setPhotoPreviews] = useState<string[]>([]);
  const [uploadingPhotos, setUploadingPhotos] = useState(false);
  const [currentRequest, setCurrentRequest] = useState(request);
  const [formData, setFormData] = useState({
    yapilacak_is: request.yapilacak_is,
    yapilacak_is_detay: request.yapilacak_is_detay || '',
    istenen_tarih: typeof request.istenen_tarih === 'string' 
      ? (request.istenen_tarih.includes('T') ? request.istenen_tarih.split('T')[0] : request.istenen_tarih)
      : request.istenen_tarih,
    planlanan_tarih: request.planlanan_tarih 
      ? (typeof request.planlanan_tarih === 'string' 
          ? (request.planlanan_tarih.includes('T') ? request.planlanan_tarih.split('T')[0] : request.planlanan_tarih)
          : request.planlanan_tarih)
      : '',
    durum: request.durum,
    priority: request.priority || 0,
    notes: request.notes || '',
  });

  useEffect(() => {
    setCurrentRequest(request);
    const dateStr = request.istenen_tarih.includes('T') 
      ? request.istenen_tarih.split('T')[0] 
      : request.istenen_tarih;
    const planDateStr = request.planlanan_tarih 
      ? (request.planlanan_tarih.includes('T') ? request.planlanan_tarih.split('T')[0] : request.planlanan_tarih)
      : '';
    setFormData({
      yapilacak_is: request.yapilacak_is,
      yapilacak_is_detay: request.yapilacak_is_detay || '',
      istenen_tarih: dateStr,
      planlanan_tarih: planDateStr,
      durum: request.durum,
      priority: request.priority || 0,
      notes: request.notes || '',
    });
  }, [request]);

  useEffect(() => {
    const handleEscape = (e: KeyboardEvent) => {
      if (e.key === 'Escape' && !isEditing) {
        onClose();
      }
    };
    document.addEventListener('keydown', handleEscape);
    return () => document.removeEventListener('keydown', handleEscape);
  }, [onClose, isEditing]);

  const handleSave = async () => {
    setLoading(true);
    try {
      const updateData: any = {};
      const currentDateStr = currentRequest.istenen_tarih.includes('T')
        ? currentRequest.istenen_tarih.split('T')[0]
        : currentRequest.istenen_tarih;
      const currentPlanDateStr = currentRequest.planlanan_tarih
        ? (currentRequest.planlanan_tarih.includes('T')
            ? currentRequest.planlanan_tarih.split('T')[0]
            : currentRequest.planlanan_tarih)
        : '';

      if (formData.yapilacak_is !== currentRequest.yapilacak_is) {
        updateData.yapilacak_is = formData.yapilacak_is;
      }
      if (formData.yapilacak_is_detay !== (currentRequest.yapilacak_is_detay || '')) {
        updateData.yapilacak_is_detay = formData.yapilacak_is_detay;
      }
      if (formData.istenen_tarih !== currentDateStr) {
        updateData.istenen_tarih = formData.istenen_tarih;
      }
      if (formData.planlanan_tarih !== currentPlanDateStr) {
        updateData.planlanan_tarih = formData.planlanan_tarih || null;
      }
      if (formData.durum !== currentRequest.durum) {
        updateData.durum = formData.durum;
      }
      if (formData.priority !== (currentRequest.priority || 0)) {
        updateData.priority = formData.priority;
      }
      if (formData.notes !== (currentRequest.notes || '')) {
        updateData.notes = formData.notes;
      }

      if (Object.keys(updateData).length > 0) {
        const response = await api.put(`/requests/${currentRequest.id}`, updateData);
        if (response.data.success) {
          setCurrentRequest(response.data.data);
          setIsEditing(false);
          if (onUpdate) onUpdate();
          showSuccess('Talep başarıyla güncellendi');
        }
      } else {
        setIsEditing(false);
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Güncelleme sırasında hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const handlePlan = async () => {
    if (!planDate) {
      showWarning('Lütfen planlanan tarih seçin');
      return;
    }

    setLoading(true);
    try {
      const response = await api.put(`/requests/${currentRequest.id}/plan`, {
        planlanan_tarih: planDate,
      });
      if (response.data.success) {
        setCurrentRequest(response.data.data);
        setShowPlanForm(false);
        setPlanDate('');
        if (onUpdate) onUpdate();
        showSuccess('Talep başarıyla planlandı');
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Planlama sırasında hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const handleCompleteClick = () => {
    setWasUsed(false);
    setUsedQuantity('');
    setCompleteNotes('');
    setCompletePhotos([]);
    setPhotoPreviews([]);
    setShowCompleteModal(true);
    setCompleteNotes('');
    setCompletePhotos([]);
    setPhotoPreviews([]);
  };

  const handlePhotoSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    if (files.length > 0) {
      setCompletePhotos(files);
      // Önizlemeler oluştur
      const previews: string[] = [];
      files.forEach((file) => {
        const reader = new FileReader();
        reader.onloadend = () => {
          previews.push(reader.result as string);
          if (previews.length === files.length) {
            setPhotoPreviews([...previews]);
          }
        };
        reader.readAsDataURL(file);
      });
    }
  };

  const handleRemovePhoto = (index: number) => {
    const newPhotos = completePhotos.filter((_, i) => i !== index);
    const newPreviews = photoPreviews.filter((_, i) => i !== index);
    setCompletePhotos(newPhotos);
    setPhotoPreviews(newPreviews);
  };

  const handleComplete = async () => {
    // Fotoğraf kontrolü
    if (completePhotos.length === 0) {
      showWarning('Lütfen en az bir fotoğraf yükleyin. Yapılan işlerin veya takılan POSM\'in fotoğrafını yüklemelisiniz.');
      return;
    }

    // PUSHER ve kullanıldı seçildiğinde miktar kontrolü
    if (wasUsed && 
        currentRequest.posm_name && 
        currentRequest.posm_name.toUpperCase().includes('PUSHER') &&
        (!usedQuantity || parseInt(usedQuantity, 10) <= 0)) {
      showWarning('Pusher kullanıldıysa lütfen kullanılan miktarı girin');
      return;
    }

    setLoading(true);
    setUploadingPhotos(true);

    try {
      // Önce fotoğrafları yükle
      const formData = new FormData();
      completePhotos.forEach((file) => {
        formData.append('photo', file);
      });
      formData.append('request_id', currentRequest.id.toString());

      await api.post('/photos', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      // Sonra talebi tamamla (notlar, kullanıldı mı, kullanılan miktar ile birlikte)
      const response = await api.put(`/requests/${currentRequest.id}/complete`, {
        notes: completeNotes.trim() || undefined,
        was_used: wasUsed,
        used_quantity: wasUsed && usedQuantity ? parseInt(usedQuantity, 10) : null,
      });

      if (response.data.success) {
        setCurrentRequest(response.data.data);
        setShowCompleteModal(false);
        if (onUpdate) onUpdate();
        showSuccess('Talep başarıyla tamamlandı');
      }
    } catch (error: any) {
      const errorMessage = error.response?.data?.error || 'Tamamlama sırasında hata oluştu';
      showError(errorMessage);
    } finally {
      setLoading(false);
      setUploadingPhotos(false);
    }
  };

  const handleCancel = async () => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu talebi iptal etmek istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        setLoading(true);
        try {
          const response = await api.put(`/requests/${currentRequest.id}/cancel`);
          if (response.data.success) {
            showSuccess('Talep başarıyla iptal edildi');
            if (onUpdate) onUpdate();
            // Modal'ı kapatmadan güncellenmiş veriyi göster
            const updatedRequest = await api.get(`/requests/${currentRequest.id}`);
            if (updatedRequest.data.success) {
              setCurrentRequest(updatedRequest.data.data);
            }
          }
        } catch (error: any) {
          showError(error.response?.data?.error || 'İptal sırasında hata oluştu');
        } finally {
          setLoading(false);
        }
      },
    });
  };

  const handleDelete = async () => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu talebi silmek istediğinize emin misiniz? Bu işlem geri alınamaz!',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        setLoading(true);
        try {
          const response = await api.delete(`/requests/${currentRequest.id}`);
          if (response.data.success) {
            showSuccess('Talep başarıyla silindi');
            if (onUpdate) onUpdate();
            onClose();
          }
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme sırasında hata oluştu');
        } finally {
          setLoading(false);
        }
      },
    });
  };

  const canEdit = isAdmin || (isTeknik && currentRequest.durum !== 'Tamamlandı');
  const canPlan = (isAdmin || isTeknik) && currentRequest.durum === 'Beklemede';
  const canComplete = (isAdmin || isTeknik) && currentRequest.durum === 'Planlandı';
  const canCancel = currentRequest.durum === 'Beklemede' || currentRequest.durum === 'Planlandı';
  const canDelete = isAdmin;
  
  return (
    <>
      <div 
        className="modal-overlay" 
        onClick={(e) => {
          if (!isEditing && e.target === e.currentTarget) {
            onClose();
          }
        }}
      >
        <div className="modal-content" onClick={(e) => e.stopPropagation()}>
          <div className="modal-header">
            <h3>Talep Detayı</h3>
            <button className="close-button" onClick={onClose}>×</button>
          </div>
          <div className="modal-body">
            {!isEditing ? (
              <>
                <div className="detail-row">
                  <span className="detail-label">Talep No:</span>
                  <span className="detail-value">{currentRequest.request_no}</span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Bayi:</span>
                  <span className="detail-value">
                    {currentRequest.bayi_adi || '-'}
                  </span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Bayi Kodu:</span>
                  <span className="detail-value">
                    {currentRequest.bayi_kodu || '-'}
                  </span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Depo:</span>
                  <span className="detail-value">
                    {currentRequest.depot_name || '-'}
                  </span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Territory:</span>
                  <span className="detail-value">
                    {currentRequest.territory_name || currentRequest.territory_code || '-'}
                  </span>
                </div>
                {currentRequest.posm_id && (
                  <div className="detail-row">
                    <span className="detail-label">POSM:</span>
                    <span className="detail-value">
                      {currentRequest.posm_name || `POSM ID: ${currentRequest.posm_id}`}
                    </span>
                  </div>
                )}
                {currentRequest.bayi_latitude && currentRequest.bayi_longitude && (
                  <div className="detail-row">
                    <span className="detail-label">Konum:</span>
                    <span className="detail-value">
                      <button
                        className="view-photos-button"
                        onClick={() => {
                          const lat = currentRequest.bayi_latitude!;
                          const lng = currentRequest.bayi_longitude!;
                          const isMobile = /iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
                          
                          if (isMobile) {
                            // Mobil cihaz - cihaza göre uygun harita uygulaması
                            const isIOS = /iPhone|iPad|iPod/i.test(navigator.userAgent);
                            
                            if (isIOS) {
                              // iOS - Apple Maps
                              window.open(`maps://maps.apple.com/?q=${lat},${lng}`, '_blank');
                            } else {
                              // Android - Google Maps
                              window.open(`https://www.google.com/maps/search/?api=1&query=${lat},${lng}`, '_blank');
                            }
                          } else {
                            // Desktop - Google Maps
                            window.open(`https://www.google.com/maps/search/?api=1&query=${lat},${lng}`, '_blank');
                          }
                        }}
                      >
                        📍 {/iPhone|iPad|iPod|Android/i.test(navigator.userAgent) 
                          ? (/iPhone|iPad|iPod/i.test(navigator.userAgent) ? 'Apple Maps' : 'Google Maps')
                          : 'Google Maps'}
                      </button>
                    </span>
                  </div>
                )}
                <div className="detail-row">
                  <span className="detail-label">Yapılacak İş:</span>
                  <span className="detail-value">{currentRequest.yapilacak_is}</span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">Yapılacak İşler Detayı:</span>
                  <span className="detail-value">{currentRequest.yapilacak_is_detay || '-'}</span>
                </div>
                <div className="detail-row">
                  <span className="detail-label">İstenen Tarih:</span>
                  <span className="detail-value">{formatDate(currentRequest.istenen_tarih)}</span>
                </div>
                {currentRequest.planlanan_tarih && (
                  <div className="detail-row">
                    <span className="detail-label">Planlanan Tarih:</span>
                    <span className="detail-value">{formatDate(currentRequest.planlanan_tarih)}</span>
                  </div>
                )}
                <div className="detail-row">
                  <span className="detail-label">Durum:</span>
                  <span className={`status-badge status-${currentRequest.durum.toLowerCase()}`}>
                    {currentRequest.durum}
                  </span>
                </div>
                {currentRequest.priority !== undefined && (
                  <div className="detail-row">
                    <span className="detail-label">Öncelik:</span>
                    <span className="detail-value">
                      {currentRequest.priority === PRIORITY.URGENT
                        ? 'Acil'
                        : currentRequest.priority === PRIORITY.HIGH
                        ? 'Yüksek'
                        : 'Normal'}
                    </span>
                  </div>
                )}
                {currentRequest.notes && (
                  <div className="detail-row">
                    <span className="detail-label">Notlar:</span>
                    <span className="detail-value">{currentRequest.notes}</span>
                  </div>
                )}
                {currentRequest.created_at && (
                  <div className="detail-row">
                    <span className="detail-label">Oluşturulma Tarihi:</span>
                    <span className="detail-value">{formatDate(currentRequest.created_at)}</span>
                  </div>
                )}
                <div className="detail-row">
                  <span className="detail-label">Fotoğraflar:</span>
                  <span className="detail-value">
                    <button
                      className="view-photos-button"
                      onClick={() => setShowPhotoViewer(true)}
                    >
                      Fotoğrafları Görüntüle
                    </button>
                  </span>
                </div>
                <div className="detail-row" style={{ borderBottom: 'none', paddingTop: '24px' }}>
                  <span className="detail-label"></span>
                  <span className="detail-value" style={{ display: 'flex', gap: '12px', justifyContent: 'flex-end', flexWrap: 'wrap' }}>
                    {canEdit && (
                      <button
                        className="action-button edit-button"
                        onClick={() => setIsEditing(true)}
                        style={{ padding: '14px 28px', fontSize: '16px', fontWeight: '600' }}
                      >
                        Düzenle
                      </button>
                    )}
                    {canPlan && !showPlanForm && (
                      <button
                        className="action-button plan-button"
                        onClick={() => setShowPlanForm(true)}
                        disabled={loading}
                        style={{ padding: '14px 28px', fontSize: '16px', fontWeight: '600' }}
                      >
                        Planla
                      </button>
                    )}
                    {showPlanForm && (
                      <div className="plan-form" style={{ display: 'flex', gap: '12px', alignItems: 'center', flexWrap: 'wrap' }}>
                        <input
                          type="date"
                          value={planDate}
                          onChange={(e) => setPlanDate(e.target.value)}
                          min={new Date().toISOString().split('T')[0]}
                          style={{ padding: '12px 16px', border: '2px solid var(--border-color)', borderRadius: 'var(--radius-md)', fontSize: '14px' }}
                        />
                        <button
                          className="action-button plan-button"
                          onClick={handlePlan}
                          disabled={loading || !planDate}
                          style={{ padding: '14px 28px', fontSize: '16px', fontWeight: '600' }}
                        >
                          {loading ? 'Planlanıyor...' : 'Planla'}
                        </button>
                        <button
                          className="action-button cancel-button"
                          onClick={() => {
                            setShowPlanForm(false);
                            setPlanDate('');
                          }}
                          disabled={loading}
                          style={{ padding: '14px 28px', fontSize: '16px', fontWeight: '600' }}
                        >
                          İptal
                        </button>
                      </div>
                    )}
                  </span>
                </div>
              </>
            ) : (
              <div className="edit-form">
                <div className="form-group">
                  <label>Yapılacak İş *</label>
                  <select
                    value={formData.yapilacak_is}
                    onChange={(e) => setFormData({ ...formData, yapilacak_is: e.target.value })}
                    required
                  >
                    {Object.values(REQUEST_TYPES).map((type) => (
                      <option key={type} value={type}>
                        {type}
                      </option>
                    ))}
                  </select>
                </div>
                <div className="form-group">
                  <label>Detay</label>
                  <textarea
                    value={formData.yapilacak_is_detay}
                    onChange={(e) => setFormData({ ...formData, yapilacak_is_detay: e.target.value })}
                    rows={3}
                  />
                </div>
                <div className="form-group">
                  <label>İstenen Tarih *</label>
                  <input
                    type="date"
                    value={formData.istenen_tarih}
                    onChange={(e) => setFormData({ ...formData, istenen_tarih: e.target.value })}
                    required
                  />
                </div>
                <div className="form-group">
                  <label>Planlanan Tarih</label>
                  <input
                    type="date"
                    value={formData.planlanan_tarih}
                    onChange={(e) => setFormData({ ...formData, planlanan_tarih: e.target.value })}
                  />
                </div>
                {(isAdmin || isTeknik) && (
                  <>
                    <div className="form-group">
                      <label>Durum</label>
                      <select
                        value={formData.durum}
                        onChange={(e) => setFormData({ ...formData, durum: e.target.value })}
                      >
                        {Object.values(REQUEST_STATUS).map((status) => (
                          <option key={status} value={status}>
                            {status}
                          </option>
                        ))}
                      </select>
                    </div>
                    <div className="form-group">
                      <label>Öncelik</label>
                      <select
                        value={formData.priority}
                        onChange={(e) =>
                          setFormData({ ...formData, priority: parseInt(e.target.value, 10) })
                        }
                      >
                        <option value={PRIORITY.NORMAL}>Normal</option>
                        <option value={PRIORITY.HIGH}>Yüksek</option>
                        <option value={PRIORITY.URGENT}>Acil</option>
                      </select>
                    </div>
                  </>
                )}
                <div className="form-group">
                  <label>Notlar</label>
                  <textarea
                    value={formData.notes}
                    onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                    rows={3}
                  />
                </div>
              </div>
            )}
          </div>
          <div className="modal-footer">
            {!isEditing ? (
              <>
                {canComplete && (
              <button
                className="action-button complete-button"
                onClick={() => {
                  setWasUsed(false);
                  setUsedQuantity('');
                  setCompleteNotes('');
                  setCompletePhotos([]);
                  setPhotoPreviews([]);
                  setShowCompleteModal(true);
                }}
                disabled={loading}
              >
                Tamamla
              </button>
                )}
                {canCancel && (
                  <button
                    className="action-button cancel-button"
                    onClick={handleCancel}
                    disabled={loading}
                    style={{ background: '#f39c12', color: 'white' }}
                  >
                    {loading ? 'İptal Ediliyor...' : 'İptal Et'}
                  </button>
                )}
                {canDelete && (
                  <button
                    className="action-button delete-button"
                    onClick={handleDelete}
                    disabled={loading}
                  >
                    {loading ? 'Siliniyor...' : 'Sil'}
                  </button>
                )}
                <button className="close-modal-button" onClick={onClose}>
                  Kapat
                </button>
              </>
            ) : (
              <>
                <button
                  className="action-button save-button"
                  onClick={handleSave}
                  disabled={loading}
                >
                  {loading ? 'Kaydediliyor...' : 'Kaydet'}
                </button>
                <button
                  className="action-button cancel-button"
                  onClick={() => {
                    setIsEditing(false);
                    const dateStr = currentRequest.istenen_tarih.includes('T')
                      ? currentRequest.istenen_tarih.split('T')[0]
                      : currentRequest.istenen_tarih;
                    const planDateStr = currentRequest.planlanan_tarih
                      ? (currentRequest.planlanan_tarih.includes('T')
                          ? currentRequest.planlanan_tarih.split('T')[0]
                          : currentRequest.planlanan_tarih)
                      : '';
                    setFormData({
                      yapilacak_is: currentRequest.yapilacak_is,
                      yapilacak_is_detay: currentRequest.yapilacak_is_detay || '',
                      istenen_tarih: dateStr,
                      planlanan_tarih: planDateStr,
                      durum: currentRequest.durum,
                      priority: currentRequest.priority || 0,
                      notes: currentRequest.notes || '',
                    });
                  }}
                  disabled={loading}
                >
                  İptal
                </button>
              </>
            )}
          </div>
        </div>
      </div>

      {showPhotoViewer && (
        <PhotoViewer
          requestId={currentRequest.id}
          isOpen={showPhotoViewer}
          onClose={() => setShowPhotoViewer(false)}
        />
      )}

      {/* Tamamlama Modal */}
      {showCompleteModal && (
        <div 
          className="modal-overlay" 
          style={{ zIndex: 10000 }}
          onClick={(e) => {
            if (e.target === e.currentTarget && !loading) {
              setShowCompleteModal(false);
            }
          }}
        >
          <div className="modal-content" style={{ maxWidth: '600px' }} onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>Talep Tamamlama</h3>
              <button 
                className="close-button" 
                onClick={() => !loading && setShowCompleteModal(false)}
                disabled={loading}
              >
                ×
              </button>
            </div>
            <div className="modal-body">
              <div style={{ marginBottom: '24px' }}>
                <label style={{ display: 'block', marginBottom: '8px', fontWeight: 600, color: '#495057' }}>
                  Fotoğraf Yükle <span style={{ color: '#e74c3c' }}>*</span>
                </label>
                <p style={{ fontSize: '13px', color: '#6c757d', marginBottom: '12px' }}>
                  Yapılan işlerin veya takılan POSM'in fotoğrafını yükleyin. En az bir fotoğraf zorunludur.
                </p>
                <input
                  type="file"
                  accept="image/*"
                  multiple
                  onChange={handlePhotoSelect}
                  disabled={loading}
                  style={{
                    width: '100%',
                    padding: '10px',
                    border: '2px solid #dee2e6',
                    borderRadius: '8px',
                    fontSize: '14px',
                  }}
                />
                {photoPreviews.length > 0 && (
                  <div style={{ marginTop: '16px', display: 'flex', flexWrap: 'wrap', gap: '12px' }}>
                    {photoPreviews.map((preview, index) => (
                      <div key={index} style={{ position: 'relative', width: '100px', height: '100px' }}>
                        <img
                          src={preview}
                          alt={`Preview ${index + 1}`}
                          style={{
                            width: '100%',
                            height: '100%',
                            objectFit: 'cover',
                            borderRadius: '8px',
                            border: '2px solid #dee2e6',
                          }}
                        />
                        <button
                          onClick={() => handleRemovePhoto(index)}
                          disabled={loading}
                          style={{
                            position: 'absolute',
                            top: '-8px',
                            right: '-8px',
                            background: '#e74c3c',
                            color: 'white',
                            border: 'none',
                            borderRadius: '50%',
                            width: '24px',
                            height: '24px',
                            cursor: 'pointer',
                            fontSize: '14px',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                          }}
                        >
                          ×
                        </button>
                      </div>
                    ))}
                  </div>
                )}
              </div>

              <div>
                {/* Kullanıldı mı? sorusu - Tüm işler için */}
                <div style={{ marginBottom: '20px' }}>
                  <label style={{ display: 'flex', alignItems: 'center', marginBottom: '8px', fontWeight: 600, color: '#495057' }}>
                    <input
                      type="checkbox"
                      checked={wasUsed}
                      onChange={(e) => {
                        setWasUsed(e.target.checked);
                        if (!e.target.checked) {
                          setUsedQuantity('');
                        }
                      }}
                      disabled={loading}
                      style={{ marginRight: '8px', width: '18px', height: '18px' }}
                    />
                    Kullanıldı mı?
                  </label>
                  <p style={{ fontSize: '12px', color: '#6c757d', marginLeft: '26px' }}>
                    İşlem sırasında POSM kullanıldıysa işaretleyin
                  </p>
                </div>

                {/* Kullanılan miktar - PUSHER ve kullanıldı seçildiğinde */}
                {wasUsed && currentRequest.posm_name && currentRequest.posm_name.toUpperCase().includes('PUSHER') && (
                  <div style={{ marginBottom: '20px' }}>
                    <label style={{ display: 'block', marginBottom: '8px', fontWeight: 600, color: '#495057' }}>
                      Kullanılan Miktar <span style={{ color: '#e74c3c' }}>*</span>
                    </label>
                    <input
                      type="number"
                      min="1"
                      value={usedQuantity}
                      onChange={(e) => setUsedQuantity(e.target.value)}
                      disabled={loading}
                      placeholder="Kullanılan adet miktarını girin"
                      required
                      style={{
                        width: '100%',
                        padding: '10px',
                        border: '2px solid #dee2e6',
                        borderRadius: '8px',
                        fontSize: '14px',
                      }}
                    />
                    <p style={{ fontSize: '12px', color: '#6c757d', marginTop: '4px' }}>
                      ℹ️ Pusher için kullanılan adet miktarını girin. Bu miktar hazır envanterden düşülecektir.
                    </p>
                  </div>
                )}

                <label style={{ display: 'block', marginBottom: '8px', fontWeight: 600, color: '#495057' }}>
                  Notlar (Opsiyonel)
                </label>
                <textarea
                  value={completeNotes}
                  onChange={(e) => setCompleteNotes(e.target.value)}
                  disabled={loading}
                  placeholder="Talep ile ilgili notlarınızı buraya yazabilirsiniz..."
                  rows={4}
                  style={{
                    width: '100%',
                    padding: '12px',
                    border: '2px solid #dee2e6',
                    borderRadius: '8px',
                    fontSize: '14px',
                    fontFamily: 'inherit',
                    resize: 'vertical',
                  }}
                />
              </div>
            </div>
            <div className="modal-footer">
              <button
                className="action-button complete-button"
                onClick={handleComplete}
                disabled={loading || uploadingPhotos || completePhotos.length === 0}
              >
                {loading || uploadingPhotos 
                  ? (uploadingPhotos ? 'Fotoğraflar yükleniyor...' : 'Tamamlanıyor...') 
                  : 'Tamamla ve Kaydet'}
              </button>
              <button
                className="action-button cancel-button"
                onClick={() => setShowCompleteModal(false)}
                disabled={loading || uploadingPhotos}
              >
                İptal
              </button>
            </div>
          </div>
        </div>
      )}

      <ConfirmModal
        isOpen={confirmModal.isOpen}
        title="Onay"
        message={confirmModal.message}
        type={confirmModal.type}
        onConfirm={confirmModal.onConfirm}
        onCancel={() => setConfirmModal({ ...confirmModal, isOpen: false })}
      />
    </>
  );
};

export default RequestDetailModal;
