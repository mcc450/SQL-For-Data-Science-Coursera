-- Question 1: Retrieve all the records from the Employees table.

SELECT *
FROM Employees;

--------------------------------------------------------------------------------------------------

-- Question 2: Retrieve the FirstName, LastName, Birthdate, Address, City, and State from the Employees table.

SELECT FirstName,
       LastName,
       Birthdate,
       Address,
       City,
       State
FROM Employees;

--------------------------------------------------------------------------------------------------

-- Question 3: Retrieve all the columns from the Tracks table, but only return 20 rows.

SELECT *
FROM Tracks
LIMIT 20;
