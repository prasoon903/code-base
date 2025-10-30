-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET DaysDelinquent = 0, DateOfLastDelinquent = NULL WHERE acctId IN (9745940)
	


COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (9745940)