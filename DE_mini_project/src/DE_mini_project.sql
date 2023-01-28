USE Northwind;

-- 1.Tulis query untuk mendapatkan jumlah customer tiap bulan yang melakukan order pada tahun 1997.
SELECT 
	Year(OrderDate) as [Year],
	count(CustomerID) as TotalCustomer
FROM Orders
WHERE Year(OrderDate) = '1997'
GROUP BY Year(OrderDate);

-- 2.Tulis query untuk mendapatkan nama employee yang termasuk Sales Representative.
SELECT
	CONCAT(FirstName, ' ', LastName) as FullName,
	Title
FROM Employees
WHERE Title = 'Sales Representative';

-- 3.Tulis query untuk mendapatkan top 5 nama produk yang quantitynya paling banyak diorder pada bulan Januari 1997.
SELECT TOP 5 
	YEAR(OrderDate) as Year,
	MONTH(OrderDate) as Month,
	c.ProductName,
	sum(b.Quantity) as TotalOrders
FROM Orders a left join  
		[Order Details] b ON a.OrderID=b.OrderID left join
		Products c ON b.ProductID=c.ProductID
WHERE YEAR(OrderDate) = '1997' and MONTH(OrderDate)='1'
GROUP BY 	
	YEAR(OrderDate),
	MONTH(OrderDate),
	c.ProductName
ORDER BY TotalOrders DESC;

-- 4.Tulis query untuk mendapatkan nama company yang melakukan order Chai pada bulan Juni 1997.
SELECT
	a.OrderID,
	b.OrderDate,
	c.ProductName,
	d.CompanyName
FROM 
	[Order Details] a left join
	Orders b ON a.OrderID=b.OrderID left join
	Products c on a.ProductID = c.ProductID left join
	Suppliers d on c.SupplierID = d.SupplierID
WHERE
	c.ProductName = 'Chai' and (b.OrderDate >= '1997-06-01' and b.OrderDate < '1997-07-01');

-- 5.Tulis query untuk mendapatkan jumlah OrderID yang pernah melakukan pembelian 
-- (unit_price dikali quantity) <=100, 100<x<=250, 250<x<=500, dan >500.
SELECT 
	case
		when UnitPrice * Quantity <=100 then '<=100'
		when UnitPrice * Quantity <=250 then '100<x<=250'
		when UnitPrice * Quantity <=500 then '250<x<=500'
		else '>500'
	end as TotalBuyBin,
	count(OrderID) as TotalOrder
FROM [Order Details]
GROUP BY 	
	case
		when UnitPrice * Quantity <=100 then '<=100'
		when UnitPrice * Quantity <=250 then '100<x<=250'
		when UnitPrice * Quantity <=500 then '250<x<=500'
		else '>500'
	end
ORDER BY TotalBuyBin;

-- 6.Tulis query untuk mendapatkan Company name pada tabel customer yang melakukan pembelian di atas 500 pada tahun 1997.
SELECT
	d.CompanyName,
	year(b.OrderDate) as Year,
	sum(a.Quantity) as TotalQuantity
FROM 
	[Order Details] a left join
	Orders b ON a.OrderID=b.OrderID left join
	Products c on a.ProductID = c.ProductID left join
	Suppliers d on c.SupplierID = d.SupplierID
WHERE
	(b.OrderDate >= '1997-01-01' and b.OrderDate < '1998-01-01') and
	YEAR(b.OrderDate) = '1997'
GROUP BY d.CompanyName,	year(b.OrderDate)
HAVING sum(a.Quantity) > 500
ORDER by TotalQuantity Desc;

-- 7.Tulis query untuk mendapatkan nama produk yang merupakan Top 5 sales tertinggi tiap bulan di tahun 1997.
SELECT 
	z.*
FROM (
	SELECT
		FORMAT(a.OrderDate, 'yyyy-MM') OrderMonth,
		c.ProductName,
		SUM(b.Quantity * b.UnitPrice) as TotalSales,
		rank() over (PARTITION BY FORMAT(a.OrderDate, 'yyyy MMMM') ORDER BY SUM(b.Quantity * b.UnitPrice) DESC) as Rank
	FROM 
		Orders a left join
		[Order Details] b  ON a.OrderID = b.OrderID left join 
		Products c ON b.ProductID = c.ProductID
	WHERE a.OrderDate >= '1997-01-01' and a.OrderDate < '1998-01-01'
	GROUP BY a.OrderDate, c.ProductName
)z
WHERE z.Rank <= 5
ORDER BY OrderMonth, Rank;

-- 8. Buatlah view untuk melihat Order Details yang berisi OrderID, ProductID, ProductName, UnitPrice, Quantity, Discount, Harga setelah diskon.
CREATE VIEW OrderView 
AS
(SELECT
	a.OrderID,
	c.ProductName,
	a.UnitPrice,
	a.Quantity,
	a.Discount,
	(a.UnitPrice - (a.UnitPrice*a.Discount)) as FinalPrice
FROM
	[Order Details] a left join
	Orders b ON a.OrderID = b.OrderID join
	Products c ON a.ProductID = c.ProductID);

SELECT * FROM Northwind.dbo.OrderView;

-- 9. Buatlah procedure Invoice untuk memanggil CustomerID, CustomerName/company name, OrderID, OrderDate, RequiredDate, ShippedDate jika terdapat inputan CustomerID tertentu.
CREATE PROCEDURE Invoice @CustomerID nchar(5)
AS 
(SELECT
	a.CustomerID,
	a.CompanyName,
	b.OrderID,
	b.OrderDate,
	b.RequiredDate,
	b.ShippedDate 
FROM
	Customers a left join
	Orders b ON a.CustomerID = b.CustomerID
WHERE
	a.CustomerID = @CustomerID
);

EXEC Invoice @CustomerID = 'ALFKI';

