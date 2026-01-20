import { useState, useEffect } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import '../styles/TerritoryManagementPage.css';

const TerritoryManagementPage = () => {
  const { user, isAdmin } = useAuth();
  const { showError } = useToast();
  const [territories, setTerritories] = useState<any[]>([]);
  const [depots, setDepots] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingTerritory, setEditingTerritory] = useState<any>(null);
  const [formData, setFormData] = useState({
    name: '',
    code: '',
    depot_id: '',
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
    fetchTerritories();
    fetchDepots();
  }, []);

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

  const fetchTerritories = async () => {
    setLoading(true);
    try {
      const response = await api.get('/territories');
      if (response.data.success) {
        setTerritories(response.data.data);
      }
    } catch (error) {
      console.error('Territories yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingTerritory) {
        await api.put(`/territories/${editingTerritory.id}`, formData);
      } else {
        await api.post('/territories', formData);
      }
      fetchTerritories();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (territory: any) => {
    setEditingTerritory(territory);
    setFormData({
      name: territory.name,
      code: territory.code || '',
      depot_id: territory.depot_id.toString(),
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu territory\'yi silmek istediğinize emin misiniz?',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/territories/${id}`);
          fetchTerritories();
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const resetForm = () => {
    setFormData({ name: '', code: '', depot_id: '' });
    setEditingTerritory(null);
    setShowForm(false);
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="territory-management-page">
      <div className="page-header">
        <h2>Territory Yönetimi</h2>
        <button className="add-button" onClick={() => setShowForm(true)}>
          + Yeni Territory
        </button>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingTerritory ? 'Territory Düzenle' : 'Yeni Territory'}</h3>
            <form onSubmit={handleSubmit}>
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
                <label>Territory Adı *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Territory Kodu</label>
                <input
                  type="text"
                  value={formData.code}
                  onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                />
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingTerritory ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="territories-table-container">
        <table className="territories-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Ad</th>
              <th>Kod</th>
              <th>Depo</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {territories.length === 0 ? (
              <tr>
                <td colSpan={5} className="no-data">
                  Henüz territory bulunmuyor
                </td>
              </tr>
            ) : (
              territories.map((territory) => (
                <tr key={territory.id}>
                  <td>{territory.id}</td>
                  <td>{territory.name}</td>
                  <td>{territory.code || '-'}</td>
                  <td>{territory.depot_name || '-'}</td>
                  <td>
                    <button
                      className="edit-button"
                      onClick={() => handleEdit(territory)}
                    >
                      Düzenle
                    </button>
                    <button
                      className="delete-button"
                      onClick={() => handleDelete(territory.id)}
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

export default TerritoryManagementPage;
