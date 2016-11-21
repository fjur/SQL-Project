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