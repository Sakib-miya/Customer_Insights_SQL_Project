-- ===============================================
-- 1️⃣ Create Database
-- ===============================================
DROP DATABASE IF EXISTS ecommerce_portfolio;
CREATE DATABASE ecommerce_portfolio;
USE ecommerce_portfolio;

-- ===============================================
-- 2️⃣ Create Tables with Constraints & Indexes
-- ===============================================

-- Amazon Orders
DROP TABLE IF EXISTS amazon_500_users;
CREATE TABLE amazon_500_users (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    name VARCHAR(50),
    product VARCHAR(50),
    category VARCHAR(50),
    quantity INT CHECK(quantity>0),
    total_amount DECIMAL(10,2) CHECK(total_amount>=0),
    order_date DATE,
    city VARCHAR(50),
    payment_method VARCHAR(20)
);
CREATE INDEX idx_amazon_customer_date ON amazon_500_users(customer_id, order_date);

-- Walmart Orders
DROP TABLE IF EXISTS walmart_500_users;
CREATE TABLE walmart_500_users (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    name VARCHAR(50),
    product VARCHAR(50),
    category VARCHAR(50),
    quantity INT CHECK(quantity>0),
    total_amount DECIMAL(10,2) CHECK(total_amount>=0),
    order_date DATE,
    city VARCHAR(50),
    payment_method VARCHAR(20)
);
CREATE INDEX idx_walmart_customer_date ON walmart_500_users(customer_id, order_date);

-- Products
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost_price DECIMAL(10,2),
    stock_quantity INT CHECK(stock_quantity>=0)
);
CREATE INDEX idx_products_category ON products(category, product_id);

-- Returns
DROP TABLE IF EXISTS returns;
CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    return_date DATE,
    reason VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES amazon_500_users(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ===============================================
-- 3️⃣ Insert Sample Data
-- ===============================================

-- Amazon Orders
INSERT INTO amazon_500_users (customer_id,name,product,category,quantity,total_amount,order_date,city,payment_method)
VALUES
('C001','Alice','Laptop','Electronics',1,1200,'2025-01-05','New York','Credit Card'),
('C002','Bob','Smartphone','Electronics',2,1600,'2025-02-12','Los Angeles','PayPal'),
('C001','Alice','Mouse','Electronics',1,50,'2025-01-05','New York','Credit Card'),
('C003','Eve','T-Shirt','Clothing',3,60,'2025-03-10','Boston','Debit Card'),
('C004','Frank','Shoes','Clothing',1,80,'2025-03-15','Seattle','Credit Card');

-- Walmart Orders
INSERT INTO walmart_500_users (customer_id,name,product,category,quantity,total_amount,order_date,city,payment_method)
VALUES
('W001','Charlie','Headphones','Electronics',1,100,'2025-01-10','Chicago','Credit Card'),
('W002','Diana','Monitor','Electronics',1,300,'2025-02-15','Miami','Debit Card'),
('W001','Charlie','Keyboard','Electronics',1,50,'2025-01-10','Chicago','Credit Card'),
('W003','Grace','Bedsheet','Home',2,80,'2025-03-05','Dallas','PayPal');

-- Products
INSERT INTO products (product_name,category,price,cost_price,stock_quantity)
VALUES
('Laptop','Electronics',1200,900,50),
('Smartphone','Electronics',800,600,100),
('Mouse','Electronics',50,20,200),
('T-Shirt','Clothing',20,10,150),
('Shoes','Clothing',80,50,75),
('Headphones','Electronics',100,70,80),
('Monitor','Electronics',300,200,60),
('Keyboard','Electronics',50,30,120),
('Bedsheet','Home',40,25,60);

-- Returns
INSERT INTO returns (order_id,product_id,return_date,reason)
VALUES
(1,1,'2025-03-15','Damaged item'),
(2,2,'2025-03-20','Wrong product size');

-- ===============================================
-- 4️⃣ Stored Procedure: Monthly RFM (Production-ready)
-- ===============================================
DELIMITER $$
CREATE PROCEDURE CalculateMonthlyRFM(IN month_year VARCHAR(7))
BEGIN
    SELECT customer_id, name,
           MAX(order_date) AS last_order_date,
           COUNT(DISTINCT order_date) AS frequency,
           SUM(total_amount) AS monetary,
           DATEDIFF(CURRENT_DATE, MAX(order_date)) AS recency_days,
           NTILE(5) OVER (ORDER BY DATEDIFF(CURRENT_DATE, MAX(order_date)) DESC) AS r_score,
           NTILE(5) OVER (ORDER BY COUNT(DISTINCT order_date)) AS f_score,
           NTILE(5) OVER (ORDER BY SUM(total_amount)) AS m_score
    FROM amazon_500_users
    WHERE DATE_FORMAT(order_date,'%Y-%m') = month_year
    GROUP BY customer_id, name;
END$$
DELIMITER ;

-- ===============================================
-- 5️⃣ Core Analytics Queries
-- ===============================================

-- 5.1 RFM Analysis
WITH rfm_base AS (
    SELECT customer_id, name, MAX(order_date) AS last_order_date,
           COUNT(DISTINCT order_date) AS frequency,
           SUM(total_amount) AS monetary,
           DATEDIFF(CURRENT_DATE, MAX(order_date)) AS recency_days
    FROM amazon_500_users
    GROUP BY customer_id, name
),
rfm_scores AS (
    SELECT *,
           NTILE(5) OVER(ORDER BY recency_days DESC) AS r_score,
           NTILE(5) OVER(ORDER BY frequency) AS f_score,
           NTILE(5) OVER(ORDER BY monetary) AS m_score
    FROM rfm_base
)
SELECT customer_id, name, recency_days, frequency, monetary,
       CONCAT(r_score,f_score,m_score) AS rfm_segment,
       CASE 
           WHEN r_score>=4 AND f_score>=4 AND m_score>=4 THEN 'Champions'
           WHEN r_score>=3 AND f_score>=3 THEN 'Loyal Customers'
           WHEN r_score>=3 THEN 'Potential Loyalists'
           WHEN r_score>=2 THEN 'At Risk'
           ELSE 'Lost Customers'
       END AS customer_tier
FROM rfm_scores
ORDER BY monetary DESC;

-- 5.2 Customer Lifetime Value (CLV) + Edge Case Handling
WITH customer_metrics AS (
    SELECT customer_id,
           COUNT(DISTINCT order_date) AS order_count,
           SUM(total_amount) AS total_spent,
           DATEDIFF(MAX(order_date), MIN(order_date)) AS tenure_days
    FROM amazon_500_users
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT customer_id,
       total_spent AS CLV,
       total_spent/NULLIF(order_count,0) AS avg_order_value,
       total_spent/NULLIF(tenure_days,0) AS daily_spend_rate
FROM customer_metrics;

-- 5.3 Cross-Selling
WITH product_pairs AS (
    SELECT o1.customer_id,o1.order_date,o1.product AS product_a,o2.product AS product_b
    FROM (
        SELECT customer_id, order_date, product FROM amazon_500_users
        UNION ALL
        SELECT customer_id, order_date, product FROM walmart_500_users
    ) o1
    JOIN (
        SELECT customer_id, order_date, product FROM amazon_500_users
        UNION ALL
        SELECT customer_id, order_date, product FROM walmart_500_users
    ) o2
    ON o1.customer_id=o2.customer_id
       AND o1.order_date=o2.order_date
       AND o1.product<o2.product
)
SELECT product_a, product_b, COUNT(*) AS times_bought_together
FROM product_pairs
GROUP BY product_a,product_b
ORDER BY times_bought_together DESC
LIMIT 10;

-- 5.4 Return Rate Analytics
WITH returns_by_category AS (
    SELECT p.category, COUNT(*) AS returns_count
    FROM returns r
    JOIN products p ON p.product_id = r.product_id
    GROUP BY p.category
),
orders_by_category AS (
    SELECT category, COUNT(*) AS orders_count
    FROM (
        SELECT category FROM amazon_500_users
        UNION ALL
        SELECT category FROM walmart_500_users
    ) o
    GROUP BY category
)
SELECT obc.category,
       COALESCE(rbc.returns_count,0) AS returns_count,
       obc.orders_count,
       ROUND(COALESCE(rbc.returns_count,0)*100/NULLIF(obc.orders_count,0),2) AS return_rate_percent
FROM orders_by_category obc
LEFT JOIN returns_by_category rbc ON rbc.category = obc.category
ORDER BY return_rate_percent DESC;

-- 5.5 Comparative Analysis
SELECT 'Amazon' AS company, AVG(total_amount) AS avg_order_value, SUM(total_amount) AS total_revenue FROM amazon_500_users
UNION ALL
SELECT 'Walmart', AVG(total_amount), SUM(total_amount) FROM walmart_500_users;

-- 5.6 Month-over-Month Growth
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(order_date,'%Y-%m') AS month,
           SUM(total_amount) AS revenue,
           LAG(SUM(total_amount)) OVER (ORDER BY DATE_FORMAT(order_date,'%Y-%m')) AS prev_revenue
    FROM (
        SELECT order_date,total_amount FROM amazon_500_users
        UNION ALL
        SELECT order_date,total_amount FROM walmart_500_users
    ) combined
    GROUP BY DATE_FORMAT(order_date,'%Y-%m')
)
SELECT month, revenue,
       ROUND(((revenue-prev_revenue)/prev_revenue)*100,2) AS growth_percent
FROM monthly_revenue
ORDER BY month;

-- 5.7 Executive Dashboard Query (All KPIs)
SELECT company,
       COUNT(DISTINCT customer_id) AS total_customers,
       SUM(total_amount) AS total_revenue,
       ROUND(AVG(total_amount),2) AS avg_order_value,
       SUM(CASE WHEN total_amount>500 THEN 1 ELSE 0 END) AS high_value_orders
FROM (
    SELECT 'Amazon' AS company, customer_id, total_amount FROM amazon_500_users
    UNION ALL
    SELECT 'Walmart', customer_id, total_amount FROM walmart_500_users
) metrics
GROUP BY company;
