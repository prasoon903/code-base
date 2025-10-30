-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2020-10-31 23:59:57.000', DaysDelinquent = 22 WHERE acctId IN (1667578)


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (1667578)