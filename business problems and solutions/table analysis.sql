-- Analysis of tables:

select distinct repair_status from warranty;
select count(*) from sales;

--QUERY PERFORMANCE IMPROVANCE: (BY CREATING INDEX)

--BEFORE INDEXING:

explain analyze
select * from sales
where product_id='P-44'
--OUTPUT BEFORE INDEXING: EXECUTION TIME : 266.3ms

--CREATING INDEX:
 
create index sales_product_id on sales(product_id);
explain analyze
select * from sales
where product_id='P-44'
--OUTPUT AFTER INDEXING: EXECUTION TIME : 2.73ms to 3.7ms

-- SIMILARLY CREATEING INDEX FOR STORE_ID AND SALE_DATE
create index sales_store_id on sales(store_id);
create index sales_sale_date on sales(sale_date);
create index idx_sales_store_product on sales(store_id, product_id);
create index idx_warranty_claim_date on warranty(claim_date);
create index idx_products_launch on products(launch_date);
create index idx_products_name on products(product_name);


 
