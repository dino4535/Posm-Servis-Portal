import { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import '../../styles/MobileMenu.css';

const MobileMenu = () => {
  const [isOpen, setIsOpen] = useState(false);
  const { user, isAdmin } = useAuth();

  return (
    <>
      <button
        className="mobile-menu-toggle"
        onClick={() => setIsOpen(!isOpen)}
        aria-label="Menu"
      >
        <span></span>
        <span></span>
        <span></span>
      </button>
      {isOpen && (
        <div className="mobile-menu-overlay" onClick={() => setIsOpen(false)}>
          <nav className="mobile-menu" onClick={(e) => e.stopPropagation()}>
            <div className="mobile-menu-header">
              <h3>Menü</h3>
              <button onClick={() => setIsOpen(false)}>×</button>
            </div>
            <div className="mobile-user-info">
              <span>{user?.name}</span>
              <span>{user?.role}</span>
            </div>
            <ul>
              <li>
                <NavLink to="/dashboard" onClick={() => setIsOpen(false)}>
                  Dashboard
                </NavLink>
              </li>
              <li>
                <NavLink to="/new-request" onClick={() => setIsOpen(false)}>
                  Yeni Talep
                </NavLink>
              </li>
              <li>
                <NavLink to="/my-requests" onClick={() => setIsOpen(false)}>
                  Taleplerim
                </NavLink>
              </li>
              {isAdmin && (
                <>
                  <li>
                    <NavLink to="/all-requests" onClick={() => setIsOpen(false)}>
                      Tüm Talepler
                    </NavLink>
                  </li>
                  <li>
                    <NavLink to="/posm-management" onClick={() => setIsOpen(false)}>
                      POSM Yönetimi
                    </NavLink>
                  </li>
                  <li>
                    <NavLink to="/user-management" onClick={() => setIsOpen(false)}>
                      Kullanıcı Yönetimi
                    </NavLink>
                  </li>
                  <li>
                    <NavLink to="/depot-management" onClick={() => setIsOpen(false)}>
                      Depo Yönetimi
                    </NavLink>
                  </li>
                </>
              )}
            </ul>
          </nav>
        </div>
      )}
    </>
  );
};

export default MobileMenu;
