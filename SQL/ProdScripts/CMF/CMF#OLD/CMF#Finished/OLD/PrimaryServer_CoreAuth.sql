-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreAuth
GO

	UPDATE BSegment_Primary SET SystemStatus = 2 WHERE acctid = 1148046
	-- 1 rows update

	UPDATE BSegment_Primary SET SystemStatus = 2 WHERE acctid = 1150358
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN



--SELECT acctId, DateOfLastDelinquent, DaysDelinquent, SystemStatus FROM CCGS_RPT_CoreAuth..BSegment_Primary WITH (NOLOCK) WHERE acctId IN (1148046, 1150358)