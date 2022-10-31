-- Question 1: Pull a list of customer ids with the customer’s full name, and address, along with combining their city and country together. Be sure to make a space in between these two and make it UPPER CASE. (e.g. LOS ANGELES USA)

SELECT CustomerId, 
       FirstName, 
       LastName, 
       Address, 
       UPPER(City || ' ' || Country) AS Location
FROM Customers

-------------------------------------------------------------------------------------------------

-- Question 2: Create a new employee user id by combining the first 4 letters of the employee’s first name with the first 2 letters of the employee’s last name. Make the new field lower case and pull each individual step to show your work.

SELECT FirstName,
       LastName,
       LOWER(SUBSTR(FirstName, 1, 4)) AS a,
       LOWER(SUBSTR(LastName, 1, 2)) AS b,
       LOWER(SUBSTR(FirstName, 1, 4)) || LOWER(SUBSTR(LastName, 1, 2)) AS UserId
FROM Employees

-------------------------------------------------------------------------------------------------

-- Question 3: Show a list of employees who have worked for the company for 15 or more years using the current date function. Sort by lastname ascending.

SELECT FirstName,
       LastName,
       HireDate,
       DATE('now') - HireDate AS YearsWithCompany
FROM Employees
WHERE YearsWithCompany >= 15
ORDER BY LastName ASC

-------------------------------------------------------------------------------------------------

Question 4: Profiling the Customers table, answer the following question.

SELECT COUNT(*)
FROM Customers
WHERE Address IS NULL









