-- STEP 3

USE CCGS_CoreIssue
GO

BEGIN TRANSACTION 

	UPDATE TT  
	SET  
		TT.JobStatus = 7,  
		TT.Counter = TT.Counter + ILP.Counter,  
		ValidationMessage = 'Duplicate or active record already present for this ScheduleID'  
	FROM ILPScheduledetailsBad_DUMP TT  
	JOIN ILPScheduleDetailsBAD ILP WITH (NOLOCK) ON (ILP.ScheduleID = TT.ScheduleIDOnILP)  
	WHERE ILP.JobStatus IN (0, 1) AND TT.JobStatus = 1

	-- 31 rows

COMMIT TRANSACTION
-- ROLLBACK TRANSACTION
