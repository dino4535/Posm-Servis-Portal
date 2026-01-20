import { useState, useEffect } from 'react';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import '../styles/DealerManagementPage.css';

const DealerManagementPage = () => {
  const { user, isAdmin } = useAuth();
  const { showError } = useToast();
  const [dealers, setDealers] = useState<any[]>([]);
  const [territories, setTerritories] = useState<any[]>([]);
  const [depots, setDepots] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingDealer, setEditingDealer] = useState<any>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTerritory, setSelectedTerritory] = useState('');
  const [selectedDepot, setSelectedDepot] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
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
  const [totalDealers, setTotalDealers] = useState(0);
  const [pageSize] = useState(50); // 50'li sayfalama
  const [formData, setFormData] = useState({
    code: '',
    name: '',
    territory_id: '',
    address: '',
    phone: '',
    latitude: '',
    longitude: '',
  });

  useEffect(() => {
    const initialLoad = async () => {
      try {
        // Depoları yükle
        const depotsResponse = await api.get('/depots');
        if (depotsResponse.data.success) {
          setDepots(depotsResponse.data.data);
        }
        
        // Territory'leri yükle
        const territoriesResponse = await api.get('/territories');
        if (territoriesResponse.data.success) {
          setTerritories(territoriesResponse.data.data);
        }
        
        // Bayileri yükle
        const dealersResponse = await api.get('/dealers');
        if (dealersResponse.data.success) {
          setDealers(dealersResponse.data.data);
        }
      } catch (error) {
        console.error('İlk yükleme hatası:', error);
      } finally {
        setLoading(false);
      }
    };
    
    initialLoad();
  }, []);

  const fetchDealers = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (selectedTerritory) {
        params.append('territory_id', selectedTerritory);
      }
      if (selectedDepot) {
        params.append('depot_id', selectedDepot);
      }
      const queryString = params.toString();
      const response = await api.get(`/dealers${queryString ? `?${queryString}` : ''}`);
      if (response.data.success) {
        setDealers(response.data.data);
      }
    } catch (error) {
      console.error('Dealers yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  // Depo değiştiğinde territory listesini güncelle
  useEffect(() => {
    const loadTerritories = async () => {
      try {
        const params = selectedDepot ? `?depot_id=${selectedDepot}` : '';
        const response = await api.get(`/territories${params}`);
        if (response.data.success) {
          setTerritories(response.data.data);
          // Territory'yi sıfırla çünkü depo değişti (sadece depo seçildiğinde)
          if (selectedDepot) {
            setSelectedTerritory('');
          }
        }
      } catch (error) {
        console.error('Territories yüklenirken hata:', error);
      }
    };
    
    loadTerritories();
  }, [selectedDepot]);

  // Filtreler veya arama terimi değiştiğinde listeyi güncelle
  useEffect(() => {
    // Sayfa değiştiğinde veya filtre değiştiğinde ilk sayfaya dön
    setCurrentPage(1);
  }, [searchTerm, selectedTerritory, selectedDepot]);

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        if (searchTerm.length >= 2) {
          // Arama yap
          const params = new URLSearchParams();
          params.append('q', searchTerm);
          params.append('page', currentPage.toString());
          params.append('limit', pageSize.toString());
          if (selectedTerritory) {
            params.append('territory_id', selectedTerritory);
          }
          if (selectedDepot) {
            params.append('depot_id', selectedDepot);
          }
          const response = await api.get(`/dealers/search?${params.toString()}`);
          if (response.data.success) {
            setDealers(response.data.data);
            if (response.data.pagination) {
              setTotalPages(response.data.pagination.totalPages);
              setTotalDealers(response.data.pagination.total);
            }
          }
        } else {
          // Normal liste getir
          const params = new URLSearchParams();
          params.append('page', currentPage.toString());
          params.append('limit', pageSize.toString());
          if (selectedTerritory) {
            params.append('territory_id', selectedTerritory);
          }
          if (selectedDepot) {
            params.append('depot_id', selectedDepot);
          }
          const response = await api.get(`/dealers?${params.toString()}`);
          if (response.data.success) {
            setDealers(response.data.data);
            if (response.data.pagination) {
              setTotalPages(response.data.pagination.totalPages);
              setTotalDealers(response.data.pagination.total);
            }
          }
        }
      } catch (error) {
        console.error('Dealers yüklenirken hata:', error);
      } finally {
        setLoading(false);
      }
    };

    const timeoutId = setTimeout(loadData, searchTerm.length >= 2 ? 300 : 0);
    return () => clearTimeout(timeoutId);
  }, [searchTerm, selectedTerritory, selectedDepot, currentPage, pageSize]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      const submitData: any = {
        code: formData.code,
        name: formData.name,
        territory_id: formData.territory_id ? parseInt(formData.territory_id, 10) : undefined,
        address: formData.address || undefined,
        phone: formData.phone || undefined,
      };
      
      // Latitude ve longitude'u sayıya çevir
      if (formData.latitude) {
        submitData.latitude = parseFloat(formData.latitude);
      }
      if (formData.longitude) {
        submitData.longitude = parseFloat(formData.longitude);
      }
      
      if (editingDealer) {
        await api.put(`/dealers/${editingDealer.id}`, submitData);
      } else {
        await api.post('/dealers', submitData);
      }
      fetchDealers();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (dealer: any) => {
    setEditingDealer(dealer);
    setFormData({
      code: dealer.code,
      name: dealer.name,
      territory_id: dealer.territory_id?.toString() || '',
      address: dealer.address || '',
      phone: dealer.phone || '',
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu bayi kaydını silmek istediğinize emin misiniz?',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/dealers/${id}`);
          fetchDealers();
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const resetForm = () => {
    setFormData({ code: '', name: '', territory_id: '', address: '', phone: '', latitude: '', longitude: '' });
    setEditingDealer(null);
    setShowForm(false);
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  return (
    <div className="dealer-management-page">
      <div className="page-header">
        <h2>Bayi Yönetimi</h2>
        <button className="add-button" onClick={() => setShowForm(true)}>
          + Yeni Bayi
        </button>
      </div>

      <div className="filters-section">
        <div className="filter-group">
          <input
            type="text"
            placeholder="Bayi kodu veya adı ile ara..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="search-input"
          />
        </div>
        <div className="filter-group">
          <select
            value={selectedDepot}
            onChange={(e) => {
              setSelectedDepot(e.target.value);
            }}
            className="filter-select"
          >
            <option value="">Tüm Depolar</option>
            {depots.map((depot) => (
              <option key={depot.id} value={depot.id}>
                {depot.name}
              </option>
            ))}
          </select>
        </div>
        <div className="filter-group">
          <select
            value={selectedTerritory}
            onChange={(e) => {
              setSelectedTerritory(e.target.value);
            }}
            className="filter-select"
            disabled={!selectedDepot}
          >
            <option value="">Tüm Territory'ler</option>
            {territories.map((territory) => (
              <option key={territory.id} value={territory.id}>
                {territory.name}
              </option>
            ))}
          </select>
        </div>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingDealer ? 'Bayi Düzenle' : 'Yeni Bayi'}</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Territory *</label>
                <select
                  value={formData.territory_id}
                  onChange={(e) => setFormData({ ...formData, territory_id: e.target.value })}
                  required
                >
                  <option value="">Territory Seçiniz</option>
                  {territories.map((territory) => (
                    <option key={territory.id} value={territory.id}>
                      {territory.name}
                    </option>
                  ))}
                </select>
              </div>
              <div className="form-group">
                <label>Bayi Kodu *</label>
                <input
                  type="text"
                  value={formData.code}
                  onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                  required
                />
              </div>
              <div className="form-group">
                <label>Bayi Adı *</label>
                <input
                  type="text"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  required
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
              <div className="form-group">
                <label>Telefon</label>
                <input
                  type="text"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                />
              </div>
              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingDealer ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="dealers-table-container">
        <table className="dealers-table">
          <thead>
            <tr>
              <th>Bayi Kodu</th>
              <th>Bayi Adı</th>
              <th>Depo</th>
              <th>Territory Kodu</th>
              <th>Territory Adı</th>
              <th>Adres</th>
              <th>Telefon</th>
              <th>Enlem</th>
              <th>Boylam</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {loading ? (
              <tr>
                <td colSpan={10} className="loading">Yükleniyor...</td>
              </tr>
            ) : dealers.length === 0 ? (
              <tr>
                <td colSpan={10} className="no-data">
                  Henüz bayi bulunmuyor
                </td>
              </tr>
            ) : (
              dealers.map((dealer) => {
                // Artık latitude ve longitude ayrı kolonlarda
                const latitude = dealer.latitude;
                const longitude = dealer.longitude;
                let displayAddress = dealer.address || '-';
                
                // Eğer address hala JSON formatındaysa parse et (eski veriler için)
                if (dealer.address && dealer.address.startsWith('{')) {
                  try {
                    const parsed = JSON.parse(dealer.address);
                    if (parsed.address) {
                      displayAddress = parsed.address;
                    }
                  } catch {
                    // JSON değilse olduğu gibi göster
                  }
                }

                return (
                  <tr key={dealer.id}>
                    <td>{dealer.code}</td>
                    <td>{dealer.name}</td>
                    <td>{dealer.depot_name || '-'}</td>
                    <td>{dealer.territory_code || '-'}</td>
                    <td>{dealer.territory_name || '-'}</td>
                    <td title={displayAddress !== '-' ? displayAddress : ''}>{displayAddress}</td>
                    <td>{dealer.phone || '-'}</td>
                    <td>{latitude !== null ? Number(latitude).toFixed(6) : '-'}</td>
                    <td>{longitude !== null ? Number(longitude).toFixed(6) : '-'}</td>
                    <td>
                      <button
                        className="edit-button"
                        onClick={() => handleEdit(dealer)}
                      >
                        Düzenle
                      </button>
                      <button
                        className="delete-button"
                        onClick={() => handleDelete(dealer.id)}
                      >
                        Sil
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="pagination">
          <div className="pagination-info">
            Toplam {totalDealers} bayi - Sayfa {currentPage} / {totalPages}
          </div>
          <div className="pagination-controls">
            <button
              className="pagination-button"
              onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
              disabled={currentPage === 1 || loading}
            >
              Önceki
            </button>
            {Array.from({ length: Math.min(5, totalPages) }, (_, i) => {
              let pageNum;
              if (totalPages <= 5) {
                pageNum = i + 1;
              } else if (currentPage <= 3) {
                pageNum = i + 1;
              } else if (currentPage >= totalPages - 2) {
                pageNum = totalPages - 4 + i;
              } else {
                pageNum = currentPage - 2 + i;
              }
              return (
                <button
                  key={pageNum}
                  className={`pagination-button ${currentPage === pageNum ? 'active' : ''}`}
                  onClick={() => setCurrentPage(pageNum)}
                  disabled={loading}
                >
                  {pageNum}
                </button>
              );
            })}
            <button
              className="pagination-button"
              onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
              disabled={currentPage === totalPages || loading}
            >
              Sonraki
            </button>
          </div>
        </div>
      )}
    </div>
  );
};

export default DealerManagementPage;
