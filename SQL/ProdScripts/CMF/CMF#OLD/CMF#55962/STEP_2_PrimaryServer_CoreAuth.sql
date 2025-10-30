-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2021-07-31 23:59:57.000' WHERE acctId = 13592733	
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2021-07-31 23:59:57.000' WHERE acctId = 3230968
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2021-07-31 23:59:57.000' WHERE acctId = 17674647	






/*
SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
acctId IN (13592733, 3230968, 17674647)
*/