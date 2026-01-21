import { useState, useEffect } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import { useDepot } from '../hooks/useDepot';
import ConfirmModal from '../components/ConfirmModal';
import { formatDate } from '../utils/helpers';
import '../styles/POSMTransferPage.css';

const POSMTransferPage = () => {
  const { isAdmin, isTeknik } = useAuth();
  const { showSuccess, showError } = useToast();
  const { depots: userDepots, selectedDepot } = useDepot();
  const [transfers, setTransfers] = useState<any[]>([]);
  const [posms, setPosms] = useState<any[]>([]);
  const [depots, setDepots] = useState<any[]>([]);
  const [allActiveDepots, setAllActiveDepots] = useState<any[]>([]); // Hedef depo için tüm aktif depolar
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [formData, setFormData] = useState({
    posm_id: '',
    from_depot_id: '',
    to_depot_id: '',
    quantity: '',
    transfer_type: 'Hazir' as 'Hazir' | 'Tamir',
    notes: '',
  });
  const [filterStatus, setFilterStatus] = useState('');
  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    message: string;
    onConfirm: () => void;
    type?: 'danger' | 'warning' | 'info';
  }>({
    isOpen: false,
    message: '',
    onConfirm: () => {},
    type: 'warning',
  });

  useEffect(() => {
    fetchTransfers();
    fetchDepots();
    fetchAllActiveDepots(); // Hedef depo için tüm aktif depoları yükle
  }, [filterStatus]);

  // userDepots değiştiğinde POSM'leri yeniden yükle
  useEffect(() => {
    if (userDepots.length > 0) {
      fetchPOSMs();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [userDepots]);

  // Form açıldığında, kullanıcının tek deposu varsa otomatik seç
  useEffect(() => {
    if (showForm && userDepots.length === 1 && !formData.from_depot_id) {
      setFormData(prev => ({
        ...prev,
        from_depot_id: userDepots[0].id.toString()
      }));
    } else if (showForm && selectedDepot && !formData.from_depot_id) {
      setFormData(prev => ({
        ...prev,
        from_depot_id: selectedDepot.id.toString()
      }));
    }
  }, [showForm, userDepots, selectedDepot]);

  const fetchTransfers = async () => {
    setLoading(true);
    try {
      const params = filterStatus ? `?status=${filterStatus}` : '';
      const response = await api.get(`/posm-transfers${params}`);
      if (response.data.success) {
        setTransfers(response.data.data);
      }
    } catch (error) {
      console.error('Transferler yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  // Kullanıcının kendi depolarındaki POSM'leri getir
  const fetchPOSMs = async () => {
    try {
      const response = await api.get('/posm/my-depots');
      if (response.data.success) {
        // Ek güvenlik: Frontend'de de kullanıcının depolarına göre filtrele
        const userDepotIds = userDepots.map(d => Number(d.id));
        console.log('Kullanıcı Depo ID\'leri:', userDepotIds);
        console.log('Backend\'den gelen POSM sayısı:', response.data.data.length);
        
        const filteredPosms = response.data.data.filter((posm: any) => {
          const posmDepotId = typeof posm.depot_id === 'string' 
            ? parseInt(posm.depot_id.split(',')[0].trim(), 10) 
            : Number(posm.depot_id);
          
          const isInUserDepots = userDepotIds.includes(posmDepotId);
          
          if (!isInUserDepots) {
            console.warn(`POSM ${posm.name} (depot_id: ${posmDepotId}) kullanıcının depolarında değil. Kullanıcı depoları:`, userDepotIds);
          }
          
          return isInUserDepots;
        });
        
        console.log('Filtrelenmiş POSM sayısı:', filteredPosms.length);
        setPosms(filteredPosms);
      }
    } catch (error) {
      console.error('POSM\'ler yüklenirken hata:', error);
    }
  };

  const fetchDepots = async () => {
    try {
      const response = await api.get('/depots');
      if (response.data.success) {
        setDepots(response.data.data);
      }
    } catch (error) {
      console.error('Depolar yüklenirken hata:', error);
    }
  };

  // Hedef depo için tüm aktif depoları getir
  const fetchAllActiveDepots = async () => {
    try {
      const response = await api.get('/depots/all-active');
      if (response.data.success) {
        console.log('Tüm aktif depolar yüklendi:', response.data.data.length, 'depot');
        setAllActiveDepots(response.data.data);
      }
    } catch (error: any) {
      console.error('Tüm aktif depolar yüklenirken hata:', error);
      console.error('Hata detayı:', error.response?.data);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await api.post('/posm-transfers', {
        posm_id: parseInt(formData.posm_id, 10),
        from_depot_id: parseInt(formData.from_depot_id, 10),
        to_depot_id: parseInt(formData.to_depot_id, 10),
        quantity: parseInt(formData.quantity, 10),
        transfer_type: formData.transfer_type,
        notes: formData.notes || null,
      });
      fetchTransfers();
      resetForm();
      showSuccess('Transfer talebi başarıyla oluşturuldu');
    } catch (error: any) {
      showError(error.response?.data?.error || 'Transfer oluşturulurken hata oluştu');
    }
  };

  const handleApprove = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu transferi onaylamak istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.put(`/posm-transfers/${id}/approve`);
          fetchTransfers();
          showSuccess('Transfer onaylandı');
        } catch (error: any) {
          showError(error.response?.data?.error || 'Onaylama sırasında hata oluştu');
        }
      },
    });
  };

  const handleComplete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu transferi tamamlamak istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.put(`/posm-transfers/${id}/complete`);
          fetchTransfers();
          showSuccess('Transfer tamamlandı');
        } catch (error: any) {
          showError(error.response?.data?.error || 'Tamamlama sırasında hata oluştu');
        }
      },
    });
  };

  const handleCancel = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu transferi iptal etmek istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.put(`/posm-transfers/${id}/cancel`);
          fetchTransfers();
          showSuccess('Transfer iptal edildi');
        } catch (error: any) {
          showError(error.response?.data?.error || 'İptal sırasında hata oluştu');
        }
      },
    });
  };

  const resetForm = () => {
    // Form sıfırlanırken, kullanıcının deposunu otomatik seç
    const defaultFromDepot = userDepots.length === 1 
      ? userDepots[0].id.toString() 
      : (selectedDepot ? selectedDepot.id.toString() : '');
    
    setFormData({
      posm_id: '',
      from_depot_id: defaultFromDepot,
      to_depot_id: '',
      quantity: '',
      transfer_type: 'Hazir',
      notes: '',
    });
    setShowForm(false);
  };

  const getStatusBadgeClass = (status: string) => {
    const statusMap: { [key: string]: string } = {
      Beklemede: 'status-pending',
      Onaylandi: 'status-approved',
      Tamamlandi: 'status-completed',
      Iptal: 'status-cancelled',
    };
    return statusMap[status] || '';
  };

  if (!isAdmin && !isTeknik) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="posm-transfer-page">
      <div className="page-header">
        <h2>POSM Transfer Yönetimi</h2>
        {(isAdmin || isTeknik) && (
          <button className="add-button" onClick={() => setShowForm(true)}>
            + Yeni Transfer
          </button>
        )}
      </div>

      <div className="filters-section">
        <select
          value={filterStatus}
          onChange={(e) => setFilterStatus(e.target.value)}
          className="filter-select"
        >
          <option value="">Tüm Durumlar</option>
          <option value="Beklemede">Beklemede</option>
          <option value="Onaylandi">Onaylandı</option>
          <option value="Tamamlandi">Tamamlandı</option>
          <option value="Iptal">İptal</option>
        </select>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>Yeni Transfer Talebi</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>POSM *</label>
                <select
                  value={formData.posm_id}
                  onChange={(e) => {
                    const selectedPosm = posms.find((p) => p.id.toString() === e.target.value);
                    setFormData({ 
                      ...formData, 
                      posm_id: e.target.value,
                      // POSM seçildiğinde otomatik olarak kaynak depo seç
                      from_depot_id: selectedPosm ? selectedPosm.depot_id?.toString() || '' : formData.from_depot_id
                    });
                  }}
                  required
                >
                  <option value="">POSM Seçiniz</option>
                  {posms.map((posm) => (
                    <option key={posm.id} value={posm.id}>
                      {posm.name} (Depo: {posm.depot_name || posm.depot_id})
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>Kaynak Depo *</label>
                <select
                  value={formData.from_depot_id}
                  onChange={(e) => setFormData({ ...formData, from_depot_id: e.target.value })}
                  required
                  disabled={!!formData.posm_id}
                  title={formData.posm_id ? "Kaynak depo, seçilen POSM'in deposu olarak otomatik belirlenir" : ""}
                >
                  <option value="">Depo Seçiniz</option>
                  {depots.map((depot) => (
                    <option key={depot.id} value={depot.id}>
                      {depot.name}
                    </option>
                  ))}
                </select>
                {formData.posm_id && (
                  <small style={{ color: '#666', fontSize: '12px', display: 'block', marginTop: '4px' }}>
                    ℹ️ Kaynak depo, seçilen POSM'in deposu olarak otomatik belirlenir
                  </small>
                )}
              </div>
              <div className="form-group">
                <label>Hedef Depo *</label>
                <select
                  value={formData.to_depot_id}
                  onChange={(e) => setFormData({ ...formData, to_depot_id: e.target.value })}
                  required
                >
                  <option value="">Depo Seçiniz</option>
                  {allActiveDepots.length > 0 ? (
                    allActiveDepots
                      .filter((d) => d.id.toString() !== formData.from_depot_id)
                      .map((depot) => (
                        <option key={depot.id} value={depot.id}>
                          {depot.name} {depot.code ? `(${depot.code})` : ''}
                        </option>
                      ))
                  ) : (
                    <option value="" disabled>Yükleniyor...</option>
                  )}
                </select>
                {allActiveDepots.length === 0 && (
                  <small style={{ color: '#666', fontSize: '12px', display: 'block', marginTop: '4px' }}>
                    Depolar yükleniyor...
                  </small>
                )}
              </div>
              <div className="form-group">
                <label>Miktar *</label>
                <input
                  type="number"
                  min="1"
                  value={formData.quantity}
                  onChange={(e) => setFormData({ ...formData, quantity: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Transfer Tipi *</label>
                <select
                  value={formData.transfer_type}
                  onChange={(e) =>
                    setFormData({ ...formData, transfer_type: e.target.value as 'Hazir' | 'Tamir' })
                  }
                  required
                >
                  <option value="Hazir">Hazır</option>
                  <option value="Tamir">Tamir</option>
                </select>
              </div>
              <div className="form-group">
                <label>Notlar</label>
                <textarea
                  value={formData.notes}
                  onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
                  rows={3}
                />
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  Oluştur
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="transfers-table-container">
        <table className="transfers-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>POSM</th>
              <th>Kaynak Depo</th>
              <th>Hedef Depo</th>
              <th>Miktar</th>
              <th>Tip</th>
              <th>Durum</th>
              <th>Talep Eden</th>
              <th>Tarih</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {transfers.length === 0 ? (
              <tr>
                <td colSpan={10} className="no-data">
                  Henüz transfer bulunmuyor
                </td>
              </tr>
            ) : (
              transfers.map((transfer) => (
                <tr key={transfer.id}>
                  <td>{transfer.id}</td>
                  <td>{transfer.posm_name || '-'}</td>
                  <td>{transfer.from_depot_name || '-'}</td>
                  <td>{transfer.to_depot_name || '-'}</td>
                  <td>{transfer.quantity}</td>
                  <td>{transfer.transfer_type}</td>
                  <td>
                    <span className={`status-badge ${getStatusBadgeClass(transfer.status)}`}>
                      {transfer.status}
                    </span>
                  </td>
                  <td>{transfer.requested_by_name || '-'}</td>
                  <td>{formatDate(transfer.created_at)}</td>
                  <td>
                    {transfer.status === 'Beklemede' && isAdmin && (
                      <button
                        className="action-button approve-button"
                        onClick={() => handleApprove(transfer.id)}
                      >
                        Onayla
                      </button>
                    )}
                    {transfer.status === 'Onaylandi' && (isAdmin || isTeknik) && (
                      <button
                        className="action-button complete-button"
                        onClick={() => handleComplete(transfer.id)}
                      >
                        Tamamla
                      </button>
                    )}
                    {(transfer.status === 'Beklemede' || transfer.status === 'Onaylandi') &&
                      (isAdmin || isTeknik) && (
                        <button
                          className="action-button cancel-button"
                          onClick={() => handleCancel(transfer.id)}
                        >
                          İptal
                        </button>
                      )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      <ConfirmModal
        isOpen={confirmModal.isOpen}
        title="Onay"
        message={confirmModal.message}
        type={confirmModal.type}
        onConfirm={confirmModal.onConfirm}
        onCancel={() => setConfirmModal({ ...confirmModal, isOpen: false })}
      />
    </div>
  );
};

export default POSMTransferPage;
