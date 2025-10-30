-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2020-11-30 23:59:57' WHERE acctId IN (2464147)
	


COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (2464147)