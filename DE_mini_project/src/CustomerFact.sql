-- Create CustomerFact
USE Northwind
GO

CREATE VIEW CustomerFact
AS
SELECT
	Customers.CustomerID,
	Customers.ContactName,
	Customers.Address,
	Customers.City,
	Customers.Region,
	Customers.PostalCode,
	Customers.Country,
	Orders.OrderID,
	Orders.OrderDate,
	Orders.ShippedDate,
	Orders.RequiredDate,
	Products.ProductName,
	[Order Details].Quantity,
	[Order Details].UnitPrice,
	[Order Details].Discount,
	SUM([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity) as TotalSales,
	ROUND(SUM(([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity) - 
			([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity * [dbo].[Order Details].Discount)), 2) as FinalSales
FROM
	Customers
LEFT JOIN
	Orders ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN
	[Order Details] ON [Order Details].OrderID = Orders.OrderID
LEFT JOIN
	Products ON [Order Details].ProductID = Products.ProductID
GROUP BY
	Customers.CustomerID,
	Customers.ContactName,
	Customers.Address,
	Customers.City,
	Customers.Region,
	Customers.PostalCode,
	Customers.Country,
	Orders.OrderID,
	Orders.OrderDate,
	Orders.ShippedDate,
	Orders.RequiredDate,
	Products.ProductName,
	[Order Details].Quantity,
	[Order Details].UnitPrice,
	[Order Details].Discount;