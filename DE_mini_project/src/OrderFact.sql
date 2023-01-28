-- Create Product Fact
USE Northwind

GO

CREATE VIEW OrderFact
AS
SELECT
	Orders.*,
	Products.ProductName,
	Suppliers.CompanyName,
	Categories.CategoryName,
	[dbo].[Order Details].UnitPrice,
	[dbo].[Order Details].Quantity,
	[dbo].[Order Details].Discount,
	SUM([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity) as TotalSales,
	ROUND(SUM(([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity) - 
			([dbo].[Order Details].UnitPrice*[dbo].[Order Details].Quantity * [dbo].[Order Details].Discount)), 2) as FinalSales
FROM 
	Orders left join
	[dbo].[Order Details] ON Orders.OrderID = [Order Details].OrderID left join
	Products ON [dbo].[Order Details].ProductID = Products.ProductID left join
	Suppliers ON Products.ProductID = Suppliers.SupplierID left join
	Categories ON Products.CategoryID = Categories.CategoryID
GROUP BY
	Orders.OrderID,
	Orders.CustomerID,
	Orders.EmployeeID,
	Orders.OrderDate,
	Orders.RequiredDate,
	Orders.ShippedDate,
	Orders.ShipVia,
	Orders.Freight,
	Orders.ShipName,
	Orders.ShipAddress,
	Orders.ShipCity,
	Orders.ShipRegion,
	Orders.ShipPostalCode,
	Orders.ShipCountry,
	Products.ProductName,
	Suppliers.CompanyName,
	Categories.CategoryName,
	[dbo].[Order Details].UnitPrice,
	[dbo].[Order Details].Quantity,
	[dbo].[Order Details].Discount
