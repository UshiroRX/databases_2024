CREATE DATABASE lab8;

CREATE TABLE salesman (
    salesman_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    commission DECIMAL(4, 2)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    cust_name VARCHAR(50),
    city VARCHAR(50),
    grade INT,
    salesman_id INT,
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id)
);

CREATE TABLE orders (
    ord_no INT PRIMARY KEY,
    purch_amt DECIMAL(10, 2),
    ord_date DATE,
    customer_id INT,
    salesman_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id)
);


INSERT INTO salesman (salesman_id, name, city, commission) VALUES
(5001, 'James Hoog', 'New York', 0.15),
(5002, 'Nail Knite', 'Paris', 0.13),
(5005, 'Pit Alex', 'London', 0.11),
(5006, 'Mc Lyon', 'Paris', 0.14),
(5003, 'Lauson Hen', NULL, 0.12),
(5007, 'Paul Adam', 'Rome', 0.13);


INSERT INTO customers (customer_id, cust_name, city, grade, salesman_id) VALUES
(3002, 'Nick Rimando', 'New York', 100, 5001),
(3005, 'Graham Zusi', 'California', 200, 5002),
(3001, 'Brad Guzan', 'London', NULL, 5005),
(3004, 'Fabian Johns', 'Paris', 300, 5006),
(3007, 'Brad Davis', 'New York', 200, 5001),
(3009, 'Geoff Camero', 'Berlin', 100, 5003),
(3008, 'Julian Green', 'London', 300, 5002);

INSERT INTO orders (ord_no, purch_amt, ord_date, customer_id, salesman_id) VALUES
(70001, 150.50, '2012-10-05', 3005, 5002),
(70009, 270.65, '2012-09-10', 3001, 5005),
(70002, 65.26, '2012-10-05', 3002, 5001),
(70004, 110.50, '2012-08-17', 3009, 5003),
(70007, 948.50, '2012-09-10', 3005, 5002),
(70005, 2400.60, '2012-07-27', 3007, 5001),
(70008, 5760.00, '2012-09-10', 3002, 5001);


-- 3. Create role named «junior_dev» with login privilege.
CREATE ROLE junior_dev LOGIN;

-- 4.  Create a view for those salesmen belongs to the city New York.
CREATE VIEW salesman_view_new_york
    AS SELECT salesman.salesman_id, salesman.name, salesman.city FROM salesmen
                                                  WHERE city = 'New York';

-- 5. Create a view that shows for each order the salesman and
-- customer by name. Grant all privileges to «junior_dev»
CREATE VIEW order_salesman_customer AS
    SELECT orders.ord_nod, orders.purch_amt, orders.ord_date, salesman.name, customers.cust_name
    FROM orders o
    JOIN salesman s on o.salesman_id = s.salesman_id
    JOIN customers c on o.customer_id = c.customer_id;

GRANT ALL PRIVILEGES ON order_salesman_customer TO junior_dev;

-- 6. Create a view that shows all of the customers who have the
-- highest grade. Grant only select statements to «junior_dev»
CREATE VIEW customer_highest_grade AS
    SELECT * FROM customers
             WHERE grade = (SELECT MAX(grade) FROM customers);

-- 7. Create a view that shows the number of the salesman in each city.
CREATE VIEW salesman_count_by_city AS
SELECT city, COUNT(salesman_id) AS salesman_count
FROM salesman
GROUP BY city;

-- 8. Create a view that shows each salesman with more than one customers.
CREATE VIEW salesman_with_multiple_customers AS
SELECT s.salesman_id, s.name, s.city, s.commission, COUNT(c.customer_id) AS customer_count
FROM salesman s
JOIN customers c ON s.salesman_id = c.salesman_id
GROUP BY s.salesman_id, s.name, s.city, s.commission
HAVING COUNT(c.customer_id) > 1;

-- 9. Create role «intern» and give all privileges of «junior_dev».
CREATE ROLE intern LOGIN ;
GRANT junior_dev to intern;

