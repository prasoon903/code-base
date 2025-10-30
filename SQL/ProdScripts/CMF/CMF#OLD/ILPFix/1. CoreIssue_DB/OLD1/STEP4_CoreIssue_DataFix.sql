BEGIN TRANSACTION
	
	
	UPDATE ILP
	SET  ILP.JobStatus = 0,  ILP.PlanID = ABS(ILP.PlanID)
	FROM ILPScheduleDetailSummary ILP
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
	WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
	and  TT.Ranking  = 5 AND TT.JobStatus = 0
	-- 1 rows

COMMIT 
--ROLLBACK 