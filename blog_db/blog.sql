-- ========================================
-- 步驟 1: 清空舊的 Blog 表格（如果有）
-- ========================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS bookmarks;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS post_photos;
DROP TABLE IF EXISTS comment_likes;
DROP TABLE IF EXISTS post_likes;
DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS sns_tags;
DROP TABLE IF EXISTS post_comments;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
SET FOREIGN_KEY_CHECKS = 1;

-- ========================================
-- 步驟 2: 執行完整的 Blog SQL
-- ========================================

-- posts 文章表
CREATE TABLE IF NOT EXISTS posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT(5000),
    category ENUM('travel', 'food', 'life', 'photo') NOT NULL,
    trip_id INT NULL,
    visible BOOLEAN DEFAULT TRUE,
    view_count INT DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_trip_id (trip_id),
    INDEX idx_category (category),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- comments 留言表
CREATE TABLE IF NOT EXISTS comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT(1000) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- post_comments 文章留言關聯表
CREATE TABLE IF NOT EXISTS post_comments (
    post_comments_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    comment_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_post_id (post_id),
    INDEX idx_comment_id (comment_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- sns_tags 標籤表
CREATE TABLE IF NOT EXISTS sns_tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tagname VARCHAR(50) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_tagname (tagname)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- post_tags 文章標籤關聯表
CREATE TABLE IF NOT EXISTS post_tags (
    post_tags_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    tag_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_post_id (post_id),
    INDEX idx_tag_id (tag_id),
    UNIQUE KEY unique_post_tag (post_id, tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- post_likes 文章按讚表
CREATE TABLE IF NOT EXISTS post_likes (
    post_likes_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_post_user_like (post_id, user_id),
    INDEX idx_post_id (post_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- comment_likes 留言按讚表
CREATE TABLE IF NOT EXISTS comment_likes (
    comment_likes_id INT AUTO_INCREMENT PRIMARY KEY,
    comment_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_comment_user_like (comment_id, user_id),
    INDEX idx_comment_id (comment_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- post_photos 文章圖片表
CREATE TABLE IF NOT EXISTS post_photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    url VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_post_id (post_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- follows 追蹤表
CREATE TABLE IF NOT EXISTS follows (
    follow_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL COMMENT '追蹤者',
    following_id INT NOT NULL COMMENT '被追蹤者',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_follower_following (follower_id, following_id),
    INDEX idx_follower_id (follower_id),
    INDEX idx_following_id (following_id),

    CHECK (follower_id != following_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bookmarks 收藏表
CREATE TABLE IF NOT EXISTS bookmarks (
    bookmark_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_post_user_bookmark (post_id, user_id),
    INDEX idx_post_id (post_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================================
-- 步驟 3: 建立所有外鍵關聯
-- ========================================

-- posts 表的外鍵
ALTER TABLE posts
ADD CONSTRAINT fk_posts_users
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE posts
ADD CONSTRAINT fk_posts_trips
FOREIGN KEY (trip_id)
REFERENCES trips(trip_id)
ON DELETE SET NULL;

-- comments 表的外鍵
ALTER TABLE comments
ADD CONSTRAINT fk_comments_users
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

-- post_comments 表的外鍵
ALTER TABLE post_comments
ADD CONSTRAINT fk_post_comments_posts
FOREIGN KEY (post_id)
REFERENCES posts(post_id)
ON DELETE CASCADE;

ALTER TABLE post_comments
ADD CONSTRAINT fk_post_comments_comments
FOREIGN KEY (comment_id)
REFERENCES comments(comment_id)
ON DELETE CASCADE;

-- post_tags 表的外鍵
ALTER TABLE post_tags
ADD CONSTRAINT fk_post_tags_posts
FOREIGN KEY (post_id)
REFERENCES posts(post_id)
ON DELETE CASCADE;

ALTER TABLE post_tags
ADD CONSTRAINT fk_post_tags_tags
FOREIGN KEY (tag_id)
REFERENCES sns_tags(tag_id)
ON DELETE CASCADE;

-- post_likes 表的外鍵
ALTER TABLE post_likes
ADD CONSTRAINT fk_post_likes_posts
FOREIGN KEY (post_id)
REFERENCES posts(post_id)
ON DELETE CASCADE;

ALTER TABLE post_likes
ADD CONSTRAINT fk_post_likes_users
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

-- comment_likes 表的外鍵
ALTER TABLE comment_likes
ADD CONSTRAINT fk_comment_likes_comments
FOREIGN KEY (comment_id)
REFERENCES comments(comment_id)
ON DELETE CASCADE;

ALTER TABLE comment_likes
ADD CONSTRAINT fk_comment_likes_users
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;

-- post_photos 表的外鍵
ALTER TABLE post_photos
ADD CONSTRAINT fk_post_photos_posts
FOREIGN KEY (post_id)
REFERENCES posts(post_id)
ON DELETE CASCADE;

-- follows 表的外鍵
ALTER TABLE follows
ADD CONSTRAINT fk_follows_follower
FOREIGN KEY (follower_id)
REFERENCES users(id)
ON DELETE CASCADE;

ALTER TABLE follows
ADD CONSTRAINT fk_follows_following
FOREIGN KEY (following_id)
REFERENCES users(id)
ON DELETE CASCADE;

-- bookmarks 表的外鍵
ALTER TABLE bookmarks
ADD CONSTRAINT fk_bookmarks_posts
FOREIGN KEY (post_id)
REFERENCES posts(post_id)
ON DELETE CASCADE;

ALTER TABLE bookmarks
ADD CONSTRAINT fk_bookmarks_users
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE;