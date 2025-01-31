# **📊 Apple Retail Sales Analytics – SQL Performance Optimization in PostgreSQL** 🚀

## 📅 Date: [Month, Year]  
👤 **Author:** [Your Name]  
🛠️ **Tech Stack:** PostgreSQL, SQL Query Optimization, Window Functions, CTEs, Indexing, Performance Tuning  

---

## **📌 Project Overview**  
This project focuses on **high-performance SQL analytics** using **PostgreSQL** to process **1M+ Apple retail sales transactions** efficiently.  
By leveraging **advanced SQL techniques** such as **window functions, indexing strategies, query refactoring, and performance tuning**, the project extracts **actionable insights on sales trends, warranty claims, product lifecycle analysis, and revenue forecasting**.

The dataset consists of **Apple store sales, products, warranties, and store locations**, enabling a **real-world SQL performance engineering challenge**.

---

## **🗂 Database Schema & Indexing Strategy**  
The project is structured around **5 key tables** with proper indexing to improve query performance:

| Table     | Primary Key (PK) | Foreign Keys (FK) | Indexed Columns               |
|-----------|----------------|------------------|------------------------------|
| **category**  | `category_id` | -                | `category_id`                |
| **products**  | `product_id`  | `category_id`    | `product_id`, `launch_date`  |
| **stores**    | `store_id`    | -                | `store_id`, `country`        |
| **sales**     | `sale_id`     | `store_id`, `product_id` | `sale_date`, `store_id`, `product_id` |
| **warranty**  | `claim_id`    | `sale_id`        | `sale_id`, `claim_date`      |

✅ **Indexing for Query Optimization**
```sql
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_store_product ON sales(store_id, product_id);
CREATE INDEX idx_warranty_claim_date ON warranty(claim_date);
CREATE INDEX idx_products_launch ON products(launch_date);
**` ``` `**
**`# 📊 Business Problems & Solutions`**
📊 Business Problems & Solutions
This project tackles 23 key business problems, ranging from simple counts and aggregations to advanced correlation analysis and time-based comparisons.

🟢 Easy to Medium (10 Questions)
Find the number of stores in each country: Group the stores based on their location and count them.
Total number of units sold by each store: Join the sales and store tables to sum up the quantities sold per store.
How many sales occurred in December 2023: Filter sales data to select transactions from December 2023.
How many stores have never had a warranty claim: Identify stores with no related warranty claims using NOT IN or anti-joins.
Count the number of stores with warranty void claims: Join sales and warranty tables to count stores with "Warranty Void" claims.
Calculate the percentage of warranty claims marked as "Warranty Void": Find the ratio of "Warranty Void" claims to total claims.
Identify which store had the highest total units sold in the last 2 years: Rank stores by units sold over the last two years.
Count the number of unique products sold in the last year: Count distinct product identifiers in sales data from the past year.
Find the unique products and their sales in the last year: Group sales by product to get total sales per product.
Calculate the average price of products in each category: Join products and categories, then compute the average product price.
🟡 Medium to Hard (8 Questions)
How many warranty claims were filed in 2020: Filter warranty claims for the year 2020 and count the entries.
Identify each store's best-selling day based on highest quantity sold: Extract the weekday from the sale date and rank them.
Identify the least selling product per country per year: Use ranking functions to find the lowest-selling products.
Calculate how many warranty claims were filed within 180 days of a product sale: Compute the date difference and filter claims.
Identify warranty claims for products launched in the last three years: Join sales and warranty data to count claims for new products.
List months in the last three years where sales exceeded 5000 units in the USA: Apply a HAVING clause on grouped sales data.
Identify the product category with the most warranty claims in the last two years: Rank product categories based on total claims.
Determine the percentage chance of receiving claims after each purchase for each country: Compute the ratio of claims to total sales.
🔴 Complex & Advanced (5 Questions)
Analyze each store's year-over-year growth ratio: Use window functions to calculate yearly growth.
Calculate the correlation between product price and warranty claims: Group products into price segments and count claims.
Identify the store with the highest percentage of "Paid Repaired" claims: Compute and rank the claim ratio per store.
Calculate the monthly running total of sales for each store over the past four years: Track sales trends over time.
Analyze product sales trends over different time periods: Segment products into key time periods and evaluate performance.
