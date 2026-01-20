import { useState, useEffect } from 'react';
import api from '../services/api';
import { formatDate } from '../utils/helpers';
import '../styles/AuditLogPage.css';

interface AuditLog {
  id: number;
  user_id?: number;
  user_name?: string;
  action: string;
  entity_type?: string;
  entity_id?: number;
  old_values?: string;
  new_values?: string;
  ip_address?: string;
  user_agent?: string;
  created_at: string;
}

const AuditLogPage = () => {
  const [logs, setLogs] = useState<AuditLog[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);
  const [filters, setFilters] = useState({
    user_id: '',
    entity_type: '',
    start_date: '',
    end_date: '',
  });
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize] = useState(50);
  const [expandedLog, setExpandedLog] = useState<number | null>(null);
  const [users, setUsers] = useState<any[]>([]);

  useEffect(() => {
    fetchUsers();
  }, []);

  useEffect(() => {
    fetchLogs();
  }, [filters, currentPage]);

  const fetchUsers = async () => {
    try {
      const response = await api.get('/users');
      if (response.data.success) {
        setUsers(response.data.data);
      }
    } catch (error) {
      console.error('Kullanıcılar yüklenirken hata:', error);
    }
  };

  const fetchLogs = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filters.user_id) params.append('user_id', filters.user_id);
      if (filters.entity_type) params.append('entity_type', filters.entity_type);
      if (filters.start_date) params.append('start_date', filters.start_date);
      if (filters.end_date) params.append('end_date', filters.end_date);
      params.append('limit', pageSize.toString());
      params.append('offset', ((currentPage - 1) * pageSize).toString());

      const response = await api.get(`/audit?${params.toString()}`);
      if (response.data.success) {
        setLogs(response.data.data);
        setTotal(response.data.total);
      }
    } catch (error) {
      console.error('Audit loglar yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (key: string, value: string) => {
    setFilters({ ...filters, [key]: value });
    setCurrentPage(1);
  };

  const clearFilters = () => {
    setFilters({
      user_id: '',
      entity_type: '',
      start_date: '',
      end_date: '',
    });
    setCurrentPage(1);
  };

  const getActionColor = (action: string) => {
    switch (action) {
      case 'CREATE':
        return 'action-create';
      case 'UPDATE':
        return 'action-update';
      case 'DELETE':
        return 'action-delete';
      case 'LOGIN':
        return 'action-login';
      case 'LOGOUT':
        return 'action-logout';
      default:
        return '';
    }
  };

  const parseJson = (jsonString?: string) => {
    if (!jsonString) return null;
    try {
      return JSON.parse(jsonString);
    } catch {
      return null;
    }
  };

  const totalPages = Math.ceil(total / pageSize);

  if (loading && logs.length === 0) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="audit-log-page">
      <div className="page-header">
        <h2>Audit Log (Denetim Kayıtları)</h2>
        <p className="page-description">
          Sistemdeki tüm işlemlerin kayıtları burada görüntülenir
        </p>
      </div>

      <div className="filters-section">
        <div className="filters-grid">
          <div className="filter-group">
            <label>Kullanıcı</label>
            <select
              value={filters.user_id}
              onChange={(e) => handleFilterChange('user_id', e.target.value)}
            >
              <option value="">Tümü</option>
              {users.map((user) => (
                <option key={user.id} value={user.id}>
                  {user.name} ({user.role})
                </option>
              ))}
            </select>
          </div>
          <div className="filter-group">
            <label>Entity Tipi</label>
            <select
              value={filters.entity_type}
              onChange={(e) => handleFilterChange('entity_type', e.target.value)}
            >
              <option value="">Tümü</option>
              <option value="User">User</option>
              <option value="Request">Request</option>
              <option value="POSM">POSM</option>
              <option value="Dealer">Dealer</option>
              <option value="Territory">Territory</option>
              <option value="Depot">Depot</option>
            </select>
          </div>
          <div className="filter-group">
            <label>Başlangıç Tarihi</label>
            <input
              type="date"
              value={filters.start_date}
              onChange={(e) => handleFilterChange('start_date', e.target.value)}
            />
          </div>
          <div className="filter-group">
            <label>Bitiş Tarihi</label>
            <input
              type="date"
              value={filters.end_date}
              onChange={(e) => handleFilterChange('end_date', e.target.value)}
            />
          </div>
        </div>
        <button className="clear-filters-button" onClick={clearFilters}>
          Filtreleri Temizle
        </button>
      </div>

      <div className="logs-summary">
        <span>Toplam {total} kayıt bulundu</span>
      </div>

      <div className="logs-table-container">
        <table className="logs-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>Tarih/Saat</th>
              <th>Kullanıcı</th>
              <th>Aksiyon</th>
              <th>Entity</th>
              <th>IP Adresi</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {logs.length === 0 ? (
              <tr>
                <td colSpan={7} className="no-data">
                  Kayıt bulunamadı
                </td>
              </tr>
            ) : (
              logs.map((log) => (
                <>
                  <tr key={log.id} className="log-row">
                    <td>{log.id}</td>
                    <td>{formatDate(log.created_at)}</td>
                    <td>{log.user_name || `ID: ${log.user_id || '-'}`}</td>
                    <td>
                      <span className={`action-badge ${getActionColor(log.action)}`}>
                        {log.action}
                      </span>
                    </td>
                    <td>
                      {log.entity_type && log.entity_id
                        ? `${log.entity_type} #${log.entity_id}`
                        : '-'}
                    </td>
                    <td>{log.ip_address || '-'}</td>
                    <td>
                      <button
                        className="detail-button"
                        onClick={() =>
                          setExpandedLog(expandedLog === log.id ? null : log.id)
                        }
                      >
                        {expandedLog === log.id ? 'Gizle' : 'Detay'}
                      </button>
                    </td>
                  </tr>
                  {expandedLog === log.id && (
                    <tr className="log-detail-row">
                      <td colSpan={7}>
                        <div className="log-detail-content">
                          <div className="detail-section">
                            <h4>Eski Değerler</h4>
                            <pre>
                              {log.old_values
                                ? JSON.stringify(parseJson(log.old_values), null, 2)
                                : '-'}
                            </pre>
                          </div>
                          <div className="detail-section">
                            <h4>Yeni Değerler</h4>
                            <pre>
                              {log.new_values
                                ? JSON.stringify(parseJson(log.new_values), null, 2)
                                : '-'}
                            </pre>
                          </div>
                          {log.user_agent && (
                            <div className="detail-section">
                              <h4>User Agent</h4>
                              <p>{log.user_agent}</p>
                            </div>
                          )}
                        </div>
                      </td>
                    </tr>
                  )}
                </>
              ))
            )}
          </tbody>
        </table>
      </div>

      {totalPages > 1 && (
        <div className="pagination">
          <button
            className="pagination-button"
            onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
            disabled={currentPage === 1}
          >
            Önceki
          </button>
          <span className="pagination-info">
            Sayfa {currentPage} / {totalPages}
          </span>
          <button
            className="pagination-button"
            onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
            disabled={currentPage === totalPages}
          >
            Sonraki
          </button>
        </div>
      )}
    </div>
  );
};

export default AuditLogPage;
