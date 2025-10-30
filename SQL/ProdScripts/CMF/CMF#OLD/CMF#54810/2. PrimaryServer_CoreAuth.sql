-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION
--COMMIT TRANSACTION
--ROLLBACK TRANSACTION

	
UPDATE TOP(1) BSegment_Primary SET SystemStatus = 3, DateOfLastDelinquent = '2021-06-30 23:59:57.000' WHERE acctId IN (22268)





--SELECT DaysDelinquent, DateOfLastDelinquent, SystemStatus, * FROM PROD1GSDB01.ccgs_coreauth.dbo.BSegment_Primary WITH (NOLOCK) WHERE 
--acctId IN (1711602, 16937633)