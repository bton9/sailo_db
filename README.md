# Sailo DB — 資料庫 Schema

Sailo 平台的 MySQL 資料庫結構，依功能模組分資料夾管理。

前端：[sailo_fronte_end](https://github.com/bton9/sailo_fronte_end)
後端：[sailo_backend](https://github.com/bton9/sailo_backend)

---

## 資料夾結構

```
Sailo_DB/
├── user_db/          # 使用者、登入、驗證
│   ├── sailo_bd.sql
│   └── v1.1/
│       └── db_v1.1.sql
├── custom_db/        # 景點、行程、收藏
│   └── custom_db.sql
├── blog_db/          # 部落格文章、留言、追蹤
│   ├── blog.sql
│   └── new.sql
├── cart_db/          # 購物車、訂單
│   ├── carts.sql
│   ├── cart_db.sql
│   ├── orders.sql
│   └── order_detail.sql
├── product_db/       # 商品
│   └── sailo_db_products.sql
└── 2025-11-11v2/     # 最新完整備份
    └── Dump20251111.sql
```

---

## 匯入方式

建議使用 **MySQL Workbench** 匯入：

1. 開啟 MySQL Workbench，連線至本機資料庫
2. 上方選單 **Server > Data Import**
3. 選擇 **Import from Self-Contained File**
4. 選取對應的 `.sql` 檔案
5. 按 **Start Import**

如需匯入完整資料庫，使用 `2025-11-11v2/Dump20251111.sql`。

---

## 模組說明

| 資料夾 | 說明 |
|--------|------|
| `user_db` | 使用者帳號、JWT Token、Google OAuth、OTP 驗證 |
| `custom_db` | 景點資料、行程規劃、景點收藏（本人負責模組） |
| `blog_db` | 文章、留言、按讚、標籤、追蹤 |
| `cart_db` | 購物車、訂單、付款紀錄 |
| `product_db` | 商品資料、分類、評論 |

---

## 作者

**林新堯**
資展國際前端工程師就業養成班（2025/6 – 2025/11）
GitHub：[@bton9](https://github.com/bton9)
