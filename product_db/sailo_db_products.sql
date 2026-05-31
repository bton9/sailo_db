-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2025 年 10 月 21 日 16:12
-- 伺服器版本： 8.4.5
-- PHP 版本： 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `sailo_db`
--

-- --------------------------------------------------------

--
-- 資料表結構 `pd_favorite`
--

CREATE TABLE `pd_favorite` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '使用者ID (關聯 users.id)',
  `product_id` int NOT NULL COMMENT '商品ID (關聯 products.product_id)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品收藏表 - 記錄使用者收藏的商品';

--
-- 傾印資料表的資料 `pd_favorite`
--

INSERT INTO `pd_favorite` (`id`, `user_id`, `product_id`, `created_at`) VALUES
(1, 1, 1, '2025-10-15 02:30:00'),
(2, 1, 6, '2025-10-15 03:00:00'),
(3, 1, 11, '2025-10-15 06:20:00'),
(4, 1, 16, '2025-10-16 01:15:00'),
(5, 1, 21, '2025-10-16 07:45:00'),
(6, 2, 2, '2025-10-14 00:30:00'),
(7, 2, 7, '2025-10-14 02:45:00'),
(8, 2, 12, '2025-10-14 08:20:00'),
(9, 2, 18, '2025-10-15 03:30:00'),
(10, 2, 26, '2025-10-15 06:00:00'),
(11, 2, 31, '2025-10-16 02:20:00'),
(12, 3, 3, '2025-10-13 01:00:00'),
(13, 3, 8, '2025-10-13 05:15:00'),
(14, 3, 13, '2025-10-14 02:30:00'),
(15, 3, 22, '2025-10-14 07:45:00'),
(16, 3, 27, '2025-10-15 01:20:00'),
(17, 3, 32, '2025-10-15 08:30:00'),
(18, 3, 36, '2025-10-16 03:00:00'),
(19, 3, 41, '2025-10-17 00:45:00');

-- --------------------------------------------------------

--
-- 資料表結構 `pd_review`
--

CREATE TABLE `pd_review` (
  `id` int NOT NULL,
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
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ;

--
-- 傾印資料表的資料 `pd_review`
--

INSERT INTO `pd_review` (`id`, `product_id`, `user_id`, `rating`, `title`, `comment`, `images`, `is_verified_purchase`, `helpful_count`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 5.0, '超級實用的旅行組合！', '包裝精美，牙刷質量很好，牙膏也不會漏。收納盒設計很貼心，放在行李箱不佔空間。出差旅行必備！', '[\"https://example.com/images/review1_1.jpg\", \"https://example.com/images/review1_2.jpg\"]', 1, 15, 1, '2025-10-16 02:00:00', '2025-10-18 08:54:21'),
(2, 1, 2, 4.5, '性價比高', '整體來說很不錯，唯一小缺點是牙刷的刷毛稍微硬了一點，但其他都很滿意。', NULL, 1, 8, 1, '2025-10-16 06:30:00', '2025-10-18 08:54:21'),
(3, 1, 3, 4.0, '還可以', '基本功能都有，但收納盒的扣子不太好開。', NULL, 0, 3, 1, '2025-10-17 01:15:00', '2025-10-18 08:54:21'),
(4, 6, 1, 5.0, '充電神器！', '容量超大，可以充滿我的iPhone 3次還有剩。支援快充真的很方便，出門再也不用擔心手機沒電了！', '[\"https://example.com/images/review6_1.jpg\"]', 1, 42, 1, '2025-10-15 08:20:00', '2025-10-18 08:54:21'),
(5, 6, 2, 4.5, '充電速度快', '雙USB輸出很實用，可以同時充兩個設備。LED電量顯示清楚，但稍微有點重量。', NULL, 1, 22, 1, '2025-10-16 03:00:00', '2025-10-18 08:54:21'),
(6, 6, 3, 5.0, '旅行必備', '帶去日本旅遊，每天充手機和相機都沒問題，真的很耐用！', '[\"https://example.com/images/review6_3.jpg\"]', 1, 18, 1, '2025-10-17 02:30:00', '2025-10-18 08:54:21'),
(7, 7, 2, 5.0, '出國必備神器', '去了歐洲、日本都能用，內建USB充電孔超方便，不用再帶一堆轉接頭了！', '[\"https://example.com/images/review7_1.jpg\"]', 1, 35, 1, '2025-10-15 01:30:00', '2025-10-18 08:54:21'),
(8, 7, 3, 4.5, '非常實用', '適用大部分國家，USB充電功能很貼心，唯一缺點是體積稍大。', NULL, 1, 12, 1, '2025-10-16 05:45:00', '2025-10-18 08:54:21'),
(9, 8, 3, 5.0, '音質超讚！', '降噪效果很好，搭飛機時完全不會被引擎聲打擾。電池續航力強，充電盒又多提供24小時，超滿意！', '[\"https://example.com/images/review8_1.jpg\", \"https://example.com/images/review8_2.jpg\"]', 1, 56, 1, '2025-10-14 07:00:00', '2025-10-18 08:54:21'),
(10, 8, 1, 4.5, '性價比不錯', '音質清晰，連線穩定，IPX5防水很實用。唯一小缺點是耳機稍微大了一點。', NULL, 1, 28, 1, '2025-10-15 03:20:00', '2025-10-18 08:54:21'),
(11, 8, 2, 5.0, '推薦購買', '降噪功能真的很強，通勤時聽音樂超享受，充電速度也很快！', NULL, 1, 19, 1, '2025-10-16 08:30:00', '2025-10-18 08:54:21'),
(12, 11, 1, 4.5, '節省空間好幫手', '不需要抽氣機，用手壓就能排氣，真的節省很多行李空間！材質也很耐用。', '[\"https://example.com/images/review11_1.jpg\"]', 1, 25, 1, '2025-10-16 04:00:00', '2025-10-18 08:54:21'),
(13, 11, 3, 4.0, '實用但需要技巧', '第一次用需要練習一下，熟悉後很方便。建議不要裝太滿，比較好壓縮。', NULL, 1, 10, 1, '2025-10-17 00:30:00', '2025-10-18 08:54:21'),
(14, 21, 1, 5.0, '露營神器！', '真的很輕只有2.5kg！搭建超快速，防水效果也很好。去了三次露營都沒問題，強力推薦！', '[\"https://example.com/images/review21_1.jpg\", \"https://example.com/images/review21_2.jpg\", \"https://example.com/images/review21_3.jpg\"]', 1, 67, 1, '2025-10-17 06:00:00', '2025-10-18 08:54:21'),
(15, 21, 2, 4.5, '很棒的帳篷', '空間對兩個人來說剛剛好，通風設計不錯。唯一缺點是收納袋有點小，不太好收。', NULL, 1, 31, 1, '2025-10-17 08:45:00', '2025-10-18 08:54:21'),
(16, 21, 3, 5.0, '超值！', '這個價格能買到這麼好的帳篷真的很划算，下大雨也沒有漏水，讚！', NULL, 1, 24, 1, '2025-10-18 01:00:00', '2025-10-18 08:54:21'),
(17, 27, 3, 5.0, '登山好夥伴', '背負系統設計得很好，長時間背著也不會累。防水拉鍊很實用，多口袋設計方便分類。', '[\"https://example.com/images/review27_1.jpg\"]', 1, 38, 1, '2025-10-16 02:30:00', '2025-10-18 08:54:21'),
(18, 27, 2, 4.5, '品質不錯', '容量夠大，材質耐用。肩帶很舒適，但腰帶的扣環有點硬。', NULL, 1, 15, 1, '2025-10-17 03:00:00', '2025-10-18 08:54:21'),
(19, 36, 3, 5.0, '防曬效果超好', '去海邊玩一整天都沒有曬傷！質地清爽不黏膩，而且防水抗汗，游泳也不用擔心。', '[\"https://example.com/images/review36_1.jpg\"]', 1, 45, 1, '2025-10-17 05:30:00', '2025-10-18 08:54:21'),
(20, 36, 1, 4.5, '敏感肌適用', '無香料配方很溫和，敏感肌用了也不會過敏。唯一缺點是要多抹幾次才能完全推開。', NULL, 1, 21, 1, '2025-10-17 07:00:00', '2025-10-18 08:54:21'),
(21, 41, 3, 5.0, '超好穿！', '彈性很好，穿起來很舒服。防曬UPF50+真的有效，游完泳皮膚也沒曬傷。乾得很快！', '[\"https://example.com/images/review41_1.jpg\", \"https://example.com/images/review41_2.jpg\"]', 1, 29, 1, '2025-10-18 02:15:00', '2025-10-18 08:54:21'),
(22, 41, 2, 4.5, '質感不錯', '材質摸起來很舒服，抗氯防曬功能都很好。版型合身但不會太緊。', NULL, 1, 16, 1, '2025-10-18 03:30:00', '2025-10-18 08:54:21');

--
-- 觸發器 `pd_review`
--
DELIMITER $$
CREATE TRIGGER `after_pd_review_delete` AFTER DELETE ON `pd_review` FOR EACH ROW BEGIN
  UPDATE products 
  SET 
    avg_rating = (
      SELECT COALESCE(AVG(rating), 0) 
      FROM pd_review 
      WHERE product_id = OLD.product_id AND is_active = 1
    ),
    review_count = (
      SELECT COUNT(*) 
      FROM pd_review 
      WHERE product_id = OLD.product_id AND is_active = 1
    )
  WHERE product_id = OLD.product_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_pd_review_insert` AFTER INSERT ON `pd_review` FOR EACH ROW BEGIN
  IF NEW.is_active = 1 THEN
    UPDATE products 
    SET 
      avg_rating = (
        SELECT COALESCE(AVG(rating), 0) 
        FROM pd_review 
        WHERE product_id = NEW.product_id AND is_active = 1
      ),
      review_count = (
        SELECT COUNT(*) 
        FROM pd_review 
        WHERE product_id = NEW.product_id AND is_active = 1
      )
    WHERE product_id = NEW.product_id;
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `after_pd_review_update` AFTER UPDATE ON `pd_review` FOR EACH ROW BEGIN
  UPDATE products 
  SET 
    avg_rating = (
      SELECT COALESCE(AVG(rating), 0) 
      FROM pd_review 
      WHERE product_id = NEW.product_id AND is_active = 1
    ),
    review_count = (
      SELECT COUNT(*) 
      FROM pd_review 
      WHERE product_id = NEW.product_id AND is_active = 1
    )
  WHERE product_id = NEW.product_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `pd_review_helpful`
--

CREATE TABLE `pd_review_helpful` (
  `id` int NOT NULL,
  `review_id` int NOT NULL COMMENT '評論ID (關聯 pd_review.id)',
  `user_id` int NOT NULL COMMENT '點擊有用的使用者ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='評論有用性記錄 - 記錄哪些使用者認為評論有幫助';

--
-- 傾印資料表的資料 `pd_review_helpful`
--

INSERT INTO `pd_review_helpful` (`id`, `review_id`, `user_id`, `created_at`) VALUES
(1, 1, 1, '2025-10-16 02:30:00'),
(2, 4, 1, '2025-10-16 03:00:00'),
(3, 7, 1, '2025-10-16 03:15:00'),
(4, 9, 1, '2025-10-16 03:30:00'),
(5, 13, 1, '2025-10-17 01:00:00'),
(6, 16, 1, '2025-10-17 01:30:00'),
(7, 1, 2, '2025-10-16 04:00:00'),
(8, 2, 2, '2025-10-16 04:15:00'),
(9, 4, 2, '2025-10-16 05:00:00'),
(10, 5, 2, '2025-10-16 05:15:00'),
(11, 9, 2, '2025-10-16 06:00:00'),
(12, 10, 2, '2025-10-16 06:15:00'),
(13, 13, 2, '2025-10-17 02:00:00'),
(14, 14, 2, '2025-10-17 02:15:00'),
(15, 18, 2, '2025-10-17 06:00:00'),
(16, 2, 3, '2025-10-16 07:00:00'),
(17, 4, 3, '2025-10-16 07:30:00'),
(18, 6, 3, '2025-10-16 08:00:00'),
(19, 7, 3, '2025-10-16 08:30:00'),
(20, 8, 3, '2025-10-16 09:00:00'),
(21, 11, 3, '2025-10-17 00:00:00'),
(22, 12, 3, '2025-10-17 00:30:00'),
(23, 13, 3, '2025-10-17 03:00:00'),
(24, 15, 3, '2025-10-17 03:30:00'),
(25, 16, 3, '2025-10-17 04:00:00'),
(26, 19, 3, '2025-10-17 08:00:00');

-- --------------------------------------------------------

--
-- 資料表結構 `products`
--

CREATE TABLE `products` (
  `product_id` int NOT NULL,
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
  `is_active` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 傾印資料表的資料 `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `description`, `price`, `stock_quantity`, `category_id`, `avg_rating`, `review_count`, `favorite_count`, `created_at`, `updated_at`, `is_active`) VALUES
(1, '旅行牙刷牙膏組', '便攜式摺疊牙刷含牙膏，輕量防水設計，附收納盒，適合短期旅行使用', 180.00, 150, 1, 4.50, 3, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(2, '旅行裝洗髮精沐浴乳組', '50ml分裝瓶組合，TSA認證可登機，無矽靈配方溫和不刺激', 250.00, 120, 1, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(3, '多功能沐浴露', '三合一配方（洗髮/沐浴/洗臉），250ml大容量，天然植萃成分', 320.00, 100, 1, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(4, '快乾旅行毛巾', '超細纖維材質，吸水快乾，輕量僅80克，附收納袋', 280.00, 80, 1, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(5, '摺疊矽膠旅行杯', '350ml容量可摺疊，食品級矽膠，耐高溫可裝熱飲', 350.00, 90, 1, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(6, '20000mAh行動電源', '雙USB快充輸出，支援PD快充，LED電量顯示，可充手機4-5次', 890.00, 200, 2, 4.83, 3, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(7, '萬國轉接頭', '適用150+國家，內建USB充電孔，安全保護機制，輕巧便攜', 650.00, 180, 2, 4.75, 2, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(8, '藍牙5.0無線耳機', '降噪功能，IPX5防水，續航8小時，充電盒提供額外24小時', 1280.00, 100, 2, 4.83, 3, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(9, '旅行萬用延長線', '3插座+2USB孔，1.5米線長，過載保護，體積小方便攜帶', 480.00, 120, 2, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(10, '防水手機腰包', '觸控螢幕可操作，IPX8防水等級，可放6.5吋手機及護照現金', 380.00, 150, 2, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(11, '真空壓縮袋5件組', '節省50%行李空間，手捲式免抽氣機，耐用加厚材質', 420.00, 100, 3, 4.25, 2, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(12, '旅行收納袋6件組', '不同尺寸分類收納，防潑水尼龍布料，透氣網格設計', 580.00, 150, 3, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(13, '內衣收納包', '立體隔層保護胸型，可收納6-8套內衣褲，防水防塵', 320.00, 80, 3, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(14, '鞋子收納袋3入組', '防水防臭材質，透明視窗快速辨識，可收納運動鞋或皮鞋', 380.00, 90, 3, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(15, '掛式盥洗包', '大容量多夾層設計，可掛式節省空間，防水易清潔', 680.00, 70, 3, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(16, '記憶泡棉U型枕', '慢回彈記憶棉，人體工學設計，可調式鬆緊帶，附收納袋', 580.00, 120, 4, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(17, '3D遮光眼罩耳塞組', '完全遮光不壓迫眼球，柔軟透氣材質，附降噪耳塞', 280.00, 150, 4, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(18, 'TSA海關鎖行李束帶', 'TSA認證可過海關，螢光色易辨識，密碼鎖防盜', 320.00, 200, 4, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(19, '便攜摺疊衣架5入組', '可摺疊節省空間，防滑設計，承重3公斤，輕量塑鋼材質', 180.00, 100, 4, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(20, '旅行護照證件包', 'RFID防盜刷功能，多卡層設計，可放護照/機票/現金/卡片', 450.00, 130, 4, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(21, '2人輕量化帳篷', '僅重2.5kg，快速搭建，防水係數3000mm，雙門雙層通風', 3800.00, 50, 5, 4.83, 3, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(22, '羽絨睡袋800FP', '填充800蓬鬆度羽絨，適溫-5°C，壓縮後僅25cm，重量900g', 4200.00, 40, 5, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(23, '野餐防潮墊200x200', '鋁箔防潮層，折疊收納輕便，適合2-4人使用，防水耐磨', 680.00, 80, 5, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(24, '露營LED燈串', '3段亮度調節，USB充電續航12小時，防水IP65，5米長', 580.00, 90, 5, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(25, '摺疊露營桌椅組', '鋁合金材質輕量化，承重120kg，5秒快速展開收納', 2800.00, 60, 5, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(26, '碳纖維登山杖', '超輕量僅180g/支，3段伸縮110-130cm，減震設計保護膝蓋', 1680.00, 70, 6, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(27, '40L防水登山背包', '防撕裂尼龍材質，透氣背負系統，防水拉鍊，多口袋分層', 2800.00, 80, 6, 4.75, 2, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(28, '304不鏽鋼保溫瓶', '真空保溫24小時，750ml大容量，防漏設計，可單手開啟', 680.00, 150, 6, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(29, '速乾登山褲', '彈性透氣快乾布料，多口袋設計，防潑水處理，UPF50+防曬', 1280.00, 100, 6, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(30, '防滑登山鞋', 'Vibram黃金大底，Gore-Tex防水透氣，中筒保護腳踝', 3200.00, 60, 6, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(31, '輕量化鋁合金三腳架', '5節伸縮最高150cm，球型雲台360度旋轉，承重3kg，僅重800g', 1680.00, 70, 7, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(32, '相機防水袋', 'IPX8防水等級，透明TPU可觸控操作，適用單眼及微單相機', 880.00, 90, 7, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(33, '128GB高速記憶卡', 'V30錄影等級，讀取速度100MB/s，適合4K錄影', 980.00, 120, 7, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(34, '單眼相機背包', '防震內膽保護，上下層分離設計，可放15吋筆電，防潑水材質', 2200.00, 60, 7, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(35, '便攜LED補光燈', '可調色溫3200K-5600K，USB充電，磁吸底座可固定手機', 780.00, 100, 7, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(36, 'SPF50+防曬乳', '物理性防曬，防水抗汗，80ml容量，無香料敏感肌適用', 420.00, 200, 8, 4.75, 2, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(37, '旅行急救包', '包含OK繃/消毒水/紗布/藥膏等30項急救用品，輕巧便攜', 580.00, 100, 8, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(38, '天然防蚊液噴霧', '天然精油配方，不含DEET，100ml噴霧瓶，4-6小時防護', 280.00, 150, 8, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(39, '運動防曬袖套', 'UPF50+防曬係數，冰絲涼感材質，吸濕排汗彈性佳', 220.00, 180, 8, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(40, '便攜式濾水瓶', '4層過濾系統，可過濾99.9%細菌，650ml容量，適合戶外使用', 1280.00, 70, 8, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(41, '快乾運動泳衣', '彈性萊卡材質，抗氯防曬UPF50+，速乾透氣不悶熱', 880.00, 100, 9, 4.75, 2, 0, '2025-10-11 13:22:26', '2025-10-18 08:54:21', 1),
(42, '超細纖維運動毛巾', '吸水力是棉質3倍，40x80cm尺寸，附扣環可掛背包', 280.00, 150, 9, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(43, '摺疊瑜珈墊', '6mm厚度防滑，TPE環保材質，可摺疊方便攜帶，僅重1kg', 980.00, 80, 9, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(44, '運動腰包', '防水防汗材質，可放6.5吋手機，反光條夜跑安全，貼身不晃動', 380.00, 120, 9, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(45, '快速充氣游泳圈', '快速充氣閥30秒充飽，加厚PVC材質，適合成人使用', 420.00, 90, 9, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(46, '自動開收折疊傘', '一鍵自動開收，抗風骨架不易翻，直徑105cm大傘面', 580.00, 150, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(47, '輕便連帽雨衣', '僅重200g可收納成小包，防水係數10000mm，反光條設計', 380.00, 180, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(48, '防水手機袋', 'IPX8防水等級，可觸控操作，透明雙面可拍照，附掛繩', 180.00, 200, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(49, '防水背包套', '彈性束繩固定，反光Logo提升能見度，5種尺寸適用20-80L背包', 280.00, 120, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(50, '防水鞋套', '加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺', 320.00, 100, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1),
(51, '防水鞋套', '加厚耐磨底，防滑紋路，可重複使用，高筒設計防雨濺', 320.00, 100, 10, 0.00, 0, 0, '2025-10-11 13:22:26', '2025-10-11 13:22:26', 1);

-- --------------------------------------------------------

--
-- 資料表結構 `product_categories`
--

CREATE TABLE `product_categories` (
  `category_id` int NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 傾印資料表的資料 `product_categories`
--

INSERT INTO `product_categories` (`category_id`, `category_name`, `parent_name`, `description`, `created_at`, `updated_at`) VALUES
(1, '盥洗用品', '日常用品', '旅行專用盥洗清潔用品，輕便好攜帶', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(2, '電子產品', '3C設備', '旅行必備電子配件與充電設備', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(3, '衣物收納', '收納整理', '高效率衣物收納與壓縮工具', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(4, '旅行配件', '舒適配件', '提升旅途舒適度的實用配件', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(5, '戶外露營', '戶外裝備', '露營野營專業裝備與用品', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(6, '登山健行', '運動裝備', '登山健行專用裝備與配件', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(7, '攝影器材', '攝影配件', '旅行攝影必備器材與配件', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(8, '防護用品', '安全防護', '防曬防蚊與緊急醫療用品', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(9, '運動用品', '運動裝備', '旅行運動與水上活動用品', '2025-10-11 13:22:26', '2025-10-11 13:22:26'),
(10, '雨具防水', '防護用品', '防雨防水保護裝備', '2025-10-11 13:22:26', '2025-10-11 13:22:26');

-- --------------------------------------------------------

--
-- 資料表結構 `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int NOT NULL,
  `product_id` int NOT NULL,
  `image_url` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 傾印資料表的資料 `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `image_url`) VALUES
(1, 1, '/uploads/products/11_dentalKit.png'),
(2, 2, '/uploads/products/12_toiletries.png'),
(3, 3, '/uploads/products/12_toiletries.png'),
(4, 4, '/uploads/products/15_towels.png'),
(5, 5, '/uploads/products/25_bottle.png'),
(6, 6, '/uploads/products/19_powerbank.png'),
(7, 7, '/uploads/products/18_chargerSet.png'),
(8, 8, '/uploads/products/20_earbuds.png'),
(9, 9, '/uploads/products/18_chargerSet.png'),
(10, 10, '/uploads/products/22_fannyPack.png'),
(11, 11, '/uploads/products/24_organizers.png'),
(12, 12, '/uploads/products/24_organizers.png'),
(13, 13, '/uploads/products/01_underwear.png'),
(14, 14, '/uploads/products/03_sandals.png'),
(15, 15, '/uploads/products/12_toiletries.png'),
(16, 16, '/uploads/products/26_neckPillow.png'),
(17, 17, '/uploads/products/27_sleepMask.png'),
(18, 18, '/uploads/products/23_luggage.png'),
(19, 19, '/uploads/products/24_organizers.png'),
(20, 20, '/uploads/products/22_fannyPack.png'),
(21, 21, '/uploads/products/21_backpack.png'),
(22, 22, '/uploads/products/21_backpack.png'),
(23, 23, '/uploads/products/24_organizers.png'),
(24, 24, '/uploads/products/18_chargerSet.png'),
(25, 25, '/uploads/products/24_organizers.png'),
(26, 26, '/uploads/products/24_organizers.png'),
(27, 27, '/uploads/products/21_backpack.png'),
(28, 28, '/uploads/products/25_bottle.png'),
(29, 29, '/uploads/products/24_organizers.png'),
(30, 30, '/uploads/products/03_sandals.png'),
(31, 31, '/uploads/products/24_organizers.png'),
(32, 32, '/uploads/products/22_fannyPack.png'),
(33, 33, '/uploads/products/18_chargerSet.png'),
(34, 34, '/uploads/products/21_backpack.png'),
(35, 35, '/uploads/products/18_chargerSet.png'),
(36, 36, '/uploads/products/14_skincareKit.png'),
(37, 37, '/uploads/products/17_medicalKit.png'),
(38, 38, '/uploads/products/14_skincareKit.png'),
(39, 39, '/uploads/products/16_hairstylingKit.png'),
(40, 40, '/uploads/products/25_bottle.png'),
(41, 41, '/uploads/products/01_underwear.png'),
(42, 42, '/uploads/products/15_towels.png'),
(43, 43, '/uploads/products/24_organizers.png'),
(44, 44, '/uploads/products/22_fannyPack.png'),
(45, 45, '/uploads/products/24_organizers.png'),
(46, 46, '/uploads/products/09_umbrella.png'),
(47, 47, '/uploads/products/10_raincoat.png'),
(48, 48, '/uploads/products/22_fannyPack.png'),
(49, 49, '/uploads/products/21_backpack.png'),
(50, 50, '/uploads/products/04_slippers.png'),
(51, 51, '/uploads/products/04_slippers.png');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `pd_favorite`
--
ALTER TABLE `pd_favorite`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_product` (`user_id`,`product_id`) COMMENT '防止重複收藏',
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- 資料表索引 `pd_review`
--
ALTER TABLE `pd_review`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_product_id` (`product_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_rating` (`rating`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- 資料表索引 `pd_review_helpful`
--
ALTER TABLE `pd_review_helpful`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_review_user` (`review_id`,`user_id`) COMMENT '防止重複點擊',
  ADD KEY `idx_review_id` (`review_id`),
  ADD KEY `idx_user_id` (`user_id`);

--
-- 資料表索引 `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_price` (`price`),
  ADD KEY `idx_avg_rating` (`avg_rating`);

--
-- 資料表索引 `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`category_id`);

--
-- 資料表索引 `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `product_id` (`product_id`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pd_favorite`
--
ALTER TABLE `pd_favorite`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pd_review`
--
ALTER TABLE `pd_review`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `pd_review_helpful`
--
ALTER TABLE `pd_review_helpful`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- 已傾印資料表的限制式
--

--
-- 資料表的限制式 `pd_favorite`
--
ALTER TABLE `pd_favorite`
  ADD CONSTRAINT `fk_pd_favorite_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pd_favorite_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `pd_review`
--
ALTER TABLE `pd_review`
  ADD CONSTRAINT `fk_pd_review_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pd_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `pd_review_helpful`
--
ALTER TABLE `pd_review_helpful`
  ADD CONSTRAINT `fk_pd_helpful_review` FOREIGN KEY (`review_id`) REFERENCES `pd_review` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_pd_helpful_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- 資料表的限制式 `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`category_id`);

--
-- 資料表的限制式 `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `fk_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;