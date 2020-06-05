-- одинарные кавычки
SET QUOTED_IDENTIFIER ON
GO
--создаем новую базу.
CREATE DATABASE Budjet
go
--Выбираем базу для использования
USE Budjet
go

CREATE SCHEMA test

go

--Проверка существования таблицы счетов
IF OBJECT_ID('test.MainAcc','U') IS NOT NULL
	DROP TABLE test.MainAcc;
go
--Таблица счетов
CREATE TABLE test.MainAcc
([AccId] int PRIMARY KEY IDENTITY (1,1),
 [acc] nvarchar(20) NULL,
 [sum] decimal(19,4) NULL,
 [open_date] datetime NULL)

 GO

CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_sum
ON test.MainAcc
(sum)

 go
 --Проверка существования таблицы клиентов - ИПшников
IF OBJECT_ID('test.Clients_ip','U') IS NOT NULL
	DROP TABLE test.Clients_ip;
go
 create table test.Clients_ip
 ([IP_Id] int PRIMARY KEY IDENTITY (1,1),
  [MainAccId] int not null,
  [fio] nvarchar(254) null,
  [inn] nvarchar(12) null,
  [ogrn] nvarchar(13) null,
  CONSTRAINT FK_ClientsIp_MainAccId FOREIGN KEY (MainAccId)
  REFERENCES test.MainAcc(AccId),
  CONSTRAINT CK_ClientsIp_Len CHECK (LEN([inn]) = 12),
  CONSTRAINT CK_ClientsIp_ogrn CHECK (LEN([ogrn]) = 13))

    --Проверка существования таблицы клиентов - организаций
IF OBJECT_ID('test.Clients_ul','U') IS NOT NULL
	DROP TABLE test.Clients_ul;
go

   create table test.Clients_ul
 ([UL_Id] int PRIMARY KEY IDENTITY (1,1),
  [MainAccId] int not null,
  [inn] nvarchar(12) null,
  [kpp] nvarchar(9) null,
  [ogrn] nvarchar(15) null,
  [address] nvarchar(256) null,
  CONSTRAINT FK_ClientsUl_MainAccId FOREIGN KEY (MainAccId)
  REFERENCES test.MainAcc(AccId),
  CONSTRAINT CK_ClientsUl_inn CHECK (LEN([inn]) = 10),
  CONSTRAINT CK_ClientsUl_ogrn CHECK (LEN([ogrn]) = 15))