"""
Hızlı Admin Kullanıcı Oluşturma Scripti
Sunucuda çalıştırmak için: python create_admin_user_quick.py
"""
import sys
import os

# Backend dizinine geç
backend_dir = os.path.join(os.path.dirname(__file__), 'backend')
sys.path.insert(0, backend_dir)

from sqlalchemy.orm import Session
from app.db.session import SessionLocal
from app.models.user import User
from app.core.security import get_password_hash

def create_admin():
    """Admin kullanıcı oluştur"""
    db: Session = SessionLocal()
    
    try:
        # Mevcut admin'i kontrol et
        existing = db.query(User).filter(User.email == "admin@example.com").first()
        if existing:
            print("⚠️  Admin kullanıcı zaten mevcut!")
            print(f"   Email: {existing.email}")
            print(f"   ID: {existing.id}")
            return
        
        # Yeni admin oluştur
        password = "Admin123!"
        admin_user = User(
            name="Admin Kullanıcı",
            email="admin@example.com",
            password_hash=get_password_hash(password),
            role="admin"
        )
        
        db.add(admin_user)
        db.commit()
        db.refresh(admin_user)
        
        print("✅ Admin kullanıcı başarıyla oluşturuldu!")
        print(f"   ID: {admin_user.id}")
        print(f"   Email: {admin_user.email}")
        print(f"   Şifre: {password}")
        print(f"   Rol: {admin_user.role}")
        print("\n⚠️  İlk girişten sonra şifreyi değiştirmeyi unutmayın!")
        
    except Exception as e:
        db.rollback()
        print(f"❌ Hata: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    create_admin()
