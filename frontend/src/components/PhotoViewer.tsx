import { useState, useEffect } from 'react';
import api from '../services/api';
import '../styles/PhotoViewer.css';

interface Photo {
  id: number;
  file_name: string;
  file_path: string;
  file_size?: number;
  created_at: string;
}

interface PhotoViewerProps {
  requestId: number;
  isOpen: boolean;
  onClose: () => void;
  initialIndex?: number;
}

const PhotoViewer: React.FC<PhotoViewerProps> = ({ requestId, isOpen, onClose, initialIndex = 0 }) => {
  const [photos, setPhotos] = useState<Photo[]>([]);
  const [currentIndex, setCurrentIndex] = useState(initialIndex);
  const [loading, setLoading] = useState(true);
  const [photoUrls, setPhotoUrls] = useState<{ [key: number]: string }>({});

  useEffect(() => {
    if (isOpen && requestId) {
      fetchPhotos();
    }
  }, [isOpen, requestId]);

  useEffect(() => {
    if (isOpen && initialIndex !== undefined) {
      setCurrentIndex(initialIndex);
    }
  }, [isOpen, initialIndex]);

  const fetchPhotos = async () => {
    setLoading(true);
    try {
      const response = await api.get(`/photos/request/${requestId}`);
      if (response.data.success) {
        const photosData = response.data.data;
        setPhotos(photosData);
        setCurrentIndex(Math.min(initialIndex, photosData.length - 1));
        
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
            // Hata durumunda placeholder ekle
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

  // Base64 URL'ler için cleanup gerekmiyor (data URL'ler)

  const handlePrevious = () => {
    setCurrentIndex((prev) => (prev > 0 ? prev - 1 : photos.length - 1));
  };

  const handleNext = () => {
    setCurrentIndex((prev) => (prev < photos.length - 1 ? prev + 1 : 0));
  };

  const handleKeyDown = (e: KeyboardEvent) => {
    if (!isOpen) return;
    if (e.key === 'Escape') {
      onClose();
    } else if (e.key === 'ArrowLeft') {
      handlePrevious();
    } else if (e.key === 'ArrowRight') {
      handleNext();
    }
  };

  useEffect(() => {
    if (isOpen) {
      document.addEventListener('keydown', handleKeyDown);
      return () => document.removeEventListener('keydown', handleKeyDown);
    }
  }, [isOpen, photos.length, currentIndex]);

  if (!isOpen) return null;

  if (loading) {
    return (
      <div className="photo-viewer-overlay" onClick={onClose}>
        <div className="photo-viewer-content" onClick={(e) => e.stopPropagation()}>
          <div className="loading-message">Yükleniyor...</div>
        </div>
      </div>
    );
  }

  if (photos.length === 0) {
    return (
      <div className="photo-viewer-overlay" onClick={onClose}>
        <div className="photo-viewer-content" onClick={(e) => e.stopPropagation()}>
          <div className="no-photos-message">Bu talebe ait fotoğraf bulunmuyor</div>
          <button className="close-button" onClick={onClose}>×</button>
        </div>
      </div>
    );
  }

  const currentPhoto = photos[currentIndex];
  const photoUrl = photoUrls[currentPhoto.id] || '';

  return (
    <div className="photo-viewer-overlay" onClick={onClose}>
      <div className="photo-viewer-content" onClick={(e) => e.stopPropagation()}>
        <button className="close-button" onClick={onClose}>×</button>
        
        {photos.length > 1 && (
          <>
            <button className="nav-button prev-button" onClick={handlePrevious}>
              ‹
            </button>
            <button className="nav-button next-button" onClick={handleNext}>
              ›
            </button>
          </>
        )}

        <div className="photo-container">
          {photoUrl ? (
            <img src={photoUrl} alt={currentPhoto.file_name} className="main-photo" />
          ) : (
            <div className="loading-message">Fotoğraf yükleniyor...</div>
          )}
        </div>

        <div className="photo-info">
          <div className="photo-counter">
            {currentIndex + 1} / {photos.length}
          </div>
          <div className="photo-name">{currentPhoto.file_name}</div>
          {currentPhoto.created_at && (
            <div className="photo-date">
              {new Date(currentPhoto.created_at).toLocaleString('tr-TR', {
                timeZone: 'Europe/Istanbul',
              })}
            </div>
          )}
        </div>

        {photos.length > 1 && (
          <div className="photo-thumbnails">
            {photos.map((photo, index) => (
              <img
                key={photo.id}
                src={photoUrls[photo.id] || ''}
                alt={photo.file_name}
                className={`thumbnail ${index === currentIndex ? 'active' : ''}`}
                onClick={() => setCurrentIndex(index)}
                onError={(e) => {
                  (e.target as HTMLImageElement).style.display = 'none';
                }}
              />
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default PhotoViewer;
