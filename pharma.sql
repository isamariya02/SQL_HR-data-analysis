create database pharma;
use pharma;

ALTER TABLE pharma
CHANGE `Customer Name` customer_name VARCHAR(100);
ALTER TABLE pharma
CHANGE `Product Name` product_name VARCHAR(50);
ALTER TABLE pharma
CHANGE `Product Class` product_class VARCHAR(50);
ALTER TABLE pharma
CHANGE `Name of Sales Rep` name_of_sales_rep VARCHAR(100);
ALTER TABLE pharma
CHANGE `Sales Team` sales_team VARCHAR(24);

-- 1. Retrieve all columns for all records in the dataset.

select * from pharma;

-- 2. How many unique countries are represented in the dataset?

select distinct country from pharma;

-- 3. Select the names of all the customers on the 'Retail' channel.

select distinct customer_name from pharma;

-- 4. Find the total quantity sold for the ' Antibiotics' product class.

select sum(Quantity) from pharma where product_class='Antibiotics';

-- 5. List all the distinct months present in the dataset.

select distinct Month from pharma;

-- 6. Calculate the total sales for each year.

select Year,sum(Sales) as totalsales from pharma group by Year;


-- 7. Find the customer with the highest sales value.

select customer_name,max(Sales) from pharma group by customer_name limit 1;

-- 8. Get the names of all employees who are Sales Reps and are managed by 'James Goodwill'.

select name_of_sales_rep,Manager from pharma where Manager='James Goodwill';

-- 10. Calculate the average price of products in each sub-channel.

select avg(Price),Channel from pharma group by Channel;

-- 13. Calculate the total sales for each product class, for each month, and order the results by
-- year, month, and product class.

SELECT SUM(Sales) AS total_sales, product_class, year, Month
FROM pharma
GROUP BY product_class, year, Month
ORDER BY year, Month, product_class;


-- 14. Find the top 3 sales reps with the highest sales in 2019.

select name_of_sales_rep,sales from pharma order by sales desc limit 3;


-- 15. Calculate the monthly total sales for each sub-channel, and then calculate the average
-- monthly sales for each sub-channel over the years.

alter table pharma change `Sub-Channel` sub_channel varchar(24);
select sum(Sales),Month,sub_channel from pharma group by Month,sub_channel;

SELECT sub_channel,year,Month,AVG(monthly_total_sales) AS average_monthly_sales
FROM (
SELECT sub_channel,year,Month,SUM(Sales) AS monthly_total_sales
    FROM
        pharma
    GROUP BY
        sub_channel, year, Month
) AS monthly_totals
GROUP BY sub_channel, year, Month
ORDER BY sub_channel, year, Month;



-- 16. Create a summary report that includes the total sales, average price, and total quantity
-- sold for each product class.

select product_class,sum(Sales),avg(Price),sum(Quantity) from pharma group by product_class;


-- 17. Find the top 5 customers with the highest sales for each year.

SELECT customer_name, MAX(Sales) AS max_sales,Year
FROM pharma GROUP BY customer_name,Year LIMIT 5;

SELECT customer_name, total_sales, Year
FROM (
    SELECT
        customer_name,
        SUM(Sales) AS total_sales,
        Year,
        RANK() OVER (PARTITION BY Year ORDER BY SUM(Sales) DESC) AS sales_rank
    FROM pharma
    GROUP BY customer_name, Year
) ranked_data
WHERE sales_rank <= 5;

-- SUM(Sales) AS total_sales: Calculates the total sales for each customer within each year.
-- RANK() OVER (PARTITION BY Year ORDER BY SUM(Sales) DESC) AS sales_rank: Uses the RANK() window function to
-- assign a rank to each customer based on their total sales within each year.
-- The PARTITION BY Year clause ensures that the ranking is reset for each year, and ORDER BY SUM(Sales) 
-- DESC orders the customers in descending order of sales.


-- 18. Calculate the year-over-year growth in sales for each country.
-- 2 of 2

SELECT
    country,
    Year,
    SUM(Sales) AS total_sales,
    LAG(SUM(Sales)) OVER (PARTITION BY country ORDER BY Year) AS previous_year_sales,
    CASE
        WHEN LAG(SUM(Sales)) OVER (PARTITION BY country ORDER BY Year) IS NOT NULL
        THEN ((SUM(Sales) - LAG(SUM(Sales)) OVER (PARTITION BY country ORDER BY Year)) / LAG(SUM(Sales)) OVER (PARTITION BY country ORDER BY Year)) * 100
        ELSE NULL
    END AS yoy_growth
FROM
    pharma
GROUP BY
    country, Year
ORDER BY
    country, Year;


-- 19. List the months with the lowest sales for each year

SELECT Month, MIN(Sales) AS min_sales, Year
FROM pharma
GROUP BY Month, Year limit 2;



-- 20. Calculate the total sales for each sub-channel in each country, and then find the country
-- with the highest total sales for each sub-channel

WITH SubChannelSales AS (
    SELECT
        country,
        sub_channel,
        SUM(Sales) AS total_sales,
        RANK() OVER (PARTITION BY sub_channel ORDER BY SUM(Sales) DESC) AS sales_rank
    FROM
        pharma
    GROUP BY
        country, sub_channel
)

SELECT
    country,
    sub_channel,
    total_sales
FROM
    SubChannelSales
WHERE
    sales_rank = 1;
