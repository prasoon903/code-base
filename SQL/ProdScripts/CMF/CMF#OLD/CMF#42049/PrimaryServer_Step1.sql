-- STEP 1

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION

	;WITH DumpData
	AS
	(
		SELECT RANK() OVER(PARTITION BY ScheduleIDOnILP ORDER BY Skey) AS Ranking, Skey,  ScheduleIDOnILP
		FROM ILPScheduledetailsBad_DUMP WITH (NOLOCK)
		WHERE JobStatus = 1
	)
	UPDATE ILP
	SET JobStatus = 7
	FROM ILPScheduledetailsBad_DUMP ILP
	JOIN DumpData DD ON (ILP.Skey = DD.Skey)
	WHERE DD.Ranking > 1

	-- 1 rows

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION
