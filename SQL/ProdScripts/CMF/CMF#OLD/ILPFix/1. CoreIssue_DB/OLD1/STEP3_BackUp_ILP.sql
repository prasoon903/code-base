USE CCGS_CoreIssue
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_ILPDetails') AND TYPE = 'U') 
BEGIN

	-- TEMP DATA Tables

	DROP TABLE IF EXISTS BKP_ILPScheduleDetailSummary_20201027
	DROP TABLE IF EXISTS BKP_ILPScheduleDetailsRevised_20201027

	SELECT ILP.* 
	INTO BKP_ILPScheduleDetailSummary_202010271
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.PlanID AND TT.ScheduleID = ILP.ScheduleID)
	WHERE TT.JobStatus = 0

	SELECT ILP.* 
	INTO BKP_ILPScheduleDetailsRevised_202010271
	FROM ILPScheduleDetailsRevised ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.acctId AND TT.ScheduleID = ILP.ScheduleID)
	WHERE TT.JobStatus = 0
	
END
ELSE
BEGIN 
	PRINT 'TEMP_ILPDetails table does not exist, please execute the Supporting table script.'
END
