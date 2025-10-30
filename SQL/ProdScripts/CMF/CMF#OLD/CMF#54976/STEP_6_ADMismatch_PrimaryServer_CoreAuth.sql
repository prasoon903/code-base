-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE TOP(1) BSegment_Primary SET SystemStatus = 2 WHERE acctId IN (15709599)	






/*
SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
acctId IN (15709599)
*/