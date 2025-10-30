-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

	
UPDATE TOP(1) BSegment_Primary SET DateOfLastDelinquent = NULL WHERE acctId IN (4959190)




--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM LS_PRODDRGSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (4959190)