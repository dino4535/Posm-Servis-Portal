# Veritabanı Şeması

## MSSQL Server Bağlantı Bilgileri

- **Server**: 77.83.37.248
- **Database**: POSM
- **User**: POSM
- **Password**: @1B9j9K045

## Tablolar

### 1. Depots (Depolar)

```sql
CREATE TABLE Depots (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    code NVARCHAR(50) UNIQUE NOT NULL,
    address NVARCHAR(500),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2
);
```

### 2. Users (Kullanıcılar)

```sql
CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(255) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    name NVARCHAR(100) NOT NULL,
    role NVARCHAR(20) NOT NULL, -- 'Admin', 'Teknik', 'User'
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2
);

CREATE INDEX IX_Users_Email ON Users(email);
CREATE INDEX IX_Users_Role ON Users(role);
```

### 3. User_Depots (Kullanıcı-Depo İlişkisi)

```sql
CREATE TABLE User_Depots (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    depot_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE,
    UNIQUE(user_id, depot_id)
);

CREATE INDEX IX_User_Depots_User ON User_Depots(user_id);
CREATE INDEX IX_User_Depots_Depot ON User_Depots(depot_id);
```

### 4. Territories (Bölgeler)

```sql
CREATE TABLE Territories (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    code NVARCHAR(50) UNIQUE,
    depot_id INT NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE
);

CREATE INDEX IX_Territories_Depot ON Territories(depot_id);
```

### 5. Dealers (Bayiler)

```sql
CREATE TABLE Dealers (
    id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) NOT NULL,
    name NVARCHAR(200) NOT NULL,
    territory_id INT,
    address NVARCHAR(500),
    phone NVARCHAR(50),
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (territory_id) REFERENCES Territories(id) ON DELETE SET NULL
);

CREATE INDEX IX_Dealers_Territory ON Dealers(territory_id);
CREATE INDEX IX_Dealers_Code ON Dealers(code);
```

### 6. POSM (Point of Sale Materials)

```sql
CREATE TABLE POSM (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) UNIQUE NOT NULL,
    description NVARCHAR(500),
    depot_id INT NOT NULL,
    hazir_adet INT DEFAULT 0,
    tamir_bekleyen INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (depot_id) REFERENCES Depots(id) ON DELETE CASCADE
);

CREATE INDEX IX_POSM_Depot ON POSM(depot_id);
```

### 7. Requests (Talepler)

```sql
CREATE TABLE Requests (
    id INT PRIMARY KEY IDENTITY(1,1),
    request_no NVARCHAR(50) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    depot_id INT NOT NULL,
    territory_id INT NOT NULL,
    dealer_id INT NOT NULL,
    yapilacak_is NVARCHAR(50) NOT NULL, -- 'Montaj', 'Demontaj', 'Bakım'
    yapilacak_is_detay NVARCHAR(MAX),
    istenen_tarih DATE NOT NULL,
    planlanan_tarih DATE,
    tamamlanma_tarihi DATE,
    tamamlayan_user_id INT,
    posm_id INT,
    durum NVARCHAR(20) DEFAULT 'Beklemede', -- 'Beklemede', 'Planlandı', 'Tamamlandı', 'İptal'
    priority INT DEFAULT 0, -- 0: Normal, 1: Yüksek, 2: Acil
    notes NVARCHAR(MAX),
    created_at DATETIME2 DEFAULT GETDATE(),
    updated_at DATETIME2,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (depot_id) REFERENCES Depots(id),
    FOREIGN KEY (territory_id) REFERENCES Territories(id),
    FOREIGN KEY (dealer_id) REFERENCES Dealers(id),
    FOREIGN KEY (posm_id) REFERENCES POSM(id),
    FOREIGN KEY (tamamlayan_user_id) REFERENCES Users(id)
);

CREATE INDEX IX_Requests_User ON Requests(user_id);
CREATE INDEX IX_Requests_Depot ON Requests(depot_id);
CREATE INDEX IX_Requests_Status ON Requests(durum);
CREATE INDEX IX_Requests_PlannedDate ON Requests(planlanan_tarih);
CREATE INDEX IX_Requests_RequestNo ON Requests(request_no);
```

### 8. Photos (Fotoğraflar)

```sql
CREATE TABLE Photos (
    id INT PRIMARY KEY IDENTITY(1,1),
    request_id INT NOT NULL,
    file_name NVARCHAR(255) NOT NULL,
    file_path NVARCHAR(500) NOT NULL,
    file_size BIGINT,
    mime_type NVARCHAR(100),
    uploaded_by INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (request_id) REFERENCES Requests(id) ON DELETE CASCADE,
    FOREIGN KEY (uploaded_by) REFERENCES Users(id)
);

CREATE INDEX IX_Photos_Request ON Photos(request_id);
```

### 9. Audit_Logs (Denetim Kayıtları)

```sql
CREATE TABLE Audit_Logs (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT,
    action NVARCHAR(50) NOT NULL, -- 'CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT'
    entity_type NVARCHAR(50), -- 'Request', 'POSM', 'User', vb.
    entity_id INT,
    old_values NVARCHAR(MAX), -- JSON
    new_values NVARCHAR(MAX), -- JSON
    ip_address NVARCHAR(50),
    user_agent NVARCHAR(500),
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE INDEX IX_Audit_Logs_User ON Audit_Logs(user_id);
CREATE INDEX IX_Audit_Logs_CreatedAt ON Audit_Logs(created_at);
CREATE INDEX IX_Audit_Logs_Entity ON Audit_Logs(entity_type, entity_id);
```

## Seed Data (İlk Veriler)

### 3 Depo Oluşturma

```sql
INSERT INTO Depots (name, code, address) VALUES
('Depo 1', 'DEPO1', 'İstanbul'),
('Depo 2', 'DEPO2', 'Ankara'),
('Depo 3', 'DEPO3', 'İzmir');
```

### Admin Kullanıcı Oluşturma

```sql
-- Şifre: admin123 (bcrypt hash'i oluşturulacak)
INSERT INTO Users (email, password_hash, name, role) VALUES
('admin@posm.com', '$2a$10$...', 'Admin User', 'Admin');
```
