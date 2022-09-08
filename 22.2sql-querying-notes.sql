-- Learn core querying 
-- learn insertion, updating, and deletion 

-- Data Manipulation Language 
-- DML is a subset of SQL that involves querying and manipulating records in existing tables. 
-- Most of the DML you'll be doing will be related to CRUD ops on rows. 

-- What's CRUD? 
C Create INSERT INTO 
R Read SELECT...FROM 
U Update UPDATE...SET 
D Delete DELETE FROM 

------------------------------------------------------- 

-- Seeding Library DB 

-- Be inside of folder for your sql file 
-- cat library.sql shows everything that is inside of the file in the terminal. 
psql < library.sql -- Creates your database 
psql library -- get inside 
\dt -- shows the table 
-- Or 
psql 
\c library 

------------------------------------------------------- 

-- Select and From 

-- SELECT is most flexible and powerful command in SQL 

1 FROM -- Select and join together tables where data is / Not Required 
2 WHERE -- Decide which rows to use / Not required 
3 GROUP BY -- Place rows into groups / Not required 
4 SELECT -- Determine values of result / Required 
5 HAVING -- Determine which grouped results to keep / Not required 
6 ORDER BY -- Sort output data / Not required 
7 LIMIT -- Limit output to n rows / Not required 
8 OFFSET -- Skip n rows at start of output / Not required 

SELECT * FROM books;
\x auto; -- Expanded display is used automatically 
-- Use enter to scroll down 
SELECT title FROM books; -- How to get the titles 

SELECT title, author FROM book; 

---------------------------------------------------------- 

-- SQL WHERE 

SELECT * FROM books WHERE price > 10; -- Only books with price over $10 
SELECT title, price FROM books WHERE price > 30; 
SELECT title, price FROM books WHERE price >= 89; 
SELECT title, page_count FROM books WHERE page_count > 500; 
SELECT title, page_count FROM books WHERE page_count >= 700 AND page_count <= 800; 
SELECT title, author FROM books WHERE author IN ('Ari Berman', 'Trevor Noah');

---------------------------------------------------------- 

--  Aggregate Functions 
SELECT COUNT(*) FROM books; 
-- 40 
SELECT MIN(price), MAX(price) FROM books; 
 min  |  max
------+--------
 2.99 | 169.03
(1 row) 

SELECT AVG(page_count) FROM books; 
SELECT SUM(price) FROM books; 
SELECT AVG(page_count) FROM books WHERE author = 'J.K. Rowling'; 

---------------------------------------------------------- 

-- GROUP BY & HAVING 

SELECT author FROM books;  

SELECT * FROM books GROUP BY author; 
-- ERROR:  column "books.id" must appear in the GROUP BY clause or be used in an aggregate function
-- LINE 1: SELECT * FROM books GROUP BY author;
               ^  

SELECT author, COUNT(*), AVG(page_count) FROM books GROUP BY author; 
        author        | count |          avg
----------------------+-------+-----------------------
 Ari Berman           |     1 |  384.0000000000000000
 Matthew Lane         |     1 |  264.0000000000000000
 J. K. Rowling        |     7 |  593.8571428571428571
 Cathy O'Neil         |     1 |  288.0000000000000000
 Edwin A. Abbott      |     1 |   96.0000000000000000
 Don Norman           |     1 |  368.0000000000000000
 Randall Munroe       |     1 |  320.0000000000000000
 Jon Klassen          |     1 |   40.0000000000000000
 Joshua Bloch         |     1 |  416.0000000000000000
 Sam Quinones         |     1 |  384.0000000000000000
 Harold Davenport     |     1 |  182.0000000000000000
 Trevor Noah          |     1 |  304.0000000000000000
 Madeleine L'Engle    |     1 |  256.0000000000000000
 Jordan Ellenberg     |     1 |  480.0000000000000000
 Roald Dahl           |     1 |  155.0000000000000000
 Ta-Nehisi Coates     |     1 |  176.0000000000000000
 William Trench       |     1 |  605.0000000000000000
 Margot Lee Shetterly |     1 |  368.0000000000000000
 Jared Diamond        |     1 |  528.0000000000000000
 Kenneth Rosen        |     1 | 1072.0000000000000000
 Michael Pollan       |     1 |  450.0000000000000000
 Margaret Wise Brown  |     1 |   32.0000000000000000
 Kyle Simpson         |     6 |  188.6666666666666667
 Mark Z. Danielewski  |     1 |  709.0000000000000000
 Haruki Murakami      |     1 |  607.0000000000000000
 Shel Silverstein     |     1 |  176.0000000000000000
 Gerald Tenenbaum     |     1 |  629.0000000000000000
 John Trimmer         |     1 |  112.0000000000000000
 Douglas Crockford    |     1 |  176.0000000000000000
(29 rows) 

SELECT publisher, count(*) FROM books GROUP BY publisher; 

SELECT author, COUNT(*) FROM books GROUP BY author HAVING COUNT(*) > 2; 
    author     | count
---------------+-------
 J. K. Rowling |     7
 Kyle Simpson  |     6
(2 rows) 

SELECT publisher, count(*) FROM books GROUP BY publisher HAVING COUNT(*) >= 2; 
   publisher    | count
----------------+-------
 Scholastic     |     7
 HarperCollins  |     2
 Spiegel & Grau |     2
 O'Reilly Media' |     7
(4 rows)   

SELECT author, AVG(page_count) FROM books GROUP BY author HAVING AVG(page_count) > 500;  
       author        |          avg
---------------------+-----------------------
 J. K. Rowling       |  593.8571428571428571
 William Trench      |  605.0000000000000000
 Jared Diamond       |  528.0000000000000000
 Kenneth Rosen       | 1072.0000000000000000
 Mark Z. Danielewski |  709.0000000000000000
 Haruki Murakami     |  607.0000000000000000
 Gerald Tenenbaum    |  629.0000000000000000
(7 rows)

-------------------------------------------------------------- 

-- Order BY & Limit Offset 

SELECT id, author FROM books; 
-- ALL authors with id 

SELECT id, author FROM books ORDER BY author;
-- Orders them alphabetically 

SELECT id, author FROM books ORDER BY author desc; -- descending 
SELECT id, author FROM books ORDER BY author asc; -- ascending 

SELECT id, author, price FROM books ORDER BY price desc; 
 id |        author        | price
----+----------------------+--------
 21 | Kenneth Rosen        | 169.03
 23 | John Trimmer         | 112.42
  2 | Gerald Tenenbaum     |     89
 24 | Harold Davenport     |  63.96
 20 | Joshua Bloch         |  49.78
 11 | William Trench       |  42.95
 22 | Matthew Lane         |   22.2
 10 | Kyle Simpson         |  20.09
 31 | Ari Berman           |  19.49
 12 | Douglas Crockford    |  19.11
 40 | Shel Silverstein     |  17.13
  6 | Kyle Simpson         |  17.09
 37 | Jared Diamond        |  16.71
 28 | Trevor Noah          |  16.16
  4 | Mark Z. Danielewski  |  15.18
 30 | Randall Munroe       |  13.89
  9 | Kyle Simpson         |  13.67
 26 | Jon Klassen          |  13.59
  1 | Don Norman           |  12.92
 25 | Margaret Wise Brown  |  12.79
 38 | Michael Pollan       |  12.56
 34 | Sam Quinones         |  12.23
  7 | Kyle Simpson         |  12.11
  8 | Kyle Simpson         |  11.92
 33 | Jordan Ellenberg     |  11.55
 39 | Haruki Murakami      |  11.52
 19 | J. K. Rowling        |  11.03
 32 | Cathy O'Neil         |     11
 29 | Ta-Nehisi Coates     |  10.35
 27 | Margot Lee Shetterly |   9.98
 16 | J. K. Rowling        |   9.78
 18 | J. K. Rowling        |   9.26
 17 | J. K. Rowling        |   8.59
 14 | J. K. Rowling        |   7.39
 15 | J. K. Rowling        |   7.39
 13 | J. K. Rowling        |   7.06
 36 | Roald Dahl           |   6.39
 35 | Madeleine L'Engle    |   4.64
  3 | Edwin A. Abbott      |      3
  5 | Kyle Simpson         |   2.99
(40 rows) 

SELECT author, title FROM books; 

SELECT author, title FROM books ORDER BY author, title; 
-- Orders JK Rowling books by title as well 

SELECT author, title FROM books ORDER BY author, title LIMIT 5; 
-- First five 

SELECT * FROM books WHERE price > 500 ORDER BY page_count LIMIT 2; 
-- Top two longest books 

SELECT id, author FROM books; 
SELECT id, author FROM books LIMIT 5 OFFSET 5; 
 id |    author
----+--------------
  6 | Kyle Simpson
  7 | Kyle Simpson
  8 | Kyle Simpson
  9 | Kyle Simpson
 10 | Kyle Simpson
(5 rows) 

SELECT id, author FROM books LIMIT 5 OFFSET 10;
 id |      author
----+-------------------
 11 | William Trench
 12 | Douglas Crockford
 13 | J. K. Rowling
 14 | J. K. Rowling
 15 | J. K. Rowling
(5 rows) 

-------------------------------------------------------- 

-- More Operators LIKE 

-- SQL Operators include IN, NOT IN, BETWEEN, AND, and OR 

SELECT id, title FROM books WHERE id IN (1,7,9); 
--  id |                            title
-- ----+-------------------------------------------------------------
--   1 | The Design of Everyday Things: Revised and Expanded Edition
--   7 | You Don't Know JS: this & Object Prototypes
--   9 | You Don't Know JS: Async & Performance
-- (3 rows) 

SELECT id, title FROM books WHERE id = 1 OR id = 7 OR id = 9; 
-- Gets the same results 

SELECT id, title FROM books WHERE id NOT IN (1,7,9); 
-- Opposite 

SELECT id, title FROM books WHERE id >=20 AND id <=25; 
--  id |                           title
-- ----+-----------------------------------------------------------
--  20 | Effective Java
--  21 | Discrete Mathematics and Its Applications Seventh Edition
--  22 | Power-Up: Unlocking the Hidden Mathematics in Video Games
--  23 | How to Avoid Huge Ships
--  24 | Multiplicative Number Theory
--  25 | Goodnight Moon
-- (6 rows)

SELECT id, author FROM books WHERE author = 'r'; 
-- Empty table 

'abc' LIKE 'abc' true
'abc' LIKE 'a%'  true 
'abc' LIKE '_b_' true 
'abc' LIKE 'c'   false 

SELECT id, title FROM books WHERE title LIKE 'T%'; 
 id |                            title
----+-------------------------------------------------------------
  1 | The Design of Everyday Things: Revised and Expanded Edition
 38 | The Omnivores Dilemma: A Natural History of Four Meals
 39 | The Wind-Up Bird Chronicle
(3 rows) 

SELECT id, title FROM books WHERE title LIKE '%:%' 
-- All books that have colons in them. 

SELECT id, title FROM books WHERE title LIKE '%:%' 
-- 19 

-- ILIKE is case insensitive. This is not in the SQL standard but is a PostgreSQL extension. 

SELECT id, title FROM books WHERE title ILIKE '%harry%'; 
-- All the harry potters 

SELECT author FROM books WHERE author ILIKE '%g%'; 
-- Any author with 'g' 

SELECT author FROM books WHERE author ILIKE '%g';
-- Ends with 'g' 

SELECT author FROM books WHERE author ILIKE '% % %';
        author
----------------------
 Edwin A. Abbott
 Mark Z. Danielewski
 J. K. Rowling
 J. K. Rowling
 J. K. Rowling
 J. K. Rowling
 J. K. Rowling
 J. K. Rowling
 J. K. Rowling
 Margaret Wise Brown
 Margot Lee Shetterly
(11 rows) 

SELECT author FROM books WHERE author ILIKE 'J%' OR author ILIKE 'K%'; 

------------------------------------------------------ 

-- Aliases 

SELECT AVG(page_count), AVG(price) FROM books GROUP BY author; 
          avg          |        avg
-----------------------+--------------------
  384.0000000000000000 | 19.489999771118164
  264.0000000000000000 | 22.200000762939453
  593.8571428571428571 |  8.642857074737549
  288.0000000000000000 |                 11
   96.0000000000000000 |                  3
  368.0000000000000000 | 12.920000076293945
  320.0000000000000000 | 13.890000343322754
   40.0000000000000000 |  13.59000015258789
  416.0000000000000000 | 49.779998779296875
  384.0000000000000000 | 12.229999542236328
  182.0000000000000000 | 63.959999084472656
  304.0000000000000000 |  16.15999984741211
  256.0000000000000000 |  4.639999866485596
  480.0000000000000000 | 11.550000190734863
  155.0000000000000000 |  6.389999866485596
  176.0000000000000000 | 10.350000381469727
  605.0000000000000000 |  42.95000076293945
  368.0000000000000000 |  9.979999542236328
  528.0000000000000000 | 16.709999084472656
 1072.0000000000000000 | 169.02999877929688
  450.0000000000000000 |   12.5600004196167
   32.0000000000000000 | 12.789999961853027
  188.6666666666666667 | 12.978333353996277
  709.0000000000000000 | 15.180000305175781
  607.0000000000000000 | 11.520000457763672
  176.0000000000000000 |   17.1299991607666
  629.0000000000000000 |                 89
  112.0000000000000000 | 112.41999816894531
  176.0000000000000000 | 19.110000610351562
(29 rows) 

SELECT AVG(page_count) AS avg_pages, AVG(price) AS avg_price FROM books GROUP BY author;
-- Gives headers 

SELECT author, SUM(page_count) FROM books GROUP BY author ORDER BY SUM(page_count);
        author        | sum
----------------------+------
 Margaret Wise Brown  |   32
 Jon Klassen          |   40
 Edwin A. Abbott      |   96
 John Trimmer         |  112
 Roald Dahl           |  155
 Douglas Crockford    |  176
 Ta-Nehisi Coates     |  176
 Shel Silverstein     |  176
 Harold Davenport     |  182
 Madeleine L'Engle    |  256
 Matthew Lane         |  264
 Cathy O'Neil         |  288
 Trevor Noah          |  304
 Randall Munroe       |  320
 Margot Lee Shetterly |  368
 Don Norman           |  368
 Sam Quinones         |  384
 Ari Berman           |  384
 Joshua Bloch         |  416
 Michael Pollan       |  450
 Jordan Ellenberg     |  480
 Jared Diamond        |  528
 William Trench       |  605
 Haruki Murakami      |  607
 Gerald Tenenbaum     |  629
 Mark Z. Danielewski  |  709
 Kenneth Rosen        | 1072
 Kyle Simpson         | 1132
 J. K. Rowling        | 4157
(29 rows) 

SELECT author, SUM(page_count) AS total FROM books GROUP BY author ORDER BY total DESC;
-- The same thing but descending order and headers 

---------------------------------------------------------------- 

-- INserting 

INSERT INTO books (title, author, price) VALUES ('Dogs Book', 'Colt Steele', 19.99); 
SELECT * FROM books ORDER BY id desc; 
-- New book shows up. 

\d books 
-- id has a default value for each column if we don't specify it.  

INSERT INTO books (title, author) VALUES  
('chicken book', 'Colt Steele'), 
('animals are cool', 'Darwin'), 
('learn to knit', 'my grandma'); 

SELECT * FROM books ORDER BY id DESC; 

--------------------------------------------------

-- Updating 

UPDATE books SET price = 0; 
SELECT price from books; 
-- All prices get set to 0 

UPDATE books SET author = 'Colt Steele' WHERE author = 'J.K. Rowling'; 

SELECT id, title, author FROM books; 
-- All books will say Colt Steele instead of Rowling 

UPDATE books SET author = 'Colt Steele' WHERE id IN (1,3,5); 

---------------------------------------------------------- 

-- DELETE 

SELECT id, page_count FROM books WHERE page_count > 500;

DELETE FROM books WHERE page_count > 500;
-- Gone 

SELECT author, title FROM books WHERE author ILIKE 'S%' OR author ILIKE 'T%'; 
DELETE FROM books WHERE author ILIKE 'S%' OR author ILIKE 'T%'; 

DELETE FROM books; 
-- ALL books gone 

-- OTHER USEFUL FUNCTIONS IN SQL 
concat()
ROUND()
REPLACE() 
LEN()
DISTINCT()
-- You can use the function LEFT to isolate the first character.
-- You can use <> as the NOT EQUALS operator. 

-- 14.
-- The expression subject IN ('chemistry','physics') can be used as a value - it will be 0 or 1.

-- Show the 1984 winners and subject ordered by subject and winner name; but list chemistry and physics last. 

SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY CASE WHEN subject IN ('Physics','Chemistry') THEN 1 ELSE 0 END,subject,winner

-- Using MAX() in a subquery instead of limited to the outer query.
SELECT * FROM payment
WHERE amount = (
   SELECT MAX (amount)
   FROM payment
);