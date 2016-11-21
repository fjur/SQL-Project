-- Switch to master to check and delete database
USE master;

if exists (SELECT * FROM sysdatabases WHERE name='Cus_Orders')
BEGIN
	raiserror('Dropping existing Cus_Orders ....', 0, 1);
	DROP DATABASE Cus_Orders;
END
GO

-- CREATE Customer Orders DatabasPRINT '**********';
PRINT '* A1 - Creating Cus_Orders Database *';

CREATE DATABASE Cus_Orders;
GO

--Switch to cus_orders
USE Cus_Orders;

-- Create User Defined Data Types

IF EXISTS (SELECT * from sys.types WHERE name='cusidt')
BEGIN
	raiserror('Dropping existing cusidt ....', 0, 1);
	DROP TYPE cusidt;
END
GO

PRINT '**********';
PRINT '* A2 - Creating User Defined Data Types *';

PRINT '* cusidt User Data Type created *';

CREATE TYPE cusidt FROM char(5) NOT NULL;
GO

PRINT '* orderidt User Data Type created *';

CREATE TYPE orderidt FROM int NOT NULL;
GO

PRINT '* prodidt User Data Type created *';

CREATE TYPE prodidt FROM int NOT NULL;
GO

PRINT '* titleidt User Data Type created *';

CREATE TYPE titleidt FROM char(3) NOT NULL;
GO

PRINT '**********';
PRINT '* A3 - Creating database tables *';

-- Create customers table
PRINT '* Create customers table *';

CREATE TABLE customers
(
	customer_id cusidt,
	name varchar(50) NOT NULL,
	contact_name varchar(30),
	title_id titleidt,
	address varchar(50),
	city varchar(20),
	region varchar(15),
	country_code varchar(10),
	country varchar(15),
	phone varchar(20),
	fax varchar(20)
);
GO

-- Create orders table
PRINT '* Create orders table *';

CREATE TABLE orders
(
	order_id orderidt,
	customer_id cusidt,
	employee_id int NOT NULL,
	shipping_name varchar(50),
	shipping_address varchar(50),
	shipping_city varchar(20),
	shipping_region varchar(15),
	shipping_country_code varchar(10),
	shipping_country varchar(15),
	shipper_id int NOT NULL,
	order_date datetime,
	required_date datetime,
	shipped_date datetime,
	freight_charge money
);
GO

-- Create order_details table
PRINT '* Create order_details table *';

CREATE TABLE order_details
(
	order_id orderidt,
	product_id prodidt,
	quantity int NOT NULL,
	discount float NOT NULL
);
GO

-- Create products table
PRINT '* Create products table *';

CREATE TABLE products
(
	product_id prodidt,
	supplier_id int NOT NULL,
	name varchar(40) NOT NULL,
	alternate_name varchar(40),
	quantity_per_unit varchar(25),
	unit_price money,
	quantity_in_stock int,
	units_on_order int,
	reorder_level int
);
GO

-- Create shippers table
PRINT '* Create shippers table *';

CREATE TABLE shippers
(
	shipper_id int IDENTITY,
	name varchar(20) NOT NULL
);
GO

-- Create suppliers table
PRINT '* Create suppliers table *';

CREATE TABLE suppliers
(
	supplier_id int IDENTITY,
	name varchar(40) NOT NULL,
	address varchar(30),
	city varchar(20),
	province char(2)
);
GO

-- Create titles table
PRINT '* Create titles table *';
CREATE TABLE titles
(
	title_id titleidt,
	description varchar(35) NOT NULL
);
GO

PRINT '**********';
PRINT '* A4 - Creating tables Primary Keys and Foreign Keys *';

PRINT '* Add PK to customers *';

ALTER TABLE customers
ADD PRIMARY KEY (customer_id);
GO


PRINT '* Add PK to shippers *';

ALTER TABLE shippers
ADD PRIMARY KEY (shipper_id);
GO

PRINT '* Add PK to suppliers *';

ALTER TABLE suppliers
ADD PRIMARY KEY (supplier_id);
GO

PRINT '* Add PK to titles *';

ALTER TABLE titles
ADD PRIMARY KEY (title_id);
GO

PRINT '* Add FK to customers *';

ALTER TABLE customers
ADD CONSTRAINT fk_customers_titles
FOREIGN KEY (title_id)
REFERENCES titles
(title_id);
GO

PRINT '* Add PK to orders *';

ALTER TABLE orders
ADD PRIMARY KEY (order_id);
GO

PRINT '* Add PK to products *';

ALTER TABLE products
ADD PRIMARY KEY (product_id);
GO


PRINT '* Add PK to order_details *';

ALTER TABLE order_details
ADD PRIMARY KEY (order_id, product_id);

PRINT '* Add FK to orders *';

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers
(customer_id);
GO

PRINT '* Add FK to orders *';

ALTER TABLE orders
ADD CONSTRAINT fk_orders_shipper
FOREIGN KEY (shipper_id)
REFERENCES shippers
(shipper_id);
GO

PRINT '* Add FK to order_details *';

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_order
FOREIGN KEY (order_id)
references orders
(order_id);
GO

PRINT '* Add FK to order_details *';

ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_product
FOREIGN KEY (product_id)
references products
(product_id);
GO


PRINT '* Add FK to products *';

ALTER TABLE products
ADD CONSTRAINT fk_products_supplier
FOREIGN KEY (supplier_id)
REFERENCES suppliers
(supplier_id);
GO

PRINT '**********';
PRINT '* A5 - Adding constraints to tables *';

PRINT '* default country for customer table *';

ALTER TABLE customers
ADD CONSTRAINT default_customers_country
DEFAULT('Canada') FOR country;
Go

PRINT '* default date for orders table *';

ALTER TABLE orders
ADD CONSTRAINT default_order_date
DEFAULT DATEADD(DAY, 10, GETDATE()) FOR required_date;
GO

PRINT '* check constraint for quantity on order_details table *';

ALTER TABLE order_details
ADD CONSTRAINT check__order_details_quantity
CHECK(quantity >= 1);
GO

PRINT '* check constraint for reorder level on products table *';

ALTER TABLE products
ADD CONSTRAINT check_products_reorder
CHECK (reorder_level >= 1);
GO

PRINT '* check constraint for quantity on products table *';

ALTER TABLE products
ADD CONSTRAINT check_products_quantity
CHECK (quantity_in_stock < 150);
GO

PRINT '* default province for suppliers table *';

ALTER TABLE suppliers
ADD CONSTRAINT default_suppliers_province
DEFAULT ('BC') for province;
GO

USE Cus_Orders;


PRINT '**********';
PRINT '* Inserting Values into database*';

BULK INSERT titles 
FROM 'C:\TextFiles\titles.txt' 
WITH (
               CODEPAGE=1252,                  
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )

BULK INSERT suppliers 
FROM 'C:\TextFiles\suppliers.txt' 
WITH (  
               CODEPAGE=1252,               
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

 
BULK INSERT shippers 
FROM 'C:\TextFiles\shippers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT customers 
FROM 'C:\TextFiles\customers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT products 
FROM 'C:\TextFiles\products.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT order_details 
FROM 'C:\TextFiles\order_details.txt'  
WITH (
               CODEPAGE=1252,              
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

BULK INSERT orders 
FROM 'C:\TextFiles\orders.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )



USE Cus_Orders;

PRINT '**********';
PRINT '* B - SQL Statements *';

PRINT '* B1 *';

SELECT customer_id,
	name,
	city,
	country
FROM customers
ORDER BY customer_id;
GO

PRINT '* B2 *';
ALTER TABLE customers
ADD active bit;
GO

ALTER TABLE customers
ADD CONSTRAINT default_customers_active
DEFAULT 1 for active;
GO

PRINT '* B3 *';

SELECT orders.order_id,
	products.name,
	customers.name,
	'order_date' = CONVERT(char(11),orders.order_date, 0),
	'new_shipped_date' = CONVERT(char(11), DATEADD(DAY, 7, orders.shipped_date), 0),
	'order_cost' = order_details.quantity * products.unit_price
FROM orders
INNER JOIN customers ON customers.customer_id = orders.customer_id
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
WHERE orders.order_date BETWEEN 'January 1 2001' AND 'December 31 2001';
GO

PRINT '* B4 *'

SELECT customers.customer_id,
	customers.name,
	customers.phone,
	orders.order_id,
	orders.order_date,
	orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NULL
ORDER BY customers.name;
GO

PRINT '* B5 *'

SELECT customers.customer_id,
	customers.name,
	customers.city,
	titles.description
FROM customers
INNER JOIN titles ON customers.title_id = titles.title_id
WHERE customers.region IS NULL;
GO

PRINT '* B6 *'

SELECT suppliers.name,
	products.name,
	products.reorder_level,
	products.quantity_in_stock
FROM suppliers
INNER JOIN products ON suppliers.supplier_id = products.supplier_id
WHERE products.reorder_level > products.quantity_in_stock
ORDER BY suppliers.name;
GO

PRINT '* B7 *'

SELECT orders.order_id,
	customers.name,
	customers.contact_name,
	'shipped_date' = CONVERT(char(11), orders.shipped_date, 0),
	'elapsed' = DATEDIFF(year, orders.shipped_date, 'January 01 2008')
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE orders.shipped_date IS NOT NULL
ORDER BY orders.order_id, 'elapsed';
GO

PRINT '* B8 *'

SELECT  'name' = SUBSTRING(name, 1, 1),
	'total' = COUNT(*)
FROM customers
WHERE SUBSTRING(name, 1, 1) != 'S'
GROUP BY SUBSTRING(name, 1, 1)
HAVING COUNT(*) >= 2;
GO

PRINT '* B9 *'

SELECT order_details.order_id,
	order_details.quantity,
	products.product_id,
	products.reorder_level,
	suppliers.supplier_id
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
INNER JOIN suppliers ON suppliers.supplier_id = products.supplier_id
WHERE order_details.quantity > 100
order by order_details.order_id;
GO

PRINT '* B10 *'

SELECT products.product_id,
	products.name,
	products.quantity_per_unit,
	products.unit_price
FROM products
WHERE products.name LIKE '%tofu%'
OR products.name LIKE '%chef%'
ORDER BY products.name;
GO

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

USE Cus_Orders;

PRINT '**********';
PRINT '* D - Stored Procedures and Triggers *';

PRINT '* D1 - sp_customer_list procedure *';

--Create sp_customer_city procedure

CREATE PROCEDURE sp_customer_city
(
	@city varchar(20)
)
AS
	SELECT customer_id,
	name,
	address,
	city,
	phone
	FROM customers
	WHERE city = @city;
GO

--Run the procedure for london

EXECUTE sp_customer_city 'london';
GO

PRINT '* D2 - sp_orders_by_dates *';

--create procedure sp_orders_by_dates

CREATE PROCEDURE sp_orders_by_dates
(
	@start datetime,
	@end datetime
)
AS
	SELECT orders.order_id,
	orders.customer_id,
	customers.name,
	shippers.name,
	orders.shipped_date
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
INNER JOIN shippers ON shippers.shipper_id = orders.shipper_id
WHERE orders.shipped_date BETWEEN @start AND @end;
GO

--Execute procedure for January 1 2003 to June 30 2003.
EXECUTE sp_orders_by_dates '2003/01/01', '2003/06/30';
GO

PRINT '* D3 - sp_product_listing *';

-- Create the procedure sp_product_listing

CREATE PROCEDURE sp_product_listing
(
	@product varchar(40),
	@month varchar(20),
	@year  varchar(20)
)
AS
	SELECT products.name,
	products.unit_price,
	products.quantity_in_stock,
	suppliers.name
	FROM products
	INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
	INNER JOIN order_details ON order_details.product_id = products.product_id
	INNER JOIN orders ON order_details.order_id = orders.order_id
	WHERE products.name LIKE '%'+@product+'%'
	AND DATENAME(MONTH, orders.order_date) = @month
	AND DATENAME(YEAR, orders.order_date) = @year;
GO

--Execute the procecedure for product name Jacke ordered in June 2001

EXECUTE sp_product_listing 'Jack', 'June', '2001';
GO

PRINT '* D4 - tr_delete_orders *';

--Create a trigger to prevent order deletion

CREATE TRIGGER tr_delete_orders
ON orders
INSTEAD OF DELETE
AS
 IF EXISTS (Select * from deleted INNER JOIN order_details ON deleted.order_id = order_details.order_id)
	BEGIN
		PRINT 'Deletion Not Allowed, order exists in order_details table';
		ROLLBACK TRANSACTION
	END
GO

--Test code below, trigger gets hit.

DELETE orders
WHERE order_id=10000;
GO

PRINT '* D5 - tr_check_qty *';

--Create Trigger tr_check_qty

CREATE TRIGGER tr_check_qty
ON order_details
FOR INSERT, UPDATE
AS
	-- IF EXISTS (SELECT quantity FROM inserted INNER JOIN products ON products.product_id = inserted.product_id WHERE products.quantity_in_stock < quantity) --Using Joins
	IF EXISTS (SELECT quantity FROM inserted WHERE product_id IN (SELECT product_id FROM products WHERE products.quantity_in_stock < quantity))
		BEGIN
			PRINT 'Cannot order a higher quantity of a product than we have in stock';
			ROLLBACK TRANSACTION;
		END
GO

-- Test tr_check_qty, it will fail

UPDATE order_details
SET quantity=30
WHERE order_id='10044'
	AND product_id=7;
GO

PRINT '* D6 - sp_del_inactive_cust *';

CREATE PROCEDURE sp_del_inactive_cust
AS
	 IF (SELECT COUNT(customer_id) FROM customers WHERE customer_id NOT IN (SELECT customer_id FROM orders)) > 0
		PRINT 'Deleting inactive customers';
		DELETE FROM customers
		WHERE customer_id NOT IN (SELECT customer_id FROM orders);

GO

-- Execute the procdure

EXECUTE sp_del_inactive_cust;
GO

--Test to see if Paris customer is still there

SELECT * FROM customers WHERE customer_id NOT IN (SELECT customer_id FROM orders);
GO

PRINT '* D7 - sp_employee_information *';

--Create the stored procedure sp_employee_information

CREATE PROCEDURE sp_employee_information
(
	@emp_id int
)
AS
	SELECT *
	 FROM employee 
	 WHERE @emp_id = employee.employee_id;
GO

--Execute to see if procedure works

EXECUTE sp_employee_information '5';
GO

PRINT '* D8 - sp_reorder_qty *';

-- DROP PROCEDURE sp_reorder_qty;

-- Create the stored procedure sp_reorder_qty

CREATE PROCEDURE sp_reorder_qty
(
	@unit int
)
AS
	SELECT products.product_id,
	suppliers.name,
	suppliers.address,
	suppliers.city,
	suppliers.province,
	products.quantity_in_stock,
	products.reorder_level
	FROM products
	INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
	WHERE (products.quantity_in_stock - products.reorder_level) < @unit;
GO

--Execute the stored Procedure

EXECUTE sp_reorder_qty 5;
GO

PRINT '* D9 - sp_unit_price *';

-- DROP PROCEDURE sp_unit_price;

--Create the stored procedure sp_unit_price

CREATE PROCEDURE sp_unit_price
(
	@unit1 money,
	@unit2 money
)
AS
	SELECT product_id,
	name,
	alternate_name,
	unit_price
	FROM products
	WHERE unit_price BETWEEN @unit1 AND @unit2;
GO

--Execute sp_unit_price for values 5 and 10.

EXECUTE sp_unit_price 5.00, 10.00;