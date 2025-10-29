use rohit_ci


--select * from cpmaccounts where creditplantype  =16
update arsystemhsaccounts set institutionid = null
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn
--select  * from  planinfoforreport 
--select  * from  PlanInfoForAccount
--select  * from  LoyaltyInfoForReport
--select  * from CustomerLoyaltyInfoForReport 

--select InterestDeferPeriod,PaymentDefermentPeriod,* from  cpmaccounts  with(nolock)   select * from ccardlookup  where lutid = 'DeferPeriod'

DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name
DECLARE @ci_secondary varchar(40) = 'Rohit_ci_secondary' -- Core Collect DB Name



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

UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_secondary].%'


UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_cisec].%'

UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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

Select NAme,base_object_name from Sys.synonyms   order by Name desc 


go
----------------
use Rohit_CL

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name



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

use Rohit_CoreCredit

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name



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
use Rohit_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name



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
use Rohit_Capp

--delete from ExperianUserInformation
--delete from ExpRequestSetupInfo

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name



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
use Rohit_CAuth



SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name



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
use Rohit_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name


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
use Rohit_Capp

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name




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
use Rohit_CI_secondary

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name




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
USE [Rohit_CI]
GO

/****** Object:  Synonym [dbo].[SYN_CoreApp_AppDataInput]    Script Date: 9/4/2018 3:24:56 AM ******/
DROP SYNONYM [dbo].[SYN_CoreApp_AppDataInput]
GO

/****** Object:  Synonym [dbo].[SYN_CoreApp_AppDataInput]    Script Date: 9/4/2018 3:24:56 AM ******/
CREATE SYNONYM [dbo].[SYN_CoreApp_AppDataInput] FOR [Rohit_Capp].[dbo].[ApplicationInputData]
GO



use Rohit_Test_CI

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name
DECLARE @ci_secondary varchar(40) = 'Rohit_test_ci_sec' -- Core Collect DB Name




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

UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_secondary].%'


UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%_cisec].%'

UPDATE #TempSyn SET base_object_name = '[' + @ci_secondary + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
Go
use Rohit_Test_CI_sec

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'Rohit_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'Rohit_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'Rohit_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'Rohit_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'Rohit_Corecredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'Rohit_Capp' -- Core Collect DB Name




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