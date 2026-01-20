-- User_Tokens tablosu oluştur
-- Token'ları veritabanında saklamak ve güvenlik için

USE POSM;
GO

IF OBJECT_ID('User_Tokens', 'U') IS NULL
BEGIN
    CREATE TABLE User_Tokens (
        id INT PRIMARY KEY IDENTITY(1,1),
        user_id INT NOT NULL,
        token_hash NVARCHAR(255) NOT NULL, -- JWT token'ın hash'i
        token_jti NVARCHAR(100) UNIQUE, -- JWT ID (jti claim)
        expires_at DATETIME2 NOT NULL,
        is_revoked BIT DEFAULT 0,
        revoked_at DATETIME2 NULL,
        ip_address NVARCHAR(50),
        user_agent NVARCHAR(500),
        created_at DATETIME2 DEFAULT GETDATE(),
        FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_User_Tokens_User ON User_Tokens(user_id);
    CREATE INDEX IX_User_Tokens_TokenHash ON User_Tokens(token_hash);
    CREATE INDEX IX_User_Tokens_JTI ON User_Tokens(token_jti);
    CREATE INDEX IX_User_Tokens_ExpiresAt ON User_Tokens(expires_at);
    CREATE INDEX IX_User_Tokens_Revoked ON User_Tokens(is_revoked);
    PRINT 'User_Tokens tablosu oluşturuldu';
END
ELSE
BEGIN
    PRINT 'User_Tokens tablosu zaten mevcut';
END
GO

-- Eski token'ları temizlemek için stored procedure
IF OBJECT_ID('sp_CleanExpiredTokens', 'P') IS NOT NULL
    DROP PROCEDURE sp_CleanExpiredTokens;
GO

CREATE PROCEDURE sp_CleanExpiredTokens
AS
BEGIN
    -- Süresi dolmuş ve iptal edilmiş token'ları sil
    DELETE FROM User_Tokens 
    WHERE (expires_at < GETDATE() AND is_revoked = 1)
       OR (expires_at < DATEADD(DAY, -30, GETDATE())); -- 30 günden eski token'ları sil
    
    PRINT 'Eski token''lar temizlendi';
END
GO

PRINT 'Token yönetim sistemi hazır!';
GO
