-- 1. Create database called «lab2»
CREATE DATABASE lab2;

-- 2. Create a simple table 'countries' including columns
CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(50),
    region_id INTEGER,
    population INTEGER
);

-- 3. Insert a row with any data into the table 'countries'
INSERT INTO countries (country_name, region_id, population)
VALUES ('USA', 1, 228000);

-- 4. Insert one row into the table 'countries' with only country_id and country_name
INSERT INTO countries (country_id, country_name)
VALUES (2, 'Kazakhstan');

-- 5. Insert NULL value to region_id column for a row of 'countries' table
INSERT INTO countries (country_name, region_id, population)
VALUES ('Uganda', NULL, 250000);

-- 6. Insert 3 rows by a single insert statement
INSERT INTO countries (country_name, region_id, population)
VALUES
('France', 2, 670000),
('Germany', 2, 83000),
('Japan', 3, 1200000);

-- 7. Set default value 'Kazakhstan' to 'country_name' column
ALTER TABLE countries
ALTER COLUMN country_name SET DEFAULT 'Kazakhstan';

-- 8. Insert default value to 'country_name' column for a row of 'countries' table
INSERT INTO countries (region_id, population)
VALUES (4, 19000000);

-- 9. Insert only default values against each column of 'countries' table
INSERT INTO countries DEFAULT VALUES;

-- 10. Create duplicate of 'countries' table named 'countries_new' with all structure using LIKE keyword
CREATE TABLE countries_new (LIKE countries INCLUDING ALL);

-- 11. Insert all rows from 'countries' table to 'countries_new' table
INSERT INTO countries_new SELECT * FROM countries;

-- 12. Change region_id of country to '1' if it equals NULL
UPDATE countries
SET region_id = 1
WHERE region_id IS NULL;

-- 13. Write a SQL statement to increase population of each country by 10% and return country_name and updated population
SELECT country_name, population * 1.10 AS "New Population"
FROM countries;

-- 14. Remove all rows from 'countries' table which has less than 100k population
DELETE FROM countries
WHERE population < 100000;

-- 15. Remove all rows from 'countries_new' table if 'country_id' exists in 'countries' table and return deleted data
DELETE FROM countries_new
WHERE country_id IN (SELECT country_id FROM countries)
RETURNING *;

-- 16. Remove all rows from 'countries' table and return deleted data
DELETE FROM countries
RETURNING *;
