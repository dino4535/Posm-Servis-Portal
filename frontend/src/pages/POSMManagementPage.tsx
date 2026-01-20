import { useState, useEffect } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import '../styles/POSMManagementPage.css';

const POSMManagementPage = () => {
  const { isAdmin, isTeknik } = useAuth();
  const { showSuccess, showError } = useToast();
  const [posms, setPosms] = useState<any[]>([]);
  const [depots, setDepots] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingPosm, setEditingPosm] = useState<any>(null);
  const [bulkInserting, setBulkInserting] = useState(false);
  const [selectedDepotFilter, setSelectedDepotFilter] = useState<string>('');
  const [showBulkResult, setShowBulkResult] = useState(false);
  const [bulkResult, setBulkResult] = useState<any>(null);
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
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    depot_id: '',
    hazir_adet: '0',
    tamir_bekleyen: '0',
    revize_adet: '0',
  });

  useEffect(() => {
    fetchDepots();
    fetchPOSM();
  }, []);

  useEffect(() => {
    fetchPOSM();
  }, [selectedDepotFilter]);

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

  const fetchPOSM = async () => {
    setLoading(true);
    try {
      const url = selectedDepotFilter 
        ? `/posm?depot_id=${selectedDepotFilter}` 
        : '/posm';
      const response = await api.get(url);
      if (response.data.success) {
        setPosms(response.data.data);
      }
    } catch (error) {
      console.error('POSM yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const submitData = {
        ...formData,
        depot_id: parseInt(formData.depot_id, 10),
        hazir_adet: parseInt(formData.hazir_adet, 10) || 0,
        tamir_bekleyen: parseInt(formData.tamir_bekleyen, 10) || 0,
        revize_adet: parseInt(formData.revize_adet, 10) || 0,
      };

      if (editingPosm) {
        await api.put(`/posm/${editingPosm.id}`, submitData);
        showSuccess('POSM başarıyla güncellendi');
      } else {
        await api.post('/posm', submitData);
        showSuccess('POSM başarıyla oluşturuldu');
      }
      fetchPOSM();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (posm: any) => {
    setEditingPosm(posm);
    setFormData({
      name: posm.name,
      description: posm.description || '',
      depot_id: posm.depot_id?.toString() || '',
      hazir_adet: posm.hazir_adet?.toString() || '0',
      tamir_bekleyen: posm.tamir_bekleyen?.toString() || '0',
      revize_adet: posm.revize_adet?.toString() || '0',
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu POSM kaydını silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/posm/${id}`);
          showSuccess('POSM başarıyla silindi');
          fetchPOSM();
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const resetForm = () => {
    setFormData({
      name: '',
      description: '',
      depot_id: '',
      hazir_adet: '0',
      tamir_bekleyen: '0',
      revize_adet: '0',
    });
    setEditingPosm(null);
    setShowForm(false);
  };

  const handleBulkInsertToAllDepots = async () => {
    setConfirmModal({
      isOpen: true,
      message: 'Tüm aktif depolar için POSM\'ler eklenecek. Devam etmek istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        setBulkInserting(true);
        try {
          const response = await api.post('/posm/bulk-insert-all-depots');
          if (response.data.success) {
            const data = response.data.data;
            setBulkResult(data);
            setShowBulkResult(true);
            fetchPOSM();
          }
        } catch (error: any) {
          showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
        } finally {
          setBulkInserting(false);
        }
      },
    });
  };

  const canManage = isAdmin || isTeknik;

  if (!canManage) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading && posms.length === 0) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="posm-management-page">
      <div className="page-header">
        <h2>POSM Yönetimi</h2>
        <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>
          {isAdmin && (
            <button 
              className="add-button" 
              onClick={handleBulkInsertToAllDepots}
              disabled={bulkInserting}
              style={{ 
                background: bulkInserting ? '#95a5a6' : '#27ae60',
                fontSize: '14px',
                padding: '10px 20px'
              }}
            >
              {bulkInserting ? 'Ekleniyor...' : '📦 Tüm Depolar İçin POSM Ekle'}
            </button>
          )}
          <button className="add-button" onClick={() => setShowForm(true)}>
            + Yeni POSM
          </button>
        </div>
      </div>

      <div className="filters-section" style={{ marginBottom: '20px', display: 'flex', gap: '12px', alignItems: 'center' }}>
        <div className="filter-group">
          <label htmlFor="depot-filter" style={{ marginRight: '8px', fontWeight: '500' }}>
            Depo Filtresi:
          </label>
          <select
            id="depot-filter"
            value={selectedDepotFilter}
            onChange={(e) => setSelectedDepotFilter(e.target.value)}
            style={{
              padding: '8px 12px',
              borderRadius: '4px',
              border: '1px solid #ddd',
              fontSize: '14px',
              minWidth: '200px'
            }}
          >
            <option value="">Tüm Depolar</option>
            {depots.map((depot) => (
              <option key={depot.id} value={depot.id}>
                {depot.name} ({depot.code})
              </option>
            ))}
          </select>
        </div>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingPosm ? 'POSM Düzenle' : 'Yeni POSM'}</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>POSM Adı *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Açıklama</label>
                <textarea
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                  rows={3}
                />
              </div>
              <div className="form-group">
                <label>Depo *</label>
                <select
                  value={formData.depot_id}
                  onChange={(e) => setFormData({ ...formData, depot_id: e.target.value })}
                  required
                >
                  <option value="">Depo Seçiniz</option>
                  {depots.map((depot) => (
                    <option key={depot.id} value={depot.id}>
                      {depot.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>Hazır Adet</label>
                <input
                  type="number"
                  min="0"
                  value={formData.hazir_adet}
                  onChange={(e) => setFormData({ ...formData, hazir_adet: e.target.value })}
                />
              </div>
              <div className="form-group">
                <label>Tamir Bekleyen</label>
                <input
                  type="number"
                  min="0"
                  value={formData.tamir_bekleyen}
                  onChange={(e) => setFormData({ ...formData, tamir_bekleyen: e.target.value })}
                />
              </div>
              <div className="form-group">
                <label>Revize Adet</label>
                <input
                  type="number"
                  min="0"
                  value={formData.revize_adet}
                  onChange={(e) => setFormData({ ...formData, revize_adet: e.target.value })}
                  disabled={!editingPosm}
                  title={!editingPosm ? "Revize adet sadece düzenleme sırasında değiştirilebilir" : ""}
                />
                {!editingPosm && (
                  <small style={{ color: '#666', fontSize: '12px', display: 'block', marginTop: '4px' }}>
                    Revize adet otomatik olarak yönetilir (talep oluşturulduğunda artar, tamamlandığında azalır)
                  </small>
                )}
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingPosm ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="posm-table-container">
        <table className="posm-table">
          <thead>
            <tr>
              <th>POSM Adı</th>
              <th>Açıklama</th>
              <th>Depo</th>
              <th>Hazır Adet</th>
              <th>Revize Adet</th>
              <th>Tamir Bekleyen</th>
              <th>Durum</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {posms.length === 0 ? (
              <tr>
                <td colSpan={8} className="no-data">
                  Henüz POSM bulunmuyor
                </td>
              </tr>
            ) : (
              posms.map((posm) => (
                <tr key={posm.id}>
                  <td>{posm.name}</td>
                  <td>{posm.description || '-'}</td>
                  <td>{posm.depot_name || '-'}</td>
                  <td>{posm.hazir_adet || 0}</td>
                  <td style={{ color: posm.revize_adet > 0 ? '#e67e22' : '#333', fontWeight: posm.revize_adet > 0 ? '600' : 'normal' }}>
                    {posm.revize_adet || 0}
                  </td>
                  <td>{posm.tamir_bekleyen || 0}</td>
                  <td>
                    <span className={posm.is_active ? 'status-active' : 'status-inactive'}>
                      {posm.is_active ? 'Aktif' : 'Pasif'}
                    </span>
                  </td>
                  <td>
                    <button
                      className="edit-button"
                      onClick={() => handleEdit(posm)}
                    >
                      Düzenle
                    </button>
                    <button
                      className="delete-button"
                      onClick={() => handleDelete(posm.id)}
                    >
                      Sil
                    </button>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {showBulkResult && bulkResult && (
        <div className="form-modal" style={{ zIndex: 10000 }}>
          <div className="form-content" style={{ maxWidth: '800px', maxHeight: '80vh', overflow: 'auto' }}>
            <h3>Toplu POSM Ekleme Sonuçları</h3>
            
            <div style={{ marginBottom: '20px' }}>
              <h4 style={{ marginBottom: '10px' }}>Özet</h4>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px', marginBottom: '20px' }}>
                <div>
                  <strong>Toplam Eklenen:</strong> {bulkResult.total_inserted || 0}
                </div>
                <div>
                  <strong>Toplam Atlanan:</strong> {bulkResult.total_skipped || 0}
                </div>
                <div>
                  <strong>Toplam Hata:</strong> {bulkResult.total_errors || 0}
                </div>
                <div>
                  <strong>Toplam Depo:</strong> {bulkResult.total_depots || 0}
                </div>
              </div>
            </div>

            {bulkResult.depot_results && bulkResult.depot_results.length > 0 && (
              <div style={{ marginBottom: '20px' }}>
                <h4 style={{ marginBottom: '10px' }}>Depo Bazında Sonuçlar</h4>
                <div style={{ maxHeight: '200px', overflow: 'auto', border: '1px solid #ddd', padding: '10px', borderRadius: '4px' }}>
                  {bulkResult.depot_results.map((depot: any, idx: number) => (
                    <div key={idx} style={{ marginBottom: '10px', paddingBottom: '10px', borderBottom: idx < bulkResult.depot_results.length - 1 ? '1px solid #eee' : 'none' }}>
                      <strong>{depot.depot_name}:</strong>
                      <div style={{ marginLeft: '20px', marginTop: '5px' }}>
                        <div>✓ Eklenen: {depot.inserted}</div>
                        <div>⊘ Atlanan: {depot.skipped}</div>
                        {depot.errors > 0 && (
                          <div style={{ color: '#e74c3c' }}>✗ Hatalar: {depot.errors}</div>
                        )}
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {bulkResult.errors && bulkResult.errors.length > 0 && (
              <div style={{ marginBottom: '20px' }}>
                <h4 style={{ marginBottom: '10px', color: '#e74c3c' }}>Hata Detayları</h4>
                <div style={{ maxHeight: '300px', overflow: 'auto', border: '1px solid #ddd', padding: '10px', borderRadius: '4px', backgroundColor: '#fff5f5' }}>
                  {bulkResult.errors.slice(0, 50).map((error: string, idx: number) => (
                    <div key={idx} style={{ marginBottom: '8px', padding: '8px', backgroundColor: '#fff', borderRadius: '4px', fontSize: '12px', fontFamily: 'monospace' }}>
                      {error}
                    </div>
                  ))}
                  {bulkResult.errors.length > 50 && (
                    <div style={{ marginTop: '10px', color: '#999', fontSize: '12px' }}>
                      ... ve {bulkResult.errors.length - 50} hata daha (backend log'larına bakın)
                    </div>
                  )}
                </div>
              </div>
            )}

            <div className="form-actions">
              <button 
                type="button" 
                className="submit-button" 
                onClick={() => {
                  setShowBulkResult(false);
                  setBulkResult(null);
                }}
              >
                Kapat
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
    </div>
  );
};

export default POSMManagementPage;
