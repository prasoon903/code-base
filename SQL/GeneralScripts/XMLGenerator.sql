SELECT 
	c.column_id-1, 
	c.name,
    t.name,
	'<COLUMN SOURCE="' + CAST(c.column_id-1 AS VARCHAR) + '" NAME="' + c.name + '" xsi:type="' + t.name + '"/>',
	CASE WHEN t.name = 'char' or t.name = 'varchar' THEN '<FIELD ID="' + CAST(c.column_id-1 AS VARCHAR) + '" xsi:type="CharTerm" TERMINATOR="," MAX_LENGTH="' + cast(c.max_length+c.precision+5 AS varchar) + '" COLLATION="SQL_Latin1_General_CP1_CI_AS"/>'
	ELSE '<FIELD ID="' + CAST(c.column_id-1 AS VARCHAR) + '" xsi:type="CharTerm" TERMINATOR="," MAX_LENGTH="' + cast(c.max_length+c.precision+5 AS varchar) + '"/>'
	END
FROM sys.columns c
JOIN sys.types   t
ON c.user_type_id = t.user_type_id
WHERE c.object_id    = Object_id('dbo.IPMAddendumDetails')
AND c.column_id > 1


SELECT 
	c.column_id-1, 
	c.name,
    t.name,
	'<COLUMN SOURCE="' + CAST(c.column_id-1 AS VARCHAR) + '" NAME="' + c.name + '" xsi:type="' + CASE WHEN t.name = 'char' THEN 'SQLCHAR' WHEN t.name = 'int' THEN 'SQLINT' WHEN t.name = 'datetime' THEN 'SQLDATETIME' WHEN t.name = 'decimal' THEN 'SQLDECIMAL' WHEN t.name = 'float' THEN 'SQLFLT8' WHEN t.name = 'money' THEN 'SQLMONEY' WHEN t.name = 'text' THEN 'SQLTEXT' WHEN t.name = 'varchar' THEN 'SQLVARYCHAR' WHEN t.name = 'tinyint' THEN 'SQLTINYINT' WHEN t.name = 'varbinary' THEN 'SQLVARYBIN' ELSE 'ERROR' END + '"/>',
	CASE WHEN t.name = 'char' or t.name = 'varchar' THEN '<FIELD ID="' + CAST(c.column_id-1 AS VARCHAR) + '" xsi:type="CharTerm" TERMINATOR="," MAX_LENGTH="' + cast(c.max_length+c.precision+5 AS varchar) + '" COLLATION="SQL_Latin1_General_CP1_CI_AS"/>'
	ELSE '<FIELD ID="' + CAST(c.column_id-1 AS VARCHAR) + '" xsi:type="CharTerm" TERMINATOR="," MAX_LENGTH="' + cast(c.max_length+c.precision+5 AS varchar) + '"/>'
	END
FROM sys.columns c
JOIN sys.types   t
ON c.user_type_id = t.user_type_id
WHERE c.object_id    = Object_id('dbo.IPMMAsterInterim')
AND c.column_id > 1
 --AND t.name = 'varbinary'



 SELECT DISTINCT t.name
  FROM sys.columns c
  JOIN sys.types   t
    ON c.user_type_id = t.user_type_id
 WHERE c.object_id    = Object_id('dbo.IPMAddendumDetails')

 
 SELECT DISTINCT t.name
  FROM sys.columns c
  JOIN sys.types   t
    ON c.user_type_id = t.user_type_id
 WHERE c.object_id    = Object_id('dbo.IPMMAsterInterim')


 --COLUMN SOURCE="1" NAME="AcctNumber" xsi:type="SQLVARYCHAR"