-- Exercise 1: Create a subtable of orders per day. Make sure you decide whether you are counting invoices or line items.

SELECT 
  date(paid_at) AS Day,
  COUNT(DISTINCT invoice_id) AS num_orders,
  COUNT(DISTINCT line_item_id) AS num_items
FROM 
  dsv1069.orders
GROUP BY
  date(paid_at)

/*
day	num_orders	num_items
2013-03-14 00:00:00	1	2
2013-03-27 00:00:00	1	1
2013-03-29 00:00:00	1	3
2013-04-07 00:00:00	1	3
2013-04-13 00:00:00	1	1
*/

--------------------------------------------------------------------

-- Exercise 2: “Check your joins”. We are still trying to count orders per day. 
-- In this step join the sub table from the previous exercise to the dates rollup table so we can get a row for every date. 
-- Check that the join works by just running a “select *” query.

SELECT *
FROM dsv1069.dates_rollup
LEFT OUTER JOIN 
(
    SELECT 
      date(paid_at) AS Day,
      COUNT(DISTINCT invoice_id) AS num_orders,
      COUNT(DISTINCT line_item_id) AS num_items
    FROM 
      dsv1069.orders
    GROUP BY
      date(paid_at)
) daily_orders
ON 
  daily_orders.day = dates_rollup.date
  
/*
date	d7_ago	d28_ago	day	num_orders	num_items
2018-06-01 00:00:00	2018-05-25 00:00:00	2018-05-04 00:00:00	2018-06-01 00:00:00	8	17
2018-05-31 00:00:00	2018-05-24 00:00:00	2018-05-03 00:00:00	2018-05-31 00:00:00	14	32
2018-05-30 00:00:00	2018-05-23 00:00:00	2018-05-02 00:00:00	2018-05-30 00:00:00	10	25
2018-05-29 00:00:00	2018-05-22 00:00:00	2018-05-01 00:00:00	2018-05-29 00:00:00	17	40
2018-05-28 00:00:00	2018-05-21 00:00:00	2018-04-30 00:00:00	2018-05-28 00:00:00	17	47
*/

--------------------------------------------------------------------

-- Exercise 3: “Clean up your Columns” In this step be sure to specify the columns you actually want to return, 
-- and if necessary do any aggregation needed to get a count of the orders made per day. 

SELECT
  dates_rollup.date,
  COALESCE(SUM(daily_orders.num_orders), 0) AS num_orders,
  COALESCE(SUM(daily_orders.num_items), 0) AS num_items_ordered
FROM dsv1069.dates_rollup
LEFT OUTER JOIN 
(
    SELECT 
      date(paid_at) AS Day,
      COUNT(DISTINCT invoice_id) AS num_orders,
      COUNT(DISTINCT line_item_id) AS num_items
    FROM 
      dsv1069.orders
    GROUP BY
      date(paid_at)
) daily_orders
ON 
  daily_orders.day = dates_rollup.date
GROUP BY
  dates_rollup.date
;

-- Example table when ORDER BY num_orders DESC
/*
date	      num_orders	num_items_ordered
2018-03-10 00:00:00	26	69
2017-03-28 00:00:00	26	67
2017-10-31 00:00:00	26	69
2018-01-16 00:00:00	26	72
2018-05-20 00:00:00	26	62
*/

--------------------------------------------------------------------

-- Exercise 4: Figure out which parts of the JOIN condition need to be edited create 7 day rolling orders table.

SELECT
  dates_rollup.date,
  COALESCE(SUM(daily_orders.num_orders), 0) AS num_orders,
  COALESCE(SUM(daily_orders.num_items), 0) AS num_items_ordered,
FROM dsv1069.dates_rollup
LEFT OUTER JOIN 
(
    SELECT 
      date(orders.paid_at) AS day,
      COUNT(DISTINCT invoice_id) AS num_orders,
      COUNT(DISTINCT line_item_id) AS num_items
    FROM 
      dsv1069.orders
    GROUP BY
      date(paid_at)
) daily_orders
ON 
  dates_rollup.date >= daily_orders.day
AND
  dates_rollup.d7_ago < daily_orders.day
GROUP BY
  dates_rollup.date
;

/*
date	num_orders	num_items_ordered
2014-11-01 00:00:00	57	138
2017-06-27 00:00:00	100	267
2018-02-07 00:00:00	112	275
2017-12-29 00:00:00	106	271
2017-07-14 00:00:00	96	232
*/

--------------------------------------------------------------------

-- Exercise 5: Column Cleanup. Finish creating the weekly rolling orders table, by performing any aggregation steps and naming your columns appropriately.

-- Need to make it clear with column names that the values displayed are rolling 7 day totals.

SELECT
  dates_rollup.date,
  COALESCE(SUM(daily_orders.num_orders), 0) AS roll_7_day_num_orders,
  COALESCE(SUM(daily_orders.num_items), 0) AS roll_7_day_num_items_ordered,
  COUNT(*) AS rows_included
FROM dsv1069.dates_rollup
LEFT OUTER JOIN 
(
    SELECT 
      date(orders.paid_at) AS day,
      COUNT(DISTINCT invoice_id) AS num_orders,
      COUNT(DISTINCT line_item_id) AS num_items
    FROM 
      dsv1069.orders
    GROUP BY
      date(paid_at)
) daily_orders
ON 
  dates_rollup.date >= daily_orders.day
AND
  dates_rollup.d7_ago < daily_orders.day
GROUP BY
  dates_rollup.date
ORDER BY
  dates_rollup.date
;

/*
date	roll_7_day_num_orders	roll_7_day_num_items_ordered	rows_included
2013-01-01 00:00:00	0	0	1
2013-01-02 00:00:00	0	0	1
2013-01-03 00:00:00	0	0	1
2013-01-04 00:00:00	0	0	1
2013-01-05 00:00:00	0	0	1
*/

