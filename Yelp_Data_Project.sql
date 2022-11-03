-- Data Scientist Role Play: Profiling and Analyzing the Yelp Dataset Coursera Worksheet

-- This is a 2-part assignment. In the first part, you are asked a series of questions that will help you profile and understand the data just like a data scientist would. For this first part of the assignment, you will be assessed both on the correctness of your findings, as well as the code you used to arrive at your answer. You will be graded on how easy your code is to read, so remember to use proper formatting and comments where necessary.

-- In the second part of the assignment, you are asked to come up with your own inferences and analysis of the data for a particular research question you want to answer. You will be required to prepare the dataset for the analysis you choose to do. As with the first part, you will be graded, in part, on how easy your code is to read, so use proper formatting and comments to illustrate and communicate your intent as required.

-- For both parts of this assignment, use this "worksheet." It provides all the questions you are being asked, and your job will be to transfer your answers and SQL coding where indicated into this worksheet so that your peers can review your work. You should be able to use any Text Editor (Windows Notepad, Apple TextEdit, Notepad ++, Sublime Text, etc.) to copy and paste your answers. If you are going to use Word or some other page layout application, just be careful to make sure your answers and code are lined appropriately.
-- In this case, you may want to save as a PDF to ensure your formatting remains intact for you reviewer.



-- Part 1: Yelp Dataset Profiling and Understanding

-- 1. Profile the data by finding the total number of records for each of the tables below:

SELECT COUNT(*)
FROM [table_name]
	
-- i. Attribute table = 10,000
-- ii. Business table = 10,000
-- iii. Category table = 10,000
-- iv. Checkin table = 10,000
-- v. elite_years table = 10,000
-- vi. friend table = 10,000
-- vii. hours table = 10,000
-- viii. photo table = 10,000
-- ix. review table = 10,000
-- x. tip table = 10,000
-- xi. user table = 10,000
	

-- 2. Find the total distinct records by either the foreign key or primary key for each table. If two foreign keys are listed in the table, please specify which foreign key.

-- i. Business: id = 10,000
-- ii. Hours: business_id = 1,562
-- iii. Category: business_id = 2,643
-- iv. Attribute: business_id = 1,115
-- v. Review: primary key: id = 10,000  |  foreign keys: business_id: 8,090,  user_id: 9,581
-- vi. Checkin: business_id = 493
-- vii. Photo: primary key: id = 10,000  |  foreign key: business_id = 6,493
-- viii. Tip: user_id = 537, business_id = 3,979
-- ix. User: primary key: id = 10,000
-- x. Friend: user_id = 11
--  xi. Elite_years: user_id = 2,780

-- Note: Primary Keys are denoted in the ER-Diagram with a yellow key icon.	



-- 3. Are there any columns with null values in the Users table? Indicate "yes," or "no."

	-- Answer: no

	-- SQL code used to arrive at answer:
SELECT COUNT(*)
FROM user
WHERE id IS NULL OR
      name IS NULL OR
      review_count IS NULL OR
      yelping_since IS NULL OR
      useful IS NULL OR
      funny IS NULL OR
      cool IS NULL OR
      fans IS NULL OR
      average_stars IS NULL OR
      compliment_hot IS NULL OR 
      compliment_more IS NULL OR 
      compliment_profile IS NULL OR 
      compliment_cute IS NULL OR 
      compliment_list IS NULL OR 
      compliment_note IS NULL OR 
      compliment_plain IS NULL OR 
      compliment_cool IS NULL OR 
      compliment_funny IS NULL OR 
      compliment_writer IS NULL OR 
      compliment_photos IS NULL;
      
 -- Result:
 /*
+----------+
| COUNT(*) |
+----------+
|        0 |
+----------+
*/

	
-- 4. For each table and column listed below, display the smallest (minimum), largest (maximum), and average (mean) value for the following fields:

	-- i. Table: Review, Column: Stars
	
		-- min:	1	  max: 5	  avg: 3.7082
		
	
	-- ii. Table: Business, Column: Stars
	
		-- min:	1	  max: 5  	  avg: 3.6549
		
	
	-- iii. Table: Tip, Column: Likes
	
		-- min:	0	  max: 2	   avg: .0144
		
	
	-- iv. Table: Checkin, Column: Count
	
		-- min:	1	  max: 53	   avg: 1.9414
		 
	
	-- v. Table: User, Column: Review_count
	
		-- min:	0	  max: 2,000	   avg: 24.2995
		
-- SQL code used to arrive at answer:
SELECT MIN(col_name),
       MAX(col_name),
       AVG(col_name)
FROM tbl_name;




-- 5. List the cities with the most reviews in descending order:

	-- SQL code used to arrive at answer:
SELECT city,
       SUM(review_count) AS total_review
FROM business
GROUP BY city
ORDER BY total_reviews DESC;
	
	-- Copy and Paste the Result Below:
/*
+-----------------+--------------+
| city            | total_review |
+-----------------+--------------+
| Las Vegas       |        82854 |
| Phoenix         |        34503 |
| Toronto         |        24113 |
| Scottsdale      |        20614 |
| Charlotte       |        12523 |
| Henderson       |        10871 |
| Tempe           |        10504 |
| Pittsburgh      |         9798 |
| Montréal        |         9448 |
| Chandler        |         8112 |
| Mesa            |         6875 |
| Gilbert         |         6380 |
| Cleveland       |         5593 |
| Madison         |         5265 |
| Glendale        |         4406 |
| Mississauga     |         3814 |
| Edinburgh       |         2792 |
| Peoria          |         2624 |
| North Las Vegas |         2438 |
| Markham         |         2352 |
| Champaign       |         2029 |
| Stuttgart       |         1849 |
| Surprise        |         1520 |
| Lakewood        |         1465 |
| Goodyear        |         1155 |
+-----------------+--------------+
*/

	
-- 6. Find the distribution of star ratings to the business in the following cities:

-- i. Avon

-- SQL code used to arrive at answer:
SELECT stars,
       SUM(review_count) as count
FROM business
WHERE city = 'Avon'
GROUP BY stars
ORDER BY stars ASC;

-- Copy and Paste the Resulting Table Below (2 columns â€“ star rating and count):

+-------+-------+
| stars | count |
+-------+-------+
|   1.5 |    10 |
|   2.5 |     6 |
|   3.5 |    88 |
|   4.0 |    21 |
|   4.5 |    31 |
|   5.0 |     3 |
+-------+-------+


-- ii. Beachwood

-- SQL code used to arrive at answer:
SELECT stars,
       SUM(review_count) as count
FROM business
WHERE city = 'Beachwood'
GROUP BY stars
ORDER BY stars ASC;

-- Copy and Paste the Resulting Table Below (2 columns â€“ star rating and count):
/*
+-------+-------+
| stars | count |
+-------+-------+
|   2.0 |     8 |
|   2.5 |     3 |
|   3.0 |    11 |
|   3.5 |     6 |
|   4.0 |    69 |
|   4.5 |    17 |
|   5.0 |    23 |
+-------+-------+		
*/

-- 7. Find the top 3 users based on their total number of reviews:
		
	-- SQL code used to arrive at answer:
SELECT id,
       name,
       review_count
FROM user
ORDER BY review_count DESC
LIMIT 3;
		
	-- Copy and Paste the Result Below:
/*
+------------------------+--------+--------------+
| id                     | name   | review_count |
+------------------------+--------+--------------+
| -G7Zkl1wIWBBmD0KRy_sCw | Gerald |         2000 |
| -3s52C4zL_DHRK0ULG6qtg | Sara   |         1629 |
| -8lbUNlXVSoXqaRRiHiSNg | Yuri   |         1339 |
+------------------------+--------+--------------+
*/

-- 8. Does posing more reviews correlate with more fans?

	-- Please explain your findings and interpretation of the results:
	-- There is a relationship between more reviews correlating to more fans. The strength is undetermined. There also seems to be a connection between years spent on the platform and the number of fans as some users with high years on platform but with significantly lower review counts have a large number of fans.
	
	-- SQL Code used to arrive at answer:

-- Finding people with most reviews.
SELECT  name,
	review_count,
	fans,
	Date('now') - yelping_since AS years_yelping
FROM user
GROUP BY name
ORDER BY review_count DESC
limit 10;

/*
+---------+--------------+------+---------------+
| name    | review_count | fans | years_yelping |
+---------+--------------+------+---------------+
| Gerald  |         2000 |  253 |            10 |
| .Hon    |         1246 |  101 |            16 |
| eric    |         1116 |   16 |            15 |
| Roanna  |         1039 |  104 |            16 |
| Dominic |          836 |   37 |            11 |
| Lissa   |          834 |  120 |            15 |
| Alison  |          775 |   61 |            15 |
| Sui     |          754 |   78 |            13 |
| Crissy  |          676 |   25 |            14 |
| Joc     |          652 |   49 |            17 |
+---------+--------------+------+---------------+
*/

-- Finding people with most fans. Comparing list of top users to list from top of previous query. Also using using the length of time as a yelp member to help gauge how long the user has been posting reviews to give more context.
SELECT  name,
	review_count,
	fans,
	Date('now') - yelping_since AS years_yelping
FROM user
GROUP BY name
ORDER BY fans DESC
limit 10;

/*
+-----------+--------------+------+---------------+
| name      | review_count | fans | years_yelping |
+-----------+--------------+------+---------------+
| Gerald    |         2000 |  253 |            10 |
| Lissa     |          834 |  120 |            15 |
| bernice   |          255 |  105 |            15 |
| Roanna    |         1039 |  104 |            16 |
| .Hon      |         1246 |  101 |            16 |
| Nieves    |          178 |   80 |             9 |
| Sui       |          754 |   78 |            13 |
| Koizumi   |          160 |   73 |            16 |
| rebecca   |            6 |   69 |            14 |
| Princeton |          376 |   64 |            13 |
+-----------+--------------+------+---------------+
*/
	
-- 9. Are there more reviews with the word "love" or with the word "hate" in them?

	-- Answer: Love: 1,780  |  Hate: 232.
	-- More reviews have "love".

	
	-- SQL code used to arrive at answer:
	
-- Code for "love"
SELECT COUNT(*) AS count_love
FROM review
WHERE text LIKE '%love%';

-- Code for "hate"
SELECT COUNT(*) AS count_hate
FROM review
WHERE text LIKE "%hate%"
	
	
-- 10. Find the top 10 users with the most fans:

	-- SQL code used to arrive at answer:
SELECT  id,
	name,
	fans
FROM user
ORDER BY fans DESC
LIMIT 10;
	
	-- Copy and Paste the Result Below:
/*
+------------------------+-----------+------+
| id                     | name      | fans |
+------------------------+-----------+------+
| -9I98YbNQnLdAmcYfb324Q | Amy       |  503 |
| -8EnCioUmDygAbsYZmTeRQ | Mimi      |  497 |
| --2vR0DIsmQ6WfcSzKWigw | Harald    |  311 |
| -G7Zkl1wIWBBmD0KRy_sCw | Gerald    |  253 |
| -0IiMAZI2SsQ7VmyzJjokQ | Christine |  173 |
| -g3XIcCb2b-BD0QBCcq2Sw | Lisa      |  159 |
| -9bbDysuiWeo2VShFJJtcw | Cat       |  133 |
| -FZBTkAZEXoP7CYvRV2ZwQ | William   |  126 |
| -9da1xk7zgnnfO1uTVYGkA | Fran      |  124 |
| -lh59ko3dxChBSZ9U7LfUw | Lissa     |  120 |
+------------------------+-----------+------+
*/
		

-- Part 2: Inferences and Analysis

-- 1. Pick one city and category of your choice and group the businesses in that city or category by their overall star rating. Compare the businesses with 2-3 stars to the businesses with 4-5 stars and answer the following questions. Include your code.

	-- First issue with this analysis is that there are many uncategorized businesses.
	-- City: Phoenix
	-- Category: Restaurants & Shopping

-- i. Do the two groups you chose to analyze have a different distribution of hours?
	-- While there are only 4 restaurants that are returned, the two with higher ratings have shorter hours. The two higher rated restaurants are typically open for 7 hours and 11 hours whereas the lower rated restaurants are typically open for 18 hours and 14 hours. The higher rated restaurants are also not open for breakfast hours nor are they open very late at night. One high rated restaurant does not list hours but is named "Matt's Big Breakfast" which is likely only open for morning hours based on the name - again another high rated restaurant that likely focuses on one type of food.

-- ii. Do the two groups you chose to analyze have a different number of reviews?
         -- The review amounts are mixed. The low rated restaurants have reviews counts of 8 and 60 whereas the high rated restaurants have review counts of 7, 188, and 431. The review count of 8 for the low rated restaurants is for McDonald's which is odd due to its notoriety and typical popularity despite bad reviews.
         
-- iii. Are you able to infer anything from the location data provided between these two groups? Explain.
	-- All restaurants have different postal codes and all neighborhood values are null. Nothing can be inferred from the postal codes or lack of neighborhoods. Addresses could be checked if all were looked up on a map to determine what areas / type of areas the restaurants are in.

-- SQL code used for analysis:

SELECT b.name,
    b.city,
    h.hours,
    b.review_count,
    b.stars,
    b.postal_code,
    c.category,
CASE
    WHEN b.stars BETWEEN 2.0 AND 3.0 THEN '2-3 Stars'
    WHEN b.stars BETWEEN 4.0 AND 5.0 THEN '4-5 Stars'
END AS review_star
FROM business as b
LEFT JOIN hours as h
ON b.id = h.business_id
LEFT JOIN category c
ON b.id = c.business_id
WHERE b.city = 'Phoenix'
AND c.category = 'Restaurants'
GROUP BY stars, review_star
ORDER BY review_star;
		
/*	
+----------------------------------------+---------+----------------------+--------------+-------+-------------+-------------+-------------+
| name                                   | city    | hours                | review_count | stars | postal_code | category    | review_star |
+----------------------------------------+---------+----------------------+--------------+-------+-------------+-------------+-------------+
| Five Guys                              | Phoenix | Saturday|10:00-22:00 |           63 |   3.5 | 85008       | Restaurants |        None |
| McDonald's                             | Phoenix | Saturday|5:00-0:00   |            8 |   2.0 | 85004       | Restaurants |   2-3 Stars |
| Gallagher's                            | Phoenix | Saturday|9:00-2:00   |           60 |   3.0 | 85024       | Restaurants |   2-3 Stars |
| Bootleggers Modern American Smokehouse | Phoenix | Saturday|11:00-22:00 |          431 |   4.0 | 85028       | Restaurants |   4-5 Stars |
| Charlie D's Catfish & Chicken          | Phoenix | Saturday|11:00-18:00 |            7 |   4.5 | 85034       | Restaurants |   4-5 Stars |
+----------------------------------------+---------+----------------------+--------------+-------+-------------+-------------+-------------+

Another table was used to analyze hours distribution where the table did not group all restaurant data together but showed each day along with the hours the restaurant was listed as open.
*/
		
-- 2. Group business based on the ones that are open and the ones that are closed. What differences can you find between the ones that are still open and the ones that are closed? List at least two differences and the SQL code you used to arrive at your answer.
		
-- i. Difference 1:
         -- The average number of reviews is somewhat significant in open (31) vs closed (23). This could be caused by many things. Would want to look into average duration of business being open as well. The longer a business is open, the more reviews it is likely to get. This could be a counfounding variable in the average number of reviews.
         
-- ii. Difference 2:
         -- Average starts between open and closed isn't significant. 3.52 for closed and 3.68 for open for a difference of 0.16. This does not seem to make a big difference.
         

-- SQL code used for analysis:
SELECT b.is_open,
    SUM(b.review_count)/COUNT(DISTINCT b.id) AS avg_num_reviews,
    AVG(b.stars) AS avg_stars,
    COUNT(DISTINCT b.id)
FROM business b
GROUP BY b.is_open

/*
+---------+-----------------+---------------+----------------------+
| is_open | avg_num_reviews |     avg_stars | COUNT(DISTINCT b.id) |
+---------+-----------------+---------------+----------------------+
|       0 |              23 | 3.52039473684 |                 1520 |
|       1 |              31 | 3.67900943396 |                 8480 |
+---------+-----------------+---------------+----------------------+
*/

	
-- 3. For this last part of your analysis, you are going to choose the type of analysis you want to conduct on the Yelp dataset and are going to prepare the data for analysis.

-- Ideas for analysis include: Parsing out keywords and business attributes for sentiment analysis, clustering businesses to find commonalities or anomalies between them, predicting the overall star rating for a business, predicting the number of fans a user will have, and so on. These are just a few examples to get you started, so feel free to be creative and come up with your own problem you want to solve. Provide answers, in-line, to all of the following:
	
-- i. Indicate the type of analysis you chose to do:
         
         
-- ii. Write 1-2 brief paragraphs on the type of data you will need for your analysis and why you chose that data:
                           
                  
-- iii. Output of your finished dataset:
         
         
-- iv. Provide the SQL code you used to create your final dataset:
