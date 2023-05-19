USE buybest;

/* 1. check for duplicates in the tables*/

/* accounts table */
SELECT 
    id,
    name,
    website,
    lat,
    lon,
    COUNT(*),
    primary_poc,
    COUNT(primary_poc),
    sales_rep_id,
    COUNT(sales_rep_id)
FROM
    accounts
GROUP BY 1 , 3 , 5 , 7 , 9 , 11 , 13
HAVING COUNT(*) > 1
ORDER BY id;

/* web_events table */
SELECT 
    id, account_id, occurred_at, channel, COUNT(*) dup_count
FROM
    web_events
GROUP BY 1 , 2 , 3 , 4
HAVING COUNT(*) > 1
ORDER BY 1;

/* there are no duplicate in the web_events table*/

/* region table */
SELECT 
    id, name, COUNT(*)
FROM
    region
GROUP BY 1 , 2
HAVING COUNT(*) > 1
ORDER BY 1;

/* there are no duplicate in the region table */

/* sales_reps */
SELECT 
    id, name, region_id, COUNT(*)
FROM
    sales_reps
GROUP BY 1 , 2 , 3
HAVING COUNT(*) > 1
ORDER BY 1;

/* there are no duplicate in the sales_rep table */

/* orders */
SELECT 
    id,
    account_id,
    occurred_at,
    standard_qty,
    gloss_qty,
    poster_qty,
    total,
    standard_amt_usd,
    gloss_amt_usd,
    poster_amt_usd,
    total_amt_usd,
    COUNT(*)
FROM
    orders
GROUP BY 1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 11
HAVING COUNT(*) > 1
ORDER BY id;

/* there are no duplicate in the sales_rep table */

/* 1.  Total number of orders */
SELECT 
    COUNT(*)
FROM
    orders;

/* 2. Total Revenue */
select sum(total_amt_usd) from orders;

/* 3. Total Sales by Region: Calculate the total sales for each region */
SELECT 
    r.name AS region_name, COUNT(o.id) total_sales
FROM
    accounts a
        JOIN
    orders o ON o.account_id = a.id
        JOIN
    sales_reps s ON a.sales_rep_id = s.id
        JOIN
    region r ON s.region_id = r.id
GROUP BY 1;

/* 4. Total sales by quarter */
SELECT 
    QUARTER(occurred_at) AS quarter, sum(total_amt_usd) total_sales
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

/* 5. Average Order Value: Determine the average order value */
SELECT 
    ROUND(AVG(total_amt_usd), 2) average_sale
FROM
    orders;

/* 6.  Top 5 Sales Representatives: Identify the top-performing sales representatives */
SELECT 
    s.id rep_id,
    s.name rep_name,
    r.name reg_name,
    SUM(o.total_amt_usd) total_rep_sales
FROM
    region r
        JOIN
    sales_reps s ON s.region_id = r.id
        JOIN
    accounts a ON a.sales_rep_id = s.id
        JOIN
    orders o ON o.account_id = a.id
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC
LIMIT 5;

/* 7. Number of orders each month */
SELECT 
    MONTHNAME(occurred_at) AS month, COUNT(*) number_of_orders
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

/* 8. Number of orders by quarter */
SELECT 
    QUARTER(occurred_at) AS quarter, COUNT(*) number_of_orders
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

/* 9. Average daily sales */
SELECT 
    DATE_FORMAT(occurred_at, '%Y-%m-%d') day_of_sales,
    AVG(total_amt_usd) total_sales
FROM
    orders
group by 1;

/* 10. Total monthly sales */
SELECT 
    DATE_FORMAT(occurred_at, '%Y-%m') month_of_sales,
    SUM(total_amt_usd) total_sales
FROM
    orders
GROUP BY 1;

/* 11. Total Yearly sales */
SELECT 
    DATE_FORMAT(occurred_at, '%Y') year_of_sales,
    SUM(total_amt_usd) total_sales
FROM
    orders
GROUP BY 1
ORDER BY 1;

/* 12. Minimum and  Maximum daily sales */
SELECT 
    MIN(total_sales) lowest_daily_sales, MAX(total_sales) highest_daily_sales
FROM
    (SELECT 
        DATE_FORMAT(occurred_at, '%Y-%m-%d') day_of_sales,
            (total_amt_usd) total_sales
    FROM
        orders) sub1;

/* 13. what is the first and last day sales*/
WITH sub AS (SELECT 
    DATE_FORMAT(occurred_at, '%Y-%m-%d') day_of_sales,
    (total_amt_usd) total_sales
FROM
    orders)
SELECT 
    MIN(day_of_sales) first_day, total_sales
FROM
    sub;
    
/* 14. which channel brought in the most account */
SELECT 
    channel, COUNT(DISTINCT (account_id)) AS number_of_accounts
FROM
    web_events
GROUP BY 1
ORDER BY 2 DESC;

/* 15. Total Revenue by Region: Calculate the total revenue for each region */
SELECT 
    r.name AS region_name, SUM(o.total_amt_usd) total_revenue
FROM
    accounts a
        JOIN
    orders o ON o.account_id = a.id
        JOIN
    sales_reps s ON a.sales_rep_id = s.id
        JOIN
    region r ON s.region_id = r.id
GROUP BY 1
ORDER BY 2 DESC;

/* 16. Total revenue by account */
SELECT 
    account_id, SUM(total_amt_usd) total_revenue
FROM
    orders
GROUP BY 1
ORDER BY 2 DESC;

/* 17. Top 5 companies by total sales amount*/
SELECT 
    a.name company, SUM(o.total_amt_usd) total_revenue
FROM
    accounts a
        JOIN
    orders o ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
