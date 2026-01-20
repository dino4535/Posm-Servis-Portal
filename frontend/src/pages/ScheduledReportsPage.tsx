import { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import ConfirmModal from '../components/ConfirmModal';
import '../styles/ScheduledReportsPage.css';

const ScheduledReportsPage = () => {
  const { isAdmin } = useAuth();
  const { showSuccess, showError } = useToast();
  const [searchParams] = useSearchParams();
  const [scheduledReports, setScheduledReports] = useState<any[]>([]);
  const [templates, setTemplates] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editingReport, setEditingReport] = useState<any>(null);
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
  const [formData, setFormData] = useState({
    report_template_id: '',
    name: '',
    description: '',
    repeat_type: 'daily',
    day: [] as number[],
    hour: 9,
    minute: 0,
    recipients: '',
    depot_filters: [] as number[],
    start_date: '',
    end_date: '',
    status: '',
  });
  const [depots, setDepots] = useState<any[]>([]);

  useEffect(() => {
    fetchScheduledReports();
    fetchTemplates();
    fetchDepots();
  }, []);

  useEffect(() => {
    // URL'den filtreleri al ve form'a ekle (çoklu seçim desteği)
    const startDate = searchParams.get('start_date');
    const endDate = searchParams.get('end_date');
    const depotIds = searchParams.getAll('depot_id').map((id) => parseInt(id, 10)).filter((id) => !isNaN(id));
    const statuses = searchParams.getAll('status').filter((s) => s);
    
    if (startDate || endDate || depotIds.length > 0 || statuses.length > 0) {
      setFormData((prev) => ({
        ...prev,
        start_date: startDate || '',
        end_date: endDate || '',
        status: statuses.length > 0 ? statuses.join(',') : '', // Durumları virgülle ayırarak sakla
        depot_filters: depotIds.length > 0 ? depotIds : [],
      }));
      setShowForm(true);
    }
  }, [searchParams]);

  const fetchScheduledReports = async () => {
    setLoading(true);
    try {
      const response = await api.get('/custom-reports/scheduled');
      if (response.data.success) {
        setScheduledReports(response.data.data);
      }
    } catch (error) {
      console.error('Zamanlanmış raporlar yüklenirken hata:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchTemplates = async () => {
    try {
      const response = await api.get('/custom-reports/templates');
      if (response.data.success) {
        setTemplates(response.data.data);
      }
    } catch (error) {
      console.error('Rapor şablonları yüklenirken hata:', error);
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
    
    // Rapor şablonu kontrolü
    if (!formData.report_template_id) {
      showError('Lütfen bir rapor şablonu seçiniz. Eğer rapor şablonu yoksa, önce "Serbest Rapor Tasarımı" sayfasından bir şablon oluşturun.');
      return;
    }
    
    try {
      const recipients = formData.recipients.split(',').map((email) => email.trim()).filter(Boolean);
      
      if (recipients.length === 0) {
        showError('Lütfen en az bir alıcı email adresi giriniz.');
        return;
      }
      
      const scheduleConfig = {
        repeat_type: formData.repeat_type,
        day: formData.day,
        hour: parseInt(formData.hour.toString(), 10),
        minute: parseInt(formData.minute.toString(), 10),
      };

      const reportData: any = {
        report_template_id: parseInt(formData.report_template_id, 10),
        name: formData.name,
        description: formData.description,
        schedule_config: scheduleConfig,
        recipients,
        depot_filters: formData.depot_filters.length > 0 ? formData.depot_filters : undefined,
      };

      // Filtreleri ekle (eğer varsa)
      if (formData.start_date) {
        reportData.start_date = formData.start_date;
      }
      if (formData.end_date) {
        reportData.end_date = formData.end_date;
      }
      if (formData.status) {
        // Durumları virgülle ayrılmış string'den array'e çevir
        const statusArray = formData.status.split(',').map((s) => s.trim()).filter((s) => s);
        if (statusArray.length > 0) {
          reportData.status = statusArray.length === 1 ? statusArray[0] : statusArray.join(',');
        }
      }

      if (editingReport) {
        await api.put(`/custom-reports/scheduled/${editingReport.id}`, reportData);
        showSuccess('Zamanlanmış rapor güncellendi');
      } else {
        await api.post('/custom-reports/scheduled', reportData);
        showSuccess('Zamanlanmış rapor oluşturuldu');
      }

      fetchScheduledReports();
      resetForm();
    } catch (error: any) {
      showError(error.response?.data?.error || 'İşlem sırasında hata oluştu');
    }
  };

  const handleEdit = (report: any) => {
    setEditingReport(report);
    const scheduleConfig = JSON.parse(report.schedule_config);
    const recipients = JSON.parse(report.recipients);
    
    setFormData({
      report_template_id: report.report_template_id.toString(),
      name: report.name,
      description: report.description || '',
      repeat_type: scheduleConfig.repeat_type,
      day: scheduleConfig.day || [],
      hour: scheduleConfig.hour,
      minute: scheduleConfig.minute,
      recipients: recipients.join(', '),
      depot_filters: report.depot_filters ? JSON.parse(report.depot_filters) : [],
      start_date: report.start_date || '',
      end_date: report.end_date || '',
      status: report.status || '',
    });
    setShowForm(true);
  };

  const handleDelete = async (id: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu zamanlanmış raporu silmek istediğinize emin misiniz?',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/custom-reports/scheduled/${id}`);
          showSuccess('Zamanlanmış rapor silindi');
          fetchScheduledReports();
        } catch (error: any) {
          showError(error.response?.data?.error || 'Silme işlemi sırasında hata oluştu');
        }
      },
    });
  };

  const toggleDay = (day: number) => {
    if (formData.day.includes(day)) {
      setFormData({ ...formData, day: formData.day.filter((d) => d !== day) });
    } else {
      setFormData({ ...formData, day: [...formData.day, day] });
    }
  };

  const toggleDepot = (depotId: number) => {
    if (formData.depot_filters.includes(depotId)) {
      setFormData({ ...formData, depot_filters: formData.depot_filters.filter((id) => id !== depotId) });
    } else {
      setFormData({ ...formData, depot_filters: [...formData.depot_filters, depotId] });
    }
  };

  const resetForm = () => {
    setFormData({
      report_template_id: '',
      name: '',
      description: '',
      repeat_type: 'daily',
      day: [],
      hour: 9,
      minute: 0,
      recipients: '',
      depot_filters: [],
      start_date: '',
      end_date: '',
      status: '',
    });
    setEditingReport(null);
    setShowForm(false);
  };

  const formatNextRun = (nextRunAt: string) => {
    if (!nextRunAt) return '-';
    return new Date(nextRunAt).toLocaleString('tr-TR', {
      timeZone: 'Europe/Istanbul',
    });
  };

  if (!isAdmin) {
    return <div className="no-access">Bu sayfaya erişim yetkiniz yok.</div>;
  }

  if (loading) {
    return <div className="loading">Yükleniyor...</div>;
  }

  const weekDays = [
    { value: 0, label: 'Pazar' },
    { value: 1, label: 'Pazartesi' },
    { value: 2, label: 'Salı' },
    { value: 3, label: 'Çarşamba' },
    { value: 4, label: 'Perşembe' },
    { value: 5, label: 'Cuma' },
    { value: 6, label: 'Cumartesi' },
  ];

  return (
    <div className="scheduled-reports-page">
      <div className="page-header">
        <h2>Otomatik Rapor Yönetimi</h2>
        <button className="add-button" onClick={() => setShowForm(true)}>
          + Yeni Zamanlanmış Rapor
        </button>
      </div>

      {showForm && (
        <div className="form-modal">
          <div className="form-content">
            <h3>{editingReport ? 'Zamanlanmış Rapor Düzenle' : 'Yeni Zamanlanmış Rapor'}</h3>
            <form onSubmit={handleSubmit}>
              <div className="form-group">
                <label>Rapor Şablonu *</label>
                <select
                  value={formData.report_template_id}
                  onChange={(e) => setFormData({ ...formData, report_template_id: e.target.value })}
                  required
                  style={{
                    borderColor: !formData.report_template_id && showForm ? '#e74c3c' : undefined,
                  }}
                >
                  <option value="">Şablon Seçiniz</option>
                  {templates.length === 0 ? (
                    <option value="" disabled>
                      Rapor şablonu bulunamadı
                    </option>
                  ) : (
                    templates.map((template) => (
                      <option key={template.id} value={template.id}>
                        {template.name}
                      </option>
                    ))
                  )}
                </select>
                {templates.length === 0 && (
                  <small style={{ color: '#e74c3c', display: 'block', marginTop: '4px' }}>
                    ⚠️ Rapor şablonu bulunamadı. Önce "Serbest Rapor Tasarımı" sayfasından bir rapor şablonu oluşturun.
                  </small>
                )}
                {!formData.report_template_id && templates.length > 0 && (
                  <small style={{ color: '#f39c12', display: 'block', marginTop: '4px' }}>
                    ⚠️ Lütfen bir rapor şablonu seçiniz.
                  </small>
                )}
              </div>

              <div className="form-group">
                <label>Rapor Adı *</label>
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
                  rows={2}
                />
              </div>

              <div className="form-group">
                <label>Tekrar Tipi *</label>
                <select
                  value={formData.repeat_type}
                  onChange={(e) => setFormData({ ...formData, repeat_type: e.target.value, day: [] })}
                  required
                >
                  <option value="daily">Günlük</option>
                  <option value="weekly">Haftalık</option>
                  <option value="monthly">Aylık</option>
                </select>
              </div>

              {(formData.repeat_type === 'weekly' || formData.repeat_type === 'monthly') && (
                <div className="form-group">
                  <label>{formData.repeat_type === 'weekly' ? 'Haftanın Günleri' : 'Ayın Günleri'} *</label>
                  <div className="day-selector">
                    {formData.repeat_type === 'weekly'
                      ? weekDays.map((day) => (
                          <label key={day.value} className="day-checkbox">
                            <input
                              type="checkbox"
                              checked={formData.day.includes(day.value)}
                              onChange={() => toggleDay(day.value)}
                            />
                            <span>{day.label}</span>
                          </label>
                        ))
                      : Array.from({ length: 31 }, (_, i) => i + 1).map((day) => (
                          <label key={day} className="day-checkbox">
                            <input
                              type="checkbox"
                              checked={formData.day.includes(day)}
                              onChange={() => toggleDay(day)}
                            />
                            <span>{day}</span>
                          </label>
                        ))}
                  </div>
                </div>
              )}

              <div className="form-group">
                <label>Saat *</label>
                <div className="time-selector">
                  <input
                    type="number"
                    min="0"
                    max="23"
                    value={formData.hour}
                    onChange={(e) => setFormData({ ...formData, hour: parseInt(e.target.value, 10) })}
                    required
                  />
                  <span>:</span>
                  <input
                    type="number"
                    min="0"
                    max="59"
                    value={formData.minute}
                    onChange={(e) => setFormData({ ...formData, minute: parseInt(e.target.value, 10) })}
                    required
                  />
                </div>
              </div>

              <div className="form-group">
                <label>Alıcılar (Email) *</label>
                <textarea
                  value={formData.recipients}
                  onChange={(e) => setFormData({ ...formData, recipients: e.target.value })}
                  placeholder="email1@example.com, email2@example.com"
                  rows={3}
                  required
                />
                <small>Virgülle ayırarak birden fazla email adresi girebilirsiniz</small>
              </div>

              <div className="form-group">
                <label>Depo Filtreleri (Opsiyonel)</label>
                <div className="depot-selector">
                  {depots.map((depot) => (
                    <label key={depot.id} className="depot-checkbox">
                      <input
                        type="checkbox"
                        checked={formData.depot_filters.includes(depot.id)}
                        onChange={() => toggleDepot(depot.id)}
                      />
                      <span>{depot.name}</span>
                    </label>
                  ))}
                </div>
                <small>Boş bırakılırsa tüm depolar için rapor gönderilir</small>
              </div>

              <div className="form-section-divider">
                <h4>Rapor Filtreleri (Opsiyonel)</h4>
                <p className="section-hint">Bu filtreler rapor çalıştırıldığında uygulanacaktır</p>
              </div>

              <div className="form-group">
                <label>Başlangıç Tarihi</label>
                <input
                  type="date"
                  value={formData.start_date}
                  onChange={(e) => setFormData({ ...formData, start_date: e.target.value })}
                />
              </div>

              <div className="form-group">
                <label>Bitiş Tarihi</label>
                <input
                  type="date"
                  value={formData.end_date}
                  onChange={(e) => setFormData({ ...formData, end_date: e.target.value })}
                />
              </div>

              <div className="form-group" style={{ minWidth: '200px' }}>
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
                      checked={!formData.status || formData.status === ''}
                      onChange={() => setFormData({ ...formData, status: '' })}
                      style={{ marginRight: '8px' }}
                    />
                    <span>Tüm Durumlar</span>
                  </label>
                  {['Beklemede', 'Planlandı', 'Tamamlandı', 'İptal'].map((status) => {
                    const statusArray = formData.status ? formData.status.split(',').map((s) => s.trim()) : [];
                    return (
                      <label 
                        key={status} 
                        style={{ display: 'flex', alignItems: 'center', marginBottom: '4px', cursor: 'pointer' }}
                      >
                        <input
                          type="checkbox"
                          checked={statusArray.includes(status)}
                          onChange={() => {
                            const currentStatuses = formData.status ? formData.status.split(',').map((s) => s.trim()).filter((s) => s) : [];
                            const newStatuses = currentStatuses.includes(status)
                              ? currentStatuses.filter((s) => s !== status)
                              : [...currentStatuses, status];
                            setFormData({ ...formData, status: newStatuses.join(',') });
                          }}
                          style={{ marginRight: '8px' }}
                        />
                        <span>{status}</span>
                      </label>
                    );
                  })}
                </div>
                {formData.status && formData.status.split(',').filter((s) => s.trim()).length > 0 && (
                  <small style={{ color: '#666', display: 'block', marginTop: '4px' }}>
                    {formData.status.split(',').filter((s) => s.trim()).length} durum seçildi
                  </small>
                )}
              </div>

              <div className="form-actions">
                <button type="submit" className="submit-button">
                  {editingReport ? 'Güncelle' : 'Oluştur'}
                </button>
                <button type="button" className="cancel-button" onClick={resetForm}>
                  İptal
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      <div className="scheduled-reports-table-container">
        <table className="scheduled-reports-table">
          <thead>
            <tr>
              <th>Rapor Adı</th>
              <th>Şablon</th>
              <th>Tekrar</th>
              <th>Saat</th>
              <th>Alıcılar</th>
              <th>Son Çalıştırma</th>
              <th>Sonraki Çalıştırma</th>
              <th>Durum</th>
              <th>İşlemler</th>
            </tr>
          </thead>
          <tbody>
            {scheduledReports.length === 0 ? (
              <tr>
                <td colSpan={9} className="no-data">
                  Henüz zamanlanmış rapor bulunmuyor
                </td>
              </tr>
            ) : (
              scheduledReports.map((report) => {
                const scheduleConfig = JSON.parse(report.schedule_config);
                const recipients = JSON.parse(report.recipients);
                
                return (
                  <tr key={report.id}>
                    <td>{report.name}</td>
                    <td>{report.template_name || '-'}</td>
                    <td>
                      {scheduleConfig.repeat_type === 'daily' && 'Günlük'}
                      {scheduleConfig.repeat_type === 'weekly' && 'Haftalık'}
                      {scheduleConfig.repeat_type === 'monthly' && 'Aylık'}
                    </td>
                    <td>
                      {String(scheduleConfig.hour).padStart(2, '0')}:
                      {String(scheduleConfig.minute).padStart(2, '0')}
                    </td>
                    <td>{recipients.length} alıcı</td>
                    <td>{report.last_run_at ? new Date(report.last_run_at).toLocaleString('tr-TR', {
                      timeZone: 'Europe/Istanbul',
                    }) : '-'}</td>
                    <td>{formatNextRun(report.next_run_at)}</td>
                    <td>
                      <span className={report.is_active ? 'status-active' : 'status-inactive'}>
                        {report.is_active ? 'Aktif' : 'Pasif'}
                      </span>
                    </td>
                    <td>
                      <button className="edit-button" onClick={() => handleEdit(report)}>
                        Düzenle
                      </button>
                      <button className="delete-button" onClick={() => handleDelete(report.id)}>
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

export default ScheduledReportsPage;
