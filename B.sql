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