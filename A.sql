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