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


📊 Business Insights & Key Findings
🔹 Insight 1: Warranty Claims Are Highest for Low & Mid-Priced Products
Less expensive products (< $500) have the most warranty claims (13,292 claims).
Mid-priced products ($500 - $1500) come next with 12,721 claims.
Most expensive products (> $1500) have the least number of claims (1,539 claims).
Conclusion: Cheaper products might have lower durability, leading to more warranty claims.
