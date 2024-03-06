use walmart;
select * from walmart;

-- checking datatypes
show fields from walmart;

-- checking for null values
select * from walmart
where weekly_sales is null;

-- this query is just for disabling safe mode (equate to 0) in case we get Error Code: 1175, remember to enable (equate to 1) it after making changes
set sql_safe_updates=1;

-- changing data type of Date column 
update walmart
set Date=str_to_date(Date,"%d-%m-%Y");
alter table walmart
modify Date date;

-- Find week with maximum sales
select store, Date, Weekly_Sales from walmart 
order by Weekly_sales desc 
limit 5;

-- Find sales by year
select sum(Weekly_sales) as total_sales, extract(year from Date) as year
from walmart 
group by year;

-- which month had highest sales in 2011
select sum(Weekly_sales) as Total_sales, extract(month from Date) as month
from walmart
where extract(year from Date)=2011
group by month
order by Total_sales desc;

-- which stores had the most sales
select sum(Weekly_sales) as total_sales, store
from walmart
group by store
order by total_sales desc 
limit 3;

-- which stores had least sales
select sum(Weekly_sales) as total_sales, store
from walmart
group by store
order by total_sales asc 
limit 3;

-- which holidays have most sales
select Date, sum(Weekly_sales) as total_sales
from walmart
where holiday_flag=1
group by Date
order by total_sales desc;

-- Creating view to finding growth rate
create view growth as (select a.store,
    (a.sales_2012 - a.sales_2011) / a.sales_2011 AS growth_rate
   FROM (select walmart.store,
            sum(CASE
                    WHEN EXTRACT(year FROM walmart.Date) = 2011 THEN walmart.weekly_sales
                    ELSE 0
                    END) AS sales_2011,
            sum(
                CASE
                    WHEN EXTRACT(year FROM walmart.Date) = 2012 THEN walmart.weekly_sales
                    ELSE 0
                    END) AS sales_2012
           FROM walmart
          GROUP BY walmart.store) a);
          
-- Stores with the lowest sales growth
SELECT store, growth_rate*100 as growth_rate_from_2011_to_2012
FROM growth
ORDER BY growth_rate ASC
LIMIT 5;

-- stores with highest sales growth
SELECT store, growth_rate*100 as growth_rate_from_2011_to_2012
FROM growth
ORDER BY growth_rate DESC
LIMIT 5;
