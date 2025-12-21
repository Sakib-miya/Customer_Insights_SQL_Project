🛒 SQL E-Commerce Analytics Project
📌 Project Overview

This project is a complete end-to-end SQL analytics solution built using simulated e-commerce data from Amazon and Walmart.
It demonstrates real-world data analyst skills, including database design, advanced SQL analytics, customer segmentation, and business-ready metrics used for decision-making.

The project focuses on answering practical business questions such as customer value, revenue growth, return behavior, and cross-selling opportunities — using SQL only.

🎯 Business Objectives

Identify high-value and at-risk customers

Measure customer lifetime value (CLV)

Track revenue performance and growth trends

Analyze returns and operational risk

Compare Amazon vs Walmart performance

Generate executive-level KPIs for dashboards

🗂 Dataset Structure
1️⃣ Amazon Orders (amazon_500_users)

~500 simulated customer orders

Key fields: order_id, customer_id, product, category, quantity, total_amount, order_date, city, payment_method

Indexed on customer_id and order_date for performance

2️⃣ Walmart Orders (walmart_500_users)

Same structure as Amazon orders

Enables cross-platform comparison

3️⃣ Products (products)

Product master data with pricing and inventory

Fields: product_name, category, price, cost_price, stock_quantity

4️⃣ Returns (returns)

Tracks returned products and reasons

Linked using foreign keys for relational integrity

🛠 Tools & Technologies

SQL (MySQL / MariaDB)

CTEs & Window Functions

NTILE-based scoring

Indexing & constraints

Stored procedures for reusable analytics

Dashboard-ready queries

📊 Key Analytics Performed
🔹 1️⃣ RFM Customer Segmentation

Classified customers into:

Champions

Loyal Customers

Potential Loyalists

At Risk

Lost Customers

Enables targeted marketing and retention strategies

🔹 2️⃣ Customer Lifetime Value (CLV)

Calculated total spend, average order value, and spending velocity

Identified long-term revenue contributors

🔹 3️⃣ Cross-Selling Analysis

Identified products frequently purchased together

Example: Laptop → Mouse

Useful for bundle and recommendation strategies

🔹 4️⃣ Return Rate Analysis

Measured return rates by product category

Highlighted high-risk categories impacting profitability

🔹 5️⃣ Comparative Analysis

Compared Amazon vs Walmart on:

Total revenue

Average order value

Helps evaluate platform performance

🔹 6️⃣ Month-over-Month Revenue Growth

Tracked revenue trends over time

Identified seasonality and growth patterns

🔹 7️⃣ Executive KPI Metrics

Total customers

Total revenue

Average order value

High-value orders (> $500)


▶️ How to Run This Project

Download SQL_Analytics_Code.sql

Load it into MySQL or MariaDB

Execute the script to:

Create tables

Insert sample data

Run analytics queries and stored procedures

Use the outputs for reporting or dashboards

🧠 Key Takeaways

Designed a production-style relational database

Applied advanced SQL analytics to solve business problems

Converted raw transactional data into actionable insights

Built analytics suitable for executive dashboards and decision-making

👤 Author

Sakib Miya
