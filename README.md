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
### **1. Find the number of stores in each country.**  
**Solution:** Group the stores based on their location and count them.  

### **2. Calculate the total number of units sold by each store.**  
**Solution:** Join the sales and store tables to sum up the quantities sold per store.  

### **3. Identify how many sales occurred in December 2023.**  
**Solution:** Filter sales data to select transactions from December 2023.  

### **4. Determine how many stores have never had a warranty claim.**  
**Solution:** Identify stores with no related warranty claims using NOT IN or anti-joins.  

### **5. Count the number of stores with warranty void claims.**  
**Solution:** Join the sales and warranty tables to count stores with "Warranty Void" claims.  

### **6. Calculate the percentage of warranty claims marked as "Warranty Void."**  
**Solution:** Find the ratio of "Warranty Void" claims to total claims.  

### **7. Identify which store had the highest total units sold in the last 2 years.**  
**Solution:** Rank stores by units sold over the last two years.  

### **8. Count the number of unique products sold in the last year.**  
**Solution:** Count distinct product identifiers in sales data from the past year.  

### **9. Find the unique products and their sales in the last year.**  
**Solution:** Group sales by product to get total sales per product.  

### **10. Calculate the average price of products in each category.**  
**Solution:** Join products and categories, then compute the average product price.  

---

## 🟡 Medium to Hard (8 Questions)
### **11. How many warranty claims were filed in 2020?**  
**Solution:** Filter warranty claims for the year 2020 and count the entries.  

### **12. Identify each store's best-selling day based on highest quantity sold.**  
**Solution:** Extract the weekday from the sale date and rank them.  

### **13. Identify the least selling product per country per year.**  
**Solution:** Use ranking functions to find the lowest-selling products.  

### **14. Calculate how many warranty claims were filed within 180 days of a product sale.**  
**Solution:** Compute the date difference and filter claims.  

### **15. Identify warranty claims for products launched in the last three years.**  
**Solution:** Join sales and warranty data to count claims for new products.  

### **16. List months in the last three years where sales exceeded 5000 units in the USA.**  
**Solution:** Apply a HAVING clause on grouped sales data.  

### **17. Identify the product category with the most warranty claims in the last two years.**  
**Solution:** Rank product categories based on total claims.  

### **18. Determine the percentage chance of receiving claims after each purchase for each country.**  
**Solution:** Compute the ratio of claims to total sales.  

---

## 🔴 Complex & Advanced (5 Questions)
### **19. Analyze each store's year-over-year growth ratio.**  
**Solution:** Use window functions to calculate yearly growth.  

### **20. Calculate the correlation between product price and warranty claims.**  
**Solution:** Group products into price segments and count claims.  

### **21. Identify the store with the highest percentage of "Paid Repaired" claims.**  
**Solution:** Compute and rank the claim ratio per store.  

### **22. Calculate the monthly running total of sales for each store over the past four years.**  
**Solution:** Track sales trends over time.  

### **23. Analyze product sales trends over different time periods.**  
**Solution:** Segment products into key time periods and evaluate performance.  

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

