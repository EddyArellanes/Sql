--Simple creation and Delete of Database
CREATE DATABASE library;
DROP DATABASE IF EXISTS library;
--Show the Schema of table
DESC library;
--Select a Database
USE library;


--Order of Queries: SELECT FROM JOIN WHERE LIKE LIMIT ORDER

--Select All info of Table and Limit to certain number of rows
SELECT * FROM clients;
SELECT name, clients FROM  library;
SELECT * FROM clients LIMIT 10;
--Do Action when an unique key is duplicated
INSERT INTO clients (name, email, birthday, gender, active) 
VALUES('Eddy', 'eddy@gmail.com', '1994-02-28', 'M', 1),
('Eddy2', 'eddy2@gmail.com', '1994-02-28', 'M', 1) 
ON DUPLICATE KEY UPDATE active = VALUES(active);

--Nested Query , not recommended because takes a lot of spend time
INSERT INTO books(title, author_id, year)
VALUES('Vueltra al laberinto de la soledad',
    (SELECT author_id FROM authors
    WHERE name = 'Octavio Paz'
    LIMIT 1
    ),
    '1994-03-12'
);

--Select setting Alias of column and using Like
SELECT  name, email, YEAR(NOW()) - YEAR(birthdate) AS age, gender
FROM clients
WHERE gender='F'
    AND name LIKE '%Lop%';

--Join two tables, If not write INNER is the same
SELECT b.book_id, a.name, b.title FROM books AS b 
INNER JOIN authors AS a
ON a.author_id = b.author_id
WHERE a.author_id BETWEEN 1 AND 5;

--Join four tables D: and using IN AS type of select x)
SELECT c.name, b.title, a.name, t.type
FROM transactions AS t
JOIN books AS b
ON t.book_id = b.book_id
JOIN clients AS c
ON t.client_id = c.client_id
JOIN authors AS a
ON b.author_id = a.author_id
WHERE c.gender = 'F' AND t.type IN ('sell', 'lend');

--Implicit Join, this maybe will deprecated in the Future
SELECT b.title, a.name
FROM authors AS a, books AS b
WHERE a.author_id = b.author_id;

--Left Join, the difference here is that will give us all authors, and if not have books, then will show us NULL in b columns :D
SELECT a.author_id, a.name, a.nationality, b.title
FROM authors AS a
LEFT JOIN books AS b
ON a.author_id = b.author_id
WHERE a.author_id BETWEEN 1 AND 5
ORDER BY a.author_id ASC

--COUNT to know how Books have an author using LEFT JOIN, when count is present, is needed add GROUP BY(the only data that won't be repeated)
--El group by es para que un autor solo salga una sola vez con su numero de libros y no muchas veces x), lo pongo en español porque al fin entendí eso xD
SELECT a.author_id, a.name, a.nationality, COUNT(b.book_id)
FROM authors AS a
LEFT JOIN books AS b
ON a.author_id = b.author_id
WHERE a.author_id BETWEEN 1 AND 5
GROUP BY a.author_id
ORDER BY a.author_id ASC

--Showcases for Queries
--What Author Nationalities exist? 
SELECT DISTINCT nationality FROM authors;

--How many authors for every nationality exist, excludin Rusia :P; if in order two rows has the same value then summon a second order :)
SELECT nationality, COUNT(author_id) as count_authors 
FROM authors 
WHERE nationality IS NOT NULL
AND nationality NOT IN('RUS')
GROUP BY nationality
ORDER BY count_authors DESC, nationality ASC;

--How is the average/ deviation standar of the books price
SELECT AVG(price) AS average_price, STDDEV(price) AS std_price  FROM books;

--How is the average/ deviation standar of the books price
SELECT AVG(price) AS average_price, STDDEV(price) AS std_price  FROM books; 

--How is the average/ deviation standar of the books price for Nationality
SELECT a.nationality, 
  COUNT(b.book_id) AS number_books, 
  AVG(price) AS average_price, 
  STDDEV(price) AS std_price  
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
GROUP BY nationality
ORDER BY number_books DESC; 

--Get the Min/Max Price of the Books
SELECT a.nationality, 
  MAX(b.price), 
  MIN(b.price) 
FROM books AS b
JOIN authors AS a
  ON a.author_id = b.author_id
GROUP BY nationality;

--Report of Borrows, CONCAT accepts until 10 arguments
SELECT c.name, t.type, b.title, 
  CONCAT(a.name, "(", a.nationality, ")") as author ,
  TO_DAYS(NOW()) - TO_DAYS(t.created_at) AS ago
FROM transacions AS t
LEFT JOIN clients AS c
  ON c.client_id = t.client_id
LEFT JOIN books AS b
  ON b.book_id = t.book_id
LEFT JOIN authors AS a
  ON b.author_id = a.author_id;


--Update and Delete
--It's recommeded not delete data from database, use booleans to simulate a delete
--It's a very good practice put limit 1, if you forget the where sentence prevent a big chaos
DELETE FROM authors WHERE author_id = 161 LIMIT 1;
--In SQL is not equal is represented by <>, very different than major of languajes is !=
UPDATE authors
SET active = 0
WHERE client_id = 80
LIMIT 1;

--Erase all data in a table
TRUNCATE TABLE transactions;


--SuperQueries, concept that you can do more complex queries inside a column
SELECT nationality, COUNT(book_id), 
SUM( IF(YEAR < 1950, 1, 0)) AS"<1950", 
SUM( IF(YEAR >= 1950 AND YEAR < 1990, 1, 0)) AS "<1990", 
SUM( IF(YEAR >= 1990 AND YEAR < 2000, 1, 0)) AS "<2000",
SUM( IF(YEAR >= 2000, 1, 0)) AS"<hoy"
FROM books AS b
JOIN authorsAS a
ON a.author_id = b.author_id
WHERE a.nationality IS NOt NULL
GROUP BY nationality;