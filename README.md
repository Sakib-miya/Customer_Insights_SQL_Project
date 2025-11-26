# SQL E-Commerce Analytics Project

## 📌 Overview
Welcome! This project is a **complete SQL analytics solution** built using sample e-commerce data from **Amazon and Walmart**. It’s designed to **demonstrate real-world analytics skills**, including advanced SQL queries, data segmentation, and dashboard-ready metrics.

Here, we simulate an e-commerce business and extract insights to help make **data-driven decisions**, all using SQL.

---

## 🔹 Dataset Structure

### 🔹1️⃣ Amazon Orders (`amazon_500_users`)
- Contains 500 sample Amazon orders  
- Key fields: `order_id`, `customer_id`, `name`, `product`, `category`, `quantity`, `total_amount`, `order_date`, `city`, `payment_method`  
- Indexed on `customer_id` and `order_date` for faster queries  

### 🔹2️⃣ Walmart Orders (`walmart_500_users`)
- Contains 500 sample Walmart orders  
- Same structure as Amazon orders  
- Indexed on `customer_id` and `order_date`  

### 🔹3️⃣ Products (`products`)
- Master list of products with pricing and stock info  
- Key fields: `product_id`, `product_name`, `category`, `price`, `cost_price`, `stock_quantity`  
- Indexed on `category` for faster category-level analytics  

### 🔹4️⃣ Returns (`returns`)
- Tracks product returns along with reasons  
- Linked via foreign keys to `amazon_500_users` and `products`  

---

## 🔹 Skills Demonstrated
- SQL database creation and table management  
- Constraints, indexes, and relationships (primary & foreign keys)  
- Advanced analytics queries using **CTEs, window functions, and NTILE**  
- Stored procedures for **monthly RFM analysis**  
- Business metric calculations: CLV, return rate, MoM growth, high-value orders  
- Portfolio-ready dataset design  

---

## 🔹 Key Analytics Insights

### 🔹1️⃣ RFM (Recency, Frequency, Monetary) Analysis
- Segments customers into tiers: **Champions, Loyal Customers, Potential Loyalists, At Risk, Lost Customers**  
- Helps identify **top customers** for targeted marketing  
- Example: Customers with high frequency and monetary spend but recent activity = **“Champions”**  

### 🔹2️⃣ Customer Lifetime Value (CLV)
- Calculates total spent, average order value, and daily spend rate  
- Shows **how valuable each customer is over time**  

### 🔹3️⃣ Cross-Selling Opportunities
- Identifies products often bought together across Amazon and Walmart  
- Example: Customers buying a **Laptop** often also buy a **Mouse**  

### 🔹4️⃣ Return Rate Analytics
- Tracks return rate by category  
- Helps spot **high-risk product categories**  

### 🔹5️⃣ Comparative Analysis
- Compares Amazon vs Walmart on **average order value** and **total revenue**  
- Provides insight into **which platform performs better**  

### 🔹6️⃣ Month-over-Month (MoM) Growth
- Measures revenue growth month-by-month  
- Detects **trends and seasonality** in sales  

### 🔹7️⃣ Executive Dashboard Metrics
- Total customers  
- Total revenue  
- Average order value  
- High-value orders (orders > $500)  

---

## 🔹 Screenshots
All dashboard images are included in this repository under `/images`. You can view them to see how the data is visualized.

---

## 🔹 Live Dashboard Link
View the interactive dashboard [here](https://app.thebricks.com/file/577aadab-c23f-413b-929d-6f9e6d687301?permissionId=7e72cd59-48e7-407a-98f6-92240d009411)  
> 🔹 **Tip:** Once you land on the page, click the **“Open Fullscreen” button** to view the dashboard in full-screen mode.  

---

## 🔹 How to Use This Repo
1. Download the `SQL_Analytics_Code.sql` file  
2. Load it into your MySQL or MariaDB environment  
3. Run the queries and stored procedures to generate insights  
4. Use the included screenshots or the live dashboard for presentation  

---

## 🔹 Takeaway
This project is designed to showcase **real SQL analytics skills** in a structured, professional manner. It’s ideal for a **data analyst portfolio** and demonstrates the ability to **extract actionable insights from e-commerce data**.
