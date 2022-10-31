-- Question 1: Run Query: Find all the tracks that have a length of 5,000,000 milliseconds or more.

SELECT *
FROM tracks
WHERE Milliseconds >= 5000000;
