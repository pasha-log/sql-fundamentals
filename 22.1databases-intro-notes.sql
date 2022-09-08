# Intro to Databases 

# Define what a database is & give examples
# Describe and visualize a relational database 
# Introduce PostgreSQL 
# Create, list, and drop databases in PostgreSQL 

# Maybe only one person at a company has access to a db. And the only one to change it. 

# People will interchangibly use the term "database" to refer to db server software, the data 
# records themselves, or the physical machine that is holding the data. 

# A typical web stack is a client, server, and database. 

# Client(Frontend) 
# - HTML/JS/CSS, jQuery, React, Angular, Vue, ... and more! 

# Server (Backend) 
# - Flask, Django, Ruby on Rails, Node.js/Express.js, Java Spring, and more! 

# Database(Backend)
# - PostgreSQL, MySQL, SQLite, MongoDB, Cassandra and more! 

######################################################### 

# Database Terminology 

# Two types: relational databases like PostgreSQL. 
# - Model data as rows and columns like in a spreadsheet. Tabular data structures.  

# Movies table, rating table, images. 

# MongoDB is completely different from relational dbs like MySQL and SQLite. 

# They are 90% similar to PostgreSQL

# Key terms include: 
# - RDBMS - Relational Database Management System, e.g. PostgresSQL, MySQL, Oracle 
# Allows us to access the database, in syntax. Querying, storing, deleting dbs. 

# - Schema -  logical representation of a db including its tables

# Movie with multiple genres. We need a different schema. 

# SQL - Structured Query Language, a human-readable language for querying. 

# Table - collection of structured data. Aka "relation" 
# Column - table attr, e.g. "first_name", "last_name", or "company"
# row - table record with values for set for colums, e.g., "Matt, Lane, Rithm" 

############################################################# 

# Visualizing Tables 

# Relational dbs 
# Compressed files that make no sense. 
# But we read them as tables. 

# Movie table, users, ratings. 
# For ratings, it combines info from movies and the users and their ids, associating them with the individual ratings. 
# Movies get ids as well. 

##################################################################### 

# PostgreSQL 
# Relational database using SQL. POwerful, popular, follows SQL standard closely. 
# Open Source RDBMS. 

# Oracle has taken over it, but there is drama about it because things have slowed down a bit. 

################################################## 

# Window Postgres Installation 

$ sudo apt-get install postgresql 
$ sudo service postgresql status # down 
$ sudo service postgresql start # Only do once. 
$ psql # psql: error: FATAL:  role "pasha" does not exist 
$ sudo -u postgres createuser -s $(whoami); createdb $(whoami) 
$ whoami # pasha 
$ psql 
# psql (12.12 (Ubuntu 12.12-0ubuntu0.20.04.1))
# Type "help" for help.

# pasha=#
/q # to get out 

##########################################################

# Basic PSQL Commands  

# Make sure server is running. 
 
psql movies_example # the name of the db 

SELECT * FROM movies; 
# Gets a table from the db 

createdb my_database_name # lower snake case for name of db 

# Where is the db? 
# No db file in the current directory.  
# Not human readable, optimized for speed. 

# Seeding a db: 
# You can feed .sql scripts into the program psql: 
$ psql < my_database.sql 
# This is often used to seed an empty db by building tables, filling in rows, or both. 

# \l - list all dbs 
# \c DB_NAME - connect to DB_NAME or psql DB_NAME 
# \dt - List all tables (in current db) 
# \d TABLE_NAME - Get details about TABLE_NAME (in current db) 
# \q - Quit psql (can also type <Control-D>)

# A db that is "dropped" is completely deleted (schema and data) 
$ dropdb my_database_name

# Backing Up a DB 
# Make a backup of your db by dumping it to a file: 
$ pg_dump -C -c -O my_database_name > backup.sql 
 # This makes a file in the current directory, backup.sql 
 # It contains all of the commands necessary to re-create the current db when seeding. 

 ################################################# 

# SQL intro 

SELECT * FROM people WHERE age > 21 AND id IS NOT NULL; 
-- strings in SQL: 
-- case-sensitive: 'Bob' not same as 'bob' 
-- single-quotes, not double, around strings. 
-- Commands end with a semicolon. Separate individual queries with ; 

-- SQL keywords are conventionally written in ALL IN CAPS but not required. 
SELECT price FROM books same as select price from books  

