--BUSINESS PROBLEMS AND SOLUTIONS(FROM EASY TO COMPLEX):

--1. Find number of stores in each country???

select * from stores; -- country is in stores column(analyse the table)
-- group by country and then count number of stores in each group(country)

select country, count(store_id) as no_of_stores
from stores
group by country
order by no_of_stores desc

--2. What is the total number of units sold by each store????

select * from stores;
select * from sales;
-- number of quantities sold is in SALES table and store detials such as id and name are in STORE table
-- now join SALES and STORE table and group by store to find the sum of quantities sold in that store

select s.store_id, st.store_name, sum(s.quantity) as no_of_unit_sold
from sales s
join stores st on st.store_id = s.store_id  -- joining SALES and STORE table
group by s.store_id, st.store_id 
order by no_of_unit_sold desc 

--3. How many sales occurred in December 2023??

select * from sales;
--Use TO_CHAR function of convert the start date in MM-YYYY format(text datatype) and then fitler dec2023

select count(sale_id) as total_sales
from sales
where to_char(sale_date,'MM-YYYY') = '12-2023'

--4. How many stores have never had a warranty claim filed against any of their products???

select * from warranty;
select * from stores;
select * from sales;
-- use NOT IN to exclude the stores that had warranty claim filed against any of their products

select count(store_id) as no_of_stores
from stores
where store_id not in(
					    select distinct store_id 
						from sales s
						join warranty as w on s.sale_id = w.sale_id
					  );

--5. How many stores have Warranty Void???

select count (st.store_id) as store_count, w.repair_status
from warranty w
join sales s on s.sale_id = w.sale_id
join stores st on st.store_id = s.store_id
where w.repair_status = 'Warranty Void'
group by w.repair_status;

--6. What percentage of warranty claims are marked as "Warranty Void"?

select round (count(claim_id)/(select count(claim_id) from warranty):: numeric--typecasting
*100,3) as warranty_void_percentage
from warranty
where repair_status = 'Warranty Void'

--7. Which store had the highest total number of units sold in the last 2 year?

select s.store_id, st.store_name, sum(s.quantity) as total_sale  
from sales s join stores st on s.store_id = st.store_id
where s.sale_date >= (current_date - interval '2 year')
group by s.store_id, st.store_name
order by 3 desc
limit 1

--8. Count the number of unique products sold in the last year.

select count(distinct product_id) from sales s
where s.sale_date >=(current_date - interval '1 year')

--9. What are the unique products and their sales in the last year???

select p.product_name, count(p.product_name) as total_sale
from sales s join products p on s.product_id = p.product_id
where s.sale_date >=(current_date - interval '1 year')
group by p.product_name

--10. What is the average price of products in each category????

select * from category;
select * from products;

select c.category_name, 
round (avg(p.price)::numeric,1)as avg_sale_price
from products p join category c on p.category_id =c.category_id
group by c.category_name, c.category_id
order by avg_sale_price desc


--11. How many warranty claims were filed in 2020??

select* from warranty;
--Use TO_CHAR or EXTRACT functions

select count(claim_id) as no_of_warranty_claims_in_2020
from warranty
where to_char(claim_date,'YYYY')= '2020' --using TO_CHAR

--or

select count(claim_id) as no_of_warranty_claims_in_2020
from warranty
where extract(year from claim_date)= '2020' --using extract function


-- 12. Identify each store and best selling day based on highest quantity sold

-- use TO_CHAR to extract "day" from "sale_date"
-- then use window functio "RANK()" to rank
select store_id, day_name,total_sales
from
(select store_id, to_char(sale_date,'day') as day_name,sum(quantity) as total_sales,
rank() over(partition by store_id order by sum(quantity)desc)as rank
from sales
group by 1,2) as t1 
where rank=1
order by total_sales desc


--13. Identify least selling product of each country for each year based on total unit sold

with rank_of_product as
(
select st.country, p.product_name, sum(s.quantity) as total_quantity_sold, 
extract(year from s.sale_date) as year,
rank() over(partition by st.country, extract(year from s.sale_date) order by sum(s.quantity)) as rank
from sales s 
join stores st on s.store_id = st.store_id
join products p on s.product_id = p.product_id
group by st.country,p.product_name, year
)
select country, product_name, year ,total_quantity_sold 
from rank_of_product
where rank = 1
order by country, year;


--14. How many warranty claims were filed within 180 days of a product sale? and also the period..

-- to find the number of  warranty claims were filed within 180 days
select count (*)
from warranty w
left join sales s on s.sale_id=w.sale_id
where w.claim_date - s.sale_date <=180

-- to find the period within
select w.claim_date, s.sale_date,  p.product_name,(w.claim_date - s.sale_date) as period
from warranty w
left join sales s on s.sale_id=w.sale_id
join products p on s.product_id = p.product_id
where w.claim_date - s.sale_date <=180
order by period desc

--15. How many warranty claims have been filed for products launched in the last three years?

-- find no of products launched in last 2 years
--  and then number of claims for them
select p.product_name, count(w.claim_id) as no_of_warranty_claims, count(s.sale_id) as no_of_sale
from warranty w 
right join sales s on s.sale_id=w.sale_id -- to inculde all sales, even if no warranty claim exists.
join products p on p.product_id = s.product_id
where p.launch_date >=current_date - interval '3 years'
group by p.product_name
having count(w.claim_id)>1 --ignores products with zero claim

--16. List the months in the last 3 years where sales exceeded 5000 units in usa.

select to_char(s.sale_date,'MM-YYYY'),sum(s.quantity) as total_units_sold 
from sales s
join stores st on s.store_id = st.store_id
where st.country='USA' and  s.sale_date>= current_date - interval'3 years'
group by 1
having sum(s.quantity)>5000
order by total_units_sold

--17. Which product category had the most warranty claims filed in the last 2 years?

select c.category_name, count(w.claim_id) as total_warranty_claims
from warranty w
left join sales s on w.sale_id =s.sale_id
join products p on p.product_id = s.product_id
join category c on c.category_id = p.category_id
where w.claim_date >= current_date - interval'2 years'
group by 1 
order by total_warranty_claims desc
limit 1


--18. Determine the percentage chance of receiving claims after each purchase in each country.

select country, total_units_sold, total_no_of_claims,
case when total_no_of_claims =0 then 'No risk because no claims were filed'
else round(total_no_of_claims/total_units_sold::numeric *100,2):: text ||'%'  
end as risk_percentage
from
(
select st.country, sum(s.quantity)as total_units_sold,
count(w.claim_id) as total_no_of_claims
from sales s 
join stores st on s.store_id=st.store_id
left join warranty w on w.sale_id = s.sale_id
group by country
)t1
order by 4 DESC


--19. Analyze each stores year by year growth ratio

with yearly_sales as
(
select s.store_id, st.store_name, extract(year from s.sale_date) as year, 
sum(s.quantity *p.price) as total_sales 
from sales s 
join products p on s.product_id = p.product_id
join stores st on st.store_id = s.store_id
group by 1,2,3
order by 1,3
),
growth_ratio as
(
select store_name, year, 
lag(total_sales,1) over (partition by store_name order by year) as last_year_sale,
total_sales as current_year_sale
from yearly_sales
)
select store_name, year,
coalesce(last_year_sale::TEXT, 'N/A') as last_year_sale,
current_year_sale,
case when last_year_sale is null then 'not available, because last year data is not available'
else round(((current_year_sale- last_year_sale)::numeric/last_year_sale::numeric)* 100,2):: text ||'%'
end as growth_ratio_percentage
from growth_ratio

--20. What is the correlation between product price and 
--warranty claims for products sold in the last four years?

select
case when p.price <500 then 'less_expensive(below 500usd)'
when p.price between 500 and 1500 then 'expensive products(between 500 and 1500usd)'
else 'most expensive products(above 1500usd)' end as price_segments,
count(w.claim_id) as total_claim
from sales s 
right join warranty w on w.sale_id=s.sale_id
join products p on p.product_id=s.product_id
where claim_date >= current_date - interval '4 year'
group by 1
order by 2


--21. Identify the store with the highest percentage of "Paid Repaired" claims 
--in relation to total claims filed.

with paid_repair as
(
select st.store_name, count (w.claim_id) as total_paid_repaired
from warranty w 
left join sales s on w.sale_id=s.sale_id
join stores st on st.store_id = s.store_id
where w.repair_status = 'Paid Repaired'
group by 1
),
total_repair as
(
select st.store_name, count (w.claim_id) as total_claims
from warranty w 
left join sales s on w.sale_id=s.sale_id
join stores st on st.store_id = s.store_id
group by 1
)
select tr.store_name,pr.total_paid_repaired,tr.total_claims,
round(pr.total_paid_repaired/tr.total_claims::numeric * 100,2) :: text ||'%' as paid_repair_percent
from paid_repair pr
join total_repair tr on pr.store_name =tr.store_name

-- above query's execution time is 688ms 
-- to optimze the above query instead of two CTEs we can combine them into single one 
--for better performance...by this the tables warranty and sales are not scanned twice.


with repair_count as
(
select st.store_name, 
count (w.claim_id) filter(where w.repair_status = 'Paid Repaired') as total_paid_repaired,
count (w.claim_id) as total_claims
from warranty w 
left join sales s on w.sale_id=s.sale_id
join stores st on st.store_id = s.store_id
group by 1
)
select store_name,total_paid_repaired,total_claims,
round(total_paid_repaired/total_claims::numeric * 100,2) :: text ||'%' as paid_repair_percent
from repair_count
where  total_paid_repaired>0;
-- above optimized query's execution time is around 316ms (nearly 54% efficient and enhanced performance) 

--22.Write SQL query to calculate the monthly running total of sales for each store over the past
--4 years and compare the trends across this period?


with monthly_sale as
(
select store_id,
extract(year from sale_date) as year,
extract(month from sale_date) as month,
sum(p.price * s.quantity) as total_revenue
from sales s
join products p on s.product_id =p.product_id
where sale_date>= current_date - interval '4 year'
group by 1, 2,3
order by 1,2,3
)
select store_id, year,month, total_revenue,
sum(total_revenue) over(partition by store_id order by year, month 
rows between 5 preceding and current row) as running_6_month_total
from monthly_sale


--23.Analyze sales trends of product over time, segmented into key time periods: 
--from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months?

select p.product_name,
case when s.sale_date between p.launch_date and p.launch_date + interval '6 month' then '0-6 months'
when s.sale_date between p.launch_date + interval '6 month' and p.launch_date + interval '12 month' then '6-12 months'
when s.sale_date between p.launch_date + interval '12 month' and p.launch_date + interval '18 month' then '12-18 months'
else 'beyond 18 months' end as product_life_cycle,
sum(s.quantity) as total_units_sold
from sales s
join products p
on s.product_id = p.product_id
group by 1, 2
order by 3 desc









