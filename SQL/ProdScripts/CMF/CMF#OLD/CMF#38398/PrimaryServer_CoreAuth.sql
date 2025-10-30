-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreAuth
GO

	UPDATE BSegment_Primary SET DateOfLastDelinquent = '2020-04-30' WHERE acctId = 2625505
	-- 1 rows update

	UPDATE BSegment_Primary SET DateOfLastDelinquent = '2020-02-29' WHERE acctId = 2285575
	-- 1 rows update

	UPDATE BSegment_Primary SET DateOfLastDelinquent = '2020-04-30' WHERE acctId = 557976
	-- 1 rows update

--COMMIT TRAN
--ROLLBACK TRAN



--SELECT acctId, DateOfLastDelinquent, DaysDelinquent FROM CCGS_RPT_CoreAuth..BSegment_Primary WITH (NOLOCK) WHERE acctId IN (2625505, 2285575, 557976)