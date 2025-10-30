--USE PARASHAR_CB_CAuth
--USE PARASHAR_CB_CC
--USE PARASHAR_CB_CI
--USE PARASHAR_CB_CL
--USE PARASHAR_CB_CoreApp
--USE PARASHAR_CB_CoreCredit
--USE  PARASHAR_CB_CoreAcquire
--USE  PARASHAR_CB_CoreAcquire_CAUTH
--USE  PARASHAR_CB_CoreAcquire_CL

--SEARCHTABLE 
--SEARCHSP
--SEARCHCOLUMN procdayend

--DROP PROCEDURE SEARCHTABLE

CREATE or Alter PROCEDURE SEARCHTABLE
@TableName VARCHAR(256)
AS
DECLARE @DBName VARCHAR(256)
DECLARE @varSQL VARCHAR(512)
DECLARE @getDBName CURSOR
SET @getDBName = CURSOR FOR
SELECT name
FROM sys.databases where name like '%PARASHAR_CB%'
CREATE TABLE #TmpTable (DBName VARCHAR(256),
SchemaName VARCHAR(256),
TableName VARCHAR(256))
OPEN @getDBName
FETCH NEXT
FROM @getDBName INTO @DBName
WHILE @@FETCH_STATUS = 0
BEGIN
SET @varSQL = 'USE ' + @DBName + ';
INSERT INTO #TmpTable
SELECT '''+ @DBName + ''' AS DBName,
SCHEMA_NAME(schema_id) AS SchemaName,
name AS TableName
FROM sys.tables
WHERE name LIKE ''%' + @TableName + '%'''
EXEC (@varSQL)
FETCH NEXT
FROM @getDBName INTO @DBName
END
CLOSE @getDBName
DEALLOCATE @getDBName
SELECT *
FROM #TmpTable
DROP TABLE #TmpTable
GO




---SEARCHCOLUMN procdayend

CREATE or Alter PROCEDURE searchcolumn
@COLUMNName VARCHAR(256)
AS
DECLARE @DBName VARCHAR(256)
DECLARE @varSQL VARCHAR(512)
DECLARE @getDBName CURSOR
SET @getDBName = CURSOR FOR
SELECT name
FROM sys.databases where name like '%PARASHAR_CB%'
CREATE TABLE #TmpTable (DBName VARCHAR(256),
TableName VARCHAR(256),
ColumnName VARCHAR(256),
DataType VARCHAR(256)
)
OPEN @getDBName
FETCH NEXT
FROM @getDBName INTO @DBName
WHILE @@FETCH_STATUS = 0
BEGIN
SET @varSQL = 'USE ' + @DBName + ';
INSERT INTO #TmpTable
SELECT '''+ @DBName + ''' AS DBName,
T.name AS TableName,
C.name AS ColumnName,
D.name AS DataType
FROM sys.columns C
JOIN sys.tables T ON C.object_id = T.object_id
JOIN sys.types D ON C.user_type_id = D.user_type_id
WHERE C.name LIKE ''%' + @ColumnName + '%'''
EXEC (@varSQL)
FETCH NEXT
FROM @getDBName INTO @DBName
END
CLOSE @getDBName
DEALLOCATE @getDBName
SELECT *
FROM #TmpTable
DROP TABLE #TmpTable
GO



----SEARCHSP

CREATE or Alter PROCEDURE SEARCHSP
@SPName VARCHAR(256)  
AS  
DECLARE @DBName VARCHAR(256)  
DECLARE @varSQL VARCHAR(512)  
DECLARE @getDBName CURSOR  
SET @getDBName = CURSOR FOR  
SELECT name  
FROM sys.databases where name like '%PARASHAR_CB%'  
CREATE TABLE #TmpTable (DBName VARCHAR(256),    
TableName VARCHAR(256))  
OPEN @getDBName  
FETCH NEXT  
FROM @getDBName INTO @DBName  
WHILE @@FETCH_STATUS = 0  
BEGIN  
SET @varSQL = 'USE ' + @DBName + ';  
INSERT INTO #TmpTable  
SELECT '''+ @DBName + ''' AS DBName,   
name AS SP_Name  
FROM sys.procedures  
WHERE name LIKE ''%' + @SPName + '%'''  
EXEC (@varSQL)  
FETCH NEXT  
FROM @getDBName INTO @DBName  
END  
CLOSE @getDBName  
DEALLOCATE @getDBName  
SELECT *  
FROM #TmpTable  
DROP TABLE #TmpTable 