-- Extra questions for possible analysis:
-- How many times does a user re-order a specific item?
-- How many times do users re-order an item from a specific category?
-- How long between orders / re-orders?

-- Exercise 0: Count how many users we have
SELECT
  COUNT(DISTINCT id) as num_users
FROM dsv1069.users
;

-- 117,178 unique users

-----------------------------------------------

-- Exercise 1: Find out how many users have ordered.
SELECT 
  COUNT(DISTINCT u.id) AS count_cust_order
FROM 
  dsv1069.users u
LEFT JOIN 
  dsv1069.orders o
ON 
  u.id = o.user_id 
WHERE
  o.paid_at IS NOT NULL 
;

-- 17,463 iunique users have ordered
-- To add context, there are 18,971 unique orders. Vast majority of users have only ordered once.
SELECT 
  COUNT(DISTINCT invoice_id)
FROM 
  dsv1069.orders
;

-----------------------------------------------

-- Exercise 2: Find out how many users have re-ordered the same item.








































