import { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import * as XLSX from 'xlsx';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import { formatDate } from '../utils/helpers';
import '../styles/ReportsPage.css';

const ReportsPage = () => {
  const { isAdmin } = useAuth();
  const { showSuccess, showError, showWarning } = useToast();
  const navigate = useNavigate();
  const [statistics, setStatistics] = useState<any>(null);
  const [reports, setReports] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({
    start_date: '',
    end_date: '',
    depot_ids: [] as string[],
    statuses: [] as string[],
  });
  const [depots, setDepots] = useState<any[]>([]);
  const [showReport, setShowReport] = useState(false);

  useEffect(() => {
    fetchDepots();
  }, []);

  useEffect(() => {
    fetchStatistics();
  }, [filters]);

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

  const fetchStatistics = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filters.start_date) params.append('start_date', filters.start_date);
      if (filters.end_date) params.append('end_date', filters.end_date);
      if (filters.depot_ids.length > 0) {
        filters.depot_ids.forEach((id) => params.append('depot_id', id));
      }

      const response = await api.get(`/reports/statistics?${params.toString()}`);
      if (response.data.success) {
        setStatistics(response.data.data);
      }
    } catch (error) {
      console.error('İstatistikler yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchReport = async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      if (filters.start_date) params.append('start_date', filters.start_date);
      if (filters.end_date) params.append('end_date', filters.end_date);
      if (filters.depot_ids.length > 0) {
        filters.depot_ids.forEach((id) => params.append('depot_id', id));
      }
      if (filters.statuses.length > 0) {
        filters.statuses.forEach((status) => params.append('status', status));
      }

      const response = await api.get(`/reports/requests?${params.toString()}`);
      if (response.data.success) {
        setReports(response.data.data);
        setShowReport(true);
      }
    } catch (error) {
      console.error('Rapor yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const exportToCSV = () => {
    if (reports.length === 0) {
      showWarning('Dışa aktarılacak veri yok');
      return;
    }

    const headers = [
      'Talep No',
      'Bayi Adı',
      'Bayi Kodu',
      'Territory Adı',
      'Seçilen POSM',
      'Yapılacak İş',
      'Durum',
      'İstenen Tarih',
      'Planlanan Tarih',
      'Tamamlanma Tarihi',
      'Kullanıcı',
      'Depo',
      'Oluşturulma Tarihi',
    ];

    const rows = reports.map((r) => [
      r.request_no,
      r.bayi_adi || '',
      r.bayi_kodu || '',
      r.territory_name || r.territory_code || '',
      r.posm_name || '',
      r.yapilacak_is,
      r.durum,
      r.istenen_tarih || '',
      r.planlanan_tarih || '',
      r.tamamlanma_tarihi || '',
      r.user_name || '',
      r.depot_name || '',
      r.created_at || '',
    ]);

    const csvContent = [
      headers.join(','),
      ...rows.map((row) => row.map((cell) => `"${cell}"`).join(',')),
    ].join('\n');

    const blob = new Blob(['\ufeff' + csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', `rapor_${new Date().toISOString().split('T')[0]}.csv`);
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  const handleCreateScheduledReport = () => {
    // Filtreleri query parametreleri olarak ScheduledReportsPage'e aktar
    const params = new URLSearchParams();
    if (filters.start_date) params.append('start_date', filters.start_date);
    if (filters.end_date) params.append('end_date', filters.end_date);
    if (filters.depot_ids.length > 0) {
      filters.depot_ids.forEach((id) => params.append('depot_id', id));
    }
    if (filters.statuses.length > 0) {
      filters.statuses.forEach((status) => params.append('status', status));
    }
    
    navigate(`/scheduled-reports?${params.toString()}`);
  };

  const toggleDepot = (depotId: string) => {
    setFilters((prev) => ({
      ...prev,
      depot_ids: prev.depot_ids.includes(depotId)
        ? prev.depot_ids.filter((id) => id !== depotId)
        : [...prev.depot_ids, depotId],
    }));
  };

  const toggleStatus = (status: string) => {
    setFilters((prev) => ({
      ...prev,
      statuses: prev.statuses.includes(status)
        ? prev.statuses.filter((s) => s !== status)
        : [...prev.statuses, status],
    }));
  };

  const exportToExcel = () => {
    if (reports.length === 0) {
      showWarning('Dışa aktarılacak veri yok');
      return;
    }

    try {
      // Veriyi Excel formatına dönüştür
      const excelData = reports.map((r) => ({
        'Talep No': r.request_no || '',
        'Bayi Adı': r.bayi_adi || '',
        'Bayi Kodu': r.bayi_kodu || '',
        'Territory Adı': r.territory_name || r.territory_code || '',
        'Seçilen POSM': r.posm_name || '',
        'Yapılacak İş': r.yapilacak_is || '',
        'Durum': r.durum || '',
        'İstenen Tarih': r.istenen_tarih || '',
        'Planlanan Tarih': r.planlanan_tarih || '',
        'Tamamlanma Tarihi': r.tamamlanma_tarihi || '',
        'Kullanıcı': r.user_name || '',
        'Depo': r.depot_name || '',
        'Oluşturulma Tarihi': r.created_at || '',
      }));

      // Workbook oluştur
      const workbook = XLSX.utils.book_new();

      // Veriyi worksheet'e dönüştür
      const worksheet = XLSX.utils.json_to_sheet(excelData);

      // Sütun genişliklerini ayarla
      const headers = [
        'Talep No',
        'Bayi Adı',
        'Bayi Kodu',
        'Territory Adı',
        'Seçilen POSM',
        'Yapılacak İş',
        'Durum',
        'İstenen Tarih',
        'Planlanan Tarih',
        'Tamamlanma Tarihi',
        'Kullanıcı',
        'Depo',
        'Oluşturulma Tarihi',
      ];
      const maxWidth = 50;
      const colWidths = headers.map((header) => {
        const maxLength = Math.max(
          header.length,
          ...excelData.map((d) => {
            const val = d[header as keyof typeof d];
            return String(val || '').length;
          })
        );
        return { wch: Math.min(maxLength + 2, maxWidth) };
      });
      worksheet['!cols'] = colWidths;

      // Worksheet'i workbook'a ekle
      XLSX.utils.book_append_sheet(workbook, worksheet, 'Rapor');

      // Excel dosyasını indir
      const fileName = `rapor_${new Date().toISOString().split('T')[0]}.xlsx`;
      XLSX.writeFile(workbook, fileName);

      showSuccess('Excel dosyası başarıyla indirildi');
    } catch (error: any) {
      console.error('Excel export hatası:', error);
      showError('Excel dosyası oluşturulurken hata oluştu: ' + (error.message || 'Bilinmeyen hata'));
    }
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading && !statistics) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="reports-page">
      <div className="page-header">
        <h2>Raporlar ve İstatistikler</h2>
        <div className="header-actions">
          <Link to="/custom-report-design" className="btn-secondary">
            Serbest Rapor Tasarımı
          </Link>
          <Link to="/scheduled-reports" className="btn-secondary">
            Otomatik Rapor Yönetimi
          </Link>
        </div>
      </div>

      <div className="filters-section">
        <div className="filter-group">
          <label>Başlangıç Tarihi</label>
          <input
            type="date"
            value={filters.start_date}
            onChange={(e) => setFilters({ ...filters, start_date: e.target.value })}
          />
        </div>
        <div className="filter-group">
          <label>Bitiş Tarihi</label>
          <input
            type="date"
            value={filters.end_date}
            onChange={(e) => setFilters({ ...filters, end_date: e.target.value })}
          />
        </div>
        <div className="filter-group" style={{ minWidth: '200px' }}>
          <label>Depo (Çoklu Seçim)</label>
          <div style={{ 
            border: '1px solid #ddd', 
            borderRadius: '4px', 
            padding: '8px', 
            maxHeight: '150px', 
            overflowY: 'auto',
            backgroundColor: '#fff'
          }}>
            <label style={{ display: 'flex', alignItems: 'center', marginBottom: '4px', cursor: 'pointer' }}>
              <input
                type="checkbox"
                checked={filters.depot_ids.length === 0}
                onChange={() => setFilters({ ...filters, depot_ids: [] })}
                style={{ marginRight: '8px' }}
              />
              <span>Tüm Depolar</span>
            </label>
            {depots.map((depot) => (
              <label 
                key={depot.id} 
                style={{ display: 'flex', alignItems: 'center', marginBottom: '4px', cursor: 'pointer' }}
              >
                <input
                  type="checkbox"
                  checked={filters.depot_ids.includes(depot.id.toString())}
                  onChange={() => toggleDepot(depot.id.toString())}
                  style={{ marginRight: '8px' }}
                />
                <span>{depot.name}</span>
              </label>
            ))}
          </div>
          {filters.depot_ids.length > 0 && (
            <small style={{ color: '#666', display: 'block', marginTop: '4px' }}>
              {filters.depot_ids.length} depo seçildi
            </small>
          )}
        </div>
        <div className="filter-group" style={{ minWidth: '200px' }}>
          <label>Durum (Çoklu Seçim)</label>
          <div style={{ 
            border: '1px solid #ddd', 
            borderRadius: '4px', 
            padding: '8px', 
            maxHeight: '150px', 
            overflowY: 'auto',
            backgroundColor: '#fff'
          }}>
            <label style={{ display: 'flex', alignItems: 'center', marginBottom: '4px', cursor: 'pointer' }}>
              <input
                type="checkbox"
                checked={filters.statuses.length === 0}
                onChange={() => setFilters({ ...filters, statuses: [] })}
                style={{ marginRight: '8px' }}
              />
              <span>Tüm Durumlar</span>
            </label>
            {['Beklemede', 'Planlandı', 'Tamamlandı', 'İptal'].map((status) => (
              <label 
                key={status} 
                style={{ display: 'flex', alignItems: 'center', marginBottom: '4px', cursor: 'pointer' }}
              >
                <input
                  type="checkbox"
                  checked={filters.statuses.includes(status)}
                  onChange={() => toggleStatus(status)}
                  style={{ marginRight: '8px' }}
                />
                <span>{status}</span>
              </label>
            ))}
          </div>
          {filters.statuses.length > 0 && (
            <small style={{ color: '#666', display: 'block', marginTop: '4px' }}>
              {filters.statuses.length} durum seçildi
            </small>
          )}
        </div>
        <div className="filter-group" style={{ display: 'flex', gap: '8px' }}>
          <button className="generate-report-button" onClick={fetchReport}>
            Rapor Oluştur
          </button>
          <button
            className="generate-report-button"
            onClick={handleCreateScheduledReport}
            style={{
              background: '#27ae60',
            }}
          >
            📅 Bu Filtrelerle Otomatik Rapor Oluştur
          </button>
        </div>
      </div>

      {statistics && (
        <div className="statistics-section">
          <h3>İstatistikler</h3>
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-label">Toplam Talep</div>
              <div className="stat-value">{statistics.total}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Beklemede</div>
              <div className="stat-value">{statistics.beklemede}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Planlandı</div>
              <div className="stat-value">{statistics.planlandi}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Tamamlandı</div>
              <div className="stat-value">{statistics.tamamlandi}</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">İptal</div>
              <div className="stat-value">{statistics.iptal}</div>
            </div>
          </div>

          {statistics.by_type && statistics.by_type.length > 0 && (
            <div className="chart-section">
              <h4>İş Tipine Göre</h4>
              <div className="chart-bars">
                {statistics.by_type.map((item: any) => (
                  <div key={item.type} className="chart-bar-item">
                    <div className="chart-bar-label">{item.type}</div>
                    <div className="chart-bar">
                      <div
                        className="chart-bar-fill"
                        style={{
                          width: `${(item.count / statistics.total) * 100}%`,
                        }}
                      >
                        {item.count}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {statistics.by_depot && statistics.by_depot.length > 0 && (
            <div className="chart-section">
              <h4>Depo Bazında</h4>
              <div className="chart-bars">
                {statistics.by_depot.map((item: any) => (
                  <div key={item.depot_name} className="chart-bar-item">
                    <div className="chart-bar-label">{item.depot_name}</div>
                    <div className="chart-bar">
                      <div
                        className="chart-bar-fill"
                        style={{
                          width: `${(item.count / statistics.total) * 100}%`,
                        }}
                      >
                        {item.count}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}

      {showReport && reports.length > 0 && (
        <div className="report-section">
          <div className="report-header">
            <h3>Detaylı Rapor ({reports.length} kayıt)</h3>
            <div style={{ display: 'flex', gap: '8px' }}>
              <button className="export-button" onClick={exportToCSV}>
                CSV Olarak Dışa Aktar
              </button>
              <button
                className="export-button"
                onClick={exportToExcel}
                style={{
                  background: '#27ae60',
                }}
              >
                📊 Excel Olarak Dışa Aktar
              </button>
            </div>
          </div>
          <div className="report-table-container">
            <table className="report-table">
              <thead>
                <tr>
                  <th>Talep No</th>
                  <th>Bayi Adı</th>
                  <th>Bayi Kodu</th>
                  <th>Territory Adı</th>
                  <th>Seçilen POSM</th>
                  <th>Yapılacak İş</th>
                  <th>Durum</th>
                  <th>İstenen Tarih</th>
                  <th>Planlanan Tarih</th>
                  <th>Tamamlanma</th>
                  <th>Kullanıcı</th>
                  <th>Depo</th>
                </tr>
              </thead>
              <tbody>
                {reports.map((report, index) => (
                  <tr key={index}>
                    <td>{report.request_no}</td>
                    <td>{report.bayi_adi || '-'}</td>
                    <td>{report.bayi_kodu || '-'}</td>
                    <td>{report.territory_name || report.territory_code || '-'}</td>
                    <td>{report.posm_name || '-'}</td>
                    <td>{report.yapilacak_is}</td>
                    <td>
                      <span className={`status-badge status-${report.durum.toLowerCase()}`}>
                        {report.durum}
                      </span>
                    </td>
                    <td>{report.istenen_tarih || '-'}</td>
                    <td>{report.planlanan_tarih || '-'}</td>
                    <td>{report.tamamlanma_tarihi || '-'}</td>
                    <td>{report.user_name || '-'}</td>
                    <td>{report.depot_name || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {showReport && reports.length === 0 && (
        <div className="no-data">Seçilen kriterlere uygun kayıt bulunamadı.</div>
      )}
    </div>
  );
};

export default ReportsPage;
