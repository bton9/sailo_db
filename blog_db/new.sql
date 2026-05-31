USE `sailo_db`;

-- 新增 place_id 欄位到 posts 表
ALTER TABLE posts 
ADD COLUMN place_id INT NULL 
AFTER trip_id;

-- 新增欄位註解
ALTER TABLE posts 
MODIFY COLUMN place_id INT NULL 
COMMENT '關聯單一景點';

-- 新增外鍵約束
ALTER TABLE posts
ADD CONSTRAINT fk_posts_places 
FOREIGN KEY (place_id) REFERENCES places(place_id) 
ON DELETE SET NULL;

-- 新增索引
CREATE INDEX idx_place_id ON posts(place_id);