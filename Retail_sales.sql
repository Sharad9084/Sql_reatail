


SELECT * FROM sql_project.retail_sales_tb;
--- count null values
select * from retail_sales_tb 
where transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null
;




--- remove null values


delete from retail_sales_tb
where transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null
;


--- Data Exploration

-- How Many Sales we have
select count(*) as total_sales from retail_sales_tb;

--- How Many unique customer we have

select count(distinct customer_id) as Unique_customer from retail_sales_tb;

-- Data Analysis & Business Key Problem Solutions

-- 1. All column from sales on date '2022-11-05'

select count(*) from retail_sales_tb where sale_date = '2022-11-05';

-- 2. category is "clothing" and quantity is more than 3 in the month of nov-2022

select * from retail_sales_tb where  category = "clothing" 
and 
quantiy > 3
and sale_date >= '2022-11-01'
;

-- 3 total sales for each category

select category,count(*),sum(total_sale) from retail_sales_tb group by 1;

-- 4 avg age of the customer to purchase "Beauty" from category

select avg(age) as avg_age from retail_sales_tb where category = "Beauty";

-- 5 all transaction where total sales more than 1000



select transactions_id,total_sale from retail_sales_tb where total_sale > 1000;



-- 6 find the total number of tranasaction made by each gender in each category

select category,gender,count(*) from retail_sales_tb group by category,gender order by category;



-- 7 calculate the avg sale of each month. find out the best selling month in each year 
select year,month,avg_sale from (
SELECT
    YEAR(sale_date) as year,
    MONTH(sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER (
        PARTITION BY YEAR(sale_date)
        ORDER BY AVG(total_sale) DESC
    ) AS rank_no
FROM retail_sales_tb
GROUP BY YEAR(sale_date), MONTH(sale_date)
) as t1 where rank_no = 1;


-- 8 find the top 5 customer based on the highest total sales

select customer_id,sum(total_sale) as sale from retail_sales_tb group by customer_id order by sale desc limit 5;

-- 9 find the number of unique customers who purchase items from each category
select category, count(distinct customer_id) as unique_customer from retail_sales_tb group by category;

-- 10 create each shift and number of orders (example morning < 12,afernoon between 12 & 17 , and evening > 17)
with hourly_sales
as (
select *,
case
	when hour(sale_time) < 12 then "Morning"
    when hour(sale_time) between 12 and 17 then "AfterNoon"
    else "Evenning"
    end as shift
from retail_sales_tb)
select count(*) as total_orders , shift from hourly_sales
group by shift


