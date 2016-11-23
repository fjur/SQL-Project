-- Switch to master to check and delete database
USE master;
-- Check if database exists, if it exists, delete it
if exists (SELECT * FROM sysdatabases WHERE name='Cus_Orders')
BEGIN
	raiserror('Dropping existing Cus_Orders ....', 0, 1);
	DROP DATABASE Cus_Orders;
END
GO

-- CREATE Customer Orders Database
PRINT '**********';
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

-- DROP TYPE cusidt;
-- DROP TYPE prodidt;
-- DROP TYPE orderidt;
-- DROP TYPE titleidt;

PRINT '**********';
PRINT '* A2 - Creating User Defined Data Types *';

PRINT '* cusidt User Data Type created for customers table *';

CREATE TYPE cusidt FROM char(5) NOT NULL;
GO

PRINT '* orderidt User Data Type created for orders table *';

CREATE TYPE orderidt FROM int NOT NULL;
GO

PRINT '* prodidt User Data Type created for products table *';

CREATE TYPE prodidt FROM int NOT NULL;
GO

PRINT '* titleidt User Data Type created for titles table *';

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

--Create the primary key for the customers table on customer_id
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);
GO

PRINT '* Add PK to shippers *';

--Create the primary key for the shippers table on shippers_id
ALTER TABLE shippers
ADD PRIMARY KEY (shipper_id);
GO

PRINT '* Add PK to suppliers *';

--Create the primary key for the suppliers table on supplier_id
ALTER TABLE suppliers
ADD PRIMARY KEY (supplier_id);
GO

PRINT '* Add PK to titles *';

--Create the primary key for the titles table on title_id
ALTER TABLE titles
ADD PRIMARY KEY (title_id);
GO

PRINT '* Add PK to orders *';

--Create the primary key on orders table on order_id
ALTER TABLE orders
ADD PRIMARY KEY (order_id);
GO

PRINT '* Add PK to products *';

--Create the primary key on products table on product_id
ALTER TABLE products
ADD PRIMARY KEY (product_id);
GO

PRINT '* Add PK to order_details *';

--Create the composite primary key on order_details for (order_id, product_id)
ALTER TABLE order_details
ADD PRIMARY KEY (order_id, product_id);
GO

PRINT '* Add FK to customers *';

--Create the foreign key for the customers table on title_id
--References title_id in titles table
ALTER TABLE customers
ADD CONSTRAINT fk_customers_titles
FOREIGN KEY (title_id)
REFERENCES titles
(title_id);
GO

PRINT '* Add FK to orders *';

--Create the foreign key for the orders table on customer_id
--References customer_id in customers table
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customers
(customer_id);
GO

PRINT '* Add FK to orders *';

--Create the foreign key for the orders table on shippers_id
--References shipper_id in shippers table
ALTER TABLE orders
ADD CONSTRAINT fk_orders_shipper
FOREIGN KEY (shipper_id)
REFERENCES shippers
(shipper_id);
GO

PRINT '* Add FK to order_details *';

--Create the foreign key for the order_details table on order_id
--References order_id in orders table
ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_order
FOREIGN KEY (order_id)
references orders
(order_id);
GO

PRINT '* Add FK to order_details *';

--Create the foreign key for the order_details table on product_id
--References product in products table
ALTER TABLE order_details
ADD CONSTRAINT fk_order_details_product
FOREIGN KEY (product_id)
references products
(product_id);
GO

PRINT '* Add FK to products *';

--Create the foreign key for the products table on supplier_id
--References supplier_id in suppliers table
ALTER TABLE products
ADD CONSTRAINT fk_products_supplier
FOREIGN KEY (supplier_id)
REFERENCES suppliers
(supplier_id);
GO

PRINT '**********';
PRINT '* A5 - Adding constraints to tables *';

PRINT '* default country for customer table *';

--Set default country for customers to 'Canada'
ALTER TABLE customers
ADD CONSTRAINT default_customers_country
DEFAULT('Canada') FOR country;
Go

PRINT '* default date for orders table *';

--Set default date to 10 days later for orders required_date
ALTER TABLE orders
ADD CONSTRAINT default_order_date
DEFAULT DATEADD(DAY, 10, GETDATE()) FOR required_date;
GO

PRINT '* create constraint for quantity on order_details table *';

--Create constraint, order_details quantity >= 1
ALTER TABLE order_details
ADD CONSTRAINT check__order_details_quantity
CHECK(quantity >= 1);
GO

PRINT '* create constraint for reorder level on products table *';

--Create constraint products reorder_level >= 1
ALTER TABLE products
ADD CONSTRAINT check_products_reorder
CHECK (reorder_level >= 1);
GO

PRINT '* create constraint for quantity on products table *';

--Create constraint products quantity_in_stock < 150
ALTER TABLE products
ADD CONSTRAINT check_products_quantity
CHECK (quantity_in_stock < 150);
GO

PRINT '* default province for suppliers table *';

--Set default province for suppliers to 'BC'
ALTER TABLE suppliers
ADD CONSTRAINT default_suppliers_province
DEFAULT ('BC') for province;
GO

USE Cus_Orders;


PRINT '**********';
PRINT '* Inserting Values into database *';

PRINT char(13) + '* Inserting Values into titles table *';
--insert values into titles
BULK INSERT titles 
FROM 'C:\TextFiles\titles.txt' 
WITH (
               CODEPAGE=1252,                  
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	 )

PRINT char(13) + '* Inserting Values into suppliers table *';
--insert values into suppliers
BULK INSERT suppliers 
FROM 'C:\TextFiles\suppliers.txt' 
WITH (  
               CODEPAGE=1252,               
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

 PRINT char(13) + '* Inserting Values into shippers table *';
--insert values into shippers
BULK INSERT shippers 
FROM 'C:\TextFiles\shippers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

PRINT char(13) + '* Inserting Values into customers table *';
--insert values into customers
BULK INSERT customers 
FROM 'C:\TextFiles\customers.txt' 
WITH (
               CODEPAGE=1252,            
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

PRINT char(13) + '* Inserting Values into products table *';
--insert values into products
BULK INSERT products 
FROM 'C:\TextFiles\products.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

PRINT char(13) + '* Inserting Values into order_details table *';
--insert values into order_details
BULK INSERT order_details 
FROM 'C:\TextFiles\order_details.txt'  
WITH (
               CODEPAGE=1252,              
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

PRINT char(13) + '* Inserting Values into orders table *';
--insert values into orders
BULK INSERT orders 
FROM 'C:\TextFiles\orders.txt' 
WITH (
               CODEPAGE=1252,             
		DATAFILETYPE = 'char',
		FIELDTERMINATOR = '\t',
		KEEPNULLS,
		ROWTERMINATOR = '\n'	            
	  )

