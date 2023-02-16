USE AdventureWorks2019
GO

--1. How many products can you find in the Production.Product table?
SELECT COUNT(DISTINCT ProductID) AS TotalProducts FROM Production.Product

--2.  Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
SELECT COUNT(DISTINCT ProductID) FROM Production.Product WHERE ProductSubcategoryID IS NOT NULL

--3.  How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(DISTINCT ProductID)  AS CntPerSubcategory FROM Production.Product GROUP BY ProductSubcategoryID

--4. How many products that do not have a product subcategory.
SELECT COUNT(DISTINCT ProductID) FROM Production.Product WHERE ProductSubcategoryID IS NULL

--5.  Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT SUM(Quantity) AS TotalQnty FROM Production.ProductInventory

--6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, Sum(Quantity) As TotalQnty FROm Production.ProductInventory WHERE LocationID = 40 GROUP BY ProductID HAVING SUM(Quantity) < 100

--7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) AS TotalQnty FROM Production.ProductInventory WHERE LocationID = 40 GROUP BY Shelf, ProductID HAVING SUM(Quantity) < 100

-- 8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(Quantity) AS AverageQnty FROM Production.ProductInventory Where LocationID = 10

-- 9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS AverageQnty FROM Production.ProductInventory GROuP BY ProductID, Shelf

--10.  Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) AS AverageQnty FROM Production.ProductInventory WHERE Shelf <> 'N/A' GROuP BY ProductID, Shelf

--11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT COLOR, CLASS, COUNT(*) AS TheCount, AVG(ListPrice) AS AvgPrice FROM Production.Product WHERE COLOR IS NOT NULL AND CLASS IS NOT NULL GROUP BY COLOR, CLASS

--12. Write a query that lists the country and province names from person.CountryRegion and person.StateProvince tables. Join them and produce a result set similar to the following.
SELECT cr.Name AS Country, sp.Name AS Province  FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name AS Country, sp.Name AS Province  FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')

USE Northwind
GO

-- 14. List all Products that has been sold at least once in last 25 years.
SELECT DISTINCT p.ProductName FROM Products p JOIN (SELECT o.OrderID , YEAR(GETDATE()) - YEAR(o.OrderDate) AS YearsElapsed, od.ProductID FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID) dt ON p.ProductID =  dt.ProductID 
WHERE dt.YearsElapsed <= 25

-- 15. List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 c.PostalCode AS ZipCode, COUNT( DISTINCT o.OrderID) AS TotalOrders 
FROM Orders o 
JOIN Customers c ON o.CustomerID = c.CustomerID 
WHERE c.PostalCode IS NOT NULL 
GROUP BY c.PostalCode
ORDER BY TotalOrders DESC;

-- 16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 dt.PostalCode AS ZipCode, COUNT(DISTINCT dt.OrderID) AS TotalOrders FROM (SELECT c.PostalCode, o.OrderID , YEAR(GETDATE()) - YEAR(o.OrderDate) AS YearsElapsed, od.ProductID 
FROM Orders o 
JOIN [Order Details] od ON o.OrderID = od.OrderID
JOIN Customers c ON o.CustomerID = c.CustomerID) dt WHERE dt.YearsElapsed <= 25 GROUP BY dt.PostalCode ORDER BY TotalOrders DESC;


-- 17. List all city names and number of customers in that city.   
SELECT City, COUNT(DISTINCT CustomerID) AS NumCustomers FROM Customers GROUP BY City

-- 18.  List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(DISTINCT CustomerID) AS NumCustomers FROM Customers GROUP BY City HAVING COUNT(DISTINCT CustomerID) > 2

-- 19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, o.OrderDate FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID WHERE o.OrderDate > CONVERT(DATETIME, '1/1/98')

-- 20. List the names of all customers with most recent order dates
SELECT c.ContactName, MAX(o.OrderDate) AS MostRecentOrderDate FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID GROUP BY c.ContactName

-- 21. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(DISTINCT od.ProductID) AS ProductsBought FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY c.ContactName

--22.  Display the customer ids who bought more than 100 Products with count of products.
SELECT c.CustomerID, COUNT(od.ProductID) AS ProductsBought FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY c.CustomerID HAVING COUNT(od.ProductID) > 100

--23.  List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT su.CompanyName AS SupplierCompanyName, sh.CompanyName AS ShippingCompanyName FROM (SELECT DISTINCT p.SupplierID , o.ShipVia FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID=p.ProductID) dt JOIN Shippers sh ON dt.ShipVia = sh.ShipperID JOIN Suppliers su ON dt.SupplierID = su.SupplierID
ORDER BY dt.SupplierID , dt.ShipVia

--24.  Display the products order each day. Show Order date and Product Name.
SELECT o.OrderDate, p.ProductName FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID JOIN Products p ON od.ProductID= p.ProductID
ORDER BY o.OrderDate 

--25.  Displays pairs of employees who have the same job title.
SELECT dt.* FROM (SELECT e.FirstName + ' ' + e.LastName AS FirstEmployee , em.FirstName + ' ' + em.LastName AS SecondEmployee FROM Employees e JOIN Employees em ON e.title = em.title) dt WHERE dt.FirstEmployee <> dt.SecondEmployee

--26.  Display all the Managers who have more than 2 employees reporting to them.
SELECT dt.ManagerName, COUNT(DISTINCT dt.EmployeeID) AS TotalEmployeesReported FROM (SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS FullName, e.ReportsTo, em.FirstName + ' ' + em.LastName AS ManagerName FROM Employees e LEFT JOIN Employees em ON e.ReportsTo = em.EmployeeID) dt GROUP BY dt.ManagerName
HAVING COUNT(DISTINCT dt.EmployeeID) > 2

--27.  Display the customers and suppliers by city. The results should have the following columns
SELECT City, CompanyName, ContactName, 'Customer' AS Type FROM Customers
UNION ALL
SELECT City, CompanyName, ContactName, 'Supplier' AS Type FROM Suppliers