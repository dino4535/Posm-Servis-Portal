import { useEffect, useState } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';
import '../styles/DashboardPage.css';

interface DashboardCounts {
  open: number;
  completed: number;
  pending: number;
}

const DashboardPage = () => {
  const { user } = useAuth();
  const [counts, setCounts] = useState<DashboardCounts>({
    open: 0,
    completed: 0,
    pending: 0,
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchCounts = async () => {
      try {
        const response = await api.get('/requests/dashboard/counts');
        if (response.data.success) {
          setCounts(response.data.data);
        }
      } catch (error) {
        console.error('Dashboard verileri yüklenirken hata:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchCounts();
  }, []);

  if (loading) {
    return <div className="loading">Yükleniyor...</div>;
  }

  return (
    <div className="dashboard-page">
      <h2>Hoş Geldiniz, {user?.name}</h2>
      <div className="summary-cards">
        <div className="summary-card">
          <h3>Açık Talepler</h3>
          <p className="count">{counts.open}</p>
        </div>
        <div className="summary-card">
          <h3>Tamamlanan Talepler</h3>
          <p className="count">{counts.completed}</p>
        </div>
        <div className="summary-card">
          <h3>Bekleyen Talepler</h3>
          <p className="count">{counts.pending}</p>
        </div>
      </div>
    </div>
  );
};

export default DashboardPage;
