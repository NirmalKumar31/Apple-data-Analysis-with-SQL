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
```
# 📊 Business Problems & Solutions  
This project tackles **23 key business problems**, ranging from **simple counts and aggregations** to **advanced correlation analysis and time-based comparisons**.

## 🟢 Easy to Medium (10 Questions)
1. Find the number of stores in each country.  
2. Calculate the total number of units sold by each store.  
3. Identify how many sales occurred in December 2023.  
4. Determine how many stores have never had a warranty claim.  
5. Count the number of stores with warranty void claims.  
6. Calculate the percentage of warranty claims marked as "Warranty Void."  
7. Identify which store had the highest total units sold in the last 2 years.  
8. Count the number of unique products sold in the last year.  
9. Find the unique products and their sales in the last year.  
10. Calculate the average price of products in each category.  

---

## 🟡 Medium to Hard (8 Questions)
11. How many warranty claims were filed in 2020?  
12. Identify each store's best-selling day based on highest quantity sold.  
13. Identify the least selling product per country per year.  
14. Calculate how many warranty claims were filed within 180 days of a product sale.  
15. Identify warranty claims for products launched in the last three years.  
16. List months in the last three years where sales exceeded 5000 units in the USA.  
17. Identify the product category with the most warranty claims in the last two years.  
18. Determine the percentage chance of receiving claims after each purchase for each country.  

---

## 🔴 Complex & Advanced (5 Questions)
19. Analyze each store's year-over-year growth ratio.  
20. Calculate the correlation between product price and warranty claims.  
21. Identify the store with the highest percentage of "Paid Repaired" claims.  
22. Calculate the monthly running total of sales for each store over the past four years.  
23. Analyze product sales trends over different time periods.  

---

# 📊 Business Insights & Key Findings  

### **🔹 Insight 1: Warranty Claims Are Highest for Low & Mid-Priced Products**
- **Less expensive products (< $500) have the most warranty claims (13,292 claims).**
- **Mid-priced products ($500 - $1500) come next with 12,721 claims.**
- **Most expensive products (> $1500) have the least number of claims (1,539 claims).**
- **Conclusion:** Cheaper products might have lower durability, leading to more warranty claims.

---

### **🔹 Insight 2: Product Lifecycle & Sales Distribution**
- **"AirTag" has the highest sales (82,549 units) in its first 6 months.**
- **Older products like "iPhone X" continue selling well beyond 18 months (61,561 units).**
- **Sales of Apple products decline as they age past 12-18 months.**
- **Conclusion:** New product launches drive the majority of sales, but some older models continue to perform well.

---

# 🚀 **SQL Query Optimization & Performance Tuning**  

## ✅ **Optimization by Query Refactoring**
**Before Optimization:**  
- **Used multiple CTEs**, resulting in **redundant table scans** and **longer execution time (688ms).**
```sql
WITH paid_repair AS (
    SELECT st.store_name, COUNT(w.claim_id) AS total_paid_repaired
    FROM warranty w 
    LEFT JOIN sales s ON w.sale_id = s.sale_id
    JOIN stores st ON st.store_id = s.store_id
    WHERE w.repair_status = 'Paid Repaired'
    GROUP BY 1
),
total_repair AS (
    SELECT st.store_name, COUNT(w.claim_id) AS total_claims
    FROM warranty w 
    LEFT JOIN sales s ON w.sale_id = s.sale_id
    JOIN stores st ON st.store_id = s.store_id
    GROUP BY 1
)
SELECT tr.store_name, pr.total_paid_repaired, tr.total_claims,
       ROUND(pr.total_paid_repaired / tr.total_claims::NUMERIC * 100,2) || '%' AS paid_repair_percent
FROM paid_repair pr
JOIN total_repair tr ON pr.store_name = tr.store_name; 
```
**Optimized Approach:**  
- **Merged CTEs** into a **single query**, eliminating redundant scans, improving performance by **54% (316ms).**  
```sql
WITH repair_count AS (
    SELECT st.store_name, 
           COUNT(w.claim_id) FILTER (WHERE w.repair_status = 'Paid Repaired') AS total_paid_repaired,
           COUNT(w.claim_id) AS total_claims
    FROM warranty w 
    LEFT JOIN sales s ON w.sale_id = s.sale_id
    JOIN stores st ON st.store_id = s.store_id
    GROUP BY 1
)
SELECT store_name, total_paid_repaired, total_claims,
       ROUND(total_paid_repaired / total_claims::NUMERIC * 100,2) || '%' AS paid_repair_percent
FROM repair_count
WHERE total_paid_repaired > 0;
```

## ✅ **Optimization by Indexing**
### **Before Indexing (Slow Query Execution)**
- Query execution time: **266.3ms**
- No indexes on frequently filtered columns (e.g., `product_id`, `sale_date`)

```sql
EXPLAIN ANALYZE
SELECT * FROM sales
WHERE product_id = 'P-44';

```


### **After Indexing (Optimized Performance)**
- **Created indexes** on `sales(product_id)`, `sales(store_id)`, `sales(sale_date)`, `warranty(claim_date)`, and `products(launch_date)`.
- Execution time reduced from **266.3ms to ~2.73ms - 3.7ms** (significant improvement).

```sql
CREATE INDEX idx_sales_product ON sales(product_id);
CREATE INDEX idx_sales_store ON sales(store_id);
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_warranty_claim_date ON warranty(claim_date);
CREATE INDEX idx_products_launch ON products(launch_date);

EXPLAIN ANALYZE
SELECT * FROM sales
WHERE product_id = 'P-44';
```
---

### ✅ **Indexes Added for Performance Boost**
- `idx_sales_date` → Speeds up **date-based queries**.  
- `idx_sales_store_product` → Optimizes **store-product lookups**.  
- `idx_warranty_claim_date` → Enhances **warranty claim analysis**.  
- `idx_products_launch` → Helps in **product lifecycle tracking**.  

**Impact:**  
- **Faster query execution (Up to 95% improvement).**  
- **Optimized joins and aggregations.**  
- **Better handling of large datasets (~1M+ rows).**  



## 📎 How to Use This Repository  

🔹 **Clone this repo:**  
```bash
git clone https://github.com/yourusername/apple-retail-sales-sql.git
```
🔹 **Run SQL queries using PostgreSQL (pgAdmin, DBeaver, etc.)**  
🔹 **Check the Business_Problems_Solutions/ folder for detailed SQL queries.**  

---

## ⭐ Contribute & Connect  

💡 **If you find this useful, star ⭐ this repo!**  

🔗 **LinkedIn:** [https://www.linkedin.com/in/nirmalkumartk/]  
🔗 **GitHub:** [Your GitHub Profile]  





