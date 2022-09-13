-- Relationships Intro 

-- What makes SQL "relational"
-- Some to many and many to many 

-- To avoid duplication of studio names of movies, for example, we would want to referance those studios with ids that are referencing another table 
-- that includes more details about each studio. 

-- Join queries will come in. 

-------------------------------------------------------------- 

-- One to Many (1:M)

-- Movie table and studio table is a one to many relationship. 

-- Primary key 
-- Our studio_id column provides us with a reference to the corresponding record in the studios table by its primary key. 
-- Typically this is implemented with a foreign key constraint, which makes sure every studio_id exists somewhere in the studios table. 

-- We write code that enforces studio_id with reality.  

-- One to many in the sense that one studio has many movies, but each movie has one studio. 

movies_example=# INSERT INTO studios (name, founded_in) VALUES ('Orion Pictures', '1980-10-10');
INSERT 0 1
movies_example=# INSERT INTO movies (title, release_year, runtime, rating, studio_id) VALUES ('Amadeus', 1984, 180, 'R',  4);

-- Deleting DATA exmaples 
-- When trying to delete a studio... 
-- We cannot delete it outright while movies still reference it. 
DELETE FROM studios WHERE id=1; -- error 

-- Option 1: Clear out the studio_id columns of movies that reference it. 
UPDATE movies SET studio_id=NULL WHERE studio_id=1; 
DELETE FROM studios WHERE id=1; 
-- Option 2: Delete the movies associated with that studio first. 
DELETE FROM movies WHERE studio_id=1; 
DELETE FROM studios WHERE id=1; 

-- What are the trade offs? We will revisit this when we look at how to implement each of the two options above in the DDL. 
-- DDL - Data Definition Language, what we use the subset of sql to define tables, references, data types. 
-- DML - Data Modification Language is what we've been using once we have our tables, inserting, deleting. 

------------------------------------------------------------- 

-- Inner Joins 

-- Joing tables 

movies_example=# SELECT id FROM studios WHERE name = 'Walt Disney Studios Motion Pictures';
 id
----
  1
(1 row)

movies_example=# SELECT * FROM movies WHERE studio_id = 1;
 id |            title             | release_year | runtime | rating | studio_id
----+------------------------------+--------------+---------+--------+-----------
  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
(3 rows) 

-- JOIN Operation
-- The JOIN op allows us to create a table in memory by combinig info from different tables
-- Data from tables is matched according to a join condition 
-- Most commonly, the join condition involves comparing a foreign key from one table and a primary key in another table 

-- Our first join
SELECT title, name 
FROM movies 
JOIN studios 
ON movies.studio_id = studios.id; 

movies_example=# SELECT title, name FROM movies JOIN studios ON movies.studio_id = studios.id;
            title             |                name
------------------------------+-------------------------------------
 Star Wars: The Force Awakens | Walt Disney Studios Motion Pictures
 Avatar                       | 20th Century Fox
 Black Panther                | Walt Disney Studios Motion Pictures
 Jurassic World               | Universal Pictures
 Marvel’s The Avengers        | Walt Disney Studios Motion Pictures
 Amadeus                      | Orion Pictures
(6 rows)

movies_example=# SELECT * FROM movies JOIN studios ON movies.studio_id = studios.id;
-- Both tables get combined 

movies_example=# SELECT title, founded_in FROM movies JOIN studios ON movies.studio_id = studios.id;
            title             | founded_in
------------------------------+------------
 Star Wars: The Force Awakens | 1953-06-23
 Avatar                       | 1935-05-31
 Black Panther                | 1953-06-23
 Jurassic World               | 1912-04-30
 Marvel’s The Avengers        | 1953-06-23
 Amadeus                      | 1980-10-10
(6 rows)

movies_example=# SELECT id, id FROM movies JOIN studios ON movies.studio_id = studios.id;
ERROR:  column reference "id" is ambiguous
LINE 1: SELECT id, id FROM movies JOIN studios ON movies.studio_id =...

SELECT movies.id, studios.id FROM movies JOIN studios ON movies.studio_id = studios.id;

-- What we see here is technically an 'Inner Join' 
SELECT title, name 
FROM movies 
INNER JOIN studios 
ON movies.studio_id = studios.id; 
-- JOIN and INNER JOIN are the same, the INNER keyword is optional. 

SELECT * FROM studios JOIN movies ON studios.id = movies.studio_id; 
-- We end up with the studio info first, and movies as well. 

--------------------------------------------------------- 

-- Outer Joins 

-- Inner - only the rows that match the condition in both tables. 

-- Outer - LEFT All of the rows from the first table (left), combined with matching rows from the second table (right). 
-- RIGHT The matching rows from the first table (left), combined with all the rows from the second table (right). 
-- FULL ALl the rows from both tables (left and right). 

movies_example=# INSERT INTO movies (title, release_year, runtime, rating) VALUES ('My first Indie Movie
movies_example# ', 2015, 90, 'PG-13'), ('My second indie movie', 2020, 110, 'R');
INSERT 0 2 

movies_example=# INSERT INTO studios (name, founded_in) VALUES ('Chickenz Pictures', '2020-12-12');
INSERT 0 1
movies_example=# SELECT * FROM studios;
 id |                name                 | founded_in
----+-------------------------------------+------------
  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  2 | 20th Century Fox                    | 1935-05-31
  3 | Universal Pictures                  | 1912-04-30
  4 | Orion Pictures                      | 1980-10-10
  5 | Chickenz Pictures                   | 2020-12-12
(5 rows) 

movies_example=# SELECT title, name AS studio_name FROM movies LEFT JOIN studios ON movies.studio_id = studios.id;
            title             |             studio_name
------------------------------+-------------------------------------
 Star Wars: The Force Awakens | Walt Disney Studios Motion Pictures
 Avatar                       | 20th Century Fox
 Black Panther                | Walt Disney Studios Motion Pictures
 Jurassic World               | Universal Pictures
 Marvel’s The Avengers        | Walt Disney Studios Motion Pictures
 Amadeus                      | Orion Pictures
 My first Indie Movie        +|
                              |
 My second indie movie        |
(8 rows) 

movies_example=# SELECT title, name AS studio_name FROM movies RIGHT JOIN studios ON movies.studio_id = studios.id;
            title             |             studio_name
------------------------------+-------------------------------------
 Star Wars: The Force Awakens | Walt Disney Studios Motion Pictures
 Avatar                       | 20th Century Fox
 Black Panther                | Walt Disney Studios Motion Pictures
 Jurassic World               | Universal Pictures
 Marvel’s The Avengers        | Walt Disney Studios Motion Pictures
 Amadeus                      | Orion Pictures
                              | Cat Cat Cat Pictures
                              | Chickenz Pictures
(8 rows) 

movies_example=# SELECT * FROM movies RIGHT JOIN studios ON movies.studio_id = studios.id;
 id |            title             | release_year | runtime | rating | studio_id | id |                name                 | founded_in
----+------------------------------+--------------+---------+--------+-----------+----+-------------------------------------+------------
  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  2 | Avatar                       |         2009 |     160 | PG-13  |         2 |  2 | 20th Century Fox                    | 1935-05-31
  3 | Black Panther                |         2018 |     140 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  4 | Jurassic World               |         2015 |     124 | PG-13  |         3 |  3 | Universal Pictures                  | 1912-04-30
  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  7 | Amadeus                      |         1984 |     180 | R      |         4 |  4 | Orion Pictures                      | 1980-10-10
    |                              |              |         |        |           |  6 | Cat Cat Cat Pictures                | 1980-10-11
    |                              |              |         |        |           |  5 | Chickenz Pictures                   | 2020-12-12
(8 rows)

movies_example=# SELECT * FROM movies LEFT JOIN studios ON movies.studio_id = studios.id; 
 id |            title             | release_year | runtime | rating | studio_id | id |                name                 | founded_in
----+------------------------------+--------------+---------+--------+-----------+----+-------------------------------------+------------
  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  2 | Avatar                       |         2009 |     160 | PG-13  |         2 |  2 | 20th Century Fox                    | 1935-05-31
  3 | Black Panther                |         2018 |     140 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  4 | Jurassic World               |         2015 |     124 | PG-13  |         3 |  3 | Universal Pictures                  | 1912-04-30
  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1 |  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  7 | Amadeus                      |         1984 |     180 | R      |         4 |  4 | Orion Pictures                      | 1980-10-10
  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |           |    |                                     |
    |                              |              |         |        |           |    |                                     |
  9 | My second indie movie        |         2020 |     110 | R      |           |    |                                     |
(8 rows) 

movies_example=# SELECT * FROM studios RIGHT JOIN movies ON movies.studio_id = studios.id;
 id |                name                 | founded_in | id |            title             | release_year | runtime | rating | studio_id
----+-------------------------------------+------------+----+------------------------------+--------------+---------+--------+-----------
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  2 | 20th Century Fox                    | 1935-05-31 |  2 | Avatar                       |         2009 |     160 | PG-13  |         2
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  3 | Universal Pictures                  | 1912-04-30 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
  4 | Orion Pictures                      | 1980-10-10 |  7 | Amadeus                      |         1984 |     180 | R      |         4
    |                                     |            |  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |
    |                                     |            |    |                              |              |         |        |
    |                                     |            |  9 | My second indie movie        |         2020 |     110 | R      |
(8 rows) 

movies_example=# SELECT * FROM studios FULL JOIN movies ON movies.studio_id = studios.id;
 id |                name                 | founded_in | id |            title             | release_year | runtime | rating | studio_id
----+-------------------------------------+------------+----+------------------------------+--------------+---------+--------+-----------
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  2 | 20th Century Fox                    | 1935-05-31 |  2 | Avatar                       |         2009 |     160 | PG-13  |         2
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  3 | Universal Pictures                  | 1912-04-30 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
  1 | Walt Disney Studios Motion Pictures | 1953-06-23 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
  4 | Orion Pictures                      | 1980-10-10 |  7 | Amadeus                      |         1984 |     180 | R      |         4
    |                                     |            |  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |
    |                                     |            |    |                              |              |         |        |
    |                                     |            |  9 | My second indie movie        |         2020 |     110 | R      |
  6 | Cat Cat Cat Pictures                | 1980-10-11 |    |                              |              |         |        |
  5 | Chickenz Pictures                   | 2020-12-12 |    |                              |              |         |        |
(10 rows) 

-- Most of the time you'll be using INNER JOINS 
-- OUTER JOINS can be helpful when trying to find rows in one table with no match in another table (e.g. an independent movie with no studio) 
-- Outer join example: 
SELECT name FROM movies 
LEFT JOIN studios 
ON movies.studio_id = studios.id; 

SELECT name, COUNT(*) FROM movies JOIN studios ON movies.studio_id = studios.id GROUP BY studios.name; 

               name                 | count 
-------------------------------------+-------
 Universal Pictures                  |     1
 Orion Pictures                      |     1
 Walt Disney Studios Motion Pictures |     3
 20th Century Fox                    |     1
(4 rows)

SELECT name, COUNT(*) AS total FROM movies JOIN studios ON movies.studio_id = studios.id GROUP BY studios.name ORDER BY total DESC; 

----------------------------------------------------- 

-- Many to Many Intro (M:N)

-- Consider actors: one movie has many different actors, but each actor also has roles in many different movie! 
-- A many to many is just two one to manys back to back!

-------------------------------------------------------

-- Many to many Insert

movies_example=# \dt
        List of relations
 Schema |  Name   | Type  | Owner
--------+---------+-------+-------
 public | actors  | table | pasha
 public | movies  | table | pasha
 public | roles   | table | pasha
 public | studios | table | pasha
(4 rows) 

movies_example=# \d roles
                             Table "public.roles"
  Column  |  Type   | Collation | Nullable |              Default
----------+---------+-----------+----------+-----------------------------------
 id       | integer |           | not null | nextval('roles_id_seq'::regclass)
 movie_id | integer |           |          |
 actor_id | integer |           |          |
Indexes:
    "roles_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "roles_actor_id_fkey" FOREIGN KEY (actor_id) REFERENCES actors(id) ON DELETE CASCADE
    "roles_movie_id_fkey" FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE

movies_example=# SELECT * FROM actors
movies_example-# ;
 id | first_name | last_name | birth_date
----+------------+-----------+------------
  1 | Scarlett   | Johansson | 1984-11-22
  2 | Samuel L   | Jackson   | 1948-12-21
  3 | Kristen    | Wiig      | 1973-08-22
(3 rows) 

movies_example=# INSERT INTO movies (title, release_year) VALUES ('Guardians 2', 2017), ('The Thing', 1982);
INSERT 0 2
movies_example=# SELECT * FROM movies;
 id |            title             | release_year | runtime | rating | studio_id
----+------------------------------+--------------+---------+--------+-----------
  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  2 | Avatar                       |         2009 |     160 | PG-13  |         2
  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
  7 | Amadeus                      |         1984 |     180 | R      |         4
  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |
    |                              |              |         |        |
  9 | My second indie movie        |         2020 |     110 | R      |
 10 | Guardians 2                  |         2017 |         |        |
 11 | The Thing                    |         1982 |         |        |
(10 rows) 

movies_example=# INSERT INTO actors (first_name, last_name, birth_date) VALUES ('Kurt', 'Russell', '1970-10-10'), ('Braley', 'Cooper', '1985-12-03'), ('Chris', 'Pratt', '1986-04-02');
INSERT 0 3
movies_example=# SELECT * FROM actors;
 id | first_name | last_name | birth_date
----+------------+-----------+------------
  1 | Scarlett   | Johansson | 1984-11-22
  2 | Samuel L   | Jackson   | 1948-12-21
  3 | Kristen    | Wiig      | 1973-08-22
  4 | Kurt       | Russell   | 1970-10-10
  5 | Braley     | Cooper    | 1985-12-03
  6 | Chris      | Pratt     | 1986-04-02
(6 rows) 

movies_example=# INSERT INTO roles (movie_id, actor_id) VALUES (10,4), (10, 5), (10, 6),(11, 4);
INSERT 0 4
movies_example=# SELECT * FROM roles;
 id | movie_id | actor_id
----+----------+----------
  1 |        1 |        1
  2 |        1 |        2
  3 |        3 |        2
  8 |       10 |        4
  9 |       10 |        5
 10 |       10 |        6
 11 |       11 |        4
(7 rows) 

movies_example=# INSERT INTO roles (actor_id, movie_id)
movies_example-# VALUES
movies_example-# (5, 72);
ERROR:  insert or update on table "roles" violates foreign key constraint "roles_movie_id_fkey"
DETAIL:  Key (movie_id)=(72) is not present in table "movies". 

-- We can do all of this, ROM, with Python. THis is just us doing it through a command line. It becomes much smoother. 

movies_example=# SELECT * FROM studios;
 id |                name                 | founded_in
----+-------------------------------------+------------
  1 | Walt Disney Studios Motion Pictures | 1953-06-23
  2 | 20th Century Fox                    | 1935-05-31
  3 | Universal Pictures                  | 1912-04-30
  4 | Orion Pictures                      | 1980-10-10
  5 | Chickenz Pictures                   | 2020-12-12
  6 | Cat Cat Cat Pictures                | 1980-10-11
(6 rows)

movies_example=# DELETE FROM studios WHERE id = 4;
ERROR:  update or delete on table "studios" violates foreign key constraint "movies_studio_id_fkey" on table "movies"
DETAIL:  Key (id)=(4) is still referenced from table "movies". 

movies_example=# \d roles
                             Table "public.roles"
  Column  |  Type   | Collation | Nullable |              Default
----------+---------+-----------+----------+-----------------------------------
 id       | integer |           | not null | nextval('roles_id_seq'::regclass)
 movie_id | integer |           |          |
 actor_id | integer |           |          |
Indexes:
    "roles_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "roles_actor_id_fkey" FOREIGN KEY (actor_id) REFERENCES actors(id) ON DELETE CASCADE
    "roles_movie_id_fkey" FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE

-- When I delete an actor or an id, those will cascade into all the other references, which will be shown shortly. 

movies_example=# DELETE FROM actors WHERE id = 1;
DELETE 1
movies_example=# SELECT * FROM actors;
 id | first_name | last_name | birth_date
----+------------+-----------+------------
  2 | Samuel L   | Jackson   | 1948-12-21
  3 | Kristen    | Wiig      | 1973-08-22
  4 | Kurt       | Russell   | 1970-10-10
  5 | Braley     | Cooper    | 1985-12-03
  6 | Chris      | Pratt     | 1986-04-02
(5 rows)

movies_example=# SELECT * FROM roles;
 id | movie_id | actor_id
----+----------+----------
  2 |        1 |        2
  3 |        3 |        2
  8 |       10 |        4
  9 |       10 |        5
 10 |       10 |        6
 11 |       11 |        4
(6 rows) 

------------------------------------------------------------

-- Many to Many JOINS

-- Join Tables 
-- The roles table in our current schema is an example of a join table (AKA an associative table aka a mapping table). 
-- A join table serves as a way to connect two tables in a many to many relationship. 
-- The join table consists of, at a minimum, two foreign key columns to the two other tables in the relationship. 
-- It is completely valid to put other data in the join table (e.g. how much was an actor paid for the role). 
-- Sometimes the join table has a nice name (when it has meaning on its own, e.g. roles), but you can also just call it table1_table2. 

movies_example=# SELECT * FROM roles JOIN actors ON roles.actor_id = actors.id;
 id | movie_id | actor_id | id | first_name | last_name | birth_date
----+----------+----------+----+------------+-----------+------------
  2 |        1 |        2 |  2 | Samuel L   | Jackson   | 1948-12-21
  3 |        3 |        2 |  2 | Samuel L   | Jackson   | 1948-12-21
  8 |       10 |        4 |  4 | Kurt       | Russell   | 1970-10-10
  9 |       10 |        5 |  5 | Braley     | Cooper    | 1985-12-03
 10 |       10 |        6 |  6 | Chris      | Pratt     | 1986-04-02
 11 |       11 |        4 |  4 | Kurt       | Russell   | 1970-10-10
(6 rows) 

movies_example=# SELECT first_name, last_name, COUNT(*) FROM roles JOIN actors ON roles.actor_id = actors.id GROUP BY actors.id;
 first_name | last_name | count
------------+-----------+-------
 Kurt       | Russell   |     2
 Chris      | Pratt     |     1
 Samuel L   | Jackson   |     2
 Braley     | Cooper    |     1
(4 rows) 

movies_example=# SELECT * FROM actors;
 id | first_name | last_name | birth_date
----+------------+-----------+------------
  2 | Samuel L   | Jackson   | 1948-12-21
  3 | Kristen    | Wiig      | 1973-08-22
  4 | Kurt       | Russell   | 1970-10-10
  5 | Braley     | Cooper    | 1985-12-03
  6 | Chris      | Pratt     | 1986-04-02
(5 rows)

movies_example=# INSERT INTO roles (actor_id, movie_id) VALUES (6,4), (6,5);
INSERT 0 2 
movies_example=# SELECT first_name, last_name, COUNT(*) FROM roles JOIN actors ON roles.actor_id = actors.id GROUP BY actors.id;
 first_name | last_name | count
------------+-----------+-------
 Kurt       | Russell   |     2
 Chris      | Pratt     |     3
 Samuel L   | Jackson   |     2
 Braley     | Cooper    |     1
(4 rows) 

movies_example=# SELECT first_name, last_name, COUNT(*) AS total_roles FROM roles JOIN actors ON roles.actor_id = actors
.id GROUP BY actors.id ORDER BY total_roles DESC;
 first_name | last_name | total_roles
------------+-----------+-------------
 Chris      | Pratt     |           3
 Kurt       | Russell   |           2
 Samuel L   | Jackson   |           2
 Braley     | Cooper    |           1
(4 rows) 

SELECT * FROM roles JOIN actors ON roles.actor_id = actors.id JOIN movies ON roles.movie_id = movies.id;
 id | movie_id | actor_id | id | first_name | last_name | birth_date | id |            title             | release_year | runtime | rating | studio_id
----+----------+----------+----+------------+-----------+------------+----+------------------------------+--------------+---------+--------+-----------
  2 |        1 |        2 |  2 | Samuel L   | Jackson   | 1948-12-21 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  3 |        3 |        2 |  2 | Samuel L   | Jackson   | 1948-12-21 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  8 |       10 |        4 |  4 | Kurt       | Russell   | 1970-10-10 | 10 | Guardians 2                  |         2017 |         |        |
  9 |       10 |        5 |  5 | Braley     | Cooper    | 1985-12-03 | 10 | Guardians 2                  |         2017 |         |        |
 10 |       10 |        6 |  6 | Chris      | Pratt     | 1986-04-02 | 10 | Guardians 2                  |         2017 |         |        |
 11 |       11 |        4 |  4 | Kurt       | Russell   | 1970-10-10 | 11 | The Thing                    |         1982 |         |        |
 13 |        4 |        6 |  6 | Chris      | Pratt     | 1986-04-02 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
 14 |        5 |        6 |  6 | Chris      | Pratt     | 1986-04-02 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
(8 rows)

movies_example=# SELECT title, first_name, last_name FROM roles JOIN actors ON roles.actor_id = actors.id JOIN movies ON
 roles.movie_id = movies.id;
            title             | first_name | last_name
------------------------------+------------+-----------
 Star Wars: The Force Awakens | Samuel L   | Jackson
 Black Panther                | Samuel L   | Jackson
 Guardians 2                  | Kurt       | Russell
 Guardians 2                  | Braley     | Cooper
 Guardians 2                  | Chris      | Pratt
 The Thing                    | Kurt       | Russell
 Jurassic World               | Chris      | Pratt
 Marvel’s The Avengers        | Chris      | Pratt
(8 rows)

-- Querying a Many to Many 
-- Connecting movies and actors: 
SELECT * FROM movies 
JOIN roles 
ON movies.id = roles.movie_id 
JOIN actors 
ON roles.actor_id = actors.id; 

-- Selecting certain columns, using table alias shorthand:
SELECT m.title, a.first_name, a.last_name
FROM movies m 
JOIN roles r 
ON m.id = r.movie_id 
JOIN actors a 
ON r.actor_id = a.id; 

movies_example=# SELECT m.title, a.first_name, a.last_name FROM roles
movies_example-# r
movies_example-# JOIN movies m
movies_example-# ON r.movie_id = m.id
movies_example-# JOIN actors a
movies_example-# ON r.actor_id = a.id;
            title             | first_name | last_name
------------------------------+------------+-----------
 Star Wars: The Force Awakens | Samuel L   | Jackson
 Black Panther                | Samuel L   | Jackson
 Guardians 2                  | Kurt       | Russell
 Guardians 2                  | Braley     | Cooper
 Guardians 2                  | Chris      | Pratt
 The Thing                    | Kurt       | Russell
 Jurassic World               | Chris      | Pratt
 Marvel’s The Avengers        | Chris      | Pratt
(8 rows) 




movies_example=# SELECT * FROM movies;
 id |            title             | release_year | runtime | rating | studio_id
----+------------------------------+--------------+---------+--------+-----------
  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  2 | Avatar                       |         2009 |     160 | PG-13  |         2
  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
  7 | Amadeus                      |         1984 |     180 | R      |         4
  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |
    |                              |              |         |        |
  9 | My second indie movie        |         2020 |     110 | R      |
 10 | Guardians 2                  |         2017 |         |        |
 11 | The Thing                    |         1982 |         |        |
(10 rows)

movies_example=# SELECT m.title, a.first_name, a.last_name
movies_example-# FROM movies m
movies_example-# JOIN roles r
movies_example-# ON m.id = r.movie_id
movies_example-# JOIN actors a
movies_example-# ON a.id = r.actor_id;
            title             | first_name | last_name
------------------------------+------------+-----------
 Star Wars: The Force Awakens | Samuel L   | Jackson
 Black Panther                | Samuel L   | Jackson
 Guardians 2                  | Kurt       | Russell
 Guardians 2                  | Braley     | Cooper
 Guardians 2                  | Chris      | Pratt
 The Thing                    | Kurt       | Russell
 Jurassic World               | Chris      | Pratt
 Marvel’s The Avengers        | Chris      | Pratt
(8 rows) 

movies_example=# SELECT m.title, a.first_name, a.last_name
FROM movies m
JOIN roles r
ON m.id = r.movie_id
JOIN actors a
ON a.id = r.actor_id
movies_example-# WHERE m.release_year < 2000;
   title   | first_name | last_name
-----------+------------+-----------
 The Thing | Kurt       | Russell
(1 row) 

movies_example=# SELECT m.title, a.first_name, a.last_name
FROM movies m
JOIN roles r
ON m.id = r.movie_id
JOIN actors a
ON a.id = r.actor_id
WHERE m.release_year > 2016;
     title     | first_name | last_name
---------------+------------+-----------
 Black Panther | Samuel L   | Jackson
 Guardians 2   | Kurt       | Russell
 Guardians 2   | Braley     | Cooper
 Guardians 2   | Chris      | Pratt
(4 rows) 





movies_example=# SELECT m.release_year, m.title, a.first_name, a.last_name
FROM movies m
JOIN roles r
ON m.id = r.movie_id
JOIN actors a
ON a.id = r.actor_id
WHERE m.release_year > 2016
ORDER BY m.release_year;
 release_year |     title     | first_name | last_name
--------------+---------------+------------+-----------
         2017 | Guardians 2   | Kurt       | Russell
         2017 | Guardians 2   | Braley     | Cooper
         2017 | Guardians 2   | Chris      | Pratt
         2018 | Black Panther | Samuel L   | Jackson
(4 rows) 




movies_example=# SELECT m.release_year, m.title, a.first_name, a.last_name
FROM movies m
JOIN roles r
ON m.id = r.movie_id
JOIN actors a
ON a.id = r.actor_id
WHERE m.release_year > 2000
ORDER BY m.release_year;
 release_year |            title             | first_name | last_name
--------------+------------------------------+------------+-----------
         2012 | Marvel’s The Avengers        | Chris      | Pratt
         2015 | Star Wars: The Force Awakens | Samuel L   | Jackson
         2015 | Jurassic World               | Chris      | Pratt
         2017 | Guardians 2                  | Braley     | Cooper
         2017 | Guardians 2                  | Kurt       | Russell
         2017 | Guardians 2                  | Chris      | Pratt
         2018 | Black Panther                | Samuel L   | Jackson
(7 rows) 




movies_example=# SELECT m.release_year, m.title, a.first_name, a.last_name
FROM movies m
JOIN roles r
ON m.id = r.movie_id
JOIN actors a
ON a.id = r.actor_id
WHERE m.release_year > 2000
ORDER BY m.release_year, a.first_name;
 release_year |            title             | first_name | last_name
--------------+------------------------------+------------+-----------
         2012 | Marvel’s The Avengers        | Chris      | Pratt
         2015 | Jurassic World               | Chris      | Pratt
         2015 | Star Wars: The Force Awakens | Samuel L   | Jackson
         2017 | Guardians 2                  | Braley     | Cooper
         2017 | Guardians 2                  | Chris      | Pratt
         2017 | Guardians 2                  | Kurt       | Russell
         2018 | Black Panther                | Samuel L   | Jackson
(7 rows)

------------------------------------------------------ 

-- Many to many outer joins 

SELECT * FROM roles r 
JOIN movies m 
ON r.movie_id = m.id; 

movies_example=# SELECT * FROM roles r
movies_example-# JOIN movies m
movies_example-# ON r.movie_id = m.id;
 id | movie_id | actor_id | id |            title             | release_year | runtime | rating | studio_id
----+----------+----------+----+------------------------------+--------------+---------+--------+-----------
  2 |        1 |        2 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  3 |        3 |        2 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  8 |       10 |        4 | 10 | Guardians 2                  |         2017 |         |        |
  9 |       10 |        5 | 10 | Guardians 2                  |         2017 |         |        |
 10 |       10 |        6 | 10 | Guardians 2                  |         2017 |         |        |
 11 |       11 |        4 | 11 | The Thing                    |         1982 |         |        |
 13 |        4 |        6 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
 14 |        5 |        6 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
(8 rows)



-- So this time we make it into a RIGHT JOIN, which adds the indie movies without those actors.
movies_example=# SELECT * FROM roles r
RIGHT JOIN movies m
ON r.movie_id = m.id;
 id | movie_id | actor_id | id |            title             | release_year | runtime | rating | studio_id
----+----------+----------+----+------------------------------+--------------+---------+--------+-----------
  2 |        1 |        2 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1
  3 |        3 |        2 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1
  8 |       10 |        4 | 10 | Guardians 2                  |         2017 |         |        |
  9 |       10 |        5 | 10 | Guardians 2                  |         2017 |         |        |
 10 |       10 |        6 | 10 | Guardians 2                  |         2017 |         |        |
 11 |       11 |        4 | 11 | The Thing                    |         1982 |         |        |
 13 |        4 |        6 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3
 14 |        5 |        6 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1
    |          |          |  2 | Avatar                       |         2009 |     160 | PG-13  |         2
    |          |          |  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |
    |          |          |    |                              |              |         |        |
    |          |          |  9 | My second indie movie        |         2020 |     110 | R      |
    |          |          |  7 | Amadeus                      |         1984 |     180 | R      |         4
(12 rows) 

-- If we do a LEFT JOIN, it looks exactly like an INNER JOIN, because in our roles table, every single role has to have a movie_id.

movies_example=# SELECT * FROM roles r
RIGHT JOIN movies m
ON r.movie_id = m.id
movies_example-# JOIN actors a
movies_example-# ON r.actor_id = a.id; 
 id | movie_id | actor_id | id |            title             | release_year | runtime | rating | studio_id | id | first_name | last_name | birth_date
----+----------+----------+----+------------------------------+--------------+---------+--------+-----------+----+------------+-----------+------------
  2 |        1 |        2 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  3 |        3 |        2 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  8 |       10 |        4 | 10 | Guardians 2                  |         2017 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
  9 |       10 |        5 | 10 | Guardians 2                  |         2017 |         |        |           |  5 | Braley     | Cooper    | 1985-12-03
 10 |       10 |        6 | 10 | Guardians 2                  |         2017 |         |        |           |  6 | Chris      | Pratt     | 1986-04-02
 11 |       11 |        4 | 11 | The Thing                    |         1982 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
 13 |        4 |        6 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3 |  6 | Chris      | Pratt     | 1986-04-02
 14 |        5 |        6 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1 |  6 | Chris      | Pratt     | 1986-04-02
(8 rows) 


-- Has Kirsten Wiig
movies_example=# SELECT * FROM roles r
RIGHT JOIN movies m
ON r.movie_id = m.id
RIGHT JOIN actors a
ON r.actor_id = a.id;
 id | movie_id | actor_id | id |            title             | release_year | runtime | rating | studio_id | id | first_name | last_name | birth_date
----+----------+----------+----+------------------------------+--------------+---------+--------+-----------+----+------------+-----------+------------
  2 |        1 |        2 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  3 |        3 |        2 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  8 |       10 |        4 | 10 | Guardians 2                  |         2017 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
  9 |       10 |        5 | 10 | Guardians 2                  |         2017 |         |        |           |  5 | Braley     | Cooper    | 1985-12-03
 10 |       10 |        6 | 10 | Guardians 2                  |         2017 |         |        |           |  6 | Chris      | Pratt     | 1986-04-02
 11 |       11 |        4 | 11 | The Thing                    |         1982 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
 13 |        4 |        6 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3 |  6 | Chris      | Pratt     | 1986-04-02
 14 |        5 |        6 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1 |  6 | Chris      | Pratt     | 1986-04-02
    |          |          |    |                              |              |         |        |           |  3 | Kristen    | Wiig      | 1973-08-22
(9 rows) 


-- Every single movie, regardless of rollover. 
movies_example=# SELECT * FROM roles r
FULL JOIN movies m
ON r.movie_id = m.id
FULL JOIN actors a
ON r.actor_id = a.id;
 id | movie_id | actor_id | id |            title             | release_year | runtime | rating | studio_id | id | first_name | last_name | birth_date
----+----------+----------+----+------------------------------+--------------+---------+--------+-----------+----+------------+-----------+------------
  2 |        1 |        2 |  1 | Star Wars: The Force Awakens |         2015 |     136 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  3 |        3 |        2 |  3 | Black Panther                |         2018 |     140 | PG-13  |         1 |  2 | Samuel L   | Jackson   | 1948-12-21
  8 |       10 |        4 | 10 | Guardians 2                  |         2017 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
  9 |       10 |        5 | 10 | Guardians 2                  |         2017 |         |        |           |  5 | Braley     | Cooper    | 1985-12-03
 10 |       10 |        6 | 10 | Guardians 2                  |         2017 |         |        |           |  6 | Chris      | Pratt     | 1986-04-02
 11 |       11 |        4 | 11 | The Thing                    |         1982 |         |        |           |  4 | Kurt       | Russell   | 1970-10-10
 13 |        4 |        6 |  4 | Jurassic World               |         2015 |     124 | PG-13  |         3 |  6 | Chris      | Pratt     | 1986-04-02
 14 |        5 |        6 |  5 | Marvel’s The Avengers        |         2012 |     142 | PG-13  |         1 |  6 | Chris      | Pratt     | 1986-04-02
    |          |          |  2 | Avatar                       |         2009 |     160 | PG-13  |         2 |    |            |           |
    |          |          |  8 | My first Indie Movie        +|         2015 |      90 | PG-13  |           |    |            |           |
    |          |          |    |                              |              |         |        |           |    |            |           |
    |          |          |  9 | My second indie movie        |         2020 |     110 | R      |           |    |            |           |
    |          |          |  7 | Amadeus                      |         1984 |     180 | R      |         4 |    |            |           |
    |          |          |    |                              |              |         |        |           |  3 | Kristen    | Wiig      | 1973-08-22
(13 rows)

-- Copy and pasting through another file makes it easier and less confusing. 

-- SQLzoo
/*
List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0.
You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
*/
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 FROM
    game LEFT JOIN goal ON (id = matchid)
    GROUP BY mdate,team1,team2, matchid
    ORDER BY mdate, matchid, team1, team2 


    SELECT title, name
FROM movie JOIN casting ON (movieid = movie.id AND ord=1)
JOIN actor ON (actorid=actor.id)
WHERE movie.id IN (171,
1233,
1249)
