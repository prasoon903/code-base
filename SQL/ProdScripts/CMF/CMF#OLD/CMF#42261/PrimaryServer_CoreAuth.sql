-- TO BE RUN ON PRIMARY SERVER ONLY

USE CCGS_CoreAuth
GO

BEGIN TRANSACTION

	UPDATE BSegment_Primary SET SystemStatus = 2, DateOfLastDelinquent = NULL WHERE acctId IN (4175721)
	-- 1 rows

COMMIT TRANSACTION
--ROLLBACK TRANSACTION

--SELECT acctId, SystemStatus, DateOfLastDelinquent, DaysDelinquent 
--FROM BSegment_Primary WITH (NOLOCK) 
--WHERE acctId IN (4175721)