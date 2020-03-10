--Домашнее задание SELECT и простые фильтры
-- 1 --
SELECT * FROM [WideWorldImporters].[Warehouse].[StockItems]
WHERE [StockItemName] LIKE '%urgent%' OR [StockItemName] LIKE 'Animal%';
------------------------------------------------------------------------
-- 2 -- вариант без GROUP BY -------------------------------------------
SELECT s.suppliername, st.SupplierTransactionID as QuantityTrans 
FROM Purchasing.Suppliers as s
LEFT JOIN Purchasing.SupplierTransactions as st
ON s.SupplierID = st.SupplierID 
where st.SupplierTransactionID is null
------------------------------------------------------------------------
-- 3 --
-- добавил расчет трети года-----------------------------------
SELECT [OrderDate] as [Дата заказа], 
datename(MONTH,o.OrderDate) as Месяц, 
datepart(QQ, o.OrderDate) as Квартал,
ol.UnitPrice as Цена,
ol.Quantity as Количество,
(datepart(month,o.OrderDate) - 1)/4 + 1 as [Треть года]
FROM [WideWorldImporters].[Sales].[Orders] as o
left join sales.OrderLines as ol on o.OrderID = ol.OrderID
where ol.UnitPrice > 100 or ol.Quantity > 20
order by [Дата заказа],Квартал,[Треть года] ASC
OFFSET 1000 ROWS FETCH NEXT 100 ROWS ONLY
------------------------------------------------------------------------
-- 4 --
select s.SupplierName, p.FullName,dm.DeliveryMethodName,  st.* from Purchasing.SupplierTransactions as st
left join Purchasing.Suppliers as s on st.SupplierID = s.SupplierID
left join application.People as p on s.PrimaryContactPersonID = p.PersonID
left join Application.DeliveryMethods as dm on s.DeliveryMethodID = dm.DeliveryMethodID
where  st.IsFinalized = 1 and (st.FinalizationDate between '2014-01-01' and '2014-12-31')
and (dm.DeliveryMethodName = 'Road Freight' or dm.DeliveryMethodName = 'Post');
------------------------------------------------------------------------
-- 5 -- добавил условие сортировки
SELECT TOP (10) cp.FullName as ClientName,sp.FullName as SalesName, o.* FROM Sales.Orders as o
Left join Application.People as cp on o.ContactPersonID = cp.PersonID
left join Application.People as sp on o.SalespersonPersonID = sp.PersonID
WHERE  o.OrderDate in (select max(tmp.OrderDate) from Sales.Orders as tmp)
ORDER BY o.OrderID DESC,o.OrderDate DESC
------------------------------------------------------------------------
-- 6 --
SELECT o.ContactPersonID, p.FullName,p.PhoneNumber FROM Sales.Orders as o
left join Sales.OrderLines as ol on o.OrderID = ol.OrderID
left join Application.People as p on o.ContactPersonID = p.PersonID
WHERE ol.Description = 'Chocolate frogs 250g'
------------------------------------------------------------------------