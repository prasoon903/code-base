
BEGIN TRANSACTION
	
	
	UPDATE ILP
	SET  ILP.JobStatus = 0,  ILP.PlanID = ABS(ILP.PlanID)
	FROM ILPScheduleDetailSummary ILP
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleID)
	WHERE TT.PlanID IN (SELECT PlanID FROM TEMP_ILPDetails WHERE JobStatus = 1)
	and  TT.Ranking  = 12
	-- 1 rows 

	--------------UPDATE ILPScheduleDetailSummary SET ActivityOrder = 5, JobStatus = 0 WHERE ScheduleID = 2826444
	---------------- 1 row

COMMIT 
--ROLLBACK 

