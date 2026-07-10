-- =================================================
-- STEP7 テスト回答ファイル
-- 作成者:　清家 侑希
-- =================================================

-- ▼ 1. データベース作成
CREATE DATABASE IF NOT EXISTS step7_test;
USE step7_test;

-- ▼ 2. テーブル作成
-- ユーザ
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10),
    created_at DATE
);

-- 商品
CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price INT
);

-- 注文
CREATE TABLE orders (
    id INT PRIMARY Key,
    user_id INT,
    order_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 注文明細
CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id) 
);

-- ▼ 3.ダミーデータ作成
-- ユーザ
INSERT INTO users (id, name, age, gender, created_at) VALUES
(1, '山田太郎', 28, 'male', '2024-01-10'),
(2, '佐藤花子', 35, 'female', '2024-03-15'),
(3, '鈴木次郎', 42, 'male', '2023-08-20'),
(4, '田中美咲', 23, 'female', '2022-11-05'),
(5, '高橋健一', 30, 'male', '2024-06-01');

-- 商品
INSERT INTO products (id, product_name, price) VALUES
(1, 'テレビ', 50000),
(2, '冷蔵庫', 70000),
(3, '電子レンジ', 15000),
(4, '掃除機', 20000),
(5, '炊飯器', 18000);

-- 注文
INSERT INTO orders (id, user_id, order_date) VALUES
(1, 1, '2024-05-01'),
(2, 1, '2024-05-15'),
(3, 2, '2024-06-01'),
(4, 3, '2024-05-20'),
(5, 4, '2024-06-03'),
(6, 5, '2024-06-05');

-- 注文明細
INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1), -- 山田がテレビを１台
(2, 1, 3, 2), -- 山田が電子レンジを２台
(3, 2, 2, 1), -- 山田が冷蔵庫を１台

(4, 3, 5, 1), -- 佐藤が炊飯器を１台

(5, 4, 4, 1), -- 鈴木が掃除機を１台
(6, 4, 3, 1), -- 鈴木が冷蔵庫を１台

(7, 5, 2, 1), -- 田中が冷蔵庫を１台

(8, 6, 1, 1), -- 高橋がテレビを１台
(9, 6, 5, 2); -- 高橋が炊飯器を２台

-- ▼ 4.設問ごとの回答
-- 設問1: すべてのユーザー情報を取得
SELECT * FROM users;

-- 設問2: 2024年に作成されたユーザーを取得
SELECT * FROM users WHERE YEAR(created_at) = 2024; 

-- 設問3: 30歳未満かつ女性のユーザーを取得
SELECT * FROM users WHERE age < 30 AND gender = 'female';

-- 設問4: 全商品の一覧（商品名と価格）を取得
SELECT product_name, price FROM products;

-- 設問5: ordersとusersを結合し、ユーザー名と注文日を取得
SELECT users.name, orders.order_date
FROM users
JOIN orders
ON users.id = orders.user_id;

-- 設問6: order_itemsとproductsを結合し、各明細ごとに商品名と数量、単価、金額を取得
SELECT 
    products.product_name,
    order_items.quantity,
    products.price,
    products.price * order_items.quantity AS total_price
FROM products
JOIN order_items
ON order_items.product_id = products.id;

-- 設問7: ユーザーごとの注文件数を取得
SELECT 
    users.name,
    COUNT(orders.id) AS order_count
FROM users
JOIN orders
ON users.id = orders.user_id
GROUP BY users.id;

-- 設問8: 各ユーザーの総購入金額（明細の合計）を取得
SELECT 
    users.name,
    SUM(products.price * order_items.quantity) AS total_amount
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON order_items.product_id = products.id
GROUP BY users.id;

-- 設問9: 最も注文金額が高かったユーザーの名前と金額を取得
SELECT 
    users.name,
    SUM(products.price * order_items.quantity) AS total_amount
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON order_items.product_id = products.id
GROUP BY users.id
ORDER BY total_amount DESC
LIMIT 1;

-- 設問10: 各商品が何回注文されたかを取得
SELECT 
    products.product_name,
    SUM(order_items.quantity) AS total_quantity
FROM products
JOIN order_items
    ON products.id = order_items.product_id
GROUP BY products.id;

-- 設問11: 注文が1回もないユーザーを取得
SELECT 
    users.name
FROM users
LEFT JOIN orders
    ON users.id = orders.user_id
WHERE orders.id IS NULL;

-- 設問12: 1回の注文で2種類以上の商品を購入した注文のIDを取得
SELECT 
    order_items.order_id
FROM order_items
GROUP BY order_items.order_id
HAVING COUNT(order_items.product_id) >= 2;

-- 設問13: 「テレビ」という商品を注文したすべてのユーザー名を取得
SELECT users.name
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON products.id = order_items.product_id 
WHERE products.product_name = 'テレビ';

-- 設問14: 明細ごとの注文日・ユーザー名・商品名・数量・合計金額を一覧で取得
SELECT 
    orders.order_date,
    users.name,
    products.product_name,
    order_items.quantity,
    (products.price * order_items.quantity) AS total_amount
FROM users
JOIN orders
    ON users.id = orders.user_id
JOIN order_items
    ON orders.id = order_items.order_id
JOIN products
    ON products.id = order_items.product_id;

-- 設問15: 最も多く購入された商品（数量ベース）の商品名を取得
SELECT 
    products.product_name,
    SUM(order_items.quantity) AS total_quantity
FROM products
JOIN order_items
    ON products.id = order_items.product_id
GROUP BY products.product_name
ORDER BY total_quantity DESC
LIMIT 1;

-- 設問16: 各月の注文件数を取得（order_dateの年月を使用）
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') year_month,
    COUNT(id) AS total_count
FROM orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m');

-- 設問17: 注文のない商品を取得
SELECT products.product_name
FROM products
LEFT JOIN order_items
    ON products.id = order_items.product_id
WHERE order_items.product_id IS NULL;

-- 設問18: order_items.product_idにインデックスを追加
CREATE INDEX idx_product_id ON order_items(product_id);

-- 設問19: ユーザーごとの平均金額を取得
SELECT 
    users.name,
    AVG(order_total) AS avg_order_amount
FROM (
    SELECT
        orders.user_id,
        SUM(products.price * order_items.quantity) AS order_total
        FROM orders
        JOIN order_items
            ON orders.id = order_items.order_id
        JOIN products
            ON order_items.product_id = products.id
        GROUP BY orders.id
) AS sub
JOIN users
    ON users.id = sub.user_id
GROUP BY users.name;

-- 設問20: 各ユーザーの最新注文日のみを取得
SELECT 
    users.name,
    MAX(orders.order_date) AS latest_order_date
FROM users
JOIN orders
    ON users.id = orders.user_id
GROUP BY users.name;

-- 設問21: 新規ユーザー「中村愛（25歳・女性・2025-06-01作成）」をusersテーブルに追加
INSERT INTO 
    users(id, name, age, gender, created_at)
VALUES
    (6,'中村愛', 25, 'female', '2025-06-01');

-- 設問22: 商品「エアコン（価格：60000円）」をproductsテーブルに追加
INSERT INTO
    products(id, product_name, price)
VALUES
    (6, 'エアコン', 60000);

-- 設問23: ユーザーIDが1の人が2025-06-10に行った新しい注文を追加（注文IDは10)
INSERT INTO
    orders(id, user_id, order_date)
VALUES
    (10, 1, '2025-06-10');

-- 設問24: 上記の注文（注文ID:10）に対して、「エアコン（商品ID:6）」を１つ購入したことを表すorder_itemsを追加
INSERT INTO
    order_items(id, order_id, product_id, quantity)
VALUES
    (10, 10, 6, 1);

-- 設問25: ユーザー「田中美咲」の年齢を23歳から24歳に更新
UPDATE users
SET age = 24
WHERE name = '田中美咲';

-- 設問26: 全ての商品価格を10%値上げする
UPDATE products
SET price = price * 1.1;

-- 設問27: 2024年5月以前に行われた注文のorder_dateをすべて「2024-05-01」に統一する
UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date < '2024-05-01';

-- 設問28: ユーザー名が「高橋健一」のレコードをusersテーブルから削除
DELETE 
FROM users
WHERE name = '高橋健一';

-- 設問29: 注文IDが5の明細をすべて削除
DELETE
FROM order_items
WHERE order_id = 5;

-- 設問30: 一度も注文されたことの無い商品をproductsテーブルから削除
DELETE
FROM products
WHERE id NOT IN (
    SELECT product_id FROM order_items
); 