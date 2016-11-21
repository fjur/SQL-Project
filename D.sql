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

PRINT '* D3 - sp_product_listing *';

