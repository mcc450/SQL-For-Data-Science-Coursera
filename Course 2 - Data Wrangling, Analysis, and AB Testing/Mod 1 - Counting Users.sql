-- Exercise 1:  We’ll be using the users table to answer the question “How many new users are added each day?“. 
-- Start by making sure you understand the columns in the table. 

SELECT *
FROM dsv1069.users;

-- Columns
-- created_at (timestamp)
-- deleted_at (timestamp)
-- email_address (string)
-- first_name (string)
-- id (float)
-- last_name (string)
-- merged_at (timestamp)
-- parent_user_id (float)

-------------------------------------------------------------------------------

-- Exercise 2: Without worrying about deleted user or merged users, count the number of users added each day.

SELECT 
  date(created_at),
  COUNT(DISTINCT created_at) AS created_users
FROM 
  dsv1069.users
GROUP BY
  date(created_at)
ORDER BY
  date(created_at) ASC;

/*
Example result, there are many days with more than 1 created user.

date	created_users
2013-02-18 00:00:00	1
2013-02-20 00:00:00	1
2013-02-21 00:00:00	1
2013-02-22 00:00:00	1
2013-02-23 00:00:00	1
*/

-------------------------------------------------------------------------------

-- Exercise 3: Consider the following query. Is this the right way to count merged or deleted users? 
-- If all of our users were deleted tomorrow what would the result look like?
Starter Code: 
SELECT  
  date(created_at) AS day,  
  COUNT(*) AS new_users_added
FROM  
  dsv1069.users 
WHERE 
  deleted_at IS NULL 
AND 
  (id <> parent_user_id OR parent_user_id IS NULL)  
GROUP BY 
  date(created_at);

-- This code does not specify when users are deleted. If users are deleted, the number of created accounts would decrease because those now deleted accounts would not show up in this query. This only counts created and still active and non-merged users.

-------------------------------------------------------------------------------

-- Exercise 4: Count the number of users deleted each day. Then count the number of users removed due to merging in a similar way.

SELECT 
  date(deleted_at) AS day,  
  COUNT(*) AS deleted_users
FROM  
  dsv1069.users
WHERE 
  deleted_at IS NOT NULL 
GROUP BY
  date(deleted_at);

/*
Example Output
day	deleted_users
2016-08-06 00:00:00	5
2016-09-27 00:00:00	1
2017-09-25 00:00:00	3
2014-11-17 00:00:00	2
2017-07-06 00:00:00	2
*/

SELECT 
      date(merged_at) AS day,  
      COUNT(*) AS merged_users
    FROM  
      dsv1069.users
    WHERE 
      id <> parent_user_id
    AND 
      parent_user_id IS NOT NULL
    GROUP BY
      date(merged_at)
  
/*
day	merged_users
2016-08-06 00:00:00	2
2016-09-27 00:00:00	6
2017-09-25 00:00:00	2
2017-07-06 00:00:00	6
2016-01-13 00:00:00	2
*/

-------------------------------------------------------------------------------

SELECT 
  new.day,
  new.new_users_added,
  deleted.deleted_users,
  merged.merged_users
FROM 
    (SELECT  
       date(created_at) AS day,  
        COUNT(*) AS new_users_added
    FROM  
       dsv1069.users 
    WHERE 
       deleted_at IS NULL 
    AND 
       (id <> parent_user_id OR parent_user_id IS NULL)  
    GROUP BY 
       date(created_at)
    ) new
LEFT JOIN
    (SELECT 
       date(deleted_at) AS day,  
       COUNT(*) AS deleted_users
    FROM  
       dsv1069.users
    WHERE 
        deleted_at IS NOT NULL 
    GROUP BY
        date(deleted_at)
    ) deleted
ON deleted.day = new.day 
LEFT JOIN 
    (SELECT 
      date(merged_at) AS day,  
      COUNT(*) AS merged_users
    FROM  
      dsv1069.users
    WHERE 
      id <> parent_user_id
    AND 
      parent_user_id IS NOT NULL
    GROUP BY
      date(merged_at)
      ) merged 
ON merged.day = new.day
;

/* 
Other row values have deleted_users and merged_users counts. Zero shows as NULL currently.
day	new_users_added	deleted_users	merged_users
2013-02-18 00:00:00	1		
2013-02-20 00:00:00	1		
2013-02-21 00:00:00	1		
2013-02-22 00:00:00	1		
2013-02-23 00:00:00	1		
*/

-------------------------------------------------------------------------------

-- Exercise 6: Refine your query from #5 to have informative column names and so that null columns return 0.

-- Can use COALESCE to return 0 if there is NULL value for deleted or merged. Calculating net added users and using COALESCE in the calculation so a zero is placed when there is a NULL value.

SELECT 
  new.day,
  new.new_users_added,
  COALESCE(deleted.deleted_users, 0) AS deleted_users,
  COALESCE(merged.merged_users, 0) AS merged_users,
  (new.new_users_added - COALESCE(deleted.deleted_users, 0) - COALESCE(merged.merged_users, 0)) AS net_added_users
FROM 
    (SELECT  
       date(created_at) AS day,  
        COUNT(*) AS new_users_added
    FROM  
       dsv1069.users 
    WHERE 
       deleted_at IS NULL 
    AND 
       (id <> parent_user_id OR parent_user_id IS NULL)  
    GROUP BY 
       date(created_at)
    ) new
LEFT JOIN
    (SELECT 
       date(deleted_at) AS day,  
       COUNT(*) AS deleted_users
    FROM  
       dsv1069.users
    WHERE 
        deleted_at IS NOT NULL 
    GROUP BY
        date(deleted_at)
    ) deleted
ON deleted.day = new.day 
LEFT JOIN 
    (SELECT 
      date(merged_at) AS day,  
      COUNT(*) AS merged_users
    FROM  
      dsv1069.users
    WHERE 
      id <> parent_user_id
    AND 
      parent_user_id IS NOT NULL
    GROUP BY
      date(merged_at)
      ) merged 
ON merged.day = new.day
;

/*
day	new_users_added	deleted_users	merged_users	net_added_users
2013-02-18 00:00:00	1	0	0	1
2013-02-20 00:00:00	1	0	0	1
2013-02-21 00:00:00	1	0	0	1
2013-02-22 00:00:00	1	0	0	1
2013-02-23 00:00:00	1	0	0	1
*/

-- While working through this exercise questions arose -- What if there is a day when no new users were created? Deleted or Merged would still be recorded? The table we are using is only using rows where there is a new user being created. How to modify query to pull all actions even when net users might be negative for a given day?
-- Will cover in next question (convenient).

-------------------------------------------------------------------------------

-- Exercise 7: What if there were days where no users were created, but some users were deleted or merged. 
-- Does the previous query still work? No, it doesn’t. 
-- Use the dates_rollup as a backbone for this query, so that we won’t miss any dates.

-- To get desired effect, all tables are joined onto the 'dates_rollup' table. This table contains every day from the start of data collection to the end.
-- Tables were joined and days were missing so there were entire days missing where there were no new users.
-- Code below uses COALESCE to fill in 0 when there were no new users.
-- After investigating, there are no days with negative net users - created charts with Mode's build in charting function. Could use Excel or Viz tool as well.
-- Created new user AND net users all show upward trends over course of data collected.

SELECT 
  dates_rollup.date,
  COALESCE(new.new_users_added, 0) AS new_users,
  COALESCE(deleted.deleted_users, 0) AS deleted_users,
  COALESCE(merged.merged_users, 0) AS merged_users,
  (COALESCE(new.new_users_added, 0) - COALESCE(deleted.deleted_users, 0) - COALESCE(merged.merged_users, 0)) AS net_added_users
FROM 
  dsv1069.dates_rollup
LEFT JOIN  
    (SELECT  
       date(created_at) AS day,  
        COUNT(*) AS new_users_added
    FROM  
       dsv1069.users 
    WHERE 
       deleted_at IS NULL 
    AND 
       (id <> parent_user_id OR parent_user_id IS NULL)  
    GROUP BY 
       date(created_at)
    ) new
ON dates_rollup.date = new.day
LEFT JOIN
    (SELECT 
       date(deleted_at) AS day,  
       COUNT(*) AS deleted_users
    FROM  
       dsv1069.users
    WHERE 
        deleted_at IS NOT NULL 
    GROUP BY
        date(deleted_at)
    ) deleted
ON dates_rollup.date = deleted.day 
LEFT JOIN 
    (SELECT 
      date(merged_at) AS day,  
      COUNT(*) AS merged_users
    FROM  
      dsv1069.users
    WHERE 
      id <> parent_user_id
    AND 
      parent_user_id IS NOT NULL
    GROUP BY
      date(merged_at)
      ) merged 
ON dates_rollup.date = merged.day
ORDER BY dates_rollup.date ASC
;


