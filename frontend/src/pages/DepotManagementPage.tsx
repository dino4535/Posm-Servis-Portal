import { useState, useEffect } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import '../styles/DepotManagementPage.css';

const DepotManagementPage = () => {
  const { isAdmin } = useAuth();
  const [depots, setDepots] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingDepot, setEditingDepot] = useState<any>(null);
  const [formData, setFormData] = useState({
    name: '',
    code: '',
    address: '',
  });
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

  useEffect(() => {
    fetchDepots();
  }, []);

  const fetchDepots = async () => {
    setLoading(true);
    try {
      const response = await api.get('/depots');
      if (response.data.success) {
        setDepots(response.data.data);
      }
    } catch (error) {
      console.error('Depolar yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingDepot) {
        await api.put(`/depots/${editingDepot.id}`, formData);
        showSuccess('Depo başarıyla güncellendi');
      } else {
        await api.post('/depots', formData);
        showSuccess('Depo başarıyla oluşturuldu');
      }
      fetchDepots();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (depot: any) => {
    setEditingDepot(depot);
    setFormData({
      name: depot.name,
      code: depot.code,
      address: depot.address || '',
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu depoyu silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/depots/${id}`);
          showSuccess('Depo başarıyla silindi');
          fetchDepots();
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const resetForm = () => {
    setFormData({ name: '', code: '', address: '' });
    setEditingDepot(null);
    setShowForm(false);
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading && depots.length === 0) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="depot-management-page">
      <div className="page-header">
        <h2>Depo Yönetimi</h2>
        <button className="add-button" onClick={() => setShowForm(true)}>
          + Yeni Depo
        </button>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingDepot ? 'Depo Düzenle' : 'Yeni Depo'}</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Depo Adı *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Depo Kodu *</label>
                <input
                  type="text"
                  value={formData.code}
                  onChange={(e) => setFormData({ ...formData, code: e.target.value.toUpperCase() })}
                  required
                  placeholder="Örn: DEPO1"
                />
              </div>
              <div className="form-group">
                <label>Adres</label>
                <textarea
                  value={formData.address}
                  onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                  rows={3}
                />
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingDepot ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="depots-table-container">
        <table className="depots-table">
          <thead>
            <tr>
              <th>Depo Adı</th>
              <th>Kod</th>
              <th>Adres</th>
              <th>Durum</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {depots.length === 0 ? (
              <tr>
                <td colSpan={5} className="no-data">
                  Henüz depo bulunmuyor
                </td>
              </tr>
            ) : (
              depots.map((depot) => (
                <tr key={depot.id}>
                  <td>{depot.name}</td>
                  <td>{depot.code}</td>
                  <td>{depot.address || '-'}</td>
                  <td>
                    <span className={depot.is_active ? 'status-active' : 'status-inactive'}>
                      {depot.is_active ? 'Aktif' : 'Pasif'}
                    </span>
                  </td>
                  <td>
                    <button
                      className="edit-button"
                      onClick={() => handleEdit(depot)}
                    >
                      Düzenle
                    </button>
                    <button
                      className="delete-button"
                      onClick={() => handleDelete(depot.id)}
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

export default DepotManagementPage;
