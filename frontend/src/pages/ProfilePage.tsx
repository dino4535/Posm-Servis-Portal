import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import '../styles/ProfilePage.css';

const ProfilePage = () => {
  const { user, login } = useAuth();
  const { showSuccess, showError } = useToast();
  const [loading, setLoading] = useState(false);
  const [profileData, setProfileData] = useState({
    name: '',
    email: '',
  });
  const [passwordData, setPasswordData] = useState({
    currentPassword: '',
    newPassword: '',
    confirmPassword: '',
  });
  const [activeTab, setActiveTab] = useState<'profile' | 'password'>('profile');

  useEffect(() => {
    if (user) {
      setProfileData({
        name: user.name || '',
        email: user.email || '',
      });
    }
  }, [user]);

  const handleProfileUpdate = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      const response = await api.put('/auth/profile', profileData);
      if (response.data.success) {
        showSuccess('Profil bilgileri başarıyla güncellendi');
        // Kullanıcı bilgilerini yenile
        const meResponse = await api.get('/auth/me');
        if (meResponse.data.success) {
          // Auth context'i güncellemek için token'ı yeniden kaydet
          // Bu durumda sayfayı yenilemek daha basit
          window.location.reload();
        }
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Profil güncellenirken hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  const handlePasswordChange = async (e: React.FormEvent) => {
    e.preventDefault();

    if (passwordData.newPassword !== passwordData.confirmPassword) {
      showError('Yeni şifreler eşleşmiyor');
      return;
    }

    if (passwordData.newPassword.length < 6) {
      showError('Yeni şifre en az 6 karakter olmalıdır');
      return;
    }

    setLoading(true);

    try {
      const response = await api.post('/auth/change-password', {
        currentPassword: passwordData.currentPassword,
        newPassword: passwordData.newPassword,
      });

      if (response.data.success) {
        showSuccess('Şifre başarıyla değiştirildi');
        setPasswordData({
          currentPassword: '',
          newPassword: '',
          confirmPassword: '',
        });
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Şifre değiştirilirken hata oluştu');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="profile-page">
      <div className="profile-header">
        <h1>Profil Ayarları</h1>
        <p>Hesap bilgilerinizi ve şifrenizi buradan güncelleyebilirsiniz</p>
      </div>

      <div className="profile-tabs">
        <button
          className={`tab-button ${activeTab === 'profile' ? 'active' : ''}`}
          onClick={() => setActiveTab('profile')}
        >
          Profil Bilgileri
        </button>
        <button
          className={`tab-button ${activeTab === 'password' ? 'active' : ''}`}
          onClick={() => setActiveTab('password')}
        >
          Şifre Değiştir
        </button>
      </div>

      <div className="profile-content">
        {activeTab === 'profile' && (
          <div className="profile-section">
            <h2>Profil Bilgileri</h2>
            <form onSubmit={handleProfileUpdate} className="profile-form">
              <div className="form-group">
                <label>Ad Soyad *</label>
                <input
                  type="text"
                  value={profileData.name}
                  onChange={(e) => setProfileData({ ...profileData, name: e.target.value })}
                  required
                  placeholder="Ad Soyad"
                />
              </div>

              <div className="form-group">
                <label>E-posta *</label>
                <input
                  type="email"
                  value={profileData.email}
                  onChange={(e) => setProfileData({ ...profileData, email: e.target.value })}
                  required
                  placeholder="E-posta"
                />
              </div>

              <div className="form-group">
                <label>Rol</label>
                <input
                  type="text"
                  value={user?.role || ''}
                  disabled
                  className="disabled-input"
                />
                <small>Rol değiştirilemez</small>
              </div>

              {user?.depots && user.depots.length > 0 && (
                <div className="form-group">
                  <label>Atanmış Depolar</label>
                  <div className="depots-list">
                    {user.depots.map((depot) => (
                      <span key={depot.id} className="depot-badge">
                        {depot.name}
                      </span>
                    ))}
                  </div>
                </div>
              )}

              <div className="form-actions">
                <button type="submit" className="submit-button" disabled={loading}>
                  {loading ? 'Kaydediliyor...' : 'Kaydet'}
                </button>
              </div>
            </form>
          </div>
        )}

        {activeTab === 'password' && (
          <div className="profile-section">
            <h2>Şifre Değiştir</h2>
            <form onSubmit={handlePasswordChange} className="profile-form">
              <div className="form-group">
                <label>Mevcut Şifre *</label>
                <input
                  type="password"
                  value={passwordData.currentPassword}
                  onChange={(e) =>
                    setPasswordData({ ...passwordData, currentPassword: e.target.value })
                  }
                  required
                  placeholder="Mevcut şifrenizi girin"
                />
              </div>

              <div className="form-group">
                <label>Yeni Şifre *</label>
                <input
                  type="password"
                  value={passwordData.newPassword}
                  onChange={(e) =>
                    setPasswordData({ ...passwordData, newPassword: e.target.value })
                  }
                  required
                  minLength={6}
                  placeholder="Yeni şifrenizi girin (min. 6 karakter)"
                />
                <small>En az 6 karakter olmalıdır</small>
              </div>

              <div className="form-group">
                <label>Yeni Şifre (Tekrar) *</label>
                <input
                  type="password"
                  value={passwordData.confirmPassword}
                  onChange={(e) =>
                    setPasswordData({ ...passwordData, confirmPassword: e.target.value })
                  }
                  required
                  minLength={6}
                  placeholder="Yeni şifrenizi tekrar girin"
                />
              </div>

              <div className="form-actions">
                <button type="submit" className="submit-button" disabled={loading}>
                  {loading ? 'Değiştiriliyor...' : 'Şifreyi Değiştir'}
                </button>
              </div>
            </form>
          </div>
        )}
      </div>
    </div>
  );
};

export default ProfilePage;
