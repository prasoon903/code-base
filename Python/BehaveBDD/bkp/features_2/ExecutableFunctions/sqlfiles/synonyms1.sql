/*This Secipt Will Drop Existting Synonym from DB and create it With DB Name mentioned below
Author : Ritik Yadav 
*/

DECLARE @CAuth_db varchar(40) = 'RitikYadav_CoreAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'RitikYadav_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'RitikYadav_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'RitikYadav_CC' -- Core Collect DB Name
DECLARE @Cm_db varchar(40) = 'RitikYadav_CCredit' -- Core Money DB Name
DECLARE @CApp_db varchar(40) = 'RitikYadav_CApp' -- Core App DB Name
DECLARE @CI_Sec_db varchar(40) = 'RitikYadav_CI_Sec' -- CI Secondary DB Name
--DECLARE @CAcqCAuth_db varchar(40) = 'Satyam_Credit_CoreAcquire_CAuth' -- Core App DB Name
--DECLARE @CAcq_CL_db varchar(40) = 'Satyam_Credit_CoreAcquire_CL' -- Core App DB Name

Declare @SQlSyn VArchar(500) 
DECLARE @Row int 


USE RitikYadav_CoreAuth
SELECT * INTO #TempSyn FROM Sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%' OR base_object_name like '%Clib].%'

UPDATE #TempSyn SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'


UPDATE #TempSyn SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select base_object_name from Sys. synonyms  WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc 

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))


USE RitikYadav_CC
SELECT * INTO #TempSyn1 FROM Sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn1 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn1
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn1 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn1 WHERE Name = (SELECT top 1 Name From #TempSyn1  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn1

Select base_object_name from Sys. synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))

USE RitikYadav_CI
SELECT * INTO #TempSyn2 FROM Sys.synonyms  WHERE SCHEMA_NAME(schema_id) = 'dbo'

UPDATE #TempSyn2 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CI_Sec_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue_Secondary].%'

UPDATE #TempSyn2 SET base_object_name = '[' + @CI_Sec_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI_Sec].%'


UPDATE #TempSyn2 SET base_object_name = '[' + @CI_Sec_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_CI_Secondary].%'


UPDATE #TempSyn2 SET base_object_name = '[' + @CI_Sec_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_CI_new].%'


UPDATE #TempSyn2 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_CI_new].%'


--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn2
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn2 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn2 WHERE Name = (SELECT top 1 Name From #TempSyn2  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn2

Select base_object_name from Sys. synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))

USE RitikYadav_CL
SELECT * INTO #TempSyn3 FROM Sys.synonyms  WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn3 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn3
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn3 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn3 WHERE Name = (SELECT top 1 Name From #TempSyn3  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn3

Select base_object_name from Sys. synonyms Where SCHEMA_NAME(schema_id) = 'dbo'  And base_object_name not LIKE '%LINK_PARITYUSE%'  order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))

USE RitikYadav_CApp
SELECT * INTO #TempSyn4 FROM Sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'


UPDATE #TempSyn4 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Ath].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn4 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn4 WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%'
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn4 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn4 WHERE Name = (SELECT top 1 Name From #TempSyn4  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn4

Select base_object_name from Sys. synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))

USE RitikYadav_CCredit;
SELECT * INTO #TempSyn5 FROM Sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

UPDATE #TempSyn5 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn5 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn5
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn5 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn5 WHERE Name = (SELECT top 1 Name From #TempSyn5  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn5

Select base_object_name from Sys. synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))


USE RitikYadav_CI_Sec;
SELECT * INTO #TempSyn6 FROM Sys.synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

UPDATE #TempSyn6 SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%' or base_object_name like '%CoreIssue].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) 
WHERE base_object_name like '%CC].%' OR base_object_name like '%CoreCollect].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%' OR base_object_name like '%CoreLibrary].%'  OR base_object_name like '%Clib].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coremoney].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%' OR  base_object_name like '%PortalDB].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%portal].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @Cm_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CA].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CApp].%'

UPDATE #TempSyn6 SET base_object_name = '[' + @CApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreApp].%'

--DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn6
print @Row
While(@Row > 0)
BEGIN 
--Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM IF EXISTS '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn6 order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn6 WHERE Name = (SELECT top 1 Name From #TempSyn6  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn6

Select base_object_name from Sys. synonyms WHERE SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not LIKE '%LINK_PARITYUSE%' order by base_object_name desc

SELECT  SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name )), COUNT(1) 
FROM sys.synonyms 
GROUP BY SUBSTRING(base_object_name,0,PATINDEX ( '%.%' , base_object_name ))

go
use RitikYadav_CoreAuth
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' And base_object_name not LIKE '%LINK_PARITYUSE%' 
use RitikYadav_CI
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' and name not like '%cntrlparms%' And base_object_name not LIKE '%LINK_PARITYUSE%'
use RitikYadav_CL
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' And base_object_name not LIKE '%LINK_PARITYUSE%'
use RitikYadav_CC
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' And base_object_name not LIKE '%LINK_PARITYUSE%'
use RitikYadav_CCredit;
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' And base_object_name not LIKE '%LINK_PARITYUSE%'
use RitikYadav_CApp
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' And base_object_name not LIKE '%LINK_PARITYUSE%'
use RitikYadav_CI_Sec
select * from sys.synonyms where SCHEMA_NAME(schema_id) = 'dbo' And base_object_name not like '%Ritik%' and name not like '%cntrlparms%' And base_object_name not LIKE '%LINK_PARITYUSE%'

