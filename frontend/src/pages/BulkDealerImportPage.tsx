import { useState } from 'react';
import * as XLSX from 'xlsx';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import '../styles/BulkDealerImportPage.css';

interface ImportResult {
  total: number;
  created: number;
  skipped: number;
  errors: string[];
}

const BulkDealerImportPage = () => {
  const { showWarning, showSuccess, showError } = useToast();
  const [file, setFile] = useState<File | null>(null);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<ImportResult | null>(null);

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      setFile(e.target.files[0]);
      setResult(null);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) {
      showWarning('Lütfen bir Excel dosyası seçin');
      return;
    }

    setLoading(true);
    setResult(null);

    try {
      const formData = new FormData();
      formData.append('file', file);

      const response = await api.post('/dealers/bulk-import', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });

      if (response.data.success) {
        setResult(response.data.data);
        if (response.data.data.created > 0) {
          showSuccess(`${response.data.data.created} bayi başarıyla eklendi`);
        }
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Import sırasında hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const downloadTemplate = () => {
    const template = [
      {
        depo: 'Depo 1',
        territory_kodu: 'TER001',
        territory_adi: 'Territory 1',
        bayi_kodu: 'BAYI001',
        bayi_adi: 'Bayi Adı 1',
        adres: 'Örnek Adres 1, İstanbul',
        telefon: '0212 123 45 67',
        enlem: 41.0082,
        boylam: 28.9784,
      },
      {
        depo: 'Depo 1',
        territory_kodu: 'TER002',
        territory_adi: 'Territory 2',
        bayi_kodu: 'BAYI002',
        bayi_adi: 'Bayi Adı 2',
        adres: 'Örnek Adres 2, Ankara',
        telefon: '0312 987 65 43',
        enlem: 41.0123,
        boylam: 28.9876,
      },
    ];

    // Workbook oluştur
    const workbook = XLSX.utils.book_new();
    
    // Worksheet oluştur
    const worksheet = XLSX.utils.json_to_sheet(template);
    
    // Sütun genişliklerini ayarla
    worksheet['!cols'] = [
      { wch: 15 }, // depo
      { wch: 15 }, // territory_kodu
      { wch: 20 }, // territory_adi
      { wch: 15 }, // bayi_kodu
      { wch: 25 }, // bayi_adi
      { wch: 30 }, // adres
      { wch: 18 }, // telefon
      { wch: 12 }, // enlem
      { wch: 12 }, // boylam
    ];
    
    // Workbook'a worksheet ekle
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Bayiler');
    
    // XLSX dosyasını indir
    XLSX.writeFile(workbook, 'bayi_import_template.xlsx');
  };

  return (
    <div className="bulk-dealer-import-page">
      <div className="page-header">
        <h2>Toplu Bayi İçe Aktarma</h2>
        <p className="page-description">
          Excel dosyası ile toplu bayi ekleyebilirsiniz. Depo ve Territory bilgileri otomatik oluşturulacaktır.
        </p>
      </div>

      <div className="import-section">
        <div className="info-box">
          <h3>Excel Formatı</h3>
          <p>Excel dosyanızda aşağıdaki sütunlar bulunmalıdır:</p>
          <ul>
            <li><strong>depo</strong> - Depo adı (yoksa otomatik oluşturulur)</li>
            <li><strong>territory_kodu</strong> - Territory kodu (yoksa otomatik oluşturulur)</li>
            <li><strong>territory_adi</strong> - Territory adı</li>
            <li><strong>bayi_kodu</strong> - Bayi kodu (zorunlu, unique)</li>
            <li><strong>bayi_adi</strong> - Bayi adı (zorunlu)</li>
            <li><strong>adres</strong> - Bayi adresi (opsiyonel)</li>
            <li><strong>telefon</strong> - Telefon numarası (opsiyonel)</li>
            <li><strong>enlem</strong> - Enlem koordinatı (opsiyonel)</li>
            <li><strong>boylam</strong> - Boylam koordinatı (opsiyonel)</li>
          </ul>
          <p className="note">
            <strong>Not:</strong> Mevcut bayi kodları atlanacaktır. Sadece yeni bayiler eklenecektir.
          </p>
        </div>

        <div className="upload-section">
          <button className="template-button" onClick={downloadTemplate}>
            📥 Şablon İndir (XLSX)
          </button>

          <form onSubmit={handleSubmit} className="upload-form">
            <div className="file-input-wrapper">
              <label className="file-label">
                <input
                  type="file"
                  accept=".xlsx,.xls"
                  onChange={handleFileChange}
                  className="file-input"
                />
                <span className="file-button">📁 Dosya Seç</span>
                {file && <span className="file-name">{file.name}</span>}
              </label>
            </div>

            <button
              type="submit"
              className="submit-button"
              disabled={!file || loading}
            >
              {loading ? 'İçe Aktarılıyor...' : 'İçe Aktar'}
            </button>
          </form>
        </div>

        {result && (
          <div className="result-section">
            <h3>İçe Aktarma Sonuçları</h3>
            <div className="result-stats">
              <div className="stat-card">
                <span className="stat-label">Toplam Satır</span>
                <span className="stat-value">{result.total}</span>
              </div>
              <div className="stat-card success">
                <span className="stat-label">Eklenen</span>
                <span className="stat-value">{result.created}</span>
              </div>
              <div className="stat-card warning">
                <span className="stat-label">Atlanan</span>
                <span className="stat-value">{result.skipped}</span>
              </div>
            </div>

            {result.errors.length > 0 && (
              <div className="errors-box">
                <h4>Hatalar:</h4>
                <ul>
                  {result.errors.map((error, index) => (
                    <li key={index}>{error}</li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  );
};

export default BulkDealerImportPage;
