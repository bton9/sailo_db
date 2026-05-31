CREATE DATABASE  IF NOT EXISTS `sailo_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `sailo_db`;
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
-- Table structure for table `bookmarks`
--

DROP TABLE IF EXISTS `bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bookmarks` (
  `bookmark_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bookmark_id`),
  UNIQUE KEY `unique_post_user_bookmark` (`post_id`,`user_id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_bookmarks_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bookmarks_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
INSERT INTO `bookmarks` VALUES (3,6,3,'2025-10-28 09:25:22');
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '購物車項目ID',
  `user_id` int NOT NULL COMMENT '用戶ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` tinyint NOT NULL COMMENT '數量',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '加入時間',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_product` (`user_id`,`product_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_cart_items_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_items_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='購物車項目';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_likes`
--

DROP TABLE IF EXISTS `comment_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_likes` (
  `comment_likes_id` int NOT NULL AUTO_INCREMENT,
  `comment_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_likes_id`),
  UNIQUE KEY `unique_comment_user_like` (`comment_id`,`user_id`),
  KEY `idx_comment_id` (`comment_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_comment_likes_comments` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_comment_likes_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_likes`
--

LOCK TABLES `comment_likes` WRITE;
/*!40000 ALTER TABLE `comment_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `comment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`comment_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_comments_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,3,'123','2025-10-27 16:41:45','2025-10-27 16:41:45'),(2,3,'1234','2025-10-27 18:54:02','2025-10-27 19:28:21');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
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
-- Table structure for table `favorite_list_places`
--

DROP TABLE IF EXISTS `favorite_list_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_list_places` (
  `list_places_id` int NOT NULL AUTO_INCREMENT COMMENT '清單景點關聯編號',
  `list_id` int DEFAULT NULL COMMENT '收藏清單編號',
  `place_id` int DEFAULT NULL COMMENT '景點編號',
  PRIMARY KEY (`list_places_id`),
  UNIQUE KEY `unique_list_place` (`list_id`,`place_id`),
  KEY `idx_list_id` (`list_id`),
  KEY `idx_place_id` (`place_id`),
  CONSTRAINT `fk_favorite_list_places_lists` FOREIGN KEY (`list_id`) REFERENCES `favorite_lists` (`list_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favorite_list_places_places` FOREIGN KEY (`place_id`) REFERENCES `places` (`place_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_list_places`
--

LOCK TABLES `favorite_list_places` WRITE;
/*!40000 ALTER TABLE `favorite_list_places` DISABLE KEYS */;
INSERT INTO `favorite_list_places` VALUES (59,1,1),(2,1,2),(60,1,7),(56,1,16),(18,1,21),(19,1,24),(50,4,18),(63,6,6);
/*!40000 ALTER TABLE `favorite_list_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorite_lists`
--

DROP TABLE IF EXISTS `favorite_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorite_lists` (
  `list_id` int NOT NULL AUTO_INCREMENT COMMENT '清單編號',
  `user_id` int DEFAULT NULL COMMENT '使用者編號',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '清單名稱',
  `description` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '清單描述',
  `location_id` int DEFAULT NULL COMMENT '收藏清單主要地區',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  PRIMARY KEY (`list_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_location_id` (`location_id`),
  CONSTRAINT `fk_favorite_lists_locations` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_favorite_lists_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_lists`
--

LOCK TABLES `favorite_lists` WRITE;
/*!40000 ALTER TABLE `favorite_lists` DISABLE KEYS */;
INSERT INTO `favorite_lists` VALUES (1,1,'我的最愛','測試用清單',NULL,'2025-10-18 17:48:08'),(2,1,'測試','測試',NULL,'2025-10-18 18:56:42'),(4,1,'123','123123',NULL,'2025-10-21 09:37:49'),(6,1,'11111gg','``',NULL,'2025-10-27 20:05:20');
/*!40000 ALTER TABLE `favorite_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follows` (
  `follow_id` int NOT NULL AUTO_INCREMENT,
  `follower_id` int NOT NULL COMMENT '追蹤者',
  `following_id` int NOT NULL COMMENT '被追蹤者',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follow_id`),
  UNIQUE KEY `unique_follower_following` (`follower_id`,`following_id`),
  KEY `idx_follower_id` (`follower_id`),
  KEY `idx_following_id` (`following_id`),
  CONSTRAINT `fk_follows_follower` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_follows_following` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `follows_chk_1` CHECK ((`follower_id` <> `following_id`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follows`
--

LOCK TABLES `follows` WRITE;
/*!40000 ALTER TABLE `follows` DISABLE KEYS */;
/*!40000 ALTER TABLE `follows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `location_id` int NOT NULL AUTO_INCREMENT COMMENT '地區編號',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '地區名稱',
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'台北市'),(2,'高雄市'),(3,'台中市'),(4,'花蓮縣'),(5,'台南市');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
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
  `session_id` int DEFAULT NULL COMMENT 'Session ID (成功登入時建立)',
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
  KEY `idx_session_id` (`session_id`),
  CONSTRAINT `fk_login_log_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE SET NULL,
  CONSTRAINT `login_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶登入日誌 - 記錄所有登入行為與安全資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
INSERT INTO `login_logs` VALUES (1,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:08'),(2,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:26'),(3,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:40:59'),(4,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:41:06'),(5,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Account locked due to too many failed attempts',0,'2025-10-02 15:41:20'),(6,1,NULL,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:40'),(7,1,NULL,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:46'),(8,3,NULL,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:46:05'),(9,3,NULL,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:05'),(10,3,NULL,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:08'),(11,3,NULL,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:10:55'),(12,2,NULL,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:12:07'),(13,1,NULL,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:14:53'),(14,1,NULL,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:22:21'),(15,1,NULL,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:32:21'),(16,3,NULL,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:44:35'),(17,3,NULL,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-02 17:12:10'),(18,3,NULL,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-02 17:12:49'),(19,3,NULL,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:01:50'),(20,3,NULL,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:58:16'),(21,3,NULL,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-03 04:01:33'),(22,3,NULL,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 08:23:02'),(23,3,NULL,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-13 03:03:38'),(24,3,NULL,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-13 03:03:56'),(25,3,NULL,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-13 03:03:57');
/*!40000 ALTER TABLE `login_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media`
--

DROP TABLE IF EXISTS `media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media` (
  `media_id` int NOT NULL AUTO_INCREMENT COMMENT '媒體編號',
  `user_id` int DEFAULT NULL COMMENT '使用者編號',
  `trip_id` int DEFAULT NULL COMMENT '行程編號',
  `place_id` int DEFAULT NULL COMMENT '景點編號',
  `place_category` enum('景點','餐廳','住宿','交通') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '景點類型',
  `url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '檔案 URL',
  `is_cover` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否封面',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '描述',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  PRIMARY KEY (`media_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_trip_id` (`trip_id`),
  KEY `idx_place_id` (`place_id`),
  CONSTRAINT `fk_media_places` FOREIGN KEY (`place_id`) REFERENCES `places` (`place_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_media_trips` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_media_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
INSERT INTO `media` VALUES (1,1,NULL,1,'景點','https://ik.imagekit.io/crjen7iza/places/gallery/place-gallery-1-1761569367490-banner1.jpg',0,NULL,'2025-10-27 20:49:30'),(113,NULL,NULL,1,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_1.jpg',1,'台北101 景點圖片','2025-10-15 14:00:00'),(114,NULL,NULL,2,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_2.jpg',1,'六合夜市 餐廳圖片','2025-10-15 14:01:00'),(115,NULL,NULL,3,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_3.jpg',1,'赤崁樓 景點圖片','2025-10-15 14:02:00'),(116,NULL,NULL,4,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_4.jpg',1,'國立故宮博物院 景點圖片','2025-10-15 14:03:00'),(117,NULL,NULL,5,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_5.jpg',1,'士林夜市 餐廳圖片','2025-10-15 14:04:00'),(118,NULL,NULL,6,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_6.jpg',1,'西門町商圈 景點圖片','2025-10-15 14:05:00'),(119,NULL,NULL,7,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_7.jpg',1,'象山步道 景點圖片','2025-10-15 14:06:00'),(120,NULL,NULL,8,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_8.jpg',1,'饒河街夜市 餐廳圖片','2025-10-15 14:07:00'),(121,NULL,NULL,9,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_9.jpg',1,'松山文創園區 景點圖片','2025-10-15 14:08:00'),(122,NULL,NULL,10,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_10.jpg',1,'北投溫泉區 景點圖片','2025-10-15 14:09:00'),(123,NULL,NULL,11,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_11.jpg',1,'美麗華百樂園 景點圖片','2025-10-15 14:10:00'),(124,NULL,NULL,12,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_12.jpg',1,'台北萬豪酒店 住宿圖片','2025-10-15 14:11:00'),(125,NULL,NULL,13,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_13.jpg',1,'台中國家歌劇院 景點圖片','2025-10-15 14:12:00'),(126,NULL,NULL,14,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_14.jpg',1,'逢甲夜市 餐廳圖片','2025-10-15 14:13:00'),(127,NULL,NULL,15,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_15.jpg',1,'高美濕地 景點圖片','2025-10-15 14:14:00'),(128,NULL,NULL,16,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_16.jpg',1,'審計新村 景點圖片','2025-10-15 14:15:00'),(129,NULL,NULL,17,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_17.jpg',1,'宮原眼科 餐廳圖片','2025-10-15 14:16:00'),(130,NULL,NULL,18,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_18.jpg',1,'一中街商圈 景點圖片','2025-10-15 14:17:00'),(131,NULL,NULL,19,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_19.jpg',1,'勤美誠品綠園道 景點圖片','2025-10-15 14:18:00'),(132,NULL,NULL,20,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_20.jpg',1,'台中港三井Outlet 景點圖片','2025-10-15 14:19:00'),(133,NULL,NULL,21,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_21.jpg',1,'日月千禧酒店 住宿圖片','2025-10-15 14:20:00'),(134,NULL,NULL,22,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_22.jpg',1,'春水堂創始店 餐廳圖片','2025-10-15 14:21:00'),(135,NULL,NULL,23,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_23.jpg',1,'太魯閣國家公園 景點圖片','2025-10-15 14:22:00'),(136,NULL,NULL,24,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_24.jpg',1,'七星潭海岸 景點圖片','2025-10-15 14:23:00'),(137,NULL,NULL,25,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_25.jpg',1,'東大門夜市 餐廳圖片','2025-10-15 14:24:00'),(138,NULL,NULL,26,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_26.jpg',1,'花蓮文創園區 景點圖片','2025-10-15 14:25:00'),(139,NULL,NULL,27,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_27.jpg',1,'鯉魚潭風景區 景點圖片','2025-10-15 14:26:00'),(140,NULL,NULL,28,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_28.jpg',1,'花蓮遠雄悅來大飯店 住宿圖片','2025-10-15 14:27:00'),(141,NULL,NULL,29,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_29.jpg',1,'瑞穗牧場 景點圖片','2025-10-15 14:28:00'),(142,NULL,NULL,30,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_30.jpg',1,'花蓮文化創意夜市 餐廳圖片','2025-10-15 14:29:00'),(143,NULL,NULL,31,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_31.jpg',1,'遠雄海洋公園 景點圖片','2025-10-15 14:30:00'),(144,NULL,NULL,32,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_32.jpg',1,'花蓮福容大飯店 住宿圖片','2025-10-15 14:31:00'),(145,NULL,NULL,33,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_33.jpg',1,'蓮池潭風景區 景點圖片','2025-10-15 14:32:00'),(146,NULL,NULL,34,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_34.jpg',1,'駁二藝術特區 景點圖片','2025-10-15 14:33:00'),(147,NULL,NULL,35,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_35.jpg',1,'六合夜市 餐廳圖片','2025-10-15 14:34:00'),(148,NULL,NULL,36,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_36.jpg',1,'愛河風景區 景點圖片','2025-10-15 14:35:00'),(149,NULL,NULL,37,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_37.jpg',1,'壽山動物園 景點圖片','2025-10-15 14:36:00'),(150,NULL,NULL,38,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_38.jpg',1,'美麗島捷運站 景點圖片','2025-10-15 14:37:00'),(151,NULL,NULL,39,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_39.jpg',1,'高雄中央公園 景點圖片','2025-10-15 14:38:00'),(152,NULL,NULL,40,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_40.jpg',1,'義享天地 景點圖片','2025-10-15 14:39:00'),(153,NULL,NULL,41,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_41.jpg',1,'漢來大飯店 住宿圖片','2025-10-15 14:40:00'),(154,NULL,NULL,42,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_42.jpg',1,'鹽埕老街 餐廳圖片','2025-10-15 14:41:00'),(155,NULL,NULL,43,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_43.jpg',1,'安平古堡 景點圖片','2025-10-15 14:42:00'),(156,NULL,NULL,44,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_44.jpg',1,'赤崁樓 景點圖片','2025-10-15 14:43:00'),(157,NULL,NULL,45,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_45.jpg',1,'花園夜市 餐廳圖片','2025-10-15 14:44:00'),(158,NULL,NULL,46,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_46.jpg',1,'台南孔廟 景點圖片','2025-10-15 14:45:00'),(159,NULL,NULL,47,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_47.jpg',1,'安平樹屋 景點圖片','2025-10-15 14:46:00'),(160,NULL,NULL,48,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_48.jpg',1,'藍晒圖文創園區 景點圖片','2025-10-15 14:47:00'),(161,NULL,NULL,49,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_49.jpg',1,'鵪鶉鹹粥 餐廳圖片','2025-10-15 14:48:00'),(162,NULL,NULL,50,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_50.jpg',1,'晶英酒店 住宿圖片','2025-10-15 14:49:00'),(163,NULL,NULL,51,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_51.jpg',1,'正興街商圈 景點圖片','2025-10-15 14:50:00'),(164,NULL,NULL,52,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_52.jpg',1,'台南美術館 景點圖片','2025-10-15 14:51:00'),(165,NULL,NULL,53,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_53.jpg',1,'台北101 景點圖片','2025-10-15 14:52:00'),(166,NULL,NULL,54,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_54.jpg',1,'陽明山國家公園 景點圖片','2025-10-15 14:53:00'),(167,NULL,NULL,55,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_55.jpg',1,'金峰魯肉飯 餐廳圖片','2025-10-15 14:54:00'),(168,NULL,NULL,56,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_56.jpg',1,'圓山大飯店 住宿圖片','2025-10-15 14:55:00'),(169,NULL,NULL,57,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_57.jpg',1,'彩虹眷村 景點圖片','2025-10-15 14:56:00'),(170,NULL,NULL,58,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_58.jpg',1,'宮原眼科冰淇淋店 餐廳圖片','2025-10-15 14:57:00'),(171,NULL,NULL,59,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_59.jpg',1,'谷關溫泉區 景點圖片','2025-10-15 14:58:00'),(172,NULL,NULL,60,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_60.jpg',1,'林酒店 住宿圖片','2025-10-15 14:59:00'),(173,NULL,NULL,61,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_61.jpg',1,'石梯坪風景區 景點圖片','2025-10-15 15:00:00'),(174,NULL,NULL,62,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_62.jpg',1,'花蓮炸蛋蔥油餅 餐廳圖片','2025-10-15 15:01:00'),(175,NULL,NULL,63,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_63.jpg',1,'立川漁場 景點圖片','2025-10-15 15:02:00'),(176,NULL,NULL,64,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_64.jpg',1,'秧悅美地渡假酒店 住宿圖片','2025-10-15 15:03:00'),(177,NULL,NULL,65,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_65.jpg',1,'旗津風車公園 景點圖片','2025-10-15 15:04:00'),(178,NULL,NULL,66,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_66.jpg',1,'鹽埕婆婆冰 餐廳圖片','2025-10-15 15:05:00'),(179,NULL,NULL,67,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_67.jpg',1,'夢時代購物中心 景點圖片','2025-10-15 15:06:00'),(180,NULL,NULL,68,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_68.jpg',1,'中央公園英迪格酒店 住宿圖片','2025-10-15 15:07:00'),(181,NULL,NULL,69,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_69.jpg',1,'奇美博物館 景點圖片','2025-10-15 15:08:00'),(182,NULL,NULL,70,'餐廳','https://ik.imagekit.io/crjen7iza/Map/maps/place_70.jpg',1,'永樂市場 餐廳圖片','2025-10-15 15:09:00'),(183,NULL,NULL,71,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_71.jpg',1,'四草綠色隧道 景點圖片','2025-10-15 15:10:00'),(184,NULL,NULL,72,'住宿','https://ik.imagekit.io/crjen7iza/Map/maps/place_72.jpg',1,'香格里拉台南遠東國際大飯店 住宿圖片','2025-10-15 15:11:00'),(185,NULL,NULL,73,'景點','https://ik.imagekit.io/crjen7iza/Map/maps/place_73.jpg',1,'中正紀念堂 景點圖片','2025-10-15 15:12:00'),(200,1,NULL,3,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/3/3_1761273746438_IhO-8i18S.jpg',0,NULL,'2025-10-24 10:42:28'),(201,1,NULL,15,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/15/15_1761274132403_H57Jgz6xA.jfif',0,NULL,'2025-10-24 10:48:54'),(202,1,NULL,6,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/6/6_1761277167925_2_nQwBuHl.jpg',0,NULL,'2025-10-24 11:39:30'),(203,1,NULL,1,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/1/1_1761277550088_cjx3F3hvU.jfif',0,NULL,'2025-10-24 11:45:52'),(204,1,NULL,1,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/1/1_1761279919124_ksptEw3M_.jpg',0,NULL,'2025-10-24 12:25:21'),(205,1,NULL,21,'住宿','https://ik.imagekit.io/crjen7iza/place/gallery/21/21_1761280469299_Frejmlx3-.jpg',0,NULL,'2025-10-24 12:34:31'),(206,1,NULL,6,'景點','https://ik.imagekit.io/crjen7iza/place/gallery/6/6_1761289895078_cv17u6HyT.jpg',0,NULL,'2025-10-24 15:11:37');
/*!40000 ALTER TABLE `media` ENABLE KEYS */;
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
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '明細ID',
  `order_id` int NOT NULL COMMENT '訂單ID',
  `product_id` int NOT NULL COMMENT '商品ID',
  `quantity` tinyint NOT NULL COMMENT '數量',
  `unit_price` int NOT NULL COMMENT '單價 (下單時的價格)',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_order_detail_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_order_detail_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='訂單明細';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,2,1,250),(2,1,1,2,180),(3,2,2,3,250),(4,2,1,4,180),(5,3,2,1,250),(6,3,1,2,180);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '訂單ID',
  `user_id` int NOT NULL COMMENT '用戶ID',
  `total` int NOT NULL COMMENT '訂單總金額',
  `payment_method` tinyint NOT NULL COMMENT '付款方式 0:未選擇 1:信用卡 2:ATM 3:超商代碼',
  `payment_status` tinyint NOT NULL DEFAULT '0' COMMENT '付款狀態 0:未付款 1:已付款 2:付款失敗',
  `recipient_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '收件人姓名',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '聯絡電話',
  `shipping_method` tinyint NOT NULL COMMENT '配送方式 0:未選擇 1:宅配 2:超商取貨',
  `shipping_address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配送地址',
  `order_status` tinyint NOT NULL DEFAULT '0' COMMENT '訂單狀態 0:待處理 1:已確認 2:已出貨 3:已完成 4:已取消',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '訂單日期',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_order_status` (`order_status`),
  KEY `idx_payment_status` (`payment_status`),
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='訂單主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,3,80,1,0,'1111','0987654122',1,'宜蘭縣 中正區 中正區123',0,'2025-10-27 15:57:35','2025-10-27 15:57:35'),(2,3,80,2,0,'123','0912345678',1,'100 屏東縣 中正區 中正區123',0,'2025-10-27 16:04:29','2025-10-27 16:04:29'),(3,3,80,2,0,'123123','0987654321',1,'宜蘭縣 中正區 中正區',0,'2025-10-28 09:29:51','2025-10-28 09:29:51');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_resets` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '使用者 Email',
  `otp` char(6) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '6位數 OTP 驗證碼',
  `verified` tinyint(1) DEFAULT '0' COMMENT 'OTP 是否已驗證',
  `used` tinyint(1) DEFAULT '0' COMMENT '是否已用於重置密碼',
  `attempts` int DEFAULT '0' COMMENT 'OTP 驗證失敗次數',
  `max_attempts` int DEFAULT '5000' COMMENT '最大允許驗證次數',
  `expires_at` timestamp NOT NULL COMMENT 'OTP 過期時間（10分鐘）',
  `verified_at` timestamp NULL DEFAULT NULL COMMENT 'OTP 驗證成功時間',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  PRIMARY KEY (`id`),
  KEY `idx_email` (`email`),
  KEY `idx_otp` (`otp`),
  KEY `idx_expires_at` (`expires_at`),
  KEY `idx_verified` (`verified`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='密碼重置表（OTP版本）- 使用6位數驗證碼而非長Token';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
INSERT INTO `password_resets` VALUES (5,'sailotest00@gmail.com','491443',1,1,0,5,'2025-10-28 01:46:48','2025-10-28 01:37:11','2025-10-28 01:36:48');
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '付款記錄ID',
  `order_id` int NOT NULL COMMENT '訂單ID',
  `merchant_trade_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '商店交易編號',
  `payment_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '付款方式',
  `amount` int NOT NULL COMMENT '付款金額',
  `payment_status` tinyint NOT NULL DEFAULT '0' COMMENT '付款狀態 0:待付款 1:已付款 2:付款失敗',
  `ecpay_trade_no` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ECPay交易編號',
  `rtn_code` int DEFAULT NULL COMMENT 'ECPay回傳碼',
  `rtn_msg` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ECPay回傳訊息',
  `payment_date` datetime DEFAULT NULL COMMENT '付款完成時間',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  PRIMARY KEY (`id`),
  UNIQUE KEY `merchant_trade_no` (`merchant_trade_no`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_merchant_trade_no` (`merchant_trade_no`),
  KEY `idx_payment_status` (`payment_status`),
  CONSTRAINT `fk_payments_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='付款記錄表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,1,'ORD1761551855635RD7T','Credit',80,0,NULL,NULL,NULL,NULL,'2025-10-27 15:57:35','2025-10-27 15:57:35');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pd_favorite`
--

DROP TABLE IF EXISTS `pd_favorite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pd_favorite` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL COMMENT '使用者ID (關聯 users.id)',
  `product_id` int NOT NULL COMMENT '商品ID (關聯 products.product_id)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏時間',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`) COMMENT '防止重複收藏',
  KEY `idx_user_id` (`user_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_pd_favorite_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pd_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏表 - 記錄使用者收藏的商品';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pd_favorite`
--

LOCK TABLES `pd_favorite` WRITE;
/*!40000 ALTER TABLE `pd_favorite` DISABLE KEYS */;
INSERT INTO `pd_favorite` VALUES (1,1,1,'2025-10-14 18:30:00'),(2,1,6,'2025-10-14 19:00:00'),(3,1,11,'2025-10-14 22:20:00'),(4,1,16,'2025-10-15 17:15:00'),(5,1,21,'2025-10-15 23:45:00'),(6,2,2,'2025-10-13 16:30:00'),(7,2,7,'2025-10-13 18:45:00'),(8,2,12,'2025-10-14 00:20:00'),(9,2,18,'2025-10-14 19:30:00'),(10,2,26,'2025-10-14 22:00:00'),(11,2,31,'2025-10-15 18:20:00'),(12,3,3,'2025-10-12 17:00:00'),(13,3,8,'2025-10-12 21:15:00'),(14,3,13,'2025-10-13 18:30:00'),(15,3,22,'2025-10-13 23:45:00'),(16,3,27,'2025-10-14 17:20:00'),(17,3,32,'2025-10-15 00:30:00'),(18,3,36,'2025-10-15 19:00:00'),(19,3,41,'2025-10-16 16:45:00');
/*!40000 ALTER TABLE `pd_favorite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pd_review`
--

DROP TABLE IF EXISTS `pd_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pd_review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL COMMENT '商品ID (關聯 products.product_id)',
  `user_id` int NOT NULL COMMENT '評論者ID (關聯 users.id)',
  `rating` decimal(2,1) NOT NULL COMMENT '評分 (1.0-5.0)',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '評論標題',
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT '評論內容',
  `images` json DEFAULT NULL COMMENT '評論圖片 URL 陣列 ["url1", "url2"]',
  `is_verified_purchase` tinyint(1) DEFAULT '0' COMMENT '是否為已購買用戶 (可選功能)',
  `helpful_count` int DEFAULT '0' COMMENT '有幫助的數量',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否顯示 (管理員可隱藏不當評論)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '評論時間',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rating` (`rating`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `fk_pd_review_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pd_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pd_review`
--

LOCK TABLES `pd_review` WRITE;
/*!40000 ALTER TABLE `pd_review` DISABLE KEYS */;
INSERT INTO `pd_review` VALUES (1,1,1,5.0,'超級實用的旅行組合！','包裝精美，牙刷質量很好，牙膏也不會漏。收納盒設計很貼心，放在行李箱不佔空間。出差旅行必備！','[\"https://example.com/images/review1_1.jpg\", \"https://example.com/images/review1_2.jpg\"]',1,15,1,'2025-10-15 18:00:00','2025-10-18 00:54:21'),(2,1,2,4.5,'性價比高','整體來說很不錯，唯一小缺點是牙刷的刷毛稍微硬了一點，但其他都很滿意。',NULL,1,8,1,'2025-10-15 22:30:00','2025-10-18 00:54:21'),(3,1,3,5.0,'爛','基本功能都有，但收納盒的扣子不太好開。',NULL,0,3,1,'2025-10-16 17:15:00','2025-10-28 01:24:10'),(4,6,1,5.0,'充電神器！','容量超大，可以充滿我的iPhone 3次還有剩。支援快充真的很方便，出門再也不用擔心手機沒電了！','[\"https://example.com/images/review6_1.jpg\"]',1,42,1,'2025-10-15 00:20:00','2025-10-18 00:54:21'),(5,6,2,4.5,'充電速度快','雙USB輸出很實用，可以同時充兩個設備。LED電量顯示清楚，但稍微有點重量。',NULL,1,22,1,'2025-10-15 19:00:00','2025-10-18 00:54:21'),(6,6,3,5.0,'旅行必備','帶去日本旅遊，每天充手機和相機都沒問題，真的很耐用！','[\"https://example.com/images/review6_3.jpg\"]',1,18,1,'2025-10-16 18:30:00','2025-10-18 00:54:21'),(7,7,2,5.0,'出國必備神器','去了歐洲、日本都能用，內建USB充電孔超方便，不用再帶一堆轉接頭了！','[\"https://example.com/images/review7_1.jpg\"]',1,35,1,'2025-10-14 17:30:00','2025-10-18 00:54:21'),(8,7,3,4.5,'非常實用','適用大部分國家，USB充電功能很貼心，唯一缺點是體積稍大。',NULL,1,12,1,'2025-10-15 21:45:00','2025-10-18 00:54:21'),(9,8,3,5.0,'音質超讚！','降噪效果很好，搭飛機時完全不會被引擎聲打擾。電池續航力強，充電盒又多提供24小時，超滿意！','[\"https://example.com/images/review8_1.jpg\", \"https://example.com/images/review8_2.jpg\"]',1,56,1,'2025-10-13 23:00:00','2025-10-18 00:54:21'),(10,8,1,4.5,'性價比不錯','音質清晰，連線穩定，IPX5防水很實用。唯一小缺點是耳機稍微大了一點。',NULL,1,28,1,'2025-10-14 19:20:00','2025-10-18 00:54:21'),(11,8,2,5.0,'推薦購買','降噪功能真的很強，通勤時聽音樂超享受，充電速度也很快！',NULL,1,19,1,'2025-10-16 00:30:00','2025-10-18 00:54:21'),(12,11,1,4.5,'節省空間好幫手','不需要抽氣機，用手壓就能排氣，真的節省很多行李空間！材質也很耐用。','[\"https://example.com/images/review11_1.jpg\"]',1,25,1,'2025-10-15 20:00:00','2025-10-18 00:54:21'),(13,11,3,4.0,'實用但需要技巧','第一次用需要練習一下，熟悉後很方便。建議不要裝太滿，比較好壓縮。',NULL,1,10,1,'2025-10-16 16:30:00','2025-10-18 00:54:21'),(14,21,1,5.0,'露營神器！','真的很輕只有2.5kg！搭建超快速，防水效果也很好。去了三次露營都沒問題，強力推薦！','[\"https://example.com/images/review21_1.jpg\", \"https://example.com/images/review21_2.jpg\", \"https://example.com/images/review21_3.jpg\"]',1,67,1,'2025-10-16 22:00:00','2025-10-18 00:54:21'),(15,21,2,4.5,'很棒的帳篷','空間對兩個人來說剛剛好，通風設計不錯。唯一缺點是收納袋有點小，不太好收。',NULL,1,31,1,'2025-10-17 00:45:00','2025-10-18 00:54:21'),(16,21,3,5.0,'超值！','這個價格能買到這麼好的帳篷真的很划算，下大雨也沒有漏水，讚！',NULL,1,24,1,'2025-10-17 17:00:00','2025-10-18 00:54:21'),(17,27,3,5.0,'登山好夥伴','背負系統設計得很好，長時間背著也不會累。防水拉鍊很實用，多口袋設計方便分類。','[\"https://example.com/images/review27_1.jpg\"]',1,38,1,'2025-10-15 18:30:00','2025-10-18 00:54:21'),(18,27,2,4.5,'品質不錯','容量夠大，材質耐用。肩帶很舒適，但腰帶的扣環有點硬。',NULL,1,15,1,'2025-10-16 19:00:00','2025-10-18 00:54:21'),(19,36,3,5.0,'防曬效果超好','去海邊玩一整天都沒有曬傷！質地清爽不黏膩，而且防水抗汗，游泳也不用擔心。','[\"https://example.com/images/review36_1.jpg\"]',1,45,1,'2025-10-16 21:30:00','2025-10-18 00:54:21'),(20,36,1,4.5,'敏感肌適用','無香料配方很溫和，敏感肌用了也不會過敏。唯一缺點是要多抹幾次才能完全推開。',NULL,1,21,1,'2025-10-16 23:00:00','2025-10-18 00:54:21'),(21,41,3,5.0,'超好穿！','彈性很好，穿起來很舒服。防曬UPF50+真的有效，游完泳皮膚也沒曬傷。乾得很快！','[\"https://example.com/images/review41_1.jpg\", \"https://example.com/images/review41_2.jpg\"]',1,29,1,'2025-10-17 18:15:00','2025-10-18 00:54:21'),(22,41,2,4.5,'質感不錯','材質摸起來很舒服，抗氯防曬功能都很好。版型合身但不會太緊。',NULL,1,16,1,'2025-10-17 19:30:00','2025-10-18 00:54:21');
/*!40000 ALTER TABLE `pd_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pd_review_helpful`
--

DROP TABLE IF EXISTS `pd_review_helpful`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pd_review_helpful` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL COMMENT '評論ID (關聯 pd_review.id)',
  `user_id` int NOT NULL COMMENT '點擊有用的使用者ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_review_user` (`review_id`,`user_id`) COMMENT '防止重複點擊',
  KEY `idx_review_id` (`review_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_pd_helpful_review` FOREIGN KEY (`review_id`) REFERENCES `pd_review` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pd_helpful_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='評論有用性記錄 - 記錄哪些使用者認為評論有幫助';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pd_review_helpful`
--

LOCK TABLES `pd_review_helpful` WRITE;
/*!40000 ALTER TABLE `pd_review_helpful` DISABLE KEYS */;
INSERT INTO `pd_review_helpful` VALUES (1,1,1,'2025-10-15 18:30:00'),(2,4,1,'2025-10-15 19:00:00'),(3,7,1,'2025-10-15 19:15:00'),(4,9,1,'2025-10-15 19:30:00'),(5,13,1,'2025-10-16 17:00:00'),(6,16,1,'2025-10-16 17:30:00'),(7,1,2,'2025-10-15 20:00:00'),(8,2,2,'2025-10-15 20:15:00'),(9,4,2,'2025-10-15 21:00:00'),(10,5,2,'2025-10-15 21:15:00'),(11,9,2,'2025-10-15 22:00:00'),(12,10,2,'2025-10-15 22:15:00'),(13,13,2,'2025-10-16 18:00:00'),(14,14,2,'2025-10-16 18:15:00'),(15,18,2,'2025-10-16 22:00:00'),(16,2,3,'2025-10-15 23:00:00'),(17,4,3,'2025-10-15 23:30:00'),(18,6,3,'2025-10-16 00:00:00'),(19,7,3,'2025-10-16 00:30:00'),(20,8,3,'2025-10-16 01:00:00'),(21,11,3,'2025-10-16 16:00:00'),(22,12,3,'2025-10-16 16:30:00'),(23,13,3,'2025-10-16 19:00:00'),(24,15,3,'2025-10-16 19:30:00'),(25,16,3,'2025-10-16 20:00:00'),(26,19,3,'2025-10-17 00:00:00');
/*!40000 ALTER TABLE `pd_review_helpful` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `places`
--

DROP TABLE IF EXISTS `places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `places` (
  `place_id` int NOT NULL AUTO_INCREMENT COMMENT '景點編號',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '景點名稱',
  `category` enum('景點','餐廳','住宿','交通') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '類別',
  `location_id` int DEFAULT NULL COMMENT '所屬地區編號',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '景點描述',
  `rating` float DEFAULT NULL COMMENT '平均評分',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `latitude` decimal(10,6) DEFAULT NULL COMMENT '緯度',
  `longitude` decimal(10,6) DEFAULT NULL COMMENT '經度',
  `google_place_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Google 地點 ID',
  PRIMARY KEY (`place_id`),
  KEY `idx_location_id` (`location_id`),
  KEY `idx_category` (`category`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `fk_places_locations` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=74 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `places`
--

LOCK TABLES `places` WRITE;
/*!40000 ALTER TABLE `places` DISABLE KEYS */;
INSERT INTO `places` VALUES (1,'台北101','景點',1,'台北著名地標,高樓觀景台能欣賞整個城市的美麗景色,是旅客必訪的景點之一,適合拍照與觀光。',4.8,'2025-10-14 11:53:24',25.033968,121.564468,'PabA9CvaPBxZELTD8'),(2,'六合夜市','餐廳',2,'高雄著名夜市,匯集各式在地小吃與特色美食,夜晚熱鬧非凡,是遊客與當地人都喜愛的美食勝地。',4.5,'2025-10-14 11:53:24',22.631600,120.301900,'Vob5ucrbKJuAKDA76'),(3,'赤崁樓','景點',5,'台南古蹟,融合中西建築風格與悠久歷史文化,提供遊客深入了解台南歷史文化的最佳去處,也是拍照打卡的熱門景點。',4.7,'2025-10-14 11:53:24',22.997883,120.202617,'fp1rY3eDhgxFZ9i46'),(4,'國立故宮博物院','景點',1,'收藏中華文物瑰寶,融合藝術與歷史教育功能,展出各朝代珍貴文物,是文化愛好者與旅客必訪的博物館。',4.7,'2025-10-14 12:10:12',25.102398,121.548492,'a4wNBURnt5npGKNU8'),(5,'士林夜市','餐廳',1,'台北最熱鬧的夜市之一,提供各式傳統小吃與特色美食,是遊客品嚐地道台灣美食的絕佳去處,夜晚熱鬧非凡。',4.5,'2025-10-14 12:12:45',25.087200,121.525000,'7nGg5fwVjQ6qdxCe6'),(6,'西門町商圈','景點',1,'年輕人潮聚集地,結合購物、美食與娛樂活動,是體驗台北潮流文化與城市生活的熱門景點,也是拍照打卡的好去處。',4.6,'2025-10-14 12:14:52',25.042233,121.508328,'9rz4fbR1S9EiHsPR7'),(7,'象山步道','景點',1,'俯瞰台北夜景的最佳地點之一,步道景觀優美,適合健行與拍攝台北市景,吸引許多遊客與攝影愛好者,是休閒散步的好去處。',4.9,'2025-10-14 12:16:33',25.027222,121.570611,'McJToUznk6i1M26C8'),(8,'饒河街夜市','餐廳',1,'結合傳統與現代特色的小吃夜市,提供多樣美食選擇,是遊客體驗台北夜市文化與街頭美食的絕佳地點,熱鬧又充滿特色。',4.4,'2025-10-14 12:18:45',25.050556,121.578333,'ykxiU5ByBWBXFbDEA'),(9,'松山文創園區','景點',1,'文創展覽與咖啡館結合的文化據點,提供藝術展覽、手作活動與休閒空間,適合喜愛文創與拍照的旅客,也是親子與朋友聚會的好去處。',4.6,'2025-10-14 12:20:18',25.044222,121.560222,'YoyvbHZz76roa7jZ8'),(10,'北投溫泉區','景點',1,'溫泉旅館林立,環境清幽,結合自然山景,是休閒泡湯與親近自然的最佳選擇,適合全家或情侶旅遊。',4.7,'2025-10-14 12:22:09',25.137500,121.506500,'Utjw52WjKN92sHzY6'),(11,'美麗華百樂園','景點',1,'摩天輪與購物娛樂合一的休閒中心,適合家庭或朋友聚會,提供購物、美食與娛樂的多重體驗,是台北熱門休閒景點。',4.5,'2025-10-14 12:23:47',25.082000,121.548600,'DEhvJzDYMBmqtuJbA'),(12,'台北萬豪酒店','住宿',1,'五星級住宿,交通便利且景觀極佳,提供舒適客房與完善設施,是旅客在台北享受高品質住宿的最佳選擇。',4.8,'2025-10-14 12:25:12',25.083611,121.548333,'oMqPZZ2vzwZvdYKm6'),(13,'台中國家歌劇院','景點',3,'建築藝術結合音樂表演的文化地標,提供精彩演出與參觀體驗,是台中文化愛好者必訪的藝術中心。',4.6,'2025-10-14 12:27:32',24.167222,120.639611,NULL),(14,'逢甲夜市','餐廳',3,'台中最具代表性的夜市,創意美食雲集,從傳統小吃到特色餐飲皆可品嚐,是旅客探索台中美食文化的好去處。',4.7,'2025-10-14 12:29:10',24.178889,120.646944,NULL),(15,'高美濕地','景點',3,'夕陽美景與自然生態觀察的熱門景點,適合攝影、散步及親近大自然,是台中戶外活動與生態旅遊的理想地點。',4.9,'2025-10-14 12:31:50',24.312611,120.561000,NULL),(16,'審計新村','景點',3,'文創商店與咖啡廳聚集的文青聖地,提供藝術展覽、手作體驗及休閒空間,是文青及創意愛好者的最佳打卡地點。',4.6,'2025-10-14 12:33:25',24.144611,120.663611,NULL),(17,'宮原眼科','餐廳',3,'復古建築冰淇淋名店,提供特色甜品與手工冰淇淋,是台中旅客品嚐經典甜點與拍照打卡的熱門地點。',4.8,'2025-10-14 12:35:10',24.136778,120.683500,NULL),(18,'一中街商圈','景點',3,'學生最愛的購物與美食街區,匯集潮流服飾、特色小吃與娛樂場所,是台中青年文化的重要聚集地。',4.5,'2025-10-14 12:36:58',24.147500,120.686333,NULL),(19,'勤美誠品綠園道','景點',3,'融合自然與設計的城市綠地,提供休閒散步、藝術展覽與戶外活動,是台中市民與遊客放鬆休憩的理想去處。',4.7,'2025-10-14 12:38:41',24.144611,120.662778,NULL),(20,'台中港三井Outlet','景點',3,'大型海港購物中心,適合全家出遊,結合購物、美食與休閒娛樂設施,是台中港熱門觀光與消費地點。',4.6,'2025-10-14 12:40:29',24.256944,120.541111,NULL),(21,'日月千禧酒店','住宿',3,'五星級飯店,位於台中市中心,提供豪華客房、完善設施與高品質服務,是旅客在台中享受舒適住宿的最佳選擇。',4.8,'2025-10-14 12:42:03',24.163611,120.638611,NULL),(22,'春水堂創始店','餐廳',4,'珍珠奶茶發源地,提供正宗茶飲及創意飲品,是體驗台灣經典飲品文化與觀光美食的絕佳地點。',4.6,'2025-10-14 12:43:47',24.136389,120.683611,NULL),(23,'太魯閣國家公園','景點',4,'峽谷與山景壯麗,提供登山、健行與戶外探險活動,是戶外愛好者與自然景觀攝影愛好者的理想選擇。',4.9,'2025-10-14 12:45:12',24.181389,121.493611,NULL),(24,'七星潭海岸','景點',3,'礫石海灘與湛藍海水,是花蓮代表景點,適合散步、拍照及欣賞海景,提供休閒與自然探索的完美環境。',4.8,'2025-10-14 12:47:21',24.032222,121.627500,NULL),(25,'東大門夜市','餐廳',4,'花蓮最大夜市,匯集各地小吃與特色美食,是遊客品嚐當地美食文化、體驗夜市熱鬧氛圍的首選地點。',4.5,'2025-10-14 12:48:59',23.973585,121.606384,NULL),(26,'花蓮文創園區','景點',4,'藝術展覽與文創商店共存的文化空間,提供展覽、手作體驗與休閒空間,是花蓮文創與藝術愛好者的好去處。',4.6,'2025-10-14 12:50:32',23.976111,121.605000,NULL),(27,'鯉魚潭風景區','景點',4,'湖光山色與環湖步道,適合騎腳踏車及散步,提供自然景觀與休閒活動,是親子與戶外愛好者的理想景點。',4.7,'2025-10-14 12:52:07',23.931111,121.561944,NULL),(28,'花蓮遠雄悅來大飯店','住宿',4,'臨海景觀飯店,設施完善,提供舒適客房與休閒服務,是花蓮旅客享受度假與海景住宿的絕佳選擇。',4.7,'2025-10-14 12:53:54',23.921944,121.605278,NULL),(29,'瑞穗牧場','景點',4,'自然草原與鮮奶製品,提供親子互動、動物體驗與戶外活動,是家庭旅遊與自然教育的理想景點。',4.5,'2025-10-14 12:55:39',23.517222,121.373611,NULL),(30,'花蓮文化創意夜市','餐廳',4,'結合在地手作與美食的夜市體驗,提供各式小吃與特色商品,是花蓮旅客探索地方文化與美食的好去處。',4.4,'2025-10-14 12:57:10',23.973611,121.605000,NULL),(31,'遠雄海洋公園','景點',4,'結合海洋生物與遊樂設施的大型主題園區,適合親子、朋友及團體遊玩,是花蓮熱門休閒娛樂與教育體驗景點。',4.6,'2025-10-14 12:58:48',23.894722,121.604444,NULL),(32,'花蓮福容大飯店','住宿',4,'臨近港口的高評價飯店,提供舒適客房與完善設施,是家庭與團體旅客在花蓮享受便利住宿的理想選擇。',4.8,'2025-10-14 13:00:26',23.851944,121.603611,NULL),(33,'蓮池潭風景區','景點',4,'湖光山色與龍虎塔,是高雄著名的旅遊景點,提供散步、休閒及觀光拍照的好去處,適合全家或朋友同遊。',4.6,'2025-10-14 13:02:05',22.686111,120.305556,NULL),(34,'駁二藝術特區','景點',2,'文創、展覽與咖啡結合的藝術聚落,提供文化活動、展覽與拍照打卡空間,是高雄文創與藝術愛好者必訪的地點。',4.7,'2025-10-14 13:03:32',22.616944,120.279167,NULL),(35,'六合夜市','餐廳',2,'高雄最具代表性的夜市,提供各式特色美食與小吃,是遊客體驗高雄在地夜市文化與美食的絕佳地點。',4.5,'2025-10-14 13:05:09',22.631600,120.301900,NULL),(36,'愛河風景區','景點',2,'浪漫夜景與河畔咖啡最受情侶喜愛,提供散步、休閒及拍照景點,是高雄情侶約會與觀光的理想地點。',4.8,'2025-10-14 13:06:52',22.626944,120.287222,NULL),(37,'壽山動物園','景點',2,'親子旅遊好去處,園區重建後環境舒適,提供動物觀賞、教育活動與戶外休閒,是家庭旅遊的熱門選擇。',4.6,'2025-10-14 13:08:31',22.648611,120.278333,NULL),(38,'美麗島捷運站','景點',2,'彩色玻璃穹頂藝術設計吸睛,是捷運站內的藝術景點,提供觀光拍照與休閒活動,是高雄旅客必訪地標。',4.7,'2025-10-14 13:10:08',22.631111,120.301111,NULL),(39,'高雄中央公園','景點',2,'市中心綠地,適合放鬆散步與休閒活動,提供自然環境與社區互動,是高雄市民與旅客放鬆身心的好去處。',4.5,'2025-10-14 13:11:54',22.630000,120.302222,NULL),(40,'義享天地','景點',2,'新興百貨商場,集購物與娛樂於一體,提供餐飲、購物及休閒娛樂,是高雄年輕族群與觀光客的熱門景點。',4.6,'2025-10-14 13:13:33',22.625000,120.300000,NULL),(41,'漢來大飯店','住宿',2,'五星級飯店,景觀與餐飲品質出眾,提供豪華住宿與完善服務,是高雄旅客享受高品質住宿的首選。',4.8,'2025-10-14 13:15:17',22.623611,120.296944,NULL),(42,'鹽埕老街','餐廳',2,'高雄在地老字號美食聚集地,提供傳統小吃與特色餐飲,是遊客體驗高雄美食文化與地方特色的必訪地點。',4.4,'2025-10-14 13:16:49',22.622222,120.295000,NULL),(43,'安平古堡','景點',5,'台南歷史悠久的古蹟,見證荷蘭時期文化,提供歷史導覽與拍照景點,是了解台南文化與歷史的重要地標。',4.6,'2025-10-14 13:18:21',22.995833,120.161111,NULL),(44,'赤崁樓','景點',5,'融合中西建築風格的歷史文化地標,提供歷史教育與觀光參觀,是台南旅客深入了解古蹟文化的理想景點。',4.5,'2025-10-14 13:19:56',22.997883,120.202617,NULL),(45,'花園夜市','餐廳',5,'台南最大夜市,傳統與創意小吃雲集,提供美食體驗與夜市文化探索,是遊客必訪的台南美食景點。',4.7,'2025-10-14 13:21:33',23.000000,120.200000,NULL),(46,'台南孔廟','景點',5,'文化與教育象徵,環境清幽,提供歷史導覽與參觀空間,是台南旅客了解古蹟文化與教育歷史的重要地標。',4.8,'2025-10-14 13:23:09',22.993611,120.204167,NULL),(47,'安平樹屋','景點',5,'樹木與老宅融合的奇特景觀,提供拍照打卡與歷史文化體驗,是遊客探索台南創意景觀與文化的理想去處。',4.6,'2025-10-14 13:24:41',22.995000,120.165000,NULL),(48,'藍晒圖文創園區','景點',5,'結合藝術與拍照景點的文青聖地,提供文創展覽與休閒空間,是喜愛藝術與創意文化旅客必訪的景點。',4.5,'2025-10-14 13:26:14',22.994444,120.196944,NULL),(49,'鵪鶉鹹粥','餐廳',5,'在地傳統早餐店,以魚粥聞名,提供早晨美食體驗與文化風味,是台南旅客品嚐地道早餐的好去處。',4.7,'2025-10-14 13:27:50',22.991111,120.197222,NULL),(50,'晶英酒店','住宿',5,'五星級飯店,位於市中心,設施完善,提供豪華住宿與優質服務,是台南旅客享受舒適住宿的首選地點。',4.9,'2025-10-14 13:29:27',22.991944,120.196111,NULL),(51,'正興街商圈','景點',5,'老屋新生的文創聚落,提供甜點咖啡與藝術展覽,是台南旅客體驗文創文化與拍照打卡的熱門景點。',4.6,'2025-10-14 13:31:02',22.992222,120.195000,NULL),(52,'台南美術館','景點',5,'現代藝術展館,建築設計極具特色,提供藝術展覽與文化教育,是台南旅客與藝術愛好者必訪的地標。',4.8,'2025-10-14 13:32:47',22.991389,120.195833,NULL),(53,'金瓜石','景點',1,'建於 1898 年的神社遺址,可經由石階前往欣賞舊淘金鎮金瓜石的景緻。',4.8,'2025-10-14 11:53:24',25.033968,121.564468,NULL),(54,'陽明山國家公園','景點',1,'溫泉與花季並存的自然景點,提供登山健行、泡湯與賞花體驗,是台北旅客親近自然與休閒的絕佳選擇。',4.8,'2025-10-14 13:36:49',25.179167,121.529167,NULL),(55,'金峰魯肉飯','餐廳',1,'台北知名傳統滷肉飯老店,提供經典台灣小吃與美食文化體驗,是旅客品嚐地道美食的熱門去處。',4.6,'2025-10-14 13:38:21',25.032222,121.521111,NULL),(56,'圓山大飯店','住宿',1,'中式宮殿風格建築,台北代表性飯店,提供豪華住宿與高品質服務,是旅客體驗台北文化與舒適住宿的首選。',4.8,'2025-10-14 13:39:58',25.072222,121.525000,NULL),(57,'彩虹眷村','景點',2,'彩繪藝術村落,充滿童趣與創意,提供拍照打卡與藝術文化體驗,是遊客探索台中創意文化與文青景點的理想地點。',4.7,'2025-10-14 13:41:26',24.133611,120.681944,NULL),(58,'宮原眼科冰淇淋店','餐廳',2,'以復古風格著名的甜品名店,提供手工冰淇淋與甜點體驗,是台中旅客品嚐經典甜品與拍照打卡的熱門景點。',4.6,'2025-10-14 13:42:59',24.136389,120.683611,NULL),(59,'谷關溫泉區','景點',2,'山林間的溫泉度假勝地,提供住宿、泡湯與戶外休閒體驗,是台中旅客親近自然與享受溫泉的理想選擇。',4.5,'2025-10-14 13:44:31',24.237222,120.837222,NULL),(60,'林酒店','住宿',2,'高評價商務與休閒並重的五星飯店,提供豪華住宿與完善設施,是台中旅客享受舒適住宿與服務的最佳選擇。',4.9,'2025-10-14 13:46:10',24.162222,120.639167,NULL),(61,'石梯坪風景區','景點',3,'獨特海蝕地形與海岸風光,適合觀光、拍照與戶外活動,是花蓮旅客探索自然景觀與海岸美景的好去處。',4.7,'2025-10-14 13:47:47',23.496944,121.519167,NULL),(62,'花蓮炸蛋蔥油餅','餐廳',3,'排隊名店,外酥內軟的經典小吃,提供花蓮在地美食體驗與觀光文化,是旅客品嚐地道小吃的熱門選擇。',4.5,'2025-10-14 13:49:25',23.978611,121.605000,NULL),(63,'立川漁場','景點',3,'可體驗摸蜆與品嚐海鮮料理的休閒農場,提供親子活動與戶外娛樂,是花蓮旅客享受自然與美食的好去處。',4.6,'2025-10-14 13:51:03',23.899167,121.536111,NULL),(64,'秧悅美地渡假酒店','住宿',3,'融合自然與舒適的高級度假住宿,提供豪華設施與戶外活動,是花蓮旅客享受放鬆與度假的理想選擇。',4.8,'2025-10-14 13:52:44',23.899722,121.538611,NULL),(65,'旗津風車公園','景點',4,'臨海風車與夕陽景色吸引眾多遊客,提供拍照打卡與休閒散步,是高雄旅客體驗自然景觀與戶外活動的熱門景點。',4.7,'2025-10-14 13:54:21',22.578611,120.295833,NULL),(66,'鹽埕婆婆冰','餐廳',4,'高雄老字號冰品店,夏季人氣旺,提供傳統冰品與甜點,是旅客品嚐地道消暑美食的理想去處。',4.5,'2025-10-14 13:55:59',22.623611,120.296944,NULL),(67,'夢時代購物中心','景點',2,'高雄最大購物中心,附有摩天輪,提供購物、美食與休閒娛樂,是遊客與家庭旅客休閒娛樂的理想地點。',4.6,'2025-10-14 13:57:37',22.604167,120.301389,NULL),(68,'中央公園英迪格酒店','住宿',4,'精品風格飯店,位置便利景觀佳,提供舒適住宿與完善服務,是高雄旅客享受便利住宿與休閒的理想選擇。',4.8,'2025-10-14 13:59:12',22.630000,120.302222,NULL),(69,'奇美博物館','景點',5,'藝術與自然結合的歐風建築博物館,提供展覽、教育體驗與拍照景點,是台南旅客與藝術愛好者必訪的景點。',4.9,'2025-10-14 14:00:41',22.934167,120.227222,NULL),(70,'永樂市場','餐廳',5,'老市場美食聚集地,以牛肉湯聞名,提供在地早餐與美食文化體驗,是遊客探索台南傳統市場與小吃的好去處。',4.6,'2025-10-14 14:02:18',22.991111,120.197222,NULL),(71,'四草綠色隧道','景點',5,'有「台版亞馬遜」之稱的紅樹林生態區,提供自然探索、划船體驗與親子活動,是台南旅客體驗生態與自然景觀的理想景點。',4.8,'2025-10-14 14:03:56',23.000000,120.200000,NULL),(72,'香格里拉台南遠東國際大飯店','住宿',5,'五星級飯店,設備完善、鄰近車站,提供豪華住宿與便利交通,是台南旅客享受高品質住宿與交通便利的最佳選擇。',4.9,'2025-10-14 14:05:29',22.997222,120.212222,NULL),(73,'中正紀念堂','景點',1,'國家級地標與歷史建築,環境開闊,提供參觀、拍照與文化體驗,是遊客了解台北歷史與文化的重要景點。',4.7,'2025-10-14 13:35:12',25.034000,121.521500,NULL);
/*!40000 ALTER TABLE `places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_comments`
--

DROP TABLE IF EXISTS `post_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_comments` (
  `post_comments_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `comment_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_comments_id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_comment_id` (`comment_id`),
  CONSTRAINT `fk_post_comments_comments` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_comments_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_comments`
--

LOCK TABLES `post_comments` WRITE;
/*!40000 ALTER TABLE `post_comments` DISABLE KEYS */;
INSERT INTO `post_comments` VALUES (1,3,1,'2025-10-27 16:41:45'),(2,4,2,'2025-10-27 18:54:02');
/*!40000 ALTER TABLE `post_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_likes`
--

DROP TABLE IF EXISTS `post_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_likes` (
  `post_likes_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_likes_id`),
  UNIQUE KEY `unique_post_user_like` (`post_id`,`user_id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_post_likes_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_likes_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_likes`
--

LOCK TABLES `post_likes` WRITE;
/*!40000 ALTER TABLE `post_likes` DISABLE KEYS */;
INSERT INTO `post_likes` VALUES (5,6,3,'2025-10-28 09:25:15');
/*!40000 ALTER TABLE `post_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_photos`
--

DROP TABLE IF EXISTS `post_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_photos` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`photo_id`),
  KEY `idx_post_id` (`post_id`),
  CONSTRAINT `fk_post_photos_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_photos`
--

LOCK TABLES `post_photos` WRITE;
/*!40000 ALTER TABLE `post_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `post_tags`
--

DROP TABLE IF EXISTS `post_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_tags` (
  `post_tags_id` int NOT NULL AUTO_INCREMENT,
  `post_id` int NOT NULL,
  `tag_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_tags_id`),
  UNIQUE KEY `unique_post_tag` (`post_id`,`tag_id`),
  KEY `idx_post_id` (`post_id`),
  KEY `idx_tag_id` (`tag_id`),
  CONSTRAINT `fk_post_tags_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_tags_tags` FOREIGN KEY (`tag_id`) REFERENCES `sns_tags` (`tag_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
INSERT INTO `post_tags` VALUES (2,2,2,'2025-10-22 11:51:32'),(3,2,3,'2025-10-22 11:51:32'),(4,3,1,'2025-10-27 16:41:39'),(5,4,2,'2025-10-27 18:53:53'),(6,6,1,'2025-10-28 09:25:57');
/*!40000 ALTER TABLE `post_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posts`
--

DROP TABLE IF EXISTS `posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `posts` (
  `post_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci,
  `category` enum('travel','food','life','photo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `trip_id` int DEFAULT NULL,
  `visible` tinyint(1) DEFAULT '1',
  `view_count` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_trip_id` (`trip_id`),
  KEY `idx_category` (`category`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_posts_trips` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_posts_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (2,3,'123','13','food',NULL,1,4,'2025-10-22 11:51:32','2025-10-22 11:52:30'),(3,3,'12313','12313','food',NULL,1,2,'2025-10-27 16:41:39','2025-10-27 16:41:45'),(4,3,'12','123','food',NULL,1,16,'2025-10-27 18:53:53','2025-10-27 19:28:56'),(6,3,'0000','0000','photo',NULL,1,9,'2025-10-27 19:29:47','2025-10-28 09:26:01');
/*!40000 ALTER TABLE `posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_categories`
--

LOCK TABLES `product_categories` WRITE;
/*!40000 ALTER TABLE `product_categories` DISABLE KEYS */;
INSERT INTO `product_categories` VALUES (1,'盥洗用品','日常用品','旅行專用盥洗清潔用品，輕便好攜帶','2025-10-11 05:22:26','2025-10-11 05:22:26'),(2,'電子產品','3C設備','旅行必備電子配件與充電設備','2025-10-11 05:22:26','2025-10-11 05:22:26'),(3,'衣物收納','收納整理','高效率衣物收納與壓縮工具','2025-10-11 05:22:26','2025-10-11 05:22:26'),(4,'旅行配件','舒適配件','提升旅途舒適度的實用配件','2025-10-11 05:22:26','2025-10-11 05:22:26'),(5,'戶外露營','戶外裝備','露營野營專業裝備與用品','2025-10-11 05:22:26','2025-10-11 05:22:26'),(6,'登山健行','運動裝備','登山健行專用裝備與配件','2025-10-11 05:22:26','2025-10-11 05:22:26'),(7,'攝影器材','攝影配件','旅行攝影必備器材與配件','2025-10-11 05:22:26','2025-10-11 05:22:26'),(8,'防護用品','安全防護','防曬防蚊與緊急醫療用品','2025-10-11 05:22:26','2025-10-11 05:22:26'),(9,'運動用品','運動裝備','旅行運動與水上活動用品','2025-10-11 05:22:26','2025-10-11 05:22:26'),(10,'雨具防水','防護用品','防雨防水保護裝備','2025-10-11 05:22:26','2025-10-11 05:22:26');
/*!40000 ALTER TABLE `product_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(255) NOT NULL,
  PRIMARY KEY (`image_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `fk_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,1,'https://ik.imagekit.io/crjen7iza/producsts/11_dentalKit.png'),(2,2,'https://ik.imagekit.io/crjen7iza/producsts/12_toiletries.png'),(3,3,'https://ik.imagekit.io/crjen7iza/producsts/12_toiletries.png'),(4,4,'https://ik.imagekit.io/crjen7iza/producsts/15_towels.png'),(5,5,'https://ik.imagekit.io/crjen7iza/producsts/25_bottle.png'),(6,6,'https://ik.imagekit.io/crjen7iza/producsts/19_powerbank.png'),(7,7,'https://ik.imagekit.io/crjen7iza/producsts/18_chargerSet.png'),(8,8,'https://ik.imagekit.io/crjen7iza/producsts/20_earbuds.png'),(9,9,'https://ik.imagekit.io/crjen7iza/producsts/18_chargerSet.png'),(10,10,'https://ik.imagekit.io/crjen7iza/producsts/22_fannyPack.png'),(11,11,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(12,12,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(13,13,'https://ik.imagekit.io/crjen7iza/producsts/01_underwear.png'),(14,14,'https://ik.imagekit.io/crjen7iza/producsts/03_sandals.png'),(15,15,'https://ik.imagekit.io/crjen7iza/producsts/12_toiletries.png'),(16,16,'https://ik.imagekit.io/crjen7iza/producsts/26_neckPillow.png'),(17,17,'https://ik.imagekit.io/crjen7iza/producsts/27_sleepMask.png'),(18,18,'https://ik.imagekit.io/crjen7iza/producsts/23_luggage.png'),(19,19,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(20,20,'https://ik.imagekit.io/crjen7iza/producsts/22_fannyPack.png'),(21,21,'https://ik.imagekit.io/crjen7iza/producsts/21_backpack.png'),(22,22,'https://ik.imagekit.io/crjen7iza/producsts/21_backpack.png'),(23,23,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(24,24,'https://ik.imagekit.io/crjen7iza/producsts/18_chargerSet.png'),(25,25,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(26,26,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(27,27,'https://ik.imagekit.io/crjen7iza/producsts/21_backpack.png'),(28,28,'https://ik.imagekit.io/crjen7iza/producsts/25_bottle.png'),(29,29,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(30,30,'https://ik.imagekit.io/crjen7iza/producsts/03_sandals.png'),(31,31,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(32,32,'https://ik.imagekit.io/crjen7iza/producsts/22_fannyPack.png'),(33,33,'https://ik.imagekit.io/crjen7iza/producsts/18_chargerSet.png'),(34,34,'https://ik.imagekit.io/crjen7iza/producsts/21_backpack.png'),(35,35,'https://ik.imagekit.io/crjen7iza/producsts/18_chargerSet.png'),(36,36,'https://ik.imagekit.io/crjen7iza/producsts/14_skincareKit.png'),(37,37,'https://ik.imagekit.io/crjen7iza/producsts/17_medicalKit.png'),(38,38,'https://ik.imagekit.io/crjen7iza/producsts/14_skincareKit.png'),(39,39,'https://ik.imagekit.io/crjen7iza/producsts/16_hairstylingKit.png'),(40,40,'https://ik.imagekit.io/crjen7iza/producsts/25_bottle.png'),(41,41,'https://ik.imagekit.io/crjen7iza/producsts/01_underwear.png'),(42,42,'https://ik.imagekit.io/crjen7iza/producsts/15_towels.png'),(43,43,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(44,44,'https://ik.imagekit.io/crjen7iza/producsts/22_fannyPack.png'),(45,45,'https://ik.imagekit.io/crjen7iza/producsts/24_organizers.png'),(46,46,'https://ik.imagekit.io/crjen7iza/producsts/09_umbrella.png'),(47,47,'https://ik.imagekit.io/crjen7iza/producsts/10_raincoat.png'),(48,48,'https://ik.imagekit.io/crjen7iza/producsts/22_fannyPack.png'),(49,49,'https://ik.imagekit.io/crjen7iza/producsts/21_backpack.png'),(50,50,'https://ik.imagekit.io/crjen7iza/producsts/04_slippers.png'),(51,51,'https://ik.imagekit.io/crjen7iza/producsts/04_slippers.png'),(52,7,'https://ik.imagekit.io/crjen7iza/producsts/04_slippers.png'),(53,1,'https://ik.imagekit.io/crjen7iza/producsts/11_dentalKit-2.png'),(55,1,'https://ik.imagekit.io/crjen7iza/producsts/11_dentalKit-3.png\r\n'),(56,1,'https://ik.imagekit.io/crjen7iza/producsts/11_dentalKit-4.png\r\n'),(57,1,'https://ik.imagekit.io/crjen7iza/producsts/11_dentalKit-5.png\r\n');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock_quantity` int NOT NULL,
  `category_id` int NOT NULL,
  `avg_rating` decimal(3,2) DEFAULT '0.00' COMMENT '平均評分',
  `review_count` int DEFAULT '0' COMMENT '評論數量',
  `favorite_count` int DEFAULT '0' COMMENT '收藏數量',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`product_id`),
  KEY `category_id` (`category_id`),
  KEY `idx_price` (`price`),
  KEY `idx_avg_rating` (`avg_rating`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'旅行牙刷牙膏組','便攜式摺疊牙刷含牙膏，輕量防水設計，附收納盒，適合短期旅行使用',180.00,142,1,4.83,3,0,'2025-10-11 05:22:26','2025-10-28 01:29:51',1),(2,'旅行裝洗髮精沐浴乳組','50ml分裝瓶組合，TSA認證可登機，無矽靈配方溫和不刺激',250.00,115,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-28 01:29:51',1),(3,'多功能沐浴露','三合一配方（洗髮/沐浴/洗臉），250ml大容量，天然植萃成分',320.00,100,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(4,'快乾旅行毛巾','超細纖維材質，吸水快乾，輕量僅80克，附收納袋',280.00,80,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(5,'摺疊矽膠旅行杯','350ml容量可摺疊，食品級矽膠，耐高溫可裝熱飲',350.00,90,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(6,'20000mAh行動電源','雙USB快充輸出，支援PD快充，LED電量顯示，可充手機4-5次',890.00,200,2,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(7,'萬國轉接頭','適用150+國家，內建USB充電孔，安全保護機制，輕巧便攜',650.00,180,2,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(8,'藍牙5.0無線耳機','降噪功能，IPX5防水，續航8小時，充電盒提供額外24小時',1280.00,100,2,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(9,'旅行萬用延長線','3插座+2USB孔，1.5米線長，過載保護，體積小方便攜帶',480.00,120,2,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(10,'防水手機腰包','觸控螢幕可操作，IPX8防水等級，可放6.5吋手機及護照現金',380.00,150,2,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(11,'真空壓縮袋5件組','節省50%行李空間，手捲式免抽氣機，耐用加厚材質',420.00,100,3,4.25,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(12,'旅行收納袋6件組','不同尺寸分類收納，防潑水尼龍布料，透氣網格設計',580.00,150,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(13,'內衣收納包','立體隔層保護胸型，可收納6-8套內衣褲，防水防塵',320.00,80,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(14,'鞋子收納袋3入組','防水防臭材質，透明視窗快速辨識，可收納運動鞋或皮鞋',380.00,90,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(15,'掛式盥洗包','大容量多夾層設計，可掛式節省空間，防水易清潔',680.00,70,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(16,'記憶泡棉U型枕','慢回彈記憶棉，人體工學設計，可調式鬆緊帶，附收納袋',580.00,120,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(17,'3D遮光眼罩耳塞組','完全遮光不壓迫眼球，柔軟透氣材質，附降噪耳塞',280.00,150,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(18,'TSA海關鎖行李束帶','TSA認證可過海關，螢光色易辨識，密碼鎖防盜',320.00,200,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(19,'便攜摺疊衣架5入組','可摺疊節省空間，防滑設計，承重3公斤，輕量塑鋼材質',180.00,100,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(20,'旅行護照證件包','RFID防盜刷功能，多卡層設計，可放護照/機票/現金/卡片',450.00,130,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(21,'2人輕量化帳篷','僅重2.5kg，快速搭建，防水係數3000mm，雙門雙層通風',3800.00,50,5,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(22,'羽絨睡袋800FP','填充800蓬鬆度羽絨，適溫-5°C，壓縮後僅25cm，重量900g',4200.00,40,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(23,'野餐防潮墊200x200','鋁箔防潮層，折疊收納輕便，適合2-4人使用，防水耐磨',680.00,80,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(24,'露營LED燈串','3段亮度調節，USB充電續航12小時，防水IP65，5米長',580.00,90,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(25,'摺疊露營桌椅組','鋁合金材質輕量化，承重120kg，5秒快速展開收納',2800.00,60,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(26,'碳纖維登山杖','超輕量僅180g/支，3段伸縮110-130cm，減震設計保護膝蓋',1680.00,70,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(27,'40L防水登山背包','防撕裂尼龍材質，透氣背負系統，防水拉鍊，多口袋分層',2800.00,80,6,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(28,'304不鏽鋼保溫瓶','真空保溫24小時，750ml大容量，防漏設計，可單手開啟',680.00,150,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(29,'速乾登山褲','彈性透氣快乾布料，多口袋設計，防潑水處理，UPF50+防曬',1280.00,100,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(30,'防滑登山鞋','Vibram黃金大底，Gore-Tex防水透氣，中筒保護腳踝',3200.00,60,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(31,'輕量化鋁合金三腳架','5節伸縮最高150cm，球型雲台360度旋轉，承重3kg，僅重800g',1680.00,70,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(32,'相機防水袋','IPX8防水等級，透明TPU可觸控操作，適用單眼及微單相機',880.00,90,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(33,'128GB高速記憶卡','V30錄影等級，讀取速度100MB/s，適合4K錄影',980.00,120,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(34,'單眼相機背包','防震內膽保護，上下層分離設計，可放15吋筆電，防潑水材質',2200.00,60,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(35,'便攜LED補光燈','可調色溫3200K-5600K，USB充電，磁吸底座可固定手機',780.00,100,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(36,'SPF50+防曬乳','物理性防曬，防水抗汗，80ml容量，無香料敏感肌適用',420.00,200,8,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(37,'旅行急救包','包含OK繃/消毒水/紗布/藥膏等30項急救用品，輕巧便攜',580.00,100,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(38,'天然防蚊液噴霧','天然精油配方，不含DEET，100ml噴霧瓶，4-6小時防護',280.00,150,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(39,'運動防曬袖套','UPF50+防曬係數，冰絲涼感材質，吸濕排汗彈性佳',220.00,180,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(40,'便攜式濾水瓶','4層過濾系統，可過濾99.9%細菌，650ml容量，適合戶外使用',1280.00,70,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(41,'快乾運動泳衣','彈性萊卡材質，抗氯防曬UPF50+，速乾透氣不悶熱',880.00,100,9,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(42,'超細纖維運動毛巾','吸水力是棉質3倍，40x80cm尺寸，附扣環可掛背包',280.00,150,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(43,'摺疊瑜珈墊','6mm厚度防滑，TPE環保材質，可摺疊方便攜帶，僅重1kg',980.00,80,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(44,'運動腰包','防水防汗材質，可放6.5吋手機，反光條夜跑安全，貼身不晃動',380.00,120,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(45,'快速充氣游泳圈','快速充氣閥30秒充飽，加厚PVC材質，適合成人使用',420.00,90,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(46,'自動開收折疊傘','一鍵自動開收，抗風骨架不易翻，直徑105cm大傘面',580.00,150,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(47,'輕便連帽雨衣','僅重200g可收納成小包，防水係數10000mm，反光條設計',380.00,180,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(48,'防水手機袋','IPX8防水等級，可觸控操作，透明雙面可拍照，附掛繩',180.00,200,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(49,'防水背包套','彈性束繩固定，反光Logo提升能見度，5種尺寸適用20-80L背包',280.00,120,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(50,'防水鞋套','加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺',320.00,100,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(51,'防水鞋套','加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺',320.00,100,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
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
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Token ID',
  `user_id` int NOT NULL COMMENT '使用者 ID',
  `session_id` int DEFAULT NULL COMMENT 'Session ID (關聯到 sessions 表)',
  `token` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Refresh Token (JWT)',
  `expires_at` datetime NOT NULL COMMENT '過期時間',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `revoked` tinyint(1) DEFAULT '0' COMMENT '是否已撤銷',
  `revoked_at` datetime DEFAULT NULL COMMENT '撤銷時間',
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '使用者代理 (瀏覽器資訊)',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP 位址 (支援 IPv6)',
  `device_fingerprint` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '裝置指紋 (用於安全驗證)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_token` (`token`),
  KEY `idx_expires_at` (`expires_at`),
  KEY `idx_revoked` (`revoked`),
  KEY `idx_user_token_status` (`user_id`,`revoked`,`expires_at`),
  KEY `idx_session_id` (`session_id`),
  CONSTRAINT `fk_refresh_token_session` FOREIGN KEY (`session_id`) REFERENCES `sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OAuth 2.0 Refresh Token 儲存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES (24,8,15,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjgsInNlc3Npb25JZCI6MTUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzg2MjE0LCJleHAiOjE3NjM5NzgyMTQsImlzcyI6InNhaWxvLWFwcCJ9.VBW5VCP1-yaFExSbD4Seo2dqBVOqh9FstOBVhwUcw5w','2025-11-24 17:56:54','2025-10-25 17:56:54',1,'2025-10-25 17:57:05','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(26,3,17,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MTcsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzg2Nzg2LCJleHAiOjE3NjM5Nzg3ODYsImlzcyI6InNhaWxvLWFwcCJ9.8Iv5IK4Cb6ob5xQ8H1q3IhnOxGiuzfe6fgNMYpaFHMM','2025-11-24 18:06:26','2025-10-25 18:06:26',1,'2025-10-25 18:06:44','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(28,4,19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MTksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwMTIxLCJleHAiOjE3NjM5ODIxMjEsImlzcyI6InNhaWxvLWFwcCJ9.PoBeJiY3VZFcTAKrTw_vtZQbCED2VrLdcJiioIOj4CM','2025-11-24 19:02:01','2025-10-25 19:02:01',1,'2025-10-25 19:02:24',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(29,4,19,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MTksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwMTQ0LCJleHAiOjE3NjM5ODIxNDQsImlzcyI6InNhaWxvLWFwcCJ9.uVzQElpi-KxSH2_8dJ5iLS2bdtWzj8P2OipCYjD0ykA','2025-11-24 19:02:24','2025-10-25 19:02:24',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(31,4,20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwMTU4LCJleHAiOjE3NjM5ODIxNTgsImlzcyI6InNhaWxvLWFwcCJ9.xzcoRjFOdtky45fBiFsiwkqbL_f3htWH1r26YdGotGQ','2025-11-24 19:02:39','2025-10-25 19:02:38',1,'2025-10-25 19:02:51',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(32,4,20,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwMTcxLCJleHAiOjE3NjM5ODIxNzEsImlzcyI6InNhaWxvLWFwcCJ9.6aRf6xnmMAT-7fDuDchLs17wIkeeES-aZk6ALStEn-c','2025-11-24 19:02:52','2025-10-25 19:02:51',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(34,4,21,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwMzczLCJleHAiOjE3NjM5ODIzNzMsImlzcyI6InNhaWxvLWFwcCJ9.cFvfeKRjYx_jiZorwIxw_Ef2K4bu04NNCqCkn6c23rs','2025-11-24 19:06:13','2025-10-25 19:06:13',1,'2025-10-25 19:08:13',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(35,4,22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNDk3LCJleHAiOjE3NjM5ODI0OTcsImlzcyI6InNhaWxvLWFwcCJ9.rDDZdQ-QHMyZqaBoseMM9ZwvX2ZuHnMmqHYM_FlKebY','2025-11-24 19:08:17','2025-10-25 19:08:17',1,'2025-10-25 19:09:06',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(36,4,22,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNTQ2LCJleHAiOjE3NjM5ODI1NDYsImlzcyI6InNhaWxvLWFwcCJ9.lUHutDDxczrkRdJA5Ju6VtmvDlimGztZNjjCxMe0laU','2025-11-24 19:09:06','2025-10-25 19:09:06',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(38,4,23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNjE1LCJleHAiOjE3NjM5ODI2MTUsImlzcyI6InNhaWxvLWFwcCJ9.ZH9JN9z-86SS29Mbuq1_lfx9ZBZRFSIpY6_z4jVGEJs','2025-11-24 19:10:15','2025-10-25 19:10:15',1,'2025-10-25 19:10:17',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(39,4,23,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNjE3LCJleHAiOjE3NjM5ODI2MTcsImlzcyI6InNhaWxvLWFwcCJ9.zBzuBG2pgn68338c4wzBowTYs6uKBSZ_qpBEVn2c4wU','2025-11-24 19:10:17','2025-10-25 19:10:17',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(41,4,24,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNzEzLCJleHAiOjE3NjM5ODI3MTMsImlzcyI6InNhaWxvLWFwcCJ9.JujIJGnW1iWzOhV1UwibrlCJSiB2OuQK8IQF5_QFCx0','2025-11-24 19:11:54','2025-10-25 19:11:53',1,'2025-10-25 19:11:55',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(42,4,24,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwNzE1LCJleHAiOjE3NjM5ODI3MTUsImlzcyI6InNhaWxvLWFwcCJ9.Uiy3uU2l6ve7S7E0uveacxo5JcHmIm0n3G7nuNm_by4','2025-11-24 19:11:55','2025-10-25 19:11:55',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(44,4,25,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwODQ4LCJleHAiOjE3NjM5ODI4NDgsImlzcyI6InNhaWxvLWFwcCJ9.N9nj44j1dLU8IgvgtGLu0_cqvz3WdloRxubRoxMUep4','2025-11-24 19:14:08','2025-10-25 19:14:08',1,'2025-10-25 19:14:09',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(45,4,25,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkwODQ5LCJleHAiOjE3NjM5ODI4NDksImlzcyI6InNhaWxvLWFwcCJ9.4RjX9aYQoQDZS6kzqvkDb6xEKdEWBqzAU86zI54mMSA','2025-11-24 19:14:10','2025-10-25 19:14:09',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(47,4,26,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6MjYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxMzkxMDM5LCJleHAiOjE3NjM5ODMwMzksImlzcyI6InNhaWxvLWFwcCJ9.aNIhOPzRlSdT8vetfaHGj9thwjKIGjf_aURVRRN12qw','2025-11-24 19:17:19','2025-10-25 19:17:19',1,'2025-10-25 19:17:44',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(52,3,31,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTQ5MDk3LCJleHAiOjE3NjQxNDEwOTcsImlzcyI6InNhaWxvLWFwcCJ9.ibbFvoOm7qknVGGj23vsxDyKPM9xxJ5Qt4rLz79-QuQ','2025-11-26 15:11:38','2025-10-27 15:11:37',1,'2025-10-27 15:11:56','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(53,3,32,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTQ5Nzk3LCJleHAiOjE3NjQxNDE3OTcsImlzcyI6InNhaWxvLWFwcCJ9.zxLjDjtAlogDnj9zcA2QxAuSbpNWpbc6fRERPtGhEqo','2025-11-26 15:23:18','2025-10-27 15:23:17',1,'2025-10-27 15:23:30','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(54,3,33,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTUxMTU2LCJleHAiOjE3NjQxNDMxNTYsImlzcyI6InNhaWxvLWFwcCJ9.cV4ZkyDUCMu2dCkosx8cPlAxHdBW9ZKcAdFjy9p1p2w','2025-11-26 15:45:57','2025-10-27 15:45:56',1,'2025-10-27 15:58:16','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(55,3,34,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTUxOTA5LCJleHAiOjE3NjQxNDM5MDksImlzcyI6InNhaWxvLWFwcCJ9.7mug7s7Dqg9RJB9dpPhodrPD8A3F0y6-7EF26aV8YsA','2025-11-26 15:58:29','2025-10-27 15:58:29',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(56,3,35,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTUxOTE5LCJleHAiOjE3NjQxNDM5MTksImlzcyI6InNhaWxvLWFwcCJ9.XNLWiNfQk8pqUFBPZHkxzal1SwXVRGF1cSCkjxdW9eI','2025-11-26 15:58:40','2025-10-27 15:58:39',1,'2025-10-27 16:24:50','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(57,3,36,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTUzNDk1LCJleHAiOjE3NjQxNDU0OTUsImlzcyI6InNhaWxvLWFwcCJ9.B9Y9aZC5bpGyP0ipXcGJKb2Us6QgSZxr3sbWDr5FJaU','2025-11-26 16:24:56','2025-10-27 16:24:55',1,'2025-10-27 18:46:59','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(58,3,36,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYyMDE5LCJleHAiOjE3NjQxNTQwMTksImlzcyI6InNhaWxvLWFwcCJ9.pE-mYaAgD9lpe1dkSBwHpNC2QlP7KYtkW2uC88EaGOw','2025-11-26 18:46:59','2025-10-27 18:46:59',1,'2025-10-27 18:52:57','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(59,3,36,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYyMzc3LCJleHAiOjE3NjQxNTQzNzcsImlzcyI6InNhaWxvLWFwcCJ9.0ytgkTdjnxCjeQU3djQgSjYpSTbdOoqE_SKjg8WLe48','2025-11-26 18:52:57','2025-10-27 18:52:57',1,'2025-10-27 18:53:07','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(60,3,37,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzcsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYyNDA2LCJleHAiOjE3NjQxNTQ0MDYsImlzcyI6InNhaWxvLWFwcCJ9.YxTaZwp7MbaB29VHts4VLIHq4zTIczv6jJxDHZ75HvA','2025-11-26 18:53:26','2025-10-27 18:53:26',1,'2025-10-27 19:01:19','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(61,3,38,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzgsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYyODkxLCJleHAiOjE3NjQxNTQ4OTEsImlzcyI6InNhaWxvLWFwcCJ9.Jl6TWsoiSvSuMEVjnL6kd4DtlXdNapOKzaIFJ_mlkaE','2025-11-26 19:01:32','2025-10-27 19:01:31',1,'2025-10-27 19:10:55','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(62,3,39,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6MzksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYzNDc5LCJleHAiOjE3NjQxNTU0NzksImlzcyI6InNhaWxvLWFwcCJ9.HnmVMtawEWSlJmtlyYUGaxM6oIe3lEhdLNrpB3vFS4k','2025-11-26 19:11:20','2025-10-27 19:11:19',1,'2025-10-27 19:11:54','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(63,3,40,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NDAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTYzNTIwLCJleHAiOjE3NjQxNTU1MjAsImlzcyI6InNhaWxvLWFwcCJ9.Z3sZqfWiMkP8tHAfyCVJP5CllMhwXiNllZk0GJyFTmo','2025-11-26 19:12:01','2025-10-27 19:12:00',1,'2025-10-27 19:22:12','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(64,3,40,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NDAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY0MTMyLCJleHAiOjE3NjQxNTYxMzIsImlzcyI6InNhaWxvLWFwcCJ9.5eiIJyc5-GMNu_9_dG7pvXCiJnXQd2STU3hSy4A1QTU','2025-11-26 19:22:13','2025-10-27 19:22:12',1,'2025-10-27 20:08:17','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(65,3,40,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NDAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY2ODk3LCJleHAiOjE3NjQxNTg4OTcsImlzcyI6InNhaWxvLWFwcCJ9.lEDCd8vkhiKJ62KicA7SnS-lwKq79qkmfb94jq3Ffyw','2025-11-26 20:08:18','2025-10-27 20:08:17',1,'2025-10-27 20:19:13','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(66,4,41,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY3NTU5LCJleHAiOjE3NjQxNTk1NTksImlzcyI6InNhaWxvLWFwcCJ9.ZRDybhCXn7Ds65MSUCoJs4t0b3Fom9EAagxeRoHX4YA','2025-11-26 20:19:19','2025-10-27 20:19:19',1,'2025-10-27 20:19:24',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(67,4,42,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY3ODkwLCJleHAiOjE3NjQxNTk4OTAsImlzcyI6InNhaWxvLWFwcCJ9.XgOqUH6DQn53LPBes3AtpPobtC8f13-nI9jlsWG5VTo','2025-11-26 20:24:51','2025-10-27 20:24:50',1,'2025-10-27 20:28:08',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(68,4,43,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4MDk1LCJleHAiOjE3NjQxNjAwOTUsImlzcyI6InNhaWxvLWFwcCJ9.lVf7NcEFHYunLF5yJbn4SP7fZCpuBdgJyUWQa2UuWZM','2025-11-26 20:28:15','2025-10-27 20:28:15',1,'2025-10-27 20:30:08',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(69,4,44,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4MjE0LCJleHAiOjE3NjQxNjAyMTQsImlzcyI6InNhaWxvLWFwcCJ9.X5gl5REgBueyfGkGxmXxuz7Q9Bty26m9GM8k72j1wok','2025-11-26 20:30:14','2025-10-27 20:30:14',1,'2025-10-27 20:30:19',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(70,4,45,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4MjI1LCJleHAiOjE3NjQxNjAyMjUsImlzcyI6InNhaWxvLWFwcCJ9.EtiFW-nEJSOhqbMeF9kcaySphGix7EAXzO_ZICbOu0g','2025-11-26 20:30:25','2025-10-27 20:30:25',1,'2025-10-27 20:30:29',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(71,3,46,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NDYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4MjM1LCJleHAiOjE3NjQxNjAyMzUsImlzcyI6InNhaWxvLWFwcCJ9.qQdyXyU1vPYSJSHRonF7Jda7DTKgRPzplcWILIhvBWI','2025-11-26 20:30:35','2025-10-27 20:30:35',1,'2025-10-27 20:30:47','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(72,4,47,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDcsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4MjUzLCJleHAiOjE3NjQxNjAyNTMsImlzcyI6InNhaWxvLWFwcCJ9.WYVm5qHUwJv_-jbDPMX4-_Tqn9gGxw2VY9CZp4RhgIU','2025-11-26 20:30:53','2025-10-27 20:30:53',1,'2025-10-27 20:33:25',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(73,4,48,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDgsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4NDExLCJleHAiOjE3NjQxNjA0MTEsImlzcyI6InNhaWxvLWFwcCJ9.e2ymRxs46D1r5DeCaJCSjMiptSrZhFcFzNBVJdu3Bk8','2025-11-26 20:33:31','2025-10-27 20:33:31',1,'2025-10-27 20:37:12',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(74,4,49,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NDksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4NjM5LCJleHAiOjE3NjQxNjA2MzksImlzcyI6InNhaWxvLWFwcCJ9.rUtsUB6VmQ5j4Hv9T2W437b68ipnARSbkuFEfwvCx9g','2025-11-26 20:37:19','2025-10-27 20:37:19',1,'2025-10-27 20:37:22',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(75,4,50,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NTAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY4OTI5LCJleHAiOjE3NjQxNjA5MjksImlzcyI6InNhaWxvLWFwcCJ9.8M3xJvDB-Cdk3_gP0rXsQG_N4cy4jz7A_nbOMNbFC4k','2025-11-26 20:42:10','2025-10-27 20:42:09',1,'2025-10-27 20:43:25',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(76,4,51,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NTEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY5MDExLCJleHAiOjE3NjQxNjEwMTEsImlzcyI6InNhaWxvLWFwcCJ9.9luHISwOdpe0Ijmx4Dh-aeIjR46-XkDSGUhYckmqKm0','2025-11-26 20:43:32','2025-10-27 20:43:31',1,'2025-10-27 20:44:59',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(77,4,52,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NTIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY5MTA1LCJleHAiOjE3NjQxNjExMDUsImlzcyI6InNhaWxvLWFwcCJ9.zrgh4YDlHfQC_InRI7hCAExKrtOE8P7SO_zBI3Qcang','2025-11-26 20:45:06','2025-10-27 20:45:05',1,'2025-10-27 20:45:32',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(78,3,53,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY5MTM4LCJleHAiOjE3NjQxNjExMzgsImlzcyI6InNhaWxvLWFwcCJ9.6vkjMesmN7T9vE2yyhbX0pT4YtnYWYOAwJvtb2Q9aJA','2025-11-26 20:45:38','2025-10-27 20:45:38',1,'2025-10-27 20:45:41','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(79,3,54,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY5MzM5LCJleHAiOjE3NjQxNjEzMzksImlzcyI6InNhaWxvLWFwcCJ9.coIu82moCl2-C8kXkXZ-hxfBkMNS7GShpQtmybs5lOk','2025-11-26 20:49:00','2025-10-27 20:48:59',1,'2025-10-27 20:59:05','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(80,3,54,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTY5OTQ1LCJleHAiOjE3NjQxNjE5NDUsImlzcyI6InNhaWxvLWFwcCJ9.YeEtgOw2vk3fAuzrpjdVrcZ6ZidA7WWhK_IAB5kUp9Q','2025-11-26 20:59:06','2025-10-27 20:59:05',1,'2025-10-27 21:11:38','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(81,3,54,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTcwNjk4LCJleHAiOjE3NjQxNjI2OTgsImlzcyI6InNhaWxvLWFwcCJ9.KuUO3Czc8SfjXv6QelixWpVkeIEHmW79_X94YHFTXOk','2025-11-26 21:11:39','2025-10-27 21:11:38',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(83,3,55,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTcwNzExLCJleHAiOjE3NjQxNjI3MTEsImlzcyI6InNhaWxvLWFwcCJ9.-KtmFchY1bMbd31-wdRHbBCU_HcUtWv6x5YeGtPXhEg','2025-11-26 21:11:51','2025-10-27 21:11:51',1,'2025-10-27 21:21:51','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(84,3,55,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTcxMzExLCJleHAiOjE3NjQxNjMzMTEsImlzcyI6InNhaWxvLWFwcCJ9.BDSY4F9IRVWq0Hf8IbnXESKNNPdF4vx5QAduRhIPgt4','2025-11-26 21:21:52','2025-10-27 21:21:51',1,'2025-10-27 21:46:54','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(85,3,55,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTcyODE0LCJleHAiOjE3NjQxNjQ4MTQsImlzcyI6InNhaWxvLWFwcCJ9.xsoJ-OSkFhxCa9sOO5BiwJZrElXhJnN7h_camsaMjDQ','2025-11-26 21:46:55','2025-10-27 21:46:54',1,'2025-10-27 21:47:51','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(86,4,56,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NTYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTcyODgwLCJleHAiOjE3NjQxNjQ4ODAsImlzcyI6InNhaWxvLWFwcCJ9.ltAmCxoGEfojgLH4OYYb4Rv0HxHvvgRxymN4F_12Q9E','2025-11-26 21:48:01','2025-10-27 21:48:00',1,'2025-10-27 21:48:08',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(87,3,57,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTcsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTczMDEwLCJleHAiOjE3NjQxNjUwMTAsImlzcyI6InNhaWxvLWFwcCJ9.f_Ug1pvrl1MH6SIVuU7fzTA-k6hqK_3orTKstKB_ZWA','2025-11-26 21:50:11','2025-10-27 21:50:10',1,'2025-10-27 23:35:35','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(88,4,58,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NTgsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTc5Mzc2LCJleHAiOjE3NjQxNzEzNzYsImlzcyI6InNhaWxvLWFwcCJ9.p1WbyNZsqpiJ1dpRtGtHdrwrN-x3FAobVhOKpvWb3v0','2025-11-26 23:36:16','2025-10-27 23:36:16',1,'2025-10-27 23:36:21',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(89,3,59,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NTksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTc5Mzg4LCJleHAiOjE3NjQxNzEzODgsImlzcyI6InNhaWxvLWFwcCJ9.78vNizMlu8UQc67Pu3lHMqTXVtnxpC5UsROVtPhhM1Q','2025-11-26 23:36:28','2025-10-27 23:36:28',1,'2025-10-27 23:36:37','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(92,3,62,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjIsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTc5OTc4LCJleHAiOjE3NjQxNzE5NzgsImlzcyI6InNhaWxvLWFwcCJ9.foWSpAQYeMZ-V7SglA7gZTld4X9bn1YYSPZ0QcCxAS4','2025-11-26 23:46:18','2025-10-27 23:46:18',1,'2025-10-27 23:46:26','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(93,3,63,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTc5OTk5LCJleHAiOjE3NjQxNzE5OTksImlzcyI6InNhaWxvLWFwcCJ9.6eRFqZvvGZcBQWckuxEyYqRi5XeXXo_iSdwvhrTp_6E','2025-11-26 23:46:40','2025-10-27 23:46:39',1,'2025-10-27 23:48:58','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(94,3,64,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTgwMzg5LCJleHAiOjE3NjQxNzIzODksImlzcyI6InNhaWxvLWFwcCJ9.ekj38R-tZksy-ekTTQd_vuJLMdyjb_u4SuBFHigBG3k','2025-11-26 23:53:09','2025-10-27 23:53:09',1,'2025-10-27 23:53:46','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(95,3,65,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjUsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNTgwNzU1LCJleHAiOjE3NjQxNzI3NTUsImlzcyI6InNhaWxvLWFwcCJ9.1QrpqN_A4f_qXrSfkGcKE4s6-UMMi5UVjXpltQtoq84','2025-11-26 23:59:16','2025-10-27 23:59:15',1,'2025-10-27 23:59:53','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(96,4,66,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjQsInNlc3Npb25JZCI6NjYsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE0NTE4LCJleHAiOjE3NjQyMDY1MTgsImlzcyI6InNhaWxvLWFwcCJ9.VmxoeUwLnDGJdGaBDU__td3udYXM8GCrTbRZi4CPUK0','2025-11-27 09:21:58','2025-10-28 09:21:58',1,'2025-10-28 09:22:30',NULL,NULL,'3601070f076aea470f02a155da573a202a8d5847e0173e6924f379a62ffe7023'),(97,3,67,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjcsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE0NTU1LCJleHAiOjE3NjQyMDY1NTUsImlzcyI6InNhaWxvLWFwcCJ9.ywvcyOv1_033RVFZ6yGyYTjIjNDlNbW9645xwZkaJ6E','2025-11-27 09:22:35','2025-10-28 09:22:35',1,'2025-10-28 09:23:02','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(99,3,69,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NjksInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE0NjE3LCJleHAiOjE3NjQyMDY2MTcsImlzcyI6InNhaWxvLWFwcCJ9.1NT3S-ufEMvPGqYecp-csg_jAg2hTmIm31LV-6pwApc','2025-11-27 09:23:38','2025-10-28 09:23:37',1,'2025-10-28 09:33:43','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(100,9,70,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjksInNlc3Npb25JZCI6NzAsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE1MjcyLCJleHAiOjE3NjQyMDcyNzIsImlzcyI6InNhaWxvLWFwcCJ9.TWlYYZMbCfRr-UrzvQXGMnnmcyazo6Vt1sl4dj9dVKE','2025-11-27 09:34:32','2025-10-28 09:34:32',1,'2025-10-28 09:35:34','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(101,9,71,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjksInNlc3Npb25JZCI6NzEsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE1MzQxLCJleHAiOjE3NjQyMDczNDEsImlzcyI6InNhaWxvLWFwcCJ9.uZnL_lO8Omn2Df6Vd_c5Jj1JNi-ujXAtLomqJpZZxIg','2025-11-27 09:35:41','2025-10-28 09:35:41',1,'2025-10-28 09:35:47','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(103,5,73,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjUsInNlc3Npb25JZCI6NzMsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE1NDU0LCJleHAiOjE3NjQyMDc0NTQsImlzcyI6InNhaWxvLWFwcCJ9.Kb7wrX0eG12GWxxfuz4xvJZjo1mMO-hrHjQI9J1BIzQ','2025-11-27 09:37:35','2025-10-28 09:37:34',1,'2025-10-28 09:37:39','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0'),(104,3,74,'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInNlc3Npb25JZCI6NzQsInR5cGUiOiJyZWZyZXNoIiwiaWF0IjoxNzYxNjE1NjA3LCJleHAiOjE3NjQyMDc2MDcsImlzcyI6InNhaWxvLWFwcCJ9.Qz9j7g2zMCYKIFDh0HGYVtNokdCAllwIVHV4v1mmpjc','2025-11-27 09:40:07','2025-10-28 09:40:07',0,NULL,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','bfe9b89f8a0a44dc36da0139e25998867f5b6c22c9308586e917fca27991c8c0');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Session ID',
  `user_id` int NOT NULL COMMENT '使用者 ID',
  `session_token` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Session Token (唯一識別碼)',
  `access_token_hash` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Access Token Hash (用於驗證)',
  `expires_at` datetime NOT NULL COMMENT 'Session 過期時間',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  `last_activity` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最後活動時間',
  `is_active` tinyint(1) DEFAULT '1' COMMENT '是否啟用',
  `user_agent` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '使用者代理 (瀏覽器資訊)',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP 位址 (支援 IPv6)',
  `device_info` json DEFAULT NULL COMMENT '裝置資訊 (作業系統、瀏覽器版本等)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_token` (`session_token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_token` (`session_token`),
  KEY `idx_expires_at` (`expires_at`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_last_activity` (`last_activity`),
  KEY `idx_user_session_status` (`user_id`,`is_active`,`expires_at`),
  CONSTRAINT `sessions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sessions 表 - 追蹤使用者會話狀態';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
INSERT INTO `sessions` VALUES (15,8,'4d106fa83469d79a0dee0a8d01c2ffe404b7147e92b2636dc7a7160a9a2e5d1af5971355dc3bbb4a9168c442b04dadea4bc11b9f192c11fed3d52fbf87d16998','98d31211d0665d7b6418bcf1e97f6a22f283866803a914ee63ba8a8dfce4f966','2025-10-26 17:56:54','2025-10-25 17:56:54','2025-10-25 17:57:05',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(17,3,'4b10a8499d91993e58b9e9384a21148e5f214f9dbdc7c0df02b4e8dc1fa3f74ea65c195a0035c24cf2e4919c5b5e4a2873fbaef5b412e8c348e7b31b4f007599','8d4b6d4e414412467c15198afb10ee763243d50346bbc78f2818c739db92650d','2025-10-26 18:06:26','2025-10-25 18:06:26','2025-10-25 18:06:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(19,4,'3c6884998e8800defd07659ac492af495117c79ead9889b8885f76c5a71111f116145e7c3aa642778e438acab9b62843fc6ad75972bc2c8f647d59907fa98d54','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:02:01','2025-10-25 19:02:01','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(20,4,'04711820fd711a41f80df34d66415f2d73c27f2d2c4ee1ae0970c22f96b0c903bdf25aaa842c63c20c2709d02cd727849eba04c8a4995fc72ffb35a0a947e14d','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:02:39','2025-10-25 19:02:38','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(21,4,'9c2ea648c36835eaa5b3f767455339e2bd0ef3ecea8cfe9bea9ff6c3b54e0e70162f07a19e6d6adbfd50ff25b663748d3691449160f009697f909e5eb14ac1d1','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:06:13','2025-10-25 19:06:13','2025-10-25 19:08:13',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(22,4,'65f01dbb56ec8db76047f29ae0f5191116aa7c051e62197dd905fd2956b3d4edab6ff6b8a1b61ca50e5a9c3d3b37c61b3ce4ed474c9c0588281d062a943ae8c7','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:08:17','2025-10-25 19:08:17','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(23,4,'9dc70f1acddadcb361797e87f5db4918080c6ffa0422bdd6d5417294ba4bd44bc7d82f7684d2feaa619d02c32a439b47624b87abed4742dba5569f34e1896424','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:10:15','2025-10-25 19:10:15','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(24,4,'534cb833eb538ae78173b201c261b219a10e2833093d8eb0cf2b6a85ef2af31fa44277d8f7c6e4c2cfb4525a20dfbf753158226e99ea3898e14d45c488323c66','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:11:54','2025-10-25 19:11:53','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(25,4,'d8b6f742101c8455250109fbbe8a5d61f5809920a6f5cc5396eaf3c6e19c5486c69f4a4eebadec708568da6d62422c733e0b60975e2d772b8bfa19f456bef493','8d3a4310782ed11654708481a971289b2b41320c78fe2ca10c0be5d9c3af9b5b','2025-10-26 19:14:08','2025-10-25 19:14:08','2025-10-27 15:07:52',0,NULL,NULL,'{\"os\": \"Unknown\", \"device\": \"Unknown\", \"browser\": \"Unknown\"}'),(26,4,'e5ee505053fca76ffc07693cf976922c0a83794d970a785e4ceaf91e568c18650dd17c9d81bbd0729e318cc3ef433dba0d1157aae8e2e6257bb485cf6054609d','e2504d4931047fdd150e5dd55ca05460149d1a262d94c1d9ddd3ed353f0db7ca','2025-10-26 19:17:19','2025-10-25 19:17:19','2025-10-25 19:17:44',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(31,3,'20b923c681224b92bc9b8d20539857031212144e11cf72f60331c672b959a03cf8f2cf3ebd85f26d8a748a327897d89a4ddc3b0e9e397c12d8546226db9c3e39','9963e8cc3b63d780c4ffa38defb2d77c7d9d4fcedd726b092e8f841f8d60a826','2025-10-28 15:11:38','2025-10-27 15:11:37','2025-10-27 15:11:56',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(32,3,'6fb7f396797d205940c800411196314efe887b3edd99c2983530df947fc96adfbed56e0dd538f2df1254199075e185254a334c88a10b75f402d7c97be7b5239d','d6a2d23a4b30363a23f266c89324cec3204cfac15843b17bae0c37dbec59af27','2025-10-28 15:23:18','2025-10-27 15:23:17','2025-10-27 15:23:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(33,3,'449a608731ca7fb6abe45ddf3fd6d05c2b5e72fe02175f0067d496e4650dc44d3f304bcba6d9ae97a325e4271d446b5ab5e337cf0e95871f66c57821ab4345e8','a79c7d65786ab7368cc99f88043b3632038f9bcd4e1fb51e1b9e61c82ac1ef08','2025-10-28 15:45:57','2025-10-27 15:45:56','2025-10-27 15:58:16',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(34,3,'4d0be076bbf3577d77e8e01cf9aa6ddd0541dfea004d93de51cb15cbbb827ee37da6063cc0f90354d4a284a7a382df9a8be4057e9fa6a2a172a7ddc2badfab2b','a153b19bccaf18cf4df936e7346722ae2da0354657f9948c53fa045f383e08bd','2025-10-28 15:58:29','2025-10-27 15:58:29','2025-10-27 15:58:29',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(35,3,'b0edc9d04f6f3322843e082288e0ced2bf233370d346f355c096e01609e74bf4160ccfd7ffc4158d603f1adf6a29b9a3f6be7d362553f6fb50e7d9ae0fbbc933','8393ad45ed3187032bd4b4c7dcaa3d326ae14c520f2f8de29fc21a7df283ed0a','2025-10-28 15:58:40','2025-10-27 15:58:39','2025-10-27 16:24:50',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(36,3,'b22e582d73589db6e8fc96120775c0efe7eb5222f9f914e1017d9790482e066f326c1ca95f3633e230d7f5a74777d4587ddec4445abf994a79644454a6c9f39b','f7c7a2cd8b8ddebd750b0f04833b36ae85eb7ed729d8ec94642fef4f8da2b64f','2025-10-28 16:24:56','2025-10-27 16:24:55','2025-10-27 18:53:07',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(37,3,'f93b6587141b940cb437533b11e2b272e123ccdc883f9028b7d1d9a2fef7cb836b3749170eb225f08dfc4e24ad1f569bbdaa59a5d9ef593a39938c40646dbf59','b97f4b174a340c4796ef4a25a21d184494f958dde74c2974784a0dcab4fe998f','2025-10-28 18:53:26','2025-10-27 18:53:26','2025-10-27 19:01:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(38,3,'fe67bf320650b361d30d355624561455a6c26e1808db48efb8e8d6d59e8d13af1b03eb021bf7034faa31369d186457c267d6f047460f4da49c9d8daae187ddb3','4145d6b289bd244a4a36f93f39ab713e7c0d51aa06f06a4394cba73b3ecb6162','2025-10-28 19:01:31','2025-10-27 19:01:31','2025-10-27 19:10:55',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(39,3,'463cd6bc9dee0a5ea691338f153d365936f6ab1e53574e6adecdcac68cfd4194e8d4e2536aae22527797c38b50d39237f3a6c794a7b6f75557850232e2abd21e','0f50d55cc5f9e3673e3ce7257638a6c16141336eff0e7fdb38f29a9986584a77','2025-10-28 19:11:20','2025-10-27 19:11:19','2025-10-27 19:11:54',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(40,3,'2e3a498684b0024699bdd037c4b4860218eacbd35f02e390d6eb027700191e49b462908214d8929bd6855f83e8a62c46278ff1aa263cf2418905399d78a59e4e','cff3663ec1dd456089eaecfe6317d79b2a615f2083d8da9550ef4f4c8c614c44','2025-10-28 19:12:01','2025-10-27 19:12:00','2025-10-27 20:19:13',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(41,4,'9003f7f1222b74f38620e711623d09e5d52eff8f5374f515a93cbf6e5f60cb0a6ee5c3793722abf662a21d74617dcbe3fb7ee387d5080b0dbd54858bde4c35c3','008ab55788c083422873904c7aac5de615f9e8fac1a65ceb781f748398dd95fa','2025-10-28 20:19:19','2025-10-27 20:19:19','2025-10-27 20:19:24',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(42,4,'03f10f87b9d67b64d98092c6a0a5b746e554f68000f16b7f197efd55d9064cbb8150a640e07004348c8703cc93abc4f3e17e7f82d7cb43e89655901b92069c65','5f9b500febf18782f90bf526aed13676e9ff2517df5cb8d66dfd738ab8fc3599','2025-10-28 20:24:51','2025-10-27 20:24:50','2025-10-27 20:28:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(43,4,'daa1aca2c5cc5d5a40fe317e14e79e9dacfe5b080b8a4ad0bd2604bbc1a0109411b6c456d49007d94c549a790ec66e04098641ba5329e1305e6318a469e6cd94','e66f17ac777d64b77d962d76abc648a5edfa90ded57eb1ca87ea4dd258c89bf0','2025-10-28 20:28:15','2025-10-27 20:28:15','2025-10-27 20:30:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(44,4,'4f2492d4fef6862577e1c69babc420d4f799082df740956e0a43314a0cdbe32d57c0522de175782f82f4fa52fb9b6a99d6838c2c1fb4ba4bcb91c9c06b6916ae','de3f0818ae259b91cb6b4fefef1a3c18bf490dc8b31fa50a3b3154704d643539','2025-10-28 20:30:14','2025-10-27 20:30:14','2025-10-27 20:30:19',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(45,4,'d4fc54dcdaa1b3eecb585527aaf651577555da01384c9d80fbb092fb0bec4543e8ee1a85d6fd7b4f3bc9c0ad050e8dc7e2bb42853b7f6b985aa03b6faaa1659f','8027f503a5a1b599fa4654486d17f4f1c431ccd99b4e5b7b1cd1d946e553726d','2025-10-28 20:30:25','2025-10-27 20:30:25','2025-10-27 20:30:29',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(46,3,'112e5f7eac748c83b1587b28d2c84174bac0eeff2361b4282d2a9061c6d6483b704f8ff8376c7c3161d067bfa411db17af2289259994f3392160a3c94cf71b76','d0c0ff7c9f6fbd677d4fcd3f36e40fd48ddb885d17e65054782efae92be9e9f2','2025-10-28 20:30:35','2025-10-27 20:30:35','2025-10-27 20:30:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(47,4,'f8380d3fb2490d0c39bc21db8988852ae6c2e347537bd2f48aa6b0e269ba30319536c6c5be9faa8b768a089a0b3453adca6d0cf1235f39bededaeab59ec03751','a7200ff8b1560bd2ee531e4db28b8c62bbcad7444f10320390ba598a402cbf7d','2025-10-28 20:30:53','2025-10-27 20:30:53','2025-10-27 20:33:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(48,4,'85b3e70caac8a846cae02c281d81e130feeeebbeb9d08715ce800d716297cb1540bf3ee9297b4ab78d352da7cab38ec5d83e57cb919342116443ea2ade2b7c71','65152b2fec1c7f21d0663c90a1c2d82194184b77f4abb71667b50007e0cfbcfc','2025-10-28 20:33:31','2025-10-27 20:33:31','2025-10-27 20:37:12',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(49,4,'076299265658def43d2b4869625f99aa6754ef5e6e0e81904eedf6dc4ca8f26fa175c9d11f2d9c78ccfe6ab4df9fb1adc173e0b326662ff6ba6db29e6a44391f','ce27c15835f42e38e01d488de9860be13968f7d07b3599b04be9e2ba44c540f1','2025-10-28 20:37:19','2025-10-27 20:37:19','2025-10-27 20:37:22',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(50,4,'213bee336a703bc8196ed27d500bfe772c8e2f3bd11a9cf30c8ad0c810d65f3951ce12f665f57553497adcdd715eb30737c697d5491f22bbbb00c2b98fa8299e','149db0dc77a95360ee0df4e849161fb58f31cf44da72fecdfffa8deb9bd7a0aa','2025-10-28 20:42:10','2025-10-27 20:42:09','2025-10-27 20:43:25',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(51,4,'a3ec7cbe5809977b191b0f0892a30e3b76730ebf8f4a5d5e424afbdaf67b27a43491f949dc318011b0b94109655338bf722feedc85ba19eee7a416fa3b87a861','42f1951550166959a17bacd0ed0ffaff9abcf7414c2c3f8a46d596bf8cffec48','2025-10-28 20:43:32','2025-10-27 20:43:31','2025-10-27 20:44:59',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(52,4,'a2d8434f5a439d0725395feaddc74b1fdf8f81941933949d6a9bafed20b57e7baf034c15d412dbbcbf00794262382e23226a75c8edaaef6edefc97eb1239d707','97be8707ddc28695d37b8702c42fadb79003e416a6d5836ffd7e94cd38fc658f','2025-10-28 20:45:05','2025-10-27 20:45:05','2025-10-27 20:45:32',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(53,3,'1017789151527a7dea90fbf6f6b8fd1283921a7e2b3dd891ec580168aaf20fe6d00fcda56b9d44825dd59f8c4aebcae05dd9932c55e2738226d2c27bc9acf51d','5e3e9596fcd2d4f05ecf701e6fa62875e4ff8117fcc86b19e96e8ca859df20de','2025-10-28 20:45:38','2025-10-27 20:45:38','2025-10-27 20:45:41',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(54,3,'16fb60f9cf30d41888b585a77f14fd09be09eefa4526ff01768853e57c9747ea3f306b05ac395c37df3bebc9f4b86f6c300f9b90187f0cb801493c14373dd604','18f7718c24f2b4194121627095e259a5f67c45ee63bb893b51de07b5b7273197','2025-10-28 20:49:00','2025-10-27 20:48:59','2025-10-27 20:48:59',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(55,3,'a85cc8308899fafecdd75e685197a63c874259bc2aec9dde4b2f7445bd9e743389129b802bec1468885961720d084129c020b227b8ac1b5fac22380201a9c75e','22759e307e401ecbf7c2f4d8fec2ab5f034c04796550dacfe04392bcb799a926','2025-10-28 21:11:51','2025-10-27 21:11:51','2025-10-27 21:47:51',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(56,4,'0e4ba9a4dfd6a4927d223ba3ecaf50328a650b0750870c8d9e95c351abff123b296acadc6225e0fe803f27258c3b124c3ef91e64747a5cb97d5df49de2244167','5be75699071c3f124a851dd9cfbd60551c5f5af74fe35bf9e3a2812141539370','2025-10-28 21:48:01','2025-10-27 21:48:00','2025-10-27 21:48:08',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(57,3,'3c26ec14842d694151556d69b4c4b6e3f82686c627417569d9a779e9c78f43470ba2abb0161164eb97a450fa69f6cc011af5c70b8028a05f1681f4e0472797b9','eea96d75ae88b53b629aa233863b1a44a1affb60f601add0eb41449818cf9a42','2025-10-28 21:50:11','2025-10-27 21:50:10','2025-10-27 23:35:35',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(58,4,'e5b5c5b336d0863fc4106763dfa02c0524c92ad71a46145c6326126899af57c16de857cab715e3f91e13fa1f7585c76def90ceb8b445dd29903bffd775d23258','2e6744b1a144b75d82fd5969f0a718067ed78e73dbf45f8bdd404f5a72f42365','2025-10-28 23:36:16','2025-10-27 23:36:16','2025-10-27 23:36:21',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(59,3,'a93bdcea1b9ad22cd48a5b5dd7e06a03d06a9b58973ee60674864dfb96e49bc370ab067f381e1d9bb72d475dd4b18e55354b17c9dc041170bcfba72225f5866c','922a9f9e26456831702c99be43efc269aea99488a8aabcb623a8f78bcf4357e9','2025-10-28 23:36:28','2025-10-27 23:36:28','2025-10-27 23:36:37',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(62,3,'4c2b563cfc2a5bbffe3316064853eac1ccdedec4dc47b4f960dd9d97e9bc8d3da6fdaedbd50ad81e36641f3228a825fec45ee572f7ff6e6c0a41767ea2851693','40aa6faad2c38abf5fa8191f9e0b094c33627d44b11a0b03b4e7086bae849001','2025-10-28 23:46:18','2025-10-27 23:46:18','2025-10-27 23:46:26',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(63,3,'e806badae3bce3cca4c96ec6531996ee0e62c786c8736abd3466afb9a906526e9d887e0b3bf6ae49d8e49e3520176db591565a898d509582c6957939fd1e8365','a1b70d5aa5cfe54a68256dc83e7a7e3c2f5dc53b9351aca828c8926329966814','2025-10-28 23:46:40','2025-10-27 23:46:39','2025-10-27 23:48:58',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(64,3,'edbd670bf9e202a16c8ea5469483dfdbff5a77a69ea608afb733a1df95f0432fa4a9f373e67c3897672def69f94a894bc1a1e577e47a9a489a2f2d264a30655f','d4549d16bea852f868dfe52d1704d40e05f9b3faef4486b53720e5afb26156c8','2025-10-28 23:53:09','2025-10-27 23:53:09','2025-10-27 23:53:46',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(65,3,'35c7ecf9a0d9c2226f994e2466303d773a818f467725f34c964fbb08c60b853df35715e2743cc7f8840356e2ae8976de69985e0ba9cc3a871fba444cc156a44c','b4582d8eac29210d81fbe81ff4bd7f73759d8a5786e04219d92a8dca92183f1b','2025-10-28 23:59:16','2025-10-27 23:59:15','2025-10-27 23:59:53',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(66,4,'5c7d6e0dae48069e86059123131f53a7b7b5a579966d875e76be39ef649e0425dda23e3f5e3e77380bff2ab6a6aa7498b888efd6e790686a5e5de9fa04b71ebb','2b76bc79e911541be8062ae9453ee74544fe6d1188c114fb4bfcaa080d3771ac','2025-10-29 09:21:58','2025-10-28 09:21:58','2025-10-28 09:22:30',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(67,3,'17825de60a9344e0ef5dc7250daa1034c82444e74196a05af25e575b9a4d516696cd5ffbf937d8669f6ced681aeb0235b45a86b027e3479c32abf7578b9b46b8','1b33ccccc01a6f04ab955d9fc6e5ebe7d56837925d6c36fa17c0ae73c7dcd5f3','2025-10-29 09:22:35','2025-10-28 09:22:35','2025-10-28 09:23:02',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(69,3,'020f21bd9ade5ed15cd56d5ef30a56882521a70965efc7c2ef45e6aada484bc2a263c09cd63ab11a6b835744dd92326d1ae7161a381e4ee608c471404db7d198','540c38b31e8c5808c61ab09bdf771211d48366a08d46512d8f3e893790763db6','2025-10-29 09:23:38','2025-10-28 09:23:37','2025-10-28 09:33:43',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(70,9,'ccf67dd050e5fca3533faf8dd7bfb9456c18e657686307b51f1d931b916e8352aa2fdeaa3b3431e475a55c9a122c24e83d760db16fa3efe9d643e72ff3628184','efd7cb5d14124d93ddce39d01602cbee5d40bd2f872f7a7e8e9155a0980dbc36','2025-10-29 09:34:32','2025-10-28 09:34:32','2025-10-28 09:35:34',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(71,9,'9d9000f1883198ab9c1f489c5afc705728735d29aed60481662bb696c9bb9b87392978b255b29f8d5172df590fe96a4aa29f76b32309afafe8089e06303224e2','ecb7f3e823648709db32a8823063dc14b76094e588ed9312d24e4beb0b9b84a8','2025-10-29 09:35:41','2025-10-28 09:35:41','2025-10-28 09:35:47',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(73,5,'9bf3fea9cd480d1595d14521eedfe79ca3db2956d6102ba5c977693f1ae1e67b5d810397607f29666caeb7886880b1a47a53782cfbd2905c6faf234bfb781736','99f6dce8c8800242c37e81f0136b80b4ccfbb03b13b72f5224c92d8c55e6b2bb','2025-10-29 09:37:35','2025-10-28 09:37:34','2025-10-28 09:37:39',0,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}'),(74,3,'a78ef2ba36f6f18e09fe5ae283bb0d7559731a9dd9c14fbce127c7b5c99cb9fcfa1b0b2f985fff975b8db2273c35128d0a40a99afe0e65fe31d7cabe89f4441d','0d7d1894e7b5f7f662aea85f359da96ed682e7703a8e6a422b4618da160b415c','2025-10-29 09:40:07','2025-10-28 09:40:07','2025-10-28 09:40:07',1,'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36','::1','{\"os\": \"Windows\", \"device\": \"Desktop\", \"browser\": \"Chrome\"}');
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sns_tags`
--

DROP TABLE IF EXISTS `sns_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sns_tags` (
  `tag_id` int NOT NULL AUTO_INCREMENT,
  `tagname` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `tagname` (`tagname`),
  KEY `idx_tagname` (`tagname`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sns_tags`
--

LOCK TABLES `sns_tags` WRITE;
/*!40000 ALTER TABLE `sns_tags` DISABLE KEYS */;
INSERT INTO `sns_tags` VALUES (1,'日本','2025-10-22 11:31:06'),(2,'1234','2025-10-22 11:51:32'),(3,'美食','2025-10-22 11:51:32'),(4,'8888','2025-10-28 09:26:14');
/*!40000 ALTER TABLE `sns_tags` ENABLE KEYS */;
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
-- Table structure for table `trip_days`
--

DROP TABLE IF EXISTS `trip_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip_days` (
  `trip_day_id` int NOT NULL AUTO_INCREMENT COMMENT '行程天數編號',
  `trip_id` int DEFAULT NULL COMMENT '所屬行程編號',
  `date` date DEFAULT NULL COMMENT '日期',
  `day_number` int DEFAULT NULL COMMENT '第幾天',
  PRIMARY KEY (`trip_day_id`),
  KEY `idx_trip_id` (`trip_id`),
  KEY `idx_date` (`date`),
  CONSTRAINT `fk_trip_days_trips` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_days`
--

LOCK TABLES `trip_days` WRITE;
/*!40000 ALTER TABLE `trip_days` DISABLE KEYS */;
INSERT INTO `trip_days` VALUES (1,3,'2025-09-30',1),(2,3,'2025-10-01',2),(3,3,'2025-10-02',3),(4,3,'2025-10-03',4),(5,3,'2025-10-04',5),(6,3,'2025-10-05',6),(7,3,'2025-10-06',7),(8,3,'2025-10-07',8),(9,4,'2025-10-07',1),(10,4,'2025-10-08',2),(11,4,'2025-10-09',3),(12,4,'2025-10-10',4),(13,4,'2025-10-11',5),(14,4,'2025-10-12',6),(15,4,'2025-10-13',7),(16,4,'2025-10-14',8),(17,4,'2025-10-15',9),(18,4,'2025-10-16',10),(19,4,'2025-10-17',11),(20,6,'2025-09-30',1),(21,6,'2025-10-01',2),(22,6,'2025-10-02',3),(23,6,'2025-10-03',4),(24,6,'2025-10-04',5),(25,6,'2025-10-05',6),(26,6,'2025-10-06',7),(27,6,'2025-10-07',8),(28,7,'2025-09-30',1),(29,7,'2025-10-01',2),(30,7,'2025-10-02',3),(31,7,'2025-10-03',4),(32,7,'2025-10-04',5),(33,7,'2025-10-05',6),(34,7,'2025-10-06',7),(35,7,'2025-10-07',8),(36,8,'2025-07-30',1),(37,8,'2025-07-31',2),(38,8,'2025-08-01',3),(39,8,'2025-08-02',4),(40,8,'2025-08-03',5),(41,8,'2025-08-04',6),(42,8,'2025-08-05',7),(43,8,'2025-08-06',8),(44,8,'2025-08-07',9),(45,8,'2025-08-08',10),(46,8,'2025-08-09',11),(47,8,'2025-08-10',12),(48,8,'2025-08-11',13),(49,8,'2025-08-12',14),(50,8,'2025-08-13',15),(51,8,'2025-08-14',16),(52,8,'2025-08-15',17),(53,8,'2025-08-16',18),(54,8,'2025-08-17',19),(55,8,'2025-08-18',20),(56,8,'2025-08-19',21),(57,8,'2025-08-20',22),(58,8,'2025-08-21',23),(59,8,'2025-08-22',24),(60,8,'2025-08-23',25),(61,8,'2025-08-24',26),(62,8,'2025-08-25',27),(63,8,'2025-08-26',28),(64,8,'2025-08-27',29),(65,8,'2025-08-28',30),(66,8,'2025-08-29',31),(67,8,'2025-08-30',32),(68,8,'2025-08-31',33),(69,8,'2025-09-01',34),(70,8,'2025-09-02',35),(71,8,'2025-09-03',36),(72,8,'2025-09-04',37),(73,8,'2025-09-05',38),(74,8,'2025-09-06',39),(75,8,'2025-09-07',40),(76,8,'2025-09-08',41),(77,8,'2025-09-09',42),(78,8,'2025-09-10',43),(79,8,'2025-09-11',44),(80,8,'2025-09-12',45),(81,8,'2025-09-13',46),(82,8,'2025-09-14',47),(83,8,'2025-09-15',48),(84,8,'2025-09-16',49),(85,8,'2025-09-17',50),(86,8,'2025-09-18',51),(87,8,'2025-09-19',52),(88,8,'2025-09-20',53),(89,8,'2025-09-21',54),(90,8,'2025-09-22',55),(91,8,'2025-09-23',56),(92,8,'2025-09-24',57),(93,8,'2025-09-25',58),(94,8,'2025-09-26',59),(95,8,'2025-09-27',60),(96,8,'2025-09-28',61),(97,8,'2025-09-29',62),(98,8,'2025-09-30',63),(99,8,'2025-10-01',64),(100,8,'2025-10-02',65),(101,8,'2025-10-03',66),(102,8,'2025-10-04',67),(103,8,'2025-10-05',68),(104,8,'2025-10-06',69),(105,8,'2025-10-07',70),(106,8,'2025-10-08',71);
/*!40000 ALTER TABLE `trip_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip_favorites`
--

DROP TABLE IF EXISTS `trip_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip_favorites` (
  `favorite_id` int NOT NULL AUTO_INCREMENT COMMENT '收藏編號',
  `user_id` int DEFAULT NULL COMMENT '使用者編號',
  `trip_id` int DEFAULT NULL COMMENT '行程編號',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `unique_user_trip` (`user_id`,`trip_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_trip_id` (`trip_id`),
  CONSTRAINT `fk_trip_favorites_trips` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`trip_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_trip_favorites_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_favorites`
--

LOCK TABLES `trip_favorites` WRITE;
/*!40000 ALTER TABLE `trip_favorites` DISABLE KEYS */;
INSERT INTO `trip_favorites` VALUES (1,3,3,'2025-10-27 21:39:30');
/*!40000 ALTER TABLE `trip_favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip_items`
--

DROP TABLE IF EXISTS `trip_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip_items` (
  `trip_item_id` int NOT NULL AUTO_INCREMENT COMMENT '行程項目編號',
  `trip_day_id` int DEFAULT NULL COMMENT '所屬行程天編號',
  `place_id` int DEFAULT NULL COMMENT '景點編號',
  `type` enum('景點','餐廳','住宿','交通') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '項目類型',
  `note` text COLLATE utf8mb4_unicode_ci COMMENT '備註',
  `start_time` time DEFAULT NULL COMMENT '開始時間',
  `end_time` time DEFAULT NULL COMMENT '結束時間',
  `sort_order` int DEFAULT NULL COMMENT '排序序號',
  PRIMARY KEY (`trip_item_id`),
  KEY `idx_trip_day_id` (`trip_day_id`),
  KEY `idx_place_id` (`place_id`),
  KEY `idx_sort_order` (`sort_order`),
  CONSTRAINT `fk_trip_items_places` FOREIGN KEY (`place_id`) REFERENCES `places` (`place_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_trip_items_trip_days` FOREIGN KEY (`trip_day_id`) REFERENCES `trip_days` (`trip_day_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_items`
--

LOCK TABLES `trip_items` WRITE;
/*!40000 ALTER TABLE `trip_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `trip_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trips`
--

DROP TABLE IF EXISTS `trips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trips` (
  `trip_id` int NOT NULL AUTO_INCREMENT COMMENT '行程編號',
  `trip_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '行程名稱',
  `user_id` int DEFAULT NULL COMMENT '建立者編號',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT '行程描述',
  `start_date` date DEFAULT NULL COMMENT '開始日期',
  `end_date` date DEFAULT NULL COMMENT '結束日期',
  `cover_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '封面圖片 URL',
  `is_public` tinyint(1) DEFAULT '0' COMMENT '是否公開行程',
  `location_id` int DEFAULT NULL COMMENT '主要旅遊地區',
  `summary_text` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '行程摘要',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  PRIMARY KEY (`trip_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_location_id` (`location_id`),
  KEY `idx_is_public` (`is_public`),
  KEY `idx_start_date` (`start_date`),
  CONSTRAINT `fk_trips_locations` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_trips_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trips`
--

LOCK TABLES `trips` WRITE;
/*!40000 ALTER TABLE `trips` DISABLE KEYS */;
INSERT INTO `trips` VALUES (1,'台北週末小旅行',3,'探索台北市區景點與美食','2025-10-18','2025-10-20','https://example.com/taipei.jpg',0,1,'三天兩夜台北自由行','2025-10-14 11:53:24'),(3,'高雄好吃',3,'高雄好吃','2025-09-30','2025-10-07','https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80',1,NULL,'高雄好吃','2025-10-27 21:39:11'),(4,'高雄好吃',3,'高雄好吃','2025-10-07','2025-10-17','https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80',1,NULL,'高雄好吃1','2025-10-27 21:40:16'),(6,'高雄好吃 - 複製',3,'高雄好吃','2025-09-30','2025-10-07','https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80',0,NULL,'高雄好吃','2025-10-27 21:50:35'),(7,'高雄好吃 - 複製 - 複製',3,'高雄好吃','2025-09-30','2025-10-07','https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80',0,NULL,'高雄好吃','2025-10-28 09:28:13'),(8,'122313',3,'12313','2025-07-30','2025-10-08','https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=800&q=80',1,NULL,'123123','2025-10-28 09:28:30');
/*!40000 ALTER TABLE `trips` ENABLE KEYS */;
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
  `avatar_file_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'ImageKit 檔案 ID，用於刪除頭像',
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
  KEY `idx_phone` (`phone`),
  KEY `idx_avatar_file_id` (`avatar_file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶主表 - 儲存所有使用者基本資料與Google 2FA資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@sailotravel.com','$2a$10$N9qo8uLOickgx2ZMRZoMye6zKWuQ.Hs0K0YFl.8G3Q5kUvnvJZLCm','系統管理員','Admin',NULL,NULL,NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,1,1,5,NULL,'2025-10-02 15:34:29','2025-10-02 16:32:21'),(2,'user@sailotravel.com','$2a$10$CwTycUXWue0Thq9StjUM0uJ8fWnHNsZwNvSBYCdH5aIMqLbhFEW.i','測試使用者','小測',NULL,NULL,NULL,NULL,'user',NULL,NULL,NULL,NULL,0,NULL,1,1,6,'2025-10-02 16:11:20','2025-10-02 15:34:29','2025-10-02 16:12:07'),(3,'sailo@sailo.com','$2b$10$AvC7ELxmIeR.UfNUP0A94u6VCeNg.wUMxiCW7JQNI71euwMHuJ4g2','測試使用者','sailo',NULL,NULL,NULL,NULL,'admin',NULL,NULL,NULL,'JVGXIVDDH4ZXOTJMGI4DCV3IJEYCKY2MN47FOP3EIVEFMJDTFJHQ',0,'[\"8DB0A5D0\", \"96BA6805\", \"9BCC2563\", \"ECB90081\", \"B181238A\", \"AB1A79FD\", \"438A3044\", \"5F21090E\", \"04CE936A\", \"69FE9B84\"]',1,1,0,NULL,'2025-10-02 15:45:49','2025-10-27 15:59:39'),(4,'lsin38533@gmail.com',NULL,'sin lee','LEE','0912345678',NULL,'https://lh3.googleusercontent.com/a/ACg8ocIONNrgIA92oWX3lYfatNHkgQimPYe1LbUOJkNOV4WPq2zX5Q=s96-c','68f9d2ac5c7cd75eb8e97666','user','1998-01-01','male','106960716538466056444',NULL,0,NULL,1,1,0,NULL,'2025-10-15 02:28:08','2025-10-28 01:21:58'),(5,'sailotest00@gmail.com','$2b$10$q/uJtgKdJ9bzdWt3qVtfj.CaLpuAWWRc7UevrAnUFxdecR2AmJ9uG','sailo','sailo','0912345678',NULL,'https://ik.imagekit.io/crjen7iza/avatars/avatar_5_1761385987674_X2VD38oH3','68fc9e055c7cd75eb8ec92fe','user','1998-01-05',NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-15 05:34:31','2025-10-28 01:37:18'),(6,'travel01@travel.com','$2b$10$5nKNNM3aNnIZR0AbRKxvF.SY2DFtavVkFsti8itD6gKUIAgBWAb8y','travel01','travel01','0912345678',NULL,NULL,NULL,'user',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-15 07:49:26','2025-10-15 07:49:26'),(7,'sailoadmin@sailo.com','$2b$10$bYuI/CiUPr4iEPElbFSXuu.0TN4G1OYJ9dSULda7a/ob/KUySx2j6','sailoadmin','sailoadmin','0912345678',NULL,'https://ik.imagekit.io/crjen7iza/avatars/avatarxxx01.png?updatedAt=1761200375843',NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-23 07:43:53','2025-10-23 07:49:04'),(8,'sailooo@sailo.com','$2b$10$ntLY0QIEoULUM.P2kjgtyuAlpO9nn3UTouOA0B1OFuPSYlZ.RJ8bG','sailooo','sailooo','0912345678',NULL,'https://ik.imagekit.io/crjen7iza/avatars/avatarxxx01.png?updatedAt=1761200375843',NULL,'user',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-25 09:56:27','2025-10-25 09:56:27'),(9,'sailoo@sailo.com','$2b$10$Cm6BljOhHS5606C.7DZT7.fUAVsdW560pjmSwrZRZfJWckqDbFIFu','sailoo','sailoo','0912345678',NULL,'https://ik.imagekit.io/crjen7iza/avatars/avatarxxx01.png?updatedAt=1761200375843',NULL,'user',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-28 01:34:21','2025-10-28 01:35:29');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_active_refresh_tokens`
--

DROP TABLE IF EXISTS `v_active_refresh_tokens`;
/*!50001 DROP VIEW IF EXISTS `v_active_refresh_tokens`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_active_refresh_tokens` AS SELECT 
 1 AS `id`,
 1 AS `user_id`,
 1 AS `email`,
 1 AS `name`,
 1 AS `created_at`,
 1 AS `expires_at`,
 1 AS `user_agent`,
 1 AS `ip_address`,
 1 AS `days_until_expiry`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_active_sessions`
--

DROP TABLE IF EXISTS `v_active_sessions`;
/*!50001 DROP VIEW IF EXISTS `v_active_sessions`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_active_sessions` AS SELECT 
 1 AS `session_id`,
 1 AS `user_id`,
 1 AS `email`,
 1 AS `name`,
 1 AS `created_at`,
 1 AS `expires_at`,
 1 AS `last_activity`,
 1 AS `user_agent`,
 1 AS `ip_address`,
 1 AS `minutes_until_expiry`,
 1 AS `refresh_tokens_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_session_tokens`
--

DROP TABLE IF EXISTS `v_session_tokens`;
/*!50001 DROP VIEW IF EXISTS `v_session_tokens`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_session_tokens` AS SELECT 
 1 AS `session_id`,
 1 AS `user_id`,
 1 AS `email`,
 1 AS `session_token`,
 1 AS `session_created`,
 1 AS `last_activity`,
 1 AS `refresh_token_id`,
 1 AS `token_created`,
 1 AS `token_expires`,
 1 AS `token_revoked`,
 1 AS `token_hours_until_expiry`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'sailo_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `cleanup_expired_auth_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `cleanup_expired_auth_data`()
BEGIN
  -- 停用過期的 Sessions
  UPDATE sessions 
  SET is_active = FALSE 
  WHERE expires_at < NOW() AND is_active = TRUE;
  
  -- 撤銷過期的 Refresh Tokens
  UPDATE refresh_tokens 
  SET revoked = TRUE, revoked_at = NOW() 
  WHERE expires_at < NOW() AND revoked = FALSE;
  
  -- 刪除超過 30 天的過期 Sessions (保留資料用於分析)
  DELETE FROM sessions 
  WHERE is_active = FALSE 
    AND expires_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
  
  -- 刪除超過 30 天的已撤銷 Refresh Tokens
  DELETE FROM refresh_tokens 
  WHERE revoked = TRUE 
    AND revoked_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
  
  -- 返回清理統計
  SELECT 
    '清理完成' AS status,
    (SELECT COUNT(*) FROM sessions WHERE is_active = FALSE) AS inactive_sessions,
    (SELECT COUNT(*) FROM refresh_tokens WHERE revoked = TRUE) AS revoked_tokens;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_active_refresh_tokens`
--

/*!50001 DROP VIEW IF EXISTS `v_active_refresh_tokens`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_active_refresh_tokens` AS select `rt`.`id` AS `id`,`rt`.`user_id` AS `user_id`,`u`.`email` AS `email`,`u`.`name` AS `name`,`rt`.`created_at` AS `created_at`,`rt`.`expires_at` AS `expires_at`,`rt`.`user_agent` AS `user_agent`,`rt`.`ip_address` AS `ip_address`,timestampdiff(DAY,now(),`rt`.`expires_at`) AS `days_until_expiry` from (`refresh_tokens` `rt` join `users` `u` on((`rt`.`user_id` = `u`.`id`))) where ((`rt`.`revoked` = false) and (`rt`.`expires_at` > now())) order by `rt`.`created_at` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_active_sessions`
--

/*!50001 DROP VIEW IF EXISTS `v_active_sessions`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_active_sessions` AS select `s`.`id` AS `session_id`,`s`.`user_id` AS `user_id`,`u`.`email` AS `email`,`u`.`name` AS `name`,`s`.`created_at` AS `created_at`,`s`.`expires_at` AS `expires_at`,`s`.`last_activity` AS `last_activity`,`s`.`user_agent` AS `user_agent`,`s`.`ip_address` AS `ip_address`,timestampdiff(MINUTE,now(),`s`.`expires_at`) AS `minutes_until_expiry`,count(`rt`.`id`) AS `refresh_tokens_count` from ((`sessions` `s` join `users` `u` on((`s`.`user_id` = `u`.`id`))) left join `refresh_tokens` `rt` on(((`rt`.`session_id` = `s`.`id`) and (`rt`.`revoked` = false)))) where ((`s`.`is_active` = true) and (`s`.`expires_at` > now())) group by `s`.`id` order by `s`.`last_activity` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_session_tokens`
--

/*!50001 DROP VIEW IF EXISTS `v_session_tokens`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_session_tokens` AS select `s`.`id` AS `session_id`,`s`.`user_id` AS `user_id`,`u`.`email` AS `email`,`s`.`session_token` AS `session_token`,`s`.`created_at` AS `session_created`,`s`.`last_activity` AS `last_activity`,`rt`.`id` AS `refresh_token_id`,`rt`.`created_at` AS `token_created`,`rt`.`expires_at` AS `token_expires`,`rt`.`revoked` AS `token_revoked`,timestampdiff(HOUR,now(),`rt`.`expires_at`) AS `token_hours_until_expiry` from ((`sessions` `s` join `users` `u` on((`s`.`user_id` = `u`.`id`))) left join `refresh_tokens` `rt` on((`rt`.`session_id` = `s`.`id`))) where (`s`.`is_active` = true) order by `s`.`last_activity` desc,`rt`.`created_at` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-28  9:46:08
