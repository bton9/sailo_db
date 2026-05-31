-- =====================================================
-- SailoTravel 完整資料庫建立腳本
-- 版本: v1.1 (優化版)
-- 建立日期: 2025-10-02
-- 說明: 包含所有表單、索引、觸發器與初始資料
-- =====================================================

CREATE DATABASE IF NOT EXISTS sailo_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE sailo_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255),
    name VARCHAR(100) NOT NULL, 
    nickname VARCHAR(50), 
    phone VARCHAR(20),
    address TEXT,
    avatar VARCHAR(500),
    access ENUM('user', 'admin', 'vip') DEFAULT 'user',
    birthday DATE,
    gender ENUM('male', 'female', 'other'),
    
    google_id VARCHAR(255) UNIQUE, 
    google_authenticator_secret VARCHAR(255), 
    google_authenticator_enabled BOOLEAN DEFAULT FALSE,
    backup_codes JSON, 
    
    email_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    failed_login_attempts INT DEFAULT 0, 
    locked_until TIMESTAMP NULL, 
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_google_id (google_id),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='用戶主表 - 儲存所有使用者基本資料與Google 2FA資訊';

CREATE TABLE IF NOT EXISTS password_resets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at TIMESTAMP NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_token (token),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='密碼重置表 - 儲存忘記密碼的重置Token';

CREATE TABLE IF NOT EXISTS puzzle_verifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL, 
    
    puzzle_type ENUM('4pieces', '9pieces', '16pieces') DEFAULT '4pieces' 
        COMMENT '拼圖類型: 4塊(2x2), 9塊(3x3), 16塊(4x4)',
    puzzle_image_url VARCHAR(500) 
        COMMENT '拼圖原圖URL (可為空白正方形或自訂圖片)',
    puzzle_pieces JSON 
        COMMENT '拼圖塊資訊: [{id:1, x:0, y:0, width:200, height:200}, ...]',
    correct_order JSON 
        COMMENT '正確順序: [1,2,3,4] 或 [1,2,3,4,5,6,7,8,9]',
    
    puzzle_solution JSON NOT NULL, 
    attempts INT DEFAULT 0, 
    max_attempts INT DEFAULT 100, 
    is_solved BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMP NOT NULL, 
    
    user_attempts JSON 
        COMMENT '使用者嘗試記錄: [{attempt:1, order:[2,1,3,4], timestamp:"2025-10-02 10:30:00"}, ...]',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_session_id (session_id),
    INDEX idx_expires_at (expires_at),
    INDEX idx_puzzle_type (puzzle_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='圖形驗證表 (優化版) - 支援4/9/16塊拼圖驗證';

CREATE TABLE IF NOT EXISTS system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT,
    description TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_setting_key (setting_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='系統設定表 - 儲存全域系統參數';

CREATE TABLE IF NOT EXISTS customer_service_rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    agent_id INT, 
    status ENUM('waiting', 'active', 'closed') DEFAULT 'waiting',
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    subject VARCHAR(255), 
    source ENUM('direct', 'ai_transfer') DEFAULT 'direct', 
    ai_chat_room_id INT NULL, 
    transfer_context TEXT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    closed_at TIMESTAMP NULL,
    
    INDEX idx_user_id (user_id),
    INDEX idx_agent_id (agent_id),
    INDEX idx_status (status),
    INDEX idx_source (source)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='1v1客服聊天室 - 支援直接諮詢與AI轉接';

CREATE TABLE IF NOT EXISTS ai_chat_rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    session_name VARCHAR(255) DEFAULT 'AI 助手對話',
    is_active BOOLEAN DEFAULT TRUE,
    transferred_to_human BOOLEAN DEFAULT FALSE, 
    transfer_requested_at TIMESTAMP NULL, 
    customer_service_room_id INT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_transferred_to_human (transferred_to_human)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='AI聊天室 - 支援自動轉人工功能';

ALTER TABLE customer_service_rooms
    ADD CONSTRAINT fk_cs_rooms_user 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_cs_rooms_agent 
        FOREIGN KEY (agent_id) REFERENCES users(id) ON DELETE SET NULL,
    ADD CONSTRAINT fk_cs_rooms_ai_room 
        FOREIGN KEY (ai_chat_room_id) REFERENCES ai_chat_rooms(id) ON DELETE SET NULL;

ALTER TABLE ai_chat_rooms
    ADD CONSTRAINT fk_ai_rooms_cs_room 
        FOREIGN KEY (customer_service_room_id) REFERENCES customer_service_rooms(id) ON DELETE SET NULL;

CREATE TABLE IF NOT EXISTS ai_chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    user_id INT NOT NULL,
    user_message TEXT NOT NULL, 
    ai_response TEXT NOT NULL, 
    tokens_used INT DEFAULT 0, 
    model_version VARCHAR(50) DEFAULT 'gpt-3.5-turbo', 
    is_transfer_request BOOLEAN DEFAULT FALSE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (room_id) REFERENCES ai_chat_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_room_id (room_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at),
    INDEX idx_is_transfer_request (is_transfer_request)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='AI聊天訊息 - 儲存使用者與AI的對話記錄';

CREATE TABLE IF NOT EXISTS customer_service_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    room_id INT NOT NULL,
    sender_id INT NOT NULL, 
    message TEXT, 
    message_type ENUM('text', 'image', 'file', 'system') DEFAULT 'text',
    file_url VARCHAR(500), 
    file_name VARCHAR(255), 
    file_size INT, 
    thumbnail_url VARCHAR(500),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (room_id) REFERENCES customer_service_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_room_id (room_id),
    INDEX idx_sender_id (sender_id),
    INDEX idx_created_at (created_at),
    INDEX idx_message_type (message_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='客服聊天訊息 - 支援文字、圖片、檔案與系統訊息';

CREATE TABLE IF NOT EXISTS media_files (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    stored_name VARCHAR(255) NOT NULL, 
    file_path VARCHAR(500) NOT NULL, 
    file_size INT NOT NULL, 
    mime_type VARCHAR(100) NOT NULL, 
    file_type ENUM('image', 'document', 'video', 'audio', 'other') NOT NULL,
    thumbnail_path VARCHAR(500), 
    upload_context ENUM('chat', 'profile', 'other') DEFAULT 'chat',
    is_temporary BOOLEAN DEFAULT FALSE, 
    expires_at TIMESTAMP NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_file_type (file_type),
    INDEX idx_upload_context (upload_context),
    INDEX idx_is_temporary (is_temporary),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='媒體檔案表 - 統一管理使用者上傳的所有檔案';

CREATE TABLE IF NOT EXISTS login_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    email VARCHAR(255) NOT NULL,
    login_method ENUM('local', 'google') NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    success BOOLEAN NOT NULL,
    failure_reason VARCHAR(255), 
    puzzle_verified BOOLEAN DEFAULT FALSE, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_email (email),
    INDEX idx_created_at (created_at),
    INDEX idx_ip_address (ip_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='用戶登入日誌 - 記錄所有登入行為與安全資訊';

CREATE TABLE IF NOT EXISTS transfer_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ai_room_id INT NOT NULL,
    customer_service_room_id INT NOT NULL,
    transfer_reason TEXT, 
    ai_conversation_summary TEXT, 
    transfer_keywords VARCHAR(500), 
    processed_by_agent_id INT, 
    processing_time INT, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (ai_room_id) REFERENCES ai_chat_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (customer_service_room_id) REFERENCES customer_service_rooms(id) ON DELETE CASCADE,
    FOREIGN KEY (processed_by_agent_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_ai_room_id (ai_room_id),
    INDEX idx_customer_service_room_id (customer_service_room_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='客服轉接記錄表 - 追蹤AI到人工客服的轉接過程';

INSERT INTO system_settings (setting_key, setting_value, description) VALUES
('puzzle_max_attempts', '100', '圖形驗證最大嘗試次數'),
('puzzle_expire_minutes', '60', '圖形驗證過期時間(分鐘)'),
('puzzle_default_type', '4pieces', '預設拼圖類型 (4pieces/9pieces/16pieces)'),
('account_lock_minutes', '1', '帳戶鎖定時間(分鐘)'),
('max_failed_attempts', '100', '最大登入失敗次數'),
('max_file_size_mb', '10', '最大檔案上傳大小(MB)'),
('allowed_image_types', 'jpg,jpeg,png,gif,webp', '允許的圖片格式'),
('transfer_keywords', '轉人工,客服,真人,人工服務', 'AI轉人工的觸發關鍵字'),
('auto_transfer_enabled', 'true', '是否啟用自動轉人工功能');

DROP TRIGGER IF EXISTS after_ai_transfer_request;


DELIMITER //

CREATE TRIGGER after_ai_transfer_request 
AFTER UPDATE ON ai_chat_rooms 
FOR EACH ROW 
BEGIN
   
    IF NEW.transferred_to_human = TRUE AND OLD.transferred_to_human = FALSE THEN
       
        INSERT INTO customer_service_rooms 
        (user_id, status, source, ai_chat_room_id, transfer_context, subject) 
        VALUES 
        (NEW.user_id, 'waiting', 'ai_transfer', NEW.id, 
         CONCAT('從AI聊天室轉接 - 會話:', NEW.session_name), 
         '從AI助手轉接的諮詢');
        
        UPDATE ai_chat_rooms 
        SET customer_service_room_id = LAST_INSERT_ID() 
        WHERE id = NEW.id;
    END IF;
END//

DELIMITER ;

INSERT INTO users (email, password, name, nickname, access, is_active, email_verified) VALUES
('admin@sailotravel.com', '$2a$10$N9qo8uLOickgx2ZMRZoMye6zKWuQ.Hs0K0YFl.8G3Q5kUvnvJZLCm', '系統管理員', 'Admin', 'admin', TRUE, TRUE);

INSERT INTO users (email, password, name, nickname, access, is_active, email_verified) VALUES
('user@sailotravel.com', '$2a$10$CwTycUXWue0Thq9StjUM0uJ8fWnHNsZwNvSBYCdH5aIMqLbhFEW.i', '測試使用者', '小測', 'user', TRUE, TRUE);

SHOW TABLES;

SELECT 
    TABLE_NAME as '資料表名稱',
    TABLE_ROWS as '資料筆數',
    TABLE_COMMENT as '說明'
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'sailo_db'
ORDER BY TABLE_NAME;
