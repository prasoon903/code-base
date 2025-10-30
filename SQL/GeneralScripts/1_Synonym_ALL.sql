/**************************************************************************************************************************************
REPLACE 'PP_CI' WITH ACTUAL CoreIssue DATABASE NAME
REPLACE 'PP_CL' WITH ACTUAL CoreLibrary DATABASE NAME
REPLACE 'PP_CC' WITH ACTUAL CoreCollect DATABASE NAME
REPLACE 'PP_CAuth' WITH ACTUAL CoreAuth DATABASE NAME
REPLACE 'PP_CoreAPP' WITH ACTUAL CoreApp DATABASE NAME
REPLACE 'PP_CoreCredit' WITH ACTUAL CoreCredit DATABASE NAME
**************************************************************************************************************************************/
---------------------------------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON


USE PP_CI

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- CoreCredit DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- CoreApp DB Name
DECLARE @CI_secondary varchar(40) = 'PP_CI_Secondary' -- CoreIssue Secondary DB Name

IF EXISTS ( SELECT 1 FROM tempdb.dbo.sysobjects  WHERE ID = OBJECT_ID('tempdb..#TempSyn') )  
DROP TABLE #TempSyn
SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%VVipin].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%' 
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI]].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL]].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreMoney].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CORELIBRARY].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_secondary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_cisec].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_ci_sec].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn
--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------

USE PP_CL

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- Core Collect DB Name

SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreMoney].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END


Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------
USE PP_CC

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- Core Collect DB Name

SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------

USE PP_CoreCredit

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- Core Collect DB Name

SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------
USE PP_CAuth

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- Core Collect DB Name

SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------
USE PP_CoreAPP

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- Core Collect DB Name

SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreMoney].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO
---------------------------------------------------------------------------------------------------------------------------------------


USE PP_CI_Secondary

DECLARE @CAuth_db varchar(40) = 'PP_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_CoreCredit' -- CoreCredit DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_CoreAPP' -- CoreApp DB Name
DECLARE @CI_secondary varchar(40) = 'PP_CI_Secondary' -- CoreIssue Secondary DB Name

IF EXISTS ( SELECT 1 FROM tempdb.dbo.sysobjects  WHERE ID = OBJECT_ID('tempdb..#TempSyn') )  
DROP TABLE #TempSyn
SELECT * INTO #TempSyn FROM Sys.synonyms  

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAuth].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%VVipin].%'
UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAuth].%' 
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CI]].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreIssue].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CLIB].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CL]].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Cm].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreMoney].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CAPP].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CC].%'
UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreCollect].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%Clibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CoreLibrary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%CORELIBRARY].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_secondary].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_cisec].%'
UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name)) WHERE base_object_name like '%_ci_sec].%'

DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
--print @Row
While(@Row > 0)
BEGIN 
	Declare @SQlSyn VArchar(500)
	Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
	--print @SQlSyn
	EXEC (@SQlSyn) 
	DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
	SET @Row =@Row - 1
	--print @Row
END

Drop Table #TempSyn
--Select NAme,base_object_name from Sys.synonyms   order by Name desc 
GO