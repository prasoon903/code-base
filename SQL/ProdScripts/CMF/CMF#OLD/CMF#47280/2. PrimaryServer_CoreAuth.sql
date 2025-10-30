-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2020-12-31 23:59:57' WHERE acctId IN (13550780)
	UPDATE BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2020-12-31 23:59:57' WHERE acctId IN (8942680)
	UPDATE BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId IN (4866741)


--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (13550780, 8942680, 4866741)