-- QUERY 1

USE TSQLV4;

SELECT Production.Products.productid, Production.Products.productname, Production.Products.supplierid, Production.Suppliers.companyname AS suppliername, Production.Products.unitprice,
	CASE
		WHEN Production.Products.unitprice < 10.00			THEN 'CHEAP'
		WHEN Production.Products.unitprice BETWEEN 10.00 AND 45.00	THEN 'MODERATELY PRICED'
		WHEN Production.Products.unitprice > 45.00			THEN 'EXPENSIVE'
	ELSE 'Unknown'
	END AS pricecategory
FROM Production.Products
	INNER JOIN Production.Suppliers
		ON Production.Products.supplierid = Production.Suppliers.supplierid
ORDER BY Production.Products.unitprice ASC;

-- QUERY 2	

USE TSQLV4;

SELECT supplierid, companyname, city, postalcode, country
FROM Production.Suppliers
WHERE fax IS NOT NULL
AND (country = 'USA' 
	OR country = 'SWEDEN');

-- QUERY 3

USE TSQLV4;

SELECT supplierid, companyname, contactname, phone, contacttitle
FROM Production.Suppliers
WHERE contacttitle LIKE N'%Accounting%';

-- QUERY 4

USE TSQLV4;

SELECT empid, firstname, lastname, title, country
FROM HR.Employees
WHERE title = 'CEO'
OR (titleofcourtesy = 'Ms.'
	OR titleofcourtesy = 'Dr.');

-- QUERY 5

USE TSQLV4;

SELECT custid, companyname, contactname, phone, city, country
FROM Sales.Customers
WHERE contactname LIKE N'%, John'
OR contactname LIKE N'%, Tom';

-- QUERY 6

USE TSQLV4;

SELECT Sales.Orders.orderid, Sales.Customers.custid, Sales.Customers.contactname AS customername, Sales.Customers.contacttitle, Sales.Orders.orderdate, Sales.Orders.requireddate
FROM Sales.Orders
	INNER JOIN Sales.Customers
		ON Sales.Orders.custid = Sales.Customers.custid
WHERE DATEDIFF (day, Sales.Orders.orderdate, Sales.Orders.requireddate) <= 21;

-- QUERY 7

USE TSQLV4;

SELECT DATENAME(weekday, orderdate) AS dayofweek, COUNT(DATENAME(weekday, orderdate)) AS ordersplaced
FROM Sales.Orders
GROUP BY DATENAME(weekday, orderdate);

-- QUERY 8

USE TSQLV4;

SELECT DISTINCT Sales.Customers.custid, Sales.Customers.companyname, MAX(DATEDIFF(week, Sales.Orders.orderdate, Sales.Orders.shippeddate)) AS longestdelay
FROM Sales.Customers
	INNER JOIN Sales.Orders
		ON Sales.Customers.custid = Sales.Orders.custid
GROUP BY Sales.Customers.custid, Sales.Customers.companyname
ORDER BY longestdelay ASC;

-- QUERY 9

USE TSQLV4;

SELECT Sales.OrderDetails.orderid, Sales.OrderDetails.productid, Production.Products.productname, Sales.OrderDetails.unitprice, Sales.OrderDetails.qty, CAST(Sales.OrderDetails.qty AS NUMERIC(8,0)) * CAST(Sales.OrderDetails.unitprice AS NUMERIC(12,2)) AS linecost
FROM Sales.Orders
	INNER JOIN Sales.OrderDetails
		ON Sales.Orders.orderid = Sales.OrderDetails.orderid
	INNER JOIN Production.Products
		ON Sales.OrderDetails.productid = Production.Products.productid
WHERE Sales.Orders.shippeddate >= '2015-08-22'
AND Sales.Orders.shippeddate <= '2015-08-31';

-- QUERY 10

USE TSQLV4;

SELECT Sales.Orders.orderid, Sales.Customers.custid, Sales.Customers.companyname, Sales.Orders.orderdate, ((CAST(Sales.OrderDetails.qty AS NUMERIC(8,0)) * CAST(Sales.OrderDetails.unitprice AS NUMERIC(12,2))) - Sales.OrderDetails.discount) AS totalorderamount
FROM Sales.OrderDetails
	INNER JOIN Sales.Orders
		ON Sales.OrderDetails.orderid = Sales.Orders.orderid
	INNER JOIN Sales.Customers
		ON Sales.Orders.custid = Sales.Customers.custid
WHERE Sales.Orders.orderdate >= '20141101'
AND Sales.Orders.orderdate <= '20141231'
ORDER BY totalorderamount ASC;