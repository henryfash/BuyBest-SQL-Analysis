USE buybest;

/* check for duplicates in the tables*/
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

/* there is one duplicate in the web_events table*/

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