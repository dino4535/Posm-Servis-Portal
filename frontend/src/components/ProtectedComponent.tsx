import { ReactNode } from 'react';
import { useAuth } from '../context/AuthContext';

interface ProtectedComponentProps {
  children: ReactNode;
  allowedRoles?: string[];
  requireDepot?: boolean;
}

const ProtectedComponent: React.FC<ProtectedComponentProps> = ({
  children,
  allowedRoles,
  requireDepot = false,
}) => {
  const { user, isAdmin } = useAuth();

  if (!user) {
    return null;
  }

  // Rol kontrolü
  if (allowedRoles && !allowedRoles.includes(user.role)) {
    return null;
  }

  // Admin her şeyi görebilir
  if (isAdmin) {
    return <>{children}</>;
  }

  // Depo kontrolü (eğer gerekliyse)
  if (requireDepot && (!user.depots || user.depots.length === 0)) {
    return null;
  }

  return <>{children}</>;
};

export default ProtectedComponent;
