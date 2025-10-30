/*Atul Vishw : This Secipt Will Drop Existting Synonym from DB and create it With DB Name mentioned below*/

--select atid,trantime,priority,count(1) from commontnp with(nolock)
--group by atid,trantime,priority
--order by atid,trantime,priority

--select * from commontnp where atid =60

--select * from ApplicationInputData with(nolock) where InstitutionID =1332
--order by ResponseCreationTime desc

----delete from PARASHAR_CB_ci..commontnp where atid <>60

use PARASHAR_CB_CI
--delete from commontnp where atid <>60
update arsystemhsaccounts set institutionid = null
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'





UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'


UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
----------------
use PARASHAR_CB_CL

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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

use PARASHAR_CB_CoreCredit

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
use PARASHAR_CB_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
use PARASHAR_CB_CoreApp

delete from ExperianUserInformation
delete from ExpRequestSetupInfo

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
use PARASHAR_CB_CAuth



SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
use PARASHAR_CB_CC
SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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
use PARASHAR_CB_CoreApp

SELECT * INTO #TempSyn FROM Sys.synonyms  
--SELECT * FROM #TempSyn


DECLARE @CAuth_db varchar(40) = 'PARASHAR_CB_CAuth' -- Core Auth DB Name
DECLARE @CI_db varchar(40) = 'PARASHAR_CB_CI' -- Core Issue DB Name
DECLARE @CL_db varchar(40) = 'PARASHAR_CB_CL' -- Core Library DB Name
DECLARE @CC_db varchar(40) = 'PARASHAR_CB_CC' -- Core Collect DB Name
DECLARE @CoreCredit_db varchar(40) = 'PARASHAR_CB_CoreCredit' -- Core Collect DB Name
DECLARE @CoreApp_db varchar(40) = 'PARASHAR_CB_CoreApp' -- Core Collect DB Name


UPDATE #TempSyn SET base_object_name = '[' + @CAuth_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%Auth].%'

UPDATE #TempSyn SET base_object_name = '[' + @CI_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CI].%'


UPDATE #TempSyn SET base_object_name = '[' + @CC_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CC].%'

UPDATE #TempSyn SET base_object_name = '[' + @CL_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CL].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CoreCredit].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CCredit].%'
UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
WHERE base_object_name like '%CM].%'

UPDATE #TempSyn SET base_object_name = '[' + @CoreCredit_db + ']'  + SUBSTRING(base_object_name,CHARINDEX(']',base_object_name)+1,LEN(base_object_name))
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