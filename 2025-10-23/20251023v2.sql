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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bookmarks`
--

LOCK TABLES `bookmarks` WRITE;
/*!40000 ALTER TABLE `bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_detail`
--

DROP TABLE IF EXISTS `cart_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` tinyint NOT NULL,
  `unit_price` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cart_id` (`cart_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_cart_detail_carts` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_detail_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_detail`
--

LOCK TABLES `cart_detail` WRITE;
/*!40000 ALTER TABLE `cart_detail` DISABLE KEYS */;
INSERT INTO `cart_detail` VALUES (3,1,48,2,180,'2025-10-23 13:47:52','2025-10-23 13:47:52'),(4,1,49,1,280,'2025-10-23 13:47:52','2025-10-23 13:47:52');
/*!40000 ALTER TABLE `cart_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carts`
--

DROP TABLE IF EXISTS `carts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_carts_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carts`
--

LOCK TABLES `carts` WRITE;
/*!40000 ALTER TABLE `carts` DISABLE KEYS */;
INSERT INTO `carts` VALUES (1,1,'2025-10-23 13:47:52','2025-10-23 13:47:52');
/*!40000 ALTER TABLE `carts` ENABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_list_places`
--

LOCK TABLES `favorite_list_places` WRITE;
/*!40000 ALTER TABLE `favorite_list_places` DISABLE KEYS */;
INSERT INTO `favorite_list_places` VALUES (59,1,1),(2,1,2),(60,1,7),(56,1,16),(18,1,21),(19,1,24),(50,4,18);
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorite_lists`
--

LOCK TABLES `favorite_lists` WRITE;
/*!40000 ALTER TABLE `favorite_lists` DISABLE KEYS */;
INSERT INTO `favorite_lists` VALUES (1,1,'我的最愛','測試用清單',NULL,'2025-10-18 17:48:08'),(2,1,'測試','測試',NULL,'2025-10-18 18:56:42'),(4,1,'123','123123',NULL,'2025-10-21 09:37:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶登入日誌 - 記錄所有登入行為與安全資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login_logs`
--

LOCK TABLES `login_logs` WRITE;
/*!40000 ALTER TABLE `login_logs` DISABLE KEYS */;
INSERT INTO `login_logs` VALUES (1,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:08'),(2,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:39:26'),(3,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:40:59'),(4,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:41:06'),(5,2,'user@sailotravel.com','local','::1',NULL,0,'Account locked due to too many failed attempts',0,'2025-10-02 15:41:20'),(6,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:40'),(7,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:43:46'),(8,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:46:05'),(9,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:05'),(10,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 15:51:08'),(11,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:10:55'),(12,2,'user@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:12:07'),(13,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:14:53'),(14,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:22:21'),(15,1,'admin@sailotravel.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:32:21'),(16,3,'sailo@sailo.com','local','::1',NULL,0,'Invalid password',0,'2025-10-02 16:44:35'),(17,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-02 17:12:10'),(18,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-02 17:12:49'),(19,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:01:50'),(20,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 03:58:16'),(21,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-03 04:01:33'),(22,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-03 08:23:02'),(23,3,'sailo@sailo.com','local','::1',NULL,1,NULL,0,'2025-10-13 03:03:38'),(24,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-13 03:03:56'),(25,3,'sailo@sailo.com','local','::1',NULL,1,'Logout',0,'2025-10-13 03:03:57');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media`
--

LOCK TABLES `media` WRITE;
/*!40000 ALTER TABLE `media` DISABLE KEYS */;
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
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` tinyint NOT NULL,
  `unit_price` int NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_order_detail_orders` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_detail_products` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,49,3,280,'2025-10-23 13:47:52','2025-10-23 13:47:52'),(2,2,48,1,180,'2025-10-23 13:47:52','2025-10-23 13:47:52');
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `order_date` timestamp NOT NULL,
  `total` int NOT NULL,
  `payment_method` tinyint NOT NULL,
  `payment_status` tinyint NOT NULL,
  `recipient_name` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shipping_method` tinyint NOT NULL,
  `shipping_address` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_status` tinyint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_order_date` (`order_date`),
  KEY `idx_order_status` (`order_status`),
  CONSTRAINT `fk_orders_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,'2025-10-20 19:29:50',840,1,0,'系統管理員','6134401419',1,'129 Cresthaven Dr.',0,'2025-10-23 13:47:52','2025-10-23 13:47:52'),(2,1,'2025-10-20 19:31:53',180,1,0,'系統管理員','6134401419',1,'129 Cresthaven Dr.',0,'2025-10-23 13:47:52','2025-10-23 13:47:52');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='密碼重置表 - 儲存忘記密碼的重置Token';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_resets`
--

LOCK TABLES `password_resets` WRITE;
/*!40000 ALTER TABLE `password_resets` DISABLE KEYS */;
INSERT INTO `password_resets` VALUES (1,'lsin38533@gmail.com','ebe3acda933f70e770e0c741d3bfdeece8c5961863468421611fb9a691ff2fc5','2025-10-15 03:45:20',0,'2025-10-15 02:45:20'),(2,'sailotest00@gmail.com','16886811e5a2efa2919a2b62a39d40f2e9d8b29d90d0a512f0cd737f14cc2413','2025-10-15 06:35:13',0,'2025-10-15 05:35:12'),(3,'sailotest00@gmail.com','11ff25131b35fde42a8ed37cfeb01a1c3a53a9f814a4947ab4120c53c68113c3','2025-10-15 06:51:14',1,'2025-10-15 05:51:14'),(4,'sailotest00@gmail.com','59be8001b102da3775808b10154f269ea685ca66799608c6fcea931d874fcebe','2025-10-15 07:01:58',0,'2025-10-15 06:01:57'),(5,'sailotest00@gmail.com','ee29b2bcfa2cab5160b4db680d7a7b3760b6e75728a1891abe21b8036273a6a7','2025-10-15 08:50:00',1,'2025-10-15 07:49:59'),(6,'sailotest00@gmail.com','6d0fb6506d6811beb58bac7f91cc7e9df0e6b89ec103651e88a9ec6dced63223','2025-10-15 08:59:35',0,'2025-10-15 07:59:35'),(7,'sailotest00@gmail.com','59e659d6092145ad57f7b71e3f6c6c7e14248281e53cbd2fa8219f7c45f32582','2025-10-15 09:00:01',1,'2025-10-15 08:00:01'),(8,'sailotest00@gmail.com','27f0ce2611a9f2cef0ef4e532fe2dc6940bd0ae18b1bf8810eabdc8f9da2ee0a','2025-10-23 06:31:16',1,'2025-10-23 05:31:15');
/*!40000 ALTER TABLE `password_resets` ENABLE KEYS */;
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
INSERT INTO `pd_review` VALUES (1,1,1,5.0,'超級實用的旅行組合！','包裝精美，牙刷質量很好，牙膏也不會漏。收納盒設計很貼心，放在行李箱不佔空間。出差旅行必備！','[\"https://example.com/images/review1_1.jpg\", \"https://example.com/images/review1_2.jpg\"]',1,15,1,'2025-10-15 18:00:00','2025-10-18 00:54:21'),(2,1,2,4.5,'性價比高','整體來說很不錯，唯一小缺點是牙刷的刷毛稍微硬了一點，但其他都很滿意。',NULL,1,8,1,'2025-10-15 22:30:00','2025-10-18 00:54:21'),(3,1,3,4.0,'還可以','基本功能都有，但收納盒的扣子不太好開。',NULL,0,3,1,'2025-10-16 17:15:00','2025-10-18 00:54:21'),(4,6,1,5.0,'充電神器！','容量超大，可以充滿我的iPhone 3次還有剩。支援快充真的很方便，出門再也不用擔心手機沒電了！','[\"https://example.com/images/review6_1.jpg\"]',1,42,1,'2025-10-15 00:20:00','2025-10-18 00:54:21'),(5,6,2,4.5,'充電速度快','雙USB輸出很實用，可以同時充兩個設備。LED電量顯示清楚，但稍微有點重量。',NULL,1,22,1,'2025-10-15 19:00:00','2025-10-18 00:54:21'),(6,6,3,5.0,'旅行必備','帶去日本旅遊，每天充手機和相機都沒問題，真的很耐用！','[\"https://example.com/images/review6_3.jpg\"]',1,18,1,'2025-10-16 18:30:00','2025-10-18 00:54:21'),(7,7,2,5.0,'出國必備神器','去了歐洲、日本都能用，內建USB充電孔超方便，不用再帶一堆轉接頭了！','[\"https://example.com/images/review7_1.jpg\"]',1,35,1,'2025-10-14 17:30:00','2025-10-18 00:54:21'),(8,7,3,4.5,'非常實用','適用大部分國家，USB充電功能很貼心，唯一缺點是體積稍大。',NULL,1,12,1,'2025-10-15 21:45:00','2025-10-18 00:54:21'),(9,8,3,5.0,'音質超讚！','降噪效果很好，搭飛機時完全不會被引擎聲打擾。電池續航力強，充電盒又多提供24小時，超滿意！','[\"https://example.com/images/review8_1.jpg\", \"https://example.com/images/review8_2.jpg\"]',1,56,1,'2025-10-13 23:00:00','2025-10-18 00:54:21'),(10,8,1,4.5,'性價比不錯','音質清晰，連線穩定，IPX5防水很實用。唯一小缺點是耳機稍微大了一點。',NULL,1,28,1,'2025-10-14 19:20:00','2025-10-18 00:54:21'),(11,8,2,5.0,'推薦購買','降噪功能真的很強，通勤時聽音樂超享受，充電速度也很快！',NULL,1,19,1,'2025-10-16 00:30:00','2025-10-18 00:54:21'),(12,11,1,4.5,'節省空間好幫手','不需要抽氣機，用手壓就能排氣，真的節省很多行李空間！材質也很耐用。','[\"https://example.com/images/review11_1.jpg\"]',1,25,1,'2025-10-15 20:00:00','2025-10-18 00:54:21'),(13,11,3,4.0,'實用但需要技巧','第一次用需要練習一下，熟悉後很方便。建議不要裝太滿，比較好壓縮。',NULL,1,10,1,'2025-10-16 16:30:00','2025-10-18 00:54:21'),(14,21,1,5.0,'露營神器！','真的很輕只有2.5kg！搭建超快速，防水效果也很好。去了三次露營都沒問題，強力推薦！','[\"https://example.com/images/review21_1.jpg\", \"https://example.com/images/review21_2.jpg\", \"https://example.com/images/review21_3.jpg\"]',1,67,1,'2025-10-16 22:00:00','2025-10-18 00:54:21'),(15,21,2,4.5,'很棒的帳篷','空間對兩個人來說剛剛好，通風設計不錯。唯一缺點是收納袋有點小，不太好收。',NULL,1,31,1,'2025-10-17 00:45:00','2025-10-18 00:54:21'),(16,21,3,5.0,'超值！','這個價格能買到這麼好的帳篷真的很划算，下大雨也沒有漏水，讚！',NULL,1,24,1,'2025-10-17 17:00:00','2025-10-18 00:54:21'),(17,27,3,5.0,'登山好夥伴','背負系統設計得很好，長時間背著也不會累。防水拉鍊很實用，多口袋設計方便分類。','[\"https://example.com/images/review27_1.jpg\"]',1,38,1,'2025-10-15 18:30:00','2025-10-18 00:54:21'),(18,27,2,4.5,'品質不錯','容量夠大，材質耐用。肩帶很舒適，但腰帶的扣環有點硬。',NULL,1,15,1,'2025-10-16 19:00:00','2025-10-18 00:54:21'),(19,36,3,5.0,'防曬效果超好','去海邊玩一整天都沒有曬傷！質地清爽不黏膩，而且防水抗汗，游泳也不用擔心。','[\"https://example.com/images/review36_1.jpg\"]',1,45,1,'2025-10-16 21:30:00','2025-10-18 00:54:21'),(20,36,1,4.5,'敏感肌適用','無香料配方很溫和，敏感肌用了也不會過敏。唯一缺點是要多抹幾次才能完全推開。',NULL,1,21,1,'2025-10-16 23:00:00','2025-10-18 00:54:21'),(21,41,3,5.0,'超好穿！','彈性很好，穿起來很舒服。防曬UPF50+真的有效，游完泳皮膚也沒曬傷。乾得很快！','[\"https://example.com/images/review41_1.jpg\", \"https://example.com/images/review41_2.jpg\"]',1,29,1,'2025-10-17 18:15:00','2025-10-18 00:54:21'),(22,41,2,4.5,'質感不錯','材質摸起來很舒服，抗氯防曬功能都很好。版型合身但不會太緊。',NULL,1,16,1,'2025-10-17 19:30:00','2025-10-18 00:54:21');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_comments`
--

LOCK TABLES `post_comments` WRITE;
/*!40000 ALTER TABLE `post_comments` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_likes`
--

LOCK TABLES `post_likes` WRITE;
/*!40000 ALTER TABLE `post_likes` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `post_tags`
--

LOCK TABLES `post_tags` WRITE;
/*!40000 ALTER TABLE `post_tags` DISABLE KEYS */;
INSERT INTO `post_tags` VALUES (2,2,2,'2025-10-22 11:51:32'),(3,2,3,'2025-10-22 11:51:32');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posts`
--

LOCK TABLES `posts` WRITE;
/*!40000 ALTER TABLE `posts` DISABLE KEYS */;
INSERT INTO `posts` VALUES (2,3,'123','13','food',2,1,4,'2025-10-22 11:51:32','2025-10-22 11:52:30');
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
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
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
INSERT INTO `products` VALUES (1,'旅行牙刷牙膏組','便攜式摺疊牙刷含牙膏，輕量防水設計，附收納盒，適合短期旅行使用',180.00,150,1,4.50,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(2,'旅行裝洗髮精沐浴乳組','50ml分裝瓶組合，TSA認證可登機，無矽靈配方溫和不刺激',250.00,120,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(3,'多功能沐浴露','三合一配方（洗髮/沐浴/洗臉），250ml大容量，天然植萃成分',320.00,100,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(4,'快乾旅行毛巾','超細纖維材質，吸水快乾，輕量僅80克，附收納袋',280.00,80,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(5,'摺疊矽膠旅行杯','350ml容量可摺疊，食品級矽膠，耐高溫可裝熱飲',350.00,90,1,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(6,'20000mAh行動電源','雙USB快充輸出，支援PD快充，LED電量顯示，可充手機4-5次',890.00,200,2,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(7,'萬國轉接頭','適用150+國家，內建USB充電孔，安全保護機制，輕巧便攜',650.00,180,2,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(8,'藍牙5.0無線耳機','降噪功能，IPX5防水，續航8小時，充電盒提供額外24小時',1280.00,100,2,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(9,'旅行萬用延長線','3插座+2USB孔，1.5米線長，過載保護，體積小方便攜帶',480.00,120,2,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(10,'防水手機腰包','觸控螢幕可操作，IPX8防水等級，可放6.5吋手機及護照現金',380.00,150,2,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(11,'真空壓縮袋5件組','節省50%行李空間，手捲式免抽氣機，耐用加厚材質',420.00,100,3,4.25,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(12,'旅行收納袋6件組','不同尺寸分類收納，防潑水尼龍布料，透氣網格設計',580.00,150,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(13,'內衣收納包','立體隔層保護胸型，可收納6-8套內衣褲，防水防塵',320.00,80,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(14,'鞋子收納袋3入組','防水防臭材質，透明視窗快速辨識，可收納運動鞋或皮鞋',380.00,90,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(15,'掛式盥洗包','大容量多夾層設計，可掛式節省空間，防水易清潔',680.00,70,3,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(16,'記憶泡棉U型枕','慢回彈記憶棉，人體工學設計，可調式鬆緊帶，附收納袋',580.00,120,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(17,'3D遮光眼罩耳塞組','完全遮光不壓迫眼球，柔軟透氣材質，附降噪耳塞',280.00,150,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(18,'TSA海關鎖行李束帶','TSA認證可過海關，螢光色易辨識，密碼鎖防盜',320.00,200,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(19,'便攜摺疊衣架5入組','可摺疊節省空間，防滑設計，承重3公斤，輕量塑鋼材質',180.00,100,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(20,'旅行護照證件包','RFID防盜刷功能，多卡層設計，可放護照/機票/現金/卡片',450.00,130,4,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(21,'2人輕量化帳篷','僅重2.5kg，快速搭建，防水係數3000mm，雙門雙層通風',3800.00,50,5,4.83,3,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(22,'羽絨睡袋800FP','填充800蓬鬆度羽絨，適溫-5°C，壓縮後僅25cm，重量900g',4200.00,40,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(23,'野餐防潮墊200x200','鋁箔防潮層，折疊收納輕便，適合2-4人使用，防水耐磨',680.00,80,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(24,'露營LED燈串','3段亮度調節，USB充電續航12小時，防水IP65，5米長',580.00,90,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(25,'摺疊露營桌椅組','鋁合金材質輕量化，承重120kg，5秒快速展開收納',2800.00,60,5,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(26,'碳纖維登山杖','超輕量僅180g/支，3段伸縮110-130cm，減震設計保護膝蓋',1680.00,70,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(27,'40L防水登山背包','防撕裂尼龍材質，透氣背負系統，防水拉鍊，多口袋分層',2800.00,80,6,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(28,'304不鏽鋼保溫瓶','真空保溫24小時，750ml大容量，防漏設計，可單手開啟',680.00,150,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(29,'速乾登山褲','彈性透氣快乾布料，多口袋設計，防潑水處理，UPF50+防曬',1280.00,100,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(30,'防滑登山鞋','Vibram黃金大底，Gore-Tex防水透氣，中筒保護腳踝',3200.00,60,6,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(31,'輕量化鋁合金三腳架','5節伸縮最高150cm，球型雲台360度旋轉，承重3kg，僅重800g',1680.00,70,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(32,'相機防水袋','IPX8防水等級，透明TPU可觸控操作，適用單眼及微單相機',880.00,90,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(33,'128GB高速記憶卡','V30錄影等級，讀取速度100MB/s，適合4K錄影',980.00,120,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(34,'單眼相機背包','防震內膽保護，上下層分離設計，可放15吋筆電，防潑水材質',2200.00,60,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(35,'便攜LED補光燈','可調色溫3200K-5600K，USB充電，磁吸底座可固定手機',780.00,100,7,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(36,'SPF50+防曬乳','物理性防曬，防水抗汗，80ml容量，無香料敏感肌適用',420.00,200,8,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(37,'旅行急救包','包含OK繃/消毒水/紗布/藥膏等30項急救用品，輕巧便攜',580.00,100,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(38,'天然防蚊液噴霧','天然精油配方，不含DEET，100ml噴霧瓶，4-6小時防護',280.00,150,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(39,'運動防曬袖套','UPF50+防曬係數，冰絲涼感材質，吸濕排汗彈性佳',220.00,180,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(40,'便攜式濾水瓶','4層過濾系統，可過濾99.9%細菌，650ml容量，適合戶外使用',1280.00,70,8,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(41,'快乾運動泳衣','彈性萊卡材質，抗氯防曬UPF50+，速乾透氣不悶熱',880.00,100,9,4.75,2,0,'2025-10-11 05:22:26','2025-10-18 00:54:21',1),(42,'超細纖維運動毛巾','吸水力是棉質3倍，40x80cm尺寸，附扣環可掛背包',280.00,150,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(43,'摺疊瑜珈墊','6mm厚度防滑，TPE環保材質，可摺疊方便攜帶，僅重1kg',980.00,80,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(44,'運動腰包','防水防汗材質，可放6.5吋手機，反光條夜跑安全，貼身不晃動',380.00,120,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(45,'快速充氣游泳圈','快速充氣閥30秒充飽，加厚PVC材質，適合成人使用',420.00,90,9,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(46,'自動開收折疊傘','一鍵自動開收，抗風骨架不易翻，直徑105cm大傘面',580.00,150,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(47,'輕便連帽雨衣','僅重200g可收納成小包，防水係數10000mm，反光條設計',380.00,180,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(48,'防水手機袋','IPX8防水等級，可觸控操作，透明雙面可拍照，附掛繩',180.00,200,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(49,'防水背包套','彈性束繩固定，反光Logo提升能見度，5種尺寸適用20-80L背包',280.00,120,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(50,'防水鞋套','加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺',320.00,100,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1),(51,'防水鞋套','加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺',320.00,100,10,0.00,0,0,'2025-10-11 05:22:26','2025-10-11 05:22:26',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sns_tags`
--

LOCK TABLES `sns_tags` WRITE;
/*!40000 ALTER TABLE `sns_tags` DISABLE KEYS */;
INSERT INTO `sns_tags` VALUES (1,'日本','2025-10-22 11:31:06'),(2,'1234','2025-10-22 11:51:32'),(3,'美食','2025-10-22 11:51:32');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_days`
--

LOCK TABLES `trip_days` WRITE;
/*!40000 ALTER TABLE `trip_days` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_favorites`
--

LOCK TABLES `trip_favorites` WRITE;
/*!40000 ALTER TABLE `trip_favorites` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trips`
--

LOCK TABLES `trips` WRITE;
/*!40000 ALTER TABLE `trips` DISABLE KEYS */;
INSERT INTO `trips` VALUES (1,'台北週末小旅行',3,'探索台北市區景點與美食','2025-10-18','2025-10-20','https://example.com/taipei.jpg',0,1,'三天兩夜台北自由行','2025-10-14 11:53:24'),(2,'高雄美食之旅',3,'品味高雄夜市與海港風情','2025-11-01','2025-11-03','https://example.com/kaohsiung.jpg',0,2,'高雄在地美食探索','2025-10-14 11:53:24');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用戶主表 - 儲存所有使用者基本資料與Google 2FA資訊';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin@sailotravel.com','$2a$10$N9qo8uLOickgx2ZMRZoMye6zKWuQ.Hs0K0YFl.8G3Q5kUvnvJZLCm','系統管理員','Admin',NULL,NULL,NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,1,1,5,NULL,'2025-10-02 15:34:29','2025-10-02 16:32:21'),(2,'user@sailotravel.com','$2a$10$CwTycUXWue0Thq9StjUM0uJ8fWnHNsZwNvSBYCdH5aIMqLbhFEW.i','測試使用者','小測',NULL,NULL,NULL,NULL,'user',NULL,NULL,NULL,NULL,0,NULL,1,1,6,'2025-10-02 16:11:20','2025-10-02 15:34:29','2025-10-02 16:12:07'),(3,'sailo@sailo.com','$2b$10$AvC7ELxmIeR.UfNUP0A94u6VCeNg.wUMxiCW7JQNI71euwMHuJ4g2','測試使用者','sailo',NULL,NULL,NULL,NULL,'admin',NULL,NULL,NULL,NULL,0,NULL,1,1,0,NULL,'2025-10-02 15:45:49','2025-10-02 17:12:10'),(4,'lsin38533@gmail.com',NULL,'sin lee','LEE','0912345678',NULL,'https://lh3.googleusercontent.com/a/ACg8ocIONNrgIA92oWX3lYfatNHkgQimPYe1LbUOJkNOV4WPq2zX5Q=s96-c','68f7204f5c7cd75eb8dd3612','user','1998-01-01','male','106960716538466056444',NULL,0,NULL,1,1,0,NULL,'2025-10-15 02:28:08','2025-10-23 03:50:05'),(5,'sailotest00@gmail.com','$2b$10$51GCDvjnsC5fnx0lpDVPzeIIvSA2dstbLFtNI0AHaU9Mr1PltA82W','sailo','sailo',NULL,NULL,'https://ik.imagekit.io/crjen7iza/avatars/avatar_5_1761026327511_fwHEjW1Ji','68f721115c7cd75eb8e1cc2c','user',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-15 05:34:31','2025-10-23 05:31:39'),(6,'travel01@travel.com','$2b$10$5nKNNM3aNnIZR0AbRKxvF.SY2DFtavVkFsti8itD6gKUIAgBWAb8y','travel01','travel01','0912345678',NULL,NULL,NULL,'user',NULL,NULL,NULL,NULL,0,NULL,0,1,0,NULL,'2025-10-15 07:49:26','2025-10-15 07:49:26');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-10-23 13:49:06
