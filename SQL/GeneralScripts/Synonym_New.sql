/**************************************************************************************************************************************
REPLACE 'PP_JAZZ_CI' WITH ACTUAL CoreIssue DATABASE NAME
REPLACE 'PP_JAZZ_CI_Secondary' WITH ACTUAL CoreIssue Secondary DATABASE NAME
REPLACE 'PP_JAZZ_CL' WITH ACTUAL CoreLibrary DATABASE NAME
REPLACE 'PP_JAZZ_CC' WITH ACTUAL CoreCollect DATABASE NAME
REPLACE 'PP_JAZZ_CAuth' WITH ACTUAL CoreAuth DATABASE NAME
REPLACE 'PP_JAZZ_CoreApp' WITH ACTUAL CoreApp DATABASE NAME
REPLACE 'PP_JAZZ_CoreCredit' WITH ACTUAL CoreCredit DATABASE NAME
**************************************************************************************************************************************/
---------------------------------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON 

use PP_JAZZ_CI

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn
--select  * from  planinfoforreport 
--select  * from  PlanInfoForAccount
--select  * from  LoyaltyInfoForReport
--select  * from CustomerLoyaltyInfoForReport 

--select InterestDeferPeriod,PaymentDefermentPeriod,* from  cpmaccounts  with(nolock)   select * from ccardlookup  where lutid = 'DeferPeriod'

DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name
DECLARE @CI_secondary varchar(40) = 'PP_JAZZ_CI_Secondary' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_secondary].%'


UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_cisec].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_ci_sec].%'



DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

--Select NAme,base_object_name from Sys.synonyms   order by Name desc 


go
----------------
use PP_JAZZ_CL

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'



UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 

go

use PP_JAZZ_CoreCredit

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'
UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'



DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 


go
use PP_JAZZ_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 



go
use PP_JAZZ_Capp

delete from ExperianUserInformation
delete from ExpRequestSetupInfo

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 
go
use PP_JAZZ_CAuth



SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name



UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 


go
use PP_JAZZ_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CLib].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn

Select NAme,base_object_name from Sys.synonyms   order by Name desc 



go
use PP_JAZZ_Capp

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PP_JAZZ_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PP_JAZZ_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PP_JAZZ_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PP_JAZZ_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PP_JAZZ_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PP_JAZZ_Capp' -- Core Collect DB Name




UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreIssue].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corecollect].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Corelibrary].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreapp].%'

UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Coreauth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_clib].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreApp_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%App].%'


DECLARE @Row int 
SELECT @Row = Count(1) FROM #TempSyn
print @Row
While(@Row > 0)
BEGIN 
Declare @SQlSyn VArchar(500)
Select  top 1 @SQlSyn=  'DROP SYNONYM '+ Name + ' CREATE SYNONYM '+ Name + ' FOR ' +  base_object_name From #TempSyn order by Name desc
print @SQlSyn
EXEC (@SQlSyn) 
DELETE FROM #TempSyn WHERE Name = (SELECT top 1 Name From #TempSyn  order by Name desc )
SET @Row =@Row - 1
print @Row
END


Drop Table #TempSyn


go
USE [PP_JAZZ_CI]
GO

/****** Object:  Synonym [dbo].[SYN_CoreApp_AppDataInput]    Script Date: 9/4/2018 3:24:56 AM ******/
DROP SYNONYM [dbo].[SYN_CoreApp_AppDataInput]
GO

/****** Object:  Synonym [dbo].[SYN_CoreApp_AppDataInput]    Script Date: 9/4/2018 3:24:56 AM ******/
CREATE SYNONYM [dbo].[SYN_CoreApp_AppDataInput] FOR [PP_JAZZ_Capp].[dbo].[ApplicationInputData]
GO


--select * from sys.synonyms  where name like '%accountin%'