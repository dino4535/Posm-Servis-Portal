import { useState, useRef, useEffect } from 'react';
import api from '../services/api';
import { useToast } from '../context/ToastContext';
import ConfirmModal from './ConfirmModal';
import { formatFileSize } from '../utils/helpers';
import PhotoViewer from './PhotoViewer';
import '../styles/PhotoUpload.css';

interface PhotoUploadProps {
  requestId: number;
  onUploadComplete?: () => void;
}

interface Photo {
  id: number;
  file_name: string;
  file_path: string;
  file_size?: number;
  created_at: string;
}

const PhotoUpload: React.FC<PhotoUploadProps> = ({ requestId, onUploadComplete }) => {
  const { showError } = useToast();
  const [selectedFiles, setSelectedFiles] = useState<File[]>([]);
  const [previews, setPreviews] = useState<string[]>([]);
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState(0);
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [loading, setLoading] = useState(true);
  const [showViewer, setShowViewer] = useState(false);
  const [selectedPhotoIndex, setSelectedPhotoIndex] = useState(0);
  const [photoUrls, setPhotoUrls] = useState<{ [key: number]: string }>({});
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [confirmModal, setConfirmModal] = useState<{
    isOpen: boolean;
    message: string;
    onConfirm: () => void;
    type?: 'danger' | 'warning' | 'info';
  }>({
    isOpen: false,
    message: '',
    onConfirm: () => {},
    type: 'danger',
  });

  // Mevcut fotoğrafları yükle
  useEffect(() => {
    const fetchPhotos = async () => {
      try {
        const response = await api.get(`/photos/request/${requestId}`);
        if (response.data.success) {
          const photosData = response.data.data;
          setPhotos(photosData);
          
          // Fotoğrafları base64 olarak yükle (blob yerine)
          const urls: { [key: number]: string } = {};
          for (const photo of photosData) {
            try {
              const photoResponse = await api.get(`/photos/${photo.id}/base64`);
              if (photoResponse.data.success && photoResponse.data.data.dataUrl) {
                urls[photo.id] = photoResponse.data.data.dataUrl;
              } else {
                urls[photo.id] = '';
              }
            } catch (error: any) {
              console.error(`Fotoğraf ${photo.id} yüklenirken hata:`, error);
              console.error('Error response:', error.response);
              // Hata durumunda boş string ekle
              urls[photo.id] = '';
            }
          }
          setPhotoUrls(urls);
        }
      } catch (error) {
        console.error('Fotoğraflar yüklenirken hata:', error);
      } finally {
        setLoading(false);
      }
    };
    if (requestId) {
      fetchPhotos();
    }
    
    // Cleanup blob URLs
    return () => {
      Object.values(photoUrls).forEach((url) => {
        if (url) {
          URL.revokeObjectURL(url);
        }
      });
    };
  }, [requestId]);

  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = Array.from(e.target.files || []);
    if (files.length === 0) return;

    // Maksimum 10 dosya
    const newFiles = files.slice(0, 10 - selectedFiles.length);
    setSelectedFiles([...selectedFiles, ...newFiles]);

    // Önizlemeler oluştur
    newFiles.forEach((file) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        setPreviews((prev) => [...prev, e.target?.result as string]);
      };
      reader.readAsDataURL(file);
    });
  };

  const removeFile = (index: number) => {
    setSelectedFiles(selectedFiles.filter((_, i) => i !== index));
    setPreviews(previews.filter((_, i) => i !== index));
  };

  const handleUpload = async () => {
    if (selectedFiles.length === 0) return;

    setUploading(true);
    setUploadProgress(0);

    try {
      const formData = new FormData();
      selectedFiles.forEach((file) => {
        formData.append('photo', file);
      });
      formData.append('request_id', requestId.toString());

      // FormData için Content-Type header'ını kaldır - browser otomatik ekler (boundary ile)
      const response = await api.post('/photos', formData, {
        onUploadProgress: (progressEvent) => {
          if (progressEvent.total) {
            const percentCompleted = Math.round(
              (progressEvent.loaded * 100) / progressEvent.total
            );
            setUploadProgress(percentCompleted);
          }
        },
      });

      if (response.data.success) {
        setSelectedFiles([]);
        setPreviews([]);
        setUploadProgress(0);
        if (onUploadComplete) {
          onUploadComplete();
        }
        // Fotoğrafları yeniden yükle
        const photosResponse = await api.get(`/photos/request/${requestId}`);
        if (photosResponse.data.success) {
          const photosData = photosResponse.data.data;
          setPhotos(photosData);
          
          // Fotoğrafları base64 olarak yükle (blob yerine)
          const urls: { [key: number]: string } = {};
          for (const photo of photosData) {
            try {
              const photoResponse = await api.get(`/photos/${photo.id}/base64`);
              if (photoResponse.data.success && photoResponse.data.data.dataUrl) {
                urls[photo.id] = photoResponse.data.data.dataUrl;
              } else {
                urls[photo.id] = '';
              }
            } catch (error: any) {
              console.error(`Fotoğraf ${photo.id} yüklenirken hata:`, error);
              console.error('Error response:', error.response);
              // Hata durumunda boş string ekle
              urls[photo.id] = '';
            }
          }
          setPhotoUrls(urls);
        }
      }
    } catch (error: any) {
      showError(error.response?.data?.error || 'Fotoğraf yüklenirken hata oluştu');
    } finally {
      setUploading(false);
    }
  };

  const handleDeletePhoto = async (photoId: number) => {
    setConfirmModal({
      isOpen: true,
      message: 'Bu fotoğrafı silmek istediğinize emin misiniz?',
      type: 'danger',
      onConfirm: async () => {
        setConfirmModal({ ...confirmModal, isOpen: false });
        try {
          await api.delete(`/photos/${photoId}`);
          setPhotos(photos.filter((p) => p.id !== photoId));
        } catch (error: any) {
          showError(error.response?.data?.error || 'Fotoğraf silinirken hata oluştu');
        }
      },
    });
  };

  return (
    <div className="photo-upload-container">
      <div className="photo-upload-section">
        <label className="upload-label">Fotoğraf Yükle *</label>
        <div className="photo-description">
          <p>
            <strong>Önemli:</strong> Fotoğraf POSM'in montaj edileceği yerden veya POSM'in kendisinden olmalıdır.
          </p>
        </div>
        <div className="upload-area" onClick={() => fileInputRef.current?.click()}>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            multiple
            onChange={handleFileSelect}
            style={{ display: 'none' }}
          />
          <div className="upload-icon">📷</div>
          <p>Fotoğraf seçmek için tıklayın</p>
          <span className="upload-hint">Maksimum 10 fotoğraf (JPG, PNG)</span>
        </div>

        {selectedFiles.length > 0 && (
          <div className="selected-files">
            <h4>Seçilen Fotoğraflar ({selectedFiles.length})</h4>
            <div className="preview-grid">
              {previews.map((preview, index) => (
                <div key={index} className="preview-item">
                  <img src={preview} alt={`Preview ${index + 1}`} />
                  <button
                    className="remove-preview"
                    onClick={() => removeFile(index)}
                    type="button"
                  >
                    ×
                  </button>
                  <span className="file-name">{selectedFiles[index].name}</span>
                  <span className="file-size">
                    {formatFileSize(selectedFiles[index].size)}
                  </span>
                </div>
              ))}
            </div>
            <button
              className="upload-button"
              onClick={handleUpload}
              disabled={uploading}
            >
              {uploading ? (
                <>
                  <span className="spinner"></span>
                  Yükleniyor... {uploadProgress}%
                </>
              ) : (
                'Fotoğrafları Yükle'
              )}
            </button>
            {uploading && (
              <div className="progress-bar">
                <div
                  className="progress-fill"
                  style={{ width: `${uploadProgress}%` }}
                ></div>
              </div>
            )}
          </div>
        )}
      </div>

      {photos.length > 0 && (
        <div className="photos-gallery">
          <h4>Yüklenen Fotoğraflar ({photos.length})</h4>
          <div className="gallery-grid">
            {photos.map((photo, index) => (
              <div key={photo.id} className="gallery-item">
                <img
                  src={photoUrls[photo.id] || ''}
                  alt={photo.file_name}
                  onClick={() => {
                    setSelectedPhotoIndex(index);
                    setShowViewer(true);
                  }}
                  style={{ cursor: 'pointer' }}
                  onError={(e) => {
                    (e.target as HTMLImageElement).style.display = 'none';
                  }}
                />
                <div className="gallery-overlay">
                  <button
                    className="view-photo-button"
                    onClick={() => {
                      setSelectedPhotoIndex(index);
                      setShowViewer(true);
                    }}
                    type="button"
                  >
                    👁️ Görüntüle
                  </button>
                  <button
                    className="delete-photo-button"
                    onClick={() => handleDeletePhoto(photo.id)}
                    type="button"
                  >
                    🗑️ Sil
                  </button>
                </div>
                <span className="photo-name">{photo.file_name}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      {showViewer && (
        <PhotoViewer
          requestId={requestId}
          isOpen={showViewer}
          onClose={() => setShowViewer(false)}
          initialIndex={selectedPhotoIndex}
        />
      )}

      <ConfirmModal
        isOpen={confirmModal.isOpen}
        title="Onay"
        message={confirmModal.message}
        type={confirmModal.type}
        onConfirm={confirmModal.onConfirm}
        onCancel={() => setConfirmModal({ ...confirmModal, isOpen: false })}
      />
    </div>
  );
};

export default PhotoUpload;
