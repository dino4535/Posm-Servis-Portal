import { useAuth } from '../../context/AuthContext';
import { useNavigate, Link } from 'react-router-dom';
import { useDepot } from '../../hooks/useDepot';
import DepotSelector from '../DepotSelector';
import '../../styles/Header.css';

const Header = () => {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const { selectedDepot, depots, changeDepot, hasMultipleDepots } = useDepot();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <header className="header">
      <div className="header-content">
        <div className="header-brand">
          <img src="/Dinologo.png" alt="Dino Gıda" className="header-logo" />
          <h1 className="header-title">POSM Teknik Servis Portalı</h1>
        </div>
        <div className="header-actions">
          {hasMultipleDepots && (
            <div className="header-depot-selector">
              <DepotSelector
                selectedDepotId={selectedDepot?.id}
                onDepotChange={changeDepot}
              />
            </div>
          )}
          <Link to="/profile" className="user-name-link">
            <span className="user-name">{user?.name}</span>
          </Link>
          <button onClick={handleLogout} className="logout-button">
            Çıkış Yap
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;
