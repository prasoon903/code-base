-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId = 17962443
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId = 1004246		






/*
SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
acctId IN (17962443, 1004246)
*/