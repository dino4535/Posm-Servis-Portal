import { useState, useEffect, useRef, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useToast } from '../context/ToastContext';
import api from '../services/api';
import PhotoUpload from '../components/PhotoUpload';
import { PRIORITY } from '../utils/constants';
import '../styles/NewRequestPage.css';

const NewRequestPage = () => {
  const { user } = useAuth();
  const { showError, showWarning } = useToast();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [createdRequestId, setCreatedRequestId] = useState<number | null>(null);
  const [formData, setFormData] = useState({
    depot_id: '',
    territory_id: '',
    dealer_id: '',
    yapilacak_is: '',
    yapilacak_is_detay: '',
    istenen_tarih: '',
    posm_id: '',
    priority: '0', // 0: Normal, 1: Yüksek, 2: Acil
  });
  const [depots, setDepots] = useState<any[]>([]);
  const [territories, setTerritories] = useState<any[]>([]);
  const [dealers, setDealers] = useState<any[]>([]);
  const [posms, setPosms] = useState<any[]>([]);
  const [selectedPosmInfo, setSelectedPosmInfo] = useState<any>(null);
  const [selectedDealer, setSelectedDealer] = useState<any>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [showPosmSection, setShowPosmSection] = useState(false);
  const [photos, setPhotos] = useState<any[]>([]);
  const [photoError, setPhotoError] = useState('');
  const [showDealerDropdown, setShowDealerDropdown] = useState(false);
  const dateInputRef = useRef<HTMLInputElement>(null);
  const searchTimeoutRef = useRef<NodeJS.Timeout | null>(null);
  const dealerSearchRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
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
    fetchDepots();
    
    // Cleanup: component unmount olduğunda timeout'u temizle
    return () => {
      if (searchTimeoutRef.current) {
        clearTimeout(searchTimeoutRef.current);
      }
    };
  }, []);

  useEffect(() => {
    if (formData.depot_id) {
      const fetchTerritories = async () => {
        try {
          const response = await api.get(`/territories?depot_id=${formData.depot_id}`);
          if (response.data.success) {
            setTerritories(response.data.data);
          }
        } catch (error) {
          console.error('Territories yüklenirken hata:', error);
        }
      };
      fetchTerritories();
    }
  }, [formData.depot_id]);

  useEffect(() => {
    if (formData.territory_id) {
      // Territory seçildiğinde, territory'ye göre tüm bayileri getir (dropdown'da gösterilmek üzere)
      // Not: Territory değiştiğinde onChange handler'ında searchTerm temizlendiği için
      // burada sadece territory'nin bayilerini getiriyoruz
      const fetchDealers = async () => {
        try {
          const response = await api.get(`/dealers?territory_id=${formData.territory_id}`);
          if (response.data.success) {
            setDealers(response.data.data);
            setShowDealerDropdown(response.data.data.length > 0);
          }
        } catch (error) {
          console.error('Bayiler yüklenirken hata:', error);
        }
      };
      fetchDealers();
    } else {
      // Territory seçilmediyse, bayi listesini temizle
      setDealers([]);
      setSelectedDealer(null);
      setFormData((prev) => ({ ...prev, dealer_id: '' }));
      setSearchTerm('');
      setShowDealerDropdown(false);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [formData.territory_id]);

  useEffect(() => {
    if (formData.depot_id && (formData.yapilacak_is === 'Montaj' || formData.yapilacak_is === 'Demontaj')) {
      const fetchPOSM = async () => {
        try {
          const response = await api.get(`/posm?depot_id=${formData.depot_id}`);
          if (response.data.success) {
            setPosms(response.data.data);
            // Eğer seçili POSM varsa ve yeni depoda yoksa, temizle
            if (formData.posm_id) {
              const posmExists = response.data.data.find((p: any) => p.id.toString() === formData.posm_id);
              if (!posmExists) {
                setFormData((prev) => ({ ...prev, posm_id: '' }));
                setSelectedPosmInfo(null);
              } else {
                setSelectedPosmInfo(posmExists);
              }
            }
          }
        } catch (error) {
          console.error('POSM yüklenirken hata:', error);
        }
      };
      fetchPOSM();
      setShowPosmSection(true);
    } else {
      setShowPosmSection(false);
      setSelectedPosmInfo(null);
    }
  }, [formData.depot_id, formData.yapilacak_is]);

  useEffect(() => {
    // Talep oluşturulduktan sonra fotoğrafları kontrol et
    if (createdRequestId) {
      const fetchPhotos = async () => {
        try {
          const response = await api.get(`/photos/request/${createdRequestId}`);
          if (response.data.success) {
            setPhotos(response.data.data);
            setPhotoError('');
          }
        } catch (error) {
          console.error('Fotoğraflar yüklenirken hata:', error);
        }
      };
      const interval = setInterval(fetchPhotos, 2000); // Her 2 saniyede bir kontrol et
      fetchPhotos();
      return () => clearInterval(interval);
    }
  }, [createdRequestId]);

  const handleSearchDealer = useCallback(async () => {
    if (searchTerm.length < 2) {
      // Arama terimi kısa ise, territory'ye göre bayi listesini getir
      if (formData.territory_id) {
        const response = await api.get(`/dealers?territory_id=${formData.territory_id}`);
        if (response.data.success) {
          setDealers(response.data.data);
          setShowDealerDropdown(response.data.data.length > 0);
        }
      } else {
        setDealers([]);
        setShowDealerDropdown(false);
      }
      return;
    }
    try {
      // Territory seçiliyse, arama sadece o territory'nin bayilerinde yapılacak
      const params = new URLSearchParams();
      params.append('q', searchTerm);
      if (formData.territory_id) {
        params.append('territory_id', formData.territory_id);
      }
      
      const response = await api.get(`/dealers/search?${params.toString()}`);
      if (response.data.success) {
        const searchResults = response.data.data;
        setDealers(searchResults);
        setShowDealerDropdown(searchResults.length > 0);
        
        // Eğer tek bir sonuç varsa otomatik seç
        if (searchResults.length === 1) {
          setSelectedDealer(searchResults[0]);
          setFormData((prev) => ({ ...prev, dealer_id: searchResults[0].id.toString() }));
          setSearchTerm(`${searchResults[0].code} - ${searchResults[0].name}`);
          setShowDealerDropdown(false);
        } else if (searchResults.length > 1) {
          // Birden fazla sonuç varsa, tam eşleşme kontrolü yap
          const exactMatch = searchResults.find(
            (dealer: any) =>
              dealer.name.toLowerCase().trim() === searchTerm.toLowerCase().trim() ||
              dealer.code.toLowerCase().trim() === searchTerm.toLowerCase().trim()
          );
          if (exactMatch) {
            setSelectedDealer(exactMatch);
            setFormData((prev) => ({ ...prev, dealer_id: exactMatch.id.toString() }));
            setSearchTerm(`${exactMatch.code} - ${exactMatch.name}`);
            setShowDealerDropdown(false);
          } else {
            // Tam eşleşme yoksa, dropdown'ı göster
            setSelectedDealer(null);
            setFormData((prev) => ({ ...prev, dealer_id: '' }));
          }
        } else {
          // Sonuç yoksa, dropdown'ı gizle
          setSelectedDealer(null);
          setFormData((prev) => ({ ...prev, dealer_id: '' }));
          setShowDealerDropdown(false);
        }
      }
    } catch (error) {
      console.error('Bayi arama hatası:', error);
    }
  }, [searchTerm, formData.territory_id]);

  const handleSelectDealer = (dealer: any) => {
    setSelectedDealer(dealer);
    setFormData((prev) => ({ ...prev, dealer_id: dealer.id.toString() }));
    setSearchTerm(`${dealer.code} - ${dealer.name}`);
    setShowDealerDropdown(false);
  };

  // Dışarı tıklandığında dropdown'ı kapat
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (dealerSearchRef.current && !dealerSearchRef.current.contains(event.target as Node)) {
        setShowDealerDropdown(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, []);


  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Bayi kontrolü
    if (!selectedDealer && !formData.dealer_id) {
      showWarning('Lütfen bir bayi seçin');
      return;
    }

    setLoading(true);
    setPhotoError('');

    try {
      const response = await api.post('/requests', {
        ...formData,
        depot_id: parseInt(formData.depot_id, 10),
        territory_id: parseInt(formData.territory_id, 10),
        dealer_id: selectedDealer?.id || parseInt(formData.dealer_id, 10),
        posm_id: formData.posm_id ? parseInt(formData.posm_id, 10) : null,
        priority: parseInt(formData.priority, 10),
      });
      if (response.data.success) {
        setCreatedRequestId(response.data.data.id);
        // Talep oluşturuldu, fotoğraflar talep oluşturulduktan sonra yüklenecek
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Talep oluşturulurken hata oluştu');
      setLoading(false);
    }
  };

  const handlePhotoUploadComplete = () => {
    // Fotoğraflar yüklendi, listeyi güncelle
    if (createdRequestId) {
      const fetchPhotos = async () => {
        try {
          const response = await api.get(`/photos/request/${createdRequestId}`);
          if (response.data.success) {
            setPhotos(response.data.data);
            setPhotoError('');
          }
        } catch (error) {
          console.error('Fotoğraflar yüklenirken hata:', error);
        }
      };
      fetchPhotos();
    }
  };

  const handleFinish = () => {
    if (photos.length === 0) {
      setPhotoError('Lütfen en az bir fotoğraf yükleyin. Fotoğraf POSM\'in montaj edileceği yer veya POSM\'den olmalıdır.');
      return;
    }
    navigate('/my-requests');
  };

  // Bugünün tarihini formatla (YYYY-MM-DD)
  const getTodayDate = () => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  // Gelecek 1 yıl içindeki tarihleri seçilebilir yap
  const getMaxDate = () => {
    const maxDate = new Date();
    maxDate.setFullYear(maxDate.getFullYear() + 1);
    const year = maxDate.getFullYear();
    const month = String(maxDate.getMonth() + 1).padStart(2, '0');
    const day = String(maxDate.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  if (createdRequestId) {
    return (
      <div className="new-request-page">
        <div className="request-created-section">
          <h2>Talep Oluşturuldu</h2>
          <p className="success-message">
            Talep başarıyla oluşturuldu. Lütfen en az bir fotoğraf yükleyin.
          </p>
          <div className="photo-requirement-info">
            <h3>Fotoğraf Gereksinimleri</h3>
            <ul>
              <li>✅ En az 1 fotoğraf yüklenmelidir</li>
              <li>📸 Fotoğraf POSM'in montaj edileceği yerden olmalıdır</li>
              <li>📷 Veya POSM'in kendisinden fotoğraf eklenebilir</li>
            </ul>
          </div>

          <PhotoUpload
            requestId={createdRequestId}
            onUploadComplete={handlePhotoUploadComplete}
          />

          {photoError && (
            <div className="error-message">{photoError}</div>
          )}

          <div className="photo-status">
            <p>
              Yüklenen Fotoğraf: <strong>{photos.length}</strong>
            </p>
            {photos.length > 0 && (
              <button className="finish-button" onClick={handleFinish}>
                Tamamla ve Taleplerime Git
              </button>
            )}
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="new-request-page">
      <h2>Yeni Teknik Servis Talebi</h2>
      <form onSubmit={handleSubmit} className="request-form">
        <div className="form-group">
          <label>Depo *</label>
          <select
            value={formData.depot_id}
            onChange={(e) => setFormData({ ...formData, depot_id: e.target.value, territory_id: '' })}
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
          <label>Territory *</label>
          <select
            value={formData.territory_id}
            onChange={(e) => {
              setFormData({ ...formData, territory_id: e.target.value, dealer_id: '' });
              setSelectedDealer(null);
              setSearchTerm('');
              setDealers([]);
              setShowDealerDropdown(false);
            }}
            required
            disabled={!formData.depot_id}
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
          <label>Bayi Ara</label>
          <div className="search-container">
            <input
              type="text"
              placeholder="Bayi kodu veya adı ile arayın..."
              value={searchTerm}
              onChange={(e) => {
                const value = e.target.value;
                setSearchTerm(value);
                setShowDealerDropdown(true);
                
                // Önceki timeout'u temizle
                if (searchTimeoutRef.current) {
                  clearTimeout(searchTimeoutRef.current);
                }
                
                // Eğer arama terimi temizlendiyse, seçili bayi'yi de temizle
                if (value.length === 0) {
                  setSelectedDealer(null);
                  setFormData((prev) => ({ ...prev, dealer_id: '' }));
                  // Territory'ye göre bayi listesini getir
                  if (formData.territory_id) {
                    const fetchDealers = async () => {
                      try {
                        const response = await api.get(`/dealers?territory_id=${formData.territory_id}`);
                        if (response.data.success) {
                          setDealers(response.data.data);
                          setShowDealerDropdown(response.data.data.length > 0);
                        }
                      } catch (error) {
                        console.error('Bayiler yüklenirken hata:', error);
                      }
                    };
                    fetchDealers();
                  } else {
                    setDealers([]);
                    setShowDealerDropdown(false);
                  }
                } else if (value.length >= 2) {
                  // Debounce ile arama yap (300ms)
                  searchTimeoutRef.current = setTimeout(() => {
                    handleSearchDealer();
                  }, 300);
                } else {
                  setDealers([]);
                  setShowDealerDropdown(false);
                }
              }}
              onFocus={() => {
                // Input'a focus olduğunda, eğer sonuç varsa dropdown'ı göster
                if (dealers.length > 0) {
                  setShowDealerDropdown(true);
                } else if (formData.territory_id && searchTerm.length === 0) {
                  // Territory seçiliyse ve arama yoksa, territory'ye göre listeyi göster
                  const fetchDealers = async () => {
                    try {
                      const response = await api.get(`/dealers?territory_id=${formData.territory_id}`);
                      if (response.data.success) {
                        setDealers(response.data.data);
                        setShowDealerDropdown(response.data.data.length > 0);
                      }
                    } catch (error) {
                      console.error('Bayiler yüklenirken hata:', error);
                    }
                  };
                  fetchDealers();
                }
              }}
              onKeyDown={(e) => {
                // Escape tuşu ile dropdown'ı kapat
                if (e.key === 'Escape') {
                  setShowDealerDropdown(false);
                }
              }}
            />
            {showDealerDropdown && dealers.length > 0 && (
              <div className="dealer-dropdown">
                {dealers.map((dealer) => (
                  <div
                    key={dealer.id}
                    className="dealer-dropdown-item"
                    onClick={() => handleSelectDealer(dealer)}
                  >
                    <div className="dealer-code">{dealer.code}</div>
                    <div className="dealer-name">{dealer.name}</div>
                    {dealer.territory_name && (
                      <div className="dealer-territory">{dealer.territory_name}</div>
                    )}
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>

        {selectedDealer && (
          <div className="form-group">
            <label>Seçilen Bayi</label>
            <div className="selected-dealer-info">
              <strong>{selectedDealer.code} - {selectedDealer.name}</strong>
              {selectedDealer.territory_name && (
                <span className="dealer-territory-info">({selectedDealer.territory_name})</span>
              )}
              <button
                type="button"
                className="clear-dealer-button"
                onClick={() => {
                  setSelectedDealer(null);
                  setFormData((prev) => ({ ...prev, dealer_id: '' }));
                  setSearchTerm('');
                }}
              >
                ✕
              </button>
            </div>
          </div>
        )}

        <div className="form-group">
          <label>Yapılacak İş *</label>
          <select
            value={formData.yapilacak_is}
              onChange={(e) => {
                setFormData({ ...formData, yapilacak_is: e.target.value, posm_id: '' });
                setSelectedPosmInfo(null);
              }}
            required
          >
            <option value="">Seçiniz</option>
            <option value="Montaj">Montaj</option>
            <option value="Demontaj">Demontaj</option>
            <option value="Bakım">Bakım</option>
          </select>
        </div>

        <div className="form-group">
          <label>Yapılacak İşler Detayı</label>
          <textarea
            value={formData.yapilacak_is_detay}
            onChange={(e) => setFormData({ ...formData, yapilacak_is_detay: e.target.value })}
            rows={4}
            placeholder="Yapılacak işlerin detaylarını buraya yazın..."
          />
        </div>

        <div className="form-group">
          <label>İstenen Tarih *</label>
          <div className="date-input-wrapper">
            <input
              ref={dateInputRef}
              type="date"
              value={formData.istenen_tarih}
              onChange={(e) => setFormData({ ...formData, istenen_tarih: e.target.value })}
              min={getTodayDate()}
              max={getMaxDate()}
              required
              className="date-input"
            />
            <span className="date-hint">Bugünden itibaren 1 yıl içinde bir tarih seçin</span>
          </div>
        </div>

        <div className="form-group">
          <label>Öncelik *</label>
          <select
            value={formData.priority}
            onChange={(e) => setFormData({ ...formData, priority: e.target.value })}
            required
          >
            <option value={PRIORITY.NORMAL.toString()}>Normal</option>
            <option value={PRIORITY.HIGH.toString()}>Yüksek</option>
            <option value={PRIORITY.URGENT.toString()}>Acil</option>
          </select>
        </div>

        {showPosmSection && (
          <div className="form-group">
            <label>POSM Seçimi *</label>
            <select
              value={formData.posm_id}
              onChange={(e) => {
                const selectedPosm = posms.find((p) => p.id.toString() === e.target.value);
                setSelectedPosmInfo(selectedPosm || null);
                setFormData({ ...formData, posm_id: e.target.value });
              }}
              required
            >
              <option value="">POSM Seçiniz</option>
              {posms.map((posm) => (
                <option key={posm.id} value={posm.id}>
                  {posm.name}
                </option>
              ))}
            </select>
            {selectedPosmInfo && (
              <div style={{ 
                marginTop: '8px', 
                padding: '10px', 
                background: (formData.yapilacak_is === 'Montaj' && selectedPosmInfo.hazir_adet > 0) || formData.yapilacak_is === 'Demontaj' ? '#d4edda' : '#f8d7da',
                border: `1px solid ${(formData.yapilacak_is === 'Montaj' && selectedPosmInfo.hazir_adet > 0) || formData.yapilacak_is === 'Demontaj' ? '#c3e6cb' : '#f5c6cb'}`,
                borderRadius: '4px',
                fontSize: '13px',
                color: (formData.yapilacak_is === 'Montaj' && selectedPosmInfo.hazir_adet > 0) || formData.yapilacak_is === 'Demontaj' ? '#155724' : '#721c24'
              }}>
                <strong>Envanter Bilgisi:</strong><br />
                Hazır Adet: <strong>{selectedPosmInfo.hazir_adet || 0}</strong><br />
                Revize Adet: <strong style={{ color: selectedPosmInfo.revize_adet > 0 ? '#e67e22' : '#155724' }}>
                  {selectedPosmInfo.revize_adet || 0}
                </strong><br />
                Tamir Bekleyen: <strong>{selectedPosmInfo.tamir_bekleyen || 0}</strong><br />
                {formData.yapilacak_is === 'Montaj' && selectedPosmInfo.hazir_adet <= 0 && (
                  <span style={{ color: '#721c24', fontWeight: 'bold' }}>
                    ⚠️ Bu POSM için hazır adet bulunmamaktadır! (Sadece Montaj için gerekli)
                  </span>
                )}
                {formData.yapilacak_is === 'Demontaj' && (
                  <span style={{ color: '#155724', fontSize: '12px', fontStyle: 'italic' }}>
                    ℹ️ Demontaj işleminde hazır stoktan düşülmez, mevcut POSM sökülür.
                  </span>
                )}
              </div>
            )}
          </div>
        )}

        <div className="form-group">
          <div className="photo-info-box">
            <p>
              <strong>📸 Fotoğraf Bilgisi:</strong> Talep oluşturulduktan sonra fotoğraf yükleme ekranı açılacaktır. 
              En az 1 fotoğraf yüklenmesi zorunludur.
            </p>
          </div>
        </div>

        <button type="submit" className="submit-button" disabled={loading}>
          {loading ? 'Oluşturuluyor...' : 'Talep Oluştur'}
        </button>
      </form>
    </div>
  );
};

export default NewRequestPage;
