import { useState, useEffect } from 'react';
import api from '../services/api';
import { formatDate } from '../utils/helpers';
import SearchFilters from '../components/SearchFilters';
import RequestDetailModal from '../components/RequestDetailModal';
import ConfirmModal from '../components/ConfirmModal';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import { REQUEST_STATUS } from '../utils/constants';
import '../styles/AllRequestsPage.css';

interface Request {
  id: number;
  request_no: string;
  dealer_id: number;
  bayi_adi?: string;
  bayi_kodu?: string;
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
  user_name?: string;
}

const AllRequestsPage = () => {
  const { isAdmin } = useAuth();
  const { showSuccess, showError } = useToast();
  const [requests, setRequests] = useState<Request[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState<any>({});
  const [selectedRequest, setSelectedRequest] = useState<Request | null>(null);
  const [showModal, setShowModal] = useState(false);
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

  const fetchRequests = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filters.durum) params.append('durum', filters.durum);
      if (filters.yapilacak_is) params.append('yapilacak_is', filters.yapilacak_is);
      if (filters.start_date) params.append('start_date', filters.start_date);
      if (filters.end_date) params.append('end_date', filters.end_date);
      if (filters.depot_id) params.append('depot_id', filters.depot_id);

      const response = await api.get(`/requests?${params.toString()}`);
      if (response.data.success) {
        let filteredRequests = response.data.data;
        
        // Client-side search
        if (filters.search) {
          const searchLower = filters.search.toLowerCase();
          filteredRequests = filteredRequests.filter((req: any) =>
            req.request_no?.toLowerCase().includes(searchLower) ||
            req.bayi_adi?.toLowerCase().includes(searchLower)
          );
        }
        
        setRequests(filteredRequests);
      }
    } catch (error) {
      console.error('Talepler yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchRequests();
  }, [filters]);

  const handleRequestClick = (request: Request) => {
    setSelectedRequest(request);
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setSelectedRequest(null);
  };

  const handleCancel = async (requestId: number, e: React.MouseEvent) => {
    e.stopPropagation();
    setConfirmModal({
      isOpen: true,
      message: 'Bu talebi iptal etmek istediğinize emin misiniz?',
      type: 'warning',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          const response = await api.put(`/requests/${requestId}/cancel`);
          if (response.data.success) {
            showSuccess('Talep başarıyla iptal edildi');
            fetchRequests();
          }
        } catch (error: any) {
          showError(error.response?.data?.error || 'İptal sırasında hata oluştu');
        }
      },
    });
  };

  const handleDelete = async (requestId: number, e: React.MouseEvent) => {
    e.stopPropagation();
    setConfirmModal({
      isOpen: true,
      message: 'Bu talebi silmek istediğinize emin misiniz? Bu işlem geri alınamaz!',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          const response = await api.delete(`/requests/${requestId}`);
          if (response.data.success) {
            showSuccess('Talep başarıyla silindi');
            fetchRequests();
          }
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme sırasında hata oluştu');
        }
      },
    });
  };

  if (loading) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="all-requests-page">
      <h2>Tüm Talepler</h2>
      <SearchFilters
        onFilterChange={setFilters}
        showDepotFilter={true}
        showUserFilter={true}
      />
      <div className="requests-table-container">
        <table className="requests-table">
          <thead>
            <tr>
              <th>Talep No</th>
              <th>Açan Kullanıcı</th>
              <th>Bayi Adı</th>
              <th>Bayi Kodu</th>
              <th>Depo</th>
              <th>Territory</th>
              <th>POSM</th>
              <th>İstenen Tarih</th>
              <th>Planlanan Tarih</th>
              <th>Yapılacak İş</th>
              <th>Yapılacak İşler Detayı</th>
              <th>Durum</th>
            </tr>
          </thead>
          <tbody>
            {requests.length === 0 ? (
              <tr>
                <td colSpan={12} className="no-data">
                  Henüz talep bulunmuyor
                </td>
              </tr>
            ) : (
              requests.map((request) => (
                <tr key={request.id} onClick={() => handleRequestClick(request)}>
                  <td>{request.request_no}</td>
                  <td>{request.user_name || '-'}</td>
                  <td>{request.bayi_adi || '-'}</td>
                  <td>{request.bayi_kodu || '-'}</td>
                  <td>{request.depot_name || '-'}</td>
                  <td>{request.territory_name || request.territory_code || '-'}</td>
                  <td>{request.posm_name || (request.posm_id ? `POSM ID: ${request.posm_id}` : '-')}</td>
                  <td>{request.istenen_tarih ? formatDate(request.istenen_tarih) : '-'}</td>
                  <td>{request.planlanan_tarih ? formatDate(request.planlanan_tarih) : '-'}</td>
                  <td>{request.yapilacak_is}</td>
                  <td>{request.yapilacak_is_detay || '-'}</td>
                  <td>
                    <span className={`status-badge status-${request.durum.toLowerCase()}`}>
                      {request.durum}
                    </span>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {showModal && selectedRequest && (
        <RequestDetailModal
          request={selectedRequest}
          onClose={handleCloseModal}
          onUpdate={fetchRequests}
        />
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

export default AllRequestsPage;
