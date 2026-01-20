import { useState, useEffect, Children } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useAuth } from '../../context/AuthContext';
import '../../styles/Sidebar.css';

interface MenuSectionProps {
  title: string;
  icon?: string;
  children: React.ReactNode;
  defaultOpen?: boolean;
}

const MenuSection: React.FC<MenuSectionProps> = ({ title, icon, children, defaultOpen = false }) => {
  const [isOpen, setIsOpen] = useState(defaultOpen);
  const location = useLocation();
  
  // Eğer alt menülerden biri aktifse, section'ı açık tut
  useEffect(() => {
    const checkActiveChild = () => {
      let hasActive = false;
      Children.forEach(children, (child: any) => {
        if (child?.props?.children) {
          Children.forEach(child.props.children, (grandChild: any) => {
            if (grandChild?.props?.to) {
              const path = grandChild.props.to;
              if (location.pathname === path || location.pathname.startsWith(path + '/')) {
                hasActive = true;
              }
            }
          });
        }
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

  const shouldBeOpen = isOpen;

  return (
    <div className="menu-section">
      <div 
        className="menu-section-header" 
        onClick={() => setIsOpen(!isOpen)}
      >
        {icon && <span className="menu-icon">{icon}</span>}
        <span className="menu-section-title">{title}</span>
        <span className={`menu-arrow ${shouldBeOpen ? 'open' : ''}`}>▼</span>
      </div>
      {shouldBeOpen && (
        <ul className="menu-section-items">
          {children}
        </ul>
      )}
    </div>
  );
};

const Sidebar = () => {
  const { user, isAdmin, isTeknik } = useAuth();

  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <h3>Teknik Servis Portalı</h3>
      </div>
      <div className="user-info">
        <span className="user-name">{user?.name}</span>
        <span className="user-role">{user?.role}</span>
      </div>
      <nav className="sidebar-nav">
        <ul className="main-menu">
          <li>
            <NavLink to="/dashboard" end>
              <span className="menu-icon">📊</span>
              Dashboard
            </NavLink>
          </li>
        </ul>

        <MenuSection title="Talepler" icon="📋" defaultOpen={true}>
          <li>
            <NavLink to="/new-request">
              <span className="menu-icon">➕</span>
              Yeni Talep
            </NavLink>
          </li>
          <li>
            <NavLink to="/my-requests">
              <span className="menu-icon">📝</span>
              Taleplerim
            </NavLink>
          </li>
          {isAdmin && (
            <li>
              <NavLink to="/all-requests">
                <span className="menu-icon">📋</span>
                Tüm Talepler
              </NavLink>
            </li>
          )}
        </MenuSection>

        {(isAdmin || isTeknik) && (
          <MenuSection title="POSM İşlemleri" icon="📦">
            <li>
              <NavLink to="/posm-management">
                <span className="menu-icon">📦</span>
                POSM Yönetimi
              </NavLink>
            </li>
            <li>
              <NavLink to="/posm-transfers">
                <span className="menu-icon">🔄</span>
                POSM Transfer
              </NavLink>
            </li>
          </MenuSection>
        )}

        {isAdmin && (
          <>
            <MenuSection title="Yönetim" icon="⚙️">
              <li>
                <NavLink to="/user-management">
                  <span className="menu-icon">👥</span>
                  Kullanıcı Yönetimi
                </NavLink>
              </li>
              <li>
                <NavLink to="/depot-management">
                  <span className="menu-icon">🏢</span>
                  Depo Yönetimi
                </NavLink>
              </li>
              <li>
                <NavLink to="/territory-management">
                  <span className="menu-icon">🗺️</span>
                  Territory Yönetimi
                </NavLink>
              </li>
              <li>
                <NavLink to="/dealer-management">
                  <span className="menu-icon">🏪</span>
                  Bayi Yönetimi
                </NavLink>
              </li>
              <li>
                <NavLink to="/bulk-dealer-import">
                  <span className="menu-icon">📥</span>
                  Toplu Bayi İçe Aktarma
                </NavLink>
              </li>
            </MenuSection>

            <MenuSection title="Raporlar & Loglar" icon="📊">
              <li>
                <NavLink to="/reports">
                  <span className="menu-icon">📈</span>
                  Raporlar
                </NavLink>
              </li>
              <li>
                <NavLink to="/audit-logs">
                  <span className="menu-icon">📜</span>
                  Audit Log
                </NavLink>
              </li>
            </MenuSection>
          </>
        )}
      </nav>
    </aside>
  );
};

export default Sidebar;
