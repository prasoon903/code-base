-- TO BE RUN ON PRIMARY SERVER ONLY
USE CCGS_CoreAuth
GO

	UPDATE BSegment_Primary SET SystemStatus = 2 WHERE acctId = 4680519
	-- 1 row update

--COMMIT TRAN
--ROLLBACK TRAN



--SELECT SystemStatus FROM CCGS_RPT_CoreAuth..BSegment_Primary WITH (NOLOCK) WHERE acctId IN (4680519)