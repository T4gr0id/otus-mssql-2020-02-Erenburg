--Домашнее задание SELECT и простые фильтры
-- 1 --
SELECT * FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE [StockItemName] LIKE '%urgent%' OR [StockItemName] LIKE 'Animal%';
------------------------------------------------------------------------
-- 2 --
SELECT t1.suppliername, count(t2.SupplierTransactionID) as QuantityTrans 
FROM Purchasing.Suppliers as t1
LEFT JOIN Purchasing.SupplierTransactions as t2
ON t1.SupplierID = t2.SupplierID group by t1.SupplierName
having count(t2.SupplierTransactionID) = 0
------------------------------------------------------------------------
-- 3 --
-- так и не понял как высчитать треть-----------------------------------
SELECT [OrderDate], 
datename(MONTH,t1.OrderDate) as Месяц, 
datepart(QQ, t1.OrderDate) as Квартал,
t2.UnitPrice as Цена,
t2.Quantity as Количество
FROM [WideWorldImporters].[Sales].[Orders] as t1
left join sales.OrderLines as t2 on t1.OrderID = t2.OrderID
where t2.UnitPrice > 100 or t2.Quantity > 20
order by t1.OrderDate,Квартал ASC
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY
------------------------------------------------------------------------
-- 4 --
select t2.SupplierName, t3.FullName,t4.DeliveryMethodName,  t1.* from Purchasing.SupplierTransactions as t1
left join Purchasing.Suppliers as t2 on t1.SupplierID = t2.SupplierID
left join application.People as t3 on t2.PrimaryContactPersonID = t3.PersonID
left join Application.DeliveryMethods as t4 on t2.DeliveryMethodID = t4.DeliveryMethodID
where  t1.IsFinalized = 1 and (t1.FinalizationDate between '2014-01-01' and '2014-12-31')
and (t4.DeliveryMethodName = 'Road Freight' or t4.DeliveryMethodName = 'Post');
------------------------------------------------------------------------
-- 5 --
SELECT TOP (10) t2.FullName as ClientName,t3.FullName as SalesName, t1.* FROM Sales.Orders as t1
Left join Application.People as t2 on t1.ContactPersonID = t2.PersonID
left join Application.People as t3 on t1.SalespersonPersonID = t3.PersonID
WHERE  t1.OrderDate in (select max(tmp.OrderDate) from Sales.Orders as tmp)
ORDER BY t1.OrderID DESC
------------------------------------------------------------------------
-- 6 --
SELECT t1.ContactPersonID, t3.FullName,t3.PhoneNumber FROM Sales.Orders as t1
left join Sales.OrderLines as t2 on t1.OrderID = t2.OrderID
left join Application.People as t3 on t1.ContactPersonID = t3.PersonID
WHERE t2.Description = 'Chocolate frogs 250g'
------------------------------------------------------------------------