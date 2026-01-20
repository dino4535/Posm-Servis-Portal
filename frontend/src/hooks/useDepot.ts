import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';

interface Depot {
  id: number;
  name: string;
  code: string;
}

export const useDepot = () => {
  const { user, isAdmin } = useAuth();
  const [selectedDepot, setSelectedDepot] = useState<Depot | null>(null);
  const [depots, setDepots] = useState<Depot[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchDepots = async () => {
      try {
        const response = await api.get('/depots');
        if (response.data.success) {
          const userDepots = response.data.data;
          setDepots(userDepots);
          
          // İlk depoyu otomatik seç
          if (userDepots.length > 0 && !selectedDepot) {
            setSelectedDepot(userDepots[0]);
          }
        }
      } catch (error) {
        console.error('Depolar yüklenirken hata:', error);
      } finally {
        setLoading(false);
      }
    };
    fetchDepots();
  }, []);

  const changeDepot = (depotId: number) => {
    const depot = depots.find((d) => d.id === depotId);
    if (depot) {
      setSelectedDepot(depot);
      localStorage.setItem('selectedDepotId', depotId.toString());
    }
  };

  // LocalStorage'dan seçili depoyu yükle
  useEffect(() => {
    const savedDepotId = localStorage.getItem('selectedDepotId');
    if (savedDepotId && depots.length > 0) {
      const depot = depots.find((d) => d.id === parseInt(savedDepotId, 10));
      if (depot) {
        setSelectedDepot(depot);
      }
    }
  }, [depots]);

  return {
    selectedDepot,
    depots,
    loading,
    changeDepot,
    hasMultipleDepots: depots.length > 1 || isAdmin,
  };
};
