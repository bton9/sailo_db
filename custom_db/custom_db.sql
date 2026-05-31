-- ========================================
-- 清空舊表（如果存在）
-- ========================================
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS trip_items;

DROP TABLE IF EXISTS trip_favorites;

DROP TABLE IF EXISTS trip_days;

DROP TABLE IF EXISTS trips;

DROP TABLE IF EXISTS media;

DROP TABLE IF EXISTS favorite_list_places;

DROP TABLE IF EXISTS favorite_lists;

DROP TABLE IF EXISTS places;

DROP TABLE IF EXISTS locations;

SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- 建立 locations 表（地區表）
-- ========================================
CREATE TABLE IF NOT EXISTS locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '地區編號',
    name VARCHAR(100) NOT NULL COMMENT '地區名稱'
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 places 表（景點表）
-- ========================================
CREATE TABLE IF NOT EXISTS places (
    place_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '景點編號',
    name VARCHAR(100) NOT NULL COMMENT '景點名稱',
    category ENUM('景點', '餐廳', '住宿', '交通') NOT NULL COMMENT '類別',
    location_id INT DEFAULT NULL COMMENT '所屬地區編號',
    description TEXT COMMENT '景點描述',
    rating FLOAT DEFAULT NULL COMMENT '平均評分',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    latitude DECIMAL(10, 6) DEFAULT NULL COMMENT '緯度',
    longitude DECIMAL(10, 6) DEFAULT NULL COMMENT '經度',
    google_place_id VARCHAR(100) DEFAULT NULL COMMENT 'Google 地點 ID',
    INDEX idx_location_id (location_id),
    INDEX idx_category (category),
    INDEX idx_rating (rating),
    CONSTRAINT fk_places_locations FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 trips 表（行程表）
-- ========================================
CREATE TABLE IF NOT EXISTS trips (
    trip_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '行程編號',
    trip_name VARCHAR(100) NOT NULL COMMENT '行程名稱',
    user_id INT DEFAULT NULL COMMENT '建立者編號',
    description TEXT COMMENT '行程描述',
    start_date DATE DEFAULT NULL COMMENT '開始日期',
    end_date DATE DEFAULT NULL COMMENT '結束日期',
    cover_image_url VARCHAR(255) DEFAULT NULL COMMENT '封面圖片 URL',
    is_public TINYINT(1) DEFAULT 0 COMMENT '是否公開行程',
    location_id INT DEFAULT NULL COMMENT '主要旅遊地區',
    summary_text VARCHAR(200) DEFAULT NULL COMMENT '行程摘要',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    INDEX idx_user_id (user_id),
    INDEX idx_location_id (location_id),
    INDEX idx_is_public (is_public),
    INDEX idx_start_date (start_date),
    CONSTRAINT fk_trips_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_trips_locations FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 trip_days 表（行程天數表）
-- ========================================
CREATE TABLE IF NOT EXISTS trip_days (
    trip_day_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '行程天數編號',
    trip_id INT DEFAULT NULL COMMENT '所屬行程編號',
    date DATE DEFAULT NULL COMMENT '日期',
    day_number INT DEFAULT NULL COMMENT '第幾天',
    INDEX idx_trip_id (trip_id),
    INDEX idx_date (date),
    CONSTRAINT fk_trip_days_trips FOREIGN KEY (trip_id) REFERENCES trips (trip_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 trip_items 表（行程項目表）
-- ========================================
CREATE TABLE IF NOT EXISTS trip_items (
    trip_item_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '行程項目編號',
    trip_day_id INT DEFAULT NULL COMMENT '所屬行程天編號',
    place_id INT DEFAULT NULL COMMENT '景點編號',
    type ENUM('景點', '餐廳', '住宿', '交通') DEFAULT NULL COMMENT '項目類型',
    note TEXT COMMENT '備註',
    start_time TIME DEFAULT NULL COMMENT '開始時間',
    end_time TIME DEFAULT NULL COMMENT '結束時間',
    sort_order INT DEFAULT NULL COMMENT '排序序號',
    INDEX idx_trip_day_id (trip_day_id),
    INDEX idx_place_id (place_id),
    INDEX idx_sort_order (sort_order),
    CONSTRAINT fk_trip_items_trip_days FOREIGN KEY (trip_day_id) REFERENCES trip_days (trip_day_id) ON DELETE CASCADE,
    CONSTRAINT fk_trip_items_places FOREIGN KEY (place_id) REFERENCES places (place_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 trip_favorites 表（行程收藏表）
-- ========================================
CREATE TABLE IF NOT EXISTS trip_favorites (
    favorite_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '收藏編號',
    user_id INT DEFAULT NULL COMMENT '使用者編號',
    trip_id INT DEFAULT NULL COMMENT '行程編號',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UNIQUE KEY unique_user_trip (user_id, trip_id),
    INDEX idx_user_id (user_id),
    INDEX idx_trip_id (trip_id),
    CONSTRAINT fk_trip_favorites_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_trip_favorites_trips FOREIGN KEY (trip_id) REFERENCES trips (trip_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 media 表（媒體檔案表）
-- ========================================
CREATE TABLE IF NOT EXISTS media (
    media_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '媒體編號',
    user_id INT DEFAULT NULL COMMENT '使用者編號',
    trip_id INT DEFAULT NULL COMMENT '行程編號',
    place_id INT DEFAULT NULL COMMENT '景點編號',
    place_category ENUM('景點', '餐廳', '住宿', '交通') DEFAULT NULL COMMENT '景點類型',
    url VARCHAR(255) DEFAULT NULL COMMENT '檔案 URL',
    is_cover TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否封面',
    description TEXT COMMENT '描述',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    INDEX idx_user_id (user_id),
    INDEX idx_trip_id (trip_id),
    INDEX idx_place_id (place_id),
    CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_media_trips FOREIGN KEY (trip_id) REFERENCES trips (trip_id) ON DELETE CASCADE,
    CONSTRAINT fk_media_places FOREIGN KEY (place_id) REFERENCES places (place_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 favorite_lists 表（收藏清單表）
-- ========================================
CREATE TABLE IF NOT EXISTS favorite_lists (
    list_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '清單編號',
    user_id INT DEFAULT NULL COMMENT '使用者編號',
    name VARCHAR(50) DEFAULT NULL COMMENT '清單名稱',
    description VARCHAR(255) DEFAULT NULL COMMENT '清單描述',
    location_id INT DEFAULT NULL COMMENT '收藏清單主要地區',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    INDEX idx_user_id (user_id),
    INDEX idx_location_id (location_id),
    CONSTRAINT fk_favorite_lists_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_favorite_lists_locations FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- ========================================
-- 建立 favorite_list_places 表（收藏清單景點關聯表）
-- ========================================
CREATE TABLE IF NOT EXISTS favorite_list_places (
    list_places_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '清單景點關聯編號',
    list_id INT DEFAULT NULL COMMENT '收藏清單編號',
    place_id INT DEFAULT NULL COMMENT '景點編號',
    UNIQUE KEY unique_list_place (list_id, place_id),
    INDEX idx_list_id (list_id),
    INDEX idx_place_id (place_id),
    CONSTRAINT fk_favorite_list_places_lists FOREIGN KEY (list_id) REFERENCES favorite_lists (list_id) ON DELETE CASCADE,
    CONSTRAINT fk_favorite_list_places_places FOREIGN KEY (place_id) REFERENCES places (place_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =================假資料=======================
-- ========================================
-- 假資料 - locations 和 places
-- ========================================

-- locations 資料
INSERT INTO
    locations (location_id, name)
VALUES (1, '台北市'),
    (2, '高雄市'),
    (3, '台中市'),
    (4, '花蓮縣'),
    (5, '台南市');

-- places 資料
INSERT INTO
    places (
        place_id,
        name,
        category,
        location_id,
        description,
        rating,
        latitude,
        longitude,
        google_place_id,
        created_at
    )
VALUES (
        1,
        '台北101',
        '景點',
        1,
        '台北著名地標,高樓觀景台能欣賞整個城市的美麗景色,是旅客必訪的景點之一,適合拍照與觀光。',
        4.8,
        25.033968,
        121.564468,
        'PabA9CvaPBxZELTD8',
        '2025-10-14 11:53:24'
    ),
    (
        2,
        '六合夜市',
        '餐廳',
        2,
        '高雄著名夜市,匯集各式在地小吃與特色美食,夜晚熱鬧非凡,是遊客與當地人都喜愛的美食勝地。',
        4.5,
        22.631600,
        120.301900,
        'Vob5ucrbKJuAKDA76',
        '2025-10-14 11:53:24'
    ),
    (
        3,
        '赤崁樓',
        '景點',
        5,
        '台南古蹟,融合中西建築風格與悠久歷史文化,提供遊客深入了解台南歷史文化的最佳去處,也是拍照打卡的熱門景點。',
        4.7,
        22.997883,
        120.202617,
        'fp1rY3eDhgxFZ9i46',
        '2025-10-14 11:53:24'
    ),
    (
        4,
        '國立故宮博物院',
        '景點',
        1,
        '收藏中華文物瑰寶,融合藝術與歷史教育功能,展出各朝代珍貴文物,是文化愛好者與旅客必訪的博物館。',
        4.7,
        25.102398,
        121.548492,
        'a4wNBURnt5npGKNU8',
        '2025-10-14 12:10:12'
    ),
    (
        5,
        '士林夜市',
        '餐廳',
        1,
        '台北最熱鬧的夜市之一,提供各式傳統小吃與特色美食,是遊客品嚐地道台灣美食的絕佳去處,夜晚熱鬧非凡。',
        4.5,
        25.087200,
        121.525000,
        '7nGg5fwVjQ6qdxCe6',
        '2025-10-14 12:12:45'
    ),
    (
        6,
        '西門町商圈',
        '景點',
        1,
        '年輕人潮聚集地,結合購物、美食與娛樂活動,是體驗台北潮流文化與城市生活的熱門景點,也是拍照打卡的好去處。',
        4.6,
        25.042233,
        121.508328,
        '9rz4fbR1S9EiHsPR7',
        '2025-10-14 12:14:52'
    ),
    (
        7,
        '象山步道',
        '景點',
        1,
        '俯瞰台北夜景的最佳地點之一,步道景觀優美,適合健行與拍攝台北市景,吸引許多遊客與攝影愛好者,是休閒散步的好去處。',
        4.9,
        25.027222,
        121.570611,
        'McJToUznk6i1M26C8',
        '2025-10-14 12:16:33'
    ),
    (
        8,
        '饒河街夜市',
        '餐廳',
        1,
        '結合傳統與現代特色的小吃夜市,提供多樣美食選擇,是遊客體驗台北夜市文化與街頭美食的絕佳地點,熱鬧又充滿特色。',
        4.4,
        25.050556,
        121.578333,
        'ykxiU5ByBWBXFbDEA',
        '2025-10-14 12:18:45'
    ),
    (
        9,
        '松山文創園區',
        '景點',
        1,
        '文創展覽與咖啡館結合的文化據點,提供藝術展覽、手作活動與休閒空間,適合喜愛文創與拍照的旅客,也是親子與朋友聚會的好去處。',
        4.6,
        25.044222,
        121.560222,
        'YoyvbHZz76roa7jZ8',
        '2025-10-14 12:20:18'
    ),
    (
        10,
        '北投溫泉區',
        '景點',
        1,
        '溫泉旅館林立,環境清幽,結合自然山景,是休閒泡湯與親近自然的最佳選擇,適合全家或情侶旅遊。',
        4.7,
        25.137500,
        121.506500,
        'Utjw52WjKN92sHzY6',
        '2025-10-14 12:22:09'
    ),
    (
        11,
        '美麗華百樂園',
        '景點',
        1,
        '摩天輪與購物娛樂合一的休閒中心,適合家庭或朋友聚會,提供購物、美食與娛樂的多重體驗,是台北熱門休閒景點。',
        4.5,
        25.082000,
        121.548600,
        'DEhvJzDYMBmqtuJbA',
        '2025-10-14 12:23:47'
    ),
    (
        12,
        '台北萬豪酒店',
        '住宿',
        1,
        '五星級住宿,交通便利且景觀極佳,提供舒適客房與完善設施,是旅客在台北享受高品質住宿的最佳選擇。',
        4.8,
        25.083611,
        121.548333,
        'oMqPZZ2vzwZvdYKm6',
        '2025-10-14 12:25:12'
    ),
    (
        13,
        '台中國家歌劇院',
        '景點',
        3,
        '建築藝術結合音樂表演的文化地標,提供精彩演出與參觀體驗,是台中文化愛好者必訪的藝術中心。',
        4.6,
        24.167222,
        120.639611,
        NULL,
        '2025-10-14 12:27:32'
    ),
    (
        14,
        '逢甲夜市',
        '餐廳',
        3,
        '台中最具代表性的夜市,創意美食雲集,從傳統小吃到特色餐飲皆可品嚐,是旅客探索台中美食文化的好去處。',
        4.7,
        24.178889,
        120.646944,
        NULL,
        '2025-10-14 12:29:10'
    ),
    (
        15,
        '高美濕地',
        '景點',
        3,
        '夕陽美景與自然生態觀察的熱門景點,適合攝影、散步及親近大自然,是台中戶外活動與生態旅遊的理想地點。',
        4.9,
        24.312611,
        120.561000,
        NULL,
        '2025-10-14 12:31:50'
    ),
    (
        16,
        '審計新村',
        '景點',
        3,
        '文創商店與咖啡廳聚集的文青聖地,提供藝術展覽、手作體驗及休閒空間,是文青及創意愛好者的最佳打卡地點。',
        4.6,
        24.144611,
        120.663611,
        NULL,
        '2025-10-14 12:33:25'
    ),
    (
        17,
        '宮原眼科',
        '餐廳',
        3,
        '復古建築冰淇淋名店,提供特色甜品與手工冰淇淋,是台中旅客品嚐經典甜點與拍照打卡的熱門地點。',
        4.8,
        24.136778,
        120.683500,
        NULL,
        '2025-10-14 12:35:10'
    ),
    (
        18,
        '一中街商圈',
        '景點',
        3,
        '學生最愛的購物與美食街區,匯集潮流服飾、特色小吃與娛樂場所,是台中青年文化的重要聚集地。',
        4.5,
        24.147500,
        120.686333,
        NULL,
        '2025-10-14 12:36:58'
    ),
    (
        19,
        '勤美誠品綠園道',
        '景點',
        3,
        '融合自然與設計的城市綠地,提供休閒散步、藝術展覽與戶外活動,是台中市民與遊客放鬆休憩的理想去處。',
        4.7,
        24.144611,
        120.662778,
        NULL,
        '2025-10-14 12:38:41'
    ),
    (
        20,
        '台中港三井Outlet',
        '景點',
        3,
        '大型海港購物中心,適合全家出遊,結合購物、美食與休閒娛樂設施,是台中港熱門觀光與消費地點。',
        4.6,
        24.256944,
        120.541111,
        NULL,
        '2025-10-14 12:40:29'
    ),
    (
        21,
        '日月千禧酒店',
        '住宿',
        3,
        '五星級飯店,位於台中市中心,提供豪華客房、完善設施與高品質服務,是旅客在台中享受舒適住宿的最佳選擇。',
        4.8,
        24.163611,
        120.638611,
        NULL,
        '2025-10-14 12:42:03'
    ),
    (
        22,
        '春水堂創始店',
        '餐廳',
        4,
        '珍珠奶茶發源地,提供正宗茶飲及創意飲品,是體驗台灣經典飲品文化與觀光美食的絕佳地點。',
        4.6,
        24.136389,
        120.683611,
        NULL,
        '2025-10-14 12:43:47'
    ),
    (
        23,
        '太魯閣國家公園',
        '景點',
        4,
        '峽谷與山景壯麗,提供登山、健行與戶外探險活動,是戶外愛好者與自然景觀攝影愛好者的理想選擇。',
        4.9,
        24.181389,
        121.493611,
        NULL,
        '2025-10-14 12:45:12'
    ),
    (
        24,
        '七星潭海岸',
        '景點',
        3,
        '礫石海灘與湛藍海水,是花蓮代表景點,適合散步、拍照及欣賞海景,提供休閒與自然探索的完美環境。',
        4.8,
        24.032222,
        121.627500,
        NULL,
        '2025-10-14 12:47:21'
    ),
    (
        25,
        '東大門夜市',
        '餐廳',
        4,
        '花蓮最大夜市,匯集各地小吃與特色美食,是遊客品嚐當地美食文化、體驗夜市熱鬧氛圍的首選地點。',
        4.5,
        23.973585,
        121.606384,
        NULL,
        '2025-10-14 12:48:59'
    ),
    (
        26,
        '花蓮文創園區',
        '景點',
        4,
        '藝術展覽與文創商店共存的文化空間,提供展覽、手作體驗與休閒空間,是花蓮文創與藝術愛好者的好去處。',
        4.6,
        23.976111,
        121.605000,
        NULL,
        '2025-10-14 12:50:32'
    ),
    (
        27,
        '鯉魚潭風景區',
        '景點',
        4,
        '湖光山色與環湖步道,適合騎腳踏車及散步,提供自然景觀與休閒活動,是親子與戶外愛好者的理想景點。',
        4.7,
        23.931111,
        121.561944,
        NULL,
        '2025-10-14 12:52:07'
    ),
    (
        28,
        '花蓮遠雄悅來大飯店',
        '住宿',
        4,
        '臨海景觀飯店,設施完善,提供舒適客房與休閒服務,是花蓮旅客享受度假與海景住宿的絕佳選擇。',
        4.7,
        23.921944,
        121.605278,
        NULL,
        '2025-10-14 12:53:54'
    ),
    (
        29,
        '瑞穗牧場',
        '景點',
        4,
        '自然草原與鮮奶製品,提供親子互動、動物體驗與戶外活動,是家庭旅遊與自然教育的理想景點。',
        4.5,
        23.517222,
        121.373611,
        NULL,
        '2025-10-14 12:55:39'
    ),
    (
        30,
        '花蓮文化創意夜市',
        '餐廳',
        4,
        '結合在地手作與美食的夜市體驗,提供各式小吃與特色商品,是花蓮旅客探索地方文化與美食的好去處。',
        4.4,
        23.973611,
        121.605000,
        NULL,
        '2025-10-14 12:57:10'
    ),
    (
        31,
        '遠雄海洋公園',
        '景點',
        4,
        '結合海洋生物與遊樂設施的大型主題園區,適合親子、朋友及團體遊玩,是花蓮熱門休閒娛樂與教育體驗景點。',
        4.6,
        23.894722,
        121.604444,
        NULL,
        '2025-10-14 12:58:48'
    ),
    (
        32,
        '花蓮福容大飯店',
        '住宿',
        4,
        '臨近港口的高評價飯店,提供舒適客房與完善設施,是家庭與團體旅客在花蓮享受便利住宿的理想選擇。',
        4.8,
        23.851944,
        121.603611,
        NULL,
        '2025-10-14 13:00:26'
    ),
    (
        33,
        '蓮池潭風景區',
        '景點',
        4,
        '湖光山色與龍虎塔,是高雄著名的旅遊景點,提供散步、休閒及觀光拍照的好去處,適合全家或朋友同遊。',
        4.6,
        22.686111,
        120.305556,
        NULL,
        '2025-10-14 13:02:05'
    ),
    (
        34,
        '駁二藝術特區',
        '景點',
        2,
        '文創、展覽與咖啡結合的藝術聚落,提供文化活動、展覽與拍照打卡空間,是高雄文創與藝術愛好者必訪的地點。',
        4.7,
        22.616944,
        120.279167,
        NULL,
        '2025-10-14 13:03:32'
    ),
    (
        35,
        '六合夜市',
        '餐廳',
        2,
        '高雄最具代表性的夜市,提供各式特色美食與小吃,是遊客體驗高雄在地夜市文化與美食的絕佳地點。',
        4.5,
        22.631600,
        120.301900,
        NULL,
        '2025-10-14 13:05:09'
    ),
    (
        36,
        '愛河風景區',
        '景點',
        2,
        '浪漫夜景與河畔咖啡最受情侶喜愛,提供散步、休閒及拍照景點,是高雄情侶約會與觀光的理想地點。',
        4.8,
        22.626944,
        120.287222,
        NULL,
        '2025-10-14 13:06:52'
    ),
    (
        37,
        '壽山動物園',
        '景點',
        2,
        '親子旅遊好去處,園區重建後環境舒適,提供動物觀賞、教育活動與戶外休閒,是家庭旅遊的熱門選擇。',
        4.6,
        22.648611,
        120.278333,
        NULL,
        '2025-10-14 13:08:31'
    ),
    (
        38,
        '美麗島捷運站',
        '景點',
        2,
        '彩色玻璃穹頂藝術設計吸睛,是捷運站內的藝術景點,提供觀光拍照與休閒活動,是高雄旅客必訪地標。',
        4.7,
        22.631111,
        120.301111,
        NULL,
        '2025-10-14 13:10:08'
    ),
    (
        39,
        '高雄中央公園',
        '景點',
        2,
        '市中心綠地,適合放鬆散步與休閒活動,提供自然環境與社區互動,是高雄市民與旅客放鬆身心的好去處。',
        4.5,
        22.630000,
        120.302222,
        NULL,
        '2025-10-14 13:11:54'
    ),
    (
        40,
        '義享天地',
        '景點',
        2,
        '新興百貨商場,集購物與娛樂於一體,提供餐飲、購物及休閒娛樂,是高雄年輕族群與觀光客的熱門景點。',
        4.6,
        22.625000,
        120.300000,
        NULL,
        '2025-10-14 13:13:33'
    ),
    (
        41,
        '漢來大飯店',
        '住宿',
        2,
        '五星級飯店,景觀與餐飲品質出眾,提供豪華住宿與完善服務,是高雄旅客享受高品質住宿的首選。',
        4.8,
        22.623611,
        120.296944,
        NULL,
        '2025-10-14 13:15:17'
    ),
    (
        42,
        '鹽埕老街',
        '餐廳',
        2,
        '高雄在地老字號美食聚集地,提供傳統小吃與特色餐飲,是遊客體驗高雄美食文化與地方特色的必訪地點。',
        4.4,
        22.622222,
        120.295000,
        NULL,
        '2025-10-14 13:16:49'
    ),
    (
        43,
        '安平古堡',
        '景點',
        5,
        '台南歷史悠久的古蹟,見證荷蘭時期文化,提供歷史導覽與拍照景點,是了解台南文化與歷史的重要地標。',
        4.6,
        22.995833,
        120.161111,
        NULL,
        '2025-10-14 13:18:21'
    ),
    (
        44,
        '赤崁樓',
        '景點',
        5,
        '融合中西建築風格的歷史文化地標,提供歷史教育與觀光參觀,是台南旅客深入了解古蹟文化的理想景點。',
        4.5,
        22.997883,
        120.202617,
        NULL,
        '2025-10-14 13:19:56'
    ),
    (
        45,
        '花園夜市',
        '餐廳',
        5,
        '台南最大夜市,傳統與創意小吃雲集,提供美食體驗與夜市文化探索,是遊客必訪的台南美食景點。',
        4.7,
        23.000000,
        120.200000,
        NULL,
        '2025-10-14 13:21:33'
    ),
    (
        46,
        '台南孔廟',
        '景點',
        5,
        '文化與教育象徵,環境清幽,提供歷史導覽與參觀空間,是台南旅客了解古蹟文化與教育歷史的重要地標。',
        4.8,
        22.993611,
        120.204167,
        NULL,
        '2025-10-14 13:23:09'
    ),
    (
        47,
        '安平樹屋',
        '景點',
        5,
        '樹木與老宅融合的奇特景觀,提供拍照打卡與歷史文化體驗,是遊客探索台南創意景觀與文化的理想去處。',
        4.6,
        22.995000,
        120.165000,
        NULL,
        '2025-10-14 13:24:41'
    ),
    (
        48,
        '藍晒圖文創園區',
        '景點',
        5,
        '結合藝術與拍照景點的文青聖地,提供文創展覽與休閒空間,是喜愛藝術與創意文化旅客必訪的景點。',
        4.5,
        22.994444,
        120.196944,
        NULL,
        '2025-10-14 13:26:14'
    ),
    (
        49,
        '鵪鶉鹹粥',
        '餐廳',
        5,
        '在地傳統早餐店,以魚粥聞名,提供早晨美食體驗與文化風味,是台南旅客品嚐地道早餐的好去處。',
        4.7,
        22.991111,
        120.197222,
        NULL,
        '2025-10-14 13:27:50'
    ),
    (
        50,
        '晶英酒店',
        '住宿',
        5,
        '五星級飯店,位於市中心,設施完善,提供豪華住宿與優質服務,是台南旅客享受舒適住宿的首選地點。',
        4.9,
        22.991944,
        120.196111,
        NULL,
        '2025-10-14 13:29:27'
    ),
    (
        51,
        '正興街商圈',
        '景點',
        5,
        '老屋新生的文創聚落,提供甜點咖啡與藝術展覽,是台南旅客體驗文創文化與拍照打卡的熱門景點。',
        4.6,
        22.992222,
        120.195000,
        NULL,
        '2025-10-14 13:31:02'
    ),
    (
        52,
        '台南美術館',
        '景點',
        5,
        '現代藝術展館,建築設計極具特色,提供藝術展覽與文化教育,是台南旅客與藝術愛好者必訪的地標。',
        4.8,
        22.991389,
        120.195833,
        NULL,
        '2025-10-14 13:32:47'
    ),
    (
        53,
        '金瓜石',
        '景點',
        1,
        '建於 1898 年的神社遺址,可經由石階前往欣賞舊淘金鎮金瓜石的景緻。',
        4.8,
        25.033968,
        121.564468,
        NULL,
        '2025-10-14 11:53:24'
    ),
    (
        54,
        '陽明山國家公園',
        '景點',
        1,
        '溫泉與花季並存的自然景點,提供登山健行、泡湯與賞花體驗,是台北旅客親近自然與休閒的絕佳選擇。',
        4.8,
        25.179167,
        121.529167,
        NULL,
        '2025-10-14 13:36:49'
    ),
    (
        55,
        '金峰魯肉飯',
        '餐廳',
        1,
        '台北知名傳統滷肉飯老店,提供經典台灣小吃與美食文化體驗,是旅客品嚐地道美食的熱門去處。',
        4.6,
        25.032222,
        121.521111,
        NULL,
        '2025-10-14 13:38:21'
    ),
    (
        56,
        '圓山大飯店',
        '住宿',
        1,
        '中式宮殿風格建築,台北代表性飯店,提供豪華住宿與高品質服務,是旅客體驗台北文化與舒適住宿的首選。',
        4.8,
        25.072222,
        121.525000,
        NULL,
        '2025-10-14 13:39:58'
    ),
    (
        57,
        '彩虹眷村',
        '景點',
        2,
        '彩繪藝術村落,充滿童趣與創意,提供拍照打卡與藝術文化體驗,是遊客探索台中創意文化與文青景點的理想地點。',
        4.7,
        24.133611,
        120.681944,
        NULL,
        '2025-10-14 13:41:26'
    ),
    (
        58,
        '宮原眼科冰淇淋店',
        '餐廳',
        2,
        '以復古風格著名的甜品名店,提供手工冰淇淋與甜點體驗,是台中旅客品嚐經典甜品與拍照打卡的熱門景點。',
        4.6,
        24.136389,
        120.683611,
        NULL,
        '2025-10-14 13:42:59'
    ),
    (
        59,
        '谷關溫泉區',
        '景點',
        2,
        '山林間的溫泉度假勝地,提供住宿、泡湯與戶外休閒體驗,是台中旅客親近自然與享受溫泉的理想選擇。',
        4.5,
        24.237222,
        120.837222,
        NULL,
        '2025-10-14 13:44:31'
    ),
    (
        60,
        '林酒店',
        '住宿',
        2,
        '高評價商務與休閒並重的五星飯店,提供豪華住宿與完善設施,是台中旅客享受舒適住宿與服務的最佳選擇。',
        4.9,
        24.162222,
        120.639167,
        NULL,
        '2025-10-14 13:46:10'
    ),
    (
        61,
        '石梯坪風景區',
        '景點',
        3,
        '獨特海蝕地形與海岸風光,適合觀光、拍照與戶外活動,是花蓮旅客探索自然景觀與海岸美景的好去處。',
        4.7,
        23.496944,
        121.519167,
        NULL,
        '2025-10-14 13:47:47'
    ),
    (
        62,
        '花蓮炸蛋蔥油餅',
        '餐廳',
        3,
        '排隊名店,外酥內軟的經典小吃,提供花蓮在地美食體驗與觀光文化,是旅客品嚐地道小吃的熱門選擇。',
        4.5,
        23.978611,
        121.605000,
        NULL,
        '2025-10-14 13:49:25'
    ),
    (
        63,
        '立川漁場',
        '景點',
        3,
        '可體驗摸蜆與品嚐海鮮料理的休閒農場,提供親子活動與戶外娛樂,是花蓮旅客享受自然與美食的好去處。',
        4.6,
        23.899167,
        121.536111,
        NULL,
        '2025-10-14 13:51:03'
    ),
    (
        64,
        '秧悅美地渡假酒店',
        '住宿',
        3,
        '融合自然與舒適的高級度假住宿,提供豪華設施與戶外活動,是花蓮旅客享受放鬆與度假的理想選擇。',
        4.8,
        23.899722,
        121.538611,
        NULL,
        '2025-10-14 13:52:44'
    ),
    (
        65,
        '旗津風車公園',
        '景點',
        4,
        '臨海風車與夕陽景色吸引眾多遊客,提供拍照打卡與休閒散步,是高雄旅客體驗自然景觀與戶外活動的熱門景點。',
        4.7,
        22.578611,
        120.295833,
        NULL,
        '2025-10-14 13:54:21'
    ),
    (
        66,
        '鹽埕婆婆冰',
        '餐廳',
        4,
        '高雄老字號冰品店,夏季人氣旺,提供傳統冰品與甜點,是旅客品嚐地道消暑美食的理想去處。',
        4.5,
        22.623611,
        120.296944,
        NULL,
        '2025-10-14 13:55:59'
    ),
    (
        67,
        '夢時代購物中心',
        '景點',
        2,
        '高雄最大購物中心,附有摩天輪,提供購物、美食與休閒娛樂,是遊客與家庭旅客休閒娛樂的理想地點。',
        4.6,
        22.604167,
        120.301389,
        NULL,
        '2025-10-14 13:57:37'
    ),
    (
        68,
        '中央公園英迪格酒店',
        '住宿',
        4,
        '精品風格飯店,位置便利景觀佳,提供舒適住宿與完善服務,是高雄旅客享受便利住宿與休閒的理想選擇。',
        4.8,
        22.630000,
        120.302222,
        NULL,
        '2025-10-14 13:59:12'
    ),
    (
        69,
        '奇美博物館',
        '景點',
        5,
        '藝術與自然結合的歐風建築博物館,提供展覽、教育體驗與拍照景點,是台南旅客與藝術愛好者必訪的景點。',
        4.9,
        22.934167,
        120.227222,
        NULL,
        '2025-10-14 14:00:41'
    ),
    (
        70,
        '永樂市場',
        '餐廳',
        5,
        '老市場美食聚集地,以牛肉湯聞名,提供在地早餐與美食文化體驗,是遊客探索台南傳統市場與小吃的好去處。',
        4.6,
        22.991111,
        120.197222,
        NULL,
        '2025-10-14 14:02:18'
    ),
    (
        71,
        '四草綠色隧道',
        '景點',
        5,
        '有「台版亞馬遜」之稱的紅樹林生態區,提供自然探索、划船體驗與親子活動,是台南旅客體驗生態與自然景觀的理想景點。',
        4.8,
        23.000000,
        120.200000,
        NULL,
        '2025-10-14 14:03:56'
    ),
    (
        72,
        '香格里拉台南遠東國際大飯店',
        '住宿',
        5,
        '五星級飯店,設備完善、鄰近車站,提供豪華住宿與便利交通,是台南旅客享受高品質住宿與交通便利的最佳選擇。',
        4.9,
        22.997222,
        120.212222,
        NULL,
        '2025-10-14 14:05:29'
    ),
    (
        73,
        '中正紀念堂',
        '景點',
        1,
        '國家級地標與歷史建築,環境開闊,提供參觀、拍照與文化體驗,是遊客了解台北歷史與文化的重要景點。',
        4.7,
        25.034000,
        121.521500,
        NULL,
        '2025-10-14 13:35:12'
    );

-- favorite_lists 資料
-- 注意:這裡假設 user_id = 1 的用戶已經在 users 表中存在
INSERT INTO
    favorite_lists (
        list_id,
        user_id,
        name,
        description,
        location_id,
        created_at
    )
VALUES (
        1,
        1,
        '我的最愛',
        '測試用清單',
        NULL,
        '2025-10-18 17:48:08'
    ),
    (
        2,
        1,
        '測試',
        '測試',
        NULL,
        '2025-10-18 18:56:42'
    ),
    (
        4,
        1,
        '123',
        '123123',
        NULL,
        '2025-10-21 09:37:49'
    );

-- favorite_list_places 資料
INSERT INTO
    favorite_list_places (
        list_places_id,
        list_id,
        place_id
    )
VALUES (2, 1, 2),
    (18, 1, 21),
    (19, 1, 24),
    (50, 4, 18),
    (56, 1, 16),
    (59, 1, 1),
    (60, 1, 7);

-- trips 資料
INSERT INTO
    trips (
        trip_id,
        trip_name,
        user_id,
        description,
        start_date,
        end_date,
        cover_image_url,
        is_public,
        location_id,
        summary_text,
        created_at
    )
VALUES (
        1,
        '台北週末小旅行',
        1,
        '探索台北市區景點與美食',
        '2025-10-18',
        '2025-10-20',
        'https://example.com/taipei.jpg',
        0,
        1,
        '三天兩夜台北自由行',
        '2025-10-14 11:53:24'
    ),
    (
        2,
        '高雄美食之旅',
        1,
        '品味高雄夜市與海港風情',
        '2025-11-01',
        '2025-11-03',
        'https://example.com/kaohsiung.jpg',
        0,
        2,
        '高雄在地美食探索',
        '2025-10-14 11:53:24'
    );

-- trip_days 資料
INSERT INTO
    trip_days (
        trip_day_id,
        trip_id,
        date,
        day_number
    )
VALUES (1, 1, '2025-10-18', 1),
    (2, 1, '2025-10-19', 2),
    (3, 1, '2025-10-20', 3),
    (4, 2, '2025-11-01', 1),
    (5, 2, '2025-11-02', 2),
    (6, 2, '2025-11-03', 3);

-- trip_items 資料
INSERT INTO
    trip_items (
        trip_item_id,
        trip_day_id,
        place_id,
        type,
        note,
        start_time,
        end_time,
        sort_order
    )
VALUES (
        1,
        1,
        1,
        '景點',
        '早上登上觀景台拍照',
        '09:00:00',
        '11:00:00',
        1
    ),
    (
        2,
        2,
        2,
        '餐廳',
        '晚餐逛夜市吃小吃',
        '18:00:00',
        '20:00:00',
        2
    ),
    (
        3,
        4,
        2,
        '餐廳',
        '第一天晚餐在六合夜市',
        '19:00:00',
        '21:00:00',
        1
    ),
    (
        4,
        5,
        2,
        '餐廳',
        '再訪夜市,嘗試不同攤位',
        '18:30:00',
        '20:30:00',
        1
    );

-- ========================================
-- 假資料 - media 表格
-- ========================================

INSERT INTO
    media (
        media_id,
        user_id,
        trip_id,
        place_id,
        place_category,
        url,
        is_cover,
        description,
        created_at
    )
VALUES (
        113,
        NULL,
        NULL,
        1,
        '景點',
        'place_1.jpg',
        1,
        '台北101 景點圖片',
        '2025-10-15 14:00:00'
    ),
    (
        114,
        NULL,
        NULL,
        2,
        '餐廳',
        'place_2.jpg',
        1,
        '六合夜市 餐廳圖片',
        '2025-10-15 14:01:00'
    ),
    (
        115,
        NULL,
        NULL,
        3,
        '景點',
        'place_3.jpg',
        1,
        '赤崁樓 景點圖片',
        '2025-10-15 14:02:00'
    ),
    (
        116,
        NULL,
        NULL,
        4,
        '景點',
        'place_4.jpg',
        1,
        '國立故宮博物院 景點圖片',
        '2025-10-15 14:03:00'
    ),
    (
        117,
        NULL,
        NULL,
        5,
        '餐廳',
        'place_5.jpg',
        1,
        '士林夜市 餐廳圖片',
        '2025-10-15 14:04:00'
    ),
    (
        118,
        NULL,
        NULL,
        6,
        '景點',
        'place_6.jpg',
        1,
        '西門町商圈 景點圖片',
        '2025-10-15 14:05:00'
    ),
    (
        119,
        NULL,
        NULL,
        7,
        '景點',
        'place_7.jpg',
        1,
        '象山步道 景點圖片',
        '2025-10-15 14:06:00'
    ),
    (
        120,
        NULL,
        NULL,
        8,
        '餐廳',
        'place_8.jpg',
        1,
        '饒河街夜市 餐廳圖片',
        '2025-10-15 14:07:00'
    ),
    (
        121,
        NULL,
        NULL,
        9,
        '景點',
        'place_9.jpg',
        1,
        '松山文創園區 景點圖片',
        '2025-10-15 14:08:00'
    ),
    (
        122,
        NULL,
        NULL,
        10,
        '景點',
        'place_10.jpg',
        1,
        '北投溫泉區 景點圖片',
        '2025-10-15 14:09:00'
    ),
    (
        123,
        NULL,
        NULL,
        11,
        '景點',
        'place_11.jpg',
        1,
        '美麗華百樂園 景點圖片',
        '2025-10-15 14:10:00'
    ),
    (
        124,
        NULL,
        NULL,
        12,
        '住宿',
        'place_12.jpg',
        1,
        '台北萬豪酒店 住宿圖片',
        '2025-10-15 14:11:00'
    ),
    (
        125,
        NULL,
        NULL,
        13,
        '景點',
        'place_13.jpg',
        1,
        '台中國家歌劇院 景點圖片',
        '2025-10-15 14:12:00'
    ),
    (
        126,
        NULL,
        NULL,
        14,
        '餐廳',
        'place_14.jpg',
        1,
        '逢甲夜市 餐廳圖片',
        '2025-10-15 14:13:00'
    ),
    (
        127,
        NULL,
        NULL,
        15,
        '景點',
        'place_15.jpg',
        1,
        '高美濕地 景點圖片',
        '2025-10-15 14:14:00'
    ),
    (
        128,
        NULL,
        NULL,
        16,
        '景點',
        'place_16.jpg',
        1,
        '審計新村 景點圖片',
        '2025-10-15 14:15:00'
    ),
    (
        129,
        NULL,
        NULL,
        17,
        '餐廳',
        'place_17.jpg',
        1,
        '宮原眼科 餐廳圖片',
        '2025-10-15 14:16:00'
    ),
    (
        130,
        NULL,
        NULL,
        18,
        '景點',
        'place_18.jpg',
        1,
        '一中街商圈 景點圖片',
        '2025-10-15 14:17:00'
    ),
    (
        131,
        NULL,
        NULL,
        19,
        '景點',
        'place_19.jpg',
        1,
        '勤美誠品綠園道 景點圖片',
        '2025-10-15 14:18:00'
    ),
    (
        132,
        NULL,
        NULL,
        20,
        '景點',
        'place_20.jpg',
        1,
        '台中港三井Outlet 景點圖片',
        '2025-10-15 14:19:00'
    ),
    (
        133,
        NULL,
        NULL,
        21,
        '住宿',
        'place_21.jpg',
        1,
        '日月千禧酒店 住宿圖片',
        '2025-10-15 14:20:00'
    ),
    (
        134,
        NULL,
        NULL,
        22,
        '餐廳',
        'place_22.jpg',
        1,
        '春水堂創始店 餐廳圖片',
        '2025-10-15 14:21:00'
    ),
    (
        135,
        NULL,
        NULL,
        23,
        '景點',
        'place_23.jpg',
        1,
        '太魯閣國家公園 景點圖片',
        '2025-10-15 14:22:00'
    ),
    (
        136,
        NULL,
        NULL,
        24,
        '景點',
        'place_24.jpg',
        1,
        '七星潭海岸 景點圖片',
        '2025-10-15 14:23:00'
    ),
    (
        137,
        NULL,
        NULL,
        25,
        '餐廳',
        'place_25.jpg',
        1,
        '東大門夜市 餐廳圖片',
        '2025-10-15 14:24:00'
    ),
    (
        138,
        NULL,
        NULL,
        26,
        '景點',
        'place_26.jpg',
        1,
        '花蓮文創園區 景點圖片',
        '2025-10-15 14:25:00'
    ),
    (
        139,
        NULL,
        NULL,
        27,
        '景點',
        'place_27.jpg',
        1,
        '鯉魚潭風景區 景點圖片',
        '2025-10-15 14:26:00'
    ),
    (
        140,
        NULL,
        NULL,
        28,
        '住宿',
        'place_28.jpg',
        1,
        '花蓮遠雄悅來大飯店 住宿圖片',
        '2025-10-15 14:27:00'
    ),
    (
        141,
        NULL,
        NULL,
        29,
        '景點',
        'place_29.jpg',
        1,
        '瑞穗牧場 景點圖片',
        '2025-10-15 14:28:00'
    ),
    (
        142,
        NULL,
        NULL,
        30,
        '餐廳',
        'place_30.jpg',
        1,
        '花蓮文化創意夜市 餐廳圖片',
        '2025-10-15 14:29:00'
    ),
    (
        143,
        NULL,
        NULL,
        31,
        '景點',
        'place_31.jpg',
        1,
        '遠雄海洋公園 景點圖片',
        '2025-10-15 14:30:00'
    ),
    (
        144,
        NULL,
        NULL,
        32,
        '住宿',
        'place_32.jpg',
        1,
        '花蓮福容大飯店 住宿圖片',
        '2025-10-15 14:31:00'
    ),
    (
        145,
        NULL,
        NULL,
        33,
        '景點',
        'place_33.jpg',
        1,
        '蓮池潭風景區 景點圖片',
        '2025-10-15 14:32:00'
    ),
    (
        146,
        NULL,
        NULL,
        34,
        '景點',
        'place_34.jpg',
        1,
        '駁二藝術特區 景點圖片',
        '2025-10-15 14:33:00'
    ),
    (
        147,
        NULL,
        NULL,
        35,
        '餐廳',
        'place_35.jpg',
        1,
        '六合夜市 餐廳圖片',
        '2025-10-15 14:34:00'
    ),
    (
        148,
        NULL,
        NULL,
        36,
        '景點',
        'place_36.jpg',
        1,
        '愛河風景區 景點圖片',
        '2025-10-15 14:35:00'
    ),
    (
        149,
        NULL,
        NULL,
        37,
        '景點',
        'place_37.jpg',
        1,
        '壽山動物園 景點圖片',
        '2025-10-15 14:36:00'
    ),
    (
        150,
        NULL,
        NULL,
        38,
        '景點',
        'place_38.jpg',
        1,
        '美麗島捷運站 景點圖片',
        '2025-10-15 14:37:00'
    ),
    (
        151,
        NULL,
        NULL,
        39,
        '景點',
        'place_39.jpg',
        1,
        '高雄中央公園 景點圖片',
        '2025-10-15 14:38:00'
    ),
    (
        152,
        NULL,
        NULL,
        40,
        '景點',
        'place_40.jpg',
        1,
        '義享天地 景點圖片',
        '2025-10-15 14:39:00'
    ),
    (
        153,
        NULL,
        NULL,
        41,
        '住宿',
        'place_41.jpg',
        1,
        '漢來大飯店 住宿圖片',
        '2025-10-15 14:40:00'
    ),
    (
        154,
        NULL,
        NULL,
        42,
        '餐廳',
        'place_42.jpg',
        1,
        '鹽埕老街 餐廳圖片',
        '2025-10-15 14:41:00'
    ),
    (
        155,
        NULL,
        NULL,
        43,
        '景點',
        'place_43.jpg',
        1,
        '安平古堡 景點圖片',
        '2025-10-15 14:42:00'
    ),
    (
        156,
        NULL,
        NULL,
        44,
        '景點',
        'place_44.jpg',
        1,
        '赤崁樓 景點圖片',
        '2025-10-15 14:43:00'
    ),
    (
        157,
        NULL,
        NULL,
        45,
        '餐廳',
        'place_45.jpg',
        1,
        '花園夜市 餐廳圖片',
        '2025-10-15 14:44:00'
    ),
    (
        158,
        NULL,
        NULL,
        46,
        '景點',
        'place_46.jpg',
        1,
        '台南孔廟 景點圖片',
        '2025-10-15 14:45:00'
    ),
    (
        159,
        NULL,
        NULL,
        47,
        '景點',
        'place_47.jpg',
        1,
        '安平樹屋 景點圖片',
        '2025-10-15 14:46:00'
    ),
    (
        160,
        NULL,
        NULL,
        48,
        '景點',
        'place_48.jpg',
        1,
        '藍晒圖文創園區 景點圖片',
        '2025-10-15 14:47:00'
    ),
    (
        161,
        NULL,
        NULL,
        49,
        '餐廳',
        'place_49.jpg',
        1,
        '鵪鶉鹹粥 餐廳圖片',
        '2025-10-15 14:48:00'
    ),
    (
        162,
        NULL,
        NULL,
        50,
        '住宿',
        'place_50.jpg',
        1,
        '晶英酒店 住宿圖片',
        '2025-10-15 14:49:00'
    ),
    (
        163,
        NULL,
        NULL,
        51,
        '景點',
        'place_51.jpg',
        1,
        '正興街商圈 景點圖片',
        '2025-10-15 14:50:00'
    ),
    (
        164,
        NULL,
        NULL,
        52,
        '景點',
        'place_52.jpg',
        1,
        '台南美術館 景點圖片',
        '2025-10-15 14:51:00'
    ),
    (
        165,
        NULL,
        NULL,
        53,
        '景點',
        'place_53.jpg',
        1,
        '台北101 景點圖片',
        '2025-10-15 14:52:00'
    ),
    (
        166,
        NULL,
        NULL,
        54,
        '景點',
        'place_54.jpg',
        1,
        '陽明山國家公園 景點圖片',
        '2025-10-15 14:53:00'
    ),
    (
        167,
        NULL,
        NULL,
        55,
        '餐廳',
        'place_55.jpg',
        1,
        '金峰魯肉飯 餐廳圖片',
        '2025-10-15 14:54:00'
    ),
    (
        168,
        NULL,
        NULL,
        56,
        '住宿',
        'place_56.jpg',
        1,
        '圓山大飯店 住宿圖片',
        '2025-10-15 14:55:00'
    ),
    (
        169,
        NULL,
        NULL,
        57,
        '景點',
        'place_57.jpg',
        1,
        '彩虹眷村 景點圖片',
        '2025-10-15 14:56:00'
    ),
    (
        170,
        NULL,
        NULL,
        58,
        '餐廳',
        'place_58.jpg',
        1,
        '宮原眼科冰淇淋店 餐廳圖片',
        '2025-10-15 14:57:00'
    ),
    (
        171,
        NULL,
        NULL,
        59,
        '景點',
        'place_59.jpg',
        1,
        '谷關溫泉區 景點圖片',
        '2025-10-15 14:58:00'
    ),
    (
        172,
        NULL,
        NULL,
        60,
        '住宿',
        'place_60.jpg',
        1,
        '林酒店 住宿圖片',
        '2025-10-15 14:59:00'
    ),
    (
        173,
        NULL,
        NULL,
        61,
        '景點',
        'place_61.jpg',
        1,
        '石梯坪風景區 景點圖片',
        '2025-10-15 15:00:00'
    ),
    (
        174,
        NULL,
        NULL,
        62,
        '餐廳',
        'place_62.jpg',
        1,
        '花蓮炸蛋蔥油餅 餐廳圖片',
        '2025-10-15 15:01:00'
    ),
    (
        175,
        NULL,
        NULL,
        63,
        '景點',
        'place_63.jpg',
        1,
        '立川漁場 景點圖片',
        '2025-10-15 15:02:00'
    ),
    (
        176,
        NULL,
        NULL,
        64,
        '住宿',
        'place_64.jpg',
        1,
        '秧悅美地渡假酒店 住宿圖片',
        '2025-10-15 15:03:00'
    ),
    (
        177,
        NULL,
        NULL,
        65,
        '景點',
        'place_65.jpg',
        1,
        '旗津風車公園 景點圖片',
        '2025-10-15 15:04:00'
    ),
    (
        178,
        NULL,
        NULL,
        66,
        '餐廳',
        'place_66.jpg',
        1,
        '鹽埕婆婆冰 餐廳圖片',
        '2025-10-15 15:05:00'
    ),
    (
        179,
        NULL,
        NULL,
        67,
        '景點',
        'place_67.jpg',
        1,
        '夢時代購物中心 景點圖片',
        '2025-10-15 15:06:00'
    ),
    (
        180,
        NULL,
        NULL,
        68,
        '住宿',
        'place_68.jpg',
        1,
        '中央公園英迪格酒店 住宿圖片',
        '2025-10-15 15:07:00'
    ),
    (
        181,
        NULL,
        NULL,
        69,
        '景點',
        'place_69.jpg',
        1,
        '奇美博物館 景點圖片',
        '2025-10-15 15:08:00'
    ),
    (
        182,
        NULL,
        NULL,
        70,
        '餐廳',
        'place_70.jpg',
        1,
        '永樂市場 餐廳圖片',
        '2025-10-15 15:09:00'
    ),
    (
        183,
        NULL,
        NULL,
        71,
        '景點',
        'place_71.jpg',
        1,
        '四草綠色隧道 景點圖片',
        '2025-10-15 15:10:00'
    ),
    (
        184,
        NULL,
        NULL,
        72,
        '住宿',
        'place_72.jpg',
        1,
        '香格里拉台南遠東國際大飯店 住宿圖片',
        '2025-10-15 15:11:00'
    ),
    (
        185,
        NULL,
        NULL,
        73,
        '景點',
        'place_73.jpg',
        1,
        '中正紀念堂 景點圖片',
        '2025-10-15 15:12:00'
    );