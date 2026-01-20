import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';
import '../styles/DepotSelector.css';

interface Depot {
  id: number;
  name: string;
  code: string;
}

interface DepotSelectorProps {
  selectedDepotId?: number;
  onDepotChange: (depotId: number) => void;
  required?: boolean;
}

const DepotSelector: React.FC<DepotSelectorProps> = ({
  selectedDepotId,
  onDepotChange,
  required = false,
}) => {
  const { user, isAdmin } = useAuth();
  const [depots, setDepots] = useState<Depot[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDepots = async () => {
      // Token kontrolü - sadece authenticated kullanıcılar için
      const token = localStorage.getItem('token');
      if (!token) {
        setLoading(false);
        return;
      }

      try {
        const response = await api.get('/depots');
        if (response.data.success) {
          setDepots(response.data.data);
          // İlk depoyu otomatik seç
          if (!selectedDepotId && response.data.data.length > 0) {
            onDepotChange(response.data.data[0].id);
          }
        }
      } catch (error: any) {
        // 401 hatası beklenen bir durum (token yoksa), sessizce geç
        if (error.response?.status !== 401) {
          console.error('Depolar yüklenirken hata:', error);
        }
      } finally {
        setLoading(false);
      }
    };
    fetchDepots();
  }, []);

  if (loading) {
    return <div className="depot-selector-loading">Yükleniyor...</div>;
  }

  if (depots.length === 0) {
    return <div className="depot-selector-error">Depo bulunamadı</div>;
  }

  // Admin değilse ve sadece 1 depo varsa, seçiciyi gizle
  if (!isAdmin && depots.length === 1) {
    return null;
  }

  return (
    <div className="depot-selector">
      <label htmlFor="depot-select">Depo Seçimi</label>
      <select
        id="depot-select"
        value={selectedDepotId || ''}
        onChange={(e) => onDepotChange(parseInt(e.target.value, 10))}
        required={required}
        className="depot-select"
      >
        <option value="">Depo Seçiniz</option>
        {depots.map((depot) => (
          <option key={depot.id} value={depot.id}>
            {depot.name} ({depot.code})
          </option>
        ))}
      </select>
    </div>
  );
};

export default DepotSelector;
