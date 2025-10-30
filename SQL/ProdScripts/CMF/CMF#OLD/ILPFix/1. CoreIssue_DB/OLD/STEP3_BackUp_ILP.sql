USE CCGS_CoreIssue
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'dbo.TEMP_ILPDetails') AND TYPE = 'U') 
BEGIN

	-- TEMP DATA Tables

	DROP TABLE IF EXISTS BKP_ILPScheduleDetailSummary_20201022
	DROP TABLE IF EXISTS BKP_ILPScheduleDetailsRevised_20201022

	SELECT ILP.* 
	INTO BKP_ILPScheduleDetailSummary_20201022
	FROM ILPScheduleDetailSummary ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.PlanID AND TT.ScheduleID = ILP.ScheduleID)
	-- 29616 rows

	SELECT ILP.* 
	INTO BKP_ILPScheduleDetailsRevised_20201022
	FROM ILPScheduleDetailsRevised ILP WITH (NOLOCK)
	JOIN TEMP_ILPDetails TT WITH (NOLOCK) ON (TT.PlanID = ILP.acctId AND TT.ScheduleID = ILP.ScheduleID)
	-- 690748 rows
	
END
ELSE
BEGIN 
	PRINT 'TEMP_ILPDetails table does not exist, please execute the Supporting table script.'
END
