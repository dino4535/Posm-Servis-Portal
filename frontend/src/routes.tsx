import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import LoginPage from './pages/LoginPage';
import DashboardPage from './pages/DashboardPage';
import NewRequestPage from './pages/NewRequestPage';
import MyRequestsPage from './pages/MyRequestsPage';
import AllRequestsPage from './pages/AllRequestsPage';
import POSMManagementPage from './pages/POSMManagementPage';
import UserManagementPage from './pages/UserManagementPage';
import DepotManagementPage from './pages/DepotManagementPage';
import TerritoryManagementPage from './pages/TerritoryManagementPage';
import DealerManagementPage from './pages/DealerManagementPage';
import POSMTransferPage from './pages/POSMTransferPage';
import ReportsPage from './pages/ReportsPage';
import CustomReportDesignPage from './pages/CustomReportDesignPage';
import ScheduledReportsPage from './pages/ScheduledReportsPage';
import AuditLogPage from './pages/AuditLogPage';
import BulkDealerImportPage from './pages/BulkDealerImportPage';
import DashboardLayout from './components/Layout/DashboardLayout';

const PrivateRoute = ({ children }: { children: React.ReactNode }) => {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return <div>Yükleniyor...</div>;
  }

  return isAuthenticated ? <>{children}</> : <Navigate to="/login" />;
};

const AdminRoute = ({ children }: { children: React.ReactNode }) => {
  const { isAdmin, loading } = useAuth();

  if (loading) {
    return <div>Yükleniyor...</div>;
  }

  return isAdmin ? <>{children}</> : <Navigate to="/dashboard" />;
};

const AdminOrTeknikRoute = ({ children }: { children: React.ReactNode }) => {
  const { isAdmin, isTeknik, loading } = useAuth();

  if (loading) {
    return <div>Yükleniyor...</div>;
  }

  return (isAdmin || isTeknik) ? <>{children}</> : <Navigate to="/dashboard" />;
};

const AppRoutes = () => {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route
        path="/"
        element={
          <PrivateRoute>
            <DashboardLayout />
          </PrivateRoute>
        }
      >
        <Route index element={<Navigate to="/dashboard" />} />
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="new-request" element={<NewRequestPage />} />
        <Route path="my-requests" element={<MyRequestsPage />} />
        <Route
          path="all-requests"
          element={
            <AdminRoute>
              <AllRequestsPage />
            </AdminRoute>
          }
        />
        <Route
          path="posm-management"
          element={
            <AdminOrTeknikRoute>
              <POSMManagementPage />
            </AdminOrTeknikRoute>
          }
        />
        <Route
          path="posm-transfers"
          element={
            <AdminOrTeknikRoute>
              <POSMTransferPage />
            </AdminOrTeknikRoute>
          }
        />
        <Route
          path="user-management"
          element={
            <AdminRoute>
              <UserManagementPage />
            </AdminRoute>
          }
        />
        <Route
          path="depot-management"
          element={
            <AdminRoute>
              <DepotManagementPage />
            </AdminRoute>
          }
        />
        <Route
          path="territory-management"
          element={
            <AdminRoute>
              <TerritoryManagementPage />
            </AdminRoute>
          }
        />
        <Route
          path="dealer-management"
          element={
            <AdminRoute>
              <DealerManagementPage />
            </AdminRoute>
          }
        />
        <Route
          path="bulk-dealer-import"
          element={
            <AdminRoute>
              <BulkDealerImportPage />
            </AdminRoute>
          }
        />
        <Route
          path="reports"
          element={
            <AdminRoute>
              <ReportsPage />
            </AdminRoute>
          }
        />
        <Route
          path="custom-report-design"
          element={
            <AdminRoute>
              <CustomReportDesignPage />
            </AdminRoute>
          }
        />
        <Route
          path="scheduled-reports"
          element={
            <AdminRoute>
              <ScheduledReportsPage />
            </AdminRoute>
          }
        />
        <Route
          path="audit-logs"
          element={
            <AdminRoute>
              <AuditLogPage />
            </AdminRoute>
          }
        />
      </Route>
    </Routes>
  );
};

export default AppRoutes;
