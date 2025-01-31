# Apple-data-Analysis-with-SQL

# **📊 Apple Retail Sales Analytics – SQL Performance Optimization in PostgreSQL**

## 🚀 Project Overview  
This project leverages **PostgreSQL** to analyze **1M+ Apple retail sales transactions**.  
It focuses on **query performance tuning, indexing strategies, advanced SQL analytics, and business intelligence solutions** for optimizing large-scale retail data.  

### **Key Objectives:**  
✅ **Efficient Query Execution:** Performance-tuned SQL queries optimized for speed and scalability.  
✅ **Advanced SQL Analytics:** Time-series analysis, trend detection, and business intelligence insights.  
✅ **Optimization & Indexing:** Use of indexes, partitioning, and execution plan analysis to improve query speed.  
✅ **Real-World Business Problems:** Solving industry-relevant questions in retail sales and warranty claims.

---

## **🛠️ Tech Stack & SQL Concepts Used**  
- **PostgreSQL (Relational Database Management)**  
- **Joins & Aggregations (Performance-Optimized)**  
- **CTEs & Window Functions (LAG, RANK, SUM OVER)**  
- **Query Optimization (Execution Plan Analysis, Indexing, Filtering)**  
- **Performance Tuning (54% Query Speed Improvement)**  
- **Data Segmentation (Time-based & Category-based Analysis)**  

---

## **📂 Database Schema & Indexing Strategy**  
This project is structured around **5 key tables** with primary & foreign key relationships optimized using **indexes**.

| Table | Primary Key (PK) | Foreign Keys (FK) | Indexed Columns |
|--------|--------------|------------------|----------------|
| **category** | `category_id` | - | `category_id` |
| **products** | `product_id` | `category_id` | `product_id`, `launch_date` |
| **stores** | `store_id` | - | `store_id`, `country` |
| **sales** | `sale_id` | `store_id`, `product_id` | `sale_date`, `store_id`, `product_id` |
| **warranty** | `claim_id` | `sale_id` | `sale_id`, `claim_date` |

✅ **Indexing for Query Optimization**  
```sql
CREATE INDEX idx_sales_date ON sales(sale_date);
CREATE INDEX idx_sales_store_product ON sales(store_id, product_id);
CREATE INDEX idx_warranty_claim_date ON warranty(claim_date);
CREATE INDEX idx_products_launch ON products(launch_date);
