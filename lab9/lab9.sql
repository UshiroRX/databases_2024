--  1. Write a stored procedure named increase_value that takes one
-- integer parameter and returns the parameter value increased by 10
CREATE OR REPLACE FUNCTION increase_value(input_value INT)
RETURNS INT AS $$
BEGIN
    RETURN input_value + 10;
END;
$$ LANGUAGE plpgsql;

-- 2. Create a stored procedure compare_numbers that takes two
-- integers and returns 'Greater', 'Equal', or ‘Lesser' as an out
-- parameter, depending on the comparison result of these two
-- numbers
CREATE OR REPLACE PROCEDURE compare_numbers(
    num1 INT,
    num2 INT,
    OUT result TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF num1 > num2 THEN
        result := 'Greater';
    ELSIF num1 = num2 THEN
        result := 'Equal';
    ELSE
        result := 'Lesser';
    END IF;
END;
$$;

-- 3. Write a stored procedure number_series that takes an integer n
-- and returns a series from 1 to n. Use a looping construct within
-- the procedure.
CREATE OR REPLACE FUNCTION number_series(n INT)
RETURNS SETOF INT AS $$
DECLARE
    i INT;
BEGIN
    FOR i IN 1..n LOOP
        RETURN NEXT i;
    END LOOP;
    RETURN;
END;
$$ LANGUAGE plpgsql;


-- 4. Write a stored procedure find_employee that takes an
-- employee name as a parameter and returns the employee
-- details by performing a query.
CREATE OR REPLACE FUNCTION find_employee(emp_name TEXT)
RETURNS TABLE(employee_id INT, name TEXT, position TEXT, salary NUMERIC, department TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT employee_id, name, position, salary, department
    FROM employees
    WHERE name = emp_name;
END;
$$ LANGUAGE plpgsql;


-- 5. Develop a stored procedure list_products that returns a table
-- with product details from a given category
CREATE OR REPLACE FUNCTION list_products(product_category TEXT)
RETURNS TABLE(product_id INT, product_name TEXT, price NUMERIC, stock INT) AS $$
BEGIN
    RETURN QUERY
    SELECT product_id, product_name, price, stock
    FROM products
    WHERE category = product_category;
END;
$$ LANGUAGE plpgsql;


-- 6. Create two stored procedures where the first procedure calls
-- the second one. For example, a procedure calculate_bonus
-- that calculates a bonus, and another procedure update_salary
-- that uses calculate_bonus to update the salary of an employee.
CREATE OR REPLACE FUNCTION calculate_bonus(emp_id INT)
RETURNS NUMERIC AS $$
DECLARE
    emp_salary NUMERIC;
    bonus NUMERIC;
BEGIN
    SELECT salary INTO emp_salary
    FROM employees
    WHERE employee_id = emp_id;

    bonus := emp_salary * 0.1;

    RETURN bonus;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_salary(emp_id INT)
RETURNS VOID AS $$
DECLARE
    bonus_amount NUMERIC;
    current_salary NUMERIC;
    new_salary NUMERIC;
BEGIN
    SELECT salary INTO current_salary
    FROM employees
    WHERE employee_id = emp_id;

    bonus_amount := calculate_bonus(emp_id);

    new_salary := current_salary + bonus_amount;

    UPDATE employees
    SET salary = new_salary
    WHERE employee_id = emp_id;

    RAISE NOTICE 'Employee ID %: Updated salary to %. Bonus: %', emp_id, new_salary, bonus_amount;
END;
$$ LANGUAGE plpgsql;



-- 7
CREATE OR REPLACE FUNCTION complex_calculation(
    num_input INTEGER,
    str_input VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE
    numeric_result INTEGER;
    string_result VARCHAR;
    final_result VARCHAR;

BEGIN
    <<main_block>>
    BEGIN
        <<numeric_subblock>>
        BEGIN
            numeric_result := num_input * 10;
        END <<numeric_subblock>>;

        <<string_subblock>>
        BEGIN
            string_result := upper(str_input)  '_processed';
        END <<string_subblock>>;

        final_result := string_result  ' with result ' || numeric_result::TEXT;

        RETURN final_result;
    END <<main_block>>;
END;
$$ LANGUAGE plpgsql;