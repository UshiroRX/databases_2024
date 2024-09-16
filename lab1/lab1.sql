CREATE DATABASE lab1;

CREATE TABLE users(
    id SERIAL,
    firstname VARCHAR(50),
    lastname VARCHAR(50)
);

ALTER TABLE users
    ADD COLUMN isadmin SMALLINT;

ALTER TABLE users
    ALTER COLUMN isadmin SET DATA TYPE BOOLEAN;

ALTER TABLE users
    ALTER COLUMN isadmin SET DEFAULT false;

ALTER TABLE users
    ADD CONSTRAINT pk_id PRIMARY KEY (id);

CREATE TABLE tasks(
    id SERIAL,
    name varchar(50),
    user_id INTEGER
);

DROP TABLE tasks;
DROP DATABASE lab1;