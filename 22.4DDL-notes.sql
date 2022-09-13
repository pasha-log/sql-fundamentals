-- DDL & Schema Design 

-- Learn SQL Commands to Create, Update,  Remove DBs & Tables 
-- Understand the Basics of DB Schema Design 
-- Learn how to properly model relational data 

createdb delete_me 
psql 
\l -- You'll see a list of databases which will include delete_me 

-- In psql 
CREATE DATABASE kitty_toys_db; 
DROP DATABASE delete_me; -- Gone 

\c movies_example; 
-- You are now connected to database 'movies_example' as user 'RecordingUser'. 

\dt -- shows tables in db 
\d actors 
\d+ actors -- more info 

---------------------------------------------------------- 

-- CReating dropping tables 

CREATE DATABASE library; 

\c library 

CREATE TABLE books (
    id SERIAL PRIMARY KEY, 
    title TEXT, 
    author TEXT, 
    price FLOAT, 
    page_count INTEGER, 
    publisher TEXT, 
    publication_date DATE
);

-- .pgsql as our file extension. Generally easier to read  

------------------------------------------------------------ 

-- SQL Datatypes 

-- Integer (int is alias) 
-- Float (you can specify precision)
-- Text 
-- Varchar (character varying alias) 
-- Boolean 
-- Date (without time) 
-- Timestamp 
-- Serial (auto-incrementing numbers (used for primary keys))

CREATE TABLE subreddits (
    id SERIAL,
    name VARCHAR(15), 
    description TEXT, 
    subscribers INTEGER, 
    is_private BOOLEAN, 
);

INSERT INTO subreddits 
(name, description, subscribers, is_private)
VALUES 
('chickenpics', 'Your fave page to see chicken pictures', 10, false); 

INSERT INTO subreddits (subscribers) VALUES ('hello'); 
-- ERROR: invalid input syntax

INSERT INTO subreddits (name) VALUES ('ajdkalsjdasaslkjfslasjdlkajs'); 
-- ERROR: value too long for type character varying(15)

----------------------------------------------------------- 

-- NULL 
-- Lack of a value, unknown, empty 

SELECT * FROM subreddits WHERE name=NULL;
-- Doesn't work 

SELECT * FROM subreddits WHERE name IS NULL; 
-- Works, but values are just empty in table 

-- NULL values are ok when you really might have missing/unknown data 
-- But generally, they are a pain, so it can be goood idea to make fields not nullable 

------------------------------------------------------------

-- Constraints 
-- Basic form of validation. 

-- Primary Key(every table must have a unique identifier) 
-- Unique (prevent duplicates in the column) 
-- Not NULL (prevent null in the column) 
-- Check (do a logical condition before inserting/updating)
-- Foreign Key (column values must reference)

CREATE TABLE subreddits (
    id SERIAL,
    name VARCHAR(15) NOT NULL, 
    description TEXT, 
    subscribers INTEGER CHECK (subscribers > 0), 
    is_private BOOLEAN, 
);

CREATE TABLE users (
    id SERIAL, 
    username VARCHAR(15) UNIQUE NOT NULL, 
    password VARCHAR(20) NOT NULL,
)

INSERT INTO subreddits (name, subscribers) 
VALUES 
('chickens', 5); 

SELECT * FROM subreddits;  
-- description and is_private can be NULL 
-- but when you set subscribers to 0, you get an error. 

------------------------------------------------------------ 

-- Default values 

CREATE TABLE subreddits (
    id SERIAL,
    name VARCHAR(15) NOT NULL, 
    description TEXT, 
    subscribers INTEGER CHECK (subscribers > 0) DEFAULT 1, 
    is_private BOOLEAN DEFAULT false, 
);

-- Default behaves exactly as you would expect. 

INSERT INTO subreddits (name) 
VALUES 
('backyardchicks'); 

SELECT * FROM reddits; 
-- Default values of subscribers and is_private automatically made. 

-------------------------------------------------------------- 

-- Primary and foreign keys 

-- Must be unique. Designate a unique identifier column. 

CREATE TABLE subreddits (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users, -- References some external table
    name VARCHAR(15) NOT NULL, 
    description TEXT, 
    subscribers INTEGER CHECK (subscribers > 0) DEFAULT 1, 
    is_private BOOLEAN DEFAULT false, 
); 

CREATE TABLE users (
    id SERIAL PRIMARY KEY, -- The same as saying UNIQUE NOT NULL
    username VARCHAR(15) UNIQUE NOT NULL, 
    password VARCHAR(20) NOT NULL,
);

INSERT INTO users (username, password)
VALUES 
('graylady', 'adsfsdfj'), 
('stevie-chicks', 'laksjfkls'); 

INSERT INTO subreddits 
(name, user_id)
VALUES 
('chickens', 2), 
('waterluvers', 1); 

 -------------------------------------------------- 

-- Deletion behavior when we have references in another table 

DELETE FROM users WHERE id=2; 
-- ERROR: update or delete on table "users" violates foreign key constraint... 

CREATE TABLE subreddits (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users ON DELETE SET NULL, 
    name VARCHAR(15) NOT NULL, 
    description TEXT, 
    subscribers INTEGER CHECK (subscribers > 0) DEFAULT 1, 
    is_private BOOLEAN DEFAULT false, 
); 

psql < reddit.pgsql 
psql 
\c reddit_db 
SELECT * FROM users; 
SELECT * FROM subreddits 
DELETE FROM users WHERE id=2; -- Still have the chicken subreddit but no user_id (one option)

-- The other option is ON DELETE CASCADE 

CREATE TABLE comments 
(
    id SERIAL PRIMARY KEY, 
    user_id INTEGER REFERENCES users ON DELETE CASCADE, 
    comment_text TEXT NOT NULL
); 
-- And everytime you add a new table into the db, psql < reddit.psql and so on. 

INSERT INTO comments (user_id, comment_text) 
VALUES 
(2, 'cluck cluck'),
(2, 'bock bock'), 
(1, 'adjklafd'); 

SELECT * FROM comments; 

DELETE FROM users WHERE id=2; 
-- The comments are gone along with the user. 

------------------------------------------------ 

-- Alter table 

-- Adding, removing, renaming columns 

ALTER TABLE books ADD COLUMN in_paperback BOOLEAN; 
ALTER TABLE books DROP COLUMN in_paperback; 
ALTER TABLE books RENAME COLUMN page_count TO num_pages; 

SELECT * FROM subreddits; 
ALTER TABLE subreddits DROP COLUMN description; -- Completely removes it 

ALTER TABLE users ADD COLUMN permissions TEXT; 
ALTER TABLE users DROP COLUMN permissions; 
ALTER TABLE users ADD COLUMN permissions TEXT DEFAULT 'moderator'; 

----------------------------------------------------- 

-- Crow's Foot Notation 

-- From our joins exercise involving movies, studios, actors, and roles, we can see that: 
-- one studio has many movies 
-- one actor has many roles 
-- one movie has many actors 
-- Before we write out the DDL, we'll visualize this a few ways. 

-- Preferably, we will draw diagrams with Crow's Foor Notation, which is a standard way to represent schemas. 
 
-- Database Diagram online, TablePlus, Vertabelo, Quick Database Diagrams, or just Excel. 

-------------------------------------------------------------- 

-- Normalization 

-- A db design technique which organizes tables in a manner that reduces redundancy and dependency of data. 
-- It divides larger tables to smaller tables and links them using relationships. 

products 
id  price 
1   05.00
2   10.00

colors 
id  color 
1   red 
2   green
3   yellow

products_colors 
id  color_id    product_id 
1   1           1
2   2           1
3   3           2 

-------------------------------------------------------- 

-- Indexing 

-- DB index is a special data structure that efficiently stores column values to speed up row retrieval via SELECT and WHERE(ie "read") queries. 

-- For instance, if you place an index on a username column in a users table, any query using username will 
-- execute faster since fewer rows have to be scanned due to the efficient structure. 

-- Index efficiency 
-- In general, db software (including PostgreSQL) use tree-like data structures to store the data, 
-- which can retrieve values in logarithmic time O(lg(N)) instead of linear O(N) time. 

-- Translation: if have 1000000 rows and are looking for a single column value, instead of examining every row, we can examine approximately log2(1000000) = 20 rows to get our answer, which is an incredible improvement. 

-- Why not index everything?
-- There is a tradeoff with indexing! For every indexed column, a copy of that column's data has to be stored as a tree, which can take up a lot of space. 

--  Only add to a column that you'll look them up throught the row. 
-- Also, every INSERT and UPDATE query becomes more expensive, since data in both the regular table AND the index have to be dealt with. 

-- The more records in the db at the time of creation, the slower the indexing process will be.
CREATE INDEX index_name ON table_name (column_name); 

-- You can also create a multi-columns index, which is useful if you are constantly queryiny by two fields at once (e.g. first_name and last_name): 
CREATE INDEX index_name ON table_name (column1_name, column2_name); 

DROP INDEX index_name;

-- Just setting up some tools to make our queries faster. 
