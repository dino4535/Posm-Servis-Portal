import { useState, useEffect, useMemo } from 'react';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import '../styles/DepotPOSMPage.css';

interface POSM {
  id: number;
  name: string;
  description?: string;
  depot_id: number;
  depot_name: string;
  depot_code: string;
  hazir_adet: number;
  tamir_bekleyen: number;
  revize_adet: number;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
}

const DepotPOSMPage = () => {
  const { showError } = useToast();
  const [posms, setPosms] = useState<POSM[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedDepot, setSelectedDepot] = useState<number | null>(null);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchPOSM();
  }, []);

  const fetchPOSM = async () => {
    setLoading(true);
    try {
      const response = await api.get('/posm/my-depots');
      if (response.data.success) {
        setPosms(response.data.data);
      }
    } catch (error: any) {
      console.error('POSM yüklenirken hata:', error);
      showError(error.response?.data?.error || 'POSM\'ler yüklenirken hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  // Depo listesini al (benzersiz) - memoize edilmiş
  // Depo ismi ve kodu kombinasyonuna göre benzersiz hale getir
  const depots = useMemo(() => {
    // İsim ve kod kombinasyonuna göre benzersiz hale getir
    // Aynı isim ve koda sahip tüm depot_id'leri topla
    interface DepotInfo {
      id: number;
      name: string;
      code: string;
      depotIds: number[];
    }
    
    const uniqueDepotMap = new Map<string, DepotInfo>();
    
    posms.forEach((posm) => {
      if (posm.depot_name && posm.depot_code) {
        // İsim ve kod kombinasyonunu key olarak kullan
        const displayKey = `${posm.depot_name.trim()}|${posm.depot_code.trim()}`;
        
        if (!uniqueDepotMap.has(displayKey)) {
          uniqueDepotMap.set(displayKey, {
            id: posm.depot_id, // İlk gelen depot_id'yi ana ID olarak kullan
            name: posm.depot_name.trim(),
            code: posm.depot_code.trim(),
            depotIds: [posm.depot_id],
          });
        } else {
          // Aynı isim ve koda sahip başka bir depot_id varsa ekle
          const existing = uniqueDepotMap.get(displayKey)!;
          if (!existing.depotIds.includes(posm.depot_id)) {
            existing.depotIds.push(posm.depot_id);
          }
        }
      }
    });
    
    // Array'e çevir ve isme göre sırala
    return Array.from(uniqueDepotMap.values()).sort((a, b) => {
      const nameA = a.name.toLowerCase();
      const nameB = b.name.toLowerCase();
      if (nameA < nameB) return -1;
      if (nameA > nameB) return 1;
      return 0;
    });
  }, [posms]);

  // Seçili depo bilgisini al (isim ve kod kombinasyonu)
  const selectedDepotKey = useMemo(() => {
    if (selectedDepot === null) return null;
    
    // Seçili depo bilgisini bul
    const selectedDepotInfo = depots.find(d => d.id === selectedDepot);
    if (!selectedDepotInfo) {
      console.warn('Seçili depo bulunamadı:', selectedDepot, 'Mevcut depolar:', depots);
      return null;
    }
    
    // Depo isim ve kod kombinasyonunu döndür
    const key = `${selectedDepotInfo.name.trim()}|${selectedDepotInfo.code.trim()}`;
    console.log('Seçili depo key:', key, 'Depot bilgisi:', selectedDepotInfo);
    return key;
  }, [selectedDepot, depots]);

  // Filtrelenmiş POSM listesi - memoize edilmiş
  const filteredPosms = useMemo(() => {
    console.log('Filtreleme başlıyor - selectedDepotKey:', selectedDepotKey, 'Toplam POSM:', posms.length);
    
    const filtered = posms.filter((posm) => {
      // Depo filtresi: Seçili depo varsa, isim ve kod kombinasyonunu kontrol et
      let matchesDepot = true;
      if (selectedDepotKey !== null) {
        const posmKey = `${posm.depot_name.trim()}|${posm.depot_code.trim()}`;
        matchesDepot = posmKey === selectedDepotKey;
        if (matchesDepot) {
          console.log('Eşleşen POSM bulundu:', posm.name, 'Depot:', posm.depot_name, 'Key:', posmKey);
        }
      }
      
      // Arama filtresi
      const matchesSearch = 
        posm.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        (posm.description && posm.description.toLowerCase().includes(searchTerm.toLowerCase())) ||
        posm.depot_name.toLowerCase().includes(searchTerm.toLowerCase());
      
      return matchesDepot && matchesSearch;
    });
    
    console.log('Filtreleme tamamlandı - Sonuç sayısı:', filtered.length);
    return filtered;
  }, [posms, selectedDepotKey, searchTerm]);

  // Depo bazında grupla - memoize edilmiş
  const groupedPosms = useMemo(() => {
    const groupedByDepot = filteredPosms.reduce((acc, posm) => {
      const depotKey = posm.depot_id;
      if (!acc[depotKey]) {
        acc[depotKey] = {
          depot_id: posm.depot_id,
          depot_name: posm.depot_name,
          depot_code: posm.depot_code,
          posms: [],
        };
      }
      acc[depotKey].posms.push(posm);
      return acc;
    }, {} as Record<number, { depot_id: number; depot_name: string; depot_code: string; posms: POSM[] }>);

    return Object.values(groupedByDepot).sort((a, b) => 
      a.depot_name.localeCompare(b.depot_name)
    );
  }, [filteredPosms]);

  // Özet istatistikleri hesapla - memoize edilmiş (Hooks kuralları: if'den önce olmalı)
  const summaryStats = useMemo(() => {
    // Benzersiz POSM sayısını hesapla (POSM ismine göre)
    const uniquePosmNames = new Set(filteredPosms.map(p => p.name.toLowerCase().trim()));
    const uniquePosmCount = uniquePosmNames.size;

    return {
      totalDepots: depots.length,
      totalPOSM: uniquePosmCount, // Benzersiz POSM sayısı
      totalHazir: filteredPosms.reduce((sum, p) => sum + p.hazir_adet, 0),
      totalRevize: filteredPosms.reduce((sum, p) => sum + p.revize_adet, 0),
      totalTamir: filteredPosms.reduce((sum, p) => sum + p.tamir_bekleyen, 0),
    };
  }, [depots.length, filteredPosms]);

  if (loading) {
    return (
      <div className="depot-posm-page">
        <div className="loading-container">
          <div className="loading-spinner"></div>
          <p>Yükleniyor...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="depot-posm-page">
      <div className="page-header">
        <h1>Depolarımdaki POSM'ler</h1>
        <p className="page-description">
          Tanımlı olduğunuz depolardaki POSM envanter bilgilerini görüntüleyebilirsiniz.
        </p>
      </div>

      {/* Özet alanı en yukarıda */}
      <div className="summary-section">
        <div className="summary-card">
          <h3>Özet</h3>
          <div className="summary-stats">
            <div className="stat-item">
              <span className="stat-label">Toplam Depo:</span>
              <span className="stat-value">{summaryStats.totalDepots}</span>
            </div>
            <div className="stat-item">
              <span className="stat-label">Toplam POSM:</span>
              <span className="stat-value">{summaryStats.totalPOSM}</span>
            </div>
            <div className="stat-item">
              <span className="stat-label">Toplam Hazır:</span>
              <span className="stat-value">{summaryStats.totalHazir}</span>
            </div>
            <div className="stat-item">
              <span className="stat-label">Toplam Revize:</span>
              <span className="stat-value">{summaryStats.totalRevize}</span>
            </div>
            <div className="stat-item">
              <span className="stat-label">Toplam Tamir Bekleyen:</span>
              <span className="stat-value">{summaryStats.totalTamir}</span>
            </div>
          </div>
        </div>
      </div>

      <div className="filters-section">
        <div className="filter-group">
          <label htmlFor="depot-filter">Depo Filtresi:</label>
          <select
            id="depot-filter"
            value={selectedDepot || ''}
            onChange={(e) => setSelectedDepot(e.target.value ? parseInt(e.target.value, 10) : null)}
            className="filter-select"
          >
            <option value="">Depo Bazlı</option>
            {depots.map((depot, index) => (
              <option key={`${depot.id}-${index}`} value={depot.id}>
                {depot.name} ({depot.code})
              </option>
            ))}
          </select>
        </div>

        <div className="filter-group">
          <label htmlFor="search-filter">Ara:</label>
          <input
            id="search-filter"
            type="text"
            placeholder="POSM adı, açıklama veya depo adı ile ara..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="filter-input"
          />
        </div>
      </div>

      {filteredPosms.length === 0 ? (
        <div className="no-data">
          <p>
            {posms.length === 0
              ? 'Tanımlı olduğunuz depolarda POSM bulunmamaktadır.'
              : 'Arama kriterlerinize uygun POSM bulunamadı.'}
          </p>
        </div>
      ) : (
        <div className="posm-groups">
          {groupedPosms.map((group) => (
            <div key={group.depot_id} className="depot-group">
              <div className="depot-header">
                <h2>{group.depot_name}</h2>
                <span className="depot-code">{group.depot_code}</span>
                <span className="posm-count">({group.posms.length} POSM)</span>
              </div>
              <div className="posm-table-container">
                <table className="posm-table">
                  <thead>
                    <tr>
                      <th>POSM Adı</th>
                      <th>Açıklama</th>
                      <th>Hazır Adet</th>
                      <th>Revize Adet</th>
                      <th>Tamir Bekleyen</th>
                      <th>Toplam</th>
                    </tr>
                  </thead>
                  <tbody>
                    {group.posms.map((posm) => {
                      const total = posm.hazir_adet + posm.revize_adet + posm.tamir_bekleyen;
                      return (
                        <tr key={posm.id}>
                          <td className="posm-name">{posm.name}</td>
                          <td className="posm-description">
                            {posm.description || '-'}
                          </td>
                          <td className="stock-cell hazir">
                            {posm.hazir_adet}
                          </td>
                          <td className="stock-cell revize">
                            {posm.revize_adet}
                          </td>
                          <td className="stock-cell tamir">
                            {posm.tamir_bekleyen}
                          </td>
                          <td className="stock-cell total">
                            <strong>{total}</strong>
                          </td>
                        </tr>
                      );
                    })}
                  </tbody>
                </table>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default DepotPOSMPage;
