-- Question 1: Run Query: Find all the tracks that have a length of 5,000,000 milliseconds or more.

SELECT *
FROM tracks
WHERE Milliseconds >= 5000000;

-------------------------------------------------------------------------------------------------

-- Question 2: Run Query: Find all the invoices whose total is between $5 and $15 dollars.

SELECT *
FROM Invoices
WHERE Total BETWEEN 5 AND 15;

-------------------------------------------------------------------------------------------------

-- Question 3: Run Query: Find all the customers from the following States: RJ, DF, AB, BC, CA, WA, NY.

SELECT *
FROM Customers
WHERE State IN ('RJ', 'DF', 'AB', 'BC', 'CA', 'WA', 'NY');

-------------------------------------------------------------------------------------------------

-- Question 4: Run Query: Find all the invoices for customer 56 and 58 where the total was between $1.00 and $5.00.

SELECT *
FROM Invoices
WHERE CustomerID IN (56, 58) AND
Total BETWEEN 1 and 5;

-------------------------------------------------------------------------------------------------

-- Question 5: Run Query: Find all the tracks whose name starts with 'All'.

SELECT *
FROM Tracks
WHERE Name LIKE 'All%';

-------------------------------------------------------------------------------------------------

-- Question 6: Run Query: Find all the customer emails that start with "J" and are from gmail.com.

SELECT *
FROM Customers
WHERE Email LIKE 'j%@gmail.com';

-------------------------------------------------------------------------------------------------

-- Question 7: Run Query: Find all the invoices from the billing city Brasília, Edmonton, and Vancouver and sort in descending order by invoice ID.

SELECT *
FROM Invoices
WHERE BillingCity IN ('Brasília', 'Edmonton', 'Vancouver')
ORDER BY InvoiceID DESC;

-------------------------------------------------------------------------------------------------

-- Question 8: Run Query: Show the number of orders placed by each customer (hint: this is found in the invoices table) and sort the result by the number of orders in descending order.

SELECT *, 
       COUNT(CustomerID) AS CountID
FROM Invoices
GROUP BY CustomerID
ORDER BY CountID DESC;

-------------------------------------------------------------------------------------------------

-- Question 9: Run Query: Find the albums with 12 or more tracks.
SELECT TrackID, 
       AlbumID
FROM Tracks
GROUP BY AlbumID
HAVING COUNT(DISTINCT TrackID) >= 12;
