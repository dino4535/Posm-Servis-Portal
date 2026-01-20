import { useState } from 'react';
import '../styles/SearchFilters.css';

interface SearchFiltersProps {
  onFilterChange: (filters: any) => void;
  showDepotFilter?: boolean;
  showUserFilter?: boolean;
}

const SearchFilters: React.FC<SearchFiltersProps> = ({
  onFilterChange,
  showDepotFilter = false,
  showUserFilter = false,
}) => {
  const [filters, setFilters] = useState({
    search: '',
    durum: '',
    yapilacak_is: '',
    start_date: '',
    end_date: '',
    depot_id: '',
    user_id: '',
  });

  const handleFilterChange = (key: string, value: string) => {
    const newFilters = { ...filters, [key]: value };
    setFilters(newFilters);
    onFilterChange(newFilters);
  };

  const handleReset = () => {
    const resetFilters = {
      search: '',
      durum: '',
      yapilacak_is: '',
      start_date: '',
      end_date: '',
      depot_id: '',
      user_id: '',
    };
    setFilters(resetFilters);
    onFilterChange(resetFilters);
  };

  return (
    <div className="search-filters">
      <div className="filters-row">
        <div className="filter-group">
          <label>Arama</label>
          <input
            type="text"
            placeholder="Talep no, bayi adı..."
            value={filters.search}
            onChange={(e) => handleFilterChange('search', e.target.value)}
          />
        </div>

        <div className="filter-group">
          <label>Durum</label>
          <select
            value={filters.durum}
            onChange={(e) => handleFilterChange('durum', e.target.value)}
          >
            <option value="">Tümü</option>
            <option value="Beklemede">Beklemede</option>
            <option value="Planlandı">Planlandı</option>
            <option value="Tamamlandı">Tamamlandı</option>
            <option value="İptal">İptal</option>
          </select>
        </div>

        <div className="filter-group">
          <label>Yapılacak İş</label>
          <select
            value={filters.yapilacak_is}
            onChange={(e) => handleFilterChange('yapilacak_is', e.target.value)}
          >
            <option value="">Tümü</option>
            <option value="Montaj">Montaj</option>
            <option value="Demontaj">Demontaj</option>
            <option value="Bakım">Bakım</option>
          </select>
        </div>

        {showDepotFilter && (
          <div className="filter-group">
            <label>Depo</label>
            <select
              value={filters.depot_id}
              onChange={(e) => handleFilterChange('depot_id', e.target.value)}
            >
              <option value="">Tümü</option>
              {/* Depolar buraya eklenecek */}
            </select>
          </div>
        )}
      </div>

      <div className="filters-row">
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

        <div className="filter-actions">
          <button className="reset-button" onClick={handleReset}>
            Filtreleri Temizle
          </button>
        </div>
      </div>
    </div>
  );
};

export default SearchFilters;
