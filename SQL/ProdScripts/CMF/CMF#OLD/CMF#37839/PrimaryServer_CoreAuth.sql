-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreAuth
GO

	UPDATE BSegment_Primary SET SystemStatus = 2 WHERE acctId = 2153560

--COMMIT TRAN
--ROLLBACK TRAN



--SELECT SystemStatus, DaysDelinquent, DateOfLastDelinquent, * FROM CCGS_RPT_CoreAuth..BSegment_Primary WITH (NOLOCK) WHERE acctId IN (2153560)