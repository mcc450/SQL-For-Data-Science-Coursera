-- Exercise 1:
-- Goal: Using any methods you like determine if you can you trust this events table. 

-- Data table name "events_201701" is odd given the long number at the end. Possibly references a single event or time period.

-- Check columns:

-- event_id
-- event_time
-- user_id
-- event_name
-- platform
-- parameter_name
-- parameter_value


-- Check number of records:
SELECT COUNT(*) 
FROM dsv1069.events_201701;

-- Returns 7,301 records

---------------------------

-- GROUP BY Checks:

SELECT event_time,
      COUNT(*)
FROM dsv1069.events_201701
GROUP BY event_time;
-- 2 events per event_time

---------------------------

SELECT COUNT(*), platform
FROM dsv1069.events_201701
GROUP BY platform;

/*
count	platform
732	mobile web
2139	web
3112	server
650	Android
668	iOS
*/

---------------------------

SELECT event_name,
      COUNT(*)
FROM dsv1069.events_201701
GROUP BY event_name;

/*
event_name        count
test_assignment	  3112
view_user_profile	197
view_item	        3992
*/

---------------------------

SELECT platform,
      COUNT(*)
FROM dsv1069.events_201701
GROUP BY platform;

/*
platform	count
mobile web	732
web	2139
server	3112
Android	650
iOS	668
*/

---------------------------

-- Check for Nulls
SELECT COUNT(*)
FROM dsv1069.events_201701 
WHERE event_id IS NULL 
  OR event_time IS NULL 
  OR user_id IS NULL 
  OR event_name IS NULL 
  OR platform IS NULL 
  OR parameter_name IS NULL 
  OR parameter_value IS NULL;

/*
count
0
*/

-- It is evident by looking at the event_time data that the tag "201701" in the table name refers to January 2017. All of the data is reliable, but is only from a single month and would only be useful for a small analysis.
-- 

---------------------------------------------------------------------------------

-- Exercise 2:
-- Goal: Using any methods you like, determine if you can you trust this events table. (HINT: When did we start recording events on mobile) 

-- Check columns

-- event_id
-- event_time
-- user_id
-- event_name
-- platform
-- parameter_name
-- parameter_value

-- Check platform counts

SELECT platform, COUNT(*)
FROM dsv1069.events_ex2
GROUP BY platform;

/*
platform	count
Android	6824
iOS	4762
mobile web	17276
server	141382
web	51184
*/

-- Number of events for each platform looks normal.

---------------------------

-- Check first and latest date recorded for each platform.

SELECT platform,
      MIN(event_time) AS first_time,
      MAX(event_time) AS last_time
FROM dsv1069.events_ex2
GROUP BY platform
ORDER BY first_time ASC;

/*
platform	  | first_time	        | last_time
server     	| 2012-11-23 00:07:10	| 2016-12-31 23:59:06
web	        | 2012-12-12 01:18:09	| 2016-12-31 23:35:45
mobile web	| 2013-01-13 21:10:30	| 2016-12-31 21:57:02
Android   	| 2016-01-01 05:48:56	| 2016-12-31 23:15:03
iOS	        | 2016-05-01 00:42:29	| 2016-12-31 23:02:56
*/

-- Large difference between iOS & Android, 3+ years for first records. Latest records are all similar.

-- Calculating the length of time each platform has had data collected.
SELECT platform,
      MAX(event_time) - MIN(event_time) AS length_of_data
FROM dsv1069.events_ex2
GROUP BY platform
ORDER BY length_of_data ASC;

/*
platform	  | length_of_data
iOS	        | 244 days 22:20:27
Android    	| 365 days 17:26:07
mobile web	| 1448 days 00:46:32
web	        | 1480 days 22:17:36
server	    | 1499 days 23:51:56
*/

-- Mobile web, web, server all have about 4x the amount of time to collect data. Would not be reliable to compare iOS or Android to the other types with this data.

---------------------------------------------------------------------------------

-- Exercise 3:
-- Goal: Imagine that you need to count item views by day. You found this table item_views_by_category_temp - should you use it to answer your questiuon? 

-- This type of table should not be used in an analysis because it is clearly labeled as temporary. Likely uesd for another person's analysis and for a specific purpose.
-- The number of events could be calculated, but we cannot get the different days from this table directly. We would need to reference the original table that contains date information.

SELECT *
FROM dsv1069.item_views_by_category_temp;

/*
category	users	view_events
apparatus	708	1725
contraption	668	1538
device	634	1551
gadget	650	1541
instrument	730	1700
mechanism	670	1588
module	682	1600
tool	682	1637
widget	682	1601
*/

---------------------------------------------------------------------------------

-- Exercise 4:
-- Goal: Using any methods you like, decide if this table is ready to be used as a source of truth. 

-- This table is not in the database
SELECT *
FROM dsv1069.raw_events;

-- ERROR: relation "dsv1069.raw_events" does not exist

---------------------------------------------------------------------------------

-- Exercise 5:
-- Goal: Is this the right way to join orders to users?

-- No, COALESCE should be used to avoid NULLs being matched with other NULLs. We only want rows with values, COALESCE will pull the first non-null value and avoid this.

-- Determine the column they are being joined on, use COALESCE to avoid NULLs.

SELECT *
FROM dsv1069.orders;
-- user_id

SELECT COUNT(*)
FROM dsv1069.orders;

-- count
-- 47402
-------------------------

SELECT *
FROM dsv1069.users;
-- parent_user_id

-- NULL parent_user_id Count
SELECT COUNT(*)
FROM dsv1069.users
WHERE parent_user_id IS NULL;

-- count
-- 110770


-- This will avoid NULLs for id values where the tables are joined. Information needed can be included in the SELECT

SELECT COALESCE(parent_user_id, user_id) AS original_user_id,
      parent_user_id,
      user_id,
      first_name,
      last_name
FROM dsv1069.orders
JOIN dsv1069.users
ON orders.user_id = users.parent_user_id;

