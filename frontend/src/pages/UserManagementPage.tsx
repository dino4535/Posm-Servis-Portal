import { useState, useEffect } from 'react';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import { ROLES } from '../utils/constants';
import '../styles/UserManagementPage.css';

const UserManagementPage = () => {
  const { showSuccess, showError } = useToast();
  const [users, setUsers] = useState<any[]>([]);
  const [depots, setDepots] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingUser, setEditingUser] = useState<any>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    role: 'User',
    depot_ids: [] as number[],
  });
  const [confirmModal, setConfirmModal] = useState({
    isOpen: false,
    message: '',
    type: 'danger' as 'danger' | 'warning' | 'info',
    onConfirm: () => {},
  });

  useEffect(() => {
    fetchUsers();
    fetchDepots();
  }, []);

  const fetchUsers = async () => {
    setLoading(true);
    try {
      const response = await api.get('/users');
      if (response.data.success) {
        setUsers(response.data.data);
      }
    } catch (error) {
      console.error('Kullanıcılar yüklenirken hata:', error);
    } finally {
      setLoading(false);
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

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingUser) {
        const updateData: any = {
          name: formData.name,
          email: formData.email,
          role: formData.role,
          depot_ids: formData.depot_ids, // Depo ID'lerini de gönder
        };
        if (formData.password) {
          updateData.password = formData.password;
        }
        await api.put(`/users/${editingUser.id}`, updateData);
      } else {
        await api.post('/users', formData);
      }
      fetchUsers();
      resetForm();
      showSuccess(editingUser ? 'Kullanıcı güncellendi' : 'Kullanıcı oluşturuldu');
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (user: any) => {
    setEditingUser(user);
    setFormData({
      name: user.name,
      email: user.email,
      password: '',
      role: user.role,
      depot_ids: user.depot_ids || [],
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu kullanıcıyı silmek istediğinize emin misiniz?',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/users/${id}`);
          fetchUsers();
          showSuccess('Kullanıcı silindi');
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const handleDepotToggle = (depotId: number) => {
    setFormData((prev) => ({
      ...prev,
      depot_ids: prev.depot_ids.includes(depotId)
        ? prev.depot_ids.filter((id) => id !== depotId)
        : [...prev.depot_ids, depotId],
    }));
  };

  const resetForm = () => {
    setFormData({
      name: '',
      email: '',
      password: '',
      role: 'User',
      depot_ids: [],
    });
    setEditingUser(null);
    setShowForm(false);
  };

  if (loading && users.length === 0) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="user-management-page">
      <div className="page-header">
        <h2>Kullanıcı Yönetimi</h2>
        <button className="add-button" onClick={() => setShowForm(true)}>
          + Yeni Kullanıcı
        </button>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingUser ? 'Kullanıcı Düzenle' : 'Yeni Kullanıcı'}</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Ad Soyad *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>E-posta *</label>
                <input
                  type="email"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  required
                  disabled={!!editingUser}
                />
              </div>
              <div className="form-group">
                <label>Şifre {!editingUser && '*'}</label>
                <input
                  type="password"
                  value={formData.password}
                  onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  required={!editingUser}
                  placeholder={editingUser ? 'Değiştirmek için yeni şifre girin' : ''}
                />
              </div>
              <div className="form-group">
                <label>Rol *</label>
                <select
                  value={formData.role}
                  onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                  required
                >
                  {Object.values(ROLES).map((role) => (
                    <option key={role} value={role}>
                      {role}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>Depolar</label>
                <div className="depot-checkboxes">
                  {depots.map((depot) => (
                    <label key={depot.id} className="checkbox-label">
                      <input
                        type="checkbox"
                        checked={formData.depot_ids.includes(depot.id)}
                        onChange={() => handleDepotToggle(depot.id)}
                      />
                      <span>{depot.name}</span>
                    </label>
                  ))}
                </div>
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingUser ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="users-table-container">
        <table className="users-table">
          <thead>
            <tr>
              <th>Ad</th>
              <th>E-posta</th>
              <th>Rol</th>
              <th>Depolar</th>
              <th>Durum</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {users.length === 0 ? (
              <tr>
                <td colSpan={6} className="no-data">
                  Henüz kullanıcı bulunmuyor
                </td>
              </tr>
            ) : (
              users.map((user) => (
                <tr key={user.id}>
                  <td>{user.name}</td>
                  <td>{user.email}</td>
                  <td>{user.role}</td>
                  <td>
                    {user.depot_names && user.depot_names.length > 0
                      ? user.depot_names.join(', ')
                      : '-'}
                  </td>
                  <td>
                    <span className={user.is_active ? 'status-active' : 'status-inactive'}>
                      {user.is_active ? 'Aktif' : 'Pasif'}
                    </span>
                  </td>
                  <td>
                    <button className="edit-button" onClick={() => handleEdit(user)}>
                      Düzenle
                    </button>
                    <button className="delete-button" onClick={() => handleDelete(user.id)}>
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

export default UserManagementPage;
