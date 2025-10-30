-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION


UPDATE BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId IN (1240951)	


--2105008



/*
SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * 
FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
acctId IN (883659, 1240951, 1344799, 1378174)
*/