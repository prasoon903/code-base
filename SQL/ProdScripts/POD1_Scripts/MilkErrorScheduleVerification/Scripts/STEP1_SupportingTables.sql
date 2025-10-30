-- CREATING THE SUPPORTING TABLES

IF NOT EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'##TEMP_ILPScheduleDetailSummary_LastTermDate') AND TYPE = 'U') 
BEGIN

	CREATE TABLE ##TEMP_ILPScheduleDetailSummary_LastTermDate
	(
		Skey DECIMAL(19,0) IDENTITY(1,1) NOT NULL,
		SkeyOnILP DECIMAL(19,0),
		parent02AID INT,
		PlanID INT,
		LastTermDateOld DATETIME,
		LastTermDate DATETIME,
		JobStatus INT DEFAULT 0
	)

	DROP INDEX IF EXISTS IX_TEMP_ILPScheduleDetailSummary_LastTermDate_Skey ON ##TEMP_ILPScheduleDetailSummary_LastTermDate

	CREATE CLUSTERED INDEX IX_TEMP_ILPScheduleDetailSummary_LastTermDate_Skey ON ##TEMP_ILPScheduleDetailSummary_LastTermDate 
	(
		Skey
	) 

	DROP INDEX IF EXISTS IDX_TEMP_ILPScheduleDetailSummary_LastTermDate_JobStatus ON ##TEMP_ILPScheduleDetailSummary_LastTermDate

	CREATE NONCLUSTERED INDEX IDX_TEMP_ILPScheduleDetailSummary_LastTermDate_JobStatus ON ##TEMP_ILPScheduleDetailSummary_LastTermDate
	(
		JobStatus
	)

END

SELECT JobStatus, COUNT(1) 
FROm ##TEMP_ILPScheduleDetailSummary_LastTermDate
GROUP BY JobStatus

--SELECT * INTO  ##ILPScheduleDetailSummary FROM ILPScheduleDetailSummary WITH (NOLOCK)
