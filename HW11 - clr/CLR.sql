sp_configure 'show advanced options', 1
reconfigure
sp_configure 'clr enabled', 1
reconfigure
sp_configure 'clr strict security', 0
reconfigure
ALTER DATABASE WideWorldImporters SET TRUSTWORTHY ON
--���������� dll � ������� SAFE
CREATE ASSEMBLY CLRFunctions FROM 'e:\SplitString.dll'
WITH PERMISSION_SET = SAFE
--������� ������� ��� �������� ������
CREATE FUNCTION [dbo].SplitStringCLR(@text [nvarchar](max), @delimiter [nchar](1))
RETURNS TABLE (
part nvarchar(max),
ID_ODER int
) WITH EXECUTE AS CALLER
AS
EXTERNAL NAME CLRFunctions.UserDefinedFunctions.SplitString

--�������� ������
select * from SplitStringCLR('London,NewYork,Paris,Moscow',',')