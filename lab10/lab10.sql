CREATE DATABASE online_bookstore;

-- Creating Books Table
CREATE TABLE Books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255) ,
    price DECIMAL(10, 2),
    quantity INTEGER
);

-- Creating Customers Table
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

-- Creating Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    book_id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    quantity INTEGER,
    CONSTRAINT fk_book FOREIGN KEY (book_id) REFERENCES Books (book_id) ON DELETE CASCADE,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers (customer_id) ON DELETE CASCADE
);


INSERT INTO Books (book_id, title, author, price, quantity)
VALUES
    (1, 'Database 101', 'A. Smith', 40.00, 10),
    (2, 'Learn SQL', 'B. Johnson', 35.00, 15),
    (3, 'Advanced DB', 'C. Lee', 50.00, 5);

INSERT INTO Customers (customer_id, name, email)
VALUES
    (101, 'John Doe', 'johndoe@example.com'),
    (102, 'Jane Doe', 'janedoe@example.com');


-- 1. Transaction for Placing an Order
BEGIN;
INSERT INTO Orders (book_id, customer_id, order_date, quantity)
VALUES (1, 101, CURRENT_DATE, 2);

UPDATE Books SET quantity = quantity - 2 WHERE book_id = 1;
COMMIT;


-- 2. Transaction with Rollback
CREATE OR REPLACE FUNCTION check_books()
RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT quantity FROM Books WHERE book_id = NEW.book_id) < NEW.quantity THEN
        RAISE EXCEPTION 'Not enough stock for book_id %', NEW.book_id;
    END IF;

    UPDATE Books
    SET quantity = quantity - NEW.quantity
    WHERE book_id = NEW.book_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_check_stock
BEFORE INSERT ON Orders
FOR EACH ROW
EXECUTE FUNCTION check_books();

INSERT INTO Orders (book_id, customer_id, order_date, quantity)
VALUES (1, 101, CURRENT_DATE, 50);

UPDATE Books
SET quantity = quantity - 50
WHERE book_id = 3;

COMMIT;


-- 3. Isolation Level Demonstration.

-- #### SESSION #1 ==================================================
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

UPDATE Books
SET price = 25.00
WHERE title = 'Learn SQL';

COMMIT;
-- #### SESSION #2 ===================================================
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Before commit in first session, second session will read old price 20.00,
-- but after commit in first, it will see new price.
SELECT price FROM Books WHERE title = 'Learn SQL';




-- 4. Durability Check
BEGIN;

UPDATE Customers
SET email = 'bebra@gmail.com'
WHERE name = 'John Doe';

COMMIT;

-- Checking
SELECT * FROM Customers;