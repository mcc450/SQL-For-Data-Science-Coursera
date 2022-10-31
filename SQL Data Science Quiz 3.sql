-- Question 1: Using a subquery, find the names of all the tracks for the album "Californication".
SELECT Name
FROM Tracks
WHERE AlbumId IN 
(
    SELECT AlbumId
    FROM Albums
    WHERE Title = 'Californication'
)

------------------------------------------------------------------------------------------------

-- Question 2: Find the total number of invoices for each customer along with the customer's full name, city and email.
SELECT COUNT(i.InvoiceId) AS Num_Invoices, 
       c.FirstName, 
       c.LastName, 
       c.City, 
       c.Email
FROM Customers AS c
INNER JOIN Invoices as i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId

------------------------------------------------------------------------------------------------

-- Question 3: Retrieve the track name, album, artistID, and trackID for all the albums.
SELECT t.Name,
       a.Title AS AlbumTitle,
       a.ArtistId,
       t.TrackId
FROM Albums AS a
INNER JOIN Tracks AS t
ON a.AlbumId = t.AlbumId

------------------------------------------------------------------------------------------------

-- Question 4: Retrieve a list with the managers last name, and the last name of the employees who report to him or her.
SELECT t1.LastName as employee, 
       t2.LastName as boss
FROM Employees AS t1, Employees AS t2
WHERE t1.ReportsTo = t2.EmployeeId
ORDER BY boss ASC

------------------------------------------------------------------------------------------------

-- Question 5: Find the name and ID of the artists who do not have albums. 
SELECT ar.Name, 
       ar.ArtistId, 
       al.AlbumId
FROM Artists AS ar
LEFT JOIN Albums AS al
ON ar.ArtistId = al.ArtistId
WHERE AlbumId IS NULL

------------------------------------------------------------------------------------------------

-- Question 6: Use a UNION to create a list of all the employee's and customer's first names and last names ordered by the last name in descending order.
SELECT FirstName, 
       LastName
FROM Employees
UNION
SELECT FirstName, 
       LastName
FROM Customers
ORDER BY LastName DESC

------------------------------------------------------------------------------------------------

-- Question 7: See if there are any customers who have a different city listed in their billing city versus their customer city.
SELECT COUNT(DISTINCT c.CustomerId)
FROM Customers AS c
LEFT JOIN Invoices AS i
ON c.CustomerId = i.CustomerId
WHERE c.city <> i.BillingCity

------------------------------------------------------------------------------------------------
