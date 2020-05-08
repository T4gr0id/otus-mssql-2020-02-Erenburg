USE [WideWorldImporters]
----------------1------------------------
INSERT INTO [Sales].[Customers]
           ([CustomerName]
           ,[BillToCustomerID]
           ,[CustomerCategoryID]
           ,[BuyingGroupID]
           ,[PrimaryContactPersonID]
           ,[AlternateContactPersonID]
           ,[DeliveryMethodID]
           ,[DeliveryCityID]
           ,[PostalCityID]
           ,[CreditLimit]
           ,[AccountOpenedDate]
           ,[StandardDiscountPercentage]
           ,[IsStatementSent]
           ,[IsOnCreditHold]
           ,[PaymentDays]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[DeliveryRun]
           ,[RunPosition]
           ,[WebsiteURL]
           ,[DeliveryAddressLine1]
           ,[DeliveryAddressLine2]
           ,[DeliveryPostalCode]
           ,[DeliveryLocation]
           ,[PostalAddressLine1]
           ,[PostalAddressLine2]
           ,[PostalPostalCode]
           ,[LastEditedBy])
SELECT [CustomerName] = 'Erenburg Tigran'
      ,[BillToCustomerID]
      ,[CustomerCategoryID]
      ,[BuyingGroupID]
      ,[PrimaryContactPersonID]
      ,[AlternateContactPersonID]
      ,[DeliveryMethodID]
      ,[DeliveryCityID]
      ,[PostalCityID]
      ,[CreditLimit]
      ,[AccountOpenedDate]
      ,[StandardDiscountPercentage]
      ,[IsStatementSent]
      ,[IsOnCreditHold]
      ,[PaymentDays]
      ,[PhoneNumber]
      ,[FaxNumber]
      ,[DeliveryRun]
      ,[RunPosition]
      ,[WebsiteURL]
      ,[DeliveryAddressLine1]
      ,[DeliveryAddressLine2]
      ,[DeliveryPostalCode]
      ,[DeliveryLocation]
      ,[PostalAddressLine1]
      ,[PostalAddressLine2]
      ,[PostalPostalCode]
      ,[LastEditedBy]
  FROM [Sales].[Customers] where [CustomerID] = '1061'
----------------------------2---------------------------
DELETE FROM [Sales].[Customers] where [CustomerID] = '1062'
----------------------------3---------------------------
UPDATE [Sales].[Customers] SET 
[CustomerName] = 'Erenburg Tigran Sarkisovich'
WHERE [CustomerID] = '1062'
----------------------------4---------------------------
--INSERT в MERGE не получается выполнить - выходит вот такая ошибка:
--Сообщение 6522, уровень 16, состояние 1, строка 72
--Произошла ошибка .NET Framework во время выполнения определяемой пользователем подпрограммы или агрегатной функции "geography": 
--System.FormatException: 24114: Недопустимая метка 0xE6100000010C11154F на входе в формате well-known text (WKT). Допустимые метки должны иметь тип POINT, LINESTRING, POLYGON, MULTIPOINT, MULTILINESTRING, MULTIPOLYGON, GEOMETRYCOLLECTION, CIRCULARSTRING, COMPOUNDCURVE, CURVEPOLYGON и FULLGLOBE (только тип данных geography).
--System.FormatException: 
--   в Microsoft.SqlServer.Types.OpenGisTypes.ParseLabel(String input)
--   в Microsoft.SqlServer.Types.WellKnownTextReader.ParseTaggedText(OpenGisType type)
--  в Microsoft.SqlServer.Types.WellKnownTextReader.Read(OpenGisType type, Int32 srid)
--   в Microsoft.SqlServer.Types.SqlGeography.ParseText(OpenGisType type, SqlChars taggedText, Int32 srid)
--  в Microsoft.SqlServer.Types.SqlGeography.GeographyFromText(OpenGisType type, SqlChars taggedText, Int32 srid)
--   в Microsoft.SqlServer.Types.SqlGeography.Parse(SqlString s)
use WideWorldImporters;
Create table #Customers_tmp
([fio] [nvarchar](30) COLLATE database_default NULL);
 Insert into #Customers_tmp([fio]) values ('Erenburg Tigran');
MERGE [Sales].[Customers] as TARGET
USING #Customers_tmp  as SOURCE
ON (TARGET.CustomerName = SOURCE.fio)
WHEN MATCHED 
	THEN UPDATE
		SET TARGET.CustomerName = 'Erenburg Tigran Sarkisovich'
WHEN NOT MATCHED
	THEN INSERT
           ([CustomerName]
           ,[BillToCustomerID]
           ,[CustomerCategoryID]           
           ,[PrimaryContactPersonID]
           ,[DeliveryMethodID]
           ,[DeliveryCityID]
           ,[PostalCityID]
           ,[CreditLimit]
           ,[AccountOpenedDate]
           ,[StandardDiscountPercentage]
           ,[IsStatementSent]
           ,[IsOnCreditHold]
           ,[PaymentDays]
           ,[PhoneNumber]
           ,[FaxNumber]          
           ,[WebsiteURL]
           ,[DeliveryAddressLine1]
           ,[DeliveryAddressLine2]
           ,[DeliveryPostalCode]
           ,[DeliveryLocation]
           ,[PostalAddressLine1]
           ,[PostalAddressLine2]
           ,[PostalPostalCode]
           ,[LastEditedBy])
	VALUES(
	'Erenburg Tigran Sarkisovich',
	'1061',
	'5',	
	'3261',
	'3',
	'19881',
	'19881',
	'1600.00',
	'2016-05-07',
	'0.000',
	'0',
	'0',
	'7',
	'(206) 555-0100',
	'(206) 555-0101',	
	'http://www.microsoft.com/',
	'Shop 12',
	'652 Victoria Lane',
	'90243',
	'0xE6100000010C11154FE2182D4740159ADA087A035FC0',
	'PO Box 8112',
	'Milicaville',
	'90243',
	'1');
---------------------------5------------------------------
use WideWorldImporters;
EXEC sp_configure 'show advanced options', 1;  
GO  
RECONFIGURE;  
GO  
EXEC sp_configure 'xp_cmdshell', 1;  
GO  
RECONFIGURE;  
GO 
	
exec master..xp_cmdshell 'bcp "WideWorldImporters.Sales.InvoiceLines" out  "E:\temp\DB\InvoiceLines.txt" -T -w -t"|" -S DESKTOP-SLQLBH9\OTUS_WWI_CORE';

BULK INSERT [WideWorldImporters].[Sales].[InvoiceLines_BulkDemo]
   FROM "E:\temp\db\InvoiceLines.txt"
   WITH 
	 (
		BATCHSIZE = 1000, 
		DATAFILETYPE = 'widechar',
		FIELDTERMINATOR = '|',
		ROWTERMINATOR ='\n',
		KEEPNULLS,
		TABLOCK        
	  );

