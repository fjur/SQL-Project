USE Cus_Orders;

PRINT '**********';
PRINT '* C - INSERT, UPDATE, DELETE and VIEWS STATEMENTS *';

PRINT '* C1 - Create employee table *';

CREATE TABLE employee
(
	employee_id int NOT NULL,
	last_name varchar(30) NOT NULL,
	first_name varchar(15) NOT NULL,
	address varchar(30),
	city varchar(20),
	province char(2),
	postal_code varchar(7),
	phone varchar(10),
	birth_date datetime NOT NULL
);
GO


PRINT '* C2 - Create employee table PK *';

ALTER TABLE employee
ADD PRIMARY KEY (employee_id);
GO

PRINT '* C3 - Create employee table references and updated data *';

--Inserting data into employee table
BULK INSERT employee 
FROM 'C:\TextFiles\employee.txt' 
WITH (         CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )
GO

-- Add FK to orders table
ALTER TABLE orders
ADD CONSTRAINT fk_orders_employee
FOREIGN KEY (employee_id)
REFERENCES employee
(employee_id);
GO

PRINT '* C4 - Insert Quick Express *';

INSERT INTO shippers
VALUES ('Quick Express');
GO

PRINT '* C5 - Update products unit price *';

-- !!! Double check that the between works as expected.
UPDATE products
SET unit_price = unit_price * 1.05
WHERE unit_price BETWEEN 5 AND 10;
GO

PRINT '* C6 - Update fax value *';

UPDATE customers
SET fax = 'Unknown'
WHERE fax IS NULL;
Go

PRINT '* C7 - view vw_order_cost *';

CREATE VIEW vw_order_cost
(
	order_id,
	order_date,
	product_id,
	name,
	order_cost
)
AS
SELECT orders.order_id,
	orders.order_date,
	products.product_id,
	customers.name,
	order_details.quantity * products.unit_price
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN customers on orders.customer_id = customers.customer_id
WHERE orders.order_id BETWEEN 10000 AND 10200;
GO

--Display the view information
SELECT * from vw_order_cost;
GO

PRINT '* C8 - view vw_list_employees *';

--create vw_list_employees

CREATE VIEW vw_list_employees
AS
SELECT *
FROM employee;
GO

--Sql Query to get the employee information

SELECT employee_id,
	'name' = first_name+', '+last_name,
	 'birth_date' = CONVERT(char(10), birth_date, 102)
FROM vw_list_employees
WHERE employee_id IN ('5', '7', '9');
GO

PRINT '* C9 - view vw_list_employees *';

--Create vw_all_orders

CREATE VIEW vw_all_orders
(
	order_id,
	customer_id,
	customer_name,
	city,
	country,
	shipped_date
)
AS
SELECT orders.order_id,
	customers.customer_id,
	customers.name,
	customers.city,
	customers.country,
	orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id;
GO

--Run query for vw_all_orders
--!!! Very last query is not the same as the data shown in notes?

SELECT order_id,
	customer_id,
	customer_name,
	city,
	country,
	'shipped_date' = CONVERT(char(10), shipped_date, 107)
FROM vw_all_orders
WHERE shipped_date BETWEEN 'January 01 2002' AND 'December 31 2002'
ORDER BY customer_name, country;
GO

PRINT '* C10 - view vw_supplier_products *';

-- Create vw_supplier_products view

CREATE VIEW vw_supplier_products
(
	supplier_id,
	supplier_name,
	product_id,
	product_name
)
AS
SELECT suppliers.supplier_id,
	suppliers.name,
	products.product_id,
	products.name
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id
GO

--List all the data from vw_supplier_products 
SELECT *
FROM vw_supplier_products;

