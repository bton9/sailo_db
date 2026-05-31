-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: sailo_db
-- ------------------------------------------------------
-- Server version	8.4.6

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_chat_messages`
--

DROP TABLE IF EXISTS `ai_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `user_id` int NOT NULL,
  `user_message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ai_response` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokens_used` int DEFAULT '0',
  `model_version` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'gpt-3.5-turbo',
  `is_transfer_request` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_id` (`room_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_is_transfer_request` (`is_transfer_request`),
  CONSTRAINT `ai_chat_messages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `ai_chat_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ai_chat_messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI聊天訊息 - 儲存使用者與AI的對話記錄';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_messages`
--

LOCK TABLES `ai_chat_messages` WRITE;
/*!40000 ALTER TABLE `ai_chat_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_chat_rooms`
--

DROP TABLE IF EXISTS `ai_chat_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `session_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT 'AI 助手對話',
  `is_active` tinyint(1) DEFAULT '1',
  `transferred_to_human` tinyint(1) DEFAULT '0',
  `transfer_requested_at` timestamp NULL DEFAULT NULL,
  `customer_service_room_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_transferred_to_human` (`transferred_to_human`),
  KEY `fk_ai_rooms_cs_room` (`customer_service_room_id`),
  CONSTRAINT `ai_chat_rooms_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ai_rooms_cs_room` FOREIGN KEY (`customer_service_room_id`) REFERENCES `customer_service_rooms` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='AI聊天室 - 支援自動轉人工功能';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_rooms`
--

LOCK TABLES `ai_chat_rooms` WRITE;
/*!40000 ALTER TABLE `ai_chat_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ai_chat_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_service_messages`
--

DROP TABLE IF EXISTS `customer_service_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_service_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `message_type` enum('text','image','file','system') COLLATE utf8mb4_unicode_ci DEFAULT 'text',
  `file_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_size` int DEFAULT NULL,
  `thumbnail_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_id` (`room_id`),
  KEY `idx_sender_id` (`sender_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_message_type` (`message_type`),
  CONSTRAINT `customer_service_messages_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `customer_service_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `customer_service_messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服聊天訊息 - 支援文字、圖片、檔案與系統訊息';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_service_messages`
--

LOCK TABLES `customer_service_messages` WRITE;
/*!40000 ALTER TABLE `customer_service_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_service_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_service_rooms`
--

DROP TABLE IF EXISTS `customer_service_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_service_rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `agent_id` int DEFAULT NULL,
  `status` enum('waiting','active','closed') COLLATE utf8mb4_unicode_ci DEFAULT 'waiting',
  `priority` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `subject` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` enum('direct','ai_transfer') COLLATE utf8mb4_unicode_ci DEFAULT 'direct',
  `ai_chat_room_id` int DEFAULT NULL,
  `transfer_context` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `closed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_agent_id` (`agent_id`),
  KEY `idx_status` (`status`),
  KEY `idx_source` (`source`),
  KEY `fk_cs_rooms_ai_room` (`ai_chat_room_id`),
  CONSTRAINT `fk_cs_rooms_agent` FOREIGN KEY (`agent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cs_rooms_ai_room` FOREIGN KEY (`ai_chat_room_id`) REFERENCES `ai_chat_rooms` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_cs_rooms_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='1v1客服聊天室 - 支援直接諮詢與AI轉接';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_service_rooms`
--

LOCK TABLES `customer_service_rooms` WRITE;
/*!40000 ALTER TABLE `customer_service_rooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer_service_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login_logs`
--

DROP TABLE IF EXISTS `login_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `login_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `login_method` enum('local','google') COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `success` tinyint(1) NOT NULL,
  `failure_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puzzle_verified` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_email` (`email`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_ip_address` (`ip_address`),
  CONSTRAINT `login_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶登入日誌 - 記錄所有登入行為與安全資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
INSERT INTO `login_logs` VALUES (1,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:08'),(2,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:26'),(3,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:40:59'),(4,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:41:06'),(5,2,'user@sailotravel.com','local','::1',NULL,0,'Account locked due to too many failed attempts',0,'2025-10-02 15:41:20'),(6,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:40'),(7,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:46'),(8,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:46:05'),(9,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:05'),(10,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:08'),(11,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:10:55'),(12,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:12:07'),(13,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:14:53'),(14,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:22:21'),(15,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:32:21'),(16,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:44:35'),(17,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-02 17:12:10'),(18,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-02 17:12:49'),(19,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:01:50'),(20,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:58:16'),(21,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-03 04:01:33'),(22,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 08:23:02');
/*!40000 ALTER TABLE `login_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_files`
--

DROP TABLE IF EXISTS `media_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_files` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `original_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `stored_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_size` int NOT NULL,
  `mime_type` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_type` enum('image','document','video','audio','other') COLLATE utf8mb4_unicode_ci NOT NULL,
  `thumbnail_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `upload_context` enum('chat','profile','other') COLLATE utf8mb4_unicode_ci DEFAULT 'chat',
  `is_temporary` tinyint(1) DEFAULT '0',
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_file_type` (`file_type`),
  KEY `idx_upload_context` (`upload_context`),
  KEY `idx_is_temporary` (`is_temporary`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `media_files_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='媒體檔案表 - 統一管理使用者上傳的所有檔案';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_files`
--

LOCK TABLES `media_files` WRITE;
/*!40000 ALTER TABLE `media_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `media_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `used` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_email` (`email`),
  KEY `idx_token` (`token`),
  KEY `idx_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='密碼重置表 - 儲存忘記密碼的重置Token';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puzzle_verifications`
--

DROP TABLE IF EXISTS `puzzle_verifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `puzzle_verifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `puzzle_type` enum('4pieces','9pieces','16pieces') COLLATE utf8mb4_unicode_ci DEFAULT '4pieces' COMMENT '拼圖類型: 4塊(2x2), 9塊(3x3), 16塊(4x4)',
  `puzzle_image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '拼圖原圖URL (可為空白正方形或自訂圖片)',
  `puzzle_pieces` json DEFAULT NULL COMMENT '拼圖塊資訊: [{id:1, x:0, y:0, width:200, height:200}, ...]',
  `correct_order` json DEFAULT NULL COMMENT '正確順序: [1,2,3,4] 或 [1,2,3,4,5,6,7,8,9]',
  `puzzle_solution` json NOT NULL,
  `attempts` int DEFAULT '0',
  `max_attempts` int DEFAULT '100',
  `is_solved` tinyint(1) DEFAULT '0',
  `expires_at` timestamp NOT NULL,
  `user_attempts` json DEFAULT NULL COMMENT '使用者嘗試記錄: [{attempt:1, order:[2,1,3,4], timestamp:"2025-10-02 10:30:00"}, ...]',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_expires_at` (`expires_at`),
  KEY `idx_puzzle_type` (`puzzle_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圖形驗證表 (優化版) - 支援4/9/16塊拼圖驗證';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `puzzle_verifications`
--

LOCK TABLES `puzzle_verifications` WRITE;
/*!40000 ALTER TABLE `puzzle_verifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `puzzle_verifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_settings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text COLLATE utf8mb4_unicode_ci,
  `description` text COLLATE utf8mb4_unicode_ci,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`),
  KEY `idx_setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系統設定表 - 儲存全域系統參數';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_settings`
--

LOCK TABLES `system_settings` WRITE;
/*!40000 ALTER TABLE `system_settings` DISABLE KEYS */;
INSERT INTO `system_settings` VALUES (1,'puzzle_max_attempts','100','圖形驗證最大嘗試次數','2025-10-02 15:34:29'),(2,'puzzle_expire_minutes','60','圖形驗證過期時間(分鐘)','2025-10-02 15:34:29'),(3,'puzzle_default_type','4pieces','預設拼圖類型 (4pieces/9pieces/16pieces)','2025-10-02 15:34:29'),(4,'account_lock_minutes','1','帳戶鎖定時間(分鐘)','2025-10-02 15:34:29'),(5,'max_failed_attempts','100','最大登入失敗次數','2025-10-02 15:34:29'),(6,'max_file_size_mb','10','最大檔案上傳大小(MB)','2025-10-02 15:34:29'),(7,'allowed_image_types','jpg,jpeg,png,gif,webp','允許的圖片格式','2025-10-02 15:34:29'),(8,'transfer_keywords','轉人工,客服,真人,人工服務','AI轉人工的觸發關鍵字','2025-10-02 15:34:29'),(9,'auto_transfer_enabled','true','是否啟用自動轉人工功能','2025-10-02 15:34:29');
/*!40000 ALTER TABLE `system_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_logs`
--

DROP TABLE IF EXISTS `transfer_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer_logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `ai_room_id` int NOT NULL,
  `customer_service_room_id` int NOT NULL,
  `transfer_reason` text COLLATE utf8mb4_unicode_ci,
  `ai_conversation_summary` text COLLATE utf8mb4_unicode_ci,
  `transfer_keywords` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `processed_by_agent_id` int DEFAULT NULL,
  `processing_time` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `processed_by_agent_id` (`processed_by_agent_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_ai_room_id` (`ai_room_id`),
  KEY `idx_customer_service_room_id` (`customer_service_room_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `transfer_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfer_logs_ibfk_2` FOREIGN KEY (`ai_room_id`) REFERENCES `ai_chat_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfer_logs_ibfk_3` FOREIGN KEY (`customer_service_room_id`) REFERENCES `customer_service_rooms` (`id`) ON DELETE CASCADE,
  CONSTRAINT `transfer_logs_ibfk_4` FOREIGN KEY (`processed_by_agent_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客服轉接記錄表 - 追蹤AI到人工客服的轉接過程';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_logs`
--

LOCK TABLES `transfer_logs` WRITE;
/*!40000 ALTER TABLE `transfer_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text COLLATE utf8mb4_unicode_ci,
  `avatar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `access` enum('user','admin','vip') COLLATE utf8mb4_unicode_ci DEFAULT 'user',
  `birthday` date DEFAULT NULL,
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_authenticator_secret` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `google_authenticator_enabled` tinyint(1) DEFAULT '0',
  `backup_codes` json DEFAULT NULL,
  `email_verified` tinyint(1) DEFAULT '0',
  `is_active` tinyint(1) DEFAULT '1',
  `failed_login_attempts` int DEFAULT '0',
  `locked_until` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `google_id` (`google_id`),
  KEY `idx_email` (`email`),
  KEY `idx_google_id` (`google_id`),
  KEY `idx_phone` (`phone`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶主表 - 儲存所有使用者基本資料與Google 2FA資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@sailotravel.com','$2a$10$N9qo8uLOickgx2ZMRZoMye6zKWuQ.Hs0K0YFl.8G3Q5kUvnvJZLCm','系統管理員','Admin',NULL,NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,1,1,5,NULL,'2025-10-02 15:34:29','2025-10-02 16:32:21'),(2,'user@sailotravel.com','$2a$10$CwTycUXWue0Thq9StjUM0uJ8fWnHNsZwNvSBYCdH5aIMqLbhFEW.i','測試使用者','小測',NULL,NULL,NULL,'user',NULL,NULL,NULL,NULL,0,NULL,1,1,6,'2025-10-02 16:11:20','2025-10-02 15:34:29','2025-10-02 16:12:07'),(3,'sailo@sailo.com','$2b$10$AvC7ELxmIeR.UfNUP0A94u6VCeNg.wUMxiCW7JQNI71euwMHuJ4g2','測試使用者','sailo',NULL,NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,1,1,0,NULL,'2025-10-02 15:45:49','2025-10-02 17:12:10');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'sailo_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-13  9:39:23
