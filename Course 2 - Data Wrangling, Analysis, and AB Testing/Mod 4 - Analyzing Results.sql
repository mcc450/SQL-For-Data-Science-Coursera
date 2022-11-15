-- Exercise 1: Use the order_binary metric from the previous exercise, count the number of users per treatment group for test_id = 7, 
-- and count the number of users with orders (for test_id 7)

-- Use order_binary metric
-- For proportion metric order binary compute....
------ The count of users per treatment group for test_id = 7
------ The count of users with orders per treatment group

SELECT 
  test_assignment,
  COUNT(user_id) AS users,
  SUM(order_binary) AS users_with_orders
FROM 
  (
    SELECT 
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment,
      MAX(CASE WHEN orders.created_at > assignments.event_time THEN 1 ELSE 0 END) 
        AS order_binary
    FROM
        (
        SELECT 
          event_id,
          event_time,
          user_id,
          MAX(
              CASE WHEN parameter_name = 'test_id'
              THEN CAST(parameter_value AS INT)
              ELSE NULL 
              END
              ) AS test_id,
          MAX(
              CASE WHEN parameter_name = 'test_assignment'
              THEN parameter_value
              ELSE NULL 
              END 
              ) AS test_assignment
        FROM 
          dsv1069.events 
        WHERE 
          event_name = 'test_assignment'
        GROUP BY 
          event_id,
          event_time,
          user_id  
        ) assignments
    LEFT OUTER JOIN 
      dsv1069.orders 
    ON 
      assignments.user_id = orders.user_id
    GROUP BY
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment
  ) user_level
WHERE
  test_id = 7
GROUP BY
  test_assignment
  ;

/*
test_assignment	users	users_with_orders
0	| 19376	| 2521
1	| 19271	| 2633
*/
-- 95% interval - p-value = .059
-- Improvement -0.2% -> 10%

---------------------------------------------------------------------------------------

-- Exercise 2: Create a new tem view binary metric. 
-- Count the number of users per treatment group, and count the number of users with views (for test_id 7).

-- Metric for 'view_item' events.
SELECT 
  test_assignment,
  COUNT(user_id) AS users,
  SUM(views_binary) AS views_binary
FROM 
  (
    SELECT 
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment,
      MAX(CASE WHEN views.event_time > assignments.event_time THEN 1 ELSE 0 END) 
        AS views_binary
    FROM
        (
        SELECT 
          event_id,
          event_time,
          user_id,
          MAX(
              CASE WHEN parameter_name = 'test_id'
              THEN CAST(parameter_value AS INT)
              ELSE NULL 
              END
              ) AS test_id,
          MAX(
              CASE WHEN parameter_name = 'test_assignment'
              THEN parameter_value
              ELSE NULL 
              END 
              ) AS test_assignment
        FROM 
          dsv1069.events 
        WHERE 
          event_name = 'test_assignment'
        GROUP BY 
          event_id,
          event_time,
          user_id  
        ) assignments
    LEFT OUTER JOIN 
      (
        SELECT 
          *
        FROM 
          dsv1069.events
        WHERE
          event_name = 'view_item'
      ) views
    ON 
      assignments.user_id = views.user_id
    GROUP BY
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment
  ) user_level
WHERE
  test_id = 7
GROUP BY
  test_assignment
;

/*
test_assignment	users	views_binary
0	19376	10290
1	19271	10271
*/

----------------------------------------------------------

-- Exercise 3: Alter the result from EX 2, to compute the users who viewed an item WITHIN 30 days of their treatment event.

SELECT 
  test_assignment,
  COUNT(user_id) AS users,
  SUM(views_binary) AS views_binary,
  SUM(views_binary_30d) AS views_binary_30d
FROM 
  (
    SELECT 
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment,
      MAX(CASE WHEN views.event_time > assignments.event_time THEN 1 ELSE 0 END) 
        AS views_binary,
      MAX(CASE WHEN (views.event_time > assignments.event_time AND 
                    DATE_PART('day', views.event_time - assignments.event_time) <= 30)
              THEN 1 ELSE 0 END) AS views_binary_30d
    FROM
        (
        SELECT 
          event_id,
          event_time,
          user_id,
          MAX(
              CASE WHEN parameter_name = 'test_id'
              THEN CAST(parameter_value AS INT)
              ELSE NULL 
              END
              ) AS test_id,
          MAX(
              CASE WHEN parameter_name = 'test_assignment'
              THEN parameter_value
              ELSE NULL 
              END 
              ) AS test_assignment
        FROM 
          dsv1069.events 
        WHERE 
          event_name = 'test_assignment'
        GROUP BY 
          event_id,
          event_time,
          user_id  
        ) assignments
    LEFT OUTER JOIN 
      (
        SELECT 
          *
        FROM 
          dsv1069.events
        WHERE
          event_name = 'view_item'
      ) views
    ON 
      assignments.user_id = views.user_id
    GROUP BY
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment
  ) user_level
WHERE
  test_id = 7
GROUP BY
  test_assignment
;

/*
test_assignment	users	views_binary	views_binary_30d
0	19376	10290	245
1	19271	10271	237
*/

----------------------------------------------------------------------------

-- Exercise 4: Create the metric invoices (this is a mean metric, not a binary metric) and for test_id = 7.
-- The count of users per treatment group.
-- The average value of the metric per treatment group.
-- The standard deviation of the metric per treatment group.

SELECT 
  test_id,
  test_assignment,
  COUNT(user_id) AS users,
  AVG(invoices) AS avg_invoices,
  STDDEV(invoices) AS stddev_invoices
FROM
    (
    SELECT 
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment,
      COUNT(DISTINCT (CASE WHEN orders.created_at > assignments.event_time THEN invoice_id ELSE NULL END)) 
        AS invoices,
      COUNT(DISTINCT (CASE WHEN orders.created_at > assignments.event_time THEN line_item_id ELSE NULL END)) 
        AS line_items,
      COALESCE(SUM(CASE WHEN orders.created_at > assignments.event_time THEN price ELSE 0 END))
        AS total_revenue
    FROM
        (
        SELECT 
          event_id,
          event_time,
          user_id,
          MAX(
              CASE WHEN parameter_name = 'test_id'
              THEN CAST(parameter_value AS INT)
              ELSE NULL 
              END
              ) AS test_id,
          MAX(
              CASE WHEN parameter_name = 'test_assignment'
              THEN parameter_value
              ELSE NULL 
              END 
              ) AS test_assignment
        FROM 
          dsv1069.events 
        WHERE 
          event_name = 'test_assignment'
        GROUP BY 
          event_id,
          event_time,
          user_id
        ) assignments
    LEFT OUTER JOIN 
      dsv1069.orders 
    ON 
      assignments.user_id = orders.user_id
    GROUP BY
      assignments.user_id,
      assignments.test_id,
      assignments.test_assignment
    ) mean_metrics
GROUP BY 
  test_id,
  test_assignment
ORDER BY
  test_id
;

/*
test_id	test_assignment	users	avg_invoices	stddev_invoices
4	0	7210	0.16130374479889042	0.4068704838430513
4	1	4680	0.1561965811965812	0.3984422271909843
5	0	34420	0.15697269029633934	0.3981740389311411
5	1	34143	0.16058928623729607	0.3997718047303091
6	0	21687	0.15866648222437404	0.4009941437976927
6	1	21703	0.1612219508823665	0.4066585004865856
7	0	19376	0.14151527663088356	0.38177616218377725
7	1	19271	0.14872087592755953	0.3900531525787444
*/

