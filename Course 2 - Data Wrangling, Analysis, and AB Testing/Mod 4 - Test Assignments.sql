-- Exercise 1: Figure out how many tests we have running right now

SELECT 
  DISTINCT parameter_value AS tests
FROM 
  dsv1069.events 
WHERE
  event_name = 'test_assignment'
AND
  parameter_name = 'test_id'
;

/*
tests
4
5
6
7
*/

-------------------------------------------------------------------

-- Exercise 2: Check for potential problems with test assignments. 
-- For example Make sure there is no data obviously missing (This is an open ended question)

SELECT 
  COUNT(*)
FROM 
  dsv1069.events
WHERE
  event_name IS NULL
;

-- Went through columns to check for nulls. Also checked to make sure dates are recorded normally.

SELECT 
  parameter_value,
  COUNT(DISTINCT event_id) AS num_in_test
FROM 
  dsv1069.events 
WHERE
  event_name = 'test_assignment'
AND
  parameter_name = 'test_id'
GROUP BY
  parameter_value
;

SELECT 
  parameter_value AS test_id,
  DATE(event_time) AS day,
  COUNT(*) AS event_rows
FROM 
  dsv1069.events 
WHERE
  event_name = 'test_assignment'
AND
  parameter_name = 'test_id'
GROUP BY
  parameter_value,
  DATE(event_time)

-------------------------------------------------------------------

-- Exercise 3:  Write a query that returns a table of assignment events.
-- Please include all of the relevant parameters as columns (Hint: A previous exercise as a template)

SELECT 
  event_id,
  event_time,
  user_id,
  platform,
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
  user_id,
  platform
ORDER BY
  event_id
;

/*
event_id	event_time	user_id	platform	test_id	test_assignment
00003d71b9cb41469c05af608a6d2145	2014-04-28 15:23:00	147689	server	5	1
00012e89e2f54bf99180dde02c63e4ad	2016-11-06 15:23:09	225112	server	7	1
00012e8f6da84f33ab9ff53901f5a2f3	2014-04-10 15:23:05	130289	server	6	1
00018d8326b64ce7b016b90282b0d81e	2014-05-13 15:23:05	86365	server	6	0
0001abcf9b824630856a246877a6ef4b	2013-10-19 15:23:00	51995	server	5	1
*/

-------------------------------------------------------------------

-- Exercise 4:  Check for potential assignment problems with test_id 5. 
-- Specifically, make sure users are assigned only one treatment group.

SELECT 
test_id,
  user_id,
  COUNT(DISTINCT test_assignment) AS assignments
FROM
  (  
    SELECT 
      event_id,
      event_time,
      user_id,
      platform,
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
      user_id,
      platform
    ORDER BY
      event_id
  ) test_events
GROUP BY
  test_id,
  user_id
ORDER BY
  assignments DESC
;

/*
test_id	user_id	assignments
4	1650	1
4	1747	1
4	1764	1
4	1829	1
4	1588	1
*/

