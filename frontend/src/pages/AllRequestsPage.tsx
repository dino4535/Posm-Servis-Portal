import { useState, useEffect } from 'react';
import api from '../services/api';
import { formatDate } from '../utils/helpers';
import SearchFilters from '../components/SearchFilters';
import RequestDetailModal from '../components/RequestDetailModal';
import '../styles/AllRequestsPage.css';

const AllRequestsPage = () => {
  const [requests, setRequests] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState<any>({});
  const [selectedRequest, setSelectedRequest] = useState<any>(null);
  const [showModal, setShowModal] = useState(false);

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
              <th>Kullanıcı</th>
              <th>POSM</th>
              <th>İstenen Tarih</th>
              <th>Planlanan Tarih</th>
              <th>Yapılacak İş</th>
              <th>Durum</th>
            </tr>
          </thead>
          <tbody>
            {requests.length === 0 ? (
              <tr>
                <td colSpan={6} className="no-data">
                  Henüz talep bulunmuyor
                </td>
              </tr>
            ) : (
              requests.map((request) => (
                <tr key={request.id}>
                  <td>{request.request_no}</td>
                  <td>{request.user_id}</td>
                  <td>{request.posm_name || (request.posm_id ? `POSM ID: ${request.posm_id}` : '-')}</td>
                  <td>{formatDate(request.istenen_tarih)}</td>
                  <td>{request.planlanan_tarih ? formatDate(request.planlanan_tarih) : '-'}</td>
                  <td>{request.yapilacak_is}</td>
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
          onClose={() => {
            setShowModal(false);
            setSelectedRequest(null);
          }}
          onUpdate={fetchRequests}
        />
      )}
    </div>
  );
};

export default AllRequestsPage;
