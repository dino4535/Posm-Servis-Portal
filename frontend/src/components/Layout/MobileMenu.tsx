import React, { useState, useEffect, Children } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import '../../styles/MobileMenu.css';

interface MobileMenuSectionProps {
  title: string;
  icon?: string;
  children: React.ReactNode;
  defaultOpen?: boolean;
}

const MobileMenuSection: React.FC<MobileMenuSectionProps> = ({ title, icon, children, defaultOpen = false }) => {
  const [isOpen, setIsOpen] = useState(defaultOpen);
  const location = useLocation();

  // Eğer alt menülerden biri aktifse, section'ı açık tut
  useEffect(() => {
    const checkActiveChild = () => {
      let hasActive = false;
      Children.forEach(children, (child: any) => {
        if (child?.props?.to) {
          const path = child.props.to;
          if (location.pathname === path || location.pathname.startsWith(path + '/')) {
            hasActive = true;
          }
        }
      });
      if (hasActive && !isOpen) {
        setIsOpen(true);
      }
    };
    checkActiveChild();
  }, [location.pathname, children, isOpen]);

  return (
    <div className="mobile-menu-section">
      <div 
        className="mobile-menu-section-header" 
        onClick={() => setIsOpen(!isOpen)}
      >
        {icon && <span className="mobile-menu-icon">{icon}</span>}
        <span className="mobile-menu-section-title">{title}</span>
        <span className={`mobile-menu-arrow ${isOpen ? 'open' : ''}`}>▼</span>
      </div>
      {isOpen && (
        <ul className="mobile-menu-section-items">
          {children}
        </ul>
      )}
    </div>
  );
};

const MobileMenu = () => {
  const [isOpen, setIsOpen] = useState(false);
  const { user, isAdmin, isTeknik } = useAuth();

  const closeMenu = () => setIsOpen(false);

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
        <div className="mobile-menu-overlay" onClick={closeMenu}>
          <nav className="mobile-menu" onClick={(e) => e.stopPropagation()}>
            <div className="mobile-menu-header">
              <h3>Teknik Servis Portalı</h3>
              <button onClick={closeMenu}>×</button>
            </div>
            <div className="mobile-user-info">
              <span className="mobile-user-name">{user?.name}</span>
              <span className="mobile-user-role">{user?.role}</span>
            </div>
            <div className="mobile-menu-nav">
              <ul className="mobile-main-menu">
                <li>
                  <NavLink to="/dashboard" end onClick={closeMenu}>
                    <span className="mobile-menu-icon">📊</span>
                    Dashboard
                  </NavLink>
                </li>
              </ul>

              <MobileMenuSection title="Talepler" icon="📋" defaultOpen={true}>
                <li>
                  <NavLink to="/new-request" onClick={closeMenu}>
                    <span className="mobile-menu-icon">➕</span>
                    Yeni Talep
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/my-requests" onClick={closeMenu}>
                    <span className="mobile-menu-icon">📝</span>
                    Taleplerim
                  </NavLink>
                </li>
                {(isAdmin || isTeknik) && (
                  <li>
                    <NavLink to="/all-requests" onClick={closeMenu}>
                      <span className="mobile-menu-icon">📋</span>
                      Tüm Talepler
                    </NavLink>
                  </li>
                )}
              </MobileMenuSection>

              <MobileMenuSection title="POSM" icon="📦">
                <li>
                  <NavLink to="/depot-posm" onClick={closeMenu}>
                    <span className="mobile-menu-icon">📦</span>
                    Depolarımdaki POSM'ler
                  </NavLink>
                </li>
                {(isAdmin || isTeknik) && (
                  <>
                    <li>
                      <NavLink to="/posm-management" onClick={closeMenu}>
                        <span className="mobile-menu-icon">⚙️</span>
                        POSM Yönetimi
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/posm-transfers" onClick={closeMenu}>
                        <span className="mobile-menu-icon">🔄</span>
                        POSM Transfer
                      </NavLink>
                    </li>
                  </>
                )}
              </MobileMenuSection>

              {isAdmin && (
                <>
                  <MobileMenuSection title="Yönetim" icon="⚙️">
                    <li>
                      <NavLink to="/user-management" onClick={closeMenu}>
                        <span className="mobile-menu-icon">👥</span>
                        Kullanıcı Yönetimi
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/depot-management" onClick={closeMenu}>
                        <span className="mobile-menu-icon">🏢</span>
                        Depo Yönetimi
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/territory-management" onClick={closeMenu}>
                        <span className="mobile-menu-icon">🗺️</span>
                        Territory Yönetimi
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/dealer-management" onClick={closeMenu}>
                        <span className="mobile-menu-icon">🏪</span>
                        Bayi Yönetimi
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/bulk-dealer-import" onClick={closeMenu}>
                        <span className="mobile-menu-icon">📥</span>
                        Toplu Bayi İçe Aktarma
                      </NavLink>
                    </li>
                  </MobileMenuSection>

                  <MobileMenuSection title="Raporlar & Loglar" icon="📊">
                    <li>
                      <NavLink to="/reports" onClick={closeMenu}>
                        <span className="mobile-menu-icon">📈</span>
                        Raporlar
                      </NavLink>
                    </li>
                    <li>
                      <NavLink to="/audit-logs" onClick={closeMenu}>
                        <span className="mobile-menu-icon">📜</span>
                        Audit Log
                      </NavLink>
                    </li>
                  </MobileMenuSection>
                </>
              )}
            </div>
          </nav>
        </div>
      )}
    </>
  );
};

export default MobileMenu;
