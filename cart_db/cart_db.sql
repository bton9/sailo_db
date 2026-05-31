USE sailo_db;

DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `order_detail`;
DROP TABLE IF EXISTS `orders`;
DROP TABLE IF EXISTS `cart_detail`;
DROP TABLE IF EXISTS `carts`;

CREATE TABLE cart_items (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '購物車項目ID',
  user_id INT NOT NULL COMMENT '用戶ID',
  product_id INT NOT NULL COMMENT '商品ID',
  quantity TINYINT NOT NULL COMMENT '數量',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入時間',
  
  INDEX idx_user_id (user_id),
  INDEX idx_product_id (product_id),
  UNIQUE KEY uk_user_product (user_id, product_id),
  
  CONSTRAINT fk_cart_items_users 
    FOREIGN KEY (user_id) 
    REFERENCES users(id) 
    ON DELETE CASCADE,
    
  CONSTRAINT fk_cart_items_products 
    FOREIGN KEY (product_id) 
    REFERENCES products(product_id) 
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='購物車項目';


CREATE TABLE orders (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '訂單ID',
  user_id INT NOT NULL COMMENT '用戶ID',
  total INT NOT NULL COMMENT '訂單總金額',
  payment_method TINYINT NOT NULL COMMENT '付款方式 0:未選擇 1:信用卡 2:ATM 3:超商代碼',
  payment_status TINYINT NOT NULL DEFAULT 0 COMMENT '付款狀態 0:未付款 1:已付款 2:付款失敗',
  recipient_name VARCHAR(20) NOT NULL COMMENT '收件人姓名',
  phone VARCHAR(20) NOT NULL COMMENT '聯絡電話',
  shipping_method TINYINT NOT NULL COMMENT '配送方式 0:未選擇 1:宅配 2:超商取貨',
  shipping_address VARCHAR(100) NOT NULL COMMENT '配送地址',
  order_status TINYINT NOT NULL DEFAULT 0 COMMENT '訂單狀態 0:待處理 1:已確認 2:已出貨 3:已完成 4:已取消',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '訂單日期',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  
  INDEX idx_user_id (user_id),
  INDEX idx_created_at (created_at),
  INDEX idx_order_status (order_status),
  INDEX idx_payment_status (payment_status),
  
  CONSTRAINT fk_orders_users 
    FOREIGN KEY (user_id) 
    REFERENCES users(id) 
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='訂單主表';

CREATE TABLE order_detail (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '明細ID',
  order_id INT NOT NULL COMMENT '訂單ID',
  product_id INT NOT NULL COMMENT '商品ID',
  quantity TINYINT NOT NULL COMMENT '數量',
  unit_price INT NOT NULL COMMENT '單價 (下單時的價格)',
  
  INDEX idx_order_id (order_id),
  INDEX idx_product_id (product_id),
  
  CONSTRAINT fk_order_detail_orders 
    FOREIGN KEY (order_id) 
    REFERENCES orders(id) 
    ON DELETE RESTRICT,
    
  CONSTRAINT fk_order_detail_products 
    FOREIGN KEY (product_id) 
    REFERENCES products(product_id) 
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='訂單明細';


CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT COMMENT '付款記錄ID',
  order_id INT NOT NULL COMMENT '訂單ID',
  merchant_trade_no VARCHAR(100) UNIQUE COMMENT '商店交易編號',
  payment_type VARCHAR(50) COMMENT '付款方式',
  amount INT NOT NULL COMMENT '付款金額',
  payment_status TINYINT NOT NULL DEFAULT 0 COMMENT '付款狀態 0:待付款 1:已付款 2:付款失敗',
  ecpay_trade_no VARCHAR(100) COMMENT 'ECPay交易編號',
  rtn_code INT COMMENT 'ECPay回傳碼',
  rtn_msg VARCHAR(500) COMMENT 'ECPay回傳訊息',
  payment_date DATETIME COMMENT '付款完成時間',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
  
  INDEX idx_order_id (order_id),
  INDEX idx_merchant_trade_no (merchant_trade_no),
  INDEX idx_payment_status (payment_status),
  
  CONSTRAINT fk_payments_orders 
    FOREIGN KEY (order_id) 
    REFERENCES orders(id) 
    ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci 
COMMENT='付款記錄表';


INSERT INTO cart_items (user_id, product_id, quantity, created_at)
VALUES 
    (3, 1, 2, DATE_SUB(NOW(), INTERVAL 2 DAY)), 
    (3, 2, 1, DATE_SUB(NOW(), INTERVAL 1 DAY)); 
